<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | MyStore</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f5f5f5;
        }
        .login-container {
            max-width: 420px;
            margin: 60px auto;
            padding: 25px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        }
        .login-title {
            font-weight: bold;
            color: #0052D4;
        }
        .btn-login {
            background-color: #0052D4;
            border: none;
        }
        .btn-login:hover {
            background-color: #003c9f;
        }
        .form-label {
            font-weight: 600;
        }
    </style>
</head>
<body>

<!-- NAVBAR (same as index.jsp) -->
<nav class="navbar navbar-expand-lg navbar-custom shadow-sm" style="background: white; border-bottom: 1px solid #ddd;">
    <div class="container">
        <a class="navbar-brand fw-bold" href="index.jsp">MyStore</a>

        <div>
            <a href="login.jsp" class="btn btn-outline-primary me-2">Login</a>
            <a href="register.jsp" class="btn btn-primary">Sign Up</a>
        </div>
    </div>
</nav>


<!-- LOGIN CARD -->
<div class="login-container shadow-sm">

    <h3 class="text-center login-title mb-3">Welcome Back</h3>
    <p class="text-center text-muted mb-4">Login to continue shopping</p>

    <!-- Display error from servlet (if any) -->
    <%
        String error = request.getParameter("error");
        if (error != null) {
    %>
        <div class="alert alert-danger text-center">Invalid email or password</div>
    <%
        }
    %>

    <form action="login" method="post">
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

        <!-- Login Button -->
        <button type="submit" class="btn btn-login text-white w-100 py-2 mt-2">
            Login
        </button>

        <!-- Register Link -->
        <p class="text-center mt-3 mb-0">
            Don't have an account?
            <a href="register.jsp" class="fw-bold" style="color:#0052D4;">Sign Up</a>
        </p>
    </form>
</div>


<!-- FOOTER -->
<footer class="text-center mt-5 py-3 bg-white shadow-sm">
    <p class="mb-0">© 2025 MyStore — All Rights Reserved</p>
</footer>

</body>
</html>
