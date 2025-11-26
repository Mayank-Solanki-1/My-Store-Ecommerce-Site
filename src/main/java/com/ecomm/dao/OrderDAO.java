package com.ecomm.dao;

import com.ecomm.model.Order;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {
    private final DataSource ds = DBPool.getDataSource();

    // Helper class for Sellers to see items relevant to them
    public static class SellerOrderItem {
        public int orderId;
        public String productName;
        public int quantity;
        public double unitPrice;
        public String status;
        //public String process;
        public Timestamp date;
    }

    public static class OrderItem {
        public int productId;
        public int quantity;
        public double unitPrice;

        public OrderItem(int productId, int quantity, double unitPrice) {
            this.productId = productId;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
        }
    }
    public DataSource getDataSource() {
        return ds;
    }


    // -------------------------------
    // Create Order with Items
    // -------------------------------
    public int createOrderWithItemsAndShipping(int buyerId, double totalAmount,
                                               List<OrderItem> items,
                                               String phone, String address,
                                               String city, String state,
                                               String pincode) throws SQLException {

        String updateUser = "UPDATE users SET phone=?, address=?, city=?, state=?, pincode=? WHERE id=?";
        String insertOrder = "INSERT INTO orders(buyer_id, total_amount, status, created_at) VALUES(?,?, 'Pending', NOW())";
        String insertItem = "INSERT INTO order_items(order_id, product_id, quantity, unit_price) VALUES(?,?,?,?)";

        Connection c = null;

        try {
            c = ds.getConnection();
            c.setAutoCommit(false);

            // --------------------------
            // 1) UPDATE USER SHIPPING INFO
            // --------------------------
            try (PreparedStatement psUser = c.prepareStatement(updateUser)) {
                psUser.setString(1, phone);
                psUser.setString(2, address);
                psUser.setString(3, city);
                psUser.setString(4, state);
                psUser.setString(5, pincode);
                psUser.setInt(6, buyerId);
                psUser.executeUpdate();
            }

            // --------------------------
            // 2) INSERT INTO ORDERS
            // --------------------------
            int orderId;
            try (PreparedStatement ps = c.prepareStatement(insertOrder, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, buyerId);
                ps.setDouble(2, totalAmount);
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    keys.next();
                    orderId = keys.getInt(1);
                }
            }

            // --------------------------
            // 3) INSERT ORDER ITEMS + UPDATE STOCK
            // --------------------------
            try (PreparedStatement psItem = c.prepareStatement(insertItem)) {
                for (OrderItem it : items) {
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, it.productId);
                    psItem.setInt(3, it.quantity);
                    psItem.setDouble(4, it.unitPrice);
                    psItem.executeUpdate();

                    try (PreparedStatement psStock = c.prepareStatement(
                            "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?")) {

                        psStock.setInt(1, it.quantity);
                        psStock.setInt(2, it.productId);
                        psStock.setInt(3, it.quantity);

                        if (psStock.executeUpdate() == 0) {
                            throw new SQLException("Insufficient stock for product " + it.productId);
                        }
                    }
                }
            }

            c.commit();
            return orderId;

        } catch (SQLException ex) {
            if (c != null) c.rollback();
            throw ex;

        } finally {
            if (c != null) {
                try { c.setAutoCommit(true); c.close(); } catch (SQLException e) {}
            }
        }
    }

    // -------------------------------
    // Fetch Orders
    // -------------------------------
    public List<Order> findAll() {
        return queryOrders("SELECT * FROM orders ORDER BY created_at DESC");
    }

    public List<Order> findByBuyer(int buyerId) {
        String sql = "SELECT * FROM orders WHERE buyer_id = ? ORDER BY created_at DESC";
        List<Order> list = new ArrayList<>();
        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, buyerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("id"));
                    o.setBuyerId(rs.getInt("buyer_id"));
                    o.setTotalAmount(rs.getDouble("total_amount"));
                    o.setStatus(rs.getString("status"));
                    o.setProcess(rs.getString("process"));
                    o.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(o);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private List<Order> queryOrders(String sql) {
        List<Order> list = new ArrayList<>();
        try (Connection c = ds.getConnection();
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery(sql)) {
            while (rs.next()) {
                Order o = new Order();
                o.setId(rs.getInt("id"));
                o.setBuyerId(rs.getInt("buyer_id"));
                o.setTotalAmount(rs.getDouble("total_amount"));
                o.setStatus(rs.getString("status"));
                o.setProcess(rs.getString("process"));
                o.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(o);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // -------------------------------
    // Update Order Status
    // -------------------------------
    public boolean updateStatus(int orderId, String status) {
        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement("UPDATE orders SET status=? WHERE id=?")) {
            ps.setString(1, status);

            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateProcess(int id, String process) {
        String sql = "UPDATE orders SET process=? WHERE id=?";

        try (Connection con = ds.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, process);
            ps.setInt(2, id);

            int result = ps.executeUpdate();
            return result == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    // -------------------------------
    // Seller Order Items
    // -------------------------------
    public List<Order> findOrdersBySeller(int sellerId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT DISTINCT o.id, o.buyer_id, o.total_amount, o.status, o.created_at " +
                "FROM orders o " +
                "JOIN order_items oi ON o.id = oi.order_id " +
                "JOIN products p ON oi.product_id = p.id " +
                "WHERE p.seller_id = ? " +
                "ORDER BY o.created_at DESC";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setBuyerId(rs.getInt("buyer_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setProcess(rs.getString("process"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }


    // -------------------------------
    // Get Single Order
    // -------------------------------
    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = "SELECT o.id, o.buyer_id, o.total_amount, o.status, o.created_at, " +
                "u.name AS buyer_name, u.phone, u.address, u.city, u.state, u.pincode " +
                "FROM orders o " +
                "JOIN users u ON o.buyer_id = u.id " +
                "WHERE o.id = ?";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setBuyerId(rs.getInt("buyer_id"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));

                    // Get buyer info from users table
                    order.setPhone(rs.getString("phone"));
                    order.setAddress(rs.getString("address"));
                    order.setCity(rs.getString("city"));
                    order.setState(rs.getString("state"));
                    order.setPincode(rs.getString("pincode"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }


    // -------------------------------
    // Get Order Items
    // -------------------------------
    public List<Map<String,Object>> getOrderItems(int orderId) {
        List<Map<String,Object>> items = new ArrayList<>();
        String sql = "SELECT p.name, oi.quantity, oi.unit_price " +
                "FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.id " +
                "WHERE oi.order_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> item = new HashMap<>();
                    item.put("productName", rs.getString("name"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("unitPrice", rs.getDouble("unit_price"));
                    items.add(item);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return items;
    }

    public List<Map<String,Object>> getOrderItemsForSeller(int orderId, int sellerId) {
        List<Map<String,Object>> items = new ArrayList<>();
        String sql = "SELECT p.name, oi.quantity, oi.unit_price " +
                "FROM order_items oi " +
                "JOIN products p ON oi.product_id = p.id " +
                "WHERE oi.order_id = ? AND p.seller_id = ?";
        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> item = new HashMap<>();
                    item.put("productName", rs.getString("name"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("unitPrice", rs.getDouble("unit_price"));
                    items.add(item);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return items;
    }


    // -------------------------------
    // Get Orders with Items (for Buyer)
    // -------------------------------
    public List<Map<String,Object>> findOrdersWithPayment(int buyerId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT o.id, o.total_amount, o.status, o.created_at, " +
                "GROUP_CONCAT(p.name, ' × ', oi.quantity) AS items " +
                "FROM orders o " +
                "JOIN order_items oi ON o.id = oi.order_id " +
                "JOIN products p ON oi.product_id = p.id " +
                "WHERE o.buyer_id = ? " +
                "GROUP BY o.id ORDER BY o.created_at DESC";

        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, buyerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("total", rs.getDouble("total_amount"));
                    map.put("status", rs.getString("status"));
                    map.put("date", rs.getTimestamp("created_at"));
                    map.put("items", rs.getString("items"));
                    list.add(map);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    public int countOrders() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM orders";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            if (rs.next()) count = rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    public List<Map<String, Object>> findOrdersWithItemsBySeller(int sellerId) {
        List<Map<String, Object>> items = new ArrayList<>();
        String sql = "SELECT o.id AS order_id, o.buyer_id, o.status, o.created_at, " +
                "p.name AS product_name, oi.quantity, oi.unit_price " +
                "FROM orders o " +
                "JOIN order_items oi ON o.id = oi.order_id " +
                "JOIN products p ON oi.product_id = p.id " +
                "WHERE p.seller_id = ? " +
                "ORDER BY o.created_at DESC";

        try (Connection conn = ds.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sellerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("orderId", rs.getInt("order_id"));
                    map.put("buyerId", rs.getInt("buyer_id"));
                    map.put("status", rs.getString("status"));
                    map.put("date", rs.getTimestamp("created_at"));
                    map.put("productName", rs.getString("product_name"));
                    map.put("quantity", rs.getInt("quantity"));
                    map.put("unitPrice", rs.getDouble("unit_price"));
                    items.add(map);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return items;
    }
    public List<SellerOrderItem> findSellerOrderItems(int sellerId) {
        List<SellerOrderItem> list = new ArrayList<>();

        String sql = "SELECT o.id AS order_id, o.status, o.created_at, " +
                "p.name AS product_name, oi.quantity, oi.unit_price " +
                "FROM orders o " +
                "JOIN order_items oi ON o.id = oi.order_id " +
                "JOIN products p ON oi.product_id = p.id " +
                "WHERE p.seller_id = ? " +
                "ORDER BY o.created_at DESC";

        try (Connection c = ds.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, sellerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SellerOrderItem item = new SellerOrderItem();
                item.orderId = rs.getInt("order_id");
                item.productName = rs.getString("product_name");
                item.quantity = rs.getInt("quantity");
                item.unitPrice = rs.getDouble("unit_price");
                item.status = rs.getString("status");
                item.date = rs.getTimestamp("created_at");
                list.add(item);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }







}
