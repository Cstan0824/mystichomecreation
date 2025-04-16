package Models.Products;

import jakarta.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "Product_Type")
public class productType implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "product_type_id")
    private int id;

    @Column(name = "product_type", nullable = false)
    private String type;

    // === Constructors ===
    public productType() {

    }

    public productType(String type) {
        this.type = type;
    }

    // === Getters/Setters ===
    public int getId() {
         return id; 
    
        }
    public void setId(int id) { 
        this.id = id; 
    }

    public String gettype() { 
        return type; 
    }

    public void settype(String type) { 
        this.type = type; 
    }
}
