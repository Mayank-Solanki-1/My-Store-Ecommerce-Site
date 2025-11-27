remove option of admin from register.jsp --><%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register | MyStore</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        body {
            background: #f5f5f5;
            font-family: 'Segoe UI', sans-serif;
        }
        .register-container {
            max-width: 480px;
            margin: 50px auto;
            padding: 25px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .register-title {
            font-weight: bold;
            color: #0052D4;
        }
        .btn-register {
            background-color: #0052D4;
            border: none;
        }
        .btn-register:hover {
            background-color: #003c9f;
        }
        .form-label {
            font-weight: 600;
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-custom shadow-sm" style="background: white; border-bottom: 1px solid #ddd;">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/index.jsp">MyStore</a>
        <div>
            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-primary me-2">Login</a>
            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">Sign Up</a>
        </div>
    </div>
</nav>

<!-- REGISTER CARD -->
<div class="register-container">
    <h3 class="text-center register-title mb-3">Create Your Account</h3>
    <p class="text-center text-muted mb-4">Join MyStore and start shopping today!</p>

    <!-- Success & Error -->
    <c:if test="${param.success == '1'}">
        <div class="alert alert-success text-center">Registration successful! Please login.</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger text-center">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/register" method="post">

        <!-- Full Name -->
        <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input type="text" name="name" class="form-control" placeholder="Enter full name" required>
        </div>

        <!-- Email -->
        <div class="mb-3">
            <label class="form-label">Email Address</label>
            <input type="email" name="email" class="form-control" placeholder="Enter email" required>
        </div>

        <!-- Password -->
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Enter password" required>
        </div>

        <!-- Confirm Password -->
        <div class="mb-3">
            <label class="form-label">Confirm Password</label>
            <input type="password" name="confirm" class="form-control" placeholder="Confirm password" required>
        </div>

        <!-- Phone -->
        <div class="mb-3">
            <label class="form-label">Phone</label>
            <input type="text" name="phone" class="form-control" placeholder="Enter phone number" required>
        </div>

        <!-- Address -->
        <div class="mb-3">
            <label class="form-label">Address</label>
            <input type="text" name="address" class="form-control" placeholder="Street address" required>
        </div>

        <!-- City -->
        <div class="mb-3">
            <label class="form-label">City</label>
            <input type="text" name="city" class="form-control" placeholder="City" required>
        </div>

        <!-- State -->
        <div class="mb-3">
            <label class="form-label">State</label>
            <input type="text" name="state" class="form-control" placeholder="State" required>
        </div>

        <!-- Pincode -->
        <div class="mb-3">
            <label class="form-label">Pincode</label>
            <input type="text" name="pincode" class="form-control" placeholder="Postal code" required>
        </div>

        <!-- Role -->
        <div class="mb-3">
            <label class="form-label">Register As</label>
            <select name="role" class="form-select" id="roleSelect" required>
                <option value="">Select Role</option>
                <option value="buyer">Buyer</option>
                <option value="seller">Seller</option>
                <option value="admin">Admin</option>
            </select>
        </div>

        <!-- Admin Secret Key -->
        <div class="mb-3" id="adminKeyDiv" style="display:none;">
            <label class="form-label">Admin Secret Key</label>
            <input type="password" name="adminKey" class="form-control" placeholder="Enter Admin Key">
        </div>

        <!-- Submit -->
        <button type="submit" class="btn btn-register text-white w-100 py-2 mt-2">
            Create Account
        </button>

        <!-- Login Link -->
        <p class="text-center mt-3 mb-0">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login.jsp" class="fw-bold" style="color:#0052D4;">Login</a>
        </p>
    </form>
</div>

<footer class="text-center mt-5 py-3 bg-white shadow-sm">
    <p class="mb-0">© 2025 MyStore — All Rights Reserved</p>
</footer>

<script>
    // Show admin key input only if Admin role is selected
    $('#roleSelect').on('change', function () {
        if ($(this).val() === 'admin') {
            $('#adminKeyDiv').slideDown();
        } else {
            $('#adminKeyDiv').slideUp();
        }
    });
</script>

</body>
</html>
