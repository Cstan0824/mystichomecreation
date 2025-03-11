package mvc;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class DataAccess {
    private static EntityManagerFactory entityManagerFactory;
    
    public static EntityManager getEntityManager() {
        // Map<String, Object> properties = new HashMap<>();
        // properties.put("javax.persistence.jdbc.url", "jdbc:mysql://localhost:3306/MysticHome_Creation");
        // properties.put("javax.persistence.jdbc.user", "user");
        // properties.put("javax.persistence.jdbc.password", "myuser1234");
        // properties.put("javax.persistence.jdbc.driver", "com.mysql.cj.jdbc.Driver");
        entityManagerFactory = Persistence.createEntityManagerFactory("myPersistenceUnit");
        //entityManagerFactory = Persistence.createEntityManagerFactory("myPersistenceUnit", properties);
        return entityManagerFactory.createEntityManager();
    }

    public static void closeFactory() {
        if (entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
        }
    }
}
