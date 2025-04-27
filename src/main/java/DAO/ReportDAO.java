package DAO;

import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;

import java.math.BigDecimal;
import java.math.BigInteger;
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

    // Payment Preferences
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

    // Sales by Category (chart)
    public List<Object[]> getSalesByCategory() {  
        String sql = 
            "SELECT pt.product_type AS category, " +
            "       SUM(ot.order_quantity * ot.ordered_product_price) AS total " +
            "FROM Order_Transaction ot " +
            "JOIN Product p ON ot.product_id = p.product_id " +
            "JOIN Product_Type pt ON p.product_type_id = pt.product_type_id " +
            "GROUP BY pt.product_type " +
            "ORDER BY total DESC";
    
        // JPA EM, no unwrap, no scalars — raw Object[] per row
        @SuppressWarnings("unchecked")
        List<Object[]> rows = db.createNativeQuery(sql).getResultList();
    
        // Let’s log them so you can see exactly what types arrive
        System.out.println("---- DB native salesByCategory ----");
        for (Object[] r : rows) {
            System.out.printf("category=%s (%s), total=%s (%s)%n",
                r[0], r[0] == null ? "null" : r[0].getClass().getSimpleName(),
                r[1], r[1] == null ? "null" : r[1].getClass().getSimpleName()
            );
        }
    
        return rows;
    }

    public int getOrdersThisMonth() {
        String sql = """
            SELECT COUNT(*) 
            FROM Orders o
            WHERE STR_TO_DATE(o.order_date, '%Y-%m-%d %H:%i:%s')
                  BETWEEN DATE_FORMAT(CURDATE(), '%Y-%m-01')
                      AND LAST_DAY(CURDATE())
        """;
    
        Number n = (Number) db
          .createNativeQuery(sql)
          .getSingleResult();
        return n.intValue();
    }

    public int getOrdersLastMonth() {
        String sql = """
            SELECT COUNT(*) 
            FROM Orders o
            WHERE STR_TO_DATE(o.order_date, '%Y-%m-%d %H:%i:%s')
              BETWEEN DATE_FORMAT(
                        DATE_SUB(CURDATE(), INTERVAL 1 MONTH), 
                        '%Y-%m-01'
                      )
                  AND LAST_DAY(
                        DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
                      )
        """;
        Number n = (Number) db
          .createNativeQuery(sql)
          .getSingleResult();
        return n.intValue();
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

    // filter product
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

    // Daily Revenue (chart)
    public List<Object[]> getDailyRevenue(int days) {
        String sql = """
            SELECT 
              DATE(o.order_date) AS day,
              SUM(p.total_paid)   AS total
            FROM Orders o
            JOIN Payment p ON o.payment_id = p.payment_id
             WHERE CAST(o.order_date AS DATE) >= DATE_SUB(CURDATE(), INTERVAL :days DAY)
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

    // Monthly Revenue (chart)
    public List<Object[]> getMonthlyRevenue(int months) {
        String sql = """
            SELECT
            YEAR(cast(o.order_date AS DATE))  AS yr,
            MONTH(cast(o.order_date AS DATE)) AS mth,
            SUM(p.total_paid)                  AS total
            FROM Orders o
            JOIN Payment p ON o.payment_id = p.payment_id
            WHERE cast(o.order_date AS DATE)
                >= DATE_SUB(
                    DATE_FORMAT(CURDATE(), '%Y-%m-01'),
                    INTERVAL :months-1 MONTH
                )
            GROUP BY yr, mth
            ORDER BY yr, mth
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

    public List<Object[]> getTopSellingProducts(int limit) {
        String sql = """
            SELECT p.title, pt.type, p.price, SUM(ot.orderQuantity) AS totalSold
            FROM OrderTransaction ot
            JOIN ot.product p
            JOIN p.type pt
            GROUP BY p.id
            ORDER BY totalSold DESC
        """;
    
        var query = db.createQuery(sql, Object[].class)
                      .setMaxResults(limit);
    
        return query.getResultList(); 
    }
}

