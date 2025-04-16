package Models.Orders;

import java.io.Serializable;
import java.util.Objects;

import Models.Products.product;

public class OrderTransactionId implements Serializable {
    private Order order;
    private product product;

    public OrderTransactionId() {}

    public OrderTransactionId(Order order, product product) {
        this.order = order;
        this.product = product;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof OrderTransactionId)) return false;
        OrderTransactionId that = (OrderTransactionId) o;
        return Objects.equals(order, that.order) &&
               Objects.equals(product, that.product);
    }

    @Override
    public int hashCode() {
        return Objects.hash(order, product);
    }
}
