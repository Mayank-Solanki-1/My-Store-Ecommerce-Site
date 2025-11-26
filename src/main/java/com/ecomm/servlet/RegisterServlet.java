package com.ecomm.servlet;

import com.ecomm.dao.UserDAO;
import com.ecomm.model.User;
import com.ecomm.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");
        String role = req.getParameter("role"); // Should only be buyer or seller

        // New buyer info fields
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String pincode = req.getParameter("pincode");

        // Validate required fields
        if (name == null || email == null || password == null || confirm == null || role == null) {
            req.setAttribute("error", "All fields are required");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // Password match validation
        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // Prevent admin registration
        if ("admin".equalsIgnoreCase(role)) {
            req.setAttribute("error", "Admin registration is not allowed.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        // Default to buyer if role is invalid
        if (!"buyer".equalsIgnoreCase(role) && !"seller".equalsIgnoreCase(role)) {
            role = "buyer";
        }

        // Create User object
        User u = new User();
        u.setName(name);
        u.setEmail(email);
        u.setPassword(PasswordUtil.hash(password));
        u.setRole(role);

        // Set buyer info only if role is buyer
        if ("buyer".equalsIgnoreCase(role)) {
            u.setPhone(phone);
            u.setAddress(address);
            u.setCity(city);
            u.setState(state);
            u.setPincode(pincode);
        }

        boolean ok = userDAO.save(u);

        if (ok) {
            // Auto-login
            HttpSession session = req.getSession();
            session.setAttribute("user", u);

            // Redirect based on role
            if ("seller".equalsIgnoreCase(u.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/seller/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/buyer/dashboard");
            }
        } else {
            req.setAttribute("error", "Registration failed (Email might be taken)");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }
}
