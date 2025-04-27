package mvc.Helpers.Mail;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import DAO.OrderDAO;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Orders.Order;
import Models.Orders.OrderTransaction;
import mvc.Helpers.JsonConverter;
import mvc.Helpers.pdf.PdfService;
import mvc.Helpers.pdf.PdfService.PdfOrientation;
import mvc.Helpers.pdf.PdfType;

public class OrderMailService {
    private MailService mailService = new MailService();
    private OrderDAO orderDAO = new OrderDAO();
    private int orderId;
    private File pdfFile;
    private String receipientEmail;
    private String orderRefNo;
    private String receipientName;
    private double totalAmount;


    public OrderMailService(int orderId) {
        this.orderId = orderId;
        Order order = orderDAO.getOrderById(orderId);
        this.pdfFile = null;
        this.receipientEmail = order.getUser().getEmail();
        this.orderRefNo = order.getOrderRefNo();
        this.receipientName = order.getUser().getUsername();
        this.totalAmount = order.getPayment().getTotalPaid();
    }


    public boolean generateOrderPDF() {
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            return false;
        }


        ShippingInformation shippingInfo = null;
        String shippingJson = order.getShippingInfo();
        try {
            shippingInfo = JsonConverter.deserialize(shippingJson, ShippingInformation.class).get(0);
        } catch (Exception e) {
            return false;
        }

        List<OrderTransaction> orderTransactions = null;

        try {
            orderTransactions = orderDAO.getAllOrderTransactionByOrder(order);
            if (orderTransactions != null && !orderTransactions.isEmpty()) {

                StringBuilder rows = new StringBuilder();
                double merchandiseSubtotal = 0;
                double shippingFee = 25.0;
                for (OrderTransaction tx : orderTransactions) {
                    double subtotal = tx.getOrderedProductPrice() * tx.getOrderQuantity();
                    rows.append("<tr>")
                        .append("<td>").append(tx.getProduct().getTitle()).append("</td>")
                        .append("<td>").append(tx.getOrderQuantity()).append("</td>")
                        .append("<td>").append(String.format("%.2f", tx.getOrderedProductPrice())).append("</td>")
                        .append("<td>").append(String.format("%.2f", subtotal)).append("</td>")
                        .append("</tr>");
                        merchandiseSubtotal += tx.getOrderQuantity() * tx.getOrderedProductPrice();
                }
                if (merchandiseSubtotal > 1000) {
                    shippingFee = 0.0;
                }
                double deduction = 0.0;
                double total = merchandiseSubtotal + shippingFee;

                if(order.getPayment().getVoucher() != null) {
                    Voucher voucher = order.getPayment().getVoucher();
                    if (voucher.getType().equals("Percent")) {
                        deduction = (merchandiseSubtotal * voucher.getAmount()) / 100;
                        if (deduction > voucher.getMaxCoverage()) {
                            deduction = voucher.getMaxCoverage();
                        }
                    } else if (voucher.getType().equals("Fixed")) {
                        deduction = voucher.getAmount();
                    }
                    total = merchandiseSubtotal + shippingFee - deduction;
                }

                String addressLine1 = (shippingInfo != null && shippingInfo.getAddressLine1() != null) ? shippingInfo.getAddressLine1() : "";
                String addressLine2 = (shippingInfo != null && shippingInfo.getAddressLine2() != null) ? shippingInfo.getAddressLine2() : "";
                String postCode = (shippingInfo != null && shippingInfo.getPostCode() != null) ? shippingInfo.getPostCode() : "";
                String state = (shippingInfo != null && shippingInfo.getState() != null) ? shippingInfo.getState() : "";
                String phoneNumber = (shippingInfo != null && shippingInfo.getPhoneNumber() != null) ? shippingInfo.getPhoneNumber() : "";
                String receiverName = (shippingInfo != null && shippingInfo.getReceiverName() != null) ? shippingInfo.getReceiverName() : "";

                Map<String, String> values = new HashMap<>();
                values.put("orderRefNo", order.getOrderRefNo());
                values.put("orderDate", order.getOrderDate());
                values.put("orderStatus", order.getStatus().getStatusDesc());
                values.put("transactionRows", rows.toString());
                values.put("userFullName", order.getUser().getUsername());
                values.put("receiverName", receiverName);
                values.put("addressLine1", addressLine1);
                values.put("addressLine2", addressLine2);
                values.put("postCode", postCode);
                values.put("state", state);
                values.put("phoneNumber", phoneNumber);
                values.put("subtotal", String.format("%.2f", merchandiseSubtotal));
                values.put("shippingFee", String.format("%.2f", shippingFee));
                values.put("voucherDeduction", String.format("%.2f", deduction));
                values.put("totalAmount", String.format("%.2f", total));
                values.put("paymentMethod", order.getPayment().getMethod().getMethodDesc());

                PdfService service = new PdfService(PdfType.RECEIPT, values, PdfOrientation.LANDSCAPE);
                File pdf = service.convert();

                if (pdf != null) {
                    this.pdfFile = pdf;
                    return true;
                } else {
                    return false;
                }

            } else {
               return false;
            }
        } catch (Exception e) {
            return false;
        }

    }

    public void send() {

        mailService
                .configure().build()
                .setRecipient(receipientEmail)
                .setSubject("Order Placed - " + orderRefNo)
                .setMailType(MailType.ORDER)
                .setValues("name",
                        receipientName)
                .setValues("amount",
                        String.format("%.2f", totalAmount))
                .setValues("orderRefNo",
                        orderRefNo)
                .attach(pdfFile)
                .send();
    }
}
