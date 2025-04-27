package Controllers;

import java.util.List;

import DAO.UserDAO;
import DAO.productDAO;
import DTO.UserSession;
import Models.Products.product;
import Models.Products.productFeedback;
import Models.Products.productType;
import Models.Users.User;
import Models.Users.UserImage;
import jakarta.persistence.EntityManager;
import mvc.Annotations.HttpRequest;
import mvc.ControllerBase;
import mvc.DataAccess;
import mvc.Helpers.Helpers;
import mvc.Helpers.SessionHelper;
import mvc.Http.HttpMethod;
import mvc.Result;

public class LandingController extends ControllerBase {
    private EntityManager db = DataAccess.getEntityManager();
    private UserDAO userDA = new UserDAO();
    private productDAO productDAO = new productDAO();

    // @Authorization(permissions = "Landing/index")
    public Result index() throws Exception {

        List<product> bestSellers = productDAO.getBestSellingProducts();
        List<product> newProducts = productDAO.getNewArrivalProducts();
        List<product> randomProducts = productDAO.getRandomProductFromEachType();
        List<productType> productTypes = productDAO.getAllProductTypes();
        List<productFeedback> feedbacks = productDAO.getTopRatedProductFeedbacks();

        request.setAttribute("bestSellers", bestSellers);
        request.setAttribute("newProducts", newProducts);
        request.setAttribute("randomProducts", randomProducts);
        request.setAttribute("productTypes", productTypes);
        request.setAttribute("feedbacks", feedbacks);

        return page();
    }

    public Result login() throws Exception {
        return page();
    }

    @HttpRequest(HttpMethod.POST)
    public Result login(String username, String password) throws Exception {
        User user = userDA.getUserByUsername(username);
        SessionHelper session = getSessionHelper();
        UserSession userSession = new UserSession();

        if (user == null) {
            request.setAttribute("error", "Invalid username or password.");
            return page();
        }

        if (!user.getUsername().equals(username)) {
            request.setAttribute("error", "Invalid username or password.");
            return page();
        }

        String userPassword = userDA.getUserPasswordById(user.getId());
        if (!Helpers.verifyPassword(password, userPassword)) {
            request.setAttribute("error", "Invalid username or password.");
            return page();
        }

        List<String> accessUrls = userDA.getUrlAccesses(user.getRole().getId());
        // if (accessUrls == null) {
        // request.setAttribute("error", "User does not have any access permissions.");
        // return page();
        // }

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

        switch (userSession.getRole().toUpperCase()) {
            case "ADMIN":
                return page("index", "Dashboard");
            case "CUSTOMER":
                return page("index");
            case "STAFF":
                return page("index");
            default:
                return page("index");
        }
    }

    @HttpRequest(HttpMethod.POST)
    public Result logout() throws Exception {
        SessionHelper session = getSessionHelper();
        session.clear(); // Invalidate session
        return page("index");
    }

    public Result test() throws Exception {
        return page();
    }
}
