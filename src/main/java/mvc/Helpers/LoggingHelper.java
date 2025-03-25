package mvc.Helpers;

import java.util.logging.Logger;

public class LoggingHelper{
    private Logger logger;

    public LoggingHelper(String name) {
        logger = Logger.getLogger(name);
    }

}
