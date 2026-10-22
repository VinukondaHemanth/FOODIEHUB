
package com.tap.model;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart {

    private int restaurantId;

    // menuId -> CartItem
    private final Map<Integer, CartItem> items;

    // Default constructor
    public Cart() {
        this.items = new LinkedHashMap<>();
    }

    // Restaurant constructor
    public Cart(int restaurantId) {
        this.restaurantId = restaurantId;
        this.items = new LinkedHashMap<>();
    }

    // Get restaurant ID
    public int getRestaurantId() {
        return restaurantId;
    }

    // Set restaurant ID
    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    // Add item to cart
    public void addItem(CartItem item) {

        if (item == null) {
            throw new IllegalArgumentException(
                    "Cart item cannot be null."
            );
        }

        if (item.getMenuId() <= 0) {
            throw new IllegalArgumentException(
                    "Menu ID must be greater than zero."
            );
        }

        if (!isValidPrice(item.getPrice())) {
            throw new IllegalArgumentException(
                    "Item price must be a valid non-negative amount."
            );
        }

        if (item.getQuantity() <= 0) {
            throw new IllegalArgumentException(
                    "Item quantity must be greater than zero."
            );
        }

        int menuId = item.getMenuId();

        CartItem existingItem = items.get(menuId);

        if (existingItem != null) {

            if (existingItem.getQuantity()
                    > Integer.MAX_VALUE - item.getQuantity()) {

                throw new IllegalArgumentException(
                        "Cart quantity is too large."
                );
            }

            existingItem.setQuantity(
                    existingItem.getQuantity()
                    + item.getQuantity()
            );

        } else {
            items.put(menuId, item);
        }
    }

    // Remove one item
    public void removeItem(int menuId) {
        items.remove(menuId);
    }

    // Increase quantity by one
    public void increaseQuantity(int menuId) {

        CartItem item = items.get(menuId);

        if (item != null) {

            if (item.getQuantity() == Integer.MAX_VALUE) {
                throw new IllegalStateException(
                        "Maximum item quantity reached."
                );
            }

            item.setQuantity(item.getQuantity() + 1);
        }
    }

    // Decrease quantity by one; remove item when quantity reaches zero
    public void decreaseQuantity(int menuId) {

        CartItem item = items.get(menuId);

        if (item == null) {
            return;
        }

        if (item.getQuantity() <= 1) {
            items.remove(menuId);
        } else {
            item.setQuantity(item.getQuantity() - 1);
        }
    }

    // Clear items without changing the restaurant ID
    public void clearCart() {
        items.clear();
    }

    // Get all items
    public Collection<CartItem> getItems() {
        return items.values();
    }

    // Get a specific item
    public CartItem getItem(int menuId) {
        return items.get(menuId);
    }

    // Calculate total amount
    public double getTotalAmount() {

        double total = 0.0;

        for (CartItem item : items.values()) {

            total += item.getPrice() * item.getQuantity();

            if (Double.isNaN(total)
                    || Double.isInfinite(total)) {

                throw new IllegalStateException(
                        "Cart total is outside the valid range."
                );
            }
        }

        return total;
    }

    // Check whether cart is empty
    public boolean isEmpty() {
        return items.isEmpty();
    }

    // Number of distinct menu items
    public int getItemCount() {
        return items.size();
    }

    // Total quantity across all menu items
    public int getTotalQuantity() {

        int totalQuantity = 0;

        for (CartItem item : items.values()) {

            if (totalQuantity
                    > Integer.MAX_VALUE - item.getQuantity()) {

                throw new IllegalStateException(
                        "Total cart quantity is too large."
                );
            }

            totalQuantity += item.getQuantity();
        }

        return totalQuantity;
    }

    private boolean isValidPrice(double price) {
        return price >= 0
                && !Double.isNaN(price)
                && !Double.isInfinite(price);
    }

    @Override
    public String toString() {

        return "Cart [restaurantId="
                + restaurantId
                + ", items="
                + items
                + ", totalAmount="
                + getTotalAmount()
                + "]";
    }
}
