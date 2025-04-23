package mvc.Helpers.PaymentGateway;

public class PaymentIndentRequestBody {
    private int amount;
    private String currency;
    private String payment_method_types;

    public int getAmount() {
        return amount;
    }

    public void setAmount(int amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getPayment_method_types() {
        return payment_method_types;
    }

    public void setPayment_method_types(String payment_method_types) {
        this.payment_method_types = payment_method_types;
    }

}
