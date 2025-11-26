<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice #${order.id} • MyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { font-family: 'Poppins', sans-serif; background: #f5f6fa; padding: 30px; }
        .invoice-box { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 8px 25px rgba(0,0,0,0.1); max-width: 900px; margin: auto; }
        .invoice-header { border-bottom: 2px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .invoice-header h1 { font-weight: 700; color: #333; }
        .invoice-footer { border-top: 2px solid #eee; padding-top: 20px; margin-top: 20px; text-align: center; color: #777; font-size: 14px; }
        table th { background: #f0f2ff; padding: 12px; }
        table td { padding: 12px; vertical-align: middle; }
        .total { font-weight: bold; font-size: 16px; }
    </style>
</head>
<body>
<div class="invoice-box">
    <!-- Header -->
    <div class="invoice-header text-center">
        <h1>MyStore Invoice</h1>
        <p>Order #${order.id}</p>
        <p>Status: <strong>${order.status}</strong> | Placed on: ${order.createdAt}</p>
    </div>

    <!-- Buyer Info -->
    <div class="mb-4">
        <h5>Buyer Information:</h5>
        <p>
            Name: ${sessionScope.user.name} <br/>
            Email: ${sessionScope.user.email} <br/>
            Phone: ${sessionScope.user.phone} <br/>
            Address: ${sessionScope.user.address}, ${sessionScope.user.city}, ${sessionScope.user.state} - ${sessionScope.user.pincode}
        </p>

    </div>

    <!-- Order Items Table -->
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Product</th>
            <th>Quantity</th>
            <th>Unit Price</th>
            <th>Total</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${items}">
            <tr>
                <td>${item.productName}</td>
                <td>${item.quantity}</td>
                <td>₹${item.unitPrice}</td>
                <td>₹${item.quantity * item.unitPrice}</td>
            </tr>
        </c:forEach>
        <tr>
            <td colspan="3" class="text-end total">Grand Total</td>
            <td class="total">₹${order.totalAmount}</td>
        </tr>
        </tbody>
    </table>

    <!-- Footer -->
    <div class="invoice-footer">
        Thank you for shopping with MyStore!<br/>
        MyStore Inc. | www.mystore.com | support@mystore.com
    </div>
</div>
</body>
</html>
