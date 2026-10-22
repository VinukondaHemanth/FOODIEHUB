
package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.LinkedHashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.User;
import com.tap.util.DBConnection;

@WebServlet("/place-order")
public class PlaceOrderController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String cp = request.getContextPath();
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("loggedInUser") instanceof User)) {
            if (isAjax(request)) {
                sendJson(response, HttpServletResponse.SC_UNAUTHORIZED,
                        false, "Your session expired. Please log in again.", cp + "/login.jsp");
            } else {
                response.sendRedirect(cp + "/login.jsp");
            }
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        Cart cart = (Cart) session.getAttribute("cart");

        int userId = user.getUserId();

        System.out.println(
                "[PLACE ORDER] Logged-in user ID: " + userId
        );

        if (userId <= 0) {
            forwardError(request, response,
                    "Invalid user account. Please log in again.");
            return;
        }

        if (cart == null || cart.isEmpty()) {
            if (isAjax(request)) {
                sendJson(response, HttpServletResponse.SC_BAD_REQUEST,
                        false, "Your cart is empty. Add items before checkout.", cp + "/cart");
            } else {
                response.sendRedirect(cp + "/cart");
            }
            return;
        }

        // Accept the normalized legacy parameter and the radio button parameter.
        String payment = trim(request.getParameter("payment"));
        if (payment.isEmpty()) {
            payment = trim(request.getParameter("paymentMethod"));
        }
        if ("ONLINE".equalsIgnoreCase(payment)
                || "Online Payment".equalsIgnoreCase(payment)) {
            payment = "Online Payment";
        } else if ("COD".equalsIgnoreCase(payment)
                || "Cash on Delivery".equalsIgnoreCase(payment)) {
            payment = "COD";
        }

        String fullName = getValue(
                request, session, "fullName", "orderFullName");
        String phone = getValue(
                request, session, "phone", "orderPhone");
        String addressLine1 = getValue(
                request, session, "addressLine1", "orderAddressLine1");
        String city = getValue(
                request, session, "city", "orderCity");
        String state = getValue(
                request, session, "state", "orderState");
        String pinCode = getValue(
                request, session, "pinCode", "orderPinCode");
        String country = getValue(
                request, session, "country", "orderCountry");

        String validationError = null;

        if (fullName.length() < 2
                || !fullName.matches("[A-Za-z][A-Za-z .'-]{1,99}")) {
            validationError = "Full Name: enter a valid name (at least 2 letters).";
        } else if (!phone.matches("[6-9][0-9]{9}")) {
            validationError = "Phone Number: enter a valid 10-digit Indian mobile number.";
        } else if (addressLine1.length() < 5
                || !addressLine1.matches(".*[A-Za-z0-9].*")) {
            validationError = "Address Line 1: enter your house/flat number and street.";
        } else if (!city.matches("[A-Za-z][A-Za-z .'-]{1,69}")) {
            validationError = "City: enter a valid city name.";
        } else if (state.isEmpty()) {
            validationError = "State: please select a state.";
        } else if (!pinCode.matches("[1-9][0-9]{5}")) {
            validationError = "PIN Code: enter a valid 6-digit Indian PIN code.";
        } else if (country.isEmpty()) {
            validationError = "Country: please select a country.";
        }

        if (validationError != null) {
            forwardError(request, response, validationError);
            return;
        }

        if (!"COD".equals(payment)
                && !"Online Payment".equals(payment)) {

            forwardError(request, response,
                    "Please select a valid payment method.");
            return;
        }

        if ("Online Payment".equals(payment)) {

            String demoMethod =
                    (String) session.getAttribute("selectedDemoMethod");

            if (!"UPI".equals(demoMethod)
                    && !"Card".equals(demoMethod)
                    && !"Wallet".equals(demoMethod)) {

                forwardError(request, response,
                        "Please select a valid demo payment method.");
                return;
            }
        }

        int restaurantId = cart.getRestaurantId();

        if (restaurantId <= 0) {
            forwardError(request, response,
                    "Restaurant information is missing from your cart.");
            return;
        }

        Cart successCart = new Cart(restaurantId);
        Map<Integer, Integer> quantities = new LinkedHashMap<>();
        double total = 0.0;

        for (CartItem item : cart.getItems()) {

            if (item == null
                    || item.getMenuId() <= 0
                    || item.getQuantity() <= 0
                    || item.getPrice() < 0) {

                forwardError(request, response,
                        "Your cart contains invalid item details.");
                return;
            }

            double subtotal = item.getPrice() * item.getQuantity();

            if (Double.isNaN(subtotal)
                    || Double.isInfinite(subtotal)) {

                forwardError(request, response,
                        "An item has an invalid price.");
                return;
            }

            total += subtotal;

            successCart.addItem(new CartItem(
                    item.getMenuId(),
                    item.getItemName(),
                    item.getPrice(),
                    item.getQuantity(),
                    item.getImagePath()
            ));

            quantities.put(item.getMenuId(), item.getQuantity());
        }

        // Match the total displayed on payment.jsp: item subtotal + delivery fee (₹30) + packaging fee (₹10).
        total += 30.00 + 10.00;

        if (total <= 0
                || Double.isNaN(total)
                || Double.isInfinite(total)) {

            forwardError(request, response,
                    "The order total is invalid.");
            return;
        }

        Connection connection = null;
        boolean committed = false;

        try {
            connection = DBConnection.getConnection();

            if (connection == null) {
                throw new SQLException(
                        "Database connection is unavailable.");
            }

            System.out.println(
                    "[PLACE ORDER] Database: "
                            + connection.getCatalog()
            );

            connection.setAutoCommit(false);

            int orderId;

            String orderSql =
                    "INSERT INTO orders "
                    + "(user_id, restaurant_id, order_date, "
                    + "total_amount, status, payment_mode) "
                    + "VALUES (?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = connection.prepareStatement(
                    orderSql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setInt(1, userId);
                ps.setInt(2, restaurantId);
                ps.setTimestamp(3,
                        new Timestamp(System.currentTimeMillis()));
                ps.setDouble(4, total);
                ps.setString(5, "Placed");
                ps.setString(6, payment);

                int rows = ps.executeUpdate();

                if (rows != 1) {
                    throw new SQLException(
                            "Order was not inserted.");
                }

                try (ResultSet keys = ps.getGeneratedKeys()) {

                    if (!keys.next()) {
                        throw new SQLException(
                                "Order ID was not generated.");
                    }

                    orderId = keys.getInt(1);
                }
            }

            String itemSql =
                    "INSERT INTO orderitem "
                    + "(order_id, menu_id, total_amount) "
                    + "VALUES (?, ?, ?)";

            try (PreparedStatement ps =
                    connection.prepareStatement(itemSql)) {

                for (CartItem item : successCart.getItems()) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getMenuId());
                    ps.setDouble(3,
                            item.getPrice() * item.getQuantity());
                    ps.addBatch();
                }

                int[] results = ps.executeBatch();

                if (results.length != successCart.getItemCount()) {
                    throw new SQLException(
                            "Not all order items were saved.");
                }
            }

            connection.commit();
            committed = true;

            Order order = new Order();
            order.setOrderId(orderId);
            order.setUserId(userId);
            order.setRestaurantId(restaurantId);
            order.setTotalAmount(total);
            order.setStatus("Placed");
            order.setPaymentMode(payment);

            session.setAttribute("placedOrder", order);
            session.setAttribute("successCart", successCart);
            session.setAttribute("successQuantities", quantities);
            session.setAttribute(
                    "successRestaurantName", "FoodieHub Restaurant");

            session.setAttribute("orderFullName", fullName);
            session.setAttribute("orderPhone", phone);
            session.setAttribute("orderAddressLine1", addressLine1);
            session.setAttribute("orderCity", city);
            session.setAttribute("orderState", state);
            session.setAttribute("orderPinCode", pinCode);
            session.setAttribute("orderCountry", country);

            if ("Online Payment".equals(payment)) {
                session.setAttribute(
                        "paymentStatusMessage",
                        "Demo payment confirmed. No real money was charged.");
            } else {
                session.setAttribute(
                        "paymentStatusMessage",
                        "Cash on Delivery selected. Pay when your order arrives.");
            }

            // Log the exact saved order for troubleshooting.
            System.out.println(
                    "[PLACE ORDER] Saved order ID: " + orderId
                    + ", user ID: " + userId
                    + ", total: " + total
            );

            cart.clearCart();
            session.removeAttribute("cart");
            session.removeAttribute("pendingPaymentAmount");
            session.removeAttribute("selectedDemoMethod");

            // Return JSON to the checkout AJAX request; normal form posts redirect.
            if (isAjax(request)) {
                sendJson(response, HttpServletResponse.SC_OK, true,
                        "Order placed successfully.", cp + "/order-success.jsp");
            } else {
                response.sendRedirect(cp + "/order-success.jsp");
            }

        } catch (Exception e) {

            if (connection != null && !committed) {
                try {
                    connection.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }
            }

            getServletContext().log(
                    "FoodieHub order placement failed.", e);

            forwardError(request, response,
                    "Order placement failed. Check the Eclipse Console.");

        } finally {

            if (connection != null) {
                try {
                    connection.close();
                } catch (SQLException e) {
                    getServletContext().log(
                            "Error closing database connection.", e);
                }
            }
        }
    }

    private String getValue(
            HttpServletRequest request,
            HttpSession session,
            String parameterName,
            String sessionName) {

        String value = request.getParameter(parameterName);

        if (value == null || value.trim().isEmpty()) {
            Object saved = session.getAttribute(sessionName);
            value = saved == null ? "" : String.valueOf(saved);
        }

        return trim(value);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private void forwardError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {

        if (isAjax(request)) {
            sendJson(response, HttpServletResponse.SC_BAD_REQUEST,
                    false, message, null);
            return;
        }

        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    private boolean isAjax(HttpServletRequest request) {
        return "XMLHttpRequest".equalsIgnoreCase(
                request.getHeader("X-Requested-With"));
    }

    private void sendJson(HttpServletResponse response, int status,
            boolean success, String message, String redirect)
            throws IOException {
        response.setStatus(status);
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-store");
        response.getWriter().write("{\"success\":" + success
                + ",\"message\":\"" + jsonEscape(message) + "\""
                + (redirect == null ? "" : ",\"redirect\":\"" + jsonEscape(redirect) + "\"")
                + "}");
    }

    private String jsonEscape(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }

}
