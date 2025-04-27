package Models.Users;

public enum RoleType {
    STAFF("staff"),
    CUSTOMER("customer"),
    ADMIN("admin");

    private String description;

    private RoleType(String description) {
        this.description = description;
    }

    public String get() {
        return this.description;
    }
}
