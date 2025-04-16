package Models.Orders;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import Models.Payment;
import Models.Products.productFeedback;
import Models.Users.User;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;



@Entity
@Table(name = "Orders")
public class Order {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "order_id")
    private int id;

    //Multiple orders can be made by a single user
    // A user can have multiple orders, but an order belongs to one user
    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    private User user;

    // One payment is unique to one order
    @OneToOne
    @JoinColumn(name = "payment_id", referencedColumnName = "payment_id")
    private Payment payment;


    // One order can have one status, but a status can be associated with multiple orders
    @ManyToOne
    @JoinColumn(name = "status_id", referencedColumnName = "status_id")
    private OrderStatus status;

    @Column(name = "shipping_information")
    private String shippingInfo;

    @Column(name = "order_date")
    private LocalDate orderDate;

    @Column(name = "pack_date")
    private LocalDate packDate;

    @Column(name = "ship_date")
    private LocalDate shipDate;

    @Column(name = "receive_date")
    private LocalDate receiveDate;

    @Column(name = "order_ref_no")
    private String orderRefNo;

    // One order can have multiple order transactions, but an order transaction belongs to one order
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<OrderTransaction> orderTransactions = new ArrayList<>();

    // One order can have multiple product feedbacks, but a product feedback belongs to one order
    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    private List<productFeedback> productFeedbacks = new ArrayList<>();

    // Constructors, getters, and setters
    public Order() {
    }

    public Order(User user, Payment payment, OrderStatus status, String shippingInfo, LocalDate orderDate, LocalDate packDate, LocalDate shipDate, LocalDate receiveDate, String orderRefNo) {
        this.user = user;
        this.payment = payment;
        this.status = status;
        this.shippingInfo = shippingInfo;
        this.orderDate = orderDate;
        this.packDate = packDate;
        this.shipDate = shipDate;
        this.receiveDate = receiveDate;
        this.orderRefNo = orderRefNo;
    }

    // Getters and Setters

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }
    public void setUser(User user) {
        this.user = user;
    }

    public Payment getPayment() {
        return payment;
    }
    public void setPayment(Payment payment) {
        this.payment = payment;
    }

    public OrderStatus getStatus() {
        return status;
    }
    public void setStatus(OrderStatus status) {
        this.status = status;
    }

    public String getShippingInfo() {
        return shippingInfo;
    }
    public void setShippingInfo(String shippingInfo) {
        this.shippingInfo = shippingInfo;
    }

    public LocalDate getOrderDate() {
        return orderDate;
    }
    public void setOrderDate(LocalDate orderDate) {
        this.orderDate = orderDate;
    }

    public LocalDate getPackDate() {
        return packDate;
    }
    public void setPackDate(LocalDate packDate) {
        this.packDate = packDate;
    }

    public LocalDate getShipDate() {
        return shipDate;
    }
    public void setShipDate(LocalDate shipDate) {
        this.shipDate = shipDate;
    }

    public LocalDate getReceiveDate() {
        return receiveDate;
    }
    public void setReceiveDate(LocalDate receiveDate) {
        this.receiveDate = receiveDate;
    }

    public String getOrderRefNo() {
        return orderRefNo;
    }
    public void setOrderRefNo(String orderRefNo) {
        this.orderRefNo = orderRefNo;
    }

}
