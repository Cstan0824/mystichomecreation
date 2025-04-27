package DAO;

import java.util.ArrayList;
import java.util.List;

import Models.Users.Permission;
import Models.Users.Role;
import Models.Users.RoleType;
import Models.Users.User;
import Models.Users.UserImage;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.Cache.Redis.CacheLevel;
import mvc.DataAccess;

public class UserDAO {
    private EntityManager db = DataAccess.getEntityManager();
    private Redis cache = new Redis();

    public UserDAO() {
    }

    public String getUserPasswordById(int id) {
        String password = null;
        TypedQuery<String> query = db.createQuery("SELECT u.password FROM User u WHERE id=:id",
                String.class)
                .setParameter("id", id);
        // DO NOT STORE SENSITIVE DATA TO CACHE
        // try {
        // password = cache.getOrCreate("user-password-" + id, String.class, query,
        // CacheLevel.LOW, "User");
        // } catch (Exception e) {
        // password = query.getResultList().get(0);
        // }
        try {
            List<String> resultList = query.getResultList();
            if (resultList.size() == 0) {
                return null;
            }
            password = query.getResultList().get(0);
        } catch (Exception e) {
            password = null;
        }
        return password;
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

    public List<User> getUsersByRole(RoleType role) {
        List<User> users = null;
        TypedQuery<User> query = db.createQuery("SELECT u FROM User u WHERE u.role.description=:role", User.class)
                .setParameter("role", role.get());
        try {
            users = cache.getOrCreateList("users-" + role.get(), User.class, query);
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

    public User getUserByEmail(String email) {
        User user = null;
        TypedQuery<User> query = db.createQuery("SELECT u FROM User u WHERE u.email=:email", User.class)
                .setParameter("email", email);
        try {
            user = cache.getOrCreate("user-" + email, User.class, query, CacheLevel.LOW);
        } catch (Exception e) {
            List<User> resultList = query.getResultList();
            if (resultList.size() == 0) {
                return null;
            }
            user = resultList.get(0);
        }
        return user;
    }

    public boolean createUser(User user) {
        db.getTransaction().begin();
        db.persist(user);
        db.getTransaction().commit();

        if (!db.getTransaction().getRollbackOnly()) {
            CartDAO cartDAO = new CartDAO();
            return cartDAO.createCart(user);
        }

        return false;
    }

    public boolean updateUser(User user) {
        db.getTransaction().begin();
        db.merge(user);
        db.getTransaction().commit();

        return !db.getTransaction().getRollbackOnly();
    }

    public boolean deleteUser(int id) {
        db.getTransaction().begin();
        User user = getUserById(id);
        db.remove(user);
        db.getTransaction().commit();

        return !db.getTransaction().getRollbackOnly();
    }

    public UserImage getUserImageById(int id) {
        UserImage userImage = null;
        TypedQuery<UserImage> query = db.createQuery("SELECT u FROM UserImage u WHERE id=:id", UserImage.class)
                .setParameter("id", id);

        List<UserImage> resultList = query.getResultList();
        if (resultList.size() == 0) {
            return null;
        }
        userImage = query.getResultList().get(0);

        return userImage;
    }

    public UserImage getUserImageByUserId(int id) {
        UserImage userImage = null;
        TypedQuery<UserImage> query = db.createQuery("SELECT u FROM UserImage u WHERE u.user.id=:id", UserImage.class)
                .setParameter("id", id);
        List<UserImage> resultList = query.getResultList();
        if (resultList.size() == 0) {
            return null;
        }
        userImage = query.getResultList().get(0);

        return userImage;
    }

    public boolean changeUserImage(UserImage userImage) {
        db.getTransaction().begin();
        db.merge(userImage);
        db.getTransaction().commit();
        return true;
    }

    public User getUserByUsername(String username) {
        User user = null;
        TypedQuery<User> query = db.createQuery("SELECT u FROM User u WHERE u.username=:username", User.class)
                .setParameter("username", username);
        try {
            user = cache.getOrCreate("user-" + username, User.class, query, CacheLevel.LOW);
        } catch (Exception e) {
            List<User> resultList = query.getResultList();
            if (resultList.size() == 0) {
                return null;
            }
            user = resultList.get(0);
        }
        return user;
    }

    public List<Permission> getPermissions(int id) {
        List<Permission> permissions = null;
        TypedQuery<Permission> query = db.createQuery("SELECT p FROM Permission p WHERE roleId=:id",
                Permission.class)
                .setParameter("id", id);
        try {
            permissions = cache.getOrCreateList("user-url-accesses-" + id, Permission.class, query);
        } catch (Exception e) {
            permissions = query.getResultList();
        }
        return permissions;
    }

    public List<String> getUrlAccesses(int id) {
        List<Permission> permissions = getPermissions(id);
        List<String> urlAccesses = new ArrayList();
        if (permissions == null) {
            return null;
        }
        for (Permission permission : permissions) {
            urlAccesses.add(permission.getAccessUrl());
        }
        return urlAccesses;
    }

    public String getEmailByUserId(int id) {
        String email = null;
        TypedQuery<String> query = db.createQuery("SELECT u.email FROM User u WHERE id=:id",
                String.class)
                .setParameter("id", id);
        try {
            List<String> resultList = query.getResultList();
            if (resultList.size() == 0) {
                return null;
            }
            email = query.getResultList().get(0);
        } catch (Exception e) {
            email = null;
        }
        return email;
    }

    public User getUserByEmailUsername(String email, String username) {
        User user = null;
        TypedQuery<User> query = db.createQuery("SELECT u FROM User u WHERE u.email=:email OR u.username=:username",
                User.class)
                .setParameter("email", email)
                .setParameter("username", username);
        try {
            List<User> resultList = query.getResultList();
            if (resultList.size() == 0) {
                return null;
            }
            user = query.getResultList().get(0);
        } catch (Exception e) {
            user = null;
        }
        return user;
    }

    public Role getRoleById(int id) {
        Role role = null;
        TypedQuery<Role> query = db.createQuery("SELECT r FROM Role r WHERE id=:id", Role.class)
                .setParameter("id", id);
        try {
            role = cache.getOrCreate("role-" + id, Role.class, query, CacheLevel.LOW);
        } catch (Exception e) {
            List<Role> resultList = query.getResultList();
            if (resultList.size() == 0) {
                return null;
            }
            role = resultList.get(0);
        }
        return role;
    }

    public Role getRoleByName(String name) {
        Role role = null;
        TypedQuery<Role> query = db.createQuery("SELECT r FROM Role r WHERE r.description=:name", Role.class)
                .setParameter("name", name);
        try {
            role = cache.getOrCreate("role-" + name, Role.class, query, CacheLevel.LOW);
        } catch (Exception e) {
            List<Role> resultList = query.getResultList();
            if (resultList.size() == 0) {
                return null;
            }
            role = resultList.get(0);
        }
        return role;
    }
}
