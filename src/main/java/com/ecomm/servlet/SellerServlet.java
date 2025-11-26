package com.ecomm.servlet;

import com.ecomm.dao.OrderDAO;
import com.ecomm.dao.ProductDAO;
import com.ecomm.model.Order;
import com.ecomm.model.Product;
import com.ecomm.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SellerServlet", urlPatterns = {"/seller/dashboard", "/seller/products", "/seller/orders"})
public class SellerServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession s = req.getSession(false);
        User user = (s != null) ? (User) s.getAttribute("user") : null;
        if (user == null || !"seller".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String path = req.getServletPath();

        if (path.equals("/seller/products")) {
            List<Product> products = productDAO.findBySeller(user.getId());
            req.setAttribute("products", products);
            req.getRequestDispatcher("/WEB-INF/jsp/seller/products.jsp").forward(req, resp);

        }  else if (path.equals("/seller/orders")) {
        // Fetch all orders with items for this seller
        List<Map<String, Object>> items = orderDAO.findOrdersWithItemsBySeller(user.getId());

        // Optional: debug
        System.out.println("Seller ID: " + user.getId() + ", items count: " + items.size());

        req.setAttribute("items", items);
        req.getRequestDispatcher("/WEB-INF/jsp/seller/orders.jsp").forward(req, resp);
    }
else { // dashboard
            List<Product> products = productDAO.findBySeller(user.getId());
            req.setAttribute("productCount", products.size());
            req.setAttribute("lowStockCount", products.stream().filter(p -> p.getStock() < 5).count());
            req.getRequestDispatcher("/WEB-INF/jsp/seller/dashboard.jsp").forward(req, resp);
        }
    }
}
