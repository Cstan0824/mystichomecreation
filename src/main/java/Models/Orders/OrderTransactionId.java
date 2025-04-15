package Models.Orders;

import java.io.Serializable;
import java.util.Objects;

public class OrderTransactionId implements Serializable {
    private int order;
    private int product;

    // Constructors
    public OrderTransactionId() {}

    public OrderTransactionId(int order, int product) {
        this.order = order;
        this.product = product;
    }

    // equals() and hashCode() are REQUIRED for composite keys
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof OrderTransactionId)) return false;
        OrderTransactionId that = (OrderTransactionId) o;
        return order == that.order && product == that.product;
    }

    @Override
    public int hashCode() {
        return Objects.hash(order, product);
    }

    // Getters/setters (optional but good practice)
}
