package com.ecomm.dao;

import com.ecomm.model.CartItem;
import com.ecomm.model.Product;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

public class CartDAO {

    // Add product to cart
    public void addToCart(HttpSession session, Product product, int quantity) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new HashMap<>();

        if (cart.containsKey(product.getId())) {
            CartItem item = cart.get(product.getId());
            item.setQuantity(item.getQuantity() + quantity);
        } else {
            cart.put(product.getId(), new CartItem(product, quantity));
        }

        session.setAttribute("cart", cart);
    }

    // Remove product from cart
    public void removeFromCart(HttpSession session, int productId) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart != null) {
            cart.remove(productId);
            session.setAttribute("cart", cart);
        }
    }

    // Update quantity
    public void updateCart(HttpSession session, int productId, int quantity) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart != null && cart.containsKey(productId)) {
            cart.get(productId).setQuantity(quantity);
            session.setAttribute("cart", cart);
        }
    }

    // Get all items
    public Map<Integer, CartItem> getCart(HttpSession session) {
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new HashMap<>();
        return cart;
    }
}
