package Models.Orders;


import Models.Products.product;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "Order_Transaction")
@IdClass(OrderTransactionId.class)
public class OrderTransaction {

    @Id
    @ManyToOne
    @JoinColumn(name = "order_id", referencedColumnName = "order_id")
    private Order order;

    @Id
    @ManyToOne
    @JoinColumn(name = "product_id", referencedColumnName = "product_id")
    private product product;

    @Id
    @Column(name = "created_at")
    private String createdAt;

    @Column(name = "order_quantity")
    private int orderQuantity;

    @Column(name = "ordered_product_price")
    private double orderedProductPrice;

    @Column(name = "selected_variations")
    private String selectedVariations;

    public OrderTransaction() {}

    public OrderTransaction(Order order, product product, int orderQuantity, double orderedProductPrice, String selectedVariations, String createdAt) {
        this.order = order;
        this.product = product;
        this.orderQuantity = orderQuantity;
        this.orderedProductPrice = orderedProductPrice;
        this.selectedVariations = selectedVariations;
        this.createdAt = createdAt;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public product getProduct() {
        return product;
    }

    public void setProduct(product product) {
        this.product = product;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public int getOrderQuantity() {
        return orderQuantity;
    }

    public void setOrderQuantity(int orderQuantity) {
        this.orderQuantity = orderQuantity;
    }

    public double getOrderedProductPrice() {
        return orderedProductPrice;
    }

    public void setOrderedProductPrice(double orderedProductPrice) {
        this.orderedProductPrice = orderedProductPrice;
    }

    public String getSelectedVariations() {
        return selectedVariations;
    }

    public void setSelectedVariations(String selectedVariations) {
        this.selectedVariations = selectedVariations;
    }
}
