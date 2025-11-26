package com.ecomm.servlet;

import com.ecomm.dao.ProductDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = {"/cart", "/cart/add", "/cart/remove"})
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Show cart page
        req.getRequestDispatcher("/WEB-INF/jsp/cart.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();  // /cart/add OR /cart/remove
        HttpSession session = req.getSession();

        Map<Integer, Integer> cart =
                (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
        }

        if ("/cart/add".equals(path)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            String qtyParam = req.getParameter("quantity");
            int qty = (qtyParam == null || qtyParam.isEmpty()) ? 1 : Integer.parseInt(qtyParam);

            // ✅ Replace old quantity with new one instead of adding
            cart.put(productId, qty);

        } else if ("/cart/remove".equals(path)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            cart.remove(productId);
        }

        session.setAttribute("cart", cart);

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
