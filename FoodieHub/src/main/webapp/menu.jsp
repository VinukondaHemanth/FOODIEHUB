<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.tap.model.Menu" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>

<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("allMenu");
    Cart cart = (Cart) session.getAttribute("cart");
    String cp = request.getContextPath();

    int restaurantId = 0;
    Object restaurantIdObject = request.getAttribute("restaurantId");

    if (restaurantIdObject instanceof Integer) {
        restaurantId = ((Integer) restaurantIdObject).intValue();
    } else {
        try {
            restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
        } catch (Exception ignored) {
            restaurantId = 0;
        }
    }

    String restaurantName = (String) request.getAttribute("restaurantName");
    String cuisine = (String) request.getAttribute("restaurantCuisine");
    String rating = (String) request.getAttribute("restaurantRating");
    String restaurantImage = (String) request.getAttribute("restaurantImage");

    // MenuController uses restaurantDeliveryTime.
    String deliveryTime = (String) request.getAttribute("restaurantDeliveryTime");

    // Retain compatibility with the previous JSP attribute name.
    if (deliveryTime == null || deliveryTime.trim().isEmpty()) {
        deliveryTime = (String) request.getAttribute("deliveryTime");
    }

    String deliveryFee = (String) request.getAttribute("deliveryFee");
    String reviews = (String) request.getAttribute("restaurantReviews");

    if (restaurantName == null || restaurantName.trim().isEmpty()) {
        restaurantName = "Restaurant";
    }

    if (cuisine == null || cuisine.trim().isEmpty()) {
        cuisine = "Explore our menu";
    }

    if (rating == null || rating.trim().isEmpty()) {
        rating = "Not rated";
    }

    if (reviews == null || reviews.trim().isEmpty()) {
        reviews = "FoodieHub";
    }

    if (deliveryTime == null || deliveryTime.trim().isEmpty()) {
        deliveryTime = "Delivery available";
    }

    if (deliveryFee == null || deliveryFee.trim().isEmpty()) {
        deliveryFee = "Fee at checkout";
    }

    if (restaurantImage == null || restaurantImage.trim().isEmpty()) {
        restaurantImage =
            "https://placehold.co/900x500/073a28/eafff0?text=FoodieHub+Restaurant";
    }

    // Escape values before placing them in HTML attributes or text.
    String safeRestaurantName = restaurantName
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;");

    String safeCuisine = cuisine
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;");

    String safeRestaurantImage = restaurantImage
        .replace("&", "&amp;")
        .replace("\"", "&quot;")
        .replace("<", "&lt;")
        .replace(">", "&gt;");

    int cartCount = (cart == null) ? 0 : cart.getItemCount();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title><%= safeRestaurantName %> | FoodieHub</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap"
      rel="stylesheet">

<style>
:root {
    --bg: #001a12;
    --panel: #05291e;
    --panel2: #073525;
    --green: #00ed83;
    --bright: #69ffac;
    --text: #f4fff8;
    --muted: #9bb8a8;
    --border: rgba(105, 255, 172, .16);
    --danger: #ff7777;
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

html {
    scroll-behavior: smooth;
    scroll-padding-top: 100px;
}

body {
    min-height: 100vh;
    color: var(--text);
    background:
        radial-gradient(ellipse at top right, rgba(0,237,131,.09), transparent 35%),
        var(--bg);
    font-family: "DM Sans", Arial, sans-serif;
}

a {
    color: inherit;
    text-decoration: none;
}

button, input {
    font: inherit;
}

button {
    cursor: pointer;
}

button:disabled {
    opacity: .6;
    cursor: wait;
}

[hidden] {
    display: none !important;
}

.page-shell {
    width: min(1180px, 92%);
    margin: 28px auto 100px;
}

/* Back navigation */

.back-row {
    margin-bottom: 20px;
}

.back-link {
    display: inline-flex;
    align-items: center;
    gap: 9px;
    color: var(--muted);
    font-size: 13px;
    font-weight: 700;
    transition: color .2s, transform .2s;
}

.back-link:hover {
    color: var(--green);
    transform: translateX(-3px);
}

/* Selected restaurant banner */

.restaurant-banner {
    display: grid;
    grid-template-columns: minmax(0, 42%) minmax(0, 1fr);
    align-items: center;
    gap: 24px;
    padding: 18px;
    border: 1px solid var(--border);
    border-radius: 25px;
    background: linear-gradient(135deg, #073525, #031f17);
    box-shadow: 0 18px 55px rgba(0,0,0,.24);
    overflow: hidden;
}

.restaurant-image {
    display: block;
    width: 100%;
    height: 260px;
    object-fit: cover;
    border-radius: 18px;
    background: var(--panel2);
}

.restaurant-details {
    min-width: 0;
}

.kicker {
    margin-bottom: 13px;
    color: var(--green);
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 3px;
}

.restaurant-details h1 {
    font-family: "Playfair Display", Georgia, serif;
    font-size: clamp(26px, 2.5vw, 34px);
    line-height: 1.2;
    overflow-wrap: anywhere;
}

.cuisine {
    margin-top: 12px;
    color: var(--muted);
    font-size: 14px;
}

.rating-row {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-top: 17px;
}

.star {
    color: #ffd166;
    font-size: 21px;
}

.rating-value {
    font-weight: 800;
}

.reviews {
    color: var(--muted);
    font-size: 12px;
}

.restaurant-stats {
    display: flex;
    flex-wrap: wrap;
    gap: 8px 10px;
    margin-top: 16px;
}

.restaurant-stats span {
    padding: 8px 10px;
    border: 1px solid var(--border);
    border-radius: 9px;
    background: rgba(0,0,0,.15);
    color: #d9f5e5;
    font-size: 11px;
}

.stat-icon {
    margin-right: 5px;
    color: var(--green);
}

/* Menu heading and search */

.menu-heading {
    display: flex;
    align-items: end;
    justify-content: space-between;
    gap: 20px;
    margin: 42px 0 22px;
}

.menu-heading h2 {
    font-family: "Playfair Display", Georgia, serif;
    font-size: clamp(27px, 3vw, 36px);
}

.menu-heading p {
    margin-top: 7px;
    color: var(--muted);
    font-size: 13px;
}

.menu-heading-actions {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 12px;
    flex: 0 1 auto;
    min-width: 0;
}

.search-box {
    position: relative;
    width: min(320px, 27vw);
    min-width: 180px;
    flex: 1 1 240px;
}

.search-box input {
    width: 100%;
    min-height: 47px;
    padding: 0 16px 0 43px;
    border: 1px solid var(--border);
    border-radius: 13px;
    outline: none;
    color: var(--text);
    background: var(--panel);
    transition: border-color .2s, box-shadow .2s;
}

.search-box input::placeholder {
    color: #789b89;
}

.search-box input:focus {
    border-color: var(--green);
    box-shadow: 0 0 0 3px rgba(0,237,131,.09);
}

.search-icon {
    position: absolute;
    top: 11px;
    left: 15px;
    color: var(--green);
    font-size: 20px;
}

.view-cart-button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    flex: 0 0 auto;
    min-height: 47px;
    padding: 0 16px;
    border: 1px solid var(--green);
    border-radius: 13px;
    color: #00351e;
    background: var(--green);
    font-size: 12px;
    font-weight: 800;
    white-space: nowrap;
    transition: transform .2s, background .2s, box-shadow .2s;
}

.view-cart-button:hover {
    transform: translateY(-2px);
    background: var(--bright);
    box-shadow: 0 6px 20px rgba(0,237,131,.18);
}

.view-cart-count {
    display: inline-grid;
    min-width: 24px;
    height: 24px;
    padding: 0 6px;
    place-items: center;
    border-radius: 50%;
    color: var(--text);
    background: #06442d;
    font-size: 11px;
}

/* Menu cards */

.menu-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 17px;
}

.menu-item {
    display: grid;
    grid-template-columns: 118px minmax(0, 1fr);
    grid-template-rows: auto auto;
    column-gap: 17px;
    row-gap: 12px;
    min-width: 0;
    padding: 17px;
    border: 1px solid var(--border);
    border-radius: 18px;
    background: linear-gradient(145deg, #073525, #032219);
    transition: transform .25s, border-color .25s, box-shadow .25s;
    animation: fadeUp .4s both;
}

.menu-item:hover {
    transform: translateY(-4px);
    border-color: rgba(0,237,131,.55);
    box-shadow: 0 12px 35px rgba(0,237,131,.08);
}

.dish-image-wrap {
    position: relative;
    grid-row: 1 / 3;
    width: 118px;
    height: 112px;
    overflow: hidden;
    border-radius: 13px;
    background: #0a3b2b;
}

.dish-image {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform .35s;
}

.menu-item:hover .dish-image {
    transform: scale(1.05);
}

.dish-image-wrap.has-missing-image::after {
    content: "Image unavailable";
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 8px;
    color: var(--muted);
    background: #0a3b2b;
    font-size: 11px;
    text-align: center;
}

.dish-info {
    min-width: 0;
}

.dish-info h3 {
    font-size: 16px;
    line-height: 1.35;
    overflow-wrap: anywhere;
}

.dish-description {
    display: -webkit-box;
    margin-top: 7px;
    overflow: hidden;
    color: var(--muted);
    font-size: 12px;
    line-height: 1.6;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
}

.dish-bottom {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    min-width: 0;
}

.dish-price {
    color: var(--bright);
    font-size: 17px;
    font-weight: 800;
    white-space: nowrap;
}

.cart-control {
    display: flex;
    justify-content: flex-end;
    min-width: 105px;
}

.add-button {
    min-width: 100px;
    min-height: 37px;
    padding: 0 14px;
    border: 1px solid var(--green);
    border-radius: 10px;
    color: var(--green);
    background: rgba(0,237,131,.07);
    font-size: 12px;
    font-weight: 800;
    transition: color .2s, background .2s;
}

.add-button:hover {
    color: #00351e;
    background: var(--green);
}

.quantity-control {
    display: inline-flex;
    align-items: center;
    gap: 14px;
    min-height: 37px;
    padding: 3px 5px;
    border: 1px solid var(--green);
    border-radius: 10px;
    background: rgba(0,237,131,.08);
}

.quantity-btn {
    display: grid;
    width: 28px;
    height: 28px;
    place-items: center;
    border: 0;
    border-radius: 7px;
    color: #00351e;
    background: var(--green);
    font-size: 19px;
    font-weight: 800;
}

.quantity-btn:hover {
    background: var(--bright);
}

.quantity-value {
    min-width: 12px;
    color: var(--text);
    text-align: center;
    font-weight: 800;
}

.unavailable-label {
    color: var(--danger);
    font-size: 11px;
    font-weight: 800;
}

/* Empty states */

.empty-menu {
    grid-column: 1 / -1;
    padding: 45px 20px;
    border: 1px dashed var(--border);
    border-radius: 18px;
    color: var(--muted);
    text-align: center;
}

.empty-menu h3 {
    margin-bottom: 8px;
    color: var(--text);
}

.empty-menu p {
    font-size: 13px;
}

/* Feedback toast */

.feedback {
    position: fixed;
    z-index: 500;
    top: 90px;
    right: 22px;
    max-width: min(380px, calc(100% - 44px));
    padding: 14px 18px;
    border: 1px solid var(--border);
    border-radius: 12px;
    color: var(--text);
    background: #073525;
    box-shadow: 0 12px 30px rgba(0,0,0,.35);
    opacity: 0;
    pointer-events: none;
    transform: translateY(-8px);
    transition: opacity .2s, transform .2s;
}

.feedback.show {
    opacity: 1;
    transform: translateY(0);
}

.feedback.error {
    border-color: rgba(255,119,119,.6);
}

/* Restaurant switch confirmation */

.modal-overlay {
    position: fixed;
    z-index: 1000;
    inset: 0;
    display: none;
    align-items: center;
    justify-content: center;
    padding: 20px;
    background: rgba(0,0,0,.75);
    backdrop-filter: blur(6px);
}

.modal-overlay.show {
    display: flex;
}

.switch-modal {
    width: min(440px, 100%);
    padding: 26px;
    border: 1px solid var(--border);
    border-radius: 20px;
    background: #05291e;
    box-shadow: 0 25px 70px rgba(0,0,0,.4);
    animation: fadeUp .2s both;
}

.modal-icon {
    display: grid;
    width: 50px;
    height: 50px;
    place-items: center;
    margin-bottom: 17px;
    border-radius: 14px;
    color: #00351e;
    background: var(--green);
    font-size: 23px;
}

.switch-modal h2 {
    margin-bottom: 10px;
    font-family: "Playfair Display", Georgia, serif;
    font-size: 25px;
}

.switch-modal p {
    color: var(--muted);
    font-size: 13px;
    line-height: 1.7;
}

.cart-switch-actions {
    display: flex;
    gap: 10px;
    margin-top: 24px;
}

.cart-switch-actions button {
    flex: 1;
    min-height: 43px;
    padding: 0 12px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: 800;
}

.cart-switch-cancel {
    border: 1px solid rgba(255,255,255,.2);
    color: var(--text);
    background: transparent;
}

.cart-switch-cancel:hover {
    border-color: var(--green);
}

.cart-switch-confirm {
    border: 1px solid var(--green);
    color: #00351e;
    background: var(--green);
}

.cart-switch-confirm:hover {
    background: var(--bright);
}

@keyframes fadeUp {
    from {
        opacity: 0;
        transform: translateY(12px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Responsive design */

@media (max-width: 900px) {
    .menu-grid {
        grid-template-columns: 1fr;
    }

    .restaurant-banner {
        gap: 18px;
        padding: 16px;
    }

    .restaurant-image {
        height: 230px;
    }

    .menu-heading-actions {
        gap: 8px;
    }

    .search-box {
        width: min(280px, 25vw);
        min-width: 160px;
    }

    .view-cart-button {
        padding: 0 11px;
        gap: 6px;
    }
}

@media (max-width: 620px) {
    .page-shell {
        width: 94%;
        margin-top: 20px;
    }

    .restaurant-banner {
        grid-template-columns: 1fr;
        gap: 20px;
        padding: 16px;
    }

    .restaurant-image {
        height: 220px;
    }

    .restaurant-details h1 {
        font-size: 30px;
    }

    .menu-heading {
        align-items: stretch;
        flex-direction: column;
        margin-top: 32px;
    }

    .menu-heading-actions {
        width: 100%;
        flex-wrap: nowrap;
        justify-content: stretch;
    }

    .search-box {
        width: auto;
        min-width: 0;
        flex: 1 1 auto;
    }

    .view-cart-button {
        min-height: 47px;
        padding: 0 10px;
        gap: 5px;
    }

    .menu-item {
        grid-template-columns: 88px minmax(0, 1fr);
        column-gap: 12px;
        padding: 12px;
    }

    .dish-image-wrap {
        width: 88px;
        height: 92px;
    }

    .dish-info h3 {
        font-size: 14px;
    }

    .dish-description {
        font-size: 11px;
        -webkit-line-clamp: 2;
    }

    .dish-price {
        font-size: 15px;
    }

    .add-button {
        min-width: 82px;
        padding: 0 9px;
    }

    .quantity-control {
        gap: 8px;
    }

    .quantity-btn {
        width: 25px;
        height: 25px;
    }
}

@media (max-width: 380px) {
    .view-cart-button {
        padding: 0 8px;
        font-size: 11px;
    }

    .view-cart-button .cart-button-text {
        display: none;
    }

    .dish-bottom {
        align-items: flex-start;
        flex-direction: column;
    }

    .cart-control {
        justify-content: flex-start;
    }
}

@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        scroll-behavior: auto !important;
        animation-duration: .01ms !important;
        transition-duration: .01ms !important;
    }
}
</style>
</head>

<body>

<!-- Shared navbar: keep the same navbar across FoodieHub pages. -->
<%@ include file="components/navbar.jsp" %>

<div class="feedback" id="feedback" role="status" aria-live="polite"></div>

<main class="page-shell">

    <div class="back-row">
        <a class="back-link" href="<%= cp %>/restaurant">
            <span aria-hidden="true">←</span>
            <span>Back to Restaurants</span>
        </a>
    </div>

    <!-- Selected restaurant details -->
    <section class="restaurant-banner">

        <img
            class="restaurant-image"
            src="<%= safeRestaurantImage %>"
            alt="<%= safeRestaurantName %>"
            onerror="this.onerror=null;this.src='https://placehold.co/900x500/073a28/eafff0?text=FoodieHub+Restaurant';">

        <div class="restaurant-details">
            <div class="kicker">YOUR RESTAURANT MENU</div>

            <h1><%= safeRestaurantName %></h1>

            <p class="cuisine"><%= safeCuisine %></p>

            <div class="rating-row">
                <span class="star" aria-hidden="true">★</span>
                <span class="rating-value"><%= rating %></span>
                <span class="reviews">(<%= reviews %>)</span>
            </div>

            <div class="restaurant-stats">
                <span><span class="stat-icon">◷</span><%= deliveryTime %></span>
                <span><span class="stat-icon">♧</span><%= deliveryFee %></span>
                <span><span class="stat-icon">✓</span>Freshly prepared</span>
            </div>
        </div>

    </section>

    <!-- Menu heading, search and cart -->
    <section class="menu-section">

        <div class="menu-heading">

            <div>
                <h2>Explore the Menu</h2>
                <p>Choose your favourites and add them to your cart.</p>
            </div>

            <div class="menu-heading-actions">

                <label class="search-box">
                    <span class="search-icon" aria-hidden="true">⌕</span>
                    <input
                        type="search"
                        id="menuSearch"
                        placeholder="Search dishes..."
                        autocomplete="off"
                        aria-label="Search menu dishes">
                </label>

                <a class="view-cart-button" href="<%= cp %>/cart">
                    <span aria-hidden="true">🛒</span>
                    <span class="cart-button-text">View Cart</span>
                    <span class="view-cart-count" id="viewCartCount"><%= cartCount %></span>
                </a>

            </div>
        </div>

        <div class="menu-grid" id="menuGrid">

        <%
            int renderedItems = 0;

            if (menuList != null && !menuList.isEmpty()) {
                for (Menu menu : menuList) {

                    if (menu == null) {
                        continue;
                    }

                    /*
                     * Safety check: render only records belonging to the
                     * restaurant selected by the user.
                     */
                    if (menu.getRestaurantId() != restaurantId) {
                        continue;
                    }

                    String itemName = menu.getItemName() == null
                            ? ""
                            : menu.getItemName().trim();

                    String description = menu.getDescription() == null
                            ? ""
                            : menu.getDescription().trim();

                    String imageUrl = menu.getImagePath() == null
                            ? ""
                            : menu.getImagePath().trim();

                    // Do not show invented item names for empty DB values.
                    if (itemName.isEmpty()) {
                        continue;
                    }

                    String safeName = itemName
                            .replace("&", "&amp;")
                            .replace("<", "&lt;")
                            .replace(">", "&gt;")
                            .replace("\"", "&quot;");

                    String safeDescription = description
                            .replace("&", "&amp;")
                            .replace("<", "&lt;")
                            .replace(">", "&gt;")
                            .replace("\"", "&quot;");

                    String safeImage = imageUrl
                            .replace("&", "&amp;")
                            .replace("\"", "&quot;")
                            .replace("<", "&lt;")
                            .replace(">", "&gt;");

                    String searchText = (itemName + " " + description)
                            .toLowerCase(Locale.ROOT);

                    CartItem cartItem = null;

                    if (cart != null
                            && cart.getRestaurantId() == restaurantId) {
                        cartItem = cart.getItem(menu.getMenuId());
                    }

                    int quantity = cartItem == null
                            ? 0
                            : cartItem.getQuantity();

                    renderedItems++;
        %>

            <article
                class="menu-item"
                data-search="<%= searchText.replace("\"", "&quot;") %>"
                style="animation-delay:<%= Math.min(renderedItems * 35, 350) %>ms">

                <div class="dish-image-wrap">

                    <% if (!safeImage.isEmpty()) { %>

                        <img
                            class="dish-image"
                            src="<%= safeImage %>"
                            alt="<%= safeName %>"
                            loading="lazy"
                            onerror="this.onerror=null;this.style.display='none';this.parentElement.classList.add('has-missing-image');">

                    <% } else { %>

                        <div class="dish-image-wrap-placeholder"
                             role="img"
                             aria-label="Image unavailable"
                             style="display:flex;width:100%;height:100%;align-items:center;justify-content:center;padding:8px;color:#9bb8a8;font-size:11px;text-align:center;">
                            Image unavailable
                        </div>

                    <% } %>

                </div>

                <div class="dish-info">
                    <h3><%= safeName %></h3>

                    <% if (!description.isEmpty()) { %>
                        <p class="dish-description"><%= safeDescription %></p>
                    <% } %>
                </div>

                <div class="dish-bottom">

                    <div class="dish-price">
                        ₹<%= String.format(Locale.US, "%.2f", menu.getPrice()) %>
                    </div>

                    <div
                        class="cart-control"
                        id="cart-control-<%= menu.getMenuId() %>">

                        <% if (!menu.isAvailable()) { %>

                            <span class="unavailable-label">
                                Currently unavailable
                            </span>

                        <% } else if (quantity > 0) { %>

                            <div class="quantity-control">

                                <button
                                    type="button"
                                    class="quantity-btn"
                                    data-menu-id="<%= menu.getMenuId() %>"
                                    data-action="decrease"
                                    aria-label="Decrease <%= safeName %> quantity">−</button>

                                <span
                                    class="quantity-value"
                                    id="quantity-<%= menu.getMenuId() %>"><%= quantity %></span>

                                <button
                                    type="button"
                                    class="quantity-btn"
                                    data-menu-id="<%= menu.getMenuId() %>"
                                    data-action="increase"
                                    aria-label="Increase <%= safeName %> quantity">+</button>

                            </div>

                        <% } else { %>

                            <button
                                type="button"
                                class="add-button"
                                data-menu-id="<%= menu.getMenuId() %>"
                                data-action="add">＋ Add</button>

                        <% } %>

                    </div>
                </div>

            </article>

        <%
                }
            }

            if (renderedItems == 0) {
        %>

            <div class="empty-menu" id="emptyMenu">
                <h3>No menu items found</h3>
                <p>This restaurant has no menu items to display right now.</p>
            </div>

        <%
            }
        %>

        </div>

        <div class="empty-menu" id="noSearchResults" hidden>
            <h3>No matching dishes</h3>
            <p>Try a different dish name or clear your search.</p>
        </div>

    </section>

</main>

<!-- Cart switch confirmation -->
<div
    class="modal-overlay"
    id="cartSwitchModal"
    role="dialog"
    aria-modal="true"
    aria-labelledby="switchTitle"
    aria-describedby="switchDescription">

    <div class="switch-modal">

        <div class="modal-icon" aria-hidden="true">🛒</div>

        <h2 id="switchTitle">Start a new cart?</h2>

        <p id="switchDescription">
            Your cart contains items from another restaurant.
            If you continue, the existing cart will be cleared and
            the selected dish will be added to a new cart.
        </p>

        <div class="cart-switch-actions">

            <button
                type="button"
                class="cart-switch-cancel"
                id="cancelRestaurantSwitch">
                Cancel
            </button>

            <button
                type="button"
                class="cart-switch-confirm"
                id="confirmRestaurantSwitch">
                OK, Clear &amp; Continue
            </button>

        </div>
    </div>
</div>

<script>
"use strict";

const contextPath = "<%= cp %>";

const menuSearch = document.getElementById("menuSearch");
const menuItems = Array.from(document.querySelectorAll(".menu-item"));
const noSearchResults = document.getElementById("noSearchResults");
const feedback = document.getElementById("feedback");
const cartSwitchModal = document.getElementById("cartSwitchModal");

const confirmRestaurantSwitch =
    document.getElementById("confirmRestaurantSwitch");

const cancelRestaurantSwitch =
    document.getElementById("cancelRestaurantSwitch");

const viewCartCount = document.getElementById("viewCartCount");

/*
 * Update a cart badge in the shared navbar if one exists.
 * Supports either ID used by existing FoodieHub navbar versions.
 */
const cartCountElement =
    document.getElementById("cartCount") ||
    document.getElementById("navbarCartCount");

const cartQueues = Object.create(null);

let pendingRestaurantSwitch = null;
let feedbackTimer = null;

function showFeedback(message, isError) {
    if (!feedback) return;

    feedback.textContent = message;
    feedback.classList.toggle("error", Boolean(isError));
    feedback.classList.add("show");

    if (feedbackTimer) {
        clearTimeout(feedbackTimer);
    }

    feedbackTimer = setTimeout(function () {
        feedback.classList.remove("show");
    }, 3000);
}

function updateCartBadges(count) {
    if (count === undefined || count === null) return;

    if (viewCartCount) {
        viewCartCount.textContent = String(count);
    }

    if (cartCountElement) {
        cartCountElement.textContent = String(count);
    }
}

function filterMenu() {
    const query = menuSearch.value.trim().toLocaleLowerCase();
    let visibleCount = 0;

    menuItems.forEach(function (item) {
        const text = item.dataset.search || "";
        const matches = text.includes(query);

        item.hidden = !matches;

        if (matches) {
            visibleCount++;
        }
    });

    noSearchResults.hidden = !(query.length > 0 && visibleCount === 0);
}

menuSearch.addEventListener("input", filterMenu);

menuSearch.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        menuSearch.value = "";
        filterMenu();
    }
});

/*
 * Keep requests for each menu item in order so quick clicks
 * do not send conflicting quantity changes.
 */
function queueCartRequest(menuId, action) {
    if (!cartQueues[menuId]) {
        cartQueues[menuId] = Promise.resolve();
    }

    cartQueues[menuId] = cartQueues[menuId]
        .catch(function () {})
        .then(function () {
            return sendCartRequest(menuId, action);
        });

    return cartQueues[menuId];
}

async function sendCartRequest(menuId, action) {
    const body = new URLSearchParams();

    body.append("menuId", String(menuId));
    body.append("action", action || "add");

    try {
        const response = await fetch(contextPath + "/cart", {
            method: "POST",
            headers: {
                "Content-Type":
                    "application/x-www-form-urlencoded;charset=UTF-8",
                "X-Requested-With": "XMLHttpRequest"
            },
            body: body.toString(),
            credentials: "same-origin"
        });

        const responseText = await response.text();

        if (!response.ok) {
            throw new Error(
                "Cart request failed (HTTP " + response.status + ")."
            );
        }

        let data;

        try {
            data = JSON.parse(responseText);
        } catch (error) {
            console.error(
                "Unexpected CartController response:",
                responseText
            );

            throw new Error(
                "CartController did not return JSON. Check CartController.java."
            );
        }

        if (data.requiresConfirmation === true) {
            return {
                success: false,
                requiresConfirmation: true
            };
        }

        if (data.success === false) {
            throw new Error(data.message || "Unable to update the cart.");
        }

        const count = data.itemCount !== undefined
            ? data.itemCount
            : data.cartCount;

        updateCartBadges(count);

        return {
            success: true,
            quantity: Number(data.quantity),
            itemCount: count,
            message: data.message
        };

    } catch (error) {
        console.error(error);

        showFeedback(
            error.message || "Unable to update the cart.",
            true
        );

        return { success: false };
    }
}

function renderQuantity(container, menuId, quantity) {
    container.replaceChildren();

    const control = document.createElement("div");
    control.className = "quantity-control";

    const minus = document.createElement("button");
    minus.type = "button";
    minus.className = "quantity-btn";
    minus.dataset.menuId = menuId;
    minus.dataset.action = "decrease";
    minus.textContent = "−";
    minus.setAttribute("aria-label", "Decrease quantity");

    const value = document.createElement("span");
    value.className = "quantity-value";
    value.id = "quantity-" + menuId;
    value.textContent = String(quantity);

    const plus = document.createElement("button");
    plus.type = "button";
    plus.className = "quantity-btn";
    plus.dataset.menuId = menuId;
    plus.dataset.action = "increase";
    plus.textContent = "+";
    plus.setAttribute("aria-label", "Increase quantity");

    control.append(minus, value, plus);
    container.appendChild(control);
}

function renderAddButton(container, menuId) {
    container.replaceChildren();

    const button = document.createElement("button");
    button.type = "button";
    button.className = "add-button";
    button.dataset.menuId = menuId;
    button.dataset.action = "add";
    button.textContent = "＋ Add";

    container.appendChild(button);
}

async function updateCart(menuId, action, button) {
    const container = document.getElementById("cart-control-" + menuId);

    if (!container) return;

    button.disabled = true;

    const result = await queueCartRequest(menuId, action);

    if (result.requiresConfirmation) {
        pendingRestaurantSwitch = {
            menuId: menuId,
            originalAction: action
        };

        openRestaurantSwitchModal();
        button.disabled = false;
        return;
    }

    if (!result.success) {
        button.disabled = false;
        return;
    }

    if (action === "add" || action === "increase") {
        const quantity =
            Number.isFinite(result.quantity) && result.quantity > 0
                ? result.quantity
                : 1;

        renderQuantity(container, menuId, quantity);

        showFeedback(
            action === "add"
                ? "Added to your cart."
                : "Quantity updated.",
            false
        );

        return;
    }

    if (action === "decrease") {
        if (!Number.isFinite(result.quantity) || result.quantity <= 0) {
            renderAddButton(container, menuId);
            showFeedback("Item removed from your cart.", false);
            return;
        }

        const value = document.getElementById("quantity-" + menuId);

        if (value) {
            value.textContent = String(result.quantity);
        }

        showFeedback("Quantity updated.", false);
    }
}

document.addEventListener("click", function (event) {
    const button = event.target.closest(".add-button, .quantity-btn");

    if (!button || button.disabled) return;

    const menuId = button.dataset.menuId;
    const action = button.dataset.action;

    if (!menuId || !action) return;

    updateCart(menuId, action, button);
});

function openRestaurantSwitchModal() {
    if (!cartSwitchModal) return;

    cartSwitchModal.classList.add("show");

    if (confirmRestaurantSwitch) {
        confirmRestaurantSwitch.focus();
    }
}

function closeRestaurantSwitchModal() {
    if (!cartSwitchModal) return;

    cartSwitchModal.classList.remove("show");
    pendingRestaurantSwitch = null;
}

function cancelRestaurantSwitchAction() {
    closeRestaurantSwitchModal();

    showFeedback(
        "Your existing cart was kept. The new item was not added.",
        false
    );
}

cancelRestaurantSwitch.addEventListener(
    "click",
    cancelRestaurantSwitchAction
);

cartSwitchModal.addEventListener("click", function (event) {
    if (event.target === cartSwitchModal) {
        cancelRestaurantSwitchAction();
    }
});

document.addEventListener("keydown", function (event) {
    if (
        event.key === "Escape" &&
        cartSwitchModal.classList.contains("show")
    ) {
        cancelRestaurantSwitchAction();
    }
});

/*
 * CartController must support:
 * action=confirmSwitch
 *
 * It should clear the old restaurant cart and add the selected item
 * only after the user confirms the switch.
 */
confirmRestaurantSwitch.addEventListener("click", async function () {
    if (!pendingRestaurantSwitch) return;

    const requestedMenuId = pendingRestaurantSwitch.menuId;

    confirmRestaurantSwitch.disabled = true;
    cancelRestaurantSwitch.disabled = true;

    const result = await sendCartRequest(requestedMenuId, "confirmSwitch");

    confirmRestaurantSwitch.disabled = false;
    cancelRestaurantSwitch.disabled = false;

    if (result.success) {
        closeRestaurantSwitchModal();

        const container = document.getElementById(
            "cart-control-" + requestedMenuId
        );

        if (container) {
            const quantity =
                Number.isFinite(result.quantity) && result.quantity > 0
                    ? result.quantity
                    : 1;

            renderQuantity(container, requestedMenuId, quantity);
        }

        showFeedback(
            "Your old cart was cleared and the selected item was added.",
            false
        );
    }
});

filterMenu();
</script>

</body>
</html>