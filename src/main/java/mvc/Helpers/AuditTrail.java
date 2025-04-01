package mvc.Helpers;

import java.io.File;
import java.io.FileWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Logger;

import jakarta.persistence.EntityManager;
import mvc.DataAccess;

public class AuditTrail {
    private String message;
    private String source;
    private AuditType type;
    private Timestamp timestamp;
    private LogTarget target;
    private static Logger logger = Logger.getLogger(AuditTrail.class.getName());
    private final String LOG_PATH = System.getenv("LOG_PATH");
    private EntityManager db = DataAccess.getEntityManager();

    public AuditTrail() {
        this.timestamp = new Timestamp(System.currentTimeMillis());
    }

    public AuditTrail(String message) {
        this(message, LogTarget.FILE);
    }

    public AuditTrail(String message, LogTarget target) {
        this(message, AuditType.ERROR, target);
    }

    public AuditTrail(String message, AuditType type, LogTarget target) {
        this(message, getCallerInfo(), type, target);
    }

    public AuditTrail(String message, String source, AuditType type, LogTarget target) {
        this();
        this.message = message;
        this.source = source;
        this.type = type;
        this.target = target;
    }

    public static Logger getLogger() {
        return logger;
    }

    public String getMessage() {
        return message;
    }

    public String getSource() {
        return source;
    }

    public AuditType getType() {
        return type;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public void setType(AuditType type) {
        this.type = type;
    }

    public LogTarget getTarget() {
        return target;
    }

    public void setTarget(LogTarget target) {
        this.target = target;
    }

    public void log() {
        // Store to database or log file
        switch (this.type) {
            // case INFO -> logToDatabase();
            case INFO, ERROR, WARNING -> logToFile();
            // case WARNING -> WARNING();
        }

    }

    @Override
    public String toString() {
        return String.format("[%s] [%s] [%s] - %s",
                new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(this.timestamp),
                this.type.toString(),
                this.source,
                this.message);
    }

    // Monitor API calls
    private void logToDatabase() {
        String sql = "INSERT INTO audit_trail (description, source, type, timestamp) VALUES (?, ?, ?, ?)";
        db.getTransaction().begin();
        db.createNativeQuery(sql)
                .setParameter(1, this.message)
                .setParameter(2, this.source)
                .setParameter(3, this.type)
                .setParameter(4, this.timestamp)
                .executeUpdate();
        db.getTransaction().commit();
    }

    private void logToFile() {
        String date = new SimpleDateFormat("dd-MM-yyyy").format(new Date());
        String fileName = date + "-Error.log";
        File file = new File(LOG_PATH + "/" + fileName);

        String logEntry = String.format("[%s] [%s] [%s] - %s",
                new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(this.timestamp),
                this.type.toString(),
                this.source,
                this.message);

        try (FileWriter writer = new FileWriter(file, true)) {
            file.getParentFile().mkdirs(); // Create parent directories if they don't exist
            if (!file.exists()) {
                file.createNewFile();
            }
            writer.write(logEntry + System.lineSeparator());
        } catch (Exception ex) {
            // Handle exception
        }
    }

    private static String getCallerInfo() {
        StackTraceElement[] stackTrace = Thread.currentThread().getStackTrace();

        // stackTrace[0] = Thread.getStackTrace
        // stackTrace[1] = this method (getCallerInfo)
        // stackTrace[2] = logToFile (or whatever method is calling getCallerInfo)
        // stackTrace[3] = the actual caller you want
        if (stackTrace.length > 3) {
            StackTraceElement caller = stackTrace[3];
            return caller.getClassName() + "#" + caller.getMethodName();
        }
        return "-";
    }

    // Store to database or log file
    public enum AuditType {
        INFO,
        WARNING,
        ERROR
    }

    public enum LogTarget {
        DATABASE,
        FILE
    }
}
