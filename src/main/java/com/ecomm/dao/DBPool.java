package com.ecomm.dao;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.io.InputStream;
import java.util.Properties;

public class DBPool {
    private static HikariDataSource ds;

    static {
        try {
            // Load properties
            Properties props = new Properties();
            try (InputStream in = DBPool.class.getClassLoader().getResourceAsStream("application.properties")) {
                if (in == null) {
                    throw new RuntimeException("application.properties not found in classpath");
                }
                props.load(in);
            }

            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Configure HikariCP
            HikariConfig cfg = new HikariConfig();
            cfg.setJdbcUrl(props.getProperty("db.url"));
            cfg.setUsername(props.getProperty("db.user"));
            cfg.setPassword(props.getProperty("db.pass"));
            cfg.setDriverClassName("com.mysql.cj.jdbc.Driver"); // explicitly set driver
            cfg.setMaximumPoolSize(10);
            cfg.setMinimumIdle(2);
            cfg.setPoolName("ecomm-pool");

            ds = new HikariDataSource(cfg);

        } catch (Exception e) {
            e.printStackTrace(); // Print exact cause
            throw new ExceptionInInitializerError(e);
        }
    }

    public static DataSource getDataSource() {
        return ds;
    }
}
