package mvc.Helpers;

import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;


public class JsonConverter {
    private static final ObjectMapper objectMapper = new ObjectMapper();

    // Convert List<T> to JSON String
    public static <T> String serialize(ArrayList<T> list) {
        try {
            return objectMapper.writeValueAsString(list);
        } catch (JsonProcessingException e) {
            // Handle the error (e.g., log it or throw a runtime exception)
            return null;
        }
    }

    // Convert a single object of type T to JSON String
    public static <T> String serialize(T item) {
        try {
            return objectMapper.writeValueAsString(item);
        } catch (JsonProcessingException e) {
            // Handle the error (e.g., log it or throw a runtime exception)
            return null;
        }
    }

    // Convert JSON String to List<T>
    public static <T> List<T> deserialize(String json, Class<T> type) {
        try {
            // If json represents a list, we deserialize it as a List of T
            List<T> list = objectMapper.readValue(json, objectMapper.getTypeFactory().constructCollectionType(List.class, type));
            return list;
        } catch (JsonProcessingException e) {
            // Handle the error (e.g., log it or throw a runtime exception)
            return new ArrayList<>();
        }
    }   
}