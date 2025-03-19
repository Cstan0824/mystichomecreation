package mvc;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import mvc.Annotations.AuthorizationHandler;
import mvc.Annotations.SyncCacheHandler;
import mvc.Helpers.HttpStatusCode;
import mvc.Helpers.JsonConverter;

public class ControllerBase extends HttpBase {
    public ControllerBase() {
        super();

        //Register all middleware here
        super.addMiddleware(new AuthorizationHandler());
        super.addMiddleware(new SyncCacheHandler());
        
    }

    @Override
    protected Result page() {
        String controller = this.getClass().getSimpleName();
        String action = getCaller();
        return page(action, controller);
    }

    @Override

    protected Result page(String action) {
        String controller = this.getClass().getSimpleName();
        return page(action, controller);
    }

    @Override

    protected Result page(String action, String controller) {
        String path = "/Views/" + controller.replace("Controller","") + "/" + action + ".jsp";
        Result result = new Result();
        //Setup response
        result.setPath(path);
        result.setContentType("text/html");
        result.setStatusCode(HttpStatusCode.OK);
        return result;
    }

    @Override
    protected Result json(Object data) {
        return json(data, HttpStatusCode.OK, "success");
    }

    @Override
    protected Result json(Object data, HttpStatusCode status, String message) {
        Result result = new Result();
        JsonNode json = getResponseTemplate();
        //Setup json data
        if (data != null) {
            ((ObjectNode) json).put("data", JsonConverter.serialize(data));
        }
        ((ObjectNode) json).put("status", status.get());
        ((ObjectNode) json).put("message", message);
        ((ObjectNode) json).put("timestamp", System.currentTimeMillis());

        //Setup response
        result.setData(json);
        result.setContentType("application/json");
        return result;
    }

    @Override
    protected Result content(Object data, String contentType, HttpStatusCode status) {
        Result result =  new Result();

        //Setup response
        result.setData(data);
        result.setContentType(contentType);
        result.setStatusCode(status);

        return result;
    }
    @Override
    protected Result content(Object data, String contentType) {
        return content(data, contentType, HttpStatusCode.OK);
    }

    @Override
    protected Result success() {
        return success("success");
    }

    @Override
    protected Result success(String message) {
        return success(HttpStatusCode.OK, message);
    }
    @Override
    protected Result success(HttpStatusCode status, String message) {
        return json(null, status, message);
    }

    @Override
    protected Result error() {
        return error("message");
    }
    
    @Override
    protected Result error(String message) {
        return error(HttpStatusCode.BAD_REQUEST, message);
    }
    
    @Override
    protected Result error(HttpStatusCode status, String message) {
        return json(null, status, message);
    }

    @Override
    protected Result response() {
        return new Result();
    }

    private static String getCaller() {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();
        // Index 0: getStackTrace(), Index 1: getCallerMethodName(), Index 2: actual caller
        return stackTrace[3].getMethodName();
    }

    private static JsonNode getResponseTemplate() {
        ObjectMapper objectMapper = new ObjectMapper();
        String content = "";
        String path = "/Content/response.json";
        File template = new File(path);

        // Read JSON file and return as JsonNode

        try (Scanner reader = new Scanner(template)) {
            while (reader.hasNextLine()) {
                content += reader.nextLine();
            }
            reader.close();
        } catch (IOException e) {
            System.out.println("An error occurred while reading the response template: " + e.getMessage());
        }
        Object object = JsonConverter.deserialize(content, Object.class).get(0);
        return objectMapper.valueToTree(object);
    }
}
