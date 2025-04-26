package Controllers;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.AccountDA;
import DAO.CartDAO;
import DAO.UserDA;
import DAO.productDAO;
import DTO.VoucherInfoDTO;
import Models.Accounts.PaymentCard;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Products.product;
import Models.Users.Cart;
import Models.Users.CartItem;
import Models.Users.User;
import jakarta.servlet.annotation.WebServlet;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.ControllerBase;
import mvc.Http.HttpMethod;
import mvc.Result;



@WebServlet("/Cart/*")
public class CartController extends ControllerBase{

    private CartDAO cartDAO = new CartDAO();
    private UserDA userDA = new UserDA();
    private productDAO productDAO = new productDAO();
    private AccountDA accountDA = new AccountDA();

    @SyncCache(channel = "CartItem", message ="from cart/index")
    public Result cart() throws Exception {
        System.out.println("Cart Index Page");
        User user = userDA.getUserById(1);
        System.out.println("Cart Index Page after user");
        if (user == null) {
            return json("User not found");
        }
        List<ShippingInformation> shippingAddresses = accountDA.getShippingInformation(1);
        System.out.println("Cart Index Page after shippingAddresses");
        if (shippingAddresses != null) {
            for (ShippingInformation address : shippingAddresses) {
                System.out.println("Address: " + address.getLabel() + ", " + address.getReceiverName() + ", " + address.getPhoneNumber() + ", " + address.getState() + ", " + address.getPostCode() + ", " + address.getAddressLine1() + ", " + address.getAddressLine2());
            }
        }
        List<CartItem> cartItems = cartDAO.getCartItemsByUser(user);
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("shippingAddresses", shippingAddresses);
        

        return page();
    }

    @SyncCache(channel = "CartItem", message ="from cart/cartCheckout")
    @HttpRequest(HttpMethod.POST)
    public Result checkout(String label, String receiverName, String phoneNumber, String state, String postCode, String addressLine1, String addressLine2, boolean isDefault) throws Exception {

        System.out.println("Cart Checkout Page");
        User user = userDA.getUserById(1);
        if (user == null) {
            return json("User not found");
        }
        
        ShippingInformation shippingAddress = new ShippingInformation();
        shippingAddress.setLabel(label);
        shippingAddress.setReceiverName(receiverName);
        shippingAddress.setPhoneNumber(phoneNumber);
        shippingAddress.setState(state);
        shippingAddress.setPostCode(postCode);
        shippingAddress.setAddressLine1(addressLine1);
        shippingAddress.setAddressLine2(addressLine2);
        shippingAddress.setDefault(isDefault);

        List<CartItem> cartItems = cartDAO.getCartItemsByUser(user);
        int totalItems = 0;
        double subtotal = 0.0;
        double shippingFee = 25.0;
        for (CartItem item : cartItems) {
            subtotal += item.getProduct().getPrice() * item.getQuantity();
            totalItems += item.getQuantity();
        }
        if (subtotal > 1000) {
            shippingFee = 0.0;
        }


        List<Voucher> vouchers = accountDA.getAvailableVouchers(user, subtotal);
        List<VoucherInfoDTO> voucherArray = new ArrayList<>();
        
        if (vouchers != null && !vouchers.isEmpty()) {
            for (Voucher voucher : vouchers) {
                double total = subtotal + shippingFee;
                double deduction = 0;
                VoucherInfoDTO voucherInfo = accountDA.getVoucherInfo(voucher.getId(), user);
                voucherInfo.setDeduction(deduction);
                voucherInfo.setTotalAfterDeduction(total);

                //Calculate total after voucher deduction
                if (voucher.getType().equals("Percent")){

                    deduction = (subtotal * voucher.getAmount()) / 100;
                    if (deduction > voucher.getMaxCoverage()){
                        deduction = voucher.getMaxCoverage();
                    }
                    total = subtotal + shippingFee - deduction;

                } else if (voucher.getType().equals("Fixed")){

                    deduction = voucher.getAmount();
                    total = subtotal + shippingFee - deduction;
                    
                }

                voucherInfo.setDeduction(deduction);
                voucherInfo.setTotalAfterDeduction(total);

                voucherArray.add(voucherInfo);

            }
        }

        List<PaymentCard> paymentCards = accountDA.getPaymentCards(1);


        request.setAttribute("cartItems", cartItems);
        request.setAttribute("shippingAddress", shippingAddress);
        request.setAttribute("voucherArray", voucherArray);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("paymentCards", paymentCards);


        
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result getAvailableVouchers(int userId, double subtotal) throws Exception {
        System.out.println("Get Available Vouchers");
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode jsonResponse = mapper.createObjectNode();
    
        try {
            User user = userDA.getUserById(userId);
            if (user != null) {
                List<Voucher> vouchers = accountDA.getAvailableVouchers(user, subtotal);
    
                if (vouchers != null && !vouchers.isEmpty()) {
                    ArrayNode voucherArray = mapper.createArrayNode();
    
                    for (Voucher voucher : vouchers) {
                        VoucherInfoDTO voucherInfo = accountDA.getVoucherInfo(voucher.getId(), user);
    
                        ObjectNode voucherNode = mapper.createObjectNode();
                        voucherNode.put("voucher_id", voucher.getId());
                        voucherNode.put("voucher_name", voucher.getName());
                        voucherNode.put("voucher_desc", voucher.getDescription());
                        voucherNode.put("voucher_type", voucher.getType());
                        voucherNode.put("voucher_amount", voucher.getAmount());
                        voucherNode.put("voucher_max_coverage", voucher.getMaxCoverage());
                        voucherNode.put("voucher_minimum_spend", voucher.getMinSpent());
                        voucherNode.put("voucher_usage_left", voucherInfo.getUsageLeft());
                        voucherNode.put("voucher_usage_limit", voucher.getUsagePerMonth());
    
                        voucherArray.add(voucherNode);
                    }
    
                    jsonResponse.put("success", true);
                    jsonResponse.set("available_vouchers", voucherArray);
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("error_msg", "No vouchers available for current subtotal.");
                }
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("error_msg", "User not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("success", false);
            jsonResponse.put("error_msg", e.getMessage());
        }
    
        return json(jsonResponse);
    }

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
    @HttpRequest(HttpMethod.POST)
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
                        cartItemNode.put("cart_id", item.getCart().getId());
                        cartItemNode.put("product_id", item.getProduct().getId());
                        cartItemNode.put("product_name", item.getProduct().getTitle());
                        cartItemNode.put("product_img_id", item.getProduct().getImage().getId());
                        cartItemNode.put("product_category", item.getProduct().getTypeId().gettype());
                        cartItemNode.put("product_price", item.getProduct().getPrice());
                        cartItemNode.put("quantity", item.getQuantity());
                        cartItemNode.put("selected_variation", item.getSelectedVariation());
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
    @SyncCache(channel = "CartItem", message ="from cart/addToCart")
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

    @ActionAttribute(urlPattern = "addToCartById")
    @SyncCache(channel = "CartItem", message ="from cart/addToCartById")
    @HttpRequest(HttpMethod.POST)
    public Result addToCart(int productId, int quantity, String selectedVariation) throws Exception{

        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();

        User user = userDA.getUserById(1); // Replace with session-based user retrieval
        product product = null;
        Cart cart = null;
        try {
            cart = cartDAO.getCartByUser(user.getId());
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("getCart_success", false);
            ((ObjectNode) jsonResponse).put("error msg", "Cart not found");
            return json(jsonResponse);
        }
        try {
            product = productDAO.searchProducts(productId);
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("getProduct_success", false);
            ((ObjectNode) jsonResponse).put("error msg", "Product not found");
            return json(jsonResponse);
        }
        try {
            System.out.println("Using Selected Variation: " + selectedVariation);
            CartItem cartItem = new CartItem(cart, product, quantity, selectedVariation, LocalDateTime.now().toString());
            if (cartDAO.addCartItem(cartItem)) {
                ((ObjectNode) jsonResponse).put("addToCart_success", true);
                ((ObjectNode) jsonResponse).put("cart_user", user.getUsername());
                ((ObjectNode) jsonResponse).put("cart_item_quantity", cartItem.getQuantity());
                ((ObjectNode) jsonResponse).put("cart_item_selected_variation", cartItem.getSelectedVariation());
                ((ObjectNode) jsonResponse).put("cart_id", cartItem.getCart().getId());
                ((ObjectNode) jsonResponse).put("cart_item_name", cartItem.getProduct().getTitle());
                return json(jsonResponse);
            } else {
                ((ObjectNode) jsonResponse).put("addToCart_success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Cart item already exists");
                return json(jsonResponse);
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("addToCart_success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
            return json(jsonResponse);
        }
    }

    // Increase Cart Item Quantity
    @SyncCache(channel = "CartItem", message ="from cart/increaseCartItemQuantity")
    @HttpRequest(HttpMethod.POST)
    public Result updateQuantity(int cartId, int productId, String selectedVariation, int delta) throws Exception {

        System.out.println("Update Cart Item Quantity");
        System.out.println("Cart ID: " + cartId);   
        System.out.println("Product ID: " + productId);
        System.out.println("Selected Variation: " + selectedVariation);
        System.out.println("Delta: " + delta);
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();
        Cart cart = null;
        product product = null;
        CartItem cartItem = null;
        try{
            cart = cartDAO.getCartById(cartId);
            System.out.println("Cart #1: " + cart.getId());
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("update_success", false);
            ((ObjectNode) jsonResponse).put("error msg", "Cart not found");
            return json(jsonResponse);
        }
        try{
            product = productDAO.searchProducts(productId);
            System.out.println("Product #2: " + product.getId());
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("update_success", false);
            ((ObjectNode) jsonResponse).put("error msg", "Product not found");
            return json(jsonResponse);
        }
        
        try {
            if (selectedVariation == null || selectedVariation.isEmpty()) {
                selectedVariation = "default"; // Provide a default value if necessary
            }
            System.out.println("Using Selected Variation: " + selectedVariation);
            cartItem = cartDAO.getCartItemByCartAndProductAndVariation(cart, product, selectedVariation);
        } catch (Exception e) {
            System.out.println("Error in getCartItemByCartAndProductAndVariation");
            ((ObjectNode) jsonResponse).put("update_success", false);
            ((ObjectNode) jsonResponse).put("error msg", "Cart item not found");
            return json(jsonResponse);
        }

        try {
            System.out.println("here #4 updateCartItemQuantity");
            if (cartDAO.updateCartItemQuantity(cartItem, delta)) {
                
                ((ObjectNode) jsonResponse).put("update_success", true);
                ((ObjectNode) jsonResponse).put("quantity", cartItem.getQuantity());
                ((ObjectNode) jsonResponse).put("selected_variation", cartItem.getSelectedVariation());
                ((ObjectNode) jsonResponse).put("cart_id", cartItem.getCart().getId());
                ((ObjectNode) jsonResponse).put("cart_item_name", cartItem.getProduct().getTitle());
            } else {
                System.out.println("here #4 updateCartItemQuantity if false");
                ((ObjectNode) jsonResponse).put("update_success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Cart item not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("update_success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }

        return json(jsonResponse);
    }

    // Remove Cart Item
    @SyncCache(channel = "CartItem", message ="from cart/removeCartItem")
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

    // Remove Cart Item by Cart ID and Product ID
    @SyncCache(channel = "CartItem", message ="from cart/removeCartItemById")
    @HttpRequest(HttpMethod.POST)
    public Result removeCartItemById(int cartId, int productId) throws Exception {

        System.out.println("Remove Cart Item");
        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();
        Cart cart = null;
        product product = null;
        CartItem cartItem = null;
        try{
            cart = cartDAO.getCartById(cartId);
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("remove_success", false);
            ((ObjectNode) jsonResponse).put("error msg", "Cart not found");
            return json(jsonResponse);
        }
        try{
            product = productDAO.searchProducts(productId);
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("remove_success", false);
            ((ObjectNode) jsonResponse).put("error msg", "Product not found");
            return json(jsonResponse);
        }
        try {
            cartItem = cartDAO.getCartItemByCartAndProduct(cart, product);
        }   catch (Exception e) {
            ((ObjectNode) jsonResponse).put("remove_success", false);
            ((ObjectNode) jsonResponse).put("error msg", "Cart item not found");
            return json(jsonResponse);
        }

        try {
            if (cartDAO.deleteCartItem(cartItem)) {
                ((ObjectNode) jsonResponse).put("remove_success", true);
            } else {
                ((ObjectNode) jsonResponse).put("remove_success", false);
                ((ObjectNode) jsonResponse).put("error msg", "Cart item not found");
            }
        } catch (Exception e) {
            ((ObjectNode) jsonResponse).put("remove_success", false);
            ((ObjectNode) jsonResponse).put("error msg", e.getMessage());
        }

        return json(jsonResponse);
    }

    // Clear Cart by User ID
    @SyncCache(channel = "CartItem", message ="from cart/clearCart")
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
