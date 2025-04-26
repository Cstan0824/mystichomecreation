package Controllers;

import java.sql.Blob;

import javax.sql.rowset.serial.SerialBlob;

import DAO.UserDA;
import DAO.productDAO;
import Models.Products.productImage;
import Models.Users.User;
import Models.Users.UserImage;
import jakarta.persistence.EntityManager;
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
    public Result retrieveProduct(int id) throws Exception {
        productImage pi = productDAO.findImageById(id);
        if (pi == null) {
            return source(null, "product-image-" + id, FileType.PNG);
        }

        byte[] imgBytes;

        try {
            imgBytes = Helpers.convertToByte2(pi.getData());
        } catch (Exception e) {
            e.printStackTrace(System.err);
            return source(null, "product-image-" + id, FileType.PNG);
        }

        if (imgBytes == null || imgBytes.length == 0) {
            return source(null, "product-image-" + id, FileType.PNG);
        }

        FileType fileType = Helpers.getFileTypeFromBytes(imgBytes);
        return source(imgBytes, "product-image-" + id, fileType);
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
        FileType fileType = Helpers.getFileTypeFromBytes(file);

        return file(file, "user-image-" + id, fileType);
    }

    @ActionAttribute(urlPattern = "user/retrieve")
    public Result retrieveUser(Integer id) throws Exception {
        byte[] file = null;
        UserImage userImage = userDA.getUserImageById(id);
        if (userImage != null) {
            file = Helpers.convertToByte(userImage.getImage());
        }
        FileType fileType = Helpers.getFileTypeFromBytes(file);

        return source(file, "user-image-" + id, fileType);
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
