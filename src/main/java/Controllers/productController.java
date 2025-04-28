package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.Authorization;
import mvc.Annotations.HttpRequest;
import mvc.Http.HttpMethod;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.sql.rowset.serial.SerialBlob;
import java.sql.Blob;

import com.fasterxml.jackson.databind.ObjectMapper;

import DAO.productDAO;
import DTO.productDTO;
import Models.Products.product;
import Models.Products.productFeedback;
import Models.Products.productFeedbackKey;
import Models.Products.productImage;
import Models.Products.productType;
import Models.Products.productVariationOptions;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 5 * 1024 * 1024, // 5 MB
        maxRequestSize = 10 * 1024 * 1024 // 10 MB
)

public class productController extends ControllerBase {
    private productDAO productDAO = new productDAO(); // Assuming you have a DAO class for product

    @ActionAttribute(urlPattern = "productPage")
    public Result productPage() throws Exception {
        if (request.getParameter("id") == null) {
            System.out.println("⚠ No product ID provided in the request.");
        }
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
        // System.out.println("📦 Product Image URL: " + p.getImageUrl());
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

        List<product> productsFeatured = productDAO.getFeaturedProducts();
        System.out.println("📦 Featured Products: " + productsFeatured.size());
        request.setAttribute("featuredProducts", productsFeatured);

        request.setAttribute("product", p);
        request.setAttribute("variationOptions", options);
        request.setAttribute("feedbackList", feedbackList);

        return page();
    }

    public Result productCatalog() throws Exception {

        List<productType> types = productDAO.getAllProductTypes();
        request.setAttribute("productTypes", types);
        System.out.println("📦 Product Types: " + types.size());
        List<product> products = productDAO.getAllProducts();
        System.out.println("📦 Products: " + products.size());
        request.setAttribute("products", products);
        // for (product p : products) {
        // if (p.getImage() != null) {
        // System.out.println("📩 Image = " + p.getImage().getId());
        // } else {
        // System.out.println("No image available for product ID: " + p.getId());
        // }
        // }

        for (product p : products) {
            System.out.println("🔍 Product ID: " + p.getId());
            System.out.println("🔍 Product Title: " + p.getTitle());
            System.out.println("🔍 Product Price: " + p.getPrice());
            System.out.println("🔍 Product Stock: " + p.getStock());
            System.out.println("🔍 Product Type: " + (p.getTypeId() != null ? p.getTypeId().gettype() : "No Type"));
            System.out.println("🔍 Product Description: " + p.getDescription());
            System.out.println("🔍 Product Featured: " + p.getFeatured());
            if (p.getImage() != null) {
                System.out.println("🔍 Product Image ID: " + p.getImage().getId());
            } else {
                System.out.println("🔍 No image available for this product.");
            }
        }

        return page();

    }

    public Result productCatalog(String productTypeId) throws Exception {

        List<productType> types = productDAO.getAllProductTypes();
        request.setAttribute("productTypes", types);

        List<product> products = productDAO.getAllProducts();

        request.setAttribute("products", products);
        for (product p : products) {
            if (p.getImage() != null) {
                System.out.println("📩 Image       = " + p.getImage().getId());
            } else {
                System.out.println("No image available for product ID: " + p.getId());
            }
        }

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
    @Authorization(accessUrls = "product/addProduct")
    @ActionAttribute(urlPattern = "productCatalog/addProduct")
    @HttpRequest(HttpMethod.POST)
    public Result addProduct() throws Exception {
        // image
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

        System.out.println("📩 title       = " + title);
        System.out.println("📩 description = " + desc);
        System.out.println("📩 priceRaw    = " + priceRaw);
        System.out.println("📩 stockRaw    = " + stockRaw);
        System.out.println("📩 typeIdRaw   = " + typeIdRaw);
        System.out.println("📩 retailInfo  = " + retailInfo);
        System.out.println("📩 slug        = " + slug);
        System.out.println("📩 featured    = " + featured);
        System.out.println("🧩 Raw variations JSON: " + variationsJson);

        Part imagePart = request.getPart("imageFile");
        if (imagePart == null || imagePart.getSize() == 0) {
            System.out.println("⚠ No image uploaded");
            return error("Please select an image file");
        }
        System.out.println("📩 imageFile size = " + imagePart.getSize());

        byte[] imgBytes = imagePart.getInputStream().readAllBytes();
        Blob blob = new SerialBlob(imgBytes);
        System.out.println("✅ Read image bytes, length=" + imgBytes.length);

        double price = Double.parseDouble(priceRaw);
        int stock = Integer.parseInt(stockRaw);
        int typeId = Integer.parseInt(typeIdRaw);

        productType type = productDAO.findTypeById(typeId);
        if (type == null) {
            System.out.println("❌ invalid typeId: " + typeId);
            return error("Invalid category");
        }
        System.out.println("✅ found category: " + type.gettype());

        productImage pi = new productImage();
        pi.setData(blob);
        productDAO.addProductImage(pi);
        System.out.println("🗃️ Saved image, id=" + pi.getId());

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
        newProduct.setImage(pi); // link the image

        try {

            productDAO.addProduct(newProduct);
            System.out.println("✅ product persisted, id=" + newProduct.getId());

        } catch (Exception ex) {
            ex.printStackTrace();
            return error("Error saving product");
        }

        // 7. redirect to catalog
        response.sendRedirect(request.getContextPath() + "/product/productCatalog?created=1");
        return null;

    }

    @Authorization(accessUrls = "deleteProduct")
    @ActionAttribute(urlPattern = "deleteProduct")
    @HttpRequest(HttpMethod.POST)
    public Result deleteProduct() throws Exception {
        int id = Integer.parseInt(request.getParameter("productId"));
        System.out.println("🗑️ Deleting product with ID: " + id);
        productDAO.deleteProduct(id);
        response.sendRedirect(request.getContextPath() + "/product/productCatalog?deleted=1");
        return null;
    }

    @Authorization(accessUrls = "updateProduct")
    @ActionAttribute(urlPattern = "updateProduct")
    @HttpRequest(HttpMethod.POST)
    public Result updateProduct() throws Exception {
        int id = Integer.parseInt(request.getParameter("productId"));
        System.out.println("🔄 Update ID : " + id);

        // === read form fields ===
        String title = request.getParameter("title");
        String desc = request.getParameter("description");
        String priceRaw = request.getParameter("price");
        String stockRaw = request.getParameter("stock");
        String typeIdRaw = request.getParameter("typeId");
        String retailInfo = request.getParameter("retailInfo");
        String slug = request.getParameter("slug");
        boolean featured = request.getParameter("featured") != null;
        String variationsJson = request.getParameter("variations");
        System.out.println("🧩 Raw variations JSON: " + variationsJson);
        if (variationsJson == null || variationsJson.isEmpty()) {
            variationsJson = "{}";
        }

        System.out.println("📩 title       = " + title);
        System.out.println("📩 description = " + desc);
        System.out.println("📩 priceRaw    = " + priceRaw);
        System.out.println("📩 stockRaw    = " + stockRaw);
        System.out.println("📩 typeIdRaw   = " + typeIdRaw);
        System.out.println("📩 retailInfo  = " + retailInfo);
        System.out.println("📩 slug        = " + slug);
        System.out.println("📩 featured    = " + featured);
        System.out.println("📩 variationsJson = " + variationsJson);

        // === parse numbers & validate type ===
        double price = Double.parseDouble(priceRaw);
        int stock = Integer.parseInt(stockRaw);
        int typeId = Integer.parseInt(typeIdRaw);
        productType type = productDAO.findTypeById(typeId);
        if (type == null) {
            System.out.println("❌ invalid typeId: " + typeId);
            return error("Invalid category");
        }
        System.out.println("✅ found category: " + type.gettype());

        // === handle new image upload (optional) ===
        Part imagePart = request.getPart("imageFile");
        productImage pi;
        if (imagePart != null && imagePart.getSize() > 0) {
            System.out.println("📩 new imageFile size = " + imagePart.getSize());
            byte[] imgBytes = imagePart.getInputStream().readAllBytes();
            Blob blob = new SerialBlob(imgBytes);
            System.out.println("✅ Read new image bytes, length=" + imgBytes.length);

            // Persist new image
            pi = new productImage();
            pi.setData(blob);
            productDAO.addProductImage(pi);
            System.out.println("🗃️ Saved new image, id=" + pi.getId());
        } else {
            System.out.println("⚠ No new image uploaded, keeping existing.");
            // load existing product (with FETCH JOIN p.image) to get its image
            product existing = productDAO.searchProducts(id);
            pi = existing.getImage();
        }

        // === build updated product and associate image ===
        product updated = new product();
        updated.setId(id);
        updated.setTitle(title);
        updated.setDescription(desc);
        updated.setPrice(price);
        updated.setStock(stock);
        updated.setTypeId(type);
        updated.setRetailInfo(retailInfo);
        updated.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
        updated.setVariations(variationsJson);
        updated.setSlug(slug);
        updated.setFeatured(featured ? 1 : 0);
        updated.setImage(pi);

        // === persist update ===
        try {
            productDAO.updateProduct(updated);
            System.out.println("✅ product updated, id=" + updated.getId());
        } catch (Exception ex) {
            ex.printStackTrace();
            return error("Error updating product");
        }

        // redirect
        response.sendRedirect(request.getContextPath() + "/product/productCatalog?updated=1");
        return null;
    }

    @Authorization(accessUrls = "feedback/reply")
    @ActionAttribute(urlPattern = "feedback/reply")
    @HttpRequest(HttpMethod.POST)
    public Result replyFeedback() throws Exception {
        int productId = Integer.parseInt(request.getParameter("productId"));
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String createdAt = request.getParameter("createdAt");
        String reply = request.getParameter("reply").trim();

        productFeedbackKey key = new productFeedbackKey(productId, orderId, createdAt);
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
