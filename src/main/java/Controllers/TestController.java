package Controllers;

import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.Result;
import mvc.Helpers.JsonConverter;

import mvc.Helpers.PaymentGateway.PaymentGatewayService;
import mvc.Helpers.PaymentGateway.PaymentIndentRequestBody;
import mvc.Helpers.PaymentGateway.PaymentIndentResponseBody;
import mvc.Helpers.PaymentGateway.PaymentIndentSummary;

@WebServlet("/Test/*")
public class TestController extends ControllerBase {

    public Result paymentIndex() throws Exception {
        PaymentGatewayService paymentGateway = new PaymentGatewayService();
        PaymentIndentRequestBody paymentRequestBody = new PaymentIndentRequestBody();

        paymentRequestBody.setAmount(1000);
        paymentRequestBody.setCurrency("usd");
        paymentRequestBody.setPayment_method_types("card");

        paymentGateway.setPaymentRequestBody(paymentRequestBody);

        PaymentIndentResponseBody response = paymentGateway.initTransaction();

        if (response == null) {
            return error("Failed to initiate payment transaction.");
        }

        PaymentIndentSummary summary = paymentGateway.doTransaction(response.getId());

        if (summary == null) {
            return error("Failed to Perform transactions.");
        }

        return success("Payment Details: " + JsonConverter.serialize(summary));
    }

    public Result redirect(boolean status) throws Exception {
        if (status == true) {
            return success();
        }

        return page("index", "Landing"); // No further processing needed after redirect
    }
}
