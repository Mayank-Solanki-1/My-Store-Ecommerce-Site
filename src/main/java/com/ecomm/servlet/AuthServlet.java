package com.ecomm.servlet;

import com.ecomm.dao.UserDAO;
import com.ecomm.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Optional;

@WebServlet(name = "AuthServlet", urlPatterns = {"/login"})
//@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class AuthServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        Optional<User> opt = userDAO.authenticate(email, password);
        if (opt.isPresent()) {
            User user = opt.get();
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            // Redirect based on role
            if ("admin".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if ("seller".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/seller/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/buyer/dashboard");
            }
        } else {
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}