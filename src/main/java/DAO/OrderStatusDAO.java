package DAO;

import java.util.List;

import Models.OrderStatus;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.DataAccess;

public class OrderStatusDAO {
    private EntityManager db = DataAccess.getEntityManager();
    private Redis cache = new Redis();

    public OrderStatusDAO() {
    }

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

}
