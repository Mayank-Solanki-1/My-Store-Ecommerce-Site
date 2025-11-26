<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Seller Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f5f7fa;
        }

        .dashboard-card {
            border-radius: 18px;
            padding: 25px;
            min-height: 180px;
            background: white;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);

        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 18px rgba(0,0,0,0.12);
        }

        .metric-number {
            font-size: 2.2rem;
            font-weight: bold;
        }

        .navbar-brand {
            font-size: 1.4rem;
            font-weight: 600;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-dark bg-primary p-3 shadow">
  <span class="navbar-brand">Seller Portal</span>
  <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm">Logout</a>
</nav>

<div class="container mt-4">

    <div class="alert alert-info shadow-sm">
        Welcome back, ${sessionScope.user.name}
    </div>

    <div class="row g-4">

        <!-- My Products -->
        <div class="col-md-4">
            <div class="dashboard-card text-center">
                <h5 class="mb-2">My Products</h5>
                <div class="metric-number">${productCount}</div>
                <a href="${pageContext.request.contextPath}/seller/products"
                   class="btn btn-primary btn-sm mt-3">Manage Inventory</a>
            </div>
        </div>

        <!-- Low Stock Alerts -->
        <div class="col-md-4">
            <div class="dashboard-card text-center">
                <h5 class="mb-2">Low Stock Alerts</h5>
                <div class="metric-number text-danger">${lowStockCount}</div>
                <small class="text-muted">Items with stock < 5</small>
            </div>
        </div>

        <!-- Orders -->
        <div class="col-md-4">
            <div class="dashboard-card text-center">
                <h5 class="mb-2">Orders</h5>
                <p class="text-muted">View items sold</p>
                <a href="${pageContext.request.contextPath}/seller/orders"
                   class="btn btn-primary btn-sm mt-2">View Orders</a>
            </div>
        </div>

        <!-- Inventory Overview -->
        <div class="col-md-4">
            <div class="dashboard-card text-center">
                <h5 class="mb-2">Inventory Overview</h5>
                <p class="text-muted">Statistics</p>

                <div class="metric-number">${inventoryCount}</div>
                <a href="${pageContext.request.contextPath}/seller/inventory"
                   class="btn btn-primary btn-sm mt-3">View Inventory</a>
            </div>
        </div>

        <!-- Sales Performance -->
        <div class="col-md-4">

                <div class="dashboard-card text-center">
                    <h5 class="mb-3">📈 Sales Performance</h5>
                    <p class="text-muted">Daily, weekly, and monthly analytics</p>
                    <a href="${pageContext.request.contextPath}/seller/salesPerformance"
                                       class="btn btn-primary btn-sm mt-3">Sales Performance</a>

                </div>
            </a>
        </div>

    </div>
</div>

</body>
</html>
