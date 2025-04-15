package DAO;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import Models.dev;
import Models.product;
import Models.productFeedback;
import Models.productVariationOptions;
import Models.productType; // Added import for productType
import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.DataAccess;
import mvc.Cache.Redis;

@Stateless 
public class productDAO implements Serializable{
    private EntityManager db = DataAccess.getEntityManager();
    private Redis cache = new Redis(); // Assuming you have a Redis cache implementation
   
    //Get all products with Cache
    public product searchProducts(int id){
        try{
            TypedQuery<product> typedQuery = this.db.createQuery("SELECT p FROM product p WHERE id=:id", product.class).setParameter("id", id);
            product product = typedQuery.getSingleResult();
            return product;
        }catch (Exception e){
            e.printStackTrace(); // Handle exception
        }
        return null;
    }

    public List<productFeedback> getFeedbackForProduct(int productId) {
        try {
            TypedQuery<productFeedback> query = db.createQuery(
                "SELECT pf FROM productFeedback pf WHERE pf.productId = :productId",
                productFeedback.class
            );
            query.setParameter("productId", productId);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //never try before 
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
            TypedQuery<product> query = db.createQuery("SELECT p FROM product p ORDER BY p.createdDate DESC", product.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace(); // Handle exception
        }
        return null;
    }
  
    // Get all product types (dont touch this method)
    public List<productType> getAllProductTypes() {
        try {
            TypedQuery<productType> query = db.createQuery("SELECT pt FROM productType pt", productType.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace(); // Handle exception
        }
        return null;
    }   

    // Get all param from the form and then process it 
    public List<product> filterProducts(List<Integer> categoryIds , Double minPrice , Double maxPrice , String sortBy ){
        try{
            // the 1=1 is to make the query always valid cuz 1=1 is always true
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


            //So now we have the query and we need to set the params
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

            // this is where we get the result
            List<product> result = query.getResultList(); // this is where we execute the query 
            System.out.println("✅ Found products: " + result.size());
            return result;

        }catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Error in filterProducts: " + e.getMessage());
            return new ArrayList<>();
        }
    }


    



  


}
