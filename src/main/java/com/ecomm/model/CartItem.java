package com.ecomm.model;

public class CartItem {
    private Product product;  // Holds the Product object
    private int quantity;     // Quantity of this product in the cart

    // Default constructor
    public CartItem() {}

    // Constructor with product and quantity
    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
    }

    // Getter and setter for Product
    public Product getProduct() {
        return product;
    }
    public void setProduct(Product product) {
        this.product = product;
    }

    // Getter and setter for Quantity
    public int getQuantity() {
        return quantity;
    }
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Convenience methods to access product properties directly
    public int getProductId() {
        return product != null ? product.getId() : 0;
    }
    public String getName() {
        return product != null ? product.getName() : "";
    }
    public String getDescription() {
        return product != null ? product.getDescription() : "";
    }
    public double getPrice() {
        return product != null ? product.getPrice() : 0.0;
    }
    public int getSellerId() {
        return product != null ? product.getSellerId() : 0;
    }
}
