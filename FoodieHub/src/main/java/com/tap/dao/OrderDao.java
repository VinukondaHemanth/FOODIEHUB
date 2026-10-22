package com.tap.dao;

import java.util.List;

import com.tap.model.Order;

public interface OrderDao {

    void addOrder(Order order);

    Order getOrder(int orderId);

    List<Order> getOrdersByUser(int userId);

    List<Order> getOrdersByRestaurant(int restaurantId);

    void updateOrder(Order order);

    void deleteOrder(int orderId);

    List<Order> getAllOrders();
}