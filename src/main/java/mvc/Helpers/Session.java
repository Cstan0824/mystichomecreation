package mvc.Helpers;

import java.security.Timestamp;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DTO.UserSession;
import mvc.Cache.Redis;
import mvc.Helpers.Audits.AuditService;

public class Session {
    // Core session properties
    private UserSession userSession;

    // Session keys
    private static final String USER_SESSION_KEY = "USER_DETAILS";

    private Logger logger = AuditService.getLogger();
    private ObjectMapper objectMapper = new ObjectMapper();
    private Redis redis = new Redis();

    public Session() {
        String json = redis.getValue(USER_SESSION_KEY);
        if (json == null) {
            return;
        }
        try {
            List<UserSession> resultList = JsonConverter.deserialize(json, UserSession.class);
            if (null == resultList) {
                return;
            }
            if (resultList.size() == 0) {
                return;
            }
            this.userSession = resultList.get(0);
        } catch (JsonProcessingException exception) {
            logger.log(Level.WARNING, "Error deserializing user session: " + exception.getMessage());
        }
    }

    // Update the JSON representation based on the User object
    private void updateJsonRepresentation() {
        if (userSession == null) {
            return;
        }
        try {
            String json = JsonConverter.serialize(userSession);
            long expiry = 7200;
            if (!"".equals(redis.getValue(USER_SESSION_KEY))) {
                // if key exists inside redis, get the remaining time to live
                expiry = redis.getTTL(USER_SESSION_KEY);
            }
            redis.setValue(USER_SESSION_KEY, json, (int) expiry); // 2 hour expiration
        } catch (JsonProcessingException e) {
            logger.log(Level.WARNING, "Error serializing user session: " + e.getMessage());
        }
    }

    // Getters and setters that directly use the User object
    public int getId() {
        return userSession.getId();
    }

    public String getUsername() {
        return this.userSession.getUsername();
    }

    public void setUsername(String username) {
        userSession.setUsername(username);
        updateJsonRepresentation();
    }

    public String getEmail() {
        return this.userSession.getEmail();
    }

    public void setEmail(String email) {
        userSession.setEmail(email);
        updateJsonRepresentation();
    }

    public String getRole() {
        return this.userSession.getRole();
    }

    public void setRole(String role) {
        userSession.setRole(role);
        updateJsonRepresentation();
    }

    public List<String> getPermissions() {
        return this.userSession.getAccessUrls();
    }

    public void setPermissions(List<String> accessUrls) {
        this.userSession.setAccessUrls(accessUrls);
        updateJsonRepresentation();
    }

    public boolean isAuthenticated() {
        return this.userSession.isAuthenticated();
    }

    public void setAuthenticated(boolean isAuthenticated) {
        this.userSession.setAuthenticated(isAuthenticated);
        updateJsonRepresentation();
    }

    public UserSession getUserSession() {
        return userSession;
    }

    public void setUserSession(UserSession userSession) {
        this.userSession = userSession;
    }

    // Helper methods
    public String getKey() {
        return USER_SESSION_KEY;
    }

    public String get(String key) {
        return redis.getValue(key) != null ? redis.getValue(key) : null;
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
        redis.setValue(key, value);
    }

    public void remove(String key) {
        redis.removeValue(key);
    }

    public void remove() {
        redis.removeValue(USER_SESSION_KEY);
        this.userSession = null;
    }

    public void clear() {
        this.userSession = null;
    }
}