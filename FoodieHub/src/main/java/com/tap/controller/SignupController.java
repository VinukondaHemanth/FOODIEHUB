package com.tap.controller;

import java.io.IOException;
import org.mindrot.jbcrypt.BCrypt;
import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/signup")
public class SignupController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        String username =
                req.getParameter("username");

        String password =
                req.getParameter("password");

        String email =
                req.getParameter("email");

        String phone =
                req.getParameter("phone");

        String address =
                req.getParameter("address");

        UserDaoImpl userDao =
                new UserDaoImpl();

        User existingUser =
                userDao.getUserByUsernameOrEmail(username);

        if (existingUser != null) {

            req.setAttribute(
                    "error",
                    "Username already exists"
            );

            req.getRequestDispatcher(
                    "signup.jsp"
            ).forward(req, resp);

            return;
        }

        User user = new User();

        user.setUsername(username);
        String en_password=BCrypt.hashpw(password, BCrypt.gensalt());;
        user.setPassword(en_password);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);

        // Normal signup is always CUSTOMER
        user.setRole("CUSTOMER");

        userDao.addUser(user);

        resp.sendRedirect("login.jsp");
    }
}