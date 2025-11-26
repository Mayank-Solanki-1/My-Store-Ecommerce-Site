<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>My Wishlist</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <h2>My Wishlist</h2>
    <a href="${pageContext.request.contextPath}/buyer/dashboard" class="btn btn-secondary mb-3">Back to Dashboard</a>

    <c:choose>
        <c:when test="${empty wishlistProducts}">
            <p>Your wishlist is empty.</p>
        </c:when>
        <c:otherwise>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="product" items="${wishlistProducts}">
                        <tr>
                            <td>${product.name}</td>
                            <td>$${product.price}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${product.stock > 0}">In Stock</c:when>
                                    <c:otherwise>Out of Stock</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <!-- Remove from wishlist -->
                                <form action="${pageContext.request.contextPath}/buyer/wishlist" method="post" style="display:inline;">
                                    <input type="hidden" name="productId" value="${product.id}" />
                                    <input type="hidden" name="action" value="remove" />
                                    <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                </form>

                                <!-- Add to cart (optional) -->
                                <c:if test="${product.stock > 0}">
                                    <form action="${pageContext.request.contextPath}/cart/add" method="post" style="display:inline;">
                                        <input type="hidden" name="productId" value="${product.id}" />
                                        <input type="hidden" name="quantity" value="1" />
                                        <button type="submit" class="btn btn-primary btn-sm">Add to Cart</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
