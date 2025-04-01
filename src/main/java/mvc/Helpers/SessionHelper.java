package mvc.Helpers;

import java.util.logging.Level;
import java.util.logging.Logger;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import jakarta.servlet.http.HttpSession;

public class SessionHelper {
    private int id;
    private String username;
    private String email;
    private String role;
    private String permissions;
    private String shipping_information;
    private String birthdate;
    private boolean isAuthenticated = false;

    private static final String SESSION_KEY = "USER_DETAILS";

    private HttpSession session;
    private Logger logger = AuditTrail.getLogger();
    private ObjectMapper objectMapper = new ObjectMapper();

    public SessionHelper() {

    }

    public SessionHelper(HttpSession session) {
        this.session = session;
        try {
            Object json = session.getAttribute(SESSION_KEY);
            if (json != null) {
                JsonNode root = objectMapper.readTree(json.toString());
                this.id = root.path("id").asInt();
                this.username = root.path("username").asText(null);
                this.email = root.path("email").asText(null);
                this.role = root.path("role").asText(null);
                this.permissions = root.path("permissions").asText(null);
                this.birthdate = root.path("birthdate").asText(null);
                this.shipping_information = root.path("shipping_information").asText(null);
                this.isAuthenticated = root.path("isAuthenticated").asBoolean(false);
            }
        } catch (Exception ex) {
            logger.log(Level.WARNING, "Error loading session data: " + ex.getMessage());
        }
    }

    public int getId() {
        try {
            String val = get("id");
            return val != null ? Integer.parseInt(val) : -1;
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error throws at [getId()]: " + e.getMessage());
            return -1;
        }
    }

    public String getUsername() {
        return get("username");
    }

    public void setUsername(String username) {
        this.username = username;
        set();
    }

    public String getEmail() {
        return get("email");
    }

    public void setEmail(String email) {
        this.email = email;
        set();
    }

    public String getRole() {
        return get("role");
    }

    public void setRole(String role) {
        this.role = role;
        set();
    }

    public String getPermissions() {
        return get("permissions");
    }

    public void setPermissions(String permissions) {
        this.permissions = permissions;
        set();
    }

    public String getShipping_information() {
        return get("shipping_information");
    }

    public void setShippingInformation(String shipping_information) {
        this.shipping_information = shipping_information;
        set();
    }

    public String getBirthdate() {
        return get("birthdate");
    }

    public void setBirthdate(String birthdate) {
        this.birthdate = birthdate;
        set();
    }

    public boolean isAuthenticated() {
        try {
            String val = get("isAuthenticated");
            return val != null ? Boolean.parseBoolean(val) : false;
        } catch (Exception e) {
            logger.log(Level.WARNING, "Error throws at [isAuthenticated()]: " + e.getMessage());
            return false;
        }
    }

    public void setAuthenticated(boolean isAuthenticated) {
        this.isAuthenticated = isAuthenticated;
        set();
    }

    public String getKey() {
        return SESSION_KEY;
    }

    public SessionHelper(int id, String username, String email, String role, String permissions,
            String shipping_information, String birthdate, HttpSession session) {
        this(session);
        this.id = id;
        this.username = username;
        this.email = email;
        this.role = role;
        this.permissions = permissions;
        this.shipping_information = shipping_information;
        this.birthdate = birthdate;
    }

    public String getJson() {
        try {
            ObjectNode json = objectMapper.createObjectNode();
            json.put("id", this.id);
            json.put("username", this.username);
            json.put("email", this.email);
            json.put("role", this.role);
            json.put("permissions", this.permissions);
            json.put("birthdate", this.birthdate);
            json.put("shipping_information", this.shipping_information);
            json.put("isAuthenticated", this.isAuthenticated);
            return objectMapper.writeValueAsString(json);
        } catch (Exception ex) {
            logger.log(Level.WARNING, "Error throws at [toJson()]: " + ex.getMessage());
            return null;
        }
    }

    private String get(String key) {
        try {
            Object json = session.getAttribute(SESSION_KEY);
            if (json == null) {
                return null;
            }
            JsonNode root = objectMapper.readTree(json.toString());
            JsonNode valueNode = root.get(key);
            return valueNode != null ? valueNode.asText() : null;
        } catch (Exception ex) {
            logger.log(Level.WARNING, "Error throws at [get(String key)]: " + ex.getMessage());
            return null;
        }

    }

    public void set() {
        String json = getJson();
        if (json == null) {
            return;
        }
        session.setAttribute(SESSION_KEY, json);
    }
}