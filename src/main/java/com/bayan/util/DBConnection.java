package com.bayan.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static final String HOST_NAME = "ticket-system-bayan.mysql.database.azure.com";
    private static final String DB_NAME = "userscred";
    private static final String USERNAME = "bayanadmin";
    private static final String PASSWORD = "wdyzeqdn6R3iB7C"; // Don't forget to put your password back!

    // 1. Create a static variable to hold the ONE active connection
    private static Connection instance = null;

    public static Connection getConnection() {
        try {
            // 2. CHECK: Is there already a connection? Is it still alive?
            if (instance == null || instance.isClosed()) {

                // Only load the driver and connect if we absolutely have to
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                } catch (ClassNotFoundException e) {
                    e.printStackTrace();
                    return null;
                }

                String url = String.format("jdbc:mysql://%s:3306/%s?useSSL=true&verifyServerCertificate=false&requireSSL=false",
                        HOST_NAME, DB_NAME);

                Properties props = new Properties();
                props.put("user", USERNAME);
                props.put("password", PASSWORD);

                instance = DriverManager.getConnection(url, props);
                System.out.println(">>> NEW CONNECTION CREATED (This takes time) <<<");
            } else {
                // 3. If it exists, just return the old one (Instant!)
                System.out.println(">>> REUSING OLD CONNECTION (Instant!) <<<");
            }

        } catch (SQLException e) {
            System.err.println("CONNECTION FAILED: " + e.getMessage());
        }
        return instance;
    }
}