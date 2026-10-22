
package com.tap.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.model.Cart;
import com.tap.model.User;

@WebServlet("/start-demo-payment")
public class StartDemoPaymentController extends HttpServlet {

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
                || !(session.getAttribute("loggedInUser")
                        instanceof User)) {

            response.sendRedirect(cp + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user.getUserId() <= 0 || cart == null || cart.isEmpty()) {
            response.sendRedirect(cp + "/cart");
            return;
        }

        String fullName = trim(request.getParameter("fullName"));
        String phone = trim(request.getParameter("phone"));
        String addressLine1 = trim(request.getParameter("addressLine1"));
        String addressLine2 = trim(request.getParameter("addressLine2"));
        String city = trim(request.getParameter("city"));
        String state = trim(request.getParameter("state"));
        String pinCode = trim(request.getParameter("pinCode"));
        String country = trim(request.getParameter("country"));

        String paymentMethod = trim(request.getParameter("paymentMethod"));

        if (fullName.length() < 2
                || !phone.matches("[6-9][0-9]{9}")
                || addressLine1.isEmpty()
                || city.isEmpty()
                || state.isEmpty()
                || !pinCode.matches("[1-9][0-9]{5}")
                || country.isEmpty()) {

            request.setAttribute(
                    "errorMessage",
                    "Please enter valid delivery details.");

            request.getRequestDispatcher("/checkout.jsp")
                    .forward(request, response);
            return;
        }

        if (!"COD".equals(paymentMethod)
                && !"ONLINE".equals(paymentMethod)) {

            request.setAttribute(
                    "errorMessage",
                    "Please select a valid payment method.");

            request.getRequestDispatcher("/checkout.jsp")
                    .forward(request, response);
            return;
        }

        // Preserve delivery information for PlaceOrderController.
        session.setAttribute("orderFullName", fullName);
        session.setAttribute("orderPhone", phone);
        session.setAttribute("orderAddressLine1", addressLine1);
        session.setAttribute("orderAddressLine2", addressLine2);
        session.setAttribute("orderCity", city);
        session.setAttribute("orderState", state);
        session.setAttribute("orderPinCode", pinCode);
        session.setAttribute("orderCountry", country);

        // Preserve the payment method separately from the demo method.
        if ("COD".equals(paymentMethod)) {

            session.setAttribute("selectedOrderPayment", "COD");
            session.removeAttribute("selectedDemoMethod");

        } else {

            session.setAttribute(
                    "selectedOrderPayment", "Online Payment");

            // This is a UI simulation, not a real bank transaction.
            session.setAttribute("selectedDemoMethod", "UPI");
        }

        session.setAttribute(
                "pendingPaymentAmount",
                cart.getTotalAmount() + 30.00 + 10.00);

        System.out.println(
                "[CHECKOUT] Validated checkout for user ID: "
                        + user.getUserId());

        System.out.println(
                "[CHECKOUT] Payment method: "
                        + session.getAttribute("selectedOrderPayment"));

        response.sendRedirect(cp + "/payment.jsp");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
