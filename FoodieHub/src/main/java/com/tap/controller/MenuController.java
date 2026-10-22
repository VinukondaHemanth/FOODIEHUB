package com.tap.controller;

import java.io.IOException;
import java.util.List;
import java.util.Locale;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.daoimpl.RestaurantDaoImpl;
import com.tap.model.Menu;
import com.tap.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final MenuDaoImpl menuDao = new MenuDaoImpl();
    private final RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String restaurantIdParam = req.getParameter("restaurantId");

        if (restaurantIdParam == null || restaurantIdParam.trim().isEmpty()) {
            resp.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Restaurant ID is required."
            );
            return;
        }

        final int restaurantId;

        try {
            restaurantId = Integer.parseInt(restaurantIdParam.trim());

            if (restaurantId <= 0) {
                resp.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Restaurant ID must be a positive number."
                );
                return;
            }
        } catch (NumberFormatException e) {
            resp.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid restaurant ID."
            );
            return;
        }

        try {
            Restaurant restaurant = restaurantDao.getRestaurant(restaurantId);

            if (restaurant == null) {
                resp.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Restaurant not found."
                );
                return;
            }

            List<Menu> menuList = menuDao.getMenusByRestaurant(restaurantId);

            // Keep the existing JSP attribute names.
            req.setAttribute("allMenu", menuList);
            req.setAttribute("restaurant", restaurant);
            req.setAttribute("restaurantId", restaurantId);
            req.setAttribute("restaurantName", restaurant.getName());
            req.setAttribute("restaurantCuisine", restaurant.getCuisineType());
            req.setAttribute("restaurantImage", restaurant.getImagePath());
            req.setAttribute("restaurantDeliveryTime", restaurant.getDeliveryTime());
            req.setAttribute(
                "restaurantRating",
                String.format(Locale.US, "%.1f", restaurant.getRating())
            );

            RequestDispatcher dispatcher = req.getRequestDispatcher("/menu.jsp");
            dispatcher.forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(
                "Unable to load menu for restaurant ID " + restaurantId, e
            );
        }
    }
}