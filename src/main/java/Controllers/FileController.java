package Controllers;

import java.sql.Blob;

import javax.sql.rowset.serial.SerialBlob;

import DAO.UserDAO;
import DAO.productDAO;
import Models.Products.productImage;
import Models.Users.User;
import Models.Users.UserImage;
import jakarta.persistence.EntityManager;
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

public class FileController extends ControllerBase {
    private EntityManager db = DataAccess.getEntityManager();
    private UserDAO userDA = new UserDAO();
    private productDAO productDAO = new productDAO();

    // #region Product
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
}
