package DAO;

import java.util.List;

import Models.Products.product;
import Models.Users.Cart;
import Models.Users.CartItem;
import Models.Users.CartItemId;
import Models.Users.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis;
import mvc.DataAccess;

public class CartDAO {
    
    EntityManager db = DataAccess.getEntityManager();
    Redis cache = new Redis();

    public CartDAO() {
    }

    // #region CART
    // Create a cart
    public boolean createCart(Cart cart){
        try {
            db.getTransaction().begin();
            db.persist(cart);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Read a cart by user
    public Cart getCartByUser(int userId) {
        Cart cart = null;
        TypedQuery<Cart> query = db.createQuery(
            "SELECT c FROM Cart c WHERE c.user.id = :userId", Cart.class
        ).setParameter("userId", userId);

        try {
            cart = cache.getOrCreate("cart-" + userId, Cart.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            cart = query.getSingleResult(); // fallback if cache fails
        }
        return cart;
    }

    // #endregion CART

    // #region CART ITEM
    public boolean createCartItem(CartItem cartItem){
        try {
            db.getTransaction().begin();
            db.persist(cartItem);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Read a cart item by cart and product
    public CartItem getCartItemByCartAndProduct(Cart cart, product product) {
        CartItem cartItem = null;
        TypedQuery<CartItem> query = db.createQuery(
            "SELECT c FROM CartItem c WHERE c.cart.id = :cartId AND c.product.id = :productId", CartItem.class
        ).setParameter("cartId", cart.getId())
         .setParameter("productId", product.getId());

        try {
            cartItem = cache.getOrCreate("cartitem-" + cart.getId() + "-" + product.getId(), CartItem.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            cartItem = query.getSingleResult(); // fallback if cache fails
        }
        return cartItem;
    }

    public List<CartItem> getCartItemsByCart(Cart cart){

        List<CartItem> cartItems = null;
        int cartId = cart.getId();

        TypedQuery<CartItem> query = db.createQuery("SELECT c FROM CartItem c WHERE c.cart.id = :cartId", CartItem.class)
            .setParameter("cartId", cartId);
        
        try {
            cartItems = cache.getOrCreateList("cartitems-" + cartId, CartItem.class, query, Redis.CacheLevel.LOW);
            
        } catch (Exception e) {
            cartItems = query.getResultList(); // fallback if cache fails
        }
        return cartItems;
    }

    public List<CartItem> getCartItemsByUser(User user){

        int userId = user.getId();
        Cart cart = getCartByUser(userId);
        if (cart == null) {
            return null; // or throw an exception, depending on your design choice
        }

        return getCartItemsByCart(cart);
    }
    
    // Add a cart item
    public boolean addCartItem(CartItem cartItem) {
        try {
            db.getTransaction().begin();
            // ✅ Find and attach the existing Cart
            if (cartItem.getCart() != null && cartItem.getCart().getId() > 0) {
                Cart cart = db.find(Cart.class, cartItem.getCart().getId());
                cartItem.setCart(cart);
            }
    
            // ✅ Find and attach the existing Product
            if (cartItem.getProduct() != null && cartItem.getProduct().getId() > 0) {
                product product = db.find(product.class, cartItem.getProduct().getId());
                cartItem.setProduct(product);
            }
            db.persist(cartItem);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCartItem(CartItem cartItem) {
        try {
            db.getTransaction().begin();
            db.merge(cartItem);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // remove cartItem
    public boolean deleteCartItem(CartItem cartItem) {
        try {
            db.getTransaction().begin();

            CartItem itemToRemove = db.find(CartItem.class, new CartItemId(
                cartItem.getCart(),
                cartItem.getProduct()
            ));

            if (itemToRemove != null) {
                db.remove(itemToRemove);
                db.getTransaction().commit();
                return true;
            } else {
                db.getTransaction().rollback();
                return false;
            }

        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }


    // increase quantity of cartItem
    public boolean increaseCartItemQuantity(CartItem cartItem) {
        try {
            db.getTransaction().begin();
            cartItem.setQuantity(cartItem.getQuantity() + 1);
            db.merge(cartItem);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // decrease quantity of cartItem
    public boolean decreaseCartItemQuantity(CartItem cartItem) {
        try {
            db.getTransaction().begin();
            cartItem.setQuantity(cartItem.getQuantity() - 1);
            db.merge(cartItem);
            db.getTransaction().commit();
            return true;
        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }
}


