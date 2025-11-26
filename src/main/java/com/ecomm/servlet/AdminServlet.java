package com.ecomm.servlet;

import com.ecomm.dao.UserDAO;
import com.ecomm.dao.ProductDAO;
import com.ecomm.dao.OrderDAO;
import com.ecomm.model.User;
import com.ecomm.model.Product;
import com.ecomm.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AdminServlet", urlPatterns = {
        "/admin/dashboard",
        "/admin/users",
        "/admin/users/action",
        "/admin/products",
        "/admin/products/action",
        "/admin/orders",
        "/admin/orders/action"
})
public class AdminServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final OrderDAO orderDAO = new OrderDAO();

    // ===============================================================
    // GET REQUESTS
    // ===============================================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("user") : null;

        if (admin == null || !"admin".equals(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String path = req.getServletPath();

        switch (path) {

            // DASHBOARD
            case "/admin/dashboard":
                loadDashboard(req, resp);
                break;

            // USERS
            case "/admin/users":
                req.setAttribute("users", userDAO.findAll());
                req.getRequestDispatcher("/WEB-INF/jsp/admin/users.jsp").forward(req, resp);
                break;

            // PRODUCTS
            case "/admin/products":
                req.setAttribute("products", productDAO.getAll());
                req.getRequestDispatcher("/WEB-INF/jsp/admin/products.jsp").forward(req, resp);
                break;

            // ORDERS
            case "/admin/orders":
                req.setAttribute("orders", orderDAO.findAll());
                req.getRequestDispatcher("/WEB-INF/jsp/admin/orders.jsp").forward(req, resp);
                break;
        }
    }

    // ===============================================================
    // POST REQUESTS
    // ===============================================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User admin = (session != null) ? (User) session.getAttribute("user") : null;

        if (admin == null || !"admin".equals(admin.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String path = req.getServletPath();
        String action = req.getParameter("action");

        switch (path) {

            case "/admin/users/action":
                handleUserAction(req, resp, action);
                break;

            case "/admin/products/action":
                handleProductAction(req, resp, action);
                break;

            case "/admin/orders/action":
                handleOrderAction(req, resp, action);
                break;
        }
    }

    // ===============================================================
    // DASHBOARD WITH REAL COUNTS
    // ===============================================================
    private void loadDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        int totalUsers = userDAO.countUsers();
        int totalProducts = productDAO.countProducts();
        int totalOrders = orderDAO.countOrders();
        //double totalRevenue = orderDAO.getTotalRevenue();

        req.setAttribute("totalUsers", totalUsers);
        req.setAttribute("totalProducts", totalProducts);
        req.setAttribute("totalOrders", totalOrders);
        //req.setAttribute("totalRevenue", totalRevenue);

        req.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(req, resp);
    }

    // ===============================================================
    // ACTION HANDLERS
    // ===============================================================
    private void handleUserAction(HttpServletRequest req, HttpServletResponse resp, String action) throws IOException {
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            userDAO.delete(id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }

    private void handleProductAction(HttpServletRequest req, HttpServletResponse resp, String action) throws IOException {
        if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            productDAO.delete(id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/products");
    }

    private void handleOrderAction(HttpServletRequest req, HttpServletResponse resp, String action) throws IOException {

        if ("updateStatus".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String status = req.getParameter("status");
            orderDAO.updateStatus(id, status);

        } else if ("updateProcess".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String process = req.getParameter("process");
            orderDAO.updateProcess(id, process);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/orders");
    }
}
