package DAO;

import java.util.List;

import Models.PaymentMethod;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.DataAccess;


public class PaymentMethodDAO {

    private EntityManager db = DataAccess.getEntityManager();
    private Redis cache = new Redis();

    public PaymentMethodDAO() {
    }

    public List<PaymentMethod> getAllPaymentMethods() {
        List<PaymentMethod> paymentMethods = null;
        TypedQuery<PaymentMethod> query = db.createQuery("SELECT pm FROM PaymentMethod pm", PaymentMethod.class);
        try {
            paymentMethods = cache.getOrCreateList("paymentMethods", PaymentMethod.class, query);
        } catch (Exception e) {
            paymentMethods = query.getResultList();
        }
        return paymentMethods;
    }

    // Read a specific payment method by ID from the database
    public PaymentMethod getPaymentMethodById(int id) {
        PaymentMethod paymentMethod = null;
        TypedQuery<PaymentMethod> query = db.createQuery("SELECT pm FROM PaymentMethod pm WHERE id=:id", PaymentMethod.class)
                .setParameter("id", id);
        try {
            paymentMethod = cache.getOrCreate("paymentMethod-" + id, PaymentMethod.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            paymentMethod = db.find(PaymentMethod.class, id);
        }
        return paymentMethod;
    }
    

    // Update a payment method in the database
    public boolean updatePaymentMethod(PaymentMethod paymentMethod) {
        try {
            db.getTransaction().begin();
            db.merge(paymentMethod);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Create a new payment method in the database
    public boolean createPaymentMethod(PaymentMethod paymentMethod) {
        try {
            db.getTransaction().begin();
            db.persist(paymentMethod);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Delete a payment method from the database
    public boolean deletePaymentMethod(PaymentMethod paymentMethod) {
        try {
            db.getTransaction().begin();
            db.remove(paymentMethod);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

}
