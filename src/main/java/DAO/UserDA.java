package DAO;

import java.util.List;

import Models.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.DataAccess;
import mvc.Cache.Redis;
import mvc.Cache.Redis.CacheLevel;

public class UserDA {
    private EntityManager db = DataAccess.getEntityManager();
    private Redis cache = new Redis();

    public UserDA() {
    }

    public List<User> getUsers() {
        List<User> users = null;
        TypedQuery<User> query = db.createQuery("SELECT u FROM User u", User.class);
        try {
            users = cache.getOrCreateList("users", User.class, query);
        } catch (Exception e) {
            users = query.getResultList();
        }
        return users;
    }

    public User getUserById(int id) {
        User user = null;
        TypedQuery<User> query = db.createQuery("SELECT u FROM User u WHERE id=:id", User.class)
                .setParameter("id", id);
        try {
            user = cache.getOrCreate("user-" + id, User.class, query, CacheLevel.LOW);
        } catch (Exception e) {
            user = db.find(User.class, id);
        }
        return user;
    }

    public boolean updateUser(User user) {
        db.getTransaction().begin();
        db.merge(user);
        db.getTransaction().commit();

        if (db.getTransaction().getRollbackOnly()) {
            return false;
        }
        return true;
    }

    public boolean changeUserImage(User user) {
        return true;
    }

}
