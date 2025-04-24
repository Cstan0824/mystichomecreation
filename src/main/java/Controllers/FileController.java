package Controllers;

import java.sql.Blob;

import javax.sql.rowset.serial.SerialBlob;

import DAO.UserDA;
import DAO.productDAO;
import Models.Products.productImage;
import Models.Users.User;
import Models.Users.UserImage;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.DataAccess;
import mvc.FileType;
import mvc.Result;
import mvc.Annotations.ActionAttribute;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.Helpers.Helpers;
import mvc.Helpers.SessionHelper;
import mvc.Http.HttpMethod;
import mvc.Http.HttpStatusCode;

@WebServlet("/File/Content/*")
public class FileController extends ControllerBase {
    private EntityManager db = DataAccess.getEntityManager();
    private UserDA userDA = new UserDA();
    private productDAO productDAO = new productDAO();


    // #region Product
    @ActionAttribute(urlPattern = "product/upload")
    @HttpRequest(HttpMethod.POST)
    @SyncCache(channel = "ProductImage")
    public Result uploadProduct(byte[][] files) throws Exception {
        // get file from request and save it to the server
        // byte[] files1 = file[0];
        // byte[] files2 = file[1];
 
        

        return success();
    }

    @ActionAttribute(urlPattern = "product/download")
    public Result downloadProduct(int id) throws Exception {
        // get the file data from the server and return it to the client
        byte[] file = null;
        return file(file, "product-image-" + id, FileType.PNG);
    }

    @ActionAttribute(urlPattern = "product/retrieve")
    @SyncCache(channel="ProductImage")
    public Result retrieveProduct(int id) throws Exception {

        // 1) Log the requested ID
        System.out.println("🔍 FileController.retrieveProduct → id = " + id);

        // 2) Load the image entity
        productImage pi = productDAO.findImageById(id);
        if (pi == null) {
            System.out.println("⚠ No productImage found for id = " + id);
            return error(HttpStatusCode.NOT_FOUND, "Image not found");
        }
        System.out.println("✅ Loaded productImage: " + pi);

            // 3) Convert Blob → byte[]
            byte[] imgBytes;
            try {
                imgBytes = Helpers.convertToByte2(pi.getData());
            } catch (Exception e) {
                e.printStackTrace();
                return error(HttpStatusCode.INTERNAL_SERVER_ERROR, "Failed to read image blob");
            }

            if (imgBytes == null || imgBytes.length == 0) {
                System.out.println("⚠ productImage.data was empty for id = " + id);
                return error(HttpStatusCode.NO_CONTENT, "Empty image");
            }
            System.out.println("📦 Image byte length = " + imgBytes.length);

            // 4) (Optional) sniff PNG vs JPEG, or hard‑code
            String contentType = "image/png"; 
            // you could do header checks here if you expect JPEGs

            // 5) Stream it back
            response.setHeader("Content-Type", contentType);
            response.setHeader("Cache-Control", "public, max-age=86400");

            try (ServletOutputStream out = response.getOutputStream()) {
                out.write(imgBytes);
                out.flush();
            }

            // tell the framework we’ve written the response
            return null;

    }


    




    // #endregion

    // #region User
    @ActionAttribute(urlPattern = "user/upload")
    @HttpRequest(HttpMethod.POST)
    @SyncCache(channel = "User")
    public Result uploadUser(byte[][] files) throws Exception {
        SessionHelper session = getSessionHelper();
        int userId = session.getId();
        User user = userDA.getUserById(userId);

        // Convert byte[] to Blob
        byte[] profilePicture = files[0];
        Blob blob = new SerialBlob(profilePicture);

        if (user == null) {
            return error(HttpStatusCode.NOT_FOUND, "User not found");
        }
        UserImage userImage = userDA.getUserImageByUserId(user.getId());
        if (userImage == null) {
            userImage = new UserImage();
            // Create profile picture in db
            db.getTransaction().begin();

            // Upload Image
            userImage.setImage(blob);
            userImage.setUser(user);
            db.persist(userImage);

            db.getTransaction().commit();

            if (db.getTransaction().getRollbackOnly()) {
                return error(HttpStatusCode.INTERNAL_SERVER_ERROR, "Failed to update user image");
            }
            session.setImageId(userImage.getId());
        } else {
            // update profile picture in db
            db.getTransaction().begin();
            userImage.setImage(blob);
            db.merge(userImage);
            db.getTransaction().commit();

            if (db.getTransaction().getRollbackOnly()) {
                return error(HttpStatusCode.INTERNAL_SERVER_ERROR, "Failed to update user image");
            }
        }

        return success();
    }

    @ActionAttribute(urlPattern = "user/download")
    public Result downloadUser(Integer id) throws Exception {
        // get the file data from the server and return it to the client
        byte[] file = null;
        UserImage userImage = userDA.getUserImageById(id);
        if (userImage != null) {
            file = Helpers.convertToByte(userImage.getImage());
        }

        return file(file, "user-image-" + id, FileType.PNG);
    }

    @ActionAttribute(urlPattern = "user/retrieve")
    public Result retrieveUser(Integer id) throws Exception {
        byte[] file = null;
        UserImage userImage = userDA.getUserImageById(id);
        if (userImage != null) {
            file = Helpers.convertToByte(userImage.getImage());
        }
        return source(file, "user-image-" + id, FileType.PNG);
    }
    // #endregion

    // public Result getImage(int id) throws Exception {
    // EntityManager em = DataAccess.getEntityManager();
    // TestImage image = em.find(TestImage.class, id);
    // // convert blob to byte[]
    // byte[] imageBytes = Helpers.convertToByte(image.getImage());
    // FileType contentType = Helpers.getFileTypeFromBytes(imageBytes);

    // return source(imageBytes, "test-get-image-from-src", contentType);
    // }

    // public Result testDownload(int id) throws Exception {
    // EntityManager em = DataAccess.getEntityManager();
    // TestImage image = em.find(TestImage.class, id);
    // // convert blob to byte[]
    // byte[] imageBytes = Helpers.convertToByte(image.getImage());
    // FileType contentType = Helpers.getFileTypeFromBytes(imageBytes);
    // return file(imageBytes, "test-download-image-from-url", contentType);
    // }
}
