<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Buyer Dashboard</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background: #eef2f3;
            font-family: 'Poppins', sans-serif;
        }

        .navbar {
            backdrop-filter: blur(10px);
            background: rgba(255,255,255,0.85) !important;
            box-shadow: 0 8px 18px rgba(0,0,0,0.08);
        }

        .dashboard-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: #1f8a70;
        }

        .info-card {
            border-radius: 14px;
            padding: 25px;
            background: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            transition: 0.3s;
        }
        .info-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 14px 32px rgba(0,0,0,0.12);
        }

        /* Quick Action Tiles */
        .quick-tile {
            border-radius: 16px;
            background: linear-gradient(135deg,#1f8a70,#5abf90);
            color: white;
            padding: 22px;
            text-align: center;
            transition: 0.3s;
            cursor: pointer;
        }
        .quick-tile:hover {
            transform: translateY(-6px);
            box-shadow: 0 16px 30px rgba(0,0,0,0.18);
        }
        .quick-tile i {
            font-size: 2.2rem;
        }
        .quick-tile span {
            font-size: 1.05rem;
            font-weight: 500;
        }

        .section-heading {
            font-size: 1.3rem;
            font-weight: 600;
            margin-bottom: 10px;
            color: #333;
        }

        /* Horizontal Scroll Cards */
        .scrollable {
            overflow-x: auto;
            white-space: nowrap;
            padding-bottom: 10px;
        }
        .scrollable .card {
            display: inline-block;
            width: 220px;
            margin-right: 15px;
            border-radius: 14px;
        }
        .scrollable img {
            height: 140px;
            object-fit: cover;
            border-radius: 14px 14px 0 0;
        }
    </style>
</head>

<body>

<!-- -------------------------------------------------- -->
<!-- NAVBAR -->
<!-- -------------------------------------------------- -->
<nav class="navbar navbar-expand-lg navbar-light bg-white py-3">
    <div class="container">
        <a class="navbar-brand fw-bold fs-3" href="${pageContext.request.contextPath}/index.jsp">MyStore</a>
        <div>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">Logout</a>
        </div>
    </div>
</nav>

<div class="container mt-4">

    <!-- Dashboard Title -->
    <h2 class="dashboard-title mb-4">Welcome, ${user.name}! 👋</h2>

    <!-- -------------------------------------------------- -->
    <!-- Account Overview -->
    <!-- -------------------------------------------------- -->
    <div class="info-card mb-4">
        <h4 class="section-heading">Account Overview</h4>

        <p><i class="bi bi-person-circle me-2"></i><strong>Name:</strong> ${user.name}</p>
        <p><i class="bi bi-envelope me-2"></i><strong>Email:</strong> ${user.email}</p>

        <c:if test="${not empty user.phone}">
            <p><i class="bi bi-telephone me-2"></i><strong>Phone:</strong> ${user.phone}</p>
        </c:if>

        <c:if test="${not empty user.address}">
            <p><i class="bi bi-geo-alt me-2"></i><strong>Address:</strong> ${user.address}</p>
        </c:if>

        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/buyer/profile"
               class="btn btn-outline-secondary btn-sm"
               style="border-radius: 12px; font-weight: 600; padding: 6px 14px;">
                Manage Profile
            </a>

            <a href="${pageContext.request.contextPath}/product/list"
               class="btn btn-shop btn-sm ms-2">
                Shop Now
            </a>

            <a href="${pageContext.request.contextPath}/buyer/wishlist"
               class="btn btn-outline-primary btn-sm ms-2"
               style="border-radius: 12px; font-weight: 600; padding: 6px 14px;">
                ❤️ Wishlist
            </a>
        </div>
    </div>

    <!-- -------------------------------------------------- -->
    <!-- Quick Action Tiles -->
    <!-- -------------------------------------------------- -->
    <div class="row g-4 mb-5">

        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/order/history" style="text-decoration:none;">
                <div class="quick-tile">
                    <i class="bi bi-bag-check"></i>
                    <div class="mt-2"><span>Your Orders</span></div>
                </div>
            </a>
        </div>

        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/buyer/wishlist" style="text-decoration:none;">
                <div class="quick-tile">
                    ❤️
                    <div class="mt-2"><span>Wishlist</span></div>
                </div>
            </a>
        </div>

        <div class="col-md-4">
            <a href="${pageContext.request.contextPath}/product/list" style="text-decoration:none;">
                <div class="quick-tile">
                    <i class="bi bi-grid"></i>
                    <div class="mt-2"><span>Browse Products</span></div>
                </div>
            </a>
        </div>
    </div>

</div>

</body>
</html>
