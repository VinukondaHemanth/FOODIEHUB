
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderItemDao;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDaoImpl implements OrderItemDao {

    private static final String INSERT_ORDER_ITEM =
            "INSERT INTO orderitem "
            + "(order_id, menu_id, total_amount) "
            + "VALUES (?, ?, ?)";

    private static final String SELECT_ORDER_ITEM_BY_ID =
            "SELECT order_item_id, order_id, menu_id, total_amount "
            + "FROM orderitem WHERE order_item_id = ?";

    private static final String SELECT_ORDER_ITEMS_BY_ORDER =
            "SELECT order_item_id, order_id, menu_id, total_amount "
            + "FROM orderitem WHERE order_id = ? "
            + "ORDER BY order_item_id";

    private static final String SELECT_ORDER_ITEMS_BY_MENU =
            "SELECT order_item_id, order_id, menu_id, total_amount "
            + "FROM orderitem WHERE menu_id = ? "
            + "ORDER BY order_item_id";

    private static final String UPDATE_ORDER_ITEM =
            "UPDATE orderitem SET order_id = ?, menu_id = ?, "
            + "total_amount = ? WHERE order_item_id = ?";

    private static final String DELETE_ORDER_ITEM =
            "DELETE FROM orderitem WHERE order_item_id = ?";

    private static final String SELECT_ALL_ORDER_ITEMS =
            "SELECT order_item_id, order_id, menu_id, total_amount "
            + "FROM orderitem ORDER BY order_item_id";

    // INSERT
    @Override
    public void addOrderItem(OrderItem orderItem) {

        if (orderItem == null) {
            throw new IllegalArgumentException(
                    "Order item cannot be null."
            );
        }

        if (orderItem.getOrderId() <= 0
                || orderItem.getMenuId() <= 0
                || !isValidAmount(orderItem.getTotalAmount())) {

            throw new IllegalArgumentException(
                    "Invalid order item details."
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
                            INSERT_ORDER_ITEM,
                            Statement.RETURN_GENERATED_KEYS)) {

                statement.setInt(1, orderItem.getOrderId());
                statement.setInt(2, orderItem.getMenuId());
                statement.setDouble(3, orderItem.getTotalAmount());

                int rows = statement.executeUpdate();

                if (rows != 1) {
                    throw new SQLException(
                            "Order item was not inserted."
                    );
                }

                try (ResultSet keys = statement.getGeneratedKeys()) {

                    if (keys.next()) {
                        orderItem.setOrderItemId(keys.getInt(1));
                    } else {
                        throw new SQLException(
                                "Generated order item ID was not returned."
                        );
                    }
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to add order item.", e
            );
        }
    }

    // SELECT ONE ORDER ITEM
    @Override
    public OrderItem getOrderItem(int orderItemId) {

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                throw new SQLException(
                        "Database connection is unavailable."
                );
            }

            try (PreparedStatement statement =
                    connection.prepareStatement(SELECT_ORDER_ITEM_BY_ID)) {

                statement.setInt(1, orderItemId);

                try (ResultSet resultSet = statement.executeQuery()) {

                    if (resultSet.next()) {
                        return mapResultSetToOrderItem(resultSet);
                    }
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve order item.", e
            );
        }

        return null;
    }

    // SELECT ITEMS FOR ONE ORDER
    @Override
    public List<OrderItem> getOrderItemsByOrder(int orderId) {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                throw new SQLException(
                        "Database connection is unavailable."
                );
            }

            try (PreparedStatement statement =
                    connection.prepareStatement(
                            SELECT_ORDER_ITEMS_BY_ORDER)) {

                statement.setInt(1, orderId);

                try (ResultSet resultSet = statement.executeQuery()) {

                    while (resultSet.next()) {
                        orderItems.add(mapResultSetToOrderItem(resultSet));
                    }
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve items for order " + orderId, e
            );
        }

        return orderItems;
    }

    // SELECT ITEMS FOR ONE MENU ITEM
    @Override
    public List<OrderItem> getOrderItemsByMenu(int menuId) {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                throw new SQLException(
                        "Database connection is unavailable."
                );
            }

            try (PreparedStatement statement =
                    connection.prepareStatement(
                            SELECT_ORDER_ITEMS_BY_MENU)) {

                statement.setInt(1, menuId);

                try (ResultSet resultSet = statement.executeQuery()) {

                    while (resultSet.next()) {
                        orderItems.add(mapResultSetToOrderItem(resultSet));
                    }
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve order items for menu " + menuId, e
            );
        }

        return orderItems;
    }

    // UPDATE
    @Override
    public void updateOrderItem(OrderItem orderItem) {

        if (orderItem == null) {
            throw new IllegalArgumentException(
                    "Order item cannot be null."
            );
        }

        if (orderItem.getOrderItemId() <= 0
                || orderItem.getOrderId() <= 0
                || orderItem.getMenuId() <= 0
                || !isValidAmount(orderItem.getTotalAmount())) {

            throw new IllegalArgumentException(
                    "Invalid order item details."
            );
        }

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                throw new SQLException(
                        "Database connection is unavailable."
                );
            }

            try (PreparedStatement statement =
                    connection.prepareStatement(UPDATE_ORDER_ITEM)) {

                statement.setInt(1, orderItem.getOrderId());
                statement.setInt(2, orderItem.getMenuId());
                statement.setDouble(3, orderItem.getTotalAmount());
                statement.setInt(4, orderItem.getOrderItemId());

                statement.executeUpdate();
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to update order item.", e
            );
        }
    }

    // DELETE
    @Override
    public void deleteOrderItem(int orderItemId) {

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                throw new SQLException(
                        "Database connection is unavailable."
                );
            }

            try (PreparedStatement statement =
                    connection.prepareStatement(DELETE_ORDER_ITEM)) {

                statement.setInt(1, orderItemId);
                statement.executeUpdate();
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to delete order item.", e
            );
        }
    }

    // SELECT ALL
    @Override
    public List<OrderItem> getAllOrderItems() {

        List<OrderItem> orderItems = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection()) {

            if (connection == null) {
                throw new SQLException(
                        "Database connection is unavailable."
                );
            }

            try (PreparedStatement statement =
                    connection.prepareStatement(SELECT_ALL_ORDER_ITEMS);
                 ResultSet resultSet = statement.executeQuery()) {

                while (resultSet.next()) {
                    orderItems.add(mapResultSetToOrderItem(resultSet));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                    "Unable to retrieve all order items.", e
            );
        }

        return orderItems;
    }

    // DATABASE ROW TO JAVA OBJECT
    private OrderItem mapResultSetToOrderItem(ResultSet resultSet)
            throws SQLException {

        OrderItem orderItem = new OrderItem();

        orderItem.setOrderItemId(
                resultSet.getInt("order_item_id"));

        orderItem.setOrderId(
                resultSet.getInt("order_id"));

        orderItem.setMenuId(
                resultSet.getInt("menu_id"));

        orderItem.setTotalAmount(
                resultSet.getDouble("total_amount"));

        return orderItem;
    }

    private boolean isValidAmount(double amount) {
        return amount >= 0
                && !Double.isNaN(amount)
                && !Double.isInfinite(amount);
    }
}
