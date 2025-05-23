package DAO;

import java.io.Serializable;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import Models.Products.product;
import Models.Products.productFeedback;
import Models.Products.productFeedbackKey;
import Models.Products.productImage;
import Models.Products.productType;
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.DataAccess;

@Stateless
public class productDAO implements Serializable {
    private EntityManager db = DataAccess.getEntityManager();
    private Redis cache = new Redis(); // Assuming you have a Redis cache implementation

    // Get all products with Cache
    public product searchProducts(int id) {
        TypedQuery<product> q = db.createQuery(
                "SELECT p FROM product p JOIN FETCH p.image WHERE p.id = :id",
                product.class).setParameter("id", id);
        return q.getSingleResult();
    }

    public List<productFeedback> getFeedbackWithUserAndProduct(int productId) {
        String jpql = "SELECT DISTINCT pf " +
                "FROM productFeedback pf " +
                "  JOIN FETCH pf.order o " +
                "  JOIN FETCH o.user u   " +
                "  JOIN FETCH pf.product p " +
                "WHERE pf.productId = :productId";

        TypedQuery<productFeedback> query = db.createQuery(jpql, productFeedback.class);
        query.setParameter("productId", productId);
        return query.getResultList();
    }

    // never try before
    public void addFeedback(productFeedback feedback) {
        try {
            db.getTransaction().begin();
            db.persist(feedback);
            db.getTransaction().commit();
        } catch (Exception e) {
            db.getTransaction().rollback();
            e.printStackTrace();
        }
    }

    // Catalog use this method to get all products (dont touch this method)
    public List<product> getAllProducts() {
        
        try {
            TypedQuery<product> query = db.createQuery(
                    "SELECT p FROM product p JOIN FETCH p.image ORDER BY p.createdDate DESC",
                    product.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace(System.err); // Handle exception
        }
        return null;
    }

    // Get all product types (dont touch this method)
    public List<productType> getAllProductTypes() {
        try {
            TypedQuery<productType> query = db.createQuery("SELECT pt FROM productType pt", productType.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace(System.err); // Handle exception
        }
        return null;
    }

    // Get all param from the form and then process it
    public List<product> filterProducts(List<Integer> categoryIds, Double minPrice, Double maxPrice, String sortBy,
            String keyword) {
        try {
            // the 1=1 is to make the query always valid cuz 1=1 is always true and this
            // help to reterieve all the products
            StringBuilder jpql = new StringBuilder("SELECT p FROM product p WHERE 1=1");

            if (categoryIds != null && !categoryIds.isEmpty()) {
                jpql.append(" AND p.type.id IN :ids");
            }
            if (minPrice != null) {
                jpql.append(" AND p.price >= :minPrice");
            }
            if (maxPrice != null) {
                jpql.append(" AND p.price <= :maxPrice");
            }
            if (keyword != null && !keyword.isBlank()) {
                jpql.append(" AND (LOWER(p.title) LIKE :kw )");
            }
            if (sortBy != null) {

                switch (sortBy) {
                    case "priceLowHigh":
                        jpql.append(" ORDER BY p.price ASC");
                        break;

                    case "priceHighLow":
                        jpql.append(" ORDER BY p.price DESC");
                        break;
                    case "newest":
                        jpql.append(" ORDER BY p.createdDate DESC");
                        break;
                    default:
                        System.out.println("⚠ Unknown sortBy value: " + sortBy);
                }
            }

            System.out.println("🛠 Final JPQL: " + jpql);

            // So now we have the query and we need to set the params
            TypedQuery<product> query = db.createQuery(jpql.toString(), product.class);

            if (categoryIds != null && !categoryIds.isEmpty()) {
                System.out.println("🟡 Binding categoryIds: " + categoryIds);
                query.setParameter("ids", categoryIds);
            }
            if (minPrice != null) {
                System.out.println("🟡 Binding minPrice: " + minPrice);
                query.setParameter("minPrice", minPrice);
            }
            if (maxPrice != null) {
                System.out.println("🟡 Binding maxPrice: " + maxPrice);
                query.setParameter("maxPrice", maxPrice);
            }
            if (keyword != null && !keyword.isBlank()) {
                System.out.println("🟡 Binding keyword: %" + keyword.toLowerCase() + "%");
                query.setParameter("kw", "%" + keyword.toLowerCase() + "%");
            }

            // this is where we get the result
            List<product> result = query.getResultList(); // this is where we execute the query
            System.out.println("✅ Found products: " + result.size());
            return result;

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Error in filterProducts: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    public productType findTypeById(int id) {
        return db.find(productType.class, id);
    }

    public void addProduct(product p) {
        try {
            db.getTransaction().begin();
            db.persist(p);
            db.getTransaction().commit();
            System.out.println("🗃️ DAO: product saved");
        } catch (Exception e) {
            db.getTransaction().rollback();
            e.printStackTrace();
            System.out.println("❌ DAO error on addProduct: " + e.getMessage());
            throw e;
        }
    }

    public void deleteProduct(int id) {
        try {
            product p = db.find(product.class, id);

            if (p != null) {
                db.getTransaction().begin();
                db.remove(p);
                db.getTransaction().commit();
                System.out.println("🗑️ DAO: product deleted");
            } else {
                System.out.println("❌ DAO: product not found for deletion");
            }
        } catch (Exception e) {
            db.getTransaction().rollback();
            e.printStackTrace();
            System.out.println("❌ DAO error on deleteProduct: " + e.getMessage());
        }
    }

    public void updateProduct(product p) {
        try {
            db.getTransaction().begin();
            db.merge(p);
            db.getTransaction().commit();
            System.out.println("🔄 DAO: product updated");

        } catch (Exception e) {
            db.getTransaction().rollback();
            e.printStackTrace();
            System.out.println("❌ DAO error on updateProduct: " + e.getMessage());
        }
    }


    public boolean updateProductWithBoolean(product p) {
        try {
            db.getTransaction().begin();
            db.merge(p);
            db.getTransaction().commit();
            System.out.println("🔄 DAO: product updated");
            return true;

        } catch (Exception e) {
            db.getTransaction().rollback();
            e.printStackTrace();
            System.out.println("❌ DAO error on updateProduct: " + e.getMessage());
            return false;
        }
    }

    public boolean isProductNameExists(String name) {
        try {
            Long count = this.db.createQuery("SELECT COUNT(p) FROM product p WHERE p.title = :name", Long.class)
                    .setParameter("name", name)
                    .getSingleResult();

            return (count > 0) ? true : false;

        } catch (Exception e) {
            e.printStackTrace(); // Handle exceptions
        }
        return false;
    }

    public void addProductType(productType type) {
        try {
            db.getTransaction().begin();
            db.persist(type);
            db.getTransaction().commit();
            System.out.println("🗃️ DAO: product type saved");
        } catch (Exception e) {
            db.getTransaction().rollback();
            e.printStackTrace();
            System.out.println("❌ DAO error on addProductType: " + e.getMessage());
        }
    }

    public void replyToFeedback(productFeedback fb) {
        try {

            if (fb != null) {
                db.getTransaction().begin();
                db.merge(fb);
                db.getTransaction().commit();
                System.out.println("🗃️ DAO: Feedback replied to successfully");
            } else {
                System.out.println("❌ DAO: Feedback not found for reply");
            }
        } catch (Exception e) {
            db.getTransaction().rollback();
            e.printStackTrace();
            System.out.println("❌ DAO error on replyToFeedback: " + e.getMessage());
        }

    }

    public productFeedback findById(productFeedbackKey key) {
        return db.find(productFeedback.class, key);
    }

    public boolean addProductFeedback(productFeedback feedback) {
        try {
            db.getTransaction().begin();
            db.persist(feedback);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Boolean> getFeedbackMapByOrderId(int orderId) {
        String key = "feedbackMap-order-" + orderId;

        TypedQuery<Object[]> query = db.createQuery(
                "SELECT pf.productId, pf.createdAt FROM productFeedback pf WHERE pf.orderId = :orderId",
                Object[].class);
        query.setParameter("orderId", orderId);

        List<Object[]> feedbackKeys = cache.getOrCreateList(
                key, Object[].class, query, Redis.CacheLevel.LOW, "Order");

        // 🛡️ Fallback
        if (feedbackKeys == null) {
            System.out.println("Redis returned null for key: " + key + " — falling back to empty map.");
            feedbackKeys = new ArrayList<>();
        }

        Map<String, Boolean> feedbackMap = new HashMap<>();
        for (Object[] row : feedbackKeys) {
            int productId = (int) row[0];
            String createdAt = (String) row[1]; // No need to cast to LocalDateTime
            String compositeKey = productId + "|" + createdAt;
            feedbackMap.put(compositeKey, true);
        }

        return feedbackMap;
    }

    public productImage findImageById(int imageId) {
        EntityManager em = DataAccess.getEntityManager();
        return em.find(productImage.class, imageId);
    }

    public void addProductImage(productImage pi) {
        db.getTransaction().begin();
        db.persist(pi);
        db.getTransaction().commit();
    }

    public List<product> getBestSellingProducts() {
        List<product> topProducts = null;
    
        String queryStr = """
                SELECT ot.product 
                FROM OrderTransaction ot
                GROUP BY ot.product
                ORDER BY SUM(ot.orderQuantity) DESC
            """;
    
        TypedQuery<product> query = db.createQuery(queryStr, product.class)
                                      .setMaxResults(4);
    
        try {
            topProducts = cache.getOrCreateList(
                    "top-4-best-sellers",
                    product.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            topProducts = query.getResultList(); // fallback if Redis fails
        }
    
        return topProducts;
    }
    
    public List<product> getNewArrivalProducts() {
        List<product> newArrivals = null;

        String queryStr = """
                SELECT p
                FROM product p
                WHERE p.createdDate >= :thirtyDaysAgo
                ORDER BY p.createdDate DESC
            """;

        LocalDateTime nowMinus30 = LocalDateTime.now().minusDays(30);
        Date thirtyDaysAgo = Date.valueOf(nowMinus30.toLocalDate()); // java.sql.Date

        TypedQuery<product> query = db.createQuery(queryStr, product.class)
                                    .setParameter("thirtyDaysAgo", thirtyDaysAgo);

        try {
            newArrivals = cache.getOrCreateList(
                    "new-arrivals-last-30-days",
                    product.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            newArrivals = query.getResultList(); // fallback
        }

        return newArrivals;
    }

    public List<product> getRandomProductFromEachType() {
        List<product> randomProducts = new ArrayList<>();
    
        // Step 1: Get all product types
        String typeQueryStr = """
                SELECT pt.id
                FROM productType pt
            """;
    
        List<Integer> productTypeIds = db.createQuery(typeQueryStr, Integer.class)
                                         .getResultList();
    
        // Step 2: For each type, pick 1 random product
        for (Integer typeId : productTypeIds) {
            String productQueryStr = """
                    SELECT p
                    FROM product p
                    WHERE p.type.id = :typeId
                    ORDER BY FUNCTION('RAND')
                """;
    
            TypedQuery<product> query = db.createQuery(productQueryStr, product.class)
                                          .setParameter("typeId", typeId)
                                          .setMaxResults(1);
    
            try {
                product randomProduct = cache.getOrCreate(
                        "random-product-type-" + typeId,
                        product.class, query, Redis.CacheLevel.LOW);
    
                if (randomProduct != null) {
                    randomProducts.add(randomProduct);
                }
            } catch (Exception e) {
                // fallback if cache fails
                List<product> fallbackList = query.getResultList();
                if (!fallbackList.isEmpty()) {
                    randomProducts.add(fallbackList.get(0));
                }
            }
        }
    
        return randomProducts;
    }
    
    public List<productFeedback> getTopRatedProductFeedbacks() {
        List<productFeedback> topFeedbacks = null;
    
        String queryStr = """
                SELECT pf
                FROM productFeedback pf
                WHERE pf.comment IS NOT NULL
                ORDER BY pf.rating DESC
            """;
    
        TypedQuery<productFeedback> query = db.createQuery(queryStr, productFeedback.class)
                                              .setMaxResults(6);
    
        try {
            topFeedbacks = cache.getOrCreateList(
                    "top-6-highest-feedbacks-with-comment",
                    productFeedback.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            topFeedbacks = query.getResultList(); // fallback
        }
    
        return topFeedbacks;
    }
    
    public List<product> getFeaturedProducts(){
        List<product> featuredProducts = null;
    
        String queryStr = """
                SELECT p
                FROM product p
                WHERE p.featured  = 1
                ORDER BY FUNCTION('RAND')
            """;
    
        TypedQuery<product> query = db.createQuery(queryStr, product.class)
                                      .setMaxResults(4);
    
        try {
            featuredProducts = cache.getOrCreateList(
                    "featured-products",
                    product.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            featuredProducts = query.getResultList(); // fallback
        }
    
        return featuredProducts;
    }


    
}
