package Controllers;

import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.ActionAttribute;

import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;

import DAO.productDAO;
import Models.product;
import jakarta.servlet.annotation.WebServlet;


@WebServlet("/product/*")
public class productController extends ControllerBase {
    private productDAO productDAO = new productDAO(); // Assuming you have a DAO class for product
    
    // return the page products.jsp 
    @ActionAttribute (urlPattern = "products") //optional
    public Result products() throws Exception {
        List<product> products = productDAO.getAllProducts();
        request.setAttribute("products", products); // Set the products list in the request scope
        return page();
    }

    //need to get the db data and then send to the products.jsp     
    //@ActionAttribute (urlPattern = "getProducts") //optional - this is the default url pattern
    public Result getProducts() throws Exception {
        // Get all products from the database
        List<product> products = productDAO.getAllProducts();
        ObjectMapper mapper = new ObjectMapper();

        // Convert the products list to JSON format
        String productsJson = mapper.writeValueAsString(products);
        return json(productsJson); // Return the JSON response
    }

    





    


    


   
}
