package Controllers;

import java.util.List;

import DAO.UserDA;
import DTO.UserCredentials;
import DTO.UserSession;
import Models.Users.User;
import Models.Users.UserImage;
import jakarta.persistence.EntityManager;
import jakarta.servlet.annotation.WebServlet;
import mvc.Annotations.HttpRequest;
import mvc.Helpers.Helpers;
import mvc.Helpers.SessionHelper;
import mvc.ControllerBase;
import mvc.DataAccess;
import mvc.Http.HttpMethod;
import mvc.Result;

@WebServlet("/Landing/*")
public class LandingController extends ControllerBase {
    private EntityManager db = DataAccess.getEntityManager();
    private UserDA userDA = new UserDA();

    // @Authorization(permissions = "Landing/index")
    public Result index() throws Exception {
        return page();
    }

    public Result login() throws Exception {
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result login(UserCredentials userCredential) throws Exception {
        User user = userDA.getUserByUsername(userCredential.getUsername());
        SessionHelper session = getSessionHelper();
        UserSession userSession = new UserSession();
        if (user == null) {
            return error("Invalid username or password.");
        }
        String password = userDA.getUserPasswordById(user.getId());
        if (!Helpers.verifyPassword(userCredential.getPassword(), password)) {
            return error("Invalid username or password.");
        }
        List<String> accessUrls = userDA.getUrlAccesses(user.getRole().getId());
        if (accessUrls == null) {
            return error("User does not have any access permissions.");
        }
        UserImage userImage = userDA.getUserImageByUserId(user.getId());
        if (userImage != null) {
            userSession.setImageId(userImage.getId());
        }
        userSession.setId(user.getId());
        userSession.setUsername(user.getUsername());
        userSession.setEmail(user.getEmail());
        userSession.setRole(user.getRole().getDescription());
        userSession.setAuthenticated(true);
        userSession.setAccessUrls(accessUrls);

        session.setUserSession(userSession);
        SessionHelper demo = getSessionHelper();
        System.out.println(demo.getUserSession().getUsername());
        return success();
    }
}
