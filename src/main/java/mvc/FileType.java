package mvc;

public enum FileType {
    PDF("pdf", "application/pdf"),
    JPEG("jpeg", "image/jpeg"),
    JPG("jpg", "image/jpeg"),
    PNG("png", "image/png"),
    GIF("gif", "image/gif"),
    TXT("txt", "text/plain"),
    CSV("csv", "text/csv"),
    DOC("doc", "application/msword"),
    DOCX("docx", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"),
    XLS("xls", "application/vnd.ms-excel"),
    XLSX("xlsx", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"),
    MP4("mp4", "video/mp4"),
    MP3("mp3", "audio/mpeg"),
    ZIP("zip", "application/zip"),
    JSON("json", "application/json"),
    XML("xml", "application/xml"),
    UNKNOWN("bin", "application/octet-stream");

    private String extension;
    private String mimeType;

    FileType(String extension, String mimeType) {
        this.extension = extension;
        this.mimeType = mimeType;
    }

    public String getExtension() {
        return extension;
    }

    public String getMimeType() {
        return mimeType;
    }

    public static boolean contains(String mimeType) {
        for (FileType type : values()) {
            if (type.mimeType.equalsIgnoreCase(mimeType)) {
                return true;
            }
        }
        return false;
    }

    public static FileType fromExtension(String ext) {
        for (FileType type : values()) {
            if (type.extension.equalsIgnoreCase(ext)) {
                return type;
            }
        }
        return UNKNOWN;
    }
}
