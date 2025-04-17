package Controllers;

import java.io.File;
import java.util.Arrays;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.devDA;
import Models.dev;
import jakarta.servlet.annotation.WebServlet;
import mvc.Annotations.Authorization;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.Helpers.Helpers;
import mvc.Helpers.SessionHelper;
import mvc.Helpers.Mail.MailService;
import mvc.Helpers.Mail.MailType;
import mvc.Helpers.pdf.PdfService;
import mvc.Helpers.pdf.PdfType;
import mvc.ControllerBase;
import mvc.FileType;
import mvc.Http.HttpMethod;
import mvc.Http.HttpStatusCode;
import mvc.Result;

@WebServlet("/dev/*")
public class devController extends ControllerBase {
    private devDA devDA = new devDA();

    // @Authorization(permissions = "viewDev")
    public Result index() throws Exception {
        String userName = "John Doe";
        List<String> features = Arrays.asList(
                "Blazing Fast Performance",
                "Highly Secure System",
                "User-Friendly Interface",
                "24/7 Customer Support");

        // List of testimonials
        List<String> testimonials = Arrays.asList(
                "This product changed my business! - Alice",
                "Highly recommended! - Bob",
                "Amazing service and support! - Charlie");
        // List of Users
        List<dev> users = devDA.getUsers();
        // Set attributes to pass data to JSP
        context.getRequest().setAttribute("userName", userName);
        context.getRequest().setAttribute("features", features);
        context.getRequest().setAttribute("testimonials", testimonials);
        context.getRequest().setAttribute("users", users);
        return page();
    }

    @HttpRequest(HttpMethod.GET)
    public Result login() throws Exception {
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result login(String username, String password) throws Exception {
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);
        ObjectMapper mapper = new ObjectMapper();
        JsonNode json = mapper.createObjectNode();
        ((ObjectNode) json).put("username", username);
        if ("admin".equals(username) && "admin".equals(password)) {
            return json(json, HttpStatusCode.OK, "Login successful");
        }
        return json(json, HttpStatusCode.UNAUTHORIZED, "Login failed");
    }

    @Authorization(permissions = "addDev")
    @HttpRequest(HttpMethod.POST)
    @SyncCache(channel = "dev", message = "from dev/addDev")
    public Result addDev(dev user) throws Exception {
        System.out.println("Add Dev");
        ObjectMapper objectMapper = new ObjectMapper();
        JsonNode jsonResponse = objectMapper.createObjectNode();
        System.out.println(user.getUsername());
        devDA.addUser(user);
        System.out.println("User added successfully");
        ((ObjectNode) jsonResponse).put("success", true);
        ((ObjectNode) jsonResponse).put("username", user.getUsername());
        return json(jsonResponse);
    }

    public Result setSession() throws Exception {
        System.out.println("Sessions");
        SessionHelper session = new SessionHelper(context.getRequest().getSession());
        session.setAuthenticated(true);
        session.setPermissions("addDev");
        return success();
    }

    public Result hashFunction(String password) throws Exception {
        String myPassword = "admin1234";
        boolean response = Helpers.verifyPassword(password, Helpers.hashPassword(myPassword));
        if (response) {
            return success("Password is correct");
        }
        return error();
    }

    public Result mailService() throws Exception {
        try {
            MailService mailService = new MailService();

            mailService
                    .configure().build()
                    .setRecipient("tancs8803@gmail.com")
                    .setMailType(MailType.WELCOME)
                    .setSubject("Welcome To MysticHome Creation")
                    .send();
            System.out.println("Mail sent successfully");
            return success();
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    public Result pdfService() throws Exception {
        PdfService pdfService = new PdfService(PdfType.RECEIPT);

        File file = pdfService.convert();
        if (file == null) {
            return error("PDF conversion failed");
        }
        System.out.println("PDF File Path: " + file.getAbsolutePath());
        return success();
    }

    public Result mailServiceAttachment() throws Exception {
        try {
            MailService mailService = new MailService();
            PdfService pdfService = new PdfService(PdfType.RECEIPT);
            File file = pdfService.convert();

            mailService
                    .configure().build()
                    .setRecipient("")
                    .setMailType(MailType.WELCOME)
                    .setSubject("Welcome To MysticHome Creation")
                    .attach(file)
                    .send();
            System.out.println("Mail sent successfully with attachment");
        } catch (Exception e) {
            return error(e.getMessage());
        }
        return success();
    }

    public Result test() throws Exception {
        return page();
    }

    // Return file from server, client downloads it via browser
    public Result returnFile() throws Exception {
        PdfService pdfService = new PdfService(PdfType.RECEIPT);

        byte[] bytes = pdfService.toByte();
        return file(bytes, "myreciept", FileType.PDF);
    }

    // Handle multiple files and return single file
    // Refer to localhost:8080/web/dev/test page
    @HttpRequest(HttpMethod.POST)
    public Result getFromAttachFile(byte[][] file) throws Exception {
        return file(file[0], "test-file", FileType.PDF);
    }

}
