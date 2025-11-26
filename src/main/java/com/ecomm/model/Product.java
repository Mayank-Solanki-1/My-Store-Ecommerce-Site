package com.ecomm.model;

public class Product {
    private int id;
    private int sellerId;
    private String name;
    private String description;
    private double price;
    private int stock;

    public Product() {}

    public Product(int id, int sellerId, String name, String description, double price, int stock) {
        this.id = id; this.sellerId = sellerId; this.name = name; this.description = description; this.price = price; this.stock = stock;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getSellerId() { return sellerId; }
    public void setSellerId(int sellerId) { this.sellerId = sellerId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }
}
