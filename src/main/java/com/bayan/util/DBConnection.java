package com.bayan.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    // Read environment variables directly so the code does not require the dotenv library on the classpath
    private static final String HOST_NAME = System.getenv().getOrDefault("DB_URL", "localhost");
    private static final String DB_NAME = "userscred";
    private static final String USERNAME = System.getenv().getOrDefault("DB_USER", "root");
    private static final String PASSWORD = System.getenv().getOrDefault("DB_PASS", "");

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // 1. FORCE LOAD THE DRIVER (Add this line!)
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                System.err.println("MySQL JDBC Driver not found! Check your pom.xml.");
                LOGGER.log(Level.SEVERE, "ERROR",e);
                return null;
            }

            // 2. Define the URL
            String url = String.format("jdbc:mysql://%s:3306/%s?useSSL=true&verifyServerCertificate=false&requireSSL=false", 
                                         HOST_NAME, DB_NAME);

            // 3. Connect
            Properties props = new Properties();
            props.put("user", USERNAME);
            props.put("password", PASSWORD);

            connection = DriverManager.getConnection(url, props);
            System.out.println("SUCCESS: Connected to Azure MySQL!");

        } catch (SQLException e) {
            System.err.println("CONNECTION FAILED!");
            LOGGER.log(Level.SEVERE, "CONNECTION FAILED", e);
        }
        return connection;
    }

    public static void main(String[] args) {
        getConnection();
    }
}