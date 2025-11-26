<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Manage Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">
    <h2>Product Management</h2>
    <table class="table table-striped mt-3">
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Description</th>
            <th>Price</th>
            <th>Stock</th>
            <th>Seller ID</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr>
                <td>${p.id}</td>
                <td>${p.name}</td>
                <td>${p.description}</td>
                <td>${p.price}</td>
                <td>${p.stock}</td>
                <td>${p.sellerId}</td>
                <td>
                    <form action="${pageContext.request.contextPath}/admin/products/action" method="post">
                        <input type="hidden" name="id" value="${p.id}"/>
                        <input type="hidden" name="action" value="delete"/>
                        <button class="btn btn-sm btn-danger" onclick="return confirm('Delete product?')">Delete</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
