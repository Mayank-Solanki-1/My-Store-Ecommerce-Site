package com.ecomm.filter;

import com.ecomm.model.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter(urlPatterns = {"/admin/*", "/seller/*", "/buyer/*", "/product/*", "/cart", "/order/*"})
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_GET_PATHS = Arrays.asList("/product/list");

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (req.getMethod().equalsIgnoreCase("GET") && PUBLIC_GET_PATHS.contains(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Strict Role Checks
        if (path.startsWith("/admin") && !"admin".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admins only");
            return;
        }
        if (path.startsWith("/seller") && !"seller".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Sellers only");
            return;
        }

        chain.doFilter(request, response);
    }
}