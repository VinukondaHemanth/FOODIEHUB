
package com.tap.controller;

import java.io.IOException;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final MenuDaoImpl menuDao = new MenuDaoImpl();

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-store");

        HttpSession session = req.getSession();
        String action = req.getParameter("action");
        Cart cart = (Cart) session.getAttribute("cart");

        // Clear the complete cart.
        if ("clear".equals(action)) {
            if (cart != null) {
                cart.clearCart();
            }

            session.removeAttribute("cart");

            writeJson(resp,
                    "{\"success\":true,"
                    + "\"quantity\":0,"
                    + "\"totalAmount\":0,"
                    + "\"itemCount\":0,"
                    + "\"empty\":true}");
            return;
        }

        // Validate menuId.
        int menuId;

        try {
            String menuIdParameter = req.getParameter("menuId");

            if (menuIdParameter == null
                    || menuIdParameter.trim().isEmpty()) {
                writeError(resp, "Menu ID is required.");
                return;
            }

            menuId = Integer.parseInt(menuIdParameter);

            if (menuId <= 0) {
                writeError(resp, "Invalid menu ID.");
                return;
            }

        } catch (NumberFormatException e) {
            writeError(resp, "Invalid menu ID.");
            return;
        }

        // ADD ITEM / CONFIRM RESTAURANT SWITCH.
        if ("add".equals(action)
                || "confirmSwitch".equals(action)
                || action == null
                || action.trim().isEmpty()) {

            Menu menu = menuDao.getMenu(menuId);

            if (menu == null) {
                writeError(resp, "Menu item not found.");
                return;
            }

            if (!menu.isAvailable()) {
                writeError(resp, "This item is currently unavailable.");
                return;
            }

            int selectedRestaurantId = menu.getRestaurantId();

            boolean switchingRestaurant =
                    cart != null
                    && !cart.isEmpty()
                    && cart.getRestaurantId() != selectedRestaurantId;

            // A different restaurant requires explicit confirmation.
            // Do not modify the old cart in this branch.
            if (switchingRestaurant
                    && !"confirmSwitch".equals(action)) {

                writeJson(resp,
                        "{\"success\":false,"
                        + "\"requiresConfirmation\":true}");
                return;
            }

            // A confirmation request is accepted only when the
            // selected menu item belongs to a different restaurant.
            // For a regular add, this branch is reached only when
            // the cart is empty or belongs to the same restaurant.
            if (cart == null
                    || cart.isEmpty()
                    || cart.getRestaurantId() != selectedRestaurantId) {

                cart = new Cart(selectedRestaurantId);
            }

            // Add the selected item.
            CartItem cartItem = new CartItem(
                    menu.getMenuId(),
                    menu.getItemName(),
                    menu.getPrice(),
                    1,
                    menu.getImagePath()
            );

            cart.addItem(cartItem);
            session.setAttribute("cart", cart);

            CartItem updatedItem = cart.getItem(menuId);

            int quantity = updatedItem != null
                    ? updatedItem.getQuantity()
                    : 0;

            writeJson(resp,
                    "{\"success\":true,"
                    + "\"quantity\":" + quantity + ","
                    + "\"totalAmount\":" + cart.getTotalAmount() + ","
                    + "\"itemCount\":" + cart.getItemCount() + "}");
            return;
        }

        // All remaining actions need an existing cart.
        if (cart == null || cart.isEmpty()) {
            session.removeAttribute("cart");
            writeError(resp, "Your cart is empty.");
            return;
        }

        // Check that the requested menu item belongs to this cart's
        // restaurant before allowing quantity changes or removal.
        Menu menu = menuDao.getMenu(menuId);

        if (menu == null) {
            writeError(resp, "Menu item not found.");
            return;
        }

        if (menu.getRestaurantId() != cart.getRestaurantId()) {
            writeError(resp,
                    "You can only update items from your current restaurant.");
            return;
        }

        // Update the requested item.
        if ("increase".equals(action)) {
            cart.increaseQuantity(menuId);

        } else if ("decrease".equals(action)) {
            cart.decreaseQuantity(menuId);

        } else if ("remove".equals(action)) {
            cart.removeItem(menuId);

        } else {
            writeError(resp, "Invalid cart action.");
            return;
        }

        // Remove the session cart if no items remain.
        if (cart.isEmpty()) {
            session.removeAttribute("cart");

            writeJson(resp,
                    "{\"success\":true,"
                    + "\"quantity\":0,"
                    + "\"totalAmount\":0,"
                    + "\"itemCount\":0,"
                    + "\"empty\":true}");
            return;
        }

        session.setAttribute("cart", cart);

        CartItem updatedItem = cart.getItem(menuId);

        int quantity = updatedItem != null
                ? updatedItem.getQuantity()
                : 0;

        writeJson(resp,
                "{\"success\":true,"
                + "\"quantity\":" + quantity + ","
                + "\"totalAmount\":" + cart.getTotalAmount() + ","
                + "\"itemCount\":" + cart.getItemCount() + "}");
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    private void writeError(HttpServletResponse resp, String message)
            throws IOException {

        writeJson(resp,
                "{\"success\":false,"
                + "\"quantity\":0,"
                + "\"totalAmount\":0,"
                + "\"message\":\"" + escapeJson(message) + "\"}");
    }

    private void writeJson(HttpServletResponse resp, String json)
            throws IOException {

        resp.getWriter().write(json);
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
