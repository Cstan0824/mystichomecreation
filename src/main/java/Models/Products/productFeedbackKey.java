
package Models.Products;
import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.Embeddable;


@Embeddable
public class productFeedbackKey implements Serializable {
    private int productId;
    private int orderId;

    public productFeedbackKey() {}

    public productFeedbackKey(int productId, int orderId) {
        this.productId = productId;
        this.orderId = orderId;
    }

    // Getters and Setters
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof productFeedbackKey)) return false;
        productFeedbackKey that = (productFeedbackKey) o;
        return productId == that.productId && orderId == that.orderId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(productId, orderId);
    }
}
