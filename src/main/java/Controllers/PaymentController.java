package Controllers;

import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.AccountDA;
import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.PaymentDAO;
import DAO.UserDA;
import Models.Accounts.Voucher;
import Models.Orders.Order;
import Models.Orders.OrderTransaction;
import Models.Payment;
import Models.Products.product;
import Models.Users.CartItem;
import Models.Users.User;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Cache.Redis;
import mvc.ControllerBase;
import mvc.Http.HttpMethod;
import mvc.Result;

public class PaymentController extends ControllerBase {

    private PaymentDAO paymentDAO = new PaymentDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private CartDAO cartDAO = new CartDAO();
    private UserDA userDA = new UserDA();
    private AccountDA accountDA = new AccountDA();

    @HttpRequest(HttpMethod.GET)
    @ActionAttribute(urlPattern = "processPayment/v2")
    public Result processPayment(int methodId, int voucherId, String paymentInfo, String shippingInfo)
            throws Exception {
        return success("Payment Successfully Processed!");
    }

    @HttpRequest(HttpMethod.POST)
    public Result testingResult(int methodId, int voucherId, String paymentInfo, String shippingInfo)
            throws Exception {
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
}
