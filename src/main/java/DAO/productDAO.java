package DAO;

import java.io.Serializable;
import java.util.List;

import Models.dev;
import Models.product;
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

    public void addProduct(product product) {
        try {
            db.getTransaction().begin();
            db.persist(product);
            db.getTransaction().commit();
        } catch (RuntimeException e) {
            e.printStackTrace(); // Handle exception
            db.getTransaction().rollback(); // Rollback transaction on error
        }
    }

    public void updateProduct(product product) {
        try {
            db.getTransaction().begin();
            db.merge(product);
            db.getTransaction().commit();
        } catch (RuntimeException e) {
            e.printStackTrace(); // Handle exception
            db.getTransaction().rollback(); // Rollback transaction on error
        }
    }
    
    public void deleteProduct(int id) {
        try {
            db.getTransaction().begin();
            product product = db.find(product.class, id);
            if (product != null) {
                db.remove(product);
            }
            db.getTransaction().commit();
        } catch (RuntimeException e) {
            e.printStackTrace(); // Handle exception
            db.getTransaction().rollback(); // Rollback transaction on error
        }
    }

    // learn from lecture note
    //Get all products with Cache
    public product searchProducts(String id){
        try{
            db.getTransaction().begin();
            TypedQuery<product> typedQuery = this.db.createQuery("SELECT p FROM product p WHERE id=?", product.class).setParameter(1, id);
            return typedQuery.getSingleResult();
        }catch (Exception e){
            e.printStackTrace(); // Handle exception
        }
        return null;
    }

    public List<product> getAllProducts() {
        try {
            db.getTransaction().begin();
            TypedQuery<product> query = db.createQuery("SELECT p FROM product p", product.class);
            List<product> products = query.getResultList();
            db.getTransaction().commit();
            return products;
        } catch (RuntimeException e) {
            e.printStackTrace(); // Handle exception
            db.getTransaction().rollback(); // Rollback transaction on error
        }
        return null;
    }


    

    



  


}
