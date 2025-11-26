package com.ecomm.servlet;

import com.ecomm.dao.UserDAO;
import com.ecomm.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "ProfileServlet", urlPatterns = {"/buyer/profile"})
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/jsp/buyer/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User u = (User) session.getAttribute("user");

        // Read updated fields
        u.setName(req.getParameter("name"));
        u.setEmail(req.getParameter("email"));
        u.setPhone(req.getParameter("phone"));
        u.setAddress(req.getParameter("address"));
        u.setCity(req.getParameter("city"));
        u.setState(req.getParameter("state"));
        u.setPincode(req.getParameter("pincode"));
        // Role remains same (buyer)

        boolean ok = userDAO.update(u);

        if (ok) {
            session.setAttribute("user", u);  // Update session
            req.setAttribute("msg", "Profile updated successfully!");
        } else {
            req.setAttribute("error", "Failed to update your profile.");
        }

        req.getRequestDispatcher("/WEB-INF/jsp/buyer/profile.jsp").forward(req, resp);
    }
}
