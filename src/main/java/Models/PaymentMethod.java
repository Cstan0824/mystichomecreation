package Models;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;



@Entity
@Table(name = "Payment_Method")
public class PaymentMethod {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "method_id")
    private int id;

    @Column(name = "method_description")
    private String methodDesc;

    // One payment can only be made using one method, but a method can be used for multiple payments
    @OneToMany(mappedBy = "method")
    private List<Payment> payments = new ArrayList<>();

    // Constructors, getters, and setters

    public PaymentMethod() {
    }

    public PaymentMethod(String methodDesc) {
        this.methodDesc = methodDesc;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMethodDesc() {
        return methodDesc;
    }

    public void setMethodDesc(String methodDesc) {
        this.methodDesc = methodDesc;
    }

}