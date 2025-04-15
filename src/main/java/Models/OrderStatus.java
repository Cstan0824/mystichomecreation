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
@Table(name = "Order_Status")
public class OrderStatus{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "status_id")
    private int id;

    @Column(name = "status_description")
    private String statusDesc;

    // One order can have one status, but a status can be associated with multiple orders
    @OneToMany(mappedBy = "status")
    private List<Order> orders = new ArrayList<>();

    // Default constructor
    public OrderStatus() {
    }

    //Contructors, getters, and setters
    public OrderStatus(String statusDesc) {
        this.statusDesc = statusDesc;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStatusDesc() {
        return statusDesc;
    }

    public void setStatusDesc(String statusDesc) {
        this.statusDesc = statusDesc;
    }

}