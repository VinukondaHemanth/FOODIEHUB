
package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.UserDao;
import com.tap.model.User;
import com.tap.util.DBConnection;

public class UserDaoImpl implements UserDao {

    private static final String INSERT_USER =
            "INSERT INTO users (username, password, email, phone, address, role) "
          + "VALUES (?, ?, ?, ?, ?, ?)";

    private static final String SELECT_USER_BY_ID =
            "SELECT user_id, username, password, email, phone, address, role "
          + "FROM users WHERE user_id = ?";

    private static final String SELECT_USER_BY_USERNAME_OR_EMAIL =
            "SELECT user_id, username, password, email, phone, address, role "
          + "FROM users WHERE username = ? OR email = ?";

    private static final String UPDATE_USER =
            "UPDATE users SET username = ?, password = ?, email = ?, "
          + "phone = ?, address = ?, role = ? WHERE user_id = ?";

    private static final String UPDATE_PASSWORD =
            "UPDATE users SET password = ? WHERE user_id = ?";

    private static final String DELETE_USER =
            "DELETE FROM users WHERE user_id = ?";

    private static final String SELECT_ALL_USERS =
            "SELECT user_id, username, password, email, phone, address, role "
          + "FROM users";

    @Override
    public void addUser(User user) {

        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            return;
        }

        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(INSERT_USER)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public User getUser(int userId) {

        User user = null;
        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            return null;
        }

        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(SELECT_USER_BY_ID)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public User getUserByUsernameOrEmail(String loginInput) {

        User user = null;
        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            return null;
        }

        try (Connection con = connection;
             PreparedStatement ps =
                     con.prepareStatement(SELECT_USER_BY_USERNAME_OR_EMAIL)) {

            ps.setString(1, loginInput);
            ps.setString(2, loginInput);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = mapResultSetToUser(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }

    @Override
    public void updateUser(User user) {

        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            return;
        }

        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(UPDATE_USER)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            ps.setInt(7, user.getUserId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update only the user's password
    @Override
    public boolean updatePassword(int userId, String hashedPassword) {

        if (hashedPassword == null || hashedPassword.trim().isEmpty()) {
            return false;
        }

        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            return false;
        }

        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(UPDATE_PASSWORD)) {

            ps.setString(1, hashedPassword);
            ps.setInt(2, userId);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public void deleteUser(int userId) {

        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            return;
        }

        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(DELETE_USER)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<User> getAllUsers() {

        List<User> users = new ArrayList<>();
        Connection connection = DBConnection.getConnection();

        if (connection == null) {
            return users;
        }

        try (Connection con = connection;
             PreparedStatement ps = con.prepareStatement(SELECT_ALL_USERS);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {

        User user = new User();

        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));

        return user;
    }
}
