package Models;

import java.io.Serializable;
import java.util.Objects;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

@Embeddable
public class productFeedbackKey implements Serializable {

    @Column(name = "product_id")
    private int productId;

    @Column(name = "order_id")
    private int orderId;

    // Default constructor
    public productFeedbackKey() {}

    public productFeedbackKey(int productId, int orderId) {
        this.productId = productId;
        this.orderId = orderId;
    }

    // Getters & Setters
    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    // Required for JPA composite key matching
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof productFeedbackKey)) return false;
        productFeedbackKey that = (productFeedbackKey) o;
        return productId == that.productId &&
               orderId == that.orderId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(productId, orderId);
    }
}
