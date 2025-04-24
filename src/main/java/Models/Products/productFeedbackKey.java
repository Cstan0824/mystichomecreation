package Models.Products;

import java.io.Serializable;
import java.util.Objects;

public class productFeedbackKey implements Serializable {
    private int productId;
    private int orderId;
    private String createdAt;

    public productFeedbackKey() {}

    public productFeedbackKey(int productId, int orderId, String createdAt) {
        this.productId = productId;
        this.orderId = orderId;
        this.createdAt = createdAt;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof productFeedbackKey)) return false;
        productFeedbackKey that = (productFeedbackKey) o;
        return productId == that.productId &&
               orderId == that.orderId &&
               Objects.equals(createdAt, that.createdAt);
    }

    @Override
    public int hashCode() {
        return Objects.hash(productId, orderId, createdAt);
    }
}
