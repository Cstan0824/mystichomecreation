package mvc.Helpers.Mail;

import java.util.Map;

public interface Mailable {

    public void send();

    public void send(String recipient, String subject, MailType mailType);

    public void send(String recipient, String[] toCc, String subject, MailType mailType);

    public void send(String recipient, String[] toCc, String subject, MailType mailType, Map<String, String> values);
}
