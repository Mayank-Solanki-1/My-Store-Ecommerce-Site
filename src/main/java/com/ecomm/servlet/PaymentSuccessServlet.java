package com.ecomm.servlet;

import com.ecomm.dao.OrderDAO;
import com.ecomm.model.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "PaymentSuccessServlet", urlPatterns = {"/order/success"})
public class PaymentSuccessServlet extends HttpServlet {

    private final OrderDAO orderDao = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("lastOrderId") == null) {
            // If no order ID, redirect to order history
            resp.sendRedirect(req.getContextPath() + "/order/history");
            return;
        }

        int orderId = (Integer) session.getAttribute("lastOrderId");
        session.removeAttribute("lastOrderId"); // clear after showing once

        Order order = orderDao.getOrderById(orderId);
        req.setAttribute("order", order);

        // Forward to JSP inside WEB-INF
        req.getRequestDispatcher("/WEB-INF/jsp/order/success.jsp").forward(req, resp);

    }
}
