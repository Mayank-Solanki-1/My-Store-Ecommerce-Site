<%@ page import="java.util.*, com.ecomm.dao.ProductDAO, com.ecomm.model.Product" %>
<%
    HttpSession s = request.getSession();
    Map<Integer,Integer> cart = (Map<Integer,Integer>) s.getAttribute("cart");
    if (cart == null) cart = new HashMap<>();

    ProductDAO dao = new ProductDAO();
    double grandTotal = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Your Cart</title>

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #eef1f5;
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            margin: 30px auto;
            display: flex;
            justify-content: space-between;
            gap: 25px;
        }

        /* CART ITEMS BOX */
        .cart-box {
            width: 70%;
        }

        .item {
            display: flex;
            background: #fff;
            padding: 20px;
            border-radius: 14px;
            margin-bottom: 18px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: 0.2s ease;
        }

        .item:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        }

        .item img {
            width: 130px;
            height: 130px;
            object-fit: cover;
            border-radius: 10px;
            margin-right: 20px;
        }

        .details {
            flex-grow: 1;
        }

        .title {
            font-size: 20px;
            font-weight: 600;
            color: #222;
        }

        .desc {
            font-size: 14px;
            color: #777;
            margin: 6px 0 12px;
        }

        .price {
            font-size: 17px;
            font-weight: bold;
            color: #2e7d32;
        }

        .qty-box {
            width: 60px;
            padding: 8px;
            border-radius: 6px;
            border: 1.5px solid #bbbbbb;
            margin-right: 10px;
        }

        .btn-update {
            background: #2962ff;
            color: #fff;
            padding: 7px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-update:hover {
            background: #0039cb;
        }

        .btn-remove {
            background: #d50000;
            color: #fff;
            padding: 7px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-remove:hover {
            background: #9b0000;
        }

        /* SUMMARY BOX */
        .summary {
            width: 30%;
            background: #fff;
            padding: 25px;
            border-radius: 14px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            height: fit-content;
        }

        .summary h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #222;
        }

        .row {
            display: flex;
            justify-content: space-between;
            margin: 8px 0;
            font-size: 16px;
        }

        .checkout-btn {
            margin-top: 25px;
            width: 100%;
            padding: 14px;
            background: #00c853;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.2s;
        }

        .checkout-btn:hover {
            background: #009624;
        }

        .empty {
            text-align: center;
            font-size: 22px;
            margin-top: 100px;
            color: #777;
        }
    </style>
</head>

<body>


<%
    if (cart.isEmpty()) {
%>
        <h2 class="empty">Your Cart is Empty 😕</h2>

<%
    } else {
%>

<div class="container">

    <!-- CART ITEMS -->
    <div class="cart-box">
        <%
            for (Map.Entry<Integer,Integer> e : cart.entrySet()) {
                Product p = dao.findById(e.getKey());
                int qty = e.getValue();
                double total = p.getPrice() * qty;
                grandTotal += total;
        %>

        <div class="item">
            <img src="<%=request.getContextPath()%>/images/default-product.jpg" />

            <div class="details">
                <div class="title"><%= p.getName() %></div>
                <div class="desc"><%= p.getDescription() %></div>
                <div class="price">₹<%= p.getPrice() %></div>

                <form action="<%=request.getContextPath()%>/cart/add" method="post" style="margin-top: 12px; display:flex; align-items:center;">
                    <input type="hidden" name="productId" value="<%=p.getId()%>" />
                    <input type="number" name="quantity" value="<%=qty%>" class="qty-box" min="1" />
                    <button type="submit" class="btn-update">Update</button>
                </form>

                <form action="<%=request.getContextPath()%>/cart/remove" method="post" style="margin-top: 10px;">
                    <input type="hidden" name="productId" value="<%=p.getId()%>" />
                    <button class="btn-remove">Remove</button>
                </form>
            </div>

            <div class="price" style="margin-left:15px;">
                Total: ₹<%= total %>
            </div>
        </div>

        <% } %>
    </div>

    <!-- SUMMARY -->
    <div class="summary">
        <h2>Order Summary</h2>

        <div class="row">
            <span>Subtotal:</span>
            <span>₹<%= grandTotal %></span>
        </div>

        <hr>

        <div class="row" style="font-size: 20px; font-weight: bold;">
            <span>Total:</span>
            <span>₹<%= grandTotal %></span>
        </div>

        <!-- CHECKOUT -->
        <form action="${pageContext.request.contextPath}/order/Checkout" method="get">
            <button class="checkout-btn" type="submit">Proceed to Checkout</button>
        </form>
    </div>

</div>

<%
    }
%>

</body>
</html>
