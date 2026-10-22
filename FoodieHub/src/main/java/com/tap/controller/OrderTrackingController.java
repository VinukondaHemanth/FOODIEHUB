
package com.tap.controller;

import java.io.IOException;
import java.util.Locale;

import com.tap.dao.OrderDao;
import com.tap.dao.RestaurantDao;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Order;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/track-order")
public class OrderTrackingController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDao orderDao = new OrderDaoImpl();
    private final RestaurantDao restaurantDao = new RestaurantDaoImpl();

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();
        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("loggedInUser") instanceof User)) {
            response.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        String orderIdValue = request.getParameter("orderId");
        int orderId;

        try {
            orderId = Integer.parseInt(orderIdValue);

            if (orderId <= 0) {
                throw new NumberFormatException("Invalid order ID");
            }

        } catch (Exception e) {
            response.sendRedirect(
                    contextPath + "/orders?trackingError=invalid");
            return;
        }

        try {
            Order order = orderDao.getOrder(orderId);

            // Never reveal another customer's order.
            if (order == null || order.getUserId() != user.getUserId()) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Order not found.");
                return;
            }

            Restaurant restaurant =
                    restaurantDao.getRestaurant(order.getRestaurantId());

            String rawStatus = order.getStatus() == null
                    ? "Placed"
                    : order.getStatus().trim();

            String lower = rawStatus.toLowerCase(Locale.ROOT);
            boolean cancelled = lower.contains("cancel");

            long elapsedMs = Math.max(
                    0L,
                    System.currentTimeMillis()
                    - parseOrderDate(order.getOrderDate()));

            String displayStatus;
            int step;
            long remainingMs;

            if (cancelled) {
                displayStatus = "Cancelled";
                step = 0;
                remainingMs = 0L;

            } else if (lower.contains("deliver")) {
                displayStatus = "Delivered";
                step = 4;
                remainingMs = 0L;

            } else if (elapsedMs < 120000L) {
                displayStatus = "Preparing";
                step = 2;
                remainingMs = 120000L - elapsedMs;

            } else if (elapsedMs < 300000L) {
                displayStatus = "On the Way";
                step = 3;
                remainingMs = 300000L - elapsedMs;

            } else {
                displayStatus = "Delivered";
                step = 4;
                remainingMs = 0L;
            }

            if (!cancelled
                    && !lower.contains("deliver")
                    && !rawStatus.equals(displayStatus)) {

                order.setStatus(displayStatus);
                orderDao.updateOrder(order);
            }

            request.setAttribute("trackedOrder", order);
            request.setAttribute("trackedRestaurant", restaurant);
            request.setAttribute("trackingStatus", displayStatus);
            request.setAttribute("trackingStep", step);
            request.setAttribute("trackingCancelled", cancelled);
            request.setAttribute(
                    "trackingRemainingMs",
                    Long.valueOf(remainingMs));

            request.getRequestDispatcher("/order-tracking.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            getServletContext().log(
                    "Unable to load tracking for order " + orderId, e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load order tracking. Please try again.");
        }
    }

    private long parseOrderDate(String value) {

        if (value == null || value.trim().isEmpty()) {
            return System.currentTimeMillis();
        }

        String v = value.trim();

        try {
            return java.sql.Timestamp.valueOf(v).getTime();
        } catch (IllegalArgumentException ignored) {
        }

        try {
            return java.sql.Timestamp.valueOf(
                    v.replace('T', ' ')).getTime();
        } catch (IllegalArgumentException ignored) {
        }

        try {
            return java.time.LocalDateTime.parse(
                    v,
                    java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME)
                    .atZone(java.time.ZoneId.systemDefault())
                    .toInstant()
                    .toEpochMilli();

        } catch (java.time.format.DateTimeParseException ignored) {
            return System.currentTimeMillis();
        }
    }
}
