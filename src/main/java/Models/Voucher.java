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
@Table(name = "Voucher")
public class Voucher {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "voucher_id")
    private int id;

    @Column(name = "voucher_name")
    private String name;

    @Column(name = "voucher_description")
    private String description;

    @Column(name = "voucher_type")
    private String type;

    @Column(name = "voucher_min")
    private String minSpent;

    @Column(name = "voucher_amount")
    private String amount;

    @Column(name = "voucher_max")
    private String maxCoverage;

    @Column(name = "voucher_usage_per_month")
    private int usagePerMonth;

    @Column(name = "voucher_status")
    private boolean status;

    @OneToMany(mappedBy = "voucher")
    private List<Payment> payments = new ArrayList<>();

    public Voucher() {

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getMinSpent() {
        return minSpent;
    }

    public void setMinSpent(String minSpent) {
        this.minSpent = minSpent;
    }

    public String getAmount() {
        return amount;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public String getMaxCoverage() {
        return maxCoverage;
    }

    public void setMaxCoverage(String maxCoverage) {
        this.maxCoverage = maxCoverage;
    }

    public int getUsagePerMonth() {
        return usagePerMonth;
    }

    public void setUsagePerMonth(int usagePerMonth) {
        this.usagePerMonth = usagePerMonth;
    }

    public boolean getStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

}
