package DAO;

import java.util.List;

import Models.Payment;
import Models.PaymentMethod;
import Models.Voucher;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.DataAccess;


public class PaymentDAO {
    
    EntityManager db = DataAccess.getEntityManager();
    Redis cache = new Redis();

    public PaymentDAO() {
    }

    // Create a new payment in the database
    public boolean createPayment(Payment payment) {
        try {
            db.getTransaction().begin();
            db.persist(payment);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Read specific payment by ID from the database
    public Payment getPaymentById(int id) {
        Payment payment = null;
        try {
            payment = db.find(Payment.class, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return payment;
    }

    // Read specific payments by method from the database
    public List<Payment> getPaymentsByMethod(PaymentMethod method) {
        List<Payment> payments = null;
        int methodId = method.getId();
    
        TypedQuery<Payment> query = db.createQuery(
    "SELECT p FROM Payment p WHERE p.method.id = :methodId", Payment.class
        ).setParameter("methodId", methodId);

    
        try {
            payments = cache.getOrCreateList("payment-" + methodId, Payment.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            payments = query.getResultList(); // fallback if cache fails
        }
    
        return payments;
    }

    // Read specific payments by voucher from the database
    public List<Payment> getPaymentsByVoucher(Voucher voucher) {
        List<Payment> payments = null;
        int voucherId = voucher.getId();
    
        TypedQuery<Payment> query = db.createQuery(
    "SELECT p FROM Payment p WHERE p.voucher.id = :voucherId", Payment.class
        ).setParameter("voucherId", voucherId);

    
        try {
            payments = cache.getOrCreateList("payment-" + voucherId, Payment.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            payments = query.getResultList(); // fallback if cache fails
        }
    
        return payments;
    }
    

    // Read all payments from the database
    public List<Payment> getAllPayments() {
        List<Payment> payments = null;
        TypedQuery<Payment> query = db.createQuery("SELECT p FROM Payment p", Payment.class);
        try {
            payments = cache.getOrCreateList("payments", Payment.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            payments = query.getResultList();
        }
        return payments;
    }

    // Update an existing payment in the database   
    public boolean updatePayment(Payment payment) {
        try {
            db.getTransaction().begin();
            db.merge(payment);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePayment(int id) {
        try {
            db.getTransaction().begin();
            Payment payment = db.find(Payment.class, id);
            if (payment != null) {
                db.remove(payment);
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
