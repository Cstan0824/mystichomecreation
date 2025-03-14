package DAO;

import java.util.List;

import Models.dev;
import jakarta.persistence.EntityManager;
import mvc.DataAccess;
import mvc.Helpers.Redis;

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
public class devDA {
    private static final EntityManager db = DataAccess.getEntityManager();
    private static final Redis cache = new Redis();

    @SuppressWarnings({ "CallToPrintStackTrace", "ConvertToTryWithResources" })
    public static List<dev> getUsers() {
        //Example use case with redis cache
        List<dev> users = null;
        try {
            users = cache.getOrCreateList("users", dev.class, () -> {
                List<dev> devs = db.createQuery("SELECT d FROM dev d", dev.class).getResultList();
                return devs; //Callback function
            });
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        // Do not close db here, as it's a shared static instance
        return users;
    }

    public static dev getUserById(int id) {
        return db.find(dev.class, id);
    }

    public static List<dev> getUserByUsername(String username) {
        return db.createQuery("SELECT u FROM dev u WHERE LOWER(u.username) LIKE LOWER(:name)", dev.class)
                .setParameter("name", "%" + username + "%") // Supports partial match
                .getResultList();
    }

    public static void addUser(dev user) {
        db.getTransaction().begin();
        db.persist(user);
        db.getTransaction().commit();
    }

    public static void addMultipleUsers(List<dev> users) {
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

    public static void updateUser(int id, String username) {
        dev user = db.find(dev.class, id);
        user.setUsername(username);
        db.getTransaction().begin();
        db.merge(user);
        db.getTransaction().commit();
    }

    public static void removeUser(int id) {
        dev user = db.find(dev.class, id);
        db.getTransaction().begin();
        db.remove(user);
        db.getTransaction().commit();
    }

    public static void close() {
        db.close();
        DataAccess.closeFactory();
    }
}
