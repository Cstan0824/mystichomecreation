package mvc.Helpers.otps;

import java.sql.Timestamp;

public class OTP {
    private int id;
    private int userId;
    private String otp;
    private Timestamp expiry;

    public OTP() {
        int MINUTES = 10;
        // set the expiry
        this.expiry = new Timestamp(System.currentTimeMillis() + MINUTES * 60 * 1000); // 5 minutes from now
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getExpiry() {
        return expiry;
    }

    public void setExpiry(Timestamp expiry) {
        this.expiry = expiry;
    }

}
