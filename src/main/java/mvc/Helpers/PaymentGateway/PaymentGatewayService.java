package mvc.Helpers.PaymentGateway;

import java.io.IOException;

import mvc.Helpers.JsonConverter;
import mvc.Http.HttpByPassSSLCertificate;
import okhttp3.FormBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

//TODO: https://dashboard.stripe.com/test/dashboard
public class PaymentGatewayService {
    private static final String STRIPE_BASE_URL = System.getenv("STRIPE_BASE_URL");
    private static final String STRIPE_API_KEY = System.getenv("STRIPE_API_KEY");
    private static final String STRIPE_SECRET_KEY = System.getenv("STRIPE_SECRET_KEY");
    private static final String DEFAULT_PAYMENT_CARD_ID = "pm_card_visa";
    private OkHttpClient clientHttp = HttpByPassSSLCertificate.getUnsafeClient();
    private PaymentIndentRequestBody paymentRequestBody = new PaymentIndentRequestBody();
    private boolean isTestMode = true;

    public PaymentGatewayService() {

    }

    public PaymentIndentRequestBody getPaymentRequestBody() {
        return paymentRequestBody;
    }

    public void setPaymentRequestBody(PaymentIndentRequestBody paymentRequestBody) {
        this.paymentRequestBody = paymentRequestBody;
    }

    public PaymentIndentResponseBody initTransaction() {
        // Build Form Body
        RequestBody body = new FormBody.Builder()
                .add("amount",
                        paymentRequestBody.getAmount() + "") // in cents
                .add("currency",
                        paymentRequestBody.getCurrency())
                .add("payment_method_types[]", paymentRequestBody
                        .getPayment_method_types() + "")
                .build();

        // Build Request
        Request request = new Request.Builder()
                .url(STRIPE_BASE_URL + "/payment_intents")
                .post(body)
                .addHeader("Authorization", "Bearer " + STRIPE_SECRET_KEY)
                .addHeader("Content-Type", "application/x-www-form-urlencoded")
                .build();

        try (Response response = clientHttp.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                return null;
            }

            // Parse JSON response
            String json = response.body().string();
            PaymentIndentResponseBody paymentResponseBody = JsonConverter
                    .deserialize(json, PaymentIndentResponseBody.class).get(0);

            // Print result - DEBUG
            System.out.println("PaymentIntent ID: " + paymentResponseBody.getId());
            System.out.println("Client Secret: " + paymentResponseBody.getClient_secret());
            System.out.println("Status: " + paymentResponseBody.getStatus());
            System.out.println("Amount: " + paymentResponseBody.getAmount() / 100.0 + " "
                    + paymentResponseBody.getCurrency().toUpperCase());
            return paymentResponseBody;

        } catch (IOException e) {
            e.printStackTrace(System.err);
            return null;
        }
    }

    public PaymentIndentSummary doTransaction(String pamynetIntentId) {
        RequestBody body = new FormBody.Builder()
                .add("payment_method",
                        DEFAULT_PAYMENT_CARD_ID)
                .build();

        Request request = new Request.Builder()
                .url(STRIPE_BASE_URL + "/payment_intents/" + pamynetIntentId + "/confirm")
                .post(body)
                .addHeader("Authorization", "Bearer " + STRIPE_SECRET_KEY)
                .addHeader("Content-Type", "application/x-www-form-urlencoded")
                .build();

        try (Response response = clientHttp.newCall(request).execute()) {
            // return true if success
            if (response.isSuccessful()) {
                // Parse JSON response
                String json = response.body().string();
                PaymentIndentSummary paymentResponseBody = JsonConverter
                        .deserialize(json, PaymentIndentSummary.class).get(0);

                return paymentResponseBody;
            } else {
                // Print error message - DEBUG
                String json = response.body().string();
                System.out.println("Error: " + json);
                return null;
            }
        } catch (IOException e) {
            e.printStackTrace(System.err);
            return null;
        }
    }
}
