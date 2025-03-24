package mvc;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class DataAccess {
    private static EntityManagerFactory entityManagerFactory;
    
    public static EntityManager getEntityManager() {
        entityManagerFactory = Persistence.createEntityManagerFactory("myPersistenceUnit");
        return entityManagerFactory.createEntityManager();
    }

    public static boolean isConnected() {
        return entityManagerFactory.isOpen();
    }

    public static void closeFactory() {
        if (entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
        }
    }
}
