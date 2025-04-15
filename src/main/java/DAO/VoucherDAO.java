package DAO;

import java.util.List;

import Models.Accounts.Voucher;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.DataAccess;


public class VoucherDAO {
    
    private EntityManager db = DataAccess.getEntityManager();
    private Redis cache = new Redis();


    public VoucherDAO() {
    }

    // Read all vouchers from the database
    public List<Voucher> getAllVouchers() {
        List<Voucher> vouchers = null;
        TypedQuery<Voucher> query = db.createQuery("SELECT v FROM Voucher v", Voucher.class);
        try {
            vouchers = cache.getOrCreateList("vouchers", Voucher.class, query);
        } catch (Exception e) {
            vouchers = query.getResultList();
        }
        return vouchers;
    }

    // Read a specific voucher by ID from the database
    public Voucher getVoucherById(int id) {
        Voucher voucher = null;
        TypedQuery<Voucher> query = db.createQuery("SELECT v FROM Voucher v WHERE id=:id", Voucher.class)
                .setParameter("id", id);
        try {
            voucher = cache.getOrCreate("voucher-" + id, Voucher.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            voucher = db.find(Voucher.class, id);
        }
        return voucher;
    }

    // Update a voucher in the database
    public boolean updateVoucher(Voucher voucher) {
        try {
            db.getTransaction().begin();
            db.merge(voucher);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Create a new voucher in the database
    public boolean createVoucher(Voucher voucher) {
        try {
            db.getTransaction().begin();
            db.persist(voucher);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Delete a voucher from the database
    public boolean deleteVoucher(Voucher voucher) {
        try {
            db.getTransaction().begin();
            db.remove(voucher);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

}
