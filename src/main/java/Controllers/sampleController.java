package Controllers;

import java.sql.Date;
import java.util.List;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import DAO.devDA;
import Models.dev;
import jakarta.servlet.annotation.WebServlet;
import mvc.ControllerBase;
import mvc.Result;
import mvc.Annotations.HttpRequest;
import mvc.Annotations.SyncCache;
import mvc.Http.HttpMethod;

@WebServlet("/sample/*")
public class sampleController extends ControllerBase {

    private devDA devDA = new devDA();
    public Result index()  throws Exception{
        System.out.println("Index");
        return page();
    }

    /*@Test Data
    {
    "name": "test1",
    "email": "test@gmail.com",
    "age": 3,
    "test" :{
        "id":3,
        "username":"test2",
        "password":"password123",
        "email":"test@gmail.com",
        "created_date":"2025-03-03"
    },
    "password": "password123",
    "devs":[
        {
        "id":1,
        "username":"test-1",
        "password":"password123",
        "email":"test@gmail.com",
        "created_date":"2025-03-03"
    }
    ,
    {
        "id":2,
        "username":"test-2",
        "password":"password123",
        "email":"test@gmail.com",
        "created_date":"2025-03-03"
    },{
        "id":3,
        "username":"test-3",
        "password":"password123",
        "email":"test@gmail.com",
        "created_date":"2025-03-03"
    }
    ],
    "devsArr":[
        {
        "id":1,
        "created_date":"2025-03-03"
    }
    ,
    {
        "id":2,
        "username":"test-21",
        "password":"password123",
        "created_date":"2025-03-03"
    },{
        "id":3,
        "username":"test-31",
        "password":"password123",
        "email":"test@gmail.com",
        "created_date":"2025-03-03"
    }
    ]
    }
    */

    public Result views(String name, String password, String email, int age, dev test, List<dev> devs, dev[] devsArr,
            String[] args)  throws Exception{
        ObjectMapper objectMapper = new ObjectMapper();
        System.out.println(name);
        System.out.println(password);
        System.out.println(email);
        System.out.println(age);
        // System.out.println(test.getUsername());
        // System.out.println(devs.get(0).getUsername());
        // System.out.println("0: " + devsArr[0].getUsername());
        // System.out.println("1: " + devsArr[1].getUsername());
        // System.out.println("2: " + devsArr[2].getUsername());
        for (String arg : args) {
            System.out.println(arg);
        }

        JsonNode jsonResponse = objectMapper.createObjectNode();

        // Check credentials

        ((ObjectNode) jsonResponse).put("success", true);
        ((ObjectNode) jsonResponse).put("username", name);
        ((ObjectNode) jsonResponse).put("message", "Welcome to the sample module!");

        return json(jsonResponse);
    }

    public Result test()  throws Exception{
        //get env variable from docker-compose.yaml
        Date date = Date.valueOf("2025-03-22");
        dev user = new dev("username", "password", date, "email");
        devDA.addUser(user);
        return page();
    }

    @SyncCache(channel = "dev", message = "from sample/addDev")
    @HttpRequest(HttpMethod.POST)
    public Result addDev(dev user)  throws Exception{
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
}
