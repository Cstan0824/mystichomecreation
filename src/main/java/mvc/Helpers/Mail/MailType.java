package mvc.Helpers.Mail;

public enum MailType {
    WELCOME("welcome.html"),
    OTP("otp.html"),
    PASSWORD_RESET("password_reset.html"),
    RECEIPT("receipt.html"),
    NOTIFICATION("notification.html"),
    PROMOTION("promotion.html");

    private String fileName;

    private MailType(String fileName) {
        this.fileName = fileName;
    }

    public String get() {
        return fileName;
    }
}
