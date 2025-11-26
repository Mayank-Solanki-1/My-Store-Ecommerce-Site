<%@ page import="java.util.*" %>

<%
    // Use implicit session object — DO NOT redeclare it
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Double amount = (Double) session.getAttribute("checkout.amount");
    if (amount == null) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }

    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Payment | MyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', sans-serif; background:#f4f6f9; }
        .box { max-width:560px; margin:40px auto; background:#fff; padding:24px; border-radius:12px; box-shadow:0 4px 20px rgba(0,0,0,0.08); }
        .btn-pay { background:#4CAF50; color:white; width:100%; padding:12px; border:none; border-radius:8px; font-size:18px; }
    </style>
</head>
<body>

<div class="box">
    <h4 class="mb-3">Complete Payment</h4>

    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <p><strong>Amount Payable:</strong> ₹<%= amount %></p>

    <form action="<%= request.getContextPath() %>/order/payment" method="post">

        <div class="mb-3">
            <label class="form-label">Payment Method</label><br>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="paymentType" id="payCOD" value="COD" checked>
                <label class="form-check-label" for="payCOD">Cash on Delivery (COD)</label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="paymentType" id="payCard" value="Card">
                <label class="form-check-label" for="payCard">Card</label>
            </div>

            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="paymentType" id="payUPI" value="UPI">
                <label class="form-check-label" for="payUPI">UPI</label>
            </div>
        </div>

        <!-- Card details -->
        <div id="cardDetails" style="display:none;">
            <div class="mb-2">
                <label>Card Number</label>
                <input type="text" name="cardNumber" class="form-control" placeholder="1234 5678 9012 3456">
            </div>

            <div class="row">
                <div class="col">
                    <label>Expiry (MM/YY)</label>
                    <input type="text" name="expiry" class="form-control" placeholder="MM/YY">
                </div>

                <div class="col">
                    <label>CVV</label>
                    <input type="password" name="cvv" class="form-control" placeholder="123">
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function(){
                const payCard = document.getElementById('payCard');
                const payCOD = document.getElementById('payCOD');
                const payUPI = document.getElementById('payUPI');
                const cardBox = document.getElementById('cardDetails');

                function toggleCard() {
                    if (payCard.checked) cardBox.style.display = 'block';
                    else cardBox.style.display = 'none';
                }

                payCard.addEventListener('change', toggleCard);
                payCOD.addEventListener('change', toggleCard);
                payUPI.addEventListener('change', toggleCard);

                // initialize UI
                toggleCard();
            });
        </script>

        <div class="mt-3">
            <button type="submit" class="btn-pay">Pay ₹<%= amount %></button>
        </div>

    </form>
</div>

</body>
</html>
