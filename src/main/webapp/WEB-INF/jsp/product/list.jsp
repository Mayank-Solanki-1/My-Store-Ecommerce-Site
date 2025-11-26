<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.ecomm.model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body { background: #f0f2f5; font-family: 'Poppins', sans-serif; }
        .product-card {
            background:#fff; padding:20px; border-radius:15px;
            box-shadow:0 6px 20px rgba(0,0,0,0.08);
            transition:0.3s; display:flex; flex-direction:column; justify-content:space-between;
            height:100%; cursor:pointer;
        }
        .product-card:hover { transform: translateY(-5px); box-shadow:0 12px 25px rgba(0,0,0,0.15); }
        .product-card h5 { font-weight:600; color:#333; margin-bottom:10px; }
        .product-price { font-weight:700; color:#4CAF50; font-size:16px; }
        .stock-badge { display:inline-block; padding:3px 8px; border-radius:12px; font-size:12px; color:#fff; }
        .in-stock { background:#4CAF50; } .out-stock { background:#e53935; }
        .description {
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .btn-group { display:flex; flex-direction:column; gap:5px; margin-top:auto; }
        .btn-cart { background:#2196F3; color:#fff; border:none; border-radius:8px; padding:6px 12px; }
        .btn-cart:hover { background:#1976D2; }
        .btn-wishlist { background:#ff4757; color:#fff; border:none; border-radius:8px; padding:6px 12px; }
        .btn-wishlist:hover { background:#e84118; }
        /* Prevent clicks on buttons from triggering card click */
        .product-card form, .btn-view { cursor: default; }
    </style>
</head>
<body>

<div class="container mt-5">
    <h2 class="mb-4 text-center">Our Products</h2>
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
        <c:forEach var="p" items="${products}">
            <div class="col d-flex">
                <div class="product-card w-100 d-flex flex-column"
                     onclick="showFullDescription('${p.name}', '${p.description}')">

                    <div>
                        <h5>${p.name}</h5>
                        <p class="description">${p.description}</p>
                        <p class="product-price">₹${p.price}</p>
                        <span class="stock-badge ${p.stock > 0 ? 'in-stock' : 'out-stock'}">
                            ${p.stock > 0 ? 'In Stock' : 'Out of Stock'}
                        </span>
                    </div>

                    <div class="btn-group mt-3" onclick="event.stopPropagation();">
                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-flex">
                            <input type="hidden" name="productId" value="${p.id}" />
                            <input type="number" name="quantity" value="1" min="1" class="form-control me-2" style="width:70px;" />
                            <button class="btn-cart" ${p.stock == 0 ? 'disabled' : ''}>Add to Cart</button>
                        </form>

                        <form action="${pageContext.request.contextPath}/buyer/wishlist" method="post">
                            <input type="hidden" name="productId" value="${p.id}" />
                            <c:choose>
                                <c:when test="${wishlistProducts != null && wishlistProducts.contains(p)}">
                                    <button class="btn-wishlist" name="action" value="remove">♥ Remove</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn-wishlist" name="action" value="add">♡ Add</button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Modal to show full description -->
<div class="modal fade" id="descModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="descModalTitle">Product Name</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="descModalBody">Full description</div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showFullDescription(name, description) {
        document.getElementById('descModalTitle').innerText = name;
        document.getElementById('descModalBody').innerText = description;
        var modal = new bootstrap.Modal(document.getElementById('descModal'));
        modal.show();
    }
</script>

</body>
</html>
