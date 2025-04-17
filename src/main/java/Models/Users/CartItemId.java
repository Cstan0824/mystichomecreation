package Models.Users;

import java.io.Serializable;
import java.util.Objects;

import Models.Products.product;

public class CartItemId implements Serializable {
    private Cart cart;
    private product product;

    public CartItemId() {}

    public CartItemId(Cart cart, product product) {
        this.cart = cart;
        this.product = product;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof CartItemId)) return false;
        CartItemId that = (CartItemId) o;
        return Objects.equals(cart, that.cart) &&
               Objects.equals(product, that.product);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cart, product);
    }
}
