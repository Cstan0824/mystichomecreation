package DAO;

import java.time.LocalDateTime;
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

    public boolean createCart(User user) {
        Cart cart = new Cart();
        cart.setUser(user);
        return createCart(cart);
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

    // Read a cart by id
    public Cart getCartById(int cartId) {
        Cart cart = null;
        TypedQuery<Cart> query = db.createQuery(
            "SELECT c FROM Cart c WHERE c.id = :cartId", Cart.class
        ).setParameter("cartId", cartId);

        try {
            cart = cache.getOrCreate("cart-" + cartId, Cart.class, query, Redis.CacheLevel.LOW);
        } catch (Exception e) {
            cart = query.getSingleResult(); // fallback if cache fails
        }
        return cart;
    }
    // #endregion CART

    // #region CART ITEM
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
    
    // get cart item by cart, product and variations
    public CartItem getCartItemByCartAndProductAndVariation(Cart cart, product product, String selectedVariation) {

        int cartId = cart.getId();
        int productId = product.getId();
    
        TypedQuery<CartItem> query = db.createQuery(
            "SELECT c FROM CartItem c WHERE c.cart.id = :cartId AND c.product.id = :productId AND c.selectedVariation = :variation",
            CartItem.class
        )
        .setParameter("cartId", cartId)
        .setParameter("productId", productId)
        .setParameter("variation", selectedVariation);
    
        try {
            // Using Redis key composed of all identifying elements
            return cache.getOrCreate(
                "cartitem-" + cartId + "-" + productId + "-" + selectedVariation,
                CartItem.class,
                query,
                Redis.CacheLevel.LOW
            );
    
        } catch (Exception e) {
            // Fallback to database query if cache fails
            return query.getSingleResult(); // or null, depending on your design choice
        }
    }
    

    // Add a cart item
    public boolean addCartItem(CartItem cartItem) {
        try {
            db.getTransaction().begin();

            // ✅ Attach existing Cart entity
            if (cartItem.getCart() != null && cartItem.getCart().getId() > 0) {
                Cart cart = db.find(Cart.class, cartItem.getCart().getId());
                cartItem.setCart(cart);
            }

            // ✅ Attach existing Product entity
            if (cartItem.getProduct() != null && cartItem.getProduct().getId() > 0) {
                product product = db.find(product.class, cartItem.getProduct().getId());
                cartItem.setProduct(product);
            }

            // ✅ Use shared method to find if item already exists
            CartItem existingItem = getCartItemByCartAndProductAndVariation(
                cartItem.getCart(),
                cartItem.getProduct(),
                cartItem.getSelectedVariation()
            );

            if (existingItem != null) {
                int newQuantity = existingItem.getQuantity() + cartItem.getQuantity();
                existingItem.setQuantity(newQuantity);
                System.out.println("selected variation: " + cartItem.getSelectedVariation() + " quantity: " + newQuantity);
                db.merge(existingItem);
            } else {
                String createdAt = LocalDateTime.now().toString(); // Use LocalDateTime for createdAt
                cartItem.setCreatedAt(createdAt); // required for composite key
                db.persist(cartItem);
            }

            db.getTransaction().commit();
            return true;

        } catch (Exception e) {
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
            e.printStackTrace();
            return false;
        }
    }

    // remove cartItem
    public boolean deleteCartItem(Cart cart, product product, String selectedVariation) {
        try {
            db.getTransaction().begin();

            CartItem searchItem = getCartItemByCartAndProductAndVariation(cart, product, selectedVariation);

            if (searchItem == null) {
                db.getTransaction().rollback();
                return false; // Item not found
            }

            CartItem itemToRemove = db.find(CartItem.class, new CartItemId(
                searchItem.getCart(),
                searchItem.getProduct(),
                searchItem.getCreatedAt()
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

    public boolean deleteCartItem(CartItem cartItem) {
        try {
            db.getTransaction().begin();

            CartItem itemToRemove = db.find(CartItem.class, new CartItemId(
                cartItem.getCart(),
                cartItem.getProduct(),
                cartItem.getCreatedAt()
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

    // Update cart item quantity
    public boolean updateCartItemQuantity(CartItem cartItem, int delta) {
        try {
            db.clear(); // Clear persistence context to avoid stale state
    
            int newQuantity = cartItem.getQuantity() + delta;
            System.out.println("New quantity: " + newQuantity);
    
            if (newQuantity <= 0) {
                System.out.println("Trying to delete cartItem with ID: " + cartItem.getProduct().getId() + 
                                   " from cart with ID: " + cartItem.getCart().getId());
                return deleteCartItem(cartItem); // Use full object with createdAt to delete
            }
    
            db.getTransaction().begin();
    
            // Include `createdAt` in the composite key lookup
            CartItemId cartItemId = new CartItemId(
                cartItem.getCart(),
                cartItem.getProduct(),
                cartItem.getCreatedAt()
            );
    
            CartItem existingItem = db.find(CartItem.class, cartItemId);
    
            if (existingItem != null) {
                System.out.println("before merge --------------------------------------------------------");
                existingItem.setQuantity(newQuantity);
                db.merge(existingItem);
                db.getTransaction().commit();
                System.out.println("after merge --------------------------------------------------------");
                cartItem.setQuantity(newQuantity); // update caller object too
                return true;
            } else {
                System.out.println("CartItem not found for update.");
                db.getTransaction().rollback();
            }
    
        } catch (Exception e) {
            System.out.println("Error updating cart item quantity:-------------------------------------------------------- " +
                               e.getMessage() + "--------------------------------------------------------");
            e.printStackTrace();
            if (db.getTransaction().isActive()) db.getTransaction().rollback();
        }
        return false;
    }
    
}


