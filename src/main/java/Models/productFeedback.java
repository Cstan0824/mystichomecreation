package Models;

import java.io.Serializable;

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
@IdClass(productFeedbackKey.class) // Composite key class
public class productFeedback implements Serializable {

    @Id
    @Column(name = "product_id")
    private int productId;

    @Id
    @Column(name = "order_id")
    private int orderId;

    @Column(name = "rating", nullable = false)
    private double rating;

    @Column(name = "comment", length = 255)
    private String comment;

  
    @Column(name = "feedback_date")
    private java.sql.Date feedbackDate;
   
    @Column(name = "reply", length = 255)
    private String reply;

    @Column(name = "reply_date")
    private java.sql.Date replyDate;

    @Column(name = "review", length = 255)
    private String review; // Optional – if you're using this column

    @ManyToOne
    @JoinColumn(name = "order_id", referencedColumnName = "order_id", insertable = false, updatable = false)
    private Order order;

    @ManyToOne
    @JoinColumn(name = "product_id", referencedColumnName = "product_id", insertable = false, updatable = false)
    private product product;
  

    // Constructors
    public productFeedback() {}

    public productFeedback(int productId, int orderId, double rating, String comment, java.sql.Date feedbackDate) {
        this.productId = productId;
        this.orderId = orderId;
        this.rating = rating;
        this.comment = comment;
        this.feedbackDate = feedbackDate;
    }

    // === Getters & Setters ===
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

    public double getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public java.sql.Date getFeedbackDate() {
        return feedbackDate;
    }

    public void setFeedbackDate(java.sql.Date feedbackDate) {
        this.feedbackDate = feedbackDate;
    }

    public String getReply() {
        return reply;
    }
    
    public void setReply(String reply) {
        this.reply = reply;
    }
    
    public java.sql.Date getReplyDate() {
        return replyDate;
    }
    
    public void setReplyDate(java.sql.Date replyDate) {
        this.replyDate = replyDate;
    }
    
    public String getReview() {
        return review;
    }
    
    public void setReview(String review) {
        this.review = review;
    }
}
