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
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        String loginInput = req.getParameter("loginInput");
        String password = req.getParameter("password");

        UserDaoImpl userDao = new UserDaoImpl();

        User user =
                userDao.getUserByUsernameOrEmail(loginInput);

        boolean passwordMatches = false;

        if (user != null
                && password != null
                && user.getPassword() != null) {

            try {
                passwordMatches = BCrypt.checkpw(
                        password,
                        user.getPassword()
                );
            } catch (IllegalArgumentException e) {
                // Stored password is not a valid BCrypt hash.
                passwordMatches = false;
            }
        }

        if (user != null && passwordMatches) {

            HttpSession session = req.getSession(true);
            session.setAttribute("loggedInUser", user);

            // Return to checkout when login was required by the cart flow.
            // Restrict redirects to this known local destination.
            String afterLoginRedirect =
                    (String) session.getAttribute("afterLoginRedirect");

            if (afterLoginRedirect != null
                    && afterLoginRedirect.equals(
                            req.getContextPath() + "/checkout.jsp")) {
                session.removeAttribute("afterLoginRedirect");
                resp.sendRedirect(afterLoginRedirect);
            } else {
                resp.sendRedirect(req.getContextPath() + "/checkout.jsp");
            }
            return;

        } else {

            req.setAttribute(
                    "error",
                    "Invalid username/email or password"
            );

            req.getRequestDispatcher("login.jsp")
               .forward(req, resp);
        }
    }
}
