package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantDao;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    private static final String INSERT_RESTAURANT =
            "INSERT INTO restaurants "
          + "(name, cuisine_type, delivery_time, address, admin_user_id, rating, is_active, image_path) "
          + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SELECT_RESTAURANT_BY_ID =
            "SELECT restaurant_id, name, cuisine_type, delivery_time, address, "
          + "admin_user_id, rating, is_active, image_path "
          + "FROM restaurants WHERE restaurant_id = ?";

    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurants SET name = ?, cuisine_type = ?, delivery_time = ?, "
          + "address = ?, admin_user_id = ?, rating = ?, is_active = ?, image_path = ? "
          + "WHERE restaurant_id = ?";

    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurants WHERE restaurant_id = ?";

    private static final String SELECT_ALL_RESTAURANTS =
            "SELECT restaurant_id, name, cuisine_type, delivery_time, address, "
          + "admin_user_id, rating, is_active, image_path "
          + "FROM restaurants";

    @Override
    public void addRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(INSERT_RESTAURANT)) {

            preparedStatement.setString(1, restaurant.getName());
            preparedStatement.setString(2, restaurant.getCuisineType());
            preparedStatement.setString(3, restaurant.getDeliveryTime());
            preparedStatement.setString(4, restaurant.getAddress());
            preparedStatement.setInt(5, restaurant.getAdminUserId());
            preparedStatement.setDouble(6, restaurant.getRating());
            preparedStatement.setBoolean(7, restaurant.isActive());
            preparedStatement.setString(8, restaurant.getImagePath());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {

        Restaurant restaurant = null;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_RESTAURANT_BY_ID)) {

            preparedStatement.setInt(1, restaurantId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                if (resultSet.next()) {
                    restaurant = mapResultSetToRestaurant(resultSet);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurant;
    }

    @Override
    public void updateRestaurant(Restaurant restaurant) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(UPDATE_RESTAURANT)) {

            preparedStatement.setString(1, restaurant.getName());
            preparedStatement.setString(2, restaurant.getCuisineType());
            preparedStatement.setString(3, restaurant.getDeliveryTime());
            preparedStatement.setString(4, restaurant.getAddress());
            preparedStatement.setInt(5, restaurant.getAdminUserId());
            preparedStatement.setDouble(6, restaurant.getRating());
            preparedStatement.setBoolean(7, restaurant.isActive());
            preparedStatement.setString(8, restaurant.getImagePath());
            preparedStatement.setInt(9, restaurant.getRestaurantId());

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deleteRestaurant(int restaurantId) {

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(DELETE_RESTAURANT)) {

            preparedStatement.setInt(1, restaurantId);

            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement preparedStatement =
                     connection.prepareStatement(SELECT_ALL_RESTAURANTS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                restaurants.add(mapResultSetToRestaurant(resultSet));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    private Restaurant mapResultSetToRestaurant(ResultSet resultSet)
            throws SQLException {

        Restaurant restaurant = new Restaurant();

        restaurant.setRestaurantId(
                resultSet.getInt("restaurant_id"));

        restaurant.setName(
                resultSet.getString("name"));

        restaurant.setCuisineType(
                resultSet.getString("cuisine_type"));

        restaurant.setDeliveryTime(
                resultSet.getString("delivery_time"));

        restaurant.setAddress(
                resultSet.getString("address"));

        restaurant.setAdminUserId(
                resultSet.getInt("admin_user_id"));

        restaurant.setRating(
                resultSet.getDouble("rating"));

        restaurant.setActive(
                resultSet.getBoolean("is_active"));

        restaurant.setImagePath(
                resultSet.getString("image_path"));

        return restaurant;
    }
}