package Controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.List;

import DAO.devDA;
import Models.dev;
import jakarta.json.Json;
import jakarta.json.JsonObject;
import jakarta.json.JsonObjectBuilder;
import jakarta.json.JsonReader;
import jakarta.json.JsonWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mvc.Helpers.Redis;

@WebServlet("/dev/*")
public class devController extends HttpServlet{
@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get the request path after "/landing"
        String path = request.getPathInfo(); // Example: "/login" or "/"
        if (path == null)
            path = "/";

        switch (path) {
            case "/" -> {
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

            case "/login" -> // Login Page Logic
            {                
                request.getRequestDispatcher("/Views/dev/login.jsp").forward(request, response);
            }
            case "/test" ->
            {
                List<dev> users = devDA.getUsers();
                for (dev user : users) {
                    System.out.println(user.getUsername());
                    System.out.println(user.getEmail());
                    System.out.println(user.getCreated_date());
                    System.out.println(user.getPassword());
                }
                Redis redis = new Redis();
                System.out.println("Redis Message Successfully Set");
            }
            default -> // Handle 404 - Page Not Found
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page Not Found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getPathInfo();

        if (path != null && path.equals("/login")) {
            // Read JSON request body
            StringBuilder jsonBuffer = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    jsonBuffer.append(line);
                }
            }

            JsonObject jsonRequest;
            try ( 
                    JsonReader jsonReader = Json.createReader(new StringReader(jsonBuffer.toString()))) {
                jsonRequest = jsonReader.readObject();
            }

            String username = jsonRequest.getString("username", "");
            String password = jsonRequest.getString("password", "");

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            // Build JSON response
            JsonObjectBuilder jsonResponseBuilder = Json.createObjectBuilder();

            //User Credential
            if ("admin".equals(username) && "password".equals(password)) {
                HttpSession session = request.getSession();
                session.setAttribute("user", username);

                jsonResponseBuilder.add("success", true);
                jsonResponseBuilder.add("message", "Login successful");
            } else {
                jsonResponseBuilder.add("success", false);
                jsonResponseBuilder.add("message", "Invalid username or password");
            }

            JsonObject jsonResponse = jsonResponseBuilder.build();

            // Convert JSON object to string and write to response
            StringWriter stringWriter = new StringWriter();
            try (JsonWriter jsonWriter = Json.createWriter(stringWriter)) {
                jsonWriter.write(jsonResponse);
            }

            response.getWriter().write(stringWriter.toString());
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invalid request");
        }
    }
}
