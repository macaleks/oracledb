package com;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class OraConnection {

    private final String INSERT_STATEMENT = "INSERT INTO TESTER1.TAB1 VALUES(?, ?, ?, ?, ?, ?, ?)";

    private Connection CONNECTION = null;
    private PreparedStatement preparedStatement = null;

    public OraConnection() {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            CONNECTION = DriverManager.getConnection("jdbc:oracle:thin:@192.168.0.25:1521/orcl", "system", "oracle");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public Connection getConnection() {
        return CONNECTION;
    }

    public void prepareStatement() throws SQLException {
        preparedStatement = CONNECTION.prepareStatement(INSERT_STATEMENT);
        preparedStatement.setInt(1, (int) Math.random());
        preparedStatement.setInt(2, (int) Math.random());
        preparedStatement.setInt(3, (int) Math.random());
        preparedStatement.setInt(4, (int) Math.random());
        preparedStatement.setInt(5, (int) Math.random());
        preparedStatement.setInt(6, (int) Math.random());
        preparedStatement.setInt(7, (int) Math.random());
//        return CONNECTION.createStatement();
//        return preparedStatement;
    }

    public void executeStatement() throws SQLException {
        preparedStatement.executeUpdate();
//        CONNECTION.commit();
    }

    public void closeConnection() throws SQLException {
        CONNECTION.close();
    }
}
