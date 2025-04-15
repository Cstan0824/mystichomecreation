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

    // Filter the categories 
    public List<product> getProductsByCategories(List<String> categoryNames) {
        try {
            TypedQuery<product> query = db.createQuery(
                "SELECT p FROM product p WHERE p.type.type IN :names", product.class
            );
            query.setParameter("names", categoryNames);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new ArrayList<>();
    }

    // sort for the products
    public List<product> getAllSorted(String orderByClause) {
        try {
            String queryStr = "SELECT p FROM product p ORDER BY p." + orderByClause;
            TypedQuery<product> query = db.createQuery(queryStr, product.class);
            return query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    



  


}
