
package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String jsp = "/forgotPassword.jsp";

        if (email == null || newPassword == null
                || confirmPassword == null
                || email.trim().isEmpty()
                || newPassword.isEmpty()
                || confirmPassword.isEmpty()) {

            showError(request, response, jsp, "Please fill in all fields.");
            return;
        }

        email = email.trim();

        if (newPassword.length() < 8) {
            showError(request, response, jsp,
                    "Password must contain at least 8 characters.");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            showError(request, response, jsp,
                    "The two passwords do not match.");
            return;
        }

        String findUserSql =
                "SELECT user_id FROM users WHERE email = ?";

        String updatePasswordSql =
                "UPDATE users SET password = ? WHERE user_id = ?";

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                throw new ServletException(
                        "Database connection is unavailable.");
            }

            int userId;

            // Find exactly one account for this email.
            try (PreparedStatement findUser =
                    connection.prepareStatement(findUserSql)) {

                findUser.setString(1, email);

                try (ResultSet rs = findUser.executeQuery()) {

                    if (!rs.next()) {
                        showError(request, response, jsp,
                                "No account was found with that email.");
                        return;
                    }

                    userId = rs.getInt("user_id");

                    // Avoid changing multiple accounts if emails are duplicated.
                    if (rs.next()) {
                        showError(request, response, jsp,
                                "This email belongs to multiple accounts. "
                                + "Please resolve the duplicate email records "
                                + "before resetting the password.");
                        return;
                    }
                }
            }

            // IMPORTANT: store a BCrypt hash, not the plain password.
            String hashedPassword =
                    BCrypt.hashpw(newPassword, BCrypt.gensalt(10));

            int rowsUpdated;

            try (PreparedStatement update =
                    connection.prepareStatement(updatePasswordSql)) {

                update.setString(1, hashedPassword);
                update.setInt(2, userId);

                rowsUpdated = update.executeUpdate();
            }

            if (rowsUpdated == 1) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/forgotPassword.jsp?updated=1");
            } else {
                showError(request, response, jsp,
                        "Password was not updated. Please try again.");
            }

        } catch (SQLException e) {
            throw new ServletException(
                    "Database error while updating the password.", e);
        }
    }

    private void showError(HttpServletRequest request,
                           HttpServletResponse response,
                           String jsp,
                           String message)
            throws ServletException, IOException {

        request.setAttribute("error", message);
        request.getRequestDispatcher(jsp).forward(request, response);
    }
}
