package Controllers;

import java.util.Arrays;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.devDA;
import Models.dev;
import jakarta.servlet.annotation.WebServlet;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.ControllerBase;
import mvc.Http.HttpMethod;
import mvc.Http.HttpStatusCode;
import mvc.Result;

@WebServlet("/dev/*")
public class devController extends ControllerBase {
    public Result index() {
        String userName = "John Doe";
        List<String> features = Arrays.asList(
                "Blazing Fast Performance",
                "Highly Secure System",
                "User-Friendly Interface",
                "24/7 Customer Support");

        // List of testimonials
        List<String> testimonials = Arrays.asList(
                "This product changed my business! - Alice",
                "Highly recommended! - Bob",
                "Amazing service and support! - Charlie");
        // List of Users
        List<dev> users = devDA.getUsers();

        // Set attributes to pass data to JSP
        request.setAttribute("userName", userName);
        request.setAttribute("features", features);
        request.setAttribute("testimonials", testimonials);
        request.setAttribute("users", users);
        return page();
    }

    @HttpRequest(HttpMethod.GET)
    public Result login() {
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result login(String username, String password) {
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        ObjectMapper mapper = new ObjectMapper();
        JsonNode json = mapper.createObjectNode();
        ((ObjectNode) json).put("username", username);
        if ("admin".equals(username) && "admin".equals(password)) {
            return json(json, HttpStatusCode.OK, "Login successful");
        }
        return json(json, HttpStatusCode.UNAUTHORIZED, "Login failed");
    }

    @SyncCache(channel = "dev", message = "from dev/addDev")
    @HttpRequest(HttpMethod.POST)
    public Result addDev(dev user) {
        System.out.println("Add Dev");
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonResponse = objectMapper.createObjectNode();
        System.out.println(user.getUsername());
        devDA.addUser(user);
        System.out.println("User added successfully");
        ((ObjectNode) jsonResponse).put("success", true);
        ((ObjectNode) jsonResponse).put("username", user.getUsername());
        return json(jsonResponse);
    }
}
