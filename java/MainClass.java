package com;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;

public class MainClass {

    public static void main(String[] args) {

        Integer numberOfThreads = 100000;
        System.out.println("Test");

        OraConnection OraConnection = new OraConnection();
        Connection connection = null;
        try {
            connection = OraConnection.getConnection();
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("select sysdate from dual");
            Date date = null;
            while (rs.next()) {
                date = rs.getDate(1);
                break;
            }
            System.out.println(date);
        } catch (Exception e) {
            e.printStackTrace();
        }


//        if (args.length > 0) {
//            System.out.println(args[0]);
//            numberOfThreads = Integer.valueOf(args[0]);
//        }

//        if (args.length > 1) {
//            System.out.println(args[1]);
//        }
//        List<String> list = new ArrayList<>();

//        todo: Get from args number of insert statements
//        todo: create for each insert a personal thread
//        for(int i = 0; i < numberOfThreads; i++) {
//            System.out.println("Run number " + i);


//            Runnable r = () -> {
//                System.out.println("Started ");
//                OraConnection conn = new OraConnection();
//                try {
//                    conn.prepareStatement();
//                    conn.executeStatement();
//                    conn.closeConnection();
//                } catch (SQLException e) {
//                    e.printStackTrace();
//                }
//
//            };
//
//            ExecutorService executor = Executors.newFixedThreadPool(20);
//            executor.execute(r);
//        }

    }
}
