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

    // Composite primary key using Order and Product IDs
    // This means that the combination of order_id and product_id must be unique in this table
    @Id
    @ManyToOne
    @JoinColumn(name = "order_id", referencedColumnName = "order_id")
    private Order order;

    @Id
    @ManyToOne
    @JoinColumn(name = "product_id", referencedColumnName = "product_id")
    private product product;

    @Column(name = "order_quantity")
    private int quantity;

    @Column(name = "ordered_product_price")
    private double orderedProductPrice;

    @Column(name = "selected_variations")
    private String selectedVariations; // use String or JSON handler depending on how you manage it

    // Getters and setters
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
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
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
    // Constructors
    public OrderTransaction() {
    }


    public OrderTransaction(Order order, product product, int quantity, double orderedProductPrice, String selectedVariations) {
        this.order = order;
        this.product = product;
        this.quantity = quantity;
        this.orderedProductPrice = orderedProductPrice;
        this.selectedVariations = selectedVariations;
    }


}
