package mvc.Helpers.otps;

import java.sql.Timestamp;
import java.util.List;

import com.fasterxml.jackson.core.JsonProcessingException;

import DAO.UserDAO;
import Models.Users.User;
import mvc.Cache.Redis;
import mvc.Helpers.JsonConverter;
import mvc.Helpers.Mail.MailService;
import mvc.Helpers.Mail.MailType;

public class OTPHelper {
    private static Redis redis = new Redis();

    public static boolean sendOTP(int id) {
        UserDAO userDA = new UserDAO();
        MailService mailService = new MailService();
        String generatedOtp = otpGenerator();
        OTP OTP = new OTP();
        Timestamp timestamp = new java.sql.Timestamp(System.currentTimeMillis() + 10 * 60 * 1000); // 10 minutes expiry
        int expiry = 10 * 60 * 1000; // 10 minutes expiry
        String json = "";

        User user = userDA.getUserById(id);

        if (user == null) {
            return false;
        }

        // insert into db
        OTP.setOtp(generatedOtp);
        OTP.setUserId(id);
        OTP.setExpiry(timestamp);
        try {
            json = JsonConverter.serialize(OTP);
        } catch (JsonProcessingException e) {
            e.printStackTrace(System.err);
        }
        if ("".equals(json)) {
            return false;
        }

        // Store to redis
        redis.setValue("user-otp-" + id, json, expiry); // 10 minutes expiry

        mailService
                .configure().build()
                .setRecipient(user.getEmail())
                .setSubject("Your OTP")
                .setMailType(MailType.OTP)
                .setValues("otp",
                        generatedOtp)
                .setValues("name",
                        user.getUsername())
                .send();
        return true;
    }

    public static boolean sendOTP(String email) {
        MailService mailService = new MailService();
        String generatedOtp = otpGenerator();
        OTP OTP = new OTP();
        Timestamp timestamp = new java.sql.Timestamp(System.currentTimeMillis() + 10 * 60 * 1000); // 10 minutes expiry
        int expiry = 10 * 60 * 1000; // 10 minutes expiry
        String json = "";

        // insert into db
        OTP.setOtp(generatedOtp);
        OTP.setEmail(email);
        OTP.setExpiry(timestamp);
        try {
            json = JsonConverter.serialize(OTP);
        } catch (JsonProcessingException e) {
            e.printStackTrace(System.err);
        }
        if ("".equals(json)) {
            return false;
        }

        // Store to redis
        redis.setValue("user-otp-" + email, json, expiry); // 10 minutes expiry

        mailService
                .configure().build()
                .setRecipient(email)
                .setSubject("Your OTP")
                .setMailType(MailType.OTP)
                .setValues("otp",
                        generatedOtp)
                .setValues("name",
                        "there")
                .send();
        return true;
    }

    public static boolean verifyOTP(int id, String entryOtp) {
        String key = "user-otp-" + id;
        String json = redis.getValue(key);
        List<OTP> OTP = null;
        try {
            OTP = JsonConverter.deserialize(json, OTP.class);

            if (OTP == null) {
                return false;
            }
            if (OTP.size() == 0) {
                return false;
            }
        } catch (JsonProcessingException e) {
            e.printStackTrace(System.err);
        }
        boolean response = OTP.get(0).getOtp().equals(entryOtp);
        if (response) {
            redis.removeValue(key); // remove the OTP from redis
            return true;
        }
        return false;
    }

    public static boolean verifyOTP(String email, String entryOtp) {
        String key = "user-otp-" + email;
        String json = redis.getValue(key);
        List<OTP> OTP = null;
        try {
            OTP = JsonConverter.deserialize(json, OTP.class);

            if (OTP == null) {
                return false;
            }
            if (OTP.size() == 0) {
                return false;
            }
        } catch (JsonProcessingException e) {
            e.printStackTrace(System.err);
        }
        boolean response = OTP.get(0).getOtp().equals(entryOtp);
        if (response) {
            redis.removeValue(key); // remove the OTP from redis
            return true;
        }
        return false;
    }

    public static String otpGenerator() {
        // generate a 6 digit OTP
        StringBuilder otp = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            otp.append((int) (Math.random() * 10));
        }
        return otp.toString();
    }
}
