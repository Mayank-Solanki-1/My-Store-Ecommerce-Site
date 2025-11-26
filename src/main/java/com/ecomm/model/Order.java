package com.ecomm.model;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

public class Order {
    private int id;
    private int buyerId;
    private double totalAmount;
    private String status;
    private String process;
    private Timestamp createdAt;

    // Store items for this order
    private List<Map<String, Object>> items;

    // Shipping info
    private String phone;
    private String address;
    private String city;
    private String state;
    private String pincode;

    // --- Getters and Setters ---

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBuyerId() { return buyerId; }
    public void setBuyerId(int buyerId) { this.buyerId = buyerId; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getProcess() {
        return process;
    }

    public void setProcess(String process) {
        this.process = process;
    }


    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<Map<String, Object>> getItems() { return items; }
    public void setItems(List<Map<String, Object>> items) { this.items = items; }

    // Shipping info getters/setters
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }
}
