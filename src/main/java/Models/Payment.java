package Models;

import Models.Accounts.Voucher;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;


@Entity
@Table(name = "Payment")
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    @Column(name = "payment_id")
    private int id;

    // One payment can only be made using one method, but a method can be used for multiple payments
    @ManyToOne
    @JoinColumn(name = "method_id", referencedColumnName = "method_id")
    private PaymentMethod method;  

    // One payment can only use one voucher, but a voucher can be used for multiple payments
    @ManyToOne
    @JoinColumn(name = "voucher_id", referencedColumnName = "voucher_id")
    private Voucher voucher;  

    @Column(name = "payment_info")
    private String paymentInfo; // Store raw JSON as string

    @Column(name = "total_paid")
    private double totalPaid;

    // Constructors, getters, and setters

    public Payment() {
    }

    public Payment(PaymentMethod method, Voucher voucher, double totalPaid) {
        this.method = method;
        this.voucher = voucher;
        this.totalPaid = totalPaid;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public PaymentMethod getMethod() {
        return method;
    }

    public void setMethod(PaymentMethod method) {
        this.method = method;
    }

    public Voucher getVoucher() {
        return voucher;
    }

    public void setVoucher(Voucher voucher) {
        this.voucher = voucher;
    }

    public String getPaymentInfo() {
        return paymentInfo;
    }

    public void setPaymentInfo(String paymentInfo) {
        this.paymentInfo = paymentInfo;
    }

    public double getTotalPaid() {
        return totalPaid;
    }

    public void setTotalPaid(double totalPaid) {
        this.totalPaid = totalPaid;
    }

}