<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Sales Performance</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="container mt-4">
    <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-link">← Back</a>
    <h2 class="mt-2">Sales Performance</h2>

    <!-- SUMMARY CARDS -->
    <div class="row mt-3 mb-4">
        <div class="col-md-4">
            <div class="card text-center bg-light p-3">
                <h5>Total Sales</h5>
                <h3>₹ ${totalSales}</h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center bg-light p-3">
                <h5>Total Orders</h5>
                <h3>${totalOrders}</h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card text-center bg-light p-3">
                <h5>Top Product</h5>
                <h3>${topProduct}</h3>
            </div>
        </div>
    </div>

    <!-- PRODUCT SALES TABLE -->
    <h4>Product-wise Sales</h4>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Product Name</th>
            <th>Quantity Sold</th>
            <th>Revenue (₹)</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${productSales}">
            <tr>
                <td>${p.productName}</td>
                <td>${p.quantity}</td>
                <td>${p.revenue}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- MONTHLY SALES CHART -->
    <h4 class="mt-5">Monthly Sales (Last 12 Months)</h4>
    <canvas id="monthlySalesChart" height="100"></canvas>

</div>

<script>
    const monthlySalesData = {
        labels: [
            <c:forEach var="m" items="${monthlySales}" varStatus="status">
                '${m.month}'<c:if test="${!status.last}">, </c:if>
            </c:forEach>
        ],
        datasets: [{
            label: 'Sales Amount (₹)',
            data: [
                <c:forEach var="m" items="${monthlySales}" varStatus="status">
                    ${m.amount}<c:if test="${!status.last}">, </c:if>
                </c:forEach>
            ],
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
        }]
    };

    const config = {
        type: 'bar',
        data: monthlySalesData,
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                title: { display: true, text: 'Monthly Sales' }
            },
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    };

    const monthlySalesChart = new Chart(
        document.getElementById('monthlySalesChart'),
        config
    );
</script>

</body>
</html>
