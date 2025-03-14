package Controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.devDA;
import Models.dev;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mvc.Helpers.Redis;

/*
============================================================================================================
@ This controller handles all requests related to the "dev" module.                                        @
@ It contains the following routes:                                                                        @
@ 1. GET /dev/ - Displays the home page for the dev module. {default action[index()]}                      @
@ 2. GET /dev/login - Displays the login page for the dev module.                                          @
@ 3. POST /dev/login - Handles the login request for the dev module.                                       @
@ 4. GET /dev/test - Displays the test page for the dev module.                                            @
============================================================================================================


 */
@WebServlet("/dev/*")
public class devController extends HttpServlet {
    private HttpServletRequest request;
    private HttpServletResponse response;

    //#region GET Requests
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Update the request and response objects for each GET request
        this.request = request;
        this.response = response;

        // Get the request path after "/landing"
        String path = request.getPathInfo(); // Example: "/login" or "/"
        if (path == null)
            path = "/";
        try {
            switch (path) {
                case "/" -> index();
                case "/login" -> login();
                case "/test" -> test();
                default -> // Handle 404 - Page Not Found
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page Not Found");
            }
        } catch (ServletException | IOException e) {
        }
    }

    public void index() throws ServletException, IOException {
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
        request.getRequestDispatcher("/Views/dev/index.jsp").forward(request, response);
    }

    public void login() throws ServletException, IOException {
        this.request.getRequestDispatcher("/Views/dev/login.jsp").forward(request, response);
    }

    public void test() {
        // List<dev> users = devDA.getUsers();
        // for (dev user : users) {
        //     System.out.println(user.getUsername());
        //     System.out.println(user.getEmail());
        //     System.out.println(user.getCreated_date());
        //     System.out.println(user.getPassword());
        // }
        List<dev> users = new ArrayList<>();
        dev user = new dev();
        user.setUsername("test");
        user.setEmail("test@gmail.com");
        user.setPassword("password");

        dev user1 = new dev();
        user1.setUsername("test user");
        user1.setEmail("user@gmail.com");
        user1.setPassword("password");

        users.add(user);
        users.add(user1);

        Redis redis = new Redis();

        redis.getOrCreateList("test", dev.class, () -> {
            return users;
        });
    }
    //#endregion

    //#region POST Requests
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Update the request and response objects for each POST request
        this.request = request;
        this.response = response;
        String path = request.getPathInfo();
        try {
            switch (path) {
                case "/login" -> verifyCredentials();
                default -> response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid request");
            }
        } catch (IOException e) {
        }

    }

    public void verifyCredentials() throws IOException {
        // Read JSON request body
        StringBuilder jsonBuffer = new StringBuilder();
        String line;
        try (BufferedReader reader = this.request.getReader()) {
            while ((line = reader.readLine()) != null) {
                jsonBuffer.append(line);
            }
        }

        ObjectMapper objectMapper = new ObjectMapper();
        // Parse JSON request body using Jackson
        JsonNode jsonRequest = objectMapper.readTree(jsonBuffer.toString());

        // Extract username and password
        String username = jsonRequest.path("username").asText("");
        String password = jsonRequest.path("password").asText("");

        this.response.setContentType("application/json");
        this.response.setCharacterEncoding("UTF-8");

        // Build JSON response using Jackson
        JsonNode jsonResponse = objectMapper.createObjectNode();

        // Check credentials
        if ("admin".equals(username) && "password".equals(password)) {
            HttpSession session = this.request.getSession();
            session.setAttribute("user", username);

            ((ObjectNode) jsonResponse).put("success", true);
            ((ObjectNode) jsonResponse).put("message", "Login successful");
        } else {
            ((ObjectNode) jsonResponse).put("success", false);
            ((ObjectNode) jsonResponse).put("message", "Invalid username or password");
        }

        // Convert JSON object to string and write to response
        String jsonResponseString = objectMapper.writeValueAsString(jsonResponse);
        this.response.getWriter().write(jsonResponseString);
    }
    //#endregion
}
