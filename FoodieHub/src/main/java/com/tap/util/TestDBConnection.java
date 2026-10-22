package com.tap.util;

import java.sql.Connection;

public class TestDBConnection {

    public static void main(String[] args) {

        Connection connection = DBConnection.getConnection();

        if (connection != null) {

            System.out.println("================================");
            System.out.println("DATABASE CONNECTION SUCCESSFUL");
            System.out.println("================================");

        } else {

            System.out.println("================================");
            System.out.println("DATABASE CONNECTION FAILED");
            System.out.println("================================");
        }
    }
}