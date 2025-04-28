package Controllers;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.AccountDAO;
import DAO.CartDAO;
import DAO.UserDAO;
import DAO.productDAO;
import DTO.VoucherInfoDTO;
import Models.Accounts.PaymentCard;
import Models.Accounts.ShippingInformation;
import Models.Accounts.Voucher;
import Models.Products.product;
import Models.Users.Cart;
import Models.Users.CartItem;
import Models.Users.User;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.Authorization;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.ControllerBase;
import mvc.Helpers.SessionHelper;
import mvc.Http.HttpMethod;
import mvc.Result;


public class CartController extends ControllerBase{

    private CartDAO cartDAO = new CartDAO();
    private UserDAO userDA = new UserDAO();
    private productDAO productDAO = new productDAO();
    private AccountDAO accountDA = new AccountDAO();

    // Cart Index Page
    @Authorization(accessUrls = "Cart/cart")
    @SyncCache(channel = "CartItem", message ="from cart/index")
    public Result cart() throws Exception {
        SessionHelper session = getSessionHelper();
        if (session.isAuthenticated() == false) {
            return page("login", "Landing");
        }
        
        System.out.println("Cart Index Page");
        User user = userDA.getUserById(session.getUserSession().getId());
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
        List<product> bestSellers = productDAO.getBestSellingProducts();
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("shippingAddresses", shippingAddresses);
        request.setAttribute("bestSellers", bestSellers);
        

        return page();
    }

    // Cart Checkout Page
    @Authorization(accessUrls = "Cart/checkout")
    @SyncCache(channel = "CartItem", message ="from cart/cartCheckout")
    @HttpRequest(HttpMethod.POST)
    public Result checkout(String label, String receiverName, String phoneNumber, String state, String postCode, String addressLine1, String addressLine2, boolean isDefault) throws Exception {
        SessionHelper session = getSessionHelper();
        if (session.isAuthenticated() == false) {
            return page("login", "Landing");
        }

        System.out.println("Cart Checkout Page");
        User user = userDA.getUserById(session.getUserSession().getId());
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
                if (voucher.getType().equals("percentage")){

                    deduction = (subtotal * voucher.getAmount()) / 100;
                    if (deduction > voucher.getMaxCoverage()){
                        deduction = voucher.getMaxCoverage();
                    }
                    total = subtotal + shippingFee - deduction;

                } else if (voucher.getType().equals("flat")){

                    deduction = voucher.getAmount();
                    total = subtotal + shippingFee - deduction;
                    
                }

                voucherInfo.setDeduction(deduction);
                voucherInfo.setTotalAfterDeduction(total);

                voucherArray.add(voucherInfo);

            }
        }

        List<PaymentCard> paymentCards = accountDA.getPaymentCards(session.getUserSession().getId());


        request.setAttribute("cartItems", cartItems);
        request.setAttribute("shippingAddress", shippingAddress);
        request.setAttribute("voucherArray", voucherArray);
        request.setAttribute("subtotal", subtotal);
        request.setAttribute("shippingFee", shippingFee);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("paymentCards", paymentCards);


        
        return page();
    }

    // Get Cart Items by User ID
    // used by cart.jsp, header.jsp
    @Authorization(accessUrls = "Cart/getCartItems")
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

    // Add Cart Item by Product ID and Quantity
    // used by productPage.jsp
    @Authorization(accessUrls = "Cart/addToCartById")
    @ActionAttribute(urlPattern = "addToCartById")
    @SyncCache(channel = "CartItem", message ="from cart/addToCartById")
    @HttpRequest(HttpMethod.POST)
    public Result addToCart(int productId, int quantity, String selectedVariation) throws Exception{

        ObjectMapper mapper = new ObjectMapper();
        JsonNode jsonResponse = mapper.createObjectNode();
        SessionHelper session = getSessionHelper();

        User user = userDA.getUserById(session.getUserSession().getId()); // Replace with session-based user retrieval
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

    // Increase or Decrease Cart Item Quantity
    // used by cart.jsp, header.jsp
    @Authorization(accessUrls = "Cart/updateQuantity")
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

    // Remove Cart Item by Cart ID and Product ID
    // used by cart.jsp, header.jsp
    @Authorization(accessUrls = "Cart/removeCartItemById")
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

}
