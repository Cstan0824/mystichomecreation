package Controllers;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.CartDAO;
import DAO.UserDA;
import Models.Users.Cart;
import Models.Users.CartItem;
import Models.Users.User;
import jakarta.servlet.annotation.WebServlet;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.ControllerBase;
import mvc.Http.HttpMethod;
import mvc.Result;



@WebServlet("/cart/*")
public class CartController extends ControllerBase{

    private CartDAO cartDAO = new CartDAO();
    private UserDA userDA = new UserDA();

    // Add New Cart to New User
    // This method is called when a new user is created and a cart is created for them.
    @SyncCache(channel = "user", message ="from cart/addCart")
    @HttpRequest(HttpMethod.POST)
    public Result addCart(Cart cart) throws Exception {

        System.out.println("Add New Cart");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            if (cartDAO.createCart(cart)) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("cart_id", cart.getId());
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }

        return json(jsonResponse);

    }

    // Get Cart by User ID
    @SyncCache(channel = "user", message ="from cart/getCart")
    @HttpRequest(HttpMethod.GET)
    public Result getCart(int userId) throws Exception {
        System.out.println("Get Cart by User ID");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            User user = userDA.getUserById(userId);
            if (user != null){
                Cart cart = cartDAO.getCartByUser(userId);
                if (cart != null) {
                    ((ObjectNode) jsonResponse).put("success", true);
                    ((ObjectNode) jsonResponse).put("username", user.getUsername());
                    ((ObjectNode) jsonResponse).put("cart_id", cart.getId());
                } else {
                    ((ObjectNode) jsonResponse).put("success", false);
                    ((ObjectNode) jsonResponse).put("error msg", "Cart not found");
                }
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }

        return json(jsonResponse);
    }

    // Get Cart Items by User ID
    @SyncCache(channel = "user", message ="from cart/getCartItems")
    @HttpRequest(HttpMethod.GET)
    public Result getCartItems(int userId) throws Exception {
        System.out.println("Get Cart Items by User ID");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            User user = userDA.getUserById(userId);
            if (user != null){
                
                System.out.println("User: " + user.getUsername());
                List<CartItem> cartItems = cartDAO.getCartItemsByUser(user);
                System.out.println("Cart Items: " + cartItems);
                
                if (cartItems != null) {
                    ArrayNode cartItemArray = mapper.createArrayNode();
                    System.out.println("Cart Items: " + cartItems.size());

                    for (CartItem item : cartItems) {
                        ObjectNode cartItemNode = mapper.createObjectNode();
                        cartItemNode.put("cart_item_name", item.getProduct().getTitle());
                        cartItemNode.put("cart_item_quantity", item.getQuantity());
                        cartItemNode.put("cart_item_selected_variation", item.getSelectedVariation());
                        cartItemArray.add(cartItemNode);
                    }
                    System.out.println("Cart Items 2: " + cartItems.size());
                    

                    ((ObjectNode) jsonResponse).put("success", true);
                    ((ObjectNode) jsonResponse).put("cart_user", user.getUsername());
                    ((ObjectNode) jsonResponse).set("cart_items", cartItemArray); // <-- attach the list

                } else {
                    ((ObjectNode) jsonResponse).put("success", false);
                    ((ObjectNode) jsonResponse).put("error msg", "Cart items not found");
                }
            } else {
                System.out.println("User not found");
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Cart not found");
            }
        
        } catch (Exception e) {
            System.out.println("Exception: " + e.getMessage());

            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }
        System.out.println("Response: " + jsonResponse.toString());
        return json(jsonResponse);
    }

    // Add Cart Item
    @SyncCache(channel = "user", message ="from cart/addToCart")
    @HttpRequest(HttpMethod.POST)
    public Result addToCart(CartItem cartItem) throws Exception {

        System.out.println("Add Cart Item");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            if (cartDAO.addCartItem(cartItem)) {
                ((ObjectNode) jsonResponse).put("success", true);
                ((ObjectNode) jsonResponse).put("cart_user", cartItem.getCart().getUser().getUsername());
                ((ObjectNode) jsonResponse).put("cart_item_quantity", cartItem.getQuantity());
                ((ObjectNode) jsonResponse).put("cart_item_selected_variation", cartItem.getSelectedVariation());
                ((ObjectNode) jsonResponse).put("cart_id", cartItem.getCart().getId());
                ((ObjectNode) jsonResponse).put("cart_item_name", cartItem.getProduct().getTitle());
            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Cart item already exists");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }

        return json(jsonResponse);
    }

    // Update Cart Item
    @SyncCache(channel = "user", message ="from cart/updateCartItem")
    @HttpRequest(HttpMethod.POST)
    public Result updateCartItems(CartItem cartItem) throws Exception {

        System.out.println("Update Cart Item");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        if(cartItem.getQuantity() <= 0){
            return removeCartItem(cartItem);
        }

        try {
            if (cartDAO.updateCartItem(cartItem)) {
                ((ObjectNode) jsonResponse).put("success", true);
            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Cart item not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }

        return json(jsonResponse);
    }

    // Remove Cart Item
    @SyncCache(channel = "user", message ="from cart/removeCartItem")
    @HttpRequest(HttpMethod.POST)
    public Result removeCartItem(CartItem cartItem) throws Exception {

        System.out.println("Remove Cart Item");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            if (cartDAO.deleteCartItem(cartItem)) {
                ((ObjectNode) jsonResponse).put("success", true);
            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Cart item not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }

        return json(jsonResponse);
    }

    // Clear Cart by User ID
    @SyncCache(channel = "user", message ="from cart/clearCart")
    @HttpRequest(HttpMethod.POST)
    public Result clearCart(int userId) throws Exception {
        System.out.println("Clear Cart by User ID");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        try {
            User user = userDA.getUserById(userId);
            if (user != null){
                List<CartItem> cartItems = cartDAO.getCartItemsByUser(user);
                if (cartItems != null) {
                    for (CartItem item : cartItems) {
                        cartDAO.deleteCartItem(item);
                    }
                    ((ObjectNode) jsonResponse).put("success", true);
                } else {
                    ((ObjectNode) jsonResponse).put("success", false);
                    ((ObjectNode) jsonResponse).put("error msg", "Cart items not found");
                }
            } else {
                ((ObjectNode) jsonResponse).put("success", false);
                ((ObjectNode) jsonResponse).put("error msg", "User not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }

        return json(jsonResponse);
    }


}
