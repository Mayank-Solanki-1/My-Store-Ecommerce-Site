package com.ecomm.servlet;

import com.ecomm.dao.OrderDAO;
import com.ecomm.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.*;

@WebServlet(name = "SalesServlet", urlPatterns = "/seller/salesPerformance")
public class SalesServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"seller".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        int sellerId = user.getId();

        // 1️⃣ Fetch all orders related to this seller
        List<OrderDAO.SellerOrderItem> sellerItems = orderDAO.findSellerOrderItems(sellerId);


        // 2️⃣ Compute total sales and orders
        double totalSales = 0;
        int totalOrders = sellerItems.size();

        Map<String, Integer> productQuantityMap = new HashMap<>();
        Map<String, Double> productRevenueMap = new HashMap<>();

        for (OrderDAO.SellerOrderItem item : sellerItems) {
            totalSales += item.unitPrice * item.quantity;

            // accumulate per product
            productQuantityMap.put(item.productName,
                    productQuantityMap.getOrDefault(item.productName, 0) + item.quantity);
            productRevenueMap.put(item.productName,
                    productRevenueMap.getOrDefault(item.productName, 0.0) + (item.unitPrice * item.quantity));
        }

        // 3️⃣ Determine top-selling product
        String topProduct = productRevenueMap.entrySet().stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse("N/A");

        // 4️⃣ Prepare product-wise sales list
        List<Map<String, Object>> productSales = new ArrayList<>();
        for (String product : productQuantityMap.keySet()) {
            Map<String, Object> map = new HashMap<>();
            map.put("productName", product);
            map.put("quantity", productQuantityMap.get(product));
            map.put("revenue", productRevenueMap.get(product));
            productSales.add(map);
        }

        // 5️⃣ Prepare monthly sales data (last 12 months)
        Map<String, Double> monthlySalesMap = new LinkedHashMap<>();
        LocalDate now = LocalDate.now();
        for (int i = 0; i < 12; i++) {
            LocalDate month = now.minusMonths(11 - i);
            String monthName = month.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
            monthlySalesMap.put(monthName, 0.0);
        }

        for (OrderDAO.SellerOrderItem item : sellerItems) {
            Timestamp ts = item.date;
            LocalDate orderMonth = ts.toLocalDateTime().toLocalDate().withDayOfMonth(1);
            String monthName = orderMonth.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
            if (monthlySalesMap.containsKey(monthName)) {
                monthlySalesMap.put(monthName, monthlySalesMap.get(monthName) + item.unitPrice * item.quantity);
            }
        }

        List<Map<String, Object>> monthlySales = new ArrayList<>();
        for (String m : monthlySalesMap.keySet()) {
            Map<String, Object> map = new HashMap<>();
            map.put("month", m);
            map.put("amount", monthlySalesMap.get(m));
            monthlySales.add(map);
        }

        // Set attributes for JSP
        req.setAttribute("totalSales", totalSales);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("topProduct", topProduct);
        req.setAttribute("productSales", productSales);
        req.setAttribute("monthlySales", monthlySales);

        req.getRequestDispatcher("/WEB-INF/jsp/seller/salesPerformance.jsp").forward(req, resp);
    }


}
