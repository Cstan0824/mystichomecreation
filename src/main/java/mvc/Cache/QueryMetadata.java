package mvc.Cache;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import org.hibernate.query.Query;

import jakarta.persistence.Parameter;
import jakarta.persistence.TypedQuery;
import mvc.Cache.Redis.CacheLevel;

public class QueryMetadata {
    // Existing fields
    private QueryResultType type;
    private String sql;
    private CacheLevel level;
    private String controllerName;

    // New fields for storing query parameters
    private Map<String, Object> namedParameters;
    private Map<Integer, Object> positionalParameters;

    public QueryMetadata() {
        this.namedParameters = new HashMap<>();
        this.positionalParameters = new HashMap<>();
    }

    public QueryMetadata(QueryResultType type, CacheLevel level, String sql) {
        this();
        this.level = level;
        this.type = type;
        this.sql = sql;
    }

    public QueryMetadata(QueryResultType type, CacheLevel level, String sql, String controllerName) {
        this(type, level, sql);
        this.controllerName = controllerName;
    }

    /**
     * Constructor that accepts named parameters map
     */
    public QueryMetadata(QueryResultType type, CacheLevel level, String sql, Map<String, Object> namedParameters) {
        this(type, level, sql);
        if (namedParameters != null) {
            this.namedParameters.putAll(namedParameters);
        }
    }

    /**
     * Constructor that accepts positional parameters map
     */
    public QueryMetadata(QueryResultType type, CacheLevel level, String sql,
            String controllerName, Map<Integer, Object> positionalParameters) {
        this(type, level, sql, controllerName);
        if (positionalParameters != null) {
            this.positionalParameters.putAll(positionalParameters);
        }
    }

    /**
     * Constructor that accepts both named and positional parameter maps
     */
    public QueryMetadata(QueryResultType type, CacheLevel level, String sql,
            Map<String, Object> namedParameters, Map<Integer, Object> positionalParameters) {
        this(type, level, sql);
        if (namedParameters != null) {
            this.namedParameters.putAll(namedParameters);
        }
        if (positionalParameters != null) {
            this.positionalParameters.putAll(positionalParameters);
        }
    }

    /**
     * Comprehensive constructor with all parameter-related fields
     */
    public QueryMetadata(QueryResultType type, CacheLevel level, String sql, String controllerName,
            Map<String, Object> namedParameters, Map<Integer, Object> positionalParameters,
            Integer firstResult, Integer maxResults, Integer timeout) {
        this(type, level, sql, controllerName);
        if (namedParameters != null) {
            this.namedParameters.putAll(namedParameters);
        }
        if (positionalParameters != null) {
            this.positionalParameters.putAll(positionalParameters);
        }
    }

    /**
     * Constructor that accepts a TypedQuery
     */
    public <T> QueryMetadata(TypedQuery<T> query, QueryResultType type, CacheLevel level, String controllerName) {
        this();
        this.type = type;
        this.level = level;
        this.controllerName = controllerName;

        // Extract SQL
        this.sql = query.unwrap(Query.class).getQueryString();

        // Extract parameters
        extractParameters(query);
    }

    /**
     * Helper method to extract parameters from a TypedQuery
     */
    private <T> void extractParameters(TypedQuery<T> query) {
        try {
            // First approach: Try to use getParameters() from JPA API
            Set<Parameter<?>> parameters = query.getParameters();

            if (parameters != null) {
                for (Parameter<?> parameter : parameters) {
                    // Handle named parameters
                    if (parameter.getName() != null) {
                        try {
                            Object value = query.getParameterValue(parameter.getName());
                            if (value != null) {
                                this.namedParameters.put(parameter.getName(), value);
                            }
                        } catch (Exception e) {
                            // Parameter might not be bound yet or other issue
                            System.out.println("Failed to extract named parameter: " + parameter.getName());
                        }
                    }
                    // Handle positional parameters
                    else if (parameter.getPosition() != null) {
                        try {
                            Object value = query.getParameterValue(parameter.getPosition());
                            if (value != null) {
                                this.positionalParameters.put(parameter.getPosition(), value);
                            }
                        } catch (Exception e) {
                            // Parameter might not be bound yet or other issue
                            System.out.println("Failed to extract positional parameter: " + parameter.getPosition());
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.out.println("Error in extractParameters: " + e.getMessage());
        }
    }

    /**
     * Clone constructor - creates a copy of an existing QueryMetadata
     */
    public QueryMetadata(QueryMetadata source) {
        this();
        if (source != null) {
            this.type = source.type;
            this.sql = source.sql;
            this.level = source.level;
            this.controllerName = source.controllerName;

            if (source.namedParameters != null) {
                this.namedParameters.putAll(source.namedParameters);
            }
            if (source.positionalParameters != null) {
                this.positionalParameters.putAll(source.positionalParameters);
            }
        }
    }

    // Parameter methods - fluent API style for easier chaining
    public QueryMetadata setParameter(String name, Object value) {
        if (namedParameters == null) {
            namedParameters = new HashMap<>();
        }
        namedParameters.put(name, value);
        return this;
    }

    public QueryMetadata setParameter(int position, Object value) {
        if (positionalParameters == null) {
            positionalParameters = new HashMap<>();
        }
        positionalParameters.put(position, value);
        return this;
    }

    // Parameter getters
    public Map<String, Object> getNamedParameters() {
        return namedParameters;
    }

    public Map<Integer, Object> getPositionalParameters() {
        return positionalParameters;
    }

    // Existing getters and setters
    public QueryResultType getType() {
        return type;
    }

    public String getSql() {
        return sql;
    }

    public CacheLevel getLevel() {
        return level;
    }

    public String getControllerName() {
        return this.controllerName;
    }

    public void setLevel(CacheLevel level) {
        this.level = level;
    }

    public void setType(QueryResultType type) {
        this.type = type;
    }

    public void setSql(String sql) {
        this.sql = sql;
    }

    public void setControllerName(String controllerName) {
        this.controllerName = controllerName;
    }

    // Existing QueryResultType enum
    public enum QueryResultType {
        SINGLE("single"),
        LIST("list");

        private final String value;

        private QueryResultType(String value) {
            this.value = value;
        }

        public String get() {
            return value;
        }

        public static QueryResultType set(String value) {
            for (QueryResultType resultType : QueryResultType.values()) {
                if (resultType.value.equalsIgnoreCase(value)) {
                    return resultType;
                }
            }
            throw new IllegalArgumentException("Invalid value: " + value);
        }
    }
}
