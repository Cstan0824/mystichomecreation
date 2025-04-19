package Controllers;

import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.OrderDAO;
import DAO.PaymentDAO;
import Models.Accounts.ShippingInformation;
import Models.Orders.Order;
import Models.Orders.OrderTransaction;
import Models.Payment;
import Models.Products.product;
import Models.Products.productType;
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

    // #region ORDER INFO PAGE
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

        
        request.setAttribute("order", order);
        request.setAttribute("shippingInfo", shippingInfo);
        request.setAttribute("orderTransactions", orderTransactions);

        
        return page();
    }

    // #endregion ORDER INFO PAGE


    // #region PAYMENT
    @SyncCache(channel = "user", message = "from order/addPayment")
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

    @SyncCache(channel = "user", message = "from order/getPayment")
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

    @SyncCache(channel = "user", message = "from order/getPaymentsById")
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
}
