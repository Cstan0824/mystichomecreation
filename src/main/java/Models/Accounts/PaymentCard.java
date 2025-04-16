package Models.Accounts;

import com.fasterxml.jackson.annotation.JsonProperty;

import Models.Users.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

@Entity
@Table(name = "User_Payment_Card")
public class PaymentCard {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "card_id")
    private int id;

    @Column(name = "card_name")
    private String name;
    @Column(name = "card_no")
    private String cardNumber;
    @Column(name = "expiry")
    private String expiryDate;
    @Column(name = "card_isDefault")
    private boolean isDefault;
    @Column(name = "bank_type_id")
    private int bankTypeId;

    @ManyToOne
    @JoinColumn(name = "user_id", referencedColumnName = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "bank_type_id", referencedColumnName = "bank_type_id", insertable = false, updatable = false)
    private BankType bankType;

    public PaymentCard() {

    }

    public int getBankTypeId() {
        return bankTypeId;
    }

    public void setBankTypeId(int bankTypeId) {
        this.bankTypeId = bankTypeId;
    }

    public BankType getBankType() {
        return bankType;
    }

    public void setBankType(BankType bankType) {
        this.bankType = bankType;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
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

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }

    public int getUserId() {
        return user != null ? user.getId() : 0;
    }

    public void setUserId(int userId) {
        if (this.user == null) {
            this.user = new User(); // or fetch from DB if needed
        }
        this.user.setId(userId);
    }

    @JsonProperty("isDefault")
    public boolean isDefault() {
        return isDefault;
    }

    @JsonProperty("isDefault")
    public void setDefault(boolean isDefault) {
        this.isDefault = isDefault;
    }
}
