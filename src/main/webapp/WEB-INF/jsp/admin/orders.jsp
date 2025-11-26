<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Order Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">

<div class="container mt-4">

    <!-- PAGE TITLE -->
    <h2 class="mb-4">Order Management</h2>

    <!-- SUCCESS MESSAGE -->
    <c:if test="${not empty message}">
        <div class="alert alert-success">${message}</div>
    </c:if>

    <!-- ERROR MESSAGE -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <!-- ORDER TABLE -->
    <table class="table table-striped mt-3">
        <thead>
        <tr>
            <th>ID</th>
            <th>Buyer ID</th>
            <th>Total Amount</th>
            <th>Status</th>
            <th>process</th>
            <th>Update Process</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="o" items="${orders}">
            <tr>
                <td>${o.id}</td>
                <td>${o.buyerId}</td>
                <td>₹${o.totalAmount}</td>
                <td>${o.status}</td>
                <td>${o.process}</td>

                <td>
                    <!-- FORM TO UPDATE ORDER STATUS -->
                    <form action="${pageContext.request.contextPath}/admin/orders/action"
                          method="post"
                          class="d-flex align-items-center">

                        <input type="hidden" name="action" value="updateProcess"/>
                        <input type="hidden" name="id" value="${o.id}"/>

                        <!-- Status Dropdown -->
                        <select name="process" class="form-select form-select-sm w-auto me-2">
                            <option value="Pending"    ${o.process == 'Pending' ? 'selected' : ''}>Pending</option>
                            <option value="Processing" ${o.process == 'Processing' ? 'selected' : ''}>Processing</option>
                            <option value="Shipped"    ${o.process == 'Shipped' ? 'selected' : ''}>Shipped</option>
                            <option value="Delivered"  ${o.process == 'Delivered' ? 'selected' : ''}>Delivered</option>
                            <option value="Cancelled"  ${o.process == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                        </select>

                        <!-- UPDATE BUTTON -->
                        <button class="btn btn-sm btn-primary">Update</button>

                    </form>
                </td>

            </tr>
        </c:forEach>
        </tbody>
    </table>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
