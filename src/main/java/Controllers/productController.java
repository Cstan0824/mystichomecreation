package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Helpers.JsonConverter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.fasterxml.jackson.databind.ObjectMapper;

import DAO.productDAO;
import Models.Products.product;
import Models.Products.productDTO;
import Models.Products.productFeedback;
import Models.Products.productType;
import Models.Products.productVariationOptions;
import jakarta.servlet.annotation.WebServlet;



@WebServlet("/product/*")
public class productController extends ControllerBase {
    private productDAO productDAO = new productDAO(); // Assuming you have a DAO class for product
    
    // // return the page products.jsp 
    // @ActionAttribute (urlPattern = "products") //optional
    // public Result products() throws Exception {
    //     List<product> products = productDAO.getAllProducts();
    //     request.setAttribute("products", products); // Set the products list in the request scope
    //     return page();
    // }

    // //need to get the db data and then send to the products.jsp     
    // //@ActionAttribute (urlPattern = "getProducts") //optional - this is the default url pattern
    // public Result getProducts() throws Exception {
    //     // Get all products from the database
    //     List<product> products = productDAO.getAllProducts();
    //     ObjectMapper mapper = new ObjectMapper();

    //     // Convert the products list to JSON format
    //     String productsJson = mapper.writeValueAsString(products);
    //     return json(productsJson); // Return the JSON response
    // }



    @ActionAttribute(urlPattern = "productPage")
    public Result productPage() throws Exception {
        int id = Integer.parseInt(request.getParameter("id"));
        product p = productDAO.searchProducts(id);
        System.out.println("✅ Product found: " + p);
    
        productVariationOptions options = null;
    
        try {
            String rawJson = p.getVariations();
            System.out.println("📦 Raw JSON: " + rawJson);
    
            if (rawJson != null && !rawJson.trim().isEmpty()) {
                ObjectMapper objectMapper = new ObjectMapper();
    
                // Deserialize JSON directly to Map<String, List<String>>
                Map<String, List<String>> variationMap = objectMapper.readValue(
                    rawJson, new com.fasterxml.jackson.core.type.TypeReference<Map<String, List<String>>>() {}
                );
    
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

        List<productFeedback> feedbackList = productDAO.getFeedbackForProduct(id);
        System.out.println("📝 Feedback count: " + (feedbackList != null ? feedbackList.size() : 0));
        for (productFeedback fb : feedbackList) {
            System.out.println("⭐ Feedback: " + fb.getRating() + " - " + fb.getComment());
        }
    
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
        List<Integer> categoryIds = selectedCategories != null ? Arrays.stream(selectedCategories).map(Integer::parseInt).toList() : new ArrayList<>();

        System.out.println("📦 Category IDs: " + categoryIds);

        // Get the min and max price from the request parameters
        String minPriceRaw = request.getParameter("minPrice");
        String maxPriceRaw = request.getParameter("maxPrice");

        //for safety check , force it to be double 
        Double minPrice = minPriceRaw != null && !minPriceRaw.isEmpty() ? Double.parseDouble(minPriceRaw) : null;
        Double maxPrice = maxPriceRaw != null && !maxPriceRaw.isEmpty() ? Double.parseDouble(maxPriceRaw) : null;

        System.out.println("💰 Min price: " + minPrice + " | Max price: " + maxPrice);

        //Get Sort Option 
        String sortBy = request.getParameter("sortBy"); 
        System.out.println("🔄 Sort by: " + sortBy);

        String keywords =  request.getParameter("keyword");
        System.out.println("🔍 Keywords: " + keywords);


        List<product> filteredProducts = productDAO.filterProducts(categoryIds, minPrice, maxPrice, sortBy , keywords);
        System.out.println("✅ DAO returned products: " + filteredProducts.size());


        List<productDTO> dtos = filteredProducts.stream().map(productDTO::new).toList();

        System.out.println("🚀 Returning product DTOs as JSON");

        return json(dtos); // Convert to JSON and return
  
    }
    



    







    


    


   
}
