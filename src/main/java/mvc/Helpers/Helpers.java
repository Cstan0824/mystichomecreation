package mvc.Helpers;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

import Models.Accounts.BankType;

public class Helpers {
    public static boolean verifyOTP(String otp) {
        return true;
    }

    // TODO: The escape String logic is not working properly, need to fix it
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

    public static String getCurrentDateTime() {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = new Date();
        return formatter.format(date);
    }

    public static String hashPassword(String password) {
        return PasswordHasher.hashPassword(password); // Placeholder for actual
        // password
        // return password; // TEMPORARY
    }

    public static boolean verifyPassword(String password, String hashedPassword) {
        return PasswordHasher.verifyPassword(password, hashedPassword); //
        // Placeholder for actual password verification
        // return password.equals(hashedPassword); // TEMPORARY
    }

    // IDK MAN IT JUST WORKS SO I PASTE IT
    private class PasswordHasher {
        private static final String ALGORITHM = System.getenv("HASH_ALGORITHM");
        private static final int ITERATION = Integer.parseInt(System.getenv("HASH_ITERATION"));
        private static final int KEY_LENGTH = Integer.parseInt(System.getenv("HASH_KEY_LENGTH")); // bits
        private static final String SECRET_KEY = System.getenv("HASH_SECRET_KEY");

        // Hash the password with a generated salt
        public static String hashPassword(String password) {
            byte[] salt = generateSalt();
            byte[] hash = hash((password + SECRET_KEY).toCharArray(), salt);

            return Base64.getEncoder().encodeToString(salt) + ":" + Base64.getEncoder().encodeToString(hash);
        }

        // Verify by re-hashing with extracted salt and same secret key (pepper)
        public static boolean verifyPassword(String password, String hashedPassword) {
            String[] parts = hashedPassword.split(":");
            if (parts.length != 2)
                return false;

            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] originalHash = Base64.getDecoder().decode(parts[1]);
            byte[] newHash = hash((password + SECRET_KEY).toCharArray(), salt);

            return java.util.Arrays.equals(originalHash, newHash);
        }

        // Internal hash logic
        private static byte[] hash(char[] password, byte[] salt) {
            try {
                PBEKeySpec spec = new PBEKeySpec(password, salt, ITERATION, KEY_LENGTH);
                SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
                return factory.generateSecret(spec).getEncoded();
            } catch (Exception e) {
                throw new RuntimeException("Error while hashing password", e);
            }
        }

        // Generate secure random salt
        private static byte[] generateSalt() {
            byte[] salt = new byte[16]; // 128-bit salt
            new SecureRandom().nextBytes(salt);
            return salt;
        }
    }

}
