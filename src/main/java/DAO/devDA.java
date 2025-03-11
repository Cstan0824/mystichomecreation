package DAO;

import java.util.List;

import Models.dev;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.DataAccess;

public class devDA {
    private static final EntityManager db = DataAccess.getEntityManager();

    @SuppressWarnings({"CallToPrintStackTrace", "ConvertToTryWithResources"})
    public static List<dev> getUsers() {
        List<dev> users = null;
        try {
            // Create a query to fetch all users
            TypedQuery<dev> query = db.createQuery("SELECT * FROM dev", dev.class);
            users = query.getResultList();
        } catch (Exception e) {
            e.printStackTrace();
        } 
        // Do not close db here, as it's a shared static instance
        return users;
    }
}
