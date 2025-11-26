<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ecomm.model.Order" %>
<%
    Order order = (Order) request.getAttribute("order");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Successful</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background:#f4f6f9; }
        .container { max-width:600px; margin:60px auto; }
        .card { padding:30px; border-radius:12px; background:white; box-shadow:0 4px 20px rgba(0,0,0,0.1); text-align:center; }
        .btn-home { margin-top:20px; }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <h2 class="text-success">🎉 Payment Successful!</h2>
        <p>Thank you for your order.</p>

        <% if (order != null) { %>
            <h5>Order ID: <%= order.getId() %></h5>
            <p>Total Amount: ₹<%= order.getTotalAmount() %></p>
            <p>Status: <%= order.getStatus() %></p>
        <% } %>

        <a href="<%= request.getContextPath() %>/order/history" class="btn btn-primary btn-home">View Order History</a>
        <a href="<%= request.getContextPath() %>/" class="btn btn-secondary btn-home">Back to Home</a>
    </div>
</div>

</body>
</html>
