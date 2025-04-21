package Models.Products;

import java.io.Serializable;
import java.sql.Date;

import Models.Orders.Order;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "Product_Feedback")
@IdClass(productFeedbackKey.class)
public class productFeedback implements Serializable {

    @Id
    @Column(name = "product_id", insertable = false, updatable = false)
    private int productId;

    @Id
    @Column(name = "order_id", insertable = false, updatable = false)
    private int orderId;

    @ManyToOne
    @JoinColumn(name = "product_id", referencedColumnName = "product_id", insertable = false, updatable = false)
    private product product;

    @ManyToOne
    @JoinColumn(name = "order_id", referencedColumnName = "order_id", insertable = false, updatable = false)
    private Order order;

    @Column(name = "rating", nullable = false)
    private double rating;

    @Column(name = "comment", length = 255)
    private String comment;

    @Column(name = "feedback_date")
    private Date feedbackDate;

    @Column(name = "reply", length = 255)
    private String reply;

    @Column(name = "reply_date")
    private Date replyDate;


    public productFeedback() {}

    // Getters and Setters
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public product getProduct() { return product; }
    public void setProduct(product product) { this.product = product; }

    public Order getOrder() { return order; }
    public void setOrder(Order order) { this.order = order; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public Date getFeedbackDate() { return feedbackDate; }
    public void setFeedbackDate(Date feedbackDate) { this.feedbackDate = feedbackDate; }

    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }

    public Date getReplyDate() { return replyDate; }
    public void setReplyDate(Date replyDate) { this.replyDate = replyDate; }

}
