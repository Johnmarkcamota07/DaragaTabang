package com.bayan.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

import com.bayan.util.DBConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/test-connection")
public class TestConnectionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><body style='text-align:center; font-family:sans-serif;'>");
        out.println("<h1>Connection Test Result</h1>");

        try (Connection conn = DBConnection.getConnection()) {
            try {

                if (conn != null) {
                    out.println("<h2 style='color:green;'>HELLO! Database Connected Successfully!</h2>");
                    out.println("<p>Connected to: <b>Azure MySQL Flexible Server</b></p>");
                } else {
                    out.println("<h2 style='color:red;'>Connection Failed</h2>");
                    out.println("<p>DBConnection returned null.</p>");
                }
            } catch (Exception e) {
                // Catch ANY error (including SQL errors) here
                out.println("<h2 style='color:red;'>CRITICAL ERROR</h2>");
                out.println("<pre>" + e.getMessage() + "</pre>");
                this.log("Exception in TestConnectionServlet.doGet", e);
            }
        } catch (SQLException e) {
            this.log("Failed to close DB connection", e);
        }

        out.println("<a href='index.jsp'>Go Back</a>");
        out.println("</body></html>");
    }
}