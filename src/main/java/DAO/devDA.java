package DAO;

import java.io.Serializable;
import java.util.List;

import Models.dev;

import jakarta.ejb.Stateless;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.DataAccess;
import mvc.Cache.Redis;

/*
@============================================================================================================@
@ JPA is using JPQL (Java Persistence Query Language) to query the database. | DO NOT USE MYSQL QUERIES HERE @
@============================================================================================================@

    Example Query:
        - Join Query: [SELECT p FROM Product p JOIN p.category c WHERE c.name = :categoryName] use Product.class{need to set @ManyToOne} and Category.class{need to set @OneToMany}
        - Group By Query: [SELECT c.name, COUNT(p) FROM Product p JOIN p.category c GROUP BY c.name] use Object[].class
        - Order By Query: [SELECT p FROM Product p ORDER BY p.price DESC]
        - Nested Query: [SELECT p FROM Product p WHERE p.price > (SELECT AVG(p2.price) FROM Product p2)]
        - Named Query: [SELECT p FROM Product p WHERE p.price > :price]
 */
@Stateless
public class devDA implements Serializable {
    private EntityManager db = DataAccess.getEntityManager();
    private Redis cache = new Redis();

    //Get all users with Cache
    @SuppressWarnings({ "CallToPrintStackTrace", "ConvertToTryWithResources" })
    public List<dev> getUsers() {
        List<dev> users = null;
        TypedQuery<dev> typedQuery = this.db.createQuery("SELECT d FROM dev d", dev.class);
        try {
            users = cache.getOrCreateList("users", dev.class, typedQuery);
        } catch (Exception e) {
            users = typedQuery.getResultList(); //run without cache if cache fails
        }
        return users;
    }

    public dev getUserById(int id) {
        return db.find(dev.class, id);
    }

    public List<dev> getUserByUsername(String username) {
        return db.createQuery("SELECT u FROM dev u WHERE LOWER(u.username) LIKE LOWER(:name)", dev.class)
                .setParameter("name", "%" + username + "%") // Supports partial match
                .getResultList();
    }

    public void addUser(dev user) {
        try {
            db.getTransaction().begin();
            db.persist(user);
            db.getTransaction().commit();

        } catch (RuntimeException e) {
            System.out.println("ERROR at addUser(dev user): " + e.getMessage());
        }
    }

    public void addMultipleUsers(List<dev> users) {
        db.getTransaction().begin();

        for (int i = 0; i < users.size(); i++) {
            db.persist(users.get(i));

            // Flush and clear every 20 inserts (batching)
            if (i % 20 == 0) {
                db.flush();
                db.clear();
            }
        }
        db.getTransaction().commit();
    }

    public void updateUser(int id, String username) {
        dev user = db.find(dev.class, id);
        user.setUsername(username);
        db.getTransaction().begin();
        db.merge(user);
        db.getTransaction().commit();
    }

    public void removeUser(int id) {
        dev user = db.find(dev.class, id);
        db.getTransaction().begin();
        db.remove(user);
        db.getTransaction().commit();
    }

    public void close() {
        db.close();
        DataAccess.closeFactory();
    }
}
