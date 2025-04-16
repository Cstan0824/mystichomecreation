package Models.Users;

import Models.Products.product;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "Cart_Item")
@IdClass(CartItemId.class)
public class CartItem {

    @Id
    @ManyToOne
    @JoinColumn(name = "cart_id", referencedColumnName = "cart_id")
    private Cart cart;

    @Id
    @ManyToOne
    @JoinColumn(name = "product_id",
    referencedColumnName = "product_id")
    private product product;

    @Column(name = "quantity")
    private int quantity;

    @Column(name = "selected_variations")
    private String selectedVariation;

    public CartItem() {
    }

    public CartItem(Cart cart, product product, int quantity, String selectedVariation) {
        this.cart = cart;
        this.product = product;
        this.quantity = quantity;
        this.selectedVariation = selectedVariation;
    }

    public Cart getCart() {
        return cart;
    }

    public void setCart(Cart cart) {
        this.cart = cart;
    }

    public product getProduct() {
        return product;
    }

    public void setProduct(product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getSelectedVariation() {
        return selectedVariation;
    }

    public void setSelectedVariation(String selectedVariation) {
        this.selectedVariation = selectedVariation;
    }
    
}
