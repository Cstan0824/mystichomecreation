package mvc.Helpers.Mail;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.Multipart;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.Session;
import jakarta.mail.Transport;

public class MailService implements Mailable {
    private final String MAIL_HOST = System.getenv("MAIL_HOST");
    private final String MAIL_PORT = System.getenv("MAIL_PORT");
    private final String ENABLE_MAIL_AUTH = System.getenv("MAIL_AUTH");
    private final String ENABLE_MAIL_STARTTLS = System.getenv("MAIL_STARTTLS");
    private final String MAIL_SENDER = System.getenv("MAIL_SENDER");
    private final String MAIL_PASSWORD = System.getenv("MAIL_PASSWORD");
    private final String MAIL_TEMPLATE_PATH = System.getenv("MAIL_TEMPLATE_PATH");

    private MimeMessage message;
    private MimeBodyPart mimeBodyPart;
    private MimeBodyPart attachmentBodyPart;
    private Multipart multipart;
    private Session session;

    private String recipient;
    private String[] toCc;
    private String subject;
    private MailType mailType;
    private Map<String, String> values = new HashMap<>();

    public MailService() {
    }

    // setter and return this
    public MailService setRecipient(String recipient) {
        this.recipient = recipient;
        return this;
    }

    public MailService setToCc(String[] toCc) {
        this.toCc = toCc;
        return this;
    }

    public MailService setSubject(String subject) {
        this.subject = subject;
        return this;
    }

    public MailService setMailType(MailType mailType) {
        this.mailType = mailType;
        return this;
    }

    public MailService setValues(Map<String, String> values) {
        this.values = values;
        return this;
    }

    public MailService setValues(String key, String value) {
        this.values.put(key, value);
        return this;
    }

    @Override
    public void send() {
        send(this.recipient, this.toCc, this.subject, this.mailType, this.values);
    }

    @Override
    public void send(String recipient, String subject, MailType mailType) {
        send(recipient, null, subject, mailType);
    }

    @Override
    public void send(String recipient, String[] toCc, String subject, MailType mailType) {
        send(recipient, toCc, subject, mailType, null);
    }

    @Override
    public void send(String recipient, String[] toCc, String subject, MailType mailType, Map<String, String> values) {
        try {
            // Add sout to debug
            this.message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            // Add CC recipients if provided

            if (toCc != null) {
                this.message.setRecipients(Message.RecipientType.CC, InternetAddress.parse(String.join(",", toCc)));
            }
            this.message.setSubject(subject);

            // Retrieve Template
            String html = getHtmlContent(mailType);
            if (values != null) {
                for (Map.Entry<String, String> entry : values.entrySet()) {
                    html = html.replace("##" + entry.getKey() + "##", entry.getValue());
                }
            }

            // Create Mail Body
            this.mimeBodyPart.setContent(html, "text/html; charset=utf-8");
            if (this.attachmentBodyPart != null) {
                this.multipart.addBodyPart(this.attachmentBodyPart);
            }
            this.multipart.addBodyPart(this.mimeBodyPart);

            this.message.setContent(this.multipart);

            // Send Email
            Transport.send(this.message);

        } catch (MessagingException e) {
            System.out.println("MailSender Error: " + e.getMessage());
            // Audit Error
        }
    }

    public MailService configure() {
        Properties properties = System.getProperties();
        // Setting up mail server
        properties.setProperty("mail.smtp.host", MAIL_HOST);
        properties.setProperty("mail.smtp.port", MAIL_PORT);
        properties.setProperty("mail.smtp.auth", ENABLE_MAIL_AUTH);
        properties.setProperty("mail.smtp.starttls.enable", ENABLE_MAIL_STARTTLS);
        properties.setProperty("mail.smtp.ssl.trust", MAIL_HOST);

        session = Session.getInstance(properties, new MailAuthenticator(MAIL_SENDER, MAIL_PASSWORD));
        // session.setDebug(true);
        return this;
    }

    public MailService build() {
        try {
            if (this.session == null) {
                throw new NullPointerException("Session is null. Please configure the MailService before building.");
            }
            this.message = new MimeMessage(this.session);
            this.multipart = new MimeMultipart();
            this.message.setFrom(new InternetAddress(MAIL_SENDER));
            this.mimeBodyPart = new MimeBodyPart();

        } catch (MessagingException e) {
            System.out.println("MailSender Error: " + e.getMessage());
            return null;
        }
        return this;
    }

    public MailService attach(File file) {
        try {
            if (this.attachmentBodyPart == null) {
                this.attachmentBodyPart = new MimeBodyPart();
            }
            this.attachmentBodyPart.attachFile(file);
        } catch (MessagingException | IOException e) {
            System.out.println("MailSender Error: " + e.getMessage());
            return null;
        }

        return this;
    }

    private String getHtmlContent(MailType mailType) {
        File file = new File(MAIL_TEMPLATE_PATH, mailType.get());
        if (!file.exists()) {
            return null;
        }
        // read the file and extract it to string
        try {
            return Files.readString(file.toPath());
        } catch (Exception e) {
            e.printStackTrace(System.err);
            return null;
        }
    }
}
