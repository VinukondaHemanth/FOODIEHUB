
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderDao;
import com.tap.model.Order;
import com.tap.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    private static final String INSERT_ORDER =
            "INSERT INTO orders " +
            "(user_id, restaurant_id, order_date, " +
            "total_amount, status, payment_mode) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_ORDER_BY_ID =
            "SELECT order_id, user_id, restaurant_id, order_date, " +
            "total_amount, status, payment_mode " +
            "FROM orders WHERE order_id = ?";

    private static final String SELECT_ORDERS_BY_USER =
            "SELECT order_id, user_id, restaurant_id, order_date, " +
            "total_amount, status, payment_mode " +
            "FROM orders WHERE user_id = ? " +
            "ORDER BY order_date DESC, order_id DESC";

    private static final String SELECT_ORDERS_BY_RESTAURANT =
            "SELECT order_id, user_id, restaurant_id, order_date, " +
            "total_amount, status, payment_mode " +
            "FROM orders WHERE restaurant_id = ? " +
            "ORDER BY order_date DESC, order_id DESC";

    private static final String UPDATE_ORDER =
            "UPDATE orders SET user_id = ?, restaurant_id = ?, " +
            "order_date = ?, total_amount = ?, status = ?, " +
            "payment_mode = ? WHERE order_id = ?";

    private static final String DELETE_ORDER =
            "DELETE FROM orders WHERE order_id = ?";

    private static final String SELECT_ALL_ORDERS =
            "SELECT order_id, user_id, restaurant_id, order_date, " +
            "total_amount, status, payment_mode " +
            "FROM orders ORDER BY order_date DESC, order_id DESC";

    @Override
    public void addOrder(Order order) {

        if (order == null) {
            throw new IllegalArgumentException(
                    "Order cannot be null."
            );
        }

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                throw new SQLException(
                        "Database connection is unavailable."
                );
            }

            try (PreparedStatement statement =
                    connection.prepareStatement(
                            INSERT_ORDER,
                            Statement.RETURN_GENERATED_KEYS)) {

                statement.setInt(1, order.getUserId());
                statement.setInt(2, order.getRestaurantId());
                statement.setString(3, order.getOrderDate());
                statement.setDouble(4, order.getTotalAmount());
                statement.setString(5, order.getStatus());
                statement.setString(6, order.getPaymentMode());

                int rows = statement.executeUpdate();

                if (rows != 1) {
                    throw new SQLException(
                            "The order was not inserted."
                    );
                }

                try (ResultSet keys = statement.getGeneratedKeys()) {
                    if (keys.next()) {
                        order.setOrderId(keys.getInt(1));
                    } else {
                        throw new SQLException(
                                "The generated order ID was not returned."
                        );
                    }
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to insert order.", e
            );
        }
    }

    @Override
    public Order getOrder(int orderId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_ORDER_BY_ID)) {

            statement.setInt(1, orderId);

            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToOrder(resultSet);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve order.", e
            );
        }

        return null;
    }

    @Override
    public List<Order> getOrdersByUser(int userId) {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             SELECT_ORDERS_BY_USER)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    orders.add(mapResultSetToOrder(resultSet));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve orders for user ID "
                            + userId, e
            );
        }

        return orders;
    }

    @Override
    public List<Order> getOrdersByRestaurant(int restaurantId) {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(
                             SELECT_ORDERS_BY_RESTAURANT)) {

            statement.setInt(1, restaurantId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    orders.add(mapResultSetToOrder(resultSet));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve restaurant orders.", e
            );
        }

        return orders;
    }

    @Override
    public void updateOrder(Order order) {

        if (order == null) {
            throw new IllegalArgumentException(
                    "Order cannot be null."
            );
        }

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(UPDATE_ORDER)) {

            statement.setInt(1, order.getUserId());
            statement.setInt(2, order.getRestaurantId());
            statement.setString(3, order.getOrderDate());
            statement.setDouble(4, order.getTotalAmount());
            statement.setString(5, order.getStatus());
            statement.setString(6, order.getPaymentMode());
            statement.setInt(7, order.getOrderId());

            int rows = statement.executeUpdate();

            if (rows == 0) {
                throw new SQLException(
                        "No order found with ID " + order.getOrderId()
                );
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to update order.", e
            );
        }
    }

    @Override
    public void deleteOrder(int orderId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(DELETE_ORDER)) {

            statement.setInt(1, orderId);
            statement.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to delete order.", e
            );
        }
    }

    @Override
    public List<Order> getAllOrders() {

        List<Order> orders = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement =
                     connection.prepareStatement(SELECT_ALL_ORDERS);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                orders.add(mapResultSetToOrder(resultSet));
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve all orders.", e
            );
        }

        return orders;
    }

    private Order mapResultSetToOrder(ResultSet resultSet)
            throws SQLException {

        Order order = new Order();

        order.setOrderId(resultSet.getInt("order_id"));
        order.setUserId(resultSet.getInt("user_id"));
        order.setRestaurantId(resultSet.getInt("restaurant_id"));
        order.setOrderDate(resultSet.getString("order_date"));
        order.setTotalAmount(resultSet.getDouble("total_amount"));
        order.setStatus(resultSet.getString("status"));
        order.setPaymentMode(resultSet.getString("payment_mode"));

        return order;
    }
}
