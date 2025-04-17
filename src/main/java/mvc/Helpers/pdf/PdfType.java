package mvc.Helpers.pdf;

public enum PdfType {
    RECEIPT("receipt.html"),
    REPORT("report.html");

    private String fileName;

    private PdfType(String fileName) {
        this.fileName = fileName;
    }

    public String get() {
        return fileName;
    }
}
