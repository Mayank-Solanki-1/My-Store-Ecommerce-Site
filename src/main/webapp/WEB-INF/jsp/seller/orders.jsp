<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Sales History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-4">
    <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-link mb-3">← Back</a>

    <h2 class="mt-2 mb-3">Sales History</h2>

    <table class="table table-striped table-bordered align-middle">
        <thead class="table-dark">
            <tr>
                <th>Order #</th>
                <th>Product</th>
                <th>Quantity Sold</th>
                <th>Unit Price (₹)</th>
                <th>Total (₹)</th>
                <th>Order Status</th>
                <th>Date</th>
            </tr>
        </thead>

        <tbody>
        <c:forEach var="i" items="${items}">
            <tr>
                <td>${i.orderId}</td>
                <td>${i.productName}</td>
                <td>${i.quantity}</td>
                <td>₹ ${i.unitPrice}</td>
                <td>₹ ${i.quantity * i.unitPrice}</td>
                <td>
                    <c:choose>
                        <c:when test="${i.status != null}">${i.status}</c:when>
                        <c:otherwise>Pending</c:otherwise>
                    </c:choose>
                </td>
                <td>${i.date}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
