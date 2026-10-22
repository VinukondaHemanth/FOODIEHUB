package com.tap.model;

public class CartItem {

    // =========================================================
    // VARIABLES
    // =========================================================

    private int menuId;
    private String itemName;
    private double price;
    private int quantity;
    private String imagePath;

    // =========================================================
    // DEFAULT CONSTRUCTOR
    // =========================================================

    public CartItem() {
    }

    // =========================================================
    // PARAMETERIZED CONSTRUCTOR
    // =========================================================

    public CartItem(int menuId,
                    String itemName,
                    double price,
                    int quantity,
                    String imagePath) {

        this.menuId = menuId;
        this.itemName = itemName;
        this.price = price;

        if (quantity > 0) {
            this.quantity = quantity;
        } else {
            this.quantity = 1;
        }

        this.imagePath = imagePath;
    }

    // =========================================================
    // GET MENU ID
    // =========================================================

    public int getMenuId() {

        return menuId;
    }

    // =========================================================
    // SET MENU ID
    // =========================================================

    public void setMenuId(int menuId) {

        this.menuId = menuId;
    }

    // =========================================================
    // GET ITEM NAME
    // =========================================================

    public String getItemName() {

        return itemName;
    }

    // =========================================================
    // SET ITEM NAME
    // =========================================================

    public void setItemName(String itemName) {

        this.itemName = itemName;
    }

    // =========================================================
    // GET PRICE
    // =========================================================

    public double getPrice() {

        return price;
    }

    // =========================================================
    // SET PRICE
    // =========================================================

    public void setPrice(double price) {

        this.price = price;
    }

    // =========================================================
    // GET QUANTITY
    // =========================================================

    public int getQuantity() {

        return quantity;
    }

    // =========================================================
    // SET QUANTITY
    // =========================================================

    public void setQuantity(int quantity) {

        this.quantity = quantity;
    }

    // =========================================================
    // GET IMAGE PATH
    // =========================================================

    public String getImagePath() {

        return imagePath;
    }

    // =========================================================
    // SET IMAGE PATH
    // =========================================================

    public void setImagePath(String imagePath) {

        this.imagePath = imagePath;
    }

    // =========================================================
    // TO STRING
    // =========================================================

    @Override
    public String toString() {

        return "CartItem [menuId="
                + menuId
                + ", itemName="
                + itemName
                + ", price="
                + price
                + ", quantity="
                + quantity
                + ", imagePath="
                + imagePath
                + "]";
    }
}