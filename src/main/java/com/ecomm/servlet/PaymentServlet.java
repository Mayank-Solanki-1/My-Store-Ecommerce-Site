package com.ecomm.servlet;

import com.ecomm.dao.OrderDAO;
import com.ecomm.dao.ProductDAO;
import com.ecomm.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/order/payment"})
public class PaymentServlet extends HttpServlet {

    private final OrderDAO orderDao = new OrderDAO();
    private final ProductDAO productDao = new ProductDAO();

    // Show payment page
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("checkout.amount") == null) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/order/payment.jsp").forward(req, resp);
    }

    // Process payment form
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // get cart
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Get payment type
        String paymentType = req.getParameter("paymentType");

        // Get card fields ALWAYS (even if null)
        String cardNumber = req.getParameter("cardNumber");
        String expiry = req.getParameter("expiry");
        String cvv = req.getParameter("cvv");

        // Validate card only if selected
        if ("Card".equals(paymentType)) {

            if (cardNumber == null || cardNumber.trim().isEmpty() ||
                    expiry == null || expiry.trim().isEmpty() ||
                    cvv == null || cvv.trim().isEmpty() ||
                    cardNumber.trim().length() < 12 ||
                    cvv.trim().length() < 3) {

                req.setAttribute("error", "Invalid card details. Please try again.");
                req.getRequestDispatcher("/WEB-INF/jsp/order/payment.jsp").forward(req, resp);
                return;
            }
        }

        // Amount from session (safe)
        Double sessionAmount = (Double) session.getAttribute("checkout.amount");
        if (sessionAmount == null) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        double total = sessionAmount;

        // Prepare Order Items
        List<OrderDAO.OrderItem> orderItems = new ArrayList<>();

        for (Map.Entry<Integer, Integer> item : cart.entrySet()) {
            int pid = item.getKey();
            int qty = item.getValue();

            try {
                var product = productDao.findById(pid);
                if (product != null) {
                    orderItems.add(new OrderDAO.OrderItem(
                            product.getId(),
                            qty,
                            product.getPrice()
                    ));
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }

        try {
            // Create order
            int orderId = orderDao.createOrderWithItemsAndShipping(
                    user.getId(),
                    total,
                    orderItems,
                    (String) session.getAttribute("checkout.phone"),
                    (String) session.getAttribute("checkout.address"),
                    (String) session.getAttribute("checkout.city"),
                    (String) session.getAttribute("checkout.state"),
                    (String) session.getAttribute("checkout.pincode"));

            orderDao.updateStatus(orderId, "Paid");
// Save last order ID to session for success page
            session.setAttribute("lastOrderId", orderId);

// clear cart & checkout session attributes

// Redirect to success page
            resp.sendRedirect(req.getContextPath() + "/order/success");
            session.removeAttribute("cart");
            session.removeAttribute("checkout.amount");
            session.removeAttribute("checkout.fullname");
            session.removeAttribute("checkout.phone");
            session.removeAttribute("checkout.address");
            session.removeAttribute("checkout.city");
            session.removeAttribute("checkout.state");
            session.removeAttribute("checkout.pincode");


        } catch (SQLException ex) {
            ex.printStackTrace();
            req.setAttribute("error", "Payment failed: " + ex.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/order/payment.jsp").forward(req, resp);
        }
    }
}
