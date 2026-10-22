
package com.tap.dao;

import java.util.List;
import com.tap.model.User;

public interface UserDao {

    void addUser(User user);

    User getUser(int userId);

    User getUserByUsernameOrEmail(String loginInput);

    void updateUser(User user);

    // Update only the password of an existing user
    boolean updatePassword(int userId, String hashedPassword);

    void deleteUser(int userId);

    List<User> getAllUsers();
}
