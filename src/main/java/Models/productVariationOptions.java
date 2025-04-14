package Models;

import java.util.List;
import java.util.Map;

public class productVariationOptions {
    private Map<String, List<String>> options;

    public Map<String, List<String>> getOptions() {
        return options;
    }

    public void setOptions(Map<String, List<String>> options) {
        this.options = options;
    }
}
