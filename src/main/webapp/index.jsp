<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MyStore • Premium Shopping</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f6f7fb;
            overflow-x: hidden;
        }

        /* NAVBAR */
        .navbar-premium {
            background: rgba(255,255,255,0.8);
            backdrop-filter: blur(12px);
            padding: 15px 0;
            border-bottom: 1px solid #ececec;
        }

        .navbar-brand {
            font-weight: 700;
            font-size: 26px;
            background: linear-gradient(90deg, #6b73ff, #000dff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* HERO SECTION */
        .hero {
            height: 75vh;
            background: linear-gradient(135deg, #6b73ff, #000dff, #6f86d6);
            border-radius: 20px;
            color: white;
            padding: 80px;
            position: relative;
            overflow: hidden;
        }

        /* Floating shapes */
        .shape {
            position: absolute;
            border-radius: 50%;
            opacity: 0.3;
            filter: blur(40px);
        }
        .shape1 { width: 200px; height: 200px; top: 20%; left: 10%; background: #ffffff; }
        .shape2 { width: 250px; height: 250px; bottom: 10%; right: 5%; background: #00e5ff; }
        .shape3 { width: 180px; height: 180px; top: 5%; right: 25%; background: #ff00f7; }

        .hero-title {
            font-size: 54px;
            font-weight: 700;
            line-height: 1.2;
            animation: fadeInUp 1s ease;
        }

        .hero-sub {
            font-size: 18px;
            opacity: 0.9;
            margin-top: 10px;
            animation: fadeInUp 1.3s ease;
        }

        .btn-shop-now {
            margin-top: 25px;
            padding: 14px 32px;
            font-size: 18px;
            border-radius: 50px;
            background: white;
            color: #000dff;
            font-weight: 600;
            border: none;
            transition: 0.3s;
            animation: fadeInUp 1.6s ease;
        }

        .btn-shop-now:hover {
            transform: scale(1.08);
            background: #f1f1f1;
        }

        /* CATEGORY CARDS */
        .category-card {
            border-radius: 18px;
            padding: 35px;
            color: white;
            height: 180px;
            transition: transform 0.3s;
            cursor: pointer;
        }

        .category-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 18px 32px rgba(0,0,0,0.1);
        }

        .cat-electronics { background: linear-gradient(135deg, #6b73ff, #000dff); }
        .cat-fashion { background: linear-gradient(135deg, #ff4b2b, #ff416c); }
        .cat-home { background: linear-gradient(135deg, #11998e, #38ef7d); }

        /* ANIMATIONS */
        @keyframes fadeInUp {
            0% { opacity: 0; transform: translateY(25px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        footer {
            background: white;
            padding: 20px;
            border-top: 1px solid #ddd;
        }
    </style>
</head>

<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-premium shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">MyStore</a>

        <div>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="me-3 fw-semibold">Hi, ${sessionScope.user.name}</span>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-primary me-2">Login</a>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<!-- HERO -->
<div class="container mt-4">
    <div class="hero shadow-lg">
        <div class="shape shape1"></div>
        <div class="shape shape2"></div>
        <div class="shape shape3"></div>

        <h1 class="hero-title">Discover Products<br>That Inspire You</h1>
        <p class="hero-sub">Shop the latest trends with a seamless modern experience.</p>

        <a href="${pageContext.request.contextPath}/product/list" class="btn btn-shop-now">
            Start Shopping →
        </a>
    </div>
</div>

<!-- CATEGORY SECTION -->
<div class="container mt-5">
    <h3 class="fw-bold mb-3">Explore Categories</h3>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="category-card cat-electronics">
                <h3>Electronics</h3>
                <p>Latest gadgets & devices</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="category-card cat-fashion">
                <h3>Fashion</h3>
                <p>Trendy & premium clothing</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="category-card cat-home">
                <h3>Home Essentials</h3>
                <p>Everyday living products</p>
            </div>
        </div>
    </div>
</div>

<!-- FOOTER -->
<footer class="text-center mt-5">
    <p class="mb-0">© 2025 MyStore • Premium Experience Delivered</p>
</footer>

</body>
</html>
