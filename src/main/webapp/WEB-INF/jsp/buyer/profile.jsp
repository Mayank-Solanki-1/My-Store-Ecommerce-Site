<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: #f5f6fa;
            font-family: 'Segoe UI', sans-serif;
        }

        .profile-container {
            max-width: 700px;
            margin: 40px auto;
        }

        .profile-card {
            background: #fff;
            border-radius: 18px;
            padding: 35px 40px;
            box-shadow: 0 8px 26px rgba(0,0,0,0.08);
            transition: 0.3s ease-in-out;
        }

        .profile-card:hover {
            box-shadow: 0 10px 35px rgba(0,0,0,0.12);
        }

        .profile-title {
            font-size: 28px;
            font-weight: 700;
            color: #2d3436;
            letter-spacing: 0.4px;
        }

        label {
            font-weight: 600;
            font-size: 14px;
            color: #2d3436;
        }

        input.form-control {
            height: 48px;
            border-radius: 10px;
            border: 1px solid #dfe6e9;
            padding-left: 14px;
            transition: 0.2s;
        }

        input.form-control:focus {
            box-shadow: none;
            border-color: #0984e3;
        }

        .btn-save {
            background: #0984e3;
            color: #fff;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            padding: 12px 18px;
            width: 100%;
            transition: 0.3s;
        }

        .btn-save:hover {
            background: #086bcc;
            transform: translateY(-2px);
        }

        .alert {
            border-radius: 10px;
        }

        .back-btn {
            text-decoration: none;
            font-weight: 600;
            color: #636e72;
            font-size: 15px;
        }

        .back-btn:hover {
            color: #2d3436;
        }
    </style>
</head>

<body>

<div class="profile-container">

    <a href="${pageContext.request.contextPath}/buyer/dashboard" class="back-btn">&larr; Back to Dashboard</a>

    <div class="profile-card mt-3">
        <div class="profile-title mb-4">My Profile</div>

        <c:if test="${not empty msg}">
            <div class="alert alert-success">${msg}</div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/buyer/profile" method="post">

            <div class="row g-3">

                <div class="col-md-6">
                    <label>Name</label>
                    <input type="text" name="name" class="form-control"
                           value="${sessionScope.user.name}" required>
                </div>

                <div class="col-md-6">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control"
                           value="${sessionScope.user.email}" required>
                </div>

                <div class="col-md-6">
                    <label>Phone</label>
                    <input type="text" name="phone" class="form-control"
                           value="${sessionScope.user.phone}">
                </div>

                <div class="col-md-6">
                    <label>Pincode</label>
                    <input type="text" name="pincode" class="form-control"
                           value="${sessionScope.user.pincode}">
                </div>

                <div class="col-md-12">
                    <label>Address</label>
                    <input type="text" name="address" class="form-control"
                           value="${sessionScope.user.address}">
                </div>

                <div class="col-md-6">
                    <label>City</label>
                    <input type="text" name="city" class="form-control"
                           value="${sessionScope.user.city}">
                </div>

                <div class="col-md-6">
                    <label>State</label>
                    <input type="text" name="state" class="form-control"
                           value="${sessionScope.user.state}">
                </div>

            </div>

            <button class="btn-save mt-4">Save Changes</button>

        </form>

    </div>
</div>

</body>
</html>
