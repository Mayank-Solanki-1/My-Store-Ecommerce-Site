<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.ecomm.model.Product, com.ecomm.dao.ProductDAO" %>

<%
    HttpSession s = request.getSession();
    Map<Integer,Integer> cart = (Map<Integer,Integer>) s.getAttribute("cart");
    if (cart == null) cart = new HashMap<>();

    ProductDAO dao = new ProductDAO();
    double grandTotal = 0;

    // Pre-fill checkout info from session or user
    String checkoutName = (String) s.getAttribute("fullname");
    String checkoutPhone = (String) s.getAttribute("phone");
    String checkoutAddress = (String) s.getAttribute("address");
    String checkoutCity = (String) s.getAttribute("city");
    String checkoutState = (String) s.getAttribute("state");
    String checkoutPincode = (String) s.getAttribute("pincode");

    com.ecomm.model.User user = (com.ecomm.model.User) s.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout | MyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background:#f4f6f9; font-family: 'Segoe UI'; }
        .checkout-container { max-width:1100px; margin:30px auto; }
        .section-box { background:white; padding:25px; border-radius:12px; box-shadow:0 4px 12px rgba(0,0,0,0.08); margin-bottom:25px; }
        .section-title { font-size:22px; font-weight:600; color:#333; margin-bottom:15px; }
        .summary-item { display:flex; justify-content:space-between; font-size:16px; margin-bottom:10px; }
        .place-btn { width:100%; padding:15px; font-size:18px; font-weight:600; border:none; border-radius:10px; background:#0052D4; color:white; }
    </style>
</head>
<body>

<div class="checkout-container">
    <div class="section-box">
        <div class="section-title">Shipping Address</div>

        <form id="checkoutForm" action="<%=request.getContextPath()%>/order/Checkout" method="post">

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="fullname" class="form-control" required
                           value="<%= checkoutName != null ? checkoutName : (user != null ? user.getName() : "") %>">

                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label">Phone</label>
                    <input type="text" name="phone" class="form-control" required
                           value="<%= checkoutPhone != null ? checkoutPhone : (user != null ? user.getPhone() : "") %>">
                </div>

                <div class="col-md-12 mb-3">
                    <label class="form-label">Address</label>
                    <textarea name="address" class="form-control" rows="3" required><%= checkoutAddress != null ? checkoutAddress : (user != null ? user.getAddress() : "") %></textarea>
                </div>

                <div class="col-md-4 mb-3">
                    <label class="form-label">City</label>
                    <input type="text" name="city" class="form-control" required
                           value="<%= checkoutCity != null ? checkoutCity : (user != null ? user.getCity() : "") %>">
                </div>

                <div class="col-md-4 mb-3">
                    <label class="form-label">State</label>
                    <input type="text" name="state" class="form-control" required
                           value="<%= checkoutState != null ? checkoutState : (user != null ? user.getState() : "") %>">
                </div>

                <div class="col-md-4 mb-3">
                    <label class="form-label">Pincode</label>
                    <input type="text" name="pincode" class="form-control" required
                           value="<%= checkoutPincode != null ? checkoutPincode : (user != null ? user.getPincode() : "") %>">
                </div>
            </div>
    </div>

    <div class="section-box mt-4">
        <div class="section-title">Order Summary</div>

        <% for (Map.Entry<Integer,Integer> e : cart.entrySet()) {
            Product p = dao.findById(e.getKey());
            int qty = e.getValue();
            double total = p.getPrice() * qty;
            grandTotal += total;
        %>

        <div class="summary-item">
            <span><%= p.getName() %> × <%= qty %></span>
            <span>₹<%= total %></span>
        </div>

        <% } %>

        <hr>

        <div class="summary-item" style="font-size:20px; font-weight:600;">
            <span>Total Payable</span>
            <span>₹<%= grandTotal %></span>
        </div>

        <input type="hidden" name="amount" value="<%=grandTotal%>">

        <button type="submit" class="place-btn mt-3">Continue to Payment</button>

        </form>
    </div>

</div>

</body>
</html>
