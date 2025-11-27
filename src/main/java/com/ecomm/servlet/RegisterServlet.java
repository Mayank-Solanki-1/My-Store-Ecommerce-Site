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
    private static final String ADMIN_SECRET_KEY = "SuperSecret123"; // Change to your real secret

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirm");
        String role = req.getParameter("role");
        String adminKey = req.getParameter("adminKey");

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

        // Admin secret key validation
        if ("admin".equals(role)) {
            if (adminKey == null || !ADMIN_SECRET_KEY.equals(adminKey)) {
                req.setAttribute("error", "Invalid Admin Secret Key");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
        }

        // Create User object
        User u = new User();
        u.setName(name);
        u.setEmail(email);
        u.setPassword(PasswordUtil.hash(password));
        u.setRole(role);

        // Set buyer info only if role is buyer
        if ("buyer".equals(role)) {
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
            switch (u.getRole()) {
                case "seller":
                    resp.sendRedirect(req.getContextPath() + "/seller/dashboard");
                    break;
                case "buyer":
                    resp.sendRedirect(req.getContextPath() + "/buyer/dashboard");
                    break;
                case "admin":
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/index.jsp");
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
