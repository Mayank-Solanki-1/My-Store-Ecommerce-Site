package com.ecomm.servlet;

import com.ecomm.dao.ProductDAO;
import com.ecomm.model.Product;
import com.ecomm.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/order/Checkout"})
public class CheckoutServlet extends HttpServlet {

    private final ProductDAO productDao = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Show the checkout page
        req.getRequestDispatcher("/WEB-INF/jsp/order/Checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(); // Always get/create session

        // Ensure user is logged in
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Ensure cart exists
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Read shipping info from form (match Checkout.jsp input names)
        String fullname = req.getParameter("fullname");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String city = req.getParameter("city");
        String state = req.getParameter("state");
        String pincode = req.getParameter("pincode");

        // Validate required fields
        if (fullname == null || phone == null || address == null || city == null
                || state == null || pincode == null
                || fullname.isEmpty() || phone.isEmpty() || address.isEmpty()
                || city.isEmpty() || state.isEmpty() || pincode.isEmpty()) {

            req.setAttribute("error", "Please fill all required address fields.");
            req.getRequestDispatcher("/WEB-INF/jsp/order/Checkout.jsp").forward(req, resp);
            return;
        }

        // Compute grand total
        double grandTotal = 0;
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            Product p = productDao.findById(entry.getKey());
            if (p != null) {
                grandTotal += p.getPrice() * entry.getValue();
            }
        }

        // Save shipping info & total in session for PaymentServlet
        session.setAttribute("checkout.fullname", fullname);
        session.setAttribute("checkout.phone", phone);
        session.setAttribute("checkout.address", address);
        session.setAttribute("checkout.city", city);
        session.setAttribute("checkout.state", state);
        session.setAttribute("checkout.pincode", pincode);
        session.setAttribute("checkout.amount", grandTotal);

        // Redirect to payment page
        resp.sendRedirect(req.getContextPath() + "/order/payment");
    }
}
