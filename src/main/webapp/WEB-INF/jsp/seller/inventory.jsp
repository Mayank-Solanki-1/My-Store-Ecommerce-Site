<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Inventory Overview</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .low-stock { background-color: #f8d7da; } /* red background for low stock */
    </style>
</head>
<body>
<div class="container mt-4">
    <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-link mb-3">← Back</a>
    <h2 class="mt-2">Inventory Overview</h2>

    <!-- Inventory Table -->
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Product Name</th>
            <th>Stock</th>
            <th>Status</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${products}">
            <tr class="${p.stock <= 5 ? 'low-stock' : ''}">
                <td>${p.name}</td>
                <td>${p.stock}</td>
                <td>
                    <c:choose>
                        <c:when test="${p.stock <= 5}">Low Stock</c:when>
                        <c:otherwise>OK</c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- Inventory Chart -->
    <h4 class="mt-4">Stock Levels</h4>
    <canvas id="inventoryChart" height="100"></canvas>
</div>

<script>
    // Prepare chart data
    const productNames = [
        <c:forEach var="p" items="${products}" varStatus="loop">
            '${p.name}'<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const productStocks = [
        <c:forEach var="p" items="${products}" varStatus="loop">
            ${p.stock}<c:if test="${!loop.last}">,</c:if>
        </c:forEach>
    ];

    const ctx = document.getElementById('inventoryChart').getContext('2d');
    const inventoryChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: productNames,
            datasets: [{
                label: 'Stock',
                data: productStocks,
                backgroundColor: productStocks.map(stock => stock <= 5 ? 'rgba(255, 99, 132, 0.7)' : 'rgba(54, 162, 235, 0.7)'),
                borderColor: productStocks.map(stock => stock <= 5 ? 'rgba(255, 99, 132, 1)' : 'rgba(54, 162, 235, 1)'),
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: { beginAtZero: true }
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return 'Stock: ' + context.raw;
                        }
                    }
                }
            }
        }
    });
</script>
</body>
</html>
