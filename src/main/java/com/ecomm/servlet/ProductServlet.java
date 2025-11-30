package com.ecomm.servlet;

import com.ecomm.dao.ProductDAO;
import com.ecomm.model.Product;
import com.ecomm.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {"/product/list", "/product/action"})
public class ProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        List<Product> products;
        if (user != null && "seller".equals(user.getRole())) {
            products = productDAO.findBySeller(user.getId());
        } else {
            products = productDAO.getAll();
        }

        req.setAttribute("products", products);
        req.getRequestDispatcher("/WEB-INF/jsp/product/list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Login required");
            return;
        }

        String action = req.getParameter("action");
        if (!"admin".equals(user.getRole()) && !"seller".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        try {
            if ("add".equals(action)) {

                Product p = new Product();
                p.setSellerId(user.getId());   // Assign to current logged-in seller

                p.setName(req.getParameter("name"));
                p.setDescription(req.getParameter("description"));
                p.setPrice(Double.parseDouble(req.getParameter("price")));
                p.setStock(Integer.parseInt(req.getParameter("stock")));

                productDAO.save(p);


            }

                 else if ("update".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                if (canModify(user, id)) {
                    Product p = productDAO.findById(id);
                    if (p != null) {
                        p.setName(req.getParameter("name"));
                        p.setDescription(req.getParameter("description"));
                        p.setPrice(Double.parseDouble(req.getParameter("price")));
                        p.setStock(Integer.parseInt(req.getParameter("stock")));
                        productDAO.update(p);
                        resp.setStatus(HttpServletResponse.SC_OK);
                    } else {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                    }
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Cannot update product");
                }

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                if (canModify(user, id)) {
                    productDAO.softDelete(id);
                    resp.setStatus(HttpServletResponse.SC_OK);
                } else {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Cannot delete product");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
        if ("seller".equals(user.getRole())) { resp.sendRedirect(req.getContextPath() + "/seller/products");
        } else {
            resp.sendRedirect(req.getContextPath() + "/product/list"); }
    }




    private boolean canModify(User user, int productId) {
        // allow admin and all products for the seller (for testing)
        return "admin".equals(user.getRole()) || "seller".equals(user.getRole());
    }

    /*private boolean canModify(User user, int productId) {
        if ("admin".equals(user.getRole())) return true;
        Product p = productDAO.findById(productId);
        return p != null && p.getSellerId() == user.getId();
    }*/
}
