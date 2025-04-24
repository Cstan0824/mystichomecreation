package DAO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

import Models.Products.product;
import mvc.DataAccess;

public class ReportDAO {
    private EntityManager db = DataAccess.getEntityManager();
    private static final int CUSTOMER_ROLE_ID = 2; // 2 is the role ID for customers
    private static final int STAFF_ROLE_ID = 3; // 3 is the role ID for staff

    // Total Customer Count
    public int getTotalCustomers() {
        TypedQuery<Long> q = db.createQuery(
            "SELECT COUNT(u) FROM User u WHERE u.role_id = :rid",
            Long.class
        ).setParameter("rid", CUSTOMER_ROLE_ID);

        Long count = q.getSingleResult();      // JPQL COUNT() always returns Long
        return count == null ? 0 : count.intValue();
    }

    // Total Staff Count
    public int getTotalStaff() {
        TypedQuery<Long> q = db.createQuery(
            "SELECT COUNT(u) FROM User u WHERE u.role_id = :rid",
            Long.class
        ).setParameter("rid", STAFF_ROLE_ID);

        Long count = q.getSingleResult();
        return count == null ? 0 : count.intValue();
    }

    // public List<product> getLowStockProducts(int threshold) {
    //     TypedQuery<product> q = db.createQuery(
    //         "SELECT p FROM product p WHERE p.stock <= :th ORDER BY p.stock ASC",
    //         product.class
    //     );
    //     q.setParameter("th", threshold);
    //     return q.getResultList();
    // }

    // public List<Object[]> getFeedbackRatings() {
    //     String jpql = """
    //         SELECT pf.product.title, AVG(pf.rating)
    //         FROM productFeedback pf
    //         GROUP BY pf.product.title
    //         ORDER BY AVG(pf.rating) DESC
    //         """;
    //     return db.createQuery(jpql, Object[].class)
    //              .getResultList();
    // }

    public List<Object[]> getPaymentPreferences() {
        String jpql = """
            SELECT pm.methodDesc, COUNT(p)
            FROM Payment p
             JOIN p.method pm
            GROUP BY pm.methodDesc
            ORDER BY COUNT(p) DESC
            """;
        return db.createQuery(jpql, Object[].class)
                 .getResultList();
    }

    public List<Object[]> getSalesByCategory() {
        String jpql = """
                SELECT pt.type, 
                SUM(ot.orderQuantity * ot.orderedProductPrice)
                FROM OrderTransaction ot
                JOIN ot.product p
                JOIN p.type pt
                GROUP BY pt.type
                ORDER BY SUM(ot.orderQuantity * ot.orderedProductPrice) DESC
                """;
        return db.createQuery(jpql, Object[].class)
                 .getResultList();
    }

    public List<Object[]> getOrdersPerMonth() {
        String sql = """
           SELECT
                YEAR(STR_TO_DATE(o.order_date, '%Y-%m-%d %H:%i:%s')) AS yr,
                MONTH(STR_TO_DATE(o.order_date, '%Y-%m-%d %H:%i:%s')) AS mon,
                COUNT(*)                                         AS cnt
            FROM Orders o
            GROUP BY yr, mon
            ORDER BY yr DESC, mon DESC
        """;
        @SuppressWarnings("unchecked")
        List<Object[]> results = db.createNativeQuery(sql).getResultList();
        return results;
    }

    public double getTotalRevenue() {
        Double sum = db.createQuery(
            "SELECT COALESCE(SUM(p.totalPaid), 0) FROM Payment p",
            Double.class
        ).getSingleResult();
        return sum;

        // coalesce() is a SQL function that returns the first non-null value in the list of arguments.
        // In this case, if the sum is null (i.e., no payments exist), it will return 0 instead.
        // ensure always get a number, not null.
    }

    // Get the top-selling products for all months
    public List<Object[]> getTopSellingProductsEachMonth() {
        String sql = """
         SELECT p.product_title, SUM(ot.order_quantity) AS total_qty
            FROM Order_Transaction ot
            JOIN Orders o ON ot.order_id = o.order_id
            JOIN Product p ON ot.product_id = p.product_id
            WHERE o.status_id = 4
            GROUP BY p.product_title
            ORDER BY total_qty DESC
        """;
        @SuppressWarnings("unchecked")
        List<Object[]> results = db.createNativeQuery(sql).getResultList();
        return results;
    }


    public List<product> filterProducts( List<Integer> categoryIds, Double priceMin, Double priceMax, Integer stockMin, Integer stockMax, Double ratingMin, LocalDate dateFrom, LocalDate dateTo) 
    {
        StringBuilder jpql = new StringBuilder("SELECT p FROM product p WHERE 1=1");

        if (categoryIds != null && !categoryIds.isEmpty()) {
            jpql.append(" AND p.type.id IN :catIds");
        }
        if (priceMin != null) {
            jpql.append(" AND p.price >= :priceMin");
        }
        if (priceMax != null) {
            jpql.append(" AND p.price <= :priceMax");
        }
        if (stockMin != null) {
            jpql.append(" AND p.stock >= :stockMin");
        }
        if (stockMax != null) {
            jpql.append(" AND p.stock <= :stockMax");
        }
        if (ratingMin != null) {
            // only products whose AVG(rating) >= :ratingMin
            jpql.append(
                " AND p.id IN (" +
                "    SELECT pf.product.id" +
                "      FROM productFeedback pf" +
                "     GROUP BY pf.product.id" +
                "    HAVING AVG(pf.rating) >= :ratingMin" +
                ")"
            );
        }
        if (dateFrom != null) {
            jpql.append(" AND p.createdDate >= :dateFrom");
        }
        if (dateTo != null) {
            jpql.append(" AND p.createdDate <= :dateTo");
        }

        TypedQuery<product> q = db.createQuery(jpql.toString(), product.class);

        if (categoryIds != null && !categoryIds.isEmpty()) {
            q.setParameter("catIds", categoryIds);
        }
        if (priceMin != null) {
            q.setParameter("priceMin", priceMin);
        }
        if (priceMax != null) {
            q.setParameter("priceMax", priceMax);
        }
        if (stockMin != null) {
            q.setParameter("stockMin", stockMin);
        }
        if (stockMax != null) {
            q.setParameter("stockMax", stockMax);
        }
        if (ratingMin != null) {
            q.setParameter("ratingMin", ratingMin);
        }
        if (dateFrom != null) {
            q.setParameter("dateFrom", Date.valueOf(dateFrom));
        }
        if (dateTo != null) {
            q.setParameter("dateTo", Date.valueOf(dateTo));
        }

        return q.getResultList();
    }


    public List<Object[]> getDailyRevenue(int days) {
        String sql = """
            SELECT 
              DATE(o.order_date) AS day,
              SUM(p.total_paid)   AS total
            FROM Orders o
            JOIN Payment p ON o.payment_id = p.payment_id
            WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL :days DAY)
            GROUP BY DATE(o.order_date)
            ORDER BY DATE(o.order_date)
        """;
        // Note: CURDATE() returns the current date in 'YYYY-MM-DD' format.
        // DATE_SUB() subtracts the specified interval from the current date.
        var q = db.createNativeQuery(sql)
                  .setParameter("days", days);
    
        // each Object[] is [ java.sql.Date day, BigDecimal total ]
        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();
        return rows;
    }


    public List<Object[]> getMonthlyRevenue(int months) {
        String sql = """
            SELECT 
              YEAR(o.order_date)  AS yr,
              MONTH(o.order_date) AS mth,
              SUM(p.total_paid)   AS total
            FROM Orders o
            JOIN Payment p ON o.payment_id = p.payment_id
            WHERE o.order_date >= DATE_SUB(
                DATE_FORMAT(CURDATE(), '%Y-%m-01'),
                INTERVAL :months-1 MONTH
            )
            GROUP BY YEAR(o.order_date), MONTH(o.order_date)
            ORDER BY YEAR(o.order_date), MONTH(o.order_date)
        """;
    
        var q = db.createNativeQuery(sql)
                  .setParameter("months", months);
    
        // each Object[] is [ Integer year, Integer month, BigDecimal total ]
        @SuppressWarnings("unchecked")
        List<Object[]> rows = q.getResultList();
        return rows;
    }




    //#region display purpose only
    public List<product> getAllProducts() {
        return db.createQuery(
            "SELECT p FROM product p",
            product.class
        ).getResultList();
    }

    public List<product> getProductsByCategory(String category) {
        String jpql = """
            SELECT p FROM product p
            WHERE p.type.type = :category
            """;
        return db.createQuery(jpql, product.class)
                 .setParameter("category", category)
                 .getResultList();
    }

    
    //helper class to get the average rating for each product
    public Map<Integer, Double> getAverageRatingsForProducts(List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return Map.of();
        }

        String jpql = """
            SELECT pf.product.id, AVG(pf.rating)
              FROM productFeedback pf
             WHERE pf.product.id IN :ids
             GROUP BY pf.product.id
            """;

        TypedQuery<Object[]> q = db.createQuery(jpql, Object[].class);
        q.setParameter("ids", productIds);

        Map<Integer, Double> result = new HashMap<>();
        for (Object[] row : q.getResultList()) {
            Integer id  = (Integer) row[0];
            Double avg  = ((Number) row[1]).doubleValue();
            result.put(id, avg);
        }
        return result;
    }


    public Map<Integer, Integer> getTotalSoldForProducts(List<Integer> productIds) {
        if (productIds == null || productIds.isEmpty()) {
            return Map.of();
        }

        String jpql = """
            SELECT ot.product.id, SUM(ot.orderQuantity)
              FROM OrderTransaction ot
             WHERE ot.product.id IN :ids
             GROUP BY ot.product.id
            """;

        TypedQuery<Object[]> q = db.createQuery(jpql, Object[].class);
        q.setParameter("ids", productIds);

        Map<Integer, Integer> result = new HashMap<>();
        for (Object[] row : q.getResultList()) {
            Integer id    = (Integer) row[0];
            Integer sold  = ((Number) row[1]).intValue();
            result.put(id, sold);
        }
        return result;
    }




    



    
  

        



}

