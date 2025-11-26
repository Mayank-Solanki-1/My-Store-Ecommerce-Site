package com.ecomm.dao;

import com.ecomm.model.User;
import com.ecomm.util.PasswordUtil;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class UserDAO {
    private final DataSource ds = DBPool.getDataSource();

    // Find user by email
    public Optional<User> findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection c = ds.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Optional.of(mapRow(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return Optional.empty();
    }

    // Get all users
    public List<User> findAll() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY id DESC";
        try (Connection c = ds.getConnection(); ResultSet rs = c.createStatement().executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Save new user (includes phone/address/city/state/pincode)
    public boolean save(User u) {
        String sql = "INSERT INTO users(name,email,password,role,phone,address,city,state,pincode) VALUES(?,?,?,?,?,?,?,?,?)";
        try (Connection c = ds.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPassword());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getPhone());
            ps.setString(6, u.getAddress());
            ps.setString(7, u.getCity());
            ps.setString(8, u.getState());
            ps.setString(9, u.getPincode());

            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) u.setId(keys.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Update user (includes new fields)
    public boolean update(User u) {
        String sql = "UPDATE users SET name=?, email=?, role=?, phone=?, address=?, city=?, state=?, pincode=? WHERE id=?";
        try (Connection c = ds.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, u.getName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getRole());
            ps.setString(4, u.getPhone());
            ps.setString(5, u.getAddress());
            ps.setString(6, u.getCity());
            ps.setString(7, u.getState());
            ps.setString(8, u.getPincode());
            ps.setInt(9, u.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Delete user
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection c = ds.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Authenticate user
    public Optional<User> authenticate(String email, String plainPassword) {
        Optional<User> opt = findByEmail(email);
        if (opt.isPresent()) {
            User u = opt.get();
            if (PasswordUtil.matches(plainPassword, u.getPassword())) return Optional.of(u);
        }
        return Optional.empty();
    }

    // Map ResultSet row to User object
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setName(rs.getString("name"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setPhone(rs.getString("phone"));
        u.setAddress(rs.getString("address"));
        u.setCity(rs.getString("city"));
        u.setState(rs.getString("state"));
        u.setPincode(rs.getString("pincode"));
        return u;
    }
    public int countUsers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

}
