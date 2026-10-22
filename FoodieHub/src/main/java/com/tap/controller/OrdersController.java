
package com.tap.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.tap.dao.MenuDao;
import com.tap.dao.OrderDao;
import com.tap.dao.OrderItemDao;
import com.tap.dao.RestaurantDao;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.OrderItemDaoImpl;
import com.tap.daoimpl.RestaurantDaoImpl;

import com.tap.model.Menu;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Restaurant;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/orders")
public class OrdersController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDao orderDao;
    private OrderItemDao orderItemDao;
    private RestaurantDao restaurantDao;
    private MenuDao menuDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
        orderItemDao = new OrderItemDaoImpl();
        restaurantDao = new RestaurantDaoImpl();
        menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control",
                "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User loggedInUser =
                (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = loggedInUser.getUserId();

        try {
            // Retrieve all orders belonging to the logged-in user.
            List<Order> orders = orderDao.getOrdersByUser(userId);

            if (orders == null) {
                orders = new ArrayList<>();
            }

            Map<Integer, List<OrderItem>> orderItemsMap =
                    new HashMap<>();

            Map<Integer, Restaurant> restaurantsMap =
                    new HashMap<>();

            Map<Integer, Menu> menusMap =
                    new HashMap<>();

            for (Order order : orders) {

                int orderId = order.getOrderId();
                int restaurantId = order.getRestaurantId();

                // Load the restaurant details for this order.
                Restaurant restaurant =
                        restaurantDao.getRestaurant(restaurantId);

                if (restaurant != null) {
                    restaurantsMap.put(restaurantId, restaurant);
                }

                // Load the items belonging to this order.
                List<OrderItem> items =
                        orderItemDao.getOrderItemsByOrder(orderId);

                if (items == null) {
                    items = new ArrayList<>();
                }

                orderItemsMap.put(orderId, items);

                // Load menu details for each order item.
                for (OrderItem item : items) {

                    int menuId = item.getMenuId();

                    if (!menusMap.containsKey(menuId)) {
                        Menu menu = menuDao.getMenu(menuId);

                        if (menu != null) {
                            menusMap.put(menuId, menu);
                        }
                    }
                }
            }

            // Preserve the attributes expected by orders.jsp.
            request.setAttribute("orders", orders);
            request.setAttribute("orderItemsMap", orderItemsMap);
            request.setAttribute("restaurantsMap", restaurantsMap);
            request.setAttribute("menusMap", menusMap);

            request.getRequestDispatcher("/orders.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            System.err.println(
                    "ERROR while loading orders for User ID: "
                    + userId);

            e.printStackTrace();

            throw new ServletException(
                    "Unable to load your orders.", e);
        }
    }
}
