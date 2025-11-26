<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Manage Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .action-btns form { display:inline-block; margin:0; }
    </style>
</head>

<body>

<div class="container mt-4">

    <a href="${pageContext.request.contextPath}/seller/dashboard" class="btn btn-link mb-3">← Back</a>

    <h2 class="mt-2">My Product Listings</h2>

    <!-- ADD PRODUCT FORM -->
    <div class="card p-3 mb-4 bg-light">
        <h5>Add New Product</h5>
        <form action="${pageContext.request.contextPath}/product/action" method="post" class="row g-2">
            <input type="hidden" name="action" value="add"/>
            <div class="col-md-3">
                <input name="name" class="form-control" placeholder="Product Name" required>
            </div>
            <div class="col-md-3">
                <input name="price" type="number" step="0.01" class="form-control" placeholder="Price" required>
            </div>
            <div class="col-md-2">
                <input name="stock" type="number" class="form-control" placeholder="Stock" required>
            </div>
            <div class="col-md-3">
                <input name="description" class="form-control" placeholder="Description">
            </div>
            <div class="col-md-1">
                <button class="btn btn-success w-100" type="submit">Add</button>
            </div>
        </form>
    </div>

    <!-- PRODUCT TABLE -->
    <table class="table table-bordered align-middle">
        <thead>
        <tr>
            <th>Name</th>
            <th>Price</th>
            <th>Stock</th>
            <th>Description</th>
            <th width="220">Action</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="p" items="${products}">
            <tr id="productRow${p.id}">
                <td class="name">${p.name}</td>
                <td class="price">₹ ${p.price}</td>
                <td class="stock">${p.stock}</td>
                <td class="description">${p.description}</td>

                <td class="action-btns">
                    <!-- EDIT BUTTON -->
                    <button type="button" class="btn btn-primary btn-sm"
                            data-bs-toggle="modal"
                            data-bs-target="#editModal${p.id}">
                        Edit
                    </button>

                    <!-- DELETE BUTTON AJAX -->
                    <button type="button" class="btn btn-danger btn-sm"
                            onclick="deleteProduct(${p.id}, '${p.name}')">
                        Remove
                    </button>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <!-- EDIT MODALS -->
    <c:forEach var="p" items="${products}">
        <div class="modal fade" id="editModal${p.id}" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <form class="modal-content editForm" data-id="${p.id}">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Product — ${p.name}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <div class="mb-2">
                            <label class="form-label">Name</label>
                            <input name="name" class="form-control" value="${p.name}" required>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Price</label>
                            <input name="price" type="number" step="0.01" class="form-control" value="${p.price}" required>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Stock</label>
                            <input name="stock" type="number" class="form-control" value="${p.stock}" required>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="form-control" rows="2">${p.description}</textarea>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-primary" type="button" onclick="updateProduct(${p.id}, this.form)">Save Changes</button>
                        <button class="btn btn-secondary" data-bs-dismiss="modal" type="button">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </c:forEach>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // AJAX Delete (Fixed)
    function deleteProduct(id, name) {
         const data = {
                    action: 'delete',  id: id }
        if (!confirm(`Remove product ${name}?`)) return;

        $.post('<c:url value="/product/action"/>',data,function () {
                // Remove the row from HTML after successful delete
                $('#productRow' + id).remove();
            }
        ).fail(function (xhr) {
            alert('Cannot delete product: ' + xhr.responseText);
        });
    }

    // AJAX Edit (same as before)
    function updateProduct(id, form) {
        const data = {
            action: 'update',
            id: id,
            name: $(form).find('[name=name]').val(),
            price: $(form).find('[name=price]').val(),
            stock: $(form).find('[name=stock]').val(),
            description: $(form).find('[name=description]').val()
        };

        $.post('<c:url value="/product/action"/>', data, function() {
            const row = $('#productRow' + id);
            row.find('.name').text(data.name);
            row.find('.price').text('₹ ' + data.price);
            row.find('.stock').text(data.stock);
            row.find('.description').text(data.description);
            $('#editModal' + id).modal('hide');
        }).fail(function(xhr){
            alert('Cannot update product: ' + xhr.responseText);
        });
    }
</script>

</body>
</html>
