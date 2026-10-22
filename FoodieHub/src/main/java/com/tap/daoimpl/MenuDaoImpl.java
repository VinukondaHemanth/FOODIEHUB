package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.MenuDao;
import com.tap.model.Menu;
import com.tap.util.DBConnection;

public class MenuDaoImpl implements MenuDao {

    private static final String INSERT_MENU =
        "INSERT INTO menu " +
        "(restaurant_id, item_name, description, price, is_available, image_path) " +
        "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_MENU_BY_ID =
        "SELECT menu_id, restaurant_id, item_name, description, " +
        "price, is_available, image_path " +
        "FROM menu WHERE menu_id = ?";

    /*
     * IMPORTANT:
     * Fetch only the selected restaurant's menu records.
     * Every field, including item_name and image_path, comes from the same row.
     */
    private static final String SELECT_MENUS_BY_RESTAURANT =
        "SELECT menu_id, restaurant_id, item_name, description, " +
        "price, is_available, image_path " +
        "FROM menu " +
        "WHERE restaurant_id = ? " +
        "ORDER BY menu_id ASC";

    private static final String UPDATE_MENU =
        "UPDATE menu SET restaurant_id = ?, item_name = ?, description = ?, " +
        "price = ?, is_available = ?, image_path = ? " +
        "WHERE menu_id = ?";

    private static final String DELETE_MENU =
        "DELETE FROM menu WHERE menu_id = ?";

    private static final String SELECT_ALL_MENUS =
        "SELECT menu_id, restaurant_id, item_name, description, " +
        "price, is_available, image_path " +
        "FROM menu ORDER BY menu_id ASC";

    @Override
    public void addMenu(Menu menu) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(INSERT_MENU)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImagePath());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Unable to insert menu item.", e);
        }
    }

    @Override
    public Menu getMenu(int menuId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_MENU_BY_ID)) {

            ps.setInt(1, menuId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMenu(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException(
                "Unable to fetch menu item ID " + menuId, e
            );
        }

        return null;
    }

    @Override
    public List<Menu> getMenusByRestaurant(int restaurantId) {
        List<Menu> menus = new ArrayList<>();

        if (restaurantId <= 0) {
            return menus;
        }

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                 connection.prepareStatement(SELECT_MENUS_BY_RESTAURANT)) {

            ps.setInt(1, restaurantId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    menus.add(mapResultSetToMenu(rs));
                }
            }

        } catch (SQLException e) {
            // Do not silently display an empty menu when the database fails.
            throw new RuntimeException(
                "Unable to fetch menu items for restaurant ID " + restaurantId,
                e
            );
        }

        return menus;
    }

    @Override
    public void updateMenu(Menu menu) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(UPDATE_MENU)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setString(6, menu.getImagePath());
            ps.setInt(7, menu.getMenuId());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(
                "Unable to update menu item ID " + menu.getMenuId(), e
            );
        }
    }

    @Override
    public void deleteMenu(int menuId) {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(DELETE_MENU)) {

            ps.setInt(1, menuId);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(
                "Unable to delete menu item ID " + menuId, e
            );
        }
    }

    @Override
    public List<Menu> getAllMenus() {
        List<Menu> menus = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(SELECT_ALL_MENUS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                menus.add(mapResultSetToMenu(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Unable to fetch all menu items.", e);
        }

        return menus;
    }

    private Menu mapResultSetToMenu(ResultSet rs) throws SQLException {
        Menu menu = new Menu();

        menu.setMenuId(rs.getInt("menu_id"));
        menu.setRestaurantId(rs.getInt("restaurant_id"));
        menu.setItemName(rs.getString("item_name"));
        menu.setDescription(rs.getString("description"));
        menu.setPrice(rs.getDouble("price"));
        menu.setAvailable(rs.getBoolean("is_available"));
        menu.setImagePath(rs.getString("image_path"));

        return menu;
    }
}