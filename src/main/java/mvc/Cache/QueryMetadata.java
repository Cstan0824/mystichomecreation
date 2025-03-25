package mvc.Cache;

import mvc.Cache.Redis.CacheLevel;

public class QueryMetadata {
    private QueryResultType type;
    private String sql;
    private CacheLevel level;
    private String controllerName;

    public QueryMetadata() {
    }

    public QueryMetadata(QueryResultType type, CacheLevel level, String sql) {
        this.level = level;
        this.type = type;
        this.sql = sql;
    }

    public QueryMetadata(QueryResultType type, CacheLevel level, String sql, String controllerName) {
        this(type, level, sql);
        this.controllerName = controllerName;
    }

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

