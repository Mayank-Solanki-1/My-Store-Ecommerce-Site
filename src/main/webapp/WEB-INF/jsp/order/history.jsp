<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders • MyStore</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">

    <style>
        body { font-family: 'Poppins', sans-serif; background: #f5f6fa; }
        .page-header { background: linear-gradient(to right, #6b73ff, #000dff); padding: 40px; border-radius: 15px; color: white; margin-top: 20px; text-align: center; }
        .orders-card { background: white; border-radius: 15px; padding: 25px; margin-top: -30px; box-shadow: 0 8px 25px rgba(0,0,0,0.08); }
        table { width: 100%; }
        th { background: #eef0ff; padding: 12px; }
        td { padding: 12px; vertical-align: middle; }
        .badge { font-size: 14px; padding: 6px 12px; border-radius: 50px; }
        .btn-back { border-radius: 50px; padding: 10px 20px; }
        .no-orders { text-align: center; padding: 40px; font-size: 18px; color: #777; }
    </style>
</head>

<body>
<div class="container">

    <!-- PAGE HEADER -->
    <div class="page-header shadow-sm">
        <h1 class="fw-bold">Your Order History</h1>
        <p class="mt-2">Track all your purchases in one place</p>
    </div>

    <!-- ORDERS CARD -->
    <div class="orders-card">

        <!-- Back Button -->
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/product/list" class="btn btn-primary btn-back">
                ← Back to Shop
            </a>
        </div>

        <!-- Check if user has orders -->
        <c:choose>
            <c:when test="${empty orders}">
                <div class="no-orders">
                    <p>No orders yet. Start shopping!</p>
                </div>
            </c:when>

            <c:otherwise>
                <!-- ORDER TABLE -->
                <table class="table table-striped align-middle">
                    <thead>
                        <tr>
                            <th>Order ID</th>
                            <th>Items</th>
                            <th>Total Amount</th>
                            <th>Status</th>
                            <th>Process</th>

                            <th>Placed On</th>
                            <th>Invoice</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td>#${o.id}</td>

                                <!-- Display items -->
                                <td>
                                    <c:forEach var="item" items="${o.items}" varStatus="loop">
                                        ${item.productName} × ${item.quantity}
                                        <c:if test="${!loop.last}">, </c:if>
                                    </c:forEach>
                                </td>

                                <td>₹${o.totalAmount}</td>

                                <!-- Status Badge -->
                                <td>
                                    <c:choose>
                                        <c:when test="${o.status == 'Paid' || o.status == 'Delivered'}">
                                            <span class="badge bg-success">${o.status}</span>
                                        </c:when>
                                        <c:when test="${o.status == 'Pending'}">
                                            <span class="badge bg-warning text-dark">Pending</span>
                                        </c:when>
                                        <c:when test="${o.status == 'Cancelled'}">
                                            <span class="badge bg-danger">Cancelled</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${o.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                  <td>
                                                     <c:choose>
                                                         <c:when test="${o.process == 'Pending'}">
                                                             <span class="badge bg-warning text-dark">Pending</span>
                                                         </c:when>
                                                         <c:when test="${o.process == 'Processing'}">
                                                             <span class="badge bg-primary">Processing</span>
                                                         </c:when>
                                                         <c:when test="${o.process == 'Shipped'}">
                                                             <span class="badge bg-info text-dark">Shipped</span>
                                                         </c:when>
                                                         <c:when test="$o.process == 'Delivered'}">
                                                             <span class="badge bg-success">Delivered</span>
                                                         </c:when>
                                                         <c:when test="${o.process == 'Cancelled'}">
                                                             <span class="badge bg-danger">Cancelled</span>
                                                         </c:when>
                                                         <c:otherwise>
                                                             <span class="badge bg-secondary">${o.process}</span>
                                                         </c:otherwise>
                                                     </c:choose>
                                                 </td>


                                <td>${o.createdAt}</td>

                                <!-- View Invoice Link -->
                                <td>
                                   <a href="${pageContext.request.contextPath}/order/invoice?id=${o.id}"
                                      target="_blank" class="btn btn-sm btn-success">
                                       View Invoice
                                   </a>


                                </td>

                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>

    </div>
</div>
</body>
</html>
