package mvc.Helpers.PaymentGateway;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PaymentIndentSummary {

    private int amount;
    private int amount_capturable;
    private int amount_received;
    private String confirmation_method;
    private long created;
    private String currency;
    private String source;
    private String status;

    // Getters & Setters

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public int getAmount_capturable() {
        return amount_capturable;
    }

    public void setAmount_capturable(int amount_capturable) {
        this.amount_capturable = amount_capturable;
    }

    public int getAmount_received() {
        return amount_received;
    }

    public void setAmount_received(int amount_received) {
        this.amount_received = amount_received;
    }

    public String getConfirmation_method() {
        return confirmation_method;
    }

    public void setConfirmation_method(String confirmation_method) {
        this.confirmation_method = confirmation_method;
    }

    public long getCreated() {
        return created;
    }

    public void setCreated(long created) {
        this.created = created;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
