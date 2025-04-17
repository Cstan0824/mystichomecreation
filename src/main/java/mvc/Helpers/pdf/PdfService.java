package mvc.Helpers.pdf;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;

public class PdfService {
    private PdfType pdfType;
    private Map<String, String> values = new HashMap<>();

    private static final String PDF_TEMPLATE_PATH = System.getenv("PDF_TEMPLATE_PATH");
    private static final String PDF_OUTPUT_PATH = System.getenv("PDF_OUTPUT_PATH");

    public PdfService() {
        // Default constructor
    }

    public PdfService(PdfType pdfType) {
        this.pdfType = pdfType;
    }

    public PdfService(PdfType pdfType, Map<String, String> values) {
        this.pdfType = pdfType;
        this.values = values;
    }

    public Map<String, String> getValues() {
        return values;
    }

    public void setValues(Map<String, String> values) {
        this.values = values;
    }

    public void setValue(String key, String value) {
        this.values.put(key, value);
    }

    public PdfType getPdfType() {
        return pdfType;
    }

    public void setPdfType(PdfType pdfType) {
        this.pdfType = pdfType;
    }

    public File convert() {
        Document document = new Document();
        String html = getHtmlContent();
        File file = new File(getOutputPath());
        try {
            if (file.exists()) {
                file.delete();
            }
            // Create parent directories if they don't exist, create new file
            if (!file.getParentFile().mkdirs() && !file.createNewFile()) {
                return null;
            }
            if (html == null) {
                return null;
            }

            PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(file));
            document.open();

            XMLWorkerHelper.getInstance().parseXHtml(writer, document, new StringReader(html));

            document.close();

        } catch (DocumentException | IOException e) {
            System.out.println("PDF Convert Error: " + e.getMessage());
            return null;
        }
        return file;
    }

    public byte[] toByte() {
        Document document = new Document();
        String html = getHtmlContent();
        if (html == null) {
            return null;
        }
        try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            PdfWriter writer = PdfWriter.getInstance(document, outputStream);

            document.open();
            XMLWorkerHelper.getInstance().parseXHtml(writer, document, new StringReader(html));
            document.close();

            return outputStream.toByteArray(); // return PDF as byte array (Blob-compatible)
        } catch (DocumentException | IOException e) {
            System.out.println("PDF Convert Error: " + e.getMessage());
            return null;
        }
    }

    private String getOutputPath() {
        UUID uuid = UUID.randomUUID();
        String fileName = this.pdfType.get().replace(".html", "") + "-" + uuid.toString() + ".pdf";
        return PDF_OUTPUT_PATH + "/" + fileName;
    }

    private String getHtmlContent() {
        File file = new File(PDF_TEMPLATE_PATH, pdfType.get());
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
