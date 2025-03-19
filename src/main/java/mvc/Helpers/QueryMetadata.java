package mvc.Helpers;

import mvc.Helpers.Redis.CacheLevel;

public class QueryMetadata {
    private QueryResultType type;
    private String sql;
    private CacheLevel level; 

    public QueryMetadata(String type, CacheLevel level, String sql) {
        this.type.set(type);
        this.sql = sql;
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

    public void setLevel(CacheLevel level) {
        this.level = level;
    }

    public void setType(QueryResultType type) {
        this.type = type;
    }

    public void setSql(String sql) {
        this.sql = sql;
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

        public QueryResultType set(String value) {
            for (QueryResultType resultType : QueryResultType.values()) {
                if (resultType.value.equalsIgnoreCase(value)) {
                    return resultType;
                }
            }
            throw new IllegalArgumentException("Invalid value: " + value);

        }
    }
}

