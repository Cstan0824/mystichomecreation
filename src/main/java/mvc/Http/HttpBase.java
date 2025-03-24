package mvc.Http;

import java.io.BufferedReader;
import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.lang.reflect.Parameter;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.Middleware;
import mvc.Exceptions.InvalidActionResultException;
import mvc.Exceptions.PageNotFoundException;
import mvc.Helpers.JsonConverter;
import mvc.Result;

/*
    * ControllerBase class is the base class for all controllers in the application.
    * It handles the request and response, and invokes the appropriate action method.
    * It also handles the middleware execution before and after the action method.
    REMARKS:
        The Actions inside ControllerBase's child class should be annotated with capable to support 
        multipart/form-data, application/json, and query parameters.
 */

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10, // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public abstract class HttpBase extends HttpServlet {
    protected static HttpServletRequest request;
    protected static HttpServletResponse response;
    private static List<Middleware> middlewares;

    //#region SERVER RESPONSE METHODS
    protected abstract Result page();
    protected abstract Result page(String action);
    protected abstract Result page(String action, String controller);
    protected abstract Result json(Object data);
    protected abstract Result json(Object data, HttpStatusCode status, String message);
    protected abstract Result content(Object data, String contentType);
    protected abstract Result content(Object data, String contentType, HttpStatusCode status);
    protected abstract Result success();
    protected abstract Result success(String message);
    protected abstract Result success(HttpStatusCode status, String message);
    protected abstract Result error();
    protected abstract Result error(String message);
    protected abstract Result error(HttpStatusCode status, String message);
    protected abstract Result response();
    //#endregion

    public HttpBase() {
        
    }
    
    //#region OVERRIDE METHODS[HttpServlet]
    @Override
    public void init() throws ServletException {
        super.init();
    }

    @Override
    protected void service(HttpServletRequest req, HttpServletResponse res) {
        Method action = null;
        try {
            request = req;
            response = res;

            action = getCurrentAction();

            invokeMethod(action);
        } catch (Exception e) {
            //Logging service
            System.out.println("Error Start");
            StackTraceElement[] stackTrace = e.getStackTrace();
            if (stackTrace.length > 0) {
                StackTraceElement source = stackTrace[0]; // The first element contains the error source
                System.out.println("Exception occurred in:");
                System.out.println("Class: " + source.getClassName());
                System.out.println("Method: " + source.getMethodName());
                System.out.println("File: " + source.getFileName());
                System.out.println("Line: " + source.getLineNumber());
            }
            System.out.println("[ERROR] at : " + e.getLocalizedMessage());
            System.out.println("Error End");
            if (action != null) {
                try {
                    executeMiddleware(action.getAnnotations(), MiddlewareAction.OnError);
                } catch (Exception ex) {
                    System.out.println("Error at Middleware OnError: " + ex.getMessage());
                }
            }
        }
    }
    //#endregion

    //#region Process Request and Middleware
    private Method getCurrentAction() {
        String action = request.getPathInfo();
        String httpMethod = request.getMethod();
        if (action == null) action = "";
        
        if (action.equals("") || action.equals("/")) {
            action = "index";
        } else {
            action = action.replaceFirst("/", "");
        }

        if (httpMethod.equals("")) {
            httpMethod = "GET";
        }
        httpMethod = httpMethod.toUpperCase();

        //Retrieve current Controller's actions
        Method[] methods = this.getClass().getDeclaredMethods();
        if (methods.length == 0) {
            throw new PageNotFoundException("Page Not Found");
        }

        //Loop for the Controller Class Actions until the action is found
        for (Method method : methods) {
            //skip if not public method
            if (!Modifier.isPublic(method.getModifiers())) {
                continue;
            }

            //Compare by action name
            String methodName = method.getName();
            ActionAttribute actionName = method.getAnnotation(ActionAttribute.class);
            if (actionName != null)
                methodName = actionName.name();

            if (!methodName.toUpperCase().equals(action.toUpperCase())) {
                continue;
            }

            //Compare by Http Method
            HttpRequest httpRequest = method.getAnnotation(HttpRequest.class);
            if (httpRequest != null) {
                //Check if the Http method is the same as the API method
                if (!httpRequest.value().get().equals(httpMethod)) {
                    continue;
                }
            } else {
                //Default to GET API
                if (!httpMethod.equals("GET")) {
                    continue;
                }
            }
            return method;
        }
        //Action Not Found
        throw new PageNotFoundException("Page Not Found Exception");
    }

    private void invokeMethod(Method action)
            throws Exception {

        //Register Services
        Annotation[] annotations = action.getAnnotations();
        //Parameters Mapping - do mapping based on the request type
        Object[] args = parameterMapping(action);
        for (Object arg : args) {
            if (arg != null) {
                System.out.println("Arg Type: " + arg.getClass().getSimpleName());
            }
            System.out.println("Arg: " + arg);

        }

        //#region execute Middlewares and action
        executeMiddleware(annotations, MiddlewareAction.BeforeAction);

        Object result = action.invoke(this, args);
        if (result instanceof Result actionResult) {
            //need to declare response header
            response.setContentType(actionResult.getContentType());
            response.setStatus(actionResult.getStatusCode().get());
            response.setCharacterEncoding(actionResult.getCharset());

            executeMiddleware(annotations, MiddlewareAction.AfterAction);

            if (actionResult.getPath() != null && !actionResult.getPath().isEmpty()) {
                request.getRequestDispatcher(actionResult.getPath()).forward(request, response);
                return;
            } else {
                //set to json response 
                response.getWriter().write(JsonConverter.serialize(actionResult.getData()));
            }
        } else {
            throw new InvalidActionResultException("Invalid Request");
        }
        //#endregion

    }

    private void executeMiddleware(Annotation[] annotations, MiddlewareAction action) throws Exception {
        for (Annotation annotation : annotations) {
            String annotationName = annotation.annotationType().getSimpleName();
            String expectedHandlerName = annotationName + "Handler";

            //Check if the annotation is registered inside Handler Object List
            for (Middleware middleware : middlewares) {
                if (!middleware.getClass().getSimpleName().equals(expectedHandlerName)) {
                    continue;
                }
                //get all variables from Annotation and set the value to Handler object
                for (Method method : annotation.annotationType().getDeclaredMethods()) {
                    String paramName = method.getName();
                    Object paramValue = method.invoke(annotation);

                    Field field = middleware.getClass().getDeclaredField(paramName);

                    //Assign value to Handler Object
                    field.setAccessible(true); //public for temporary
                    field.set(middleware, paramValue);
                    field.setAccessible(false); //set back to private
                }

                switch (action) {
                    case BeforeAction -> middleware.executeBeforeAction();
                    case AfterAction -> middleware.executeAfterAction();
                    case OnError -> middleware.onError();
                }
                break;
            }

        }
    }

    
    protected void addMiddleware(Middleware middleware) {
        //Add Middleware
        if (middlewares == null) {
            middlewares = new ArrayList<>();
        }
        middlewares.add(middleware);
    }

    //#endregion
    
    //#region PARAMETER MAPPING
    private Object[] parameterMapping(Method action) throws IOException, Exception {
        String contentType = request.getContentType();
        String method = request.getMethod();
        System.out.println("Method: " + method);
        System.out.println("ContentType: " + contentType);
        //validate with request method and content_type
        if (method.equals("GET")) {
            return mapFromQueryParams(action);
        }
        //POST, DELETE, PUT, PATCH
        if ("application/json".equalsIgnoreCase(contentType)) {
            return mapFromJson(action);
        } else {
            return mapFromFormData(action); //multipart/form-data
        }

    }

    private Object[] mapFromFormData(Method action) throws Exception {
        Object[] formData = new Object[action.getParameters().length];
        Parameter[] parameters = action.getParameters(); // Get method parameters
        int count = 0;

        for (Parameter parameter : parameters) {
            String paramName = parameter.getName();
            Class<?> paramType = parameter.getType();
            Object convertedValue = getDefaultValue(paramType);

            if (paramType.isArray()) {
                // Handle arrays
                Class<?> componentType = paramType.getComponentType();

                if (componentType.equals(byte[].class)) {
                    // Handle file array (List of byte[])
                    List<byte[]> fileList = new ArrayList<>();
                    for (Part part : request.getParts()) {
                        if (part.getName().equals(paramName) && part.getSubmittedFileName() != null) {
                            fileList.add(part.getInputStream().readAllBytes());
                        }
                    }
                    convertedValue = fileList.toArray(byte[][]::new); //a.k.a fileList.toArray(new byte[0][]);
                } else {
                    // Handle text input array
                    String[] paramValues = request.getParameterValues(paramName);
                    if (paramValues != null) {
                        Object[] convertedArray = (Object[]) java.lang.reflect.Array.newInstance(componentType,
                                paramValues.length);
                        for (int i = 0; i < paramValues.length; i++) {
                            convertedArray[i] = convertType(paramValues[i], componentType);
                        }
                        convertedValue = convertedArray;
                    }
                }

            } else {
                // Handle text or file input
                Part part = request.getPart(paramName);
                if (part != null) {
                    if (part.getSubmittedFileName() != null) {
                        convertedValue = part.getInputStream().readAllBytes();
                    } else {
                        convertedValue = convertType(new String(part.getInputStream().readAllBytes()), paramType);
                    }
                }
            }

            System.out.println("Mapped Parameter: " + paramName + " = " + convertedValue);
            formData[count++] = convertedValue;
        }

        return formData;
    }

    private Object[] mapFromQueryParams(Method action) throws Exception {
        Object[] queryParams = new Object[action.getParameters().length];
        Parameter[] parameters = action.getParameters(); // Get method parameters
        int count = 0;

        for (Parameter parameter : parameters) {
            String paramName = parameter.getName();
            Class<?> paramType = parameter.getType();

            if (paramType.isArray()) {
                // Handle arrays: get all values as String[]
                String[] paramValues = request.getParameterValues(paramName);
                if (paramValues != null) {
                    queryParams[count] = convertArrayType(paramValues, paramType.getComponentType());
                } else {
                    queryParams[count] = getDefaultValue(paramType);
                }
            } else {
                // Handle single value
                String paramValue = request.getParameter(paramName);
                queryParams[count] = (paramValue != null) ? convertType(paramValue, paramType) : getDefaultValue(paramType);
            }

            count++;
        }
        return queryParams;
    }

    private Object[] mapFromJson(Method action) throws IOException, Exception {
        Object[] args = new Object[action.getParameters().length];
        ObjectMapper objectMapper = new ObjectMapper();
        int count = 0;

        // Read JSON request body
        String jsonBody = getBody();
        JsonNode jsonNode = objectMapper.readTree(jsonBody);

        for (Parameter param : action.getParameters()) {
            Class<?> paramType = param.getType();
            Object value;
            if (List.class.isAssignableFrom(
                    paramType)) { // Handle List<Object>
                                                                  //@@DONT ASK ME WHY, IT JUST WORKS@@ ;)
                Type actualTypeArgument = ((ParameterizedType) param.getParameterizedType())
                        .getActualTypeArguments()[0];
                value = objectMapper.convertValue(jsonNode.get(param.getName()), objectMapper.getTypeFactory()
                        .constructCollectionType(List.class, objectMapper.constructType(actualTypeArgument)));
            } else if (paramType
                    .isArray()) { // Handle Object[]
                                                      //MAGIC CODE THAT CONVERT JSON ARRAY INTO ARRAY OF OBJECT
                Class<?> componentType = paramType.getComponentType();
                value = objectMapper.convertValue(jsonNode.get(param.getName()),
                        objectMapper.getTypeFactory().constructArrayType(componentType));
            } else if (isComplexObject(paramType)) { // Handle single object
                value = objectMapper.convertValue(jsonNode.get(param.getName()), paramType);
            } else { // Handle primitive types
                value = objectMapper.convertValue(jsonNode.get(param.getName()), paramType);
            }
            if (value == null) {
                value = getDefaultValue(paramType);
            }
            args[count++] = value;
        }
        return args;
    }
   
    private String getBody() {
        StringBuilder stringBuilder = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
        } catch (Exception e) {
            //Handle the error
            System.out.println("Error at getBody(): " + e.getMessage());
        }
        return stringBuilder.toString();
    }
    //#endregion

    //#region HELPER METHODS
    private boolean isComplexObject(Class<?> type) {
        return !(type.isPrimitive() || type.equals(String.class) || Number.class.isAssignableFrom(type)
                || Boolean.class.equals(type));
    }

    @SuppressWarnings("unchecked")
    private static <T> T getDefaultValue(Class<T> clazz) {
        if (clazz == boolean.class)
            return (T) Boolean.FALSE;
        else if (clazz == byte.class)
            return (T) (Byte) (byte) 0;
        else if (clazz == short.class)
            return (T) (Short) (short) 0;
        else if (clazz == int.class)
            return (T) (Integer) 0;
        else if (clazz == long.class)
            return (T) (Long) 0L;
        else if (clazz == float.class)
            return (T) (Float) 0.0f;
        else if (clazz == double.class)
            return (T) (Double) 0.0;
        else if (clazz == char.class)
            return (T) (Character) '\u0000';
        else
            return null; // Complex objects return null
    }

    private Object convertType(String value, Class<?> targetType) {
        if (targetType == String.class)
            return value;
        if (targetType == int.class || targetType == Integer.class)
            return Integer.valueOf(value);
        if (targetType == double.class || targetType == Double.class)
            return Double.valueOf(value);
        if (targetType == boolean.class || targetType == Boolean.class)
            return Boolean.valueOf(value);
        if (targetType == long.class || targetType == Long.class)
            return Long.valueOf(value);
        if (targetType == float.class || targetType == Float.class)
            return Float.valueOf(value);
        return value; // Default: Return as a string
    }

    private Object convertArrayType(String[] values, Class<?> componentType) throws Exception {
        Object array = java.lang.reflect.Array.newInstance(componentType, values.length);
        for (int i = 0; i < values.length; i++) {
            java.lang.reflect.Array.set(array, i, convertType(values[i], componentType));
        }
        return array;
    }

    private enum MiddlewareAction {
        BeforeAction, AfterAction, OnError
    }
    //#endregion
}

