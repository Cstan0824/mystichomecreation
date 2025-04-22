package DAO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.util.List; // Import List

import Models.Accounts.Voucher;
import Models.Orders.Order;
import Models.Orders.OrderStatus;
import Models.Users.User;
import mvc.DataAccess;

public class ReportDAO {
    private EntityManager db = DataAccess.getEntityManager();

    /**
     * Total of all payments for completed orders
     */
    // public BigDecimal getTotalEarned() {
    //     String jpql = "SELECT SUM(p.totalPaid) " +
    //                   "FROM Order o " +
    //                   "JOIN o.payment p " +
    //                   "JOIN o.status s " +
    //                   "WHERE s.statusDescription IN : 'Recieved'";
    //     TypedQuery<BigDecimal> q = db.createQuery(jpql, BigDecimal.class);
    //     q.setParameter("completedStatuses", List.of("Shipped", "Delivered", "Completed"));
    //     return q.getSingleResult();
    // }

    /**
     * Count of orders in Pending status
     */
    public Long getPendingOrdersCount() {
        String jpql = "SELECT COUNT(o) FROM Order o " +
                      "JOIN o.status s " +
                      "WHERE s.statusDescription = :'Pending'";
        TypedQuery<Long> q = db.createQuery(jpql, Long.class);
        q.setParameter("pending", "Pending");
        return q.getSingleResult();
    }

    /**
     * Payment-method breakdown (description, count, total volume)
     */
    // public List<Object[]> getPaymentMethodStats() {
    //     String jpql = "SELECT pm.methodDescription, COUNT(p), SUM(p.totalPaid) " +
    //                   "FROM Payment p " +
    //                   "JOIN p.method pm " +
    //                   "GROUP BY pm.methodDescription";
    //     return db.createQuery(jpql, Object[].class)
    //              .getResultList();
    // }

    /**
     * Total registered users
     */
    public Long getTotalUsersCount() {
        String jpql = "SELECT COUNT(u) FROM User u";
        return db.createQuery(jpql, Long.class)
                 .getSingleResult();
    }

    /**
     * Total staff count (users having 'Staff' role)
     */
    public Long getTotalStaffCount() {
        String jpql = "SELECT COUNT(u) FROM User u JOIN u.role r WHERE r.roleDescription = :staffRole";
        TypedQuery<Long> q = db.createQuery(jpql, Long.class);
        q.setParameter("staffRole", "Staff");
        return q.getSingleResult();
    }

    /**
     * Top N vouchers by usage per month
     */
    // public List<Object[]> getMostUsedVouchers() {
    //     String jpql = "SELECT v.voucherCode, v.voucherUsagePerMonth " +
    //                   "FROM Voucher v " +
    //                   "ORDER BY v.voucherUsagePerMonth DESC";
    //     TypedQuery<Object[]> q = db.createQuery(jpql, Object[].class);
    //     q.setMaxResults(10);
    //     return q.getResultList();
    // }

    
}
