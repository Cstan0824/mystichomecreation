package mvc.Helpers;

@FunctionalInterface
    public interface Callback<T> {
        T get();
    }