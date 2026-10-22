package com.tap.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/foodiehub";

    private static final String USERNAME = "root";

    private static final String PASSWORD = "root";

    public static Connection getConnection() {

        Connection connection = null;

        try {

            // Load MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish database connection
            connection = DriverManager.getConnection(
                    URL,
                    USERNAME,
                    PASSWORD
            );

            System.out.println("Database Connection Successful");

        } catch (ClassNotFoundException  |SQLException e) {

      
            e.printStackTrace();

        } 

        return connection;
    }
}