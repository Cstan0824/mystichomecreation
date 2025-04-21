package Controllers;

import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.AccountDA;
import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.PaymentDAO;
import DAO.UserDA;
import DAO.productDAO;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Orders.Order;
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
import mvc.ControllerBase;
import mvc.Helpers.JsonConverter;
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

        Map<Integer, Boolean> feedbackMap = new HashMap<>();
        if (order.getStatus().getId() == 4) {
            feedbackMap = productDAO.getFeedbackMapByOrderId(order.getId());
        }
        
        request.setAttribute("order", order);
        request.setAttribute("shippingInfo", shippingInfo);
        request.setAttribute("orderTransactions", orderTransactions);
        request.setAttribute("feedbackMap", feedbackMap);

        
        return page();
    }

    // #endregion ORDER INFO PAGE

    // #region CHECKOUT PAGE

    // Process payment
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
    
                try {
                    // Step 3: Create order
                    Order createdOrder = orderDAO.createOrder(userId, statusId, paymentId, shippingInfo);
    
                    if (createdOrder != null) {
                        System.out.println("Order Created Successfully");
                        ((ObjectNode) jsonResponse).put("order_success", true);
                        ((ObjectNode) jsonResponse).put("order_id", createdOrder.getId());
    
                        final int orderId = createdOrder.getId();
                        ((ObjectNode) orderIdJson).put("orderId", orderId);
                        int itemcount = 0;
    
                        for (CartItem item : cartItems) {
                            product prod = item.getProduct();
                            int quantity = item.getQuantity();
                            String selectedVariation = item.getSelectedVariation();
                            double orderedProductPrice = prod.getPrice();
    
                            Order order = orderDAO.getOrderById(orderId);
                            OrderTransaction orderTransaction = new OrderTransaction(order, prod, quantity, orderedProductPrice, selectedVariation);
                            
                            // Step 4: Create order transaction
                            if (orderDAO.createOrderTransaction(orderTransaction)) {
                                System.out.println("Order Transaction Created Successfully");
                                itemcount++;
    
                                ((ObjectNode) jsonResponse).put("orderTransaction_success", true);
                                ((ObjectNode) jsonResponse).put(("orderTransaction_info_" + itemcount),
                                        (orderTransaction.getOrder().getId() + " " + orderTransaction.getProduct().getTitle()));
    
                                if (cartDAO.deleteCartItem(item.getCart(), item.getProduct())) {
                                    System.out.println("Cart Item Deleted Successfully");
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
    @SyncCache(channel = "user", message = "from order/addOrder")
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

    @SyncCache(channel = "user", message = "from order/getOrder")
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

    @SyncCache(channel = "user", message = "from order/getOrdersByUser")
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

    @SyncCache(channel = "user", message = "from order/getOrderTransaction")
    @HttpRequest(HttpMethod.POST)
    public Result getTransactionByOrderAndProduct(Order order, product product) throws Exception{

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

    @SyncCache(channel = "user", message = "from order/getOrderTransactionByOrder")
    @HttpRequest(HttpMethod.POST)
    public Result getOrderTransactionByOrder(Order order) throws Exception{

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

    @SyncCache(channel = "ProductFeedback", message = "from order/addOrderFeedback")
    @HttpRequest(HttpMethod.POST)
    public Result addOrderFeedback(int orderId, int productId, String comment, int rating) throws Exception {

        System.out.println("Add Order Feedback");

        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonResponse = mapper.createObjectNode();

        Order order = orderDAO.getOrderById(orderId);
        product product = productDAO.searchProducts(productId);

        productFeedback orderFeedback = new productFeedback();

        Date feedbackDate = Date.valueOf(LocalDate.now());
        orderFeedback.setFeedbackDate(feedbackDate);
        orderFeedback.setOrder(order);
        orderFeedback.setProduct(product);
        orderFeedback.setComment(comment);
        orderFeedback.setRating(rating);
        orderFeedback.setOrderId(orderId);
        orderFeedback.setProductId(productId);


        // Only allow feedback if order is completed
        if (order.getStatus() == null || order.getStatus().getId() != 4) {
            jsonResponse.put("success", false);
            jsonResponse.put("error_msg", "Order not completed yet");
            return json(jsonResponse);
        }

        try {
            boolean isAdded = productDAO.addProductFeedback(orderFeedback);
            if (isAdded) {
                jsonResponse.put("success", true);
                jsonResponse.put("orderFeedback_info", orderFeedback.getOrder().getId() + " " + orderFeedback.getProduct().getTitle());
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("error_msg", "Failed to add feedback.");
            }
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("error_msg", e.getMessage());
        }

        return json(jsonResponse); // ✅ Add final return
    }



    // #endregion ORDER FEEDBACK
}
