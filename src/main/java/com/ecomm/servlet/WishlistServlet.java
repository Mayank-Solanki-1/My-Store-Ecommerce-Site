package com.ecomm.servlet;

import com.ecomm.dao.ProductDAO;
import com.ecomm.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "WishlistServlet", urlPatterns = {"/buyer/wishlist"})
public class WishlistServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        // Properly type the wishlist as Set<Integer>
        @SuppressWarnings("unchecked")
        Set<Integer> wishlist = (Set<Integer>) session.getAttribute("wishlist");
        if (wishlist == null) wishlist = new HashSet<>();

        List<Product> wishlistProducts = new ArrayList<>();
        for (int pid : wishlist) {
            Product p = productDAO.findById(pid);
            if (p != null) wishlistProducts.add(p);
        }

        req.setAttribute("wishlistProducts", wishlistProducts);
        req.getRequestDispatcher("/WEB-INF/jsp/buyer/wishlist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        @SuppressWarnings("unchecked")
        Set<Integer> wishlist = (Set<Integer>) session.getAttribute("wishlist");
        if (wishlist == null) wishlist = new HashSet<>();

        int productId = Integer.parseInt(req.getParameter("productId"));
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            wishlist.add(productId);
        } else if ("remove".equals(action)) {
            wishlist.remove(productId);
        }

        session.setAttribute("wishlist", wishlist);
        resp.sendRedirect(req.getContextPath() + "/buyer/wishlist");
    }
}
