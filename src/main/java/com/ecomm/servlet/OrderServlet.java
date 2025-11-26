package com.ecomm.servlet;

import com.ecomm.dao.OrderDAO;
import com.ecomm.dao.ProductDAO;
import com.ecomm.model.Order;
import com.ecomm.model.User;
import com.ecomm.dao.OrderDAO.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderServlet", urlPatterns = {"/order/place", "/order/history", "/order/invoice"})
public class OrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Map<Integer,Integer> cart = (Map<Integer,Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // --- Build order items ---
        List<OrderItem> items = new ArrayList<>();
        double total = 0;
        for (Map.Entry<Integer,Integer> e : cart.entrySet()) {
            int pid = e.getKey();
            int qty = e.getValue();
            var p = productDAO.findById(pid);
            if (p != null) {
                items.add(new OrderItem(pid, qty, p.getPrice()));
                total += p.getPrice() * qty;
            }
        }

        // --- Get checkout info from session ---
        String phone   = (String) session.getAttribute("phone");
        String address = (String) session.getAttribute("address");
        String city    = (String) session.getAttribute("city");
        String state   = (String) session.getAttribute("state");
        String pincode = (String) session.getAttribute("pincode");

        try {
            // Save order with items and checkout info
            orderDAO.createOrderWithItemsAndShipping(user.getId(), total, items, phone, address, city, state, pincode);

            // Clear cart & checkout info from session
            session.removeAttribute("cart");
            session.removeAttribute("name");
            session.removeAttribute("phone");
            session.removeAttribute("address");
            session.removeAttribute("city");
            session.removeAttribute("state");
            session.removeAttribute("pincode");
            session.removeAttribute("amount");

            resp.sendRedirect(req.getContextPath() + "/order/history");
        } catch (Exception ex) {
            req.setAttribute("error", "Order failed: " + ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/cart.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String path = req.getServletPath();

        if ("/order/history".equals(path)) {
            List<Order> orders = orderDAO.findByBuyer(user.getId());

            // Load items for each order
            for (Order o : orders) {
                o.setItems(orderDAO.getOrderItems(o.getId()));
            }

            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/WEB-INF/jsp/order/history.jsp").forward(req, resp);

        } else if ("/order/invoice".equals(path)) {
            String idParam = req.getParameter("id");
            System.out.println("Invoice ID param: " + idParam);

            if (idParam == null) {
                resp.sendRedirect(req.getContextPath() + "/order/history");
                return;
            }

            int orderId = Integer.parseInt(idParam);
            Order order = orderDAO.getOrderById(orderId);
            if (order == null) {
                resp.sendRedirect(req.getContextPath() + "/order/history");
                return;
            }

            var items = orderDAO.getOrderItems(orderId);

            req.setAttribute("order", order);
            req.setAttribute("items", items);

            // Pass buyer info from order to JSP
            req.setAttribute("buyerPhone", order.getPhone());
            req.setAttribute("buyerAddress", order.getAddress());
            req.setAttribute("buyerCity", order.getCity());
            req.setAttribute("buyerState", order.getState());
            req.setAttribute("buyerPincode", order.getPincode());

            req.getRequestDispatcher("/WEB-INF/jsp/order/invoice.jsp").forward(req, resp);
        }
    }
}
