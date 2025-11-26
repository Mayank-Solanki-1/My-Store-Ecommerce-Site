package com.ecomm.servlet;

import com.ecomm.dao.ProductDAO;
import com.ecomm.model.Product;
import com.ecomm.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "InventoryServlet", urlPatterns = "/seller/inventory")
public class InventoryServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"seller".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Fetch all products for the seller
        List<Product> products = productDAO.findBySeller(user.getId());

        // Pass to JSP
        req.setAttribute("products", products);
        req.getRequestDispatcher("/WEB-INF/jsp/seller/inventory.jsp").forward(req, resp);
    }
}

