package mvc.Helpers;

import java.security.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import Models.Users.User;
import jakarta.servlet.http.HttpSession;

public class SessionHelper {
    // Core session properties
    private String permissions;
    private boolean isAuthenticated = false;
    private User user;

    // Session keys
    private static final String USER_SESSION_KEY = "USER_DETAILS";
    private static final String USER_OBJECT_KEY = "USER_OBJECT";

    private HttpSession session;
    private Logger logger = AuditTrail.getLogger();
    private ObjectMapper objectMapper = new ObjectMapper();

    public SessionHelper() {
    }

    public SessionHelper(HttpSession session) {
        this.session = session;
        try {
            // Load User object first
            this.user = (User) session.getAttribute(USER_OBJECT_KEY);

            // If no user object exists, try to load from JSON
            if (this.user == null) {
                Object json = session.getAttribute(USER_SESSION_KEY);
                if (json != null) {
                    JsonNode root = objectMapper.readTree(json.toString());
                    this.permissions = root.path("permissions").asText(null);
                    this.isAuthenticated = root.path("isAuthenticated").asBoolean(false);

                    // Create User object from JSON data
                    User newUser = new User();
                    newUser.setId(root.path("id").asInt());
                    newUser.setUsername(root.path("username").asText(null));
                    newUser.setEmail(root.path("email").asText(null));
                    newUser.setRole_id(Integer.parseInt(root.path("role").asText("0")));
                    newUser.setBirthdate(root.path("birthdate").asText(null));
                    newUser.setShippingInformation(root.path("shipping_information").asText(null));

                    this.user = newUser;
                    session.setAttribute(USER_OBJECT_KEY, newUser);
                }
            }
        } catch (Exception ex) {
            logger.log(Level.WARNING, "Error loading session data: " + ex.getMessage());
        }
    }

    // User object methods
    /**
     * Store the User object in the session
     * 
     * @param user The user object to store
     */
    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.isAuthenticated = true;
            session.setAttribute(USER_OBJECT_KEY, user);
            updateJsonRepresentation();
        }
    }

    /**
     * Retrieve the stored User object from session
     * 
     * @return The User object or null if not found
     */
    public User getUser() {
        return this.user;
    }

    // Update the JSON representation based on the User object
    private void updateJsonRepresentation() {
        if (this.user != null) {
            try {
                ObjectNode json = objectMapper.createObjectNode();
                json.put("id", this.user.getId());
                json.put("username", this.user.getUsername());
                json.put("email", this.user.getEmail());
                json.put("role", String.valueOf(this.user.getRole_id()));
                json.put("permissions", this.permissions);
                json.put("birthdate", this.user.getBirthdate());
                json.put("shipping_information", this.user.getShippingInformation());
                json.put("isAuthenticated", this.isAuthenticated);

                session.setAttribute(USER_SESSION_KEY, objectMapper.writeValueAsString(json));
            } catch (Exception ex) {
                logger.log(Level.WARNING, "Error updating JSON representation: " + ex.getMessage());
            }
        }
    }

    // Getters and setters that directly use the User object
    public int getId() {
        return user != null ? user.getId() : -1;
    }

    public String getUsername() {
        return user != null ? user.getUsername() : null;
    }

    public void setUsername(String username) {
        if (user != null) {
            user.setUsername(username);
            updateJsonRepresentation();
        }
    }

    public String getEmail() {
        return user != null ? user.getEmail() : null;
    }

    public void setEmail(String email) {
        if (user != null) {
            user.setEmail(email);
            updateJsonRepresentation();
        }
    }

    public String getRole() {
        return user != null ? String.valueOf(user.getRole_id()) : null;
    }

    public void setRole(String role) {
        if (user != null && role != null) {
            try {
                user.setRole_id(Integer.parseInt(role));
                updateJsonRepresentation();
            } catch (NumberFormatException e) {
                logger.log(Level.WARNING, "Invalid role format: " + e.getMessage());
            }
        }
    }

    public String getPermissions() {
        return this.permissions;
    }

    public void setPermissions(String permissions) {
        this.permissions = permissions;
        updateJsonRepresentation();
    }

    public String getShipping_information() {
        return user != null ? user.getShippingInformation() : null;
    }

    public void setShippingInformation(String shipping_information) {
        if (user != null) {
            user.setShippingInformation(shipping_information);
            updateJsonRepresentation();
        }
    }

    public String getBirthdate() {
        return user != null ? user.getBirthdate() : null;
    }

    public void setBirthdate(String birthdate) {
        if (user != null) {
            user.setBirthdate(birthdate);
            updateJsonRepresentation();
        }
    }

    public boolean isAuthenticated() {
        return this.isAuthenticated;
    }

    public void setAuthenticated(boolean isAuthenticated) {
        this.isAuthenticated = isAuthenticated;
        updateJsonRepresentation();
    }

    // Helper methods
    public String getKey() {
        return USER_SESSION_KEY;
    }

    public String get(String key) {
        return session.getAttribute(key) != null ? session.getAttribute(key).toString() : null;
    }

    public void set(String key, String value) {
        set(key, value, null);
    }

    public void set(String key, String value, Timestamp timestamp) {
        if (timestamp != null) {
            try {
                ObjectNode json = objectMapper.createObjectNode();
                json.put("value", value);
                json.put("timestamp", timestamp.toString());
                value = JsonConverter.serialize(json);
            } catch (JsonProcessingException e) {
                logger.log(Level.WARNING, "Error in set method: " + e.getMessage());
            }
        }
        session.setAttribute(key, value);
    }

    public void remove(String key) {
        session.removeAttribute(key);
    }

    public void remove() {
        session.removeAttribute(USER_SESSION_KEY);
        session.removeAttribute(USER_OBJECT_KEY);
        this.user = null;
        this.isAuthenticated = false;
    }

    public void clear() {
        session.invalidate();
        this.user = null;
        this.isAuthenticated = false;
    }
}