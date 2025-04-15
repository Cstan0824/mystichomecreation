package DAO;

import java.time.LocalDate;
import java.util.List;

import Models.Order;
import Models.OrderStatus;
import Models.Payment;
import Models.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.DataAccess;

public class OrderDAO {
    
    EntityManager db = DataAccess.getEntityManager();
    Redis cache = new Redis();

    public OrderDAO() {
    }

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

    // Read an order by ID from the database
    public Order getOrderById(int id) {
        Order order = null;
        TypedQuery<Order> query = db.createQuery("SELECT o FROM Order o WHERE id=:id", Order.class)
                .setParameter("id", id);
        try {
            order = cache.getOrCreate("order-" + id, Order.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
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



}
