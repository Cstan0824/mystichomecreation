package mvc.Helpers;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.hibernate.query.Query;

import jakarta.persistence.TypedQuery;

public class QueryConverter {
    private static <T> String extractQuery(TypedQuery<T> query) {
        return query.unwrap(Query.class).getQueryString();
    }

    public static <T> String getQuery(TypedQuery<T> query) {
        String sql = extractQuery(query);
        Pattern pattern = Pattern.compile(":(\\w+)");
        Matcher matcher = pattern.matcher(sql);
        StringBuffer sqlQuery = new StringBuffer();
        while (matcher.find()) {
            String param = matcher.group(1); // Extract parameter name (without :)
            Object value = query.getParameterValue(param);

            if (value == null) {
                throw new IllegalArgumentException("Parameter '" + param + "'' is not set");
            }
            String replacement = (value instanceof String) ? "'" + value + "'" : value.toString();
            matcher.appendReplacement(sqlQuery, replacement);
        }
        return sql;
    }
}
