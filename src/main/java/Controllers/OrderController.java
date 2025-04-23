package Controllers;

import java.io.File;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.AccountDA;
import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.PaymentDAO;
import DAO.UserDA;
import DAO.productDAO;
import DTO.OrderDTO;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Orders.Order;
import Models.Orders.OrderStatus;
import Models.Orders.OrderTransaction;
import Models.Payment;
import Models.Products.product;
import Models.Products.productFeedback;
import Models.Products.productType;
import Models.Users.CartItem;
import Models.Users.User;
import jakarta.servlet.annotation.WebServlet;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.Cache.Redis;
import mvc.ControllerBase;
import mvc.Helpers.JsonConverter;
import mvc.Helpers.pdf.PdfService;
import mvc.Helpers.pdf.PdfService.PdfOrientation;
import mvc.Helpers.pdf.PdfType;
import mvc.Http.HttpMethod;
import mvc.Result;



@WebServlet("/Order/*")
public class OrderController extends ControllerBase {
    
    private PaymentDAO paymentDAO = new PaymentDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private CartDAO cartDAO = new CartDAO();
    private UserDA userDA = new UserDA();
    private AccountDA accountDA = new AccountDA();
    private productDAO productDAO = new productDAO();

    // #region ORDER INFO PAGE
    @SyncCache(channel = "Order", message = "from order/orderInfo")
    @ActionAttribute(urlPattern= "orderInfo")
    @HttpRequest(HttpMethod.GET)
    public Result orderInfo(int orderId) throws Exception{
        
        System.out.println("Order Info Page");
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            System.out.println("Order not found");
        }

        ShippingInformation shippingInfo = null;
        String shippingJson = order.getShippingInfo();
        try {
            shippingInfo = JsonConverter.deserialize(shippingJson, ShippingInformation.class).get(0);
        } catch (Exception e) {
            System.out.println("Error deserializing shipping information: " + e.getMessage());
        }

        List<OrderTransaction> orderTransactions = orderDAO.getAllOrderTransactionByOrder(order);

        Map<String, Boolean> feedbackMap = new HashMap<>();
        if (order.getStatus().getId() == 4) {
            feedbackMap = productDAO.getFeedbackMapByOrderId(order.getId());
        }
        
        request.setAttribute("order", order);
        request.setAttribute("shippingInfo", shippingInfo);
        request.setAttribute("orderTransactions", orderTransactions);
        request.setAttribute("feedbackMap", feedbackMap);

        
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result generateReceipt(int orderId) throws Exception {

        System.out.println("Generate Receipt");
        // Return the file path or download link as JSON response
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonResponse = mapper.createObjectNode();
        
        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            ((ObjectNode) jsonResponse).put("pdf_success", false);
            ((ObjectNode) jsonResponse).put("error_msg", "Order not found");
            return json(jsonResponse);
        }

        

        ShippingInformation shippingInfo = null;
        String shippingJson = order.getShippingInfo();
        try {
            shippingInfo = JsonConverter.deserialize(shippingJson, ShippingInformation.class).get(0);
        } catch (Exception e) {
            System.out.println("Error deserializing shipping information: " + e.getMessage());
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
                    ((ObjectNode) jsonResponse).put("pdf_success", true);
                    ((ObjectNode) jsonResponse).put("pdf_path", pdf.getAbsolutePath());
                } else {
                    ((ObjectNode) jsonResponse).put("pdf_success", false);
                    ((ObjectNode) jsonResponse).put("error_msg", "PDF generation failed");
                }

            } else {
                ((ObjectNode) jsonResponse).put("pdf_success", false);
                ((ObjectNode) jsonResponse).put("error_msg", "No transactions found for this order");
                return json(jsonResponse);
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("pdf_success", false);
            ((ObjectNode) jsonResponse).put("error_msg", "Error retrieving order transactions: " + e.getMessage());
            return json(jsonResponse);
        }
            
        return json(jsonResponse);
    }


    // #endregion ORDER INFO PAGE

    // #region STAFFORDER PAGE

    @ActionAttribute(urlPattern = "orders")
    public Result orders() throws Exception {
        List<OrderStatus> status = orderDAO.getAllOrderStatuses();
        request.setAttribute("statuses", status);
        
        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        
        return page();
    }

    @ActionAttribute(urlPattern = "orders/Categories")
    @HttpRequest(HttpMethod.POST)
    public Result getOrderByCategories(String[] selectedStatuses, String sortBy, String keywords) throws Exception {

        System.out.println("Selected Statuses: " + Arrays.toString(selectedStatuses));
        List<Integer> statusIds = selectedStatuses != null ? Arrays.stream(selectedStatuses).map(Integer::parseInt).toList() : new ArrayList<>();

        System.out.println("📦 Status IDs: " + statusIds);

        System.out.println("🔄 Sort by: " + sortBy);

        System.out.println("🔍 Keywords: " + keywords);


        List<Order> filteredOrders = orderDAO.filterOrders(statusIds, sortBy, keywords);
        System.out.println("✅ DAO returned products: " + filteredOrders.size());

        List<OrderDTO> dtos = filteredOrders.stream().map(OrderDTO::new).toList();

        System.out.println("🚀 Returning order DTOs as JSON");

        return json(dtos); // Convert to JSON and return

    }

    @SyncCache(channel = "Order", message = "from order/updateOrderStatus")
    @ActionAttribute(urlPattern = "orders/updateStatus")
    @HttpRequest(HttpMethod.POST)
    public Result updateOrderStatus(int orderId) throws Exception {
        System.out.println("Update Order Status");

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonResponse = mapper.createObjectNode();

        try {
            Order order = orderDAO.getOrderById(orderId);
            if (order != null) {
                LocalDateTime now = LocalDateTime.now();
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                String formattedDateTime = now.format(formatter);
                
                switch (order.getStatus().getId()) {
                    case 3:
                        order.setReceiveDate(formattedDateTime);
                        OrderStatus completedStatus = orderDAO.getOrderStatusById(4);
                        order.setStatus(completedStatus);
                        break;
                    case 2:
                        order.setShipDate(formattedDateTime);
                        OrderStatus shippingStatus = orderDAO.getOrderStatusById(3);
                        order.setStatus(shippingStatus);
                        break;
                    case 1:
                        order.setPackDate(formattedDateTime);
                        OrderStatus packingStatus = orderDAO.getOrderStatusById(2);
                        order.setStatus(packingStatus);
                        break;
                    default:
                        break;
                }

                if(orderDAO.updateOrder(order)){
                    System.out.println("Order status updated successfully");
                    ((ObjectNode) jsonResponse).put("updateStatus_success", true);
                    ((ObjectNode) jsonResponse).put("order_id", order.getId());
                    ((ObjectNode) jsonResponse).put("status_id", order.getStatus().getId());
                } else {
                    System.out.println("Failed to update order status");
                    ((ObjectNode) jsonResponse).put("updateStatus_success", false);
                    ((ObjectNode) jsonResponse).put("error msg", "Failed to update order status");
                }

            } else {
                ((ObjectNode) jsonResponse).put("updateStatus_success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Order not found");
            }

        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("updateStatus_success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }
        return json(jsonResponse);
    }

    @SyncCache(channel = "Order", message = "from order/cancelOrder")
    @ActionAttribute(urlPattern = "orders/cancelOrder")
    @HttpRequest(HttpMethod.POST)
    public Result cancelOrder(int orderId) throws Exception {
        System.out.println("Cancel Order");

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonResponse = mapper.createObjectNode();

        try {
            Order order = orderDAO.getOrderById(orderId);
            if (order != null) {
                OrderStatus cancelledStatus = orderDAO.getOrderStatusById(5);
                order.setStatus(cancelledStatus);

                if(orderDAO.updateOrder(order)){
                    System.out.println("Order cancelled successfully");
                    ((ObjectNode) jsonResponse).put("cancelOrder_success", true);
                    ((ObjectNode) jsonResponse).put("order_id", order.getId());
                    ((ObjectNode) jsonResponse).put("status_id", order.getStatus().getId());
                } else {
                    System.out.println("Failed to cancel order");
                    ((ObjectNode) jsonResponse).put("cancelOrder_success", false);
                    ((ObjectNode) jsonResponse).put("error msg", "Failed to cancel order");
                }

            } else {
                ((ObjectNode) jsonResponse).put("cancelOrder_success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Order not found");
            }

        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("cancelOrder_success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }
        return json(jsonResponse);
    }
    
    // #endregion STAFFORDER PAGE

    // #region CHECKOUT PAGE

    // Process payment
    @SyncCache(channel = "Order", message = "from order/processPayment")
    @HttpRequest(HttpMethod.POST)
    public Result processPayment(int methodId, int voucherId, String paymentInfo, String shippingInfo) throws Exception {
        System.out.println("Process Payment");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();
        JsonNode orderIdJson = mapper.createObjectNode();
    
        final int userId = 1;  // Replace with session-based user retrieval
        final int statusId = 1; // Order status "Pending"
    
        User user = userDA.getUserById(userId);
        List<CartItem> cartItems = cartDAO.getCartItemsByUser(user);
        if (cartItems == null || cartItems.isEmpty()) {
            ((ObjectNode) jsonResponse).put("error", "No items in cart.");
            return json(jsonResponse);
        }

        double subtotal = 0.0;
        double shippingFee = 25.0;
    
        for (CartItem item : cartItems) {
            subtotal += item.getProduct().getPrice() * item.getQuantity();
        }
    
        if (subtotal > 1000) {
            shippingFee = 0.0;
        }
    
        double total = subtotal + shippingFee;
        double deduction = 0.0;
        Voucher voucher = null;
    
        try {
            // Step 1: Validate voucher eligibility only if voucherId is not 0
            if (voucherId > 0) {
                // retrieve eligible voucher
                List<Voucher> eligibleVouchers = accountDA.getAvailableVouchers(user, subtotal);
            
                if (eligibleVouchers != null) {
                    for (Voucher v : eligibleVouchers) {
                        if (v.getId() == voucherId) {
                            voucher = v;
                            break;
                        }
                    }
                }
            
                // if not found in eligible, treat as null
                if (voucher != null) {
                    if (voucher.getType().equals("Percent")) {
                        deduction = (subtotal * voucher.getAmount()) / 100;
                        if (deduction > voucher.getMaxCoverage()) {
                            deduction = voucher.getMaxCoverage();
                        }
                    } else if (voucher.getType().equals("Fixed")) {
                        deduction = voucher.getAmount();
                    }
            
                    total = subtotal + shippingFee - deduction;
                } else {
                    System.out.println("Voucher not eligible or not found. Proceeding without voucher.");
                    voucherId = 0; // treat as no voucher
                }
            }
    
            // Step 2: Create payment
            Payment createdPayment = paymentDAO.createPayment(methodId, voucherId, total, paymentInfo);
    
            if (createdPayment != null) {
                
                System.out.println("Payment Created Successfully");
                ((ObjectNode) jsonResponse).put("payment_success", true);
                ((ObjectNode) jsonResponse).put("payment_id", createdPayment.getId());
                ((ObjectNode) jsonResponse).put("totalPaid", total);
    
                final int paymentId = createdPayment.getId();

                Redis.getSignalHub().publish("Payment", "invalidate feedback cache for payment " + paymentId);
    
                try {
                    // Step 3: Create order
                    Order createdOrder = orderDAO.createOrder(userId, statusId, paymentId, shippingInfo);
    
                    if (createdOrder != null) {
                        System.out.println("Order Created Successfully");
                        ((ObjectNode) jsonResponse).put("order_success", true);
                        ((ObjectNode) jsonResponse).put("order_id", createdOrder.getId());
    
                        final int orderId = createdOrder.getId();
                        Redis.getSignalHub().publish("Payment", "invalidate feedback cache for order " + orderId);
                        ((ObjectNode) orderIdJson).put("orderId", orderId);
                        int itemcount = 0;
    
                        for (CartItem item : cartItems) {
                            product prod = item.getProduct();
                            int quantity = item.getQuantity();
                            String selectedVariation = item.getSelectedVariation();
                            String createdAt = item.getCreatedAt();
                            double orderedProductPrice = prod.getPrice();
    
                            Order order = orderDAO.getOrderById(orderId);
                            OrderTransaction orderTransaction = new OrderTransaction(order, prod, quantity, orderedProductPrice, selectedVariation, createdAt);
                            
                            // Step 4: Create order transaction
                            if (orderDAO.createOrderTransaction(orderTransaction)) {
                                System.out.println("Order Transaction Created Successfully");
                                itemcount++;
    
                                ((ObjectNode) jsonResponse).put("orderTransaction_success", true);
                                ((ObjectNode) jsonResponse).put(("orderTransaction_info_" + itemcount),
                                        (orderTransaction.getOrder().getId() + " " + orderTransaction.getProduct().getTitle()));

                                Redis.getSignalHub().publish("OrderTransaction", "invalidate feedback cache for OrderTransaction " + orderId);

                                if (cartDAO.deleteCartItem(item.getCart(), item.getProduct(), item.getSelectedVariation())) {
                                    System.out.println("Cart Item Deleted Successfully");
                                    Redis.getSignalHub().publish("CartItem", "invalidate feedback cache for CartItem " + item.getCart().getId() + "Product " + item.getProduct().getId());
                                } else {
                                    System.out.println("Cart Item Deletion Failed");
                                }
                            } else {
                                System.out.println("Order Transaction Creation Failed");
                            }
                        }
    
                    } else {
                        System.out.println("Order Creation Failed");
                    }
    
                } catch (Exception e) {
                    ((ObjectNode) jsonResponse).put("order_success", false);
                    ((ObjectNode) jsonResponse).put("error msg", "order creation failed: " + e.getMessage());
                }
    
            } else {
                System.out.println("Payment Creation Failed");
            }
    
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("process_failed", true);
            ((ObjectNode) jsonResponse).put("error", "Unexpected error: " + e.getMessage());
        }

        //return page("orderInfo", "Order", orderIdJson);
        return json(jsonResponse);
    }
    
    // #endregion CHECKOUT PAGE

    // #region PAYMENT
    @SyncCache(channel = "Payment", message = "from order/addPayment")
    @HttpRequest(HttpMethod.POST)
    public Result addPayment(Payment payment) throws Exception {

        //json data format
        /*
            {
                "payment": {
                    "method": { "id": "1" },
                    "paymentInfo": "",
                    "totalPaid": "0"
                }
            }
        */

        System.out.println("Add Payment");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();
        try {
            if (paymentDAO.createPayment(payment)) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("payment_id", payment.getId());
            } 
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }
        return json(jsonResponse);
    }

    @HttpRequest(HttpMethod.POST)
    public Result getPaymentByOrder(Order order) throws Exception{

        
        System.out.println("Get Payment By Order");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            Payment payment = paymentDAO.getPaymentByOrder(order);
            if (payment != null) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("payment_id", payment.getId());
                ((ObjectNode) jsonResponse).put("method_id", payment.getMethod().getId());
                ((ObjectNode) jsonResponse).put("paymentInfo", payment.getPaymentInfo());
                ((ObjectNode) jsonResponse).put("totalPaid", payment.getTotalPaid());

            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Payment not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }

        return json(jsonResponse);


    }

    @HttpRequest(HttpMethod.POST)
    public Result getPaymentById(int id) throws Exception{

        System.out.println("Get Payment By Id");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            Payment payment = paymentDAO.getPaymentById(id);
            if (payment != null) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("payment_id", payment.getId());
                ((ObjectNode) jsonResponse).put("method_id", payment.getMethod().getId());
                ((ObjectNode) jsonResponse).put("paymentInfo", payment.getPaymentInfo());
                ((ObjectNode) jsonResponse).put("totalPaid", payment.getTotalPaid());

            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Payment not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }
        return json(jsonResponse);

    }

    // #endregion PAYMENT

    // #region ORDER
    @SyncCache(channel = "Order", message = "from order/addOrder")
    @HttpRequest(HttpMethod.POST)
    public Result addOrder(Order order) throws Exception {

        //json data format
        /*
            {
                "order": {
                    "user": { "id": "1" },
                    "payment": { "id": "3"},
                    "status": { "id": "1"},
                    "orderDate": "2025-04-15",
                    "orderRefNo": "12345678"
                }
            }   
        */


        System.out.println("Add Order");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            if (orderDAO.createOrder(order)) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("order_id", order.getId());
            } 
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }

        return json(jsonResponse);
    }

    @HttpRequest(HttpMethod.GET)
    public Result getOrder(int id) throws Exception {
    
        System.out.println("Get Order");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            System.out.println("here #1");
            Order order = orderDAO.getOrderById(id);
            if (order != null) {
                System.out.println("here #2");
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("order_id", order.getId());
                ((ObjectNode) jsonResponse).put("user_id", order.getUser().getId());
                ((ObjectNode) jsonResponse).put("payment_id", order.getPayment().getId());
                ((ObjectNode) jsonResponse).put("status_id", order.getStatus().getId());
                ((ObjectNode) jsonResponse).put("shippingInfo", order.getShippingInfo());
                ((ObjectNode) jsonResponse).put("orderDate", order.getOrderDate());
                ((ObjectNode) jsonResponse).put("packDate", order.getPackDate());
                ((ObjectNode) jsonResponse).put("shipDate", order.getShipDate());
                ((ObjectNode) jsonResponse).put("receiveDate", order.getReceiveDate());
                ((ObjectNode) jsonResponse).put("orderRefNo", order.getOrderRefNo());
                System.out.println("here #3");
            } else {
                System.out.println("here #11");
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Order not found");
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }

        return json(jsonResponse);
    }

    @HttpRequest(HttpMethod.POST)
    public Result getAllOrderInfo(int orderId) throws Exception{

        System.out.println("Get All Order Info");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            Order order = orderDAO.getOrderById(orderId);
            if (order != null) {
                ArrayNode orderTransactions = mapper.createArrayNode();
                List<OrderTransaction> orderTransactionList = orderDAO.getAllOrderTransactionByOrder(order);

                ((ObjectNode) jsonResponse).put("getOrder_success", true);
                ((ObjectNode) jsonResponse).put("order_id", order.getId());

                if(orderTransactionList != null) {
                    for (OrderTransaction orderTransaction : orderTransactionList) {
                        ObjectNode orderTransactionJson = mapper.createObjectNode();
                        String prodJson = JsonConverter.serialize(orderTransaction.getProduct());
                        orderTransactionJson.put("productJson", prodJson);
                        orderTransactionJson.put("quantity", orderTransaction.getOrderQuantity());
                        orderTransactionJson.put("orderedProductPrice", orderTransaction.getOrderedProductPrice());
                        orderTransactionJson.put("selectedVariations", orderTransaction.getSelectedVariations());
                        orderTransactions.add(orderTransactionJson);
                    }
                }
                ((ObjectNode) jsonResponse).set("orderTransactions", orderTransactions);
            
                String userJson = JsonConverter.serialize(order.getUser());
                ((ObjectNode) jsonResponse).put("userJson", userJson);
                String paymentJson = JsonConverter.serialize(order.getPayment());
                ((ObjectNode) jsonResponse).put("paymentJson", paymentJson);
                String statusJson = JsonConverter.serialize(order.getStatus());
                ((ObjectNode) jsonResponse).put("statusJson", statusJson);

                ((ObjectNode) jsonResponse).put("shippingInfoJson", order.getShippingInfo());
                ((ObjectNode) jsonResponse).put("orderDate", order.getOrderDate());
                ((ObjectNode) jsonResponse).put("packDate", order.getPackDate());
                ((ObjectNode) jsonResponse).put("shipDate", order.getShipDate());
                ((ObjectNode) jsonResponse).put("receiveDate", order.getReceiveDate());
                ((ObjectNode) jsonResponse).put("orderRefNo", order.getOrderRefNo());

            } else {
                ((ObjectNode) jsonResponse).put("getOrder_success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Order not found");
            }
           
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("getOrder_success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }

        return json(jsonResponse);

    }

    @HttpRequest(HttpMethod.POST)
    public Result getOrdersByUser(User user) throws Exception {
    
        System.out.println("Get Orders By User");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            List<Order> orders = orderDAO.getOrdersByUser(user);
            if (orders != null) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("orders", orders.size());
                for (Order order : orders) {
                    ((ObjectNode) jsonResponse).put("order_id", order.getId());
                    ((ObjectNode) jsonResponse).put("user_id", order.getUser().getId());
                    ((ObjectNode) jsonResponse).put("payment_id", order.getPayment().getId());
                    ((ObjectNode) jsonResponse).put("status_id", order.getStatus().getId());
                    ((ObjectNode) jsonResponse).put("shippingInfo", order.getShippingInfo());
                    ((ObjectNode) jsonResponse).put("orderDate", order.getOrderDate());
                    ((ObjectNode) jsonResponse).put("packDate", order.getPackDate());
                    ((ObjectNode) jsonResponse).put("shipDate", order.getShipDate());
                    ((ObjectNode) jsonResponse).put("receiveDate", order.getReceiveDate());
                    ((ObjectNode) jsonResponse).put("orderRefNo", order.getOrderRefNo());

                }
            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Orders not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }

        return json(jsonResponse);
    }

    // #endregion ORDER

    // #region ORDER TRANSACTION
    @SyncCache(channel = "OrderTransaction", message = "from order/addOrderTransaction")
    @HttpRequest(HttpMethod.POST)
    public Result addOrderTransaction(OrderTransaction orderTransaction) throws Exception{

        System.out.println("Add Order Transaction");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            if (orderDAO.createOrderTransaction(orderTransaction)) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("orderTransaction_info", orderTransaction.getOrder().getId() + " " + orderTransaction.getProduct().getTitle());
                
            } 
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }
        return json(jsonResponse);


    }

    @HttpRequest(HttpMethod.POST)
    public Result getOrderTransaction(Order order, product product) throws Exception{

        System.out.println("Get Order Transaction By Order and Product");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            OrderTransaction orderTransaction = orderDAO.getOrderTransactionByOrderAndProduct(order, product);
            if (orderTransaction != null) {
                product prod = orderTransaction.getProduct();
                productType type = prod.getTypeId(); // LAZY fetch happens here if still attached
                

                ((ObjectNode) jsonResponse).put("order_id", orderTransaction.getOrder().getId());
                ((ObjectNode) jsonResponse).put("product_id", prod.getId());
                ((ObjectNode) jsonResponse).put("quantity", orderTransaction.getOrderQuantity());
                ((ObjectNode) jsonResponse).put("orderedProductPrice", orderTransaction.getOrderedProductPrice());
                ((ObjectNode) jsonResponse).put("selectedVariations", orderTransaction.getSelectedVariations());
                ((ObjectNode) jsonResponse).put("product_type", type.gettype());


            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Order Transaction not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }

        return json(jsonResponse);



    }

    @HttpRequest(HttpMethod.POST)
    public Result getOrderTransaction(Order order) throws Exception{

        System.out.println("Get Order Transaction By Order");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            List<OrderTransaction> orderTransactions = orderDAO.getAllOrderTransactionByOrder(order);
            if (orderTransactions != null) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("orderTransaction", orderTransactions.size());
                for (OrderTransaction orderTransaction : orderTransactions) {
                    product prod = orderTransaction.getProduct();

                    ((ObjectNode) jsonResponse).put("order_id", orderTransaction.getOrder().getId());
                    ((ObjectNode) jsonResponse).put("product_id", prod.getId());
                    ((ObjectNode) jsonResponse).put("quantity", orderTransaction.getOrderQuantity());
                    ((ObjectNode) jsonResponse).put("orderedProductPrice", orderTransaction.getOrderedProductPrice());
                    ((ObjectNode) jsonResponse).put("selectedVariations", orderTransaction.getSelectedVariations());

                }
            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Order Transaction not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        
        }

        return json(jsonResponse);
    }

    // #endregion ORDER TRANSACTION

    // #region ORDER FEEDBACK

    @SyncCache(channel = "Product_Feedback", message = "from order/addOrderFeedback")
    @HttpRequest(HttpMethod.POST)
    public Result addOrderFeedback(int orderId, int productId, String selectedVariation, String comment, int rating) throws Exception {

        System.out.println("Add Order Feedback");

        System.out.println("#api SelectedVariation: " + selectedVariation);
        System.out.println("#api OrderId: " + orderId);
        System.out.println("#api ProductId: " + productId);

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonResponse = mapper.createObjectNode();

        Order order = orderDAO.getOrderById(orderId);
        product product = productDAO.searchProducts(productId);

        System.out.println("#api2 SelectedVariation: " + selectedVariation);

        if (order == null) {
            System.out.println("#api Order not found");
        } else {
            System.out.println("#api Order found: " + order.getId());
        }
        if (product == null) {
            System.out.println("#api Product not found");
        } else {
            System.out.println("#api Product found: " + product.getId());
        }

        if (order == null || product == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("error_msg", "Order or Product not found.");
            return json(jsonResponse);
        }

        // ✅ Only allow feedback if order is completed (assuming status ID 4 = completed)
        if (order.getStatus() == null || order.getStatus().getId() != 4) {
            jsonResponse.put("success", false);
            jsonResponse.put("error_msg", "Order not completed yet.");
            return json(jsonResponse);
        }

        // ✅ Get the exact OrderTransaction (based on variation)
        OrderTransaction targetTxn = orderDAO.getOrderTransactionByOrderAndProductAndVariation(order, product, selectedVariation);

        if (targetTxn == null) {
            jsonResponse.put("success", false);
            jsonResponse.put("error_msg", "Unable to locate order transaction for this product and variation.");
            return json(jsonResponse);
        }

        // ✅ Create and populate the feedback object
        productFeedback orderFeedback = new productFeedback();
        orderFeedback.setOrder(order);
        orderFeedback.setProduct(product);
        orderFeedback.setOrderId(orderId);
        orderFeedback.setProductId(productId);
        orderFeedback.setCreatedAt(targetTxn.getCreatedAt());
        orderFeedback.setFeedbackDate(Date.valueOf(LocalDate.now()));
        orderFeedback.setComment(comment);
        orderFeedback.setRating(rating);

        try {
            boolean isAdded = productDAO.addProductFeedback(orderFeedback);
            if (isAdded) {
                Redis.getSignalHub().publish("Order", "invalidate feedback cache for order " + orderId);
                jsonResponse.put("success", true);
                jsonResponse.put("orderFeedback_info", orderFeedback.getOrder().getId() + " " + orderFeedback.getProduct().getTitle());
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("error_msg", "Failed to add feedback.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("error_msg", e.getMessage());
        }

        return json(jsonResponse);
    }




    // #endregion ORDER FEEDBACK
}
