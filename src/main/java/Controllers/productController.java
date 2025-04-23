package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Helpers.JsonConverter;
import mvc.Http.HttpMethod;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import DAO.productDAO;
import Models.Products.product;
import Models.Products.productDTO;
import Models.Products.productFeedback;
import Models.Products.productFeedbackKey;
import Models.Products.productType;
import Models.Products.productVariationOptions;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Part;

@WebServlet("/product/*")
public class productController extends ControllerBase {
    private productDAO productDAO = new productDAO(); // Assuming you have a DAO class for product

    // // return the page products.jsp
    // @ActionAttribute (urlPattern = "products") //optional
    // public Result products() throws Exception {
    // List<product> products = productDAO.getAllProducts();
    // request.setAttribute("products", products); // Set the products list in the
    // request scope
    // return page();
    // }

    // //need to get the db data and then send to the products.jsp
    // //@ActionAttribute (urlPattern = "getProducts") //optional - this is the
    // default url pattern
    // public Result getProducts() throws Exception {
    // // Get all products from the database
    // List<product> products = productDAO.getAllProducts();
    // ObjectMapper mapper = new ObjectMapper();

    // // Convert the products list to JSON format
    // String productsJson = mapper.writeValueAsString(products);
    // return json(productsJson); // Return the JSON response
    // }

    @ActionAttribute(urlPattern = "productPage")
    public Result productPage() throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        product p = productDAO.searchProducts(id);
        System.out.println("✅ Product found: " + p);
        System.out.println("📦 Product ID: " + p.getId());
        System.out.println("📦 Product Title: " + p.getTitle());
        System.out.println("📦 Product Price: " + p.getPrice());
        System.out.println("📦 Product Stock: " + p.getStock());
        System.out.println("📦 Product Type: " + p.getTypeId().gettype());
        System.out.println("📦 Product Description: " + p.getDescription());
        System.out.println("📦 Product Retail Info: " + p.getRetailInfo());
        System.out.println("📦 Product Created Date: " + p.getCreatedDate());
        System.out.println("📦 Product Image URL: " + p.getImageUrl());
        System.out.println("📦 Product Featured: " + p.getFeatured());

        productVariationOptions options = null;

        try {
            String rawJson = p.getVariations();
            System.out.println("📦 Raw JSON: " + rawJson);

            if (rawJson != null && !rawJson.trim().isEmpty()) {
                ObjectMapper objectMapper = new ObjectMapper();

                // Deserialize JSON directly to Map<String, List<String>>
                Map<String, List<String>> variationMap = objectMapper.readValue(
                        rawJson, new com.fasterxml.jackson.core.type.TypeReference<Map<String, List<String>>>() {
                        });

                options = new productVariationOptions();
                options.setOptions(variationMap);

                System.out.println("✅ Parsed variation keys: " + variationMap.keySet());
            } else {
                System.out.println("⚠ Variation JSON is empty or null.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("❌ Failed to parse variations JSON", e);
        }

        List<productFeedback> feedbackList = productDAO.getFeedbackWithUserAndProduct(id);
        System.out.println("📝 Feedback count: " + (feedbackList != null ? feedbackList.size() : 0));
        for (productFeedback fb : feedbackList) {
            System.out.println("⭐ Feedback: " + fb.getRating() + " - " + fb.getComment());
        }

        List<productType> types = productDAO.getAllProductTypes();
        request.setAttribute("productTypes", types);

        request.setAttribute("product", p);
        request.setAttribute("variationOptions", options);
        request.setAttribute("feedbackList", feedbackList);

        return page();
    }

    // only return the products and the types
    @ActionAttribute(urlPattern = "productCatalog")
    public Result productCatalog() throws Exception {

        List<productType> types = productDAO.getAllProductTypes();
        request.setAttribute("productTypes", types);

        List<product> products = productDAO.getAllProducts();

        request.setAttribute("products", products);
        return page();
    }

    @ActionAttribute(urlPattern = "productCatalog/Categories")
    public Result getProductsByCategories() throws Exception {
        String[] selectedCategories = request.getParameterValues("categories");
        System.out.println("Selected Categories: " + Arrays.toString(selectedCategories));
        
        // convert the selected categories to a list of integers
        List<Integer> categoryIds = selectedCategories != null
                ? Arrays.stream(selectedCategories).map(Integer::parseInt).toList()
                : new ArrayList<>();

        System.out.println("📦 Category IDs: " + categoryIds);

        // Get the min and max price from the request parameters
        String minPriceRaw = request.getParameter("minPrice");
        String maxPriceRaw = request.getParameter("maxPrice");

        // for safety check , force it to be double
        Double minPrice = minPriceRaw != null && !minPriceRaw.isEmpty() ? Double.parseDouble(minPriceRaw) : null;
        Double maxPrice = maxPriceRaw != null && !maxPriceRaw.isEmpty() ? Double.parseDouble(maxPriceRaw) : null;

        System.out.println("💰 Min price: " + minPrice + " | Max price: " + maxPrice);

        // Get Sort Option
        String sortBy = request.getParameter("sortBy");
        System.out.println("🔄 Sort by: " + sortBy);

        String keywords = request.getParameter("keyword");
        System.out.println("🔍 Keywords: " + keywords);

        List<product> filteredProducts = productDAO.filterProducts(categoryIds, minPrice, maxPrice, sortBy, keywords);
        System.out.println("✅ DAO returned products: " + filteredProducts.size());

        List<productDTO> dtos = filteredProducts.stream().map(productDTO::new).toList();

        System.out.println("🚀 Returning product DTOs as JSON");

        return json(dtos); // Convert to JSON and return

    }

    // This is to add product
    @ActionAttribute(urlPattern = "productCatalog/addProduct")
    @HttpRequest(HttpMethod.POST)
    public Result addProduct() throws Exception {
        // image
        String imageFile = request.getParameter("imageFile");
        String title = request.getParameter("title");
        String desc = request.getParameter("description");
        String priceRaw = request.getParameter("price");
        String stockRaw = request.getParameter("stock");
        String typeIdRaw = request.getParameter("typeId");
        String retailInfo = request.getParameter("retailInfo");
        String slug = request.getParameter("slug");
        boolean featured = request.getParameter("featured") != null; // this is a checkbox so if it is checked it will
                                                                     // be true
        String variationsJson = request.getParameter("variations");

        if (variationsJson == null || variationsJson.isEmpty()) {
            variationsJson = "{}"; // set to empty json if it is null or empty
        }

        // Part imagePart = request.getPart("imageFile");

        // if(imagePart != null && imagePart.getSize() > 0){

        // // read the image file as bytes
        // byte[] bytes = imagePart.getInputStream().readAllBytes();

        // //
        // FileController fileController = new FileController();
        // Result uploadResult = fileController.uploadProduct(new byte[][]{bytes});
        // //Wraps single image in a 2D array
        // JsonNode json = (JsonNode) uploadResult.getData();
        // String fileName = json.get("fileName").asText();
        // }

        System.out.println("📩 title       = " + title);
        System.out.println("📩 description = " + desc);
        System.out.println("📩 priceRaw    = " + priceRaw);
        System.out.println("📩 stockRaw    = " + stockRaw);
        System.out.println("📩 typeIdRaw   = " + typeIdRaw);
        System.out.println("📩 retailInfo  = " + retailInfo);
        System.out.println("📩 slug        = " + slug);
        System.out.println("📩 featured    = " + featured);
        System.out.println("🧩 Raw variations JSON: " + variationsJson);
        System.out.println("📩 imageFile    = " + imageFile);

        double price = Double.parseDouble(priceRaw);
        int stock = Integer.parseInt(stockRaw);
        int typeId = Integer.parseInt(typeIdRaw);

        productType type = productDAO.findTypeById(typeId);
        if (type == null) {
            System.out.println("❌ invalid typeId: " + typeId);
            return error("Invalid category");
        }
        System.out.println("✅ found category: " + type.gettype());

        product newProduct = new product();
        newProduct.setTitle(title);
        newProduct.setDescription(desc);
        newProduct.setPrice(price);
        newProduct.setStock(stock);
        newProduct.setTypeId(type);
        newProduct.setRetailInfo(retailInfo);
        newProduct.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
        newProduct.setVariations(variationsJson);
        newProduct.setSlug(slug);
        newProduct.setFeatured(featured ? 1 : 0);

        try {

            if (productDAO.isProductNameExists(title) == true) {
                System.out.println("❌ Product name already exists: " + title);
                return error("Product name already exists");
            } else {
                productDAO.addProduct(newProduct);
                System.out.println("✅ product persisted, id=" + newProduct.getId());
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            return error("Error saving product");
        }

        // 7. redirect to catalog
        response.sendRedirect(request.getContextPath() + "/product/productCatalog?created=1");
        return null;

    }

    @ActionAttribute(urlPattern = "deleteProduct")
    @HttpRequest(HttpMethod.POST)
    public Result deleteProduct() throws Exception {
        int id = Integer.parseInt(request.getParameter("productId"));
        System.out.println("🗑️ Deleting product with ID: " + id);
        productDAO.deleteProduct(id);
        response.sendRedirect(request.getContextPath() + "/product/productCatalog?deleted=1");
        return null;
    }

    @ActionAttribute(urlPattern = "updateProduct")
    @HttpRequest(HttpMethod.POST)
    public Result updateProduct() throws Exception {
        int id = Integer.parseInt(request.getParameter("productId"));
        System.out.println("Update ID : " + id);

        String title = request.getParameter("title");
        String desc = request.getParameter("description");
        String priceRaw = request.getParameter("price");
        String stockRaw = request.getParameter("stock");
        String typeIdRaw = request.getParameter("typeId");
        String retailInfo = request.getParameter("retailInfo");
        String imageUrl = request.getParameter("imageUrl");
        String slug = request.getParameter("slug");
        boolean featured = request.getParameter("featured") != null; // this is a checkbox so if it is checked it will
                                                                     // be true
        String variationsJson = request.getParameter("variations");
        System.out.println("🧩 Raw variations JSON: " + variationsJson);

        if (variationsJson == null || variationsJson.isEmpty()) {
            variationsJson = "{}"; // set to empty json if it is null or empty
        }

        System.out.println("📩 title       = " + title);
        System.out.println("📩 description = " + desc);
        System.out.println("📩 priceRaw    = " + priceRaw);
        System.out.println("📩 stockRaw    = " + stockRaw);
        System.out.println("📩 typeIdRaw   = " + typeIdRaw);
        System.out.println("📩 retailInfo  = " + retailInfo);
        System.out.println("📩 imageUrl    = " + imageUrl);
        System.out.println("📩 slug        = " + slug);
        System.out.println("📩 featured    = " + featured);
        System.out.println("📩 variationsJson = " + variationsJson);

        double price = Double.parseDouble(priceRaw);
        int stock = Integer.parseInt(stockRaw);
        int typeId = Integer.parseInt(typeIdRaw);

        productType type = productDAO.findTypeById(typeId);
        if (type == null) {
            System.out.println("❌ invalid typeId: " + typeId);
            return error("Invalid category");
        }
        System.out.println("✅ found category: " + type.gettype());

        product newProduct = new product();
        newProduct.setId(id); // set the id of the product to be updated
        newProduct.setTitle(title);
        newProduct.setDescription(desc);
        newProduct.setPrice(price);
        newProduct.setStock(stock);
        newProduct.setTypeId(type);
        newProduct.setRetailInfo(retailInfo);
        newProduct.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
        newProduct.setVariations(variationsJson);
        newProduct.setSlug(slug);
        newProduct.setImageUrl(imageUrl);
        newProduct.setFeatured(featured ? 1 : 0);

        try {
            productDAO.updateProduct(newProduct);
            System.out.println("✅ product updated, id=" + newProduct.getId());

        } catch (Exception ex) {
            ex.printStackTrace();
            return error("Error saving product");
        }

        // 7. redirect to catalog
        response.sendRedirect(request.getContextPath() + "/product/productCatalog?updated=1");
        return null;

    }

    @ActionAttribute(urlPattern = "feedback/reply")
    @HttpRequest(HttpMethod.POST)
    public Result replyFeedback() throws Exception {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String reply = request.getParameter("reply").trim();

        productFeedbackKey key = new productFeedbackKey(productId, orderId);
        productFeedback fb = productDAO.findById(key);
        if (fb == null) {
            return error("Feedback not found");
        }
        fb.setReply(reply);
        fb.setReplyDate(new java.sql.Date(System.currentTimeMillis()));
        productDAO.replyToFeedback(fb);

        return success("Reply sent successfully");

    }

}
