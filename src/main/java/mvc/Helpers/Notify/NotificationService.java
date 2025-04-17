package mvc.Helpers.Notify;

import jakarta.persistence.EntityManager;
import mvc.DataAccess;

public class NotificationService implements Notifiable {

    private Notification notification;
    private EntityManager db = DataAccess.getEntityManager();

    public NotificationService() {
    }

    public NotificationService(Notification notification) {
        this.notification = notification;
    }

    // getter setter for notification data fields
    public Notification getNotification() {
        return notification;
    }

    public void setNotification(Notification notification) {
        this.notification = notification;
    }

    @Override
    public void inform() {
        db.getTransaction().begin();
        db.persist(notification);
        db.getTransaction().commit();
    }

}
