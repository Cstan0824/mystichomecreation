package DAO;

import java.time.LocalDate;
import java.util.List;

import Models.Orders.Order;
import Models.Orders.OrderStatus;
import Models.Orders.OrderTransaction;
import Models.Payment;
import Models.Products.product;
import Models.Users.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.DataAccess;

public class OrderDAO {
    
    EntityManager db = DataAccess.getEntityManager();
    Redis cache = new Redis();

    public OrderDAO() {
    }
    // #region ORDER
    // Create a new order in the database
    public boolean createOrder(Order order) {
        try {
            db.getTransaction().begin();
            db.persist(order);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    public Order createOrder(int userId, int statusId, int paymentId, String shippingInfo){

        try {
            db.getTransaction().begin();
            // get user object
            User user = db.find(User.class, userId);
            // get status object
            OrderStatus status = db.find(OrderStatus.class, statusId);
            // get payment object
            Payment payment = db.find(Payment.class, paymentId);
            // create order object
            Order order = new Order(user, payment, status, shippingInfo);

            db.persist(order);
            db.getTransaction().commit();

            return order;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return null;
        }


    }

    // Read an order by ID from the database
    public Order getOrderById(int id) {
        Order order = null;
        TypedQuery<Order> query = db.createQuery("SELECT o FROM Order o WHERE id=:id", Order.class)
                .setParameter("id", id);
        try {
            order = cache.getOrCreate("order-" + id, Order.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            e.printStackTrace(System.err);
            order = db.find(Order.class, id);
        }
        return order;
    }

    // Get all orders from the database
    public List<Order> getAllOrders() {
        List<Order> orders = null;
        TypedQuery<Order> query = db.createQuery("SELECT o FROM Order o", Order.class);
        try {
            orders = cache.getOrCreateList("orders", Order.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orders = db.createQuery("SELECT o FROM Order o", Order.class).getResultList();
        }
        return orders;
    }

    // Get all orders by user ID from the database
    public List<Order> getOrdersByUser(User user) {
        List<Order> orders = null;
        int userId = user.getId();
        TypedQuery<Order> query = db.createQuery("SELECT o FROM Order o WHERE o.user.id=:userId", Order.class)
                .setParameter("userId", userId);
        try {
            orders = cache.getOrCreateList("orders-user-" + userId, Order.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orders = query.getResultList();
        }
        return orders;
    }

    // Get all orders by status from the database
    public List<Order> getOrdersByStatus(OrderStatus status) {
        List<Order> orders = null;
        int statusId = status.getId();
        TypedQuery<Order> query = db.createQuery("SELECT o FROM Order o WHERE o.status.id=:statusId", Order.class)
                .setParameter("statusId", statusId);
        try {
            orders = cache.getOrCreateList("orders-status-" + statusId, Order.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orders = query.getResultList();
        }
        return orders;
    }

    public List<Order> getOrdersByUserAndStatus(User user, OrderStatus status) {
        List<Order> orders = null;
        int userId = user.getId();
        int statusId = status.getId();
        TypedQuery<Order> query = db.createQuery("SELECT o FROM Order o WHERE o.user.id=:userId AND o.status.id=:statusId", Order.class)
                .setParameter("userId", userId)
                .setParameter("statusId", statusId);
        try {
            orders = cache.getOrCreateList("orders-user-" + userId + "-status-" + statusId, Order.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orders = query.getResultList();
        }
        return orders;
    }

    public Order getOrderByPayment(Payment payment) {
        Order order = null;
        int paymentId = payment.getId();
        TypedQuery<Order> query = db.createQuery("SELECT o FROM Order o WHERE o.payment.id=:paymentId", Order.class)
                .setParameter("paymentId", paymentId);
        try {
            order = cache.getOrCreate("order-payment-" + paymentId, Order.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            order = db.find(Order.class, paymentId);
        }
        return order;
    }

    public List<Order> getOrderByDate(LocalDate date){
        List<Order> orders = null;
        TypedQuery<Order> query = db.createQuery("SELECT o FROM Order o WHERE o.orderDate=:date", Order.class)
                .setParameter("date", date);
        try {
            orders = cache.getOrCreateList("orders-date-" + date, Order.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orders = query.getResultList();
        }
        return orders;
    }

    // Update an order in the database
    public boolean updateOrder(Order order) {
        try {
            db.getTransaction().begin();
            db.merge(order);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Delete an order from the database
    public boolean deleteOrder(int id) {
        try {
            db.getTransaction().begin();
            Order order = db.find(Order.class, id);
            if (order != null) {
                db.remove(order);
            }
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // #endregion END ORDER

    // #region ORDER TRANSACTION
    public boolean createOrderTransaction(OrderTransaction orderTransaction) {
        try {
            db.getTransaction().begin();
    
            // ✅ Find and attach the existing Order
            if (orderTransaction.getOrder() != null && orderTransaction.getOrder().getId() > 0) {
                Order managedOrder = db.find(Order.class, orderTransaction.getOrder().getId());
                orderTransaction.setOrder(managedOrder);
            }
    
            // ✅ Find and attach the existing Product
            if (orderTransaction.getProduct() != null && orderTransaction.getProduct().getId() > 0) {
                product managedProduct = db.find(product.class, orderTransaction.getProduct().getId());
                orderTransaction.setProduct(managedProduct);
            }
    
            // ✅ Now safe to persist
            db.persist(orderTransaction);
            db.getTransaction().commit();
            return true;
    
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }
    
    // Method to read an order transaction by order from the database
    public List<OrderTransaction> getAllOrderTransactionByOrder(Order order){

        List<OrderTransaction> orderTransactions = null;
        TypedQuery<OrderTransaction> query = db.createQuery("SELECT ot FROM OrderTransaction ot WHERE ot.order.id=:id", OrderTransaction.class)
                .setParameter("id", order.getId());
        try {
            orderTransactions = cache.getOrCreateList("orderTransactions-" + order.getId(), OrderTransaction.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orderTransactions = db.createQuery("SELECT ot FROM OrderTransaction ot WHERE ot.order.id=:id", OrderTransaction.class)
                    .setParameter("id", order.getId()).getResultList();
        }
        return orderTransactions;
    }

    // Method to read an order transaction by products from the database
    public List<OrderTransaction> getAllOrderTransactionByProduct(product product){

        List<OrderTransaction> orderTransactions = null;
        TypedQuery<OrderTransaction> query = db.createQuery("SELECT ot FROM OrderTransaction ot WHERE ot.product.id=:id", OrderTransaction.class)
                .setParameter("id", product.getId());
        try {
            orderTransactions = cache.getOrCreateList("orderTransactions-" + product.getId(), OrderTransaction.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orderTransactions = db.createQuery("SELECT ot FROM OrderTransaction ot WHERE ot.product.id=:id", OrderTransaction.class)
                    .setParameter("id", product.getId()).getResultList();
        }
        return orderTransactions;
    }

    // Method to read an order transaction by order and product from the database
    public OrderTransaction getOrderTransactionByOrderAndProduct(Order order, product product){

        OrderTransaction orderTransaction = null;
        TypedQuery<OrderTransaction> query = db.createQuery("SELECT ot FROM OrderTransaction ot WHERE ot.order.id=:orderId AND ot.product.id=:productId", OrderTransaction.class)
                .setParameter("orderId", order.getId())
                .setParameter("productId", product.getId());
        try {
            orderTransaction = cache.getOrCreate("orderTransaction-" + order.getId() + "-" + product.getId(), OrderTransaction.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orderTransaction = db.createQuery("SELECT ot FROM OrderTransaction ot WHERE ot.order.id=:orderId AND ot.product.id=:productId", OrderTransaction.class)
                    .setParameter("orderId", order.getId())
                    .setParameter("productId", product.getId()).getSingleResult();
        }
        return orderTransaction;
    }

    // #endregion ORDER TRANSACTION

    // #region ORDER STATUS
    // Read all order statuses from the database
    public List<OrderStatus> getAllOrderStatuses() {
        List<OrderStatus> orderStatuses = null;
        TypedQuery<OrderStatus> query = db.createQuery("SELECT os FROM OrderStatus os", OrderStatus.class);
        try {
            orderStatuses = cache.getOrCreateList("orderStatuses", OrderStatus.class, query);
        } catch (Exception e) {
            orderStatuses = query.getResultList();
        }
        return orderStatuses;
    }

    // Read a specific order status by ID from the database
    public OrderStatus getOrderStatusById(int id) {
        OrderStatus orderStatus = null;
        TypedQuery<OrderStatus> query = db.createQuery("SELECT os FROM OrderStatus os WHERE id=:id", OrderStatus.class)
                .setParameter("id", id);
        try {
            orderStatus = cache.getOrCreate("orderStatus-" + id, OrderStatus.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            orderStatus = db.find(OrderStatus.class, id);
        }
        return orderStatus;
    }

    // Update an order status in the database
    public boolean updateOrderStatus(OrderStatus orderStatus) {
        try {
            db.getTransaction().begin();
            db.merge(orderStatus);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Create a new order status in the database
    public boolean createOrderStatus(OrderStatus orderStatus) {
        try {
            db.getTransaction().begin();
            db.persist(orderStatus);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }
    

    // Delete an order status from the database
    public boolean deleteOrderStatus(OrderStatus orderStatus) {
        try {
            db.getTransaction().begin();
            db.remove(orderStatus);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // #endregion ORDER STATUS
}
