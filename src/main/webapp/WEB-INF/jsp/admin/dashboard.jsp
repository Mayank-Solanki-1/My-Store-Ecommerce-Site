<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Admin Dashboard</title>

    <!-- Bootstrap + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f4f6f9;
        }

        .sidebar {
            width: 260px;
            background: #111827;
            height: 100vh;
            position: fixed;
            padding-top: 20px;
            color: white;
        }

        .sidebar a {
            color: #d1d5db;
            text-decoration: none;
            padding: 12px 20px;
            display: block;
            font-size: 15px;
            border-radius: 6px;
            margin: 5px 10px;
            transition: 0.3s;
        }

        .sidebar a:hover {
            background: #374151;
            color: white;
        }

        .sidebar .active {
            background: #2563eb;
            color: white;
        }

        .content {
            margin-left: 260px;
            padding: 20px;
        }

        .card-stats {
            border-radius: 15px;
            padding: 25px;
            background: white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }

        .card-stats h3 {
            font-size: 26px;
            margin-bottom: 5px;
        }

        .table-container {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <h4 class="text-center fw-bold mb-4">Admin Panel</h4>

    <a href="adminDashboard.jsp" class="active"><i class="bi bi-speedometer2"></i> Dashboard</a>
    <a href="${pageContext.request.contextPath}/admin/products"><i class="bi bi-box-seam"></i> Manage Products</a>
    <a href="${pageContext.request.contextPath}/admin/orders"><i class="bi bi-cart-check"></i> Manage Orders</a>
    <a href="${pageContext.request.contextPath}/admin/users"><i class="bi bi-people"></i> Manage Users</a>

    <a href="${pageContext.request.contextPath}/logout" class="mt-3"><i class="bi bi-power"></i> Logout</a>
</div>

<!-- MAIN CONTENT -->
<div class="content">

    <h2 class="fw-bold mb-4">Welcome, Admin 👋</h2>

    <!-- STAT CARDS -->
    <div class="row g-4 mb-4">

        <div class="col-md-4">
            <div class="card-stats">
                <h3>${totalProducts}</h3>
                <p class="text-muted">Total Products</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card-stats">
                <h3>${totalOrders}</h3>
                <p class="text-muted">Total Orders</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card-stats">
                <h3>${totalUsers}</h3>
                <p class="text-muted">Registered Users</p>
            </div>
        </div>



</div>

</body>
</html>
