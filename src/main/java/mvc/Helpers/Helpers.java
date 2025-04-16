package mvc.Helpers;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

import Models.Accounts.BankType;

public class Helpers {
    public static boolean verifyOTP(String otp) {
        return true;
    }

    public static String escapeString(String str) {
        if (str == null) {
            return null;
        }
        return str.replace("'", "''")
                .replace("&", "&amp;")
                .replace("<", "\\u003C")
                .replace(">", "\\u003E")
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    public static String generateOrderRefNo(Date date, String userId) {
        SimpleDateFormat formatter = new SimpleDateFormat("ddMMyyyy");
        String formattedDate = formatter.format(date);

        return "ORD-" + formattedDate + "-" + userId;
    }

    // TODO: Bin Lookup API: https://bincheck.io/api
    public static BankType getBankTypeByBin(String bin) throws MalformedURLException, IOException {
        // Call Bin Lookup API to get bank type
        String BINTABLE_API_KEY = System.getenv("BINTABLE_API_KEY");
        String url = "https://DOMAIN_ENDPOINTS?api_key=" + BINTABLE_API_KEY;
        URL apiUrl = new URL(url);
        HttpURLConnection conn = (HttpURLConnection) apiUrl.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept-Version", "3");
        return new BankType();
    }
}
