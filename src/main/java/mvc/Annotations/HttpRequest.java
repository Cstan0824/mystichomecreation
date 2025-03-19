package mvc.Annotations;

import mvc.Helpers.HttpStatusCode;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface HttpRequest {
    HttpStatusCode value() default HttpStatusCode.OK;
}
