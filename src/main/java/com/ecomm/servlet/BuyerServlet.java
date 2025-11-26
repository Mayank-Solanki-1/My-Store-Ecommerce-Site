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
import java.util.*;

@WebServlet("/buyer/dashboard")
public class BuyerServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = user.getId();

        // --- Orders ---
        List<Order> orders = orderDAO.findByBuyer(userId);
        int orderCount = orders.size();

        // --- Wishlist ---
        Set<Integer> wishlist = (Set<Integer>) session.getAttribute("wishlist");
        if (wishlist == null) wishlist = new HashSet<>();
        int wishlistCount = wishlist.size();

        // --- Recently Viewed Products ---
        List<Integer> history = (List<Integer>) session.getAttribute("history");
        if (history == null) history = new ArrayList<>();
        List<Product> recentProducts = new ArrayList<>();
        // Show only last 5
        int start = Math.max(0, history.size() - 5);
        for (int i = history.size() - 1; i >= start; i--) {
            Product p = productDAO.findById(history.get(i));
            if (p != null) recentProducts.add(p);
        }
        int historyCount = recentProducts.size();

        // --- Set attributes for JSP ---
        request.setAttribute("user", user);
        request.setAttribute("orders", orders);
        request.setAttribute("orderCount", orderCount);
        request.setAttribute("wishlistCount", wishlistCount);
        request.setAttribute("recentProducts", recentProducts);
        request.setAttribute("historyCount", historyCount);

        request.getRequestDispatcher("/WEB-INF/jsp/buyer/dashboard.jsp")
                .forward(request, response);
    }
}
