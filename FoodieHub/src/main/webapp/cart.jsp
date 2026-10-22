<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.daoimpl.RestaurantDaoImpl" %>
<%
    String cp = request.getContextPath();
    Cart cart = (Cart) session.getAttribute("cart");
    Restaurant restaurant = null;
    Collection<CartItem> cartItems = null;
    double totalAmount = 0.0;
    int itemCount = 0;
    String restaurantName = "Your Restaurant";

    if (cart != null && !cart.isEmpty()) {
        try {
            RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();
            restaurant = restaurantDao.getRestaurant(cart.getRestaurantId());
            if (restaurant != null && restaurant.getName() != null
                    && !restaurant.getName().trim().isEmpty()) {
                restaurantName = restaurant.getName();
            }
        } catch (Exception ignored) {
            restaurantName = "Your Restaurant";
        }
        cartItems = cart.getItems();
        totalAmount = cart.getTotalAmount();
        itemCount = cart.getItemCount();
    }

    String safeRestaurantName = restaurantName
        .replace("&", "&amp;").replace("<", "&lt;")
        .replace(">", "&gt;").replace("\"", "&quot;")
        .replace("'", "&#39;");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Your Cart | FoodieHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap" rel="stylesheet">
<style>
:root{--bg:#001a12;--panel:#05291e;--panel2:#073525;--green:#00ed83;--bright:#69ffac;--text:#f4fff8;--muted:#9bb8a8;--border:rgba(105,255,172,.17);--red:#ff6268;--gold:#ffd166}
*{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{min-height:100vh;background:radial-gradient(ellipse at 85% 0%,rgba(0,237,131,.10),transparent 32%),radial-gradient(ellipse at 0% 80%,rgba(0,100,65,.13),transparent 30%),var(--bg);color:var(--text);font-family:'DM Sans',Arial,sans-serif;overflow-x:hidden}
a{color:inherit;text-decoration:none}button{font:inherit;cursor:pointer}
.cart-page{width:min(1240px,92%);margin:34px auto 70px}
.cart-heading{display:flex;align-items:center;justify-content:space-between;gap:20px;margin-bottom:25px}
.heading-left{display:flex;align-items:center;gap:15px}
.heading-icon{width:52px;height:52px;display:grid;place-items:center;border:1px solid rgba(0,237,131,.55);border-radius:15px;background:rgba(0,237,131,.08);color:var(--green);font-size:25px;box-shadow:0 0 22px rgba(0,237,131,.07)}
.cart-heading h1{font-size:clamp(27px,3vw,36px);line-height:1.15;font-weight:800;letter-spacing:-.8px}
.cart-heading p{margin-top:5px;color:var(--muted);font-size:13px}
.clear-cart-top{border:1px solid rgba(255,98,104,.45);border-radius:10px;padding:10px 14px;background:rgba(255,98,104,.07);color:#ff9296;font-size:12px;font-weight:800;transition:.2s}
.clear-cart-top:hover{background:rgba(255,98,104,.16);transform:translateY(-2px)}
.cart-layout{display:grid;grid-template-columns:minmax(0,1.7fr) minmax(285px,.85fr);align-items:start;gap:22px}
.cart-main{min-width:0}
.restaurant-strip{display:flex;align-items:center;gap:12px;padding:14px 16px;margin-bottom:15px;border:1px solid var(--border);border-radius:14px;background:linear-gradient(110deg,rgba(0,237,131,.09),rgba(5,41,30,.85))}
.restaurant-icon{width:39px;height:39px;display:grid;place-items:center;flex-shrink:0;border-radius:11px;background:rgba(0,237,131,.12);color:var(--green);font-size:19px}
.restaurant-strip small{display:block;color:var(--muted);font-size:10px;text-transform:uppercase;letter-spacing:1.5px;margin-bottom:3px;font-weight:800}
.restaurant-strip h2{font-size:16px;font-weight:800}
.restaurant-strip .restaurant-tag{margin-left:auto;color:var(--bright);font-size:11px;white-space:nowrap}
.cart-items{display:grid;gap:13px}
.cart-item{display:grid;grid-template-columns:90px minmax(0,1fr) auto;align-items:center;gap:15px;padding:14px;border:1px solid var(--border);border-radius:16px;background:linear-gradient(140deg,rgba(7,53,37,.96),rgba(3,34,25,.98));transition:border-color .2s,transform .2s,box-shadow .2s;animation:rise .35s both}
.cart-item:hover{border-color:rgba(0,237,131,.42);box-shadow:0 10px 28px rgba(0,0,0,.15);transform:translateY(-2px)}
.item-image{width:90px;height:82px;display:block;object-fit:cover;border-radius:12px;background:#0a3b2b;border:1px solid rgba(255,255,255,.06)}
.item-info{min-width:0}
.item-info h3{font-size:15px;line-height:1.35;font-weight:800;overflow-wrap:anywhere}
.item-restaurant{margin-top:4px;color:var(--muted);font-size:11px}
.item-unit-price{margin-top:8px;color:var(--muted);font-size:11px}
.item-unit-price strong{color:var(--bright);font-size:13px}
.item-actions{display:flex;flex-direction:column;align-items:flex-end;gap:12px}
.item-line-total{font-size:15px;font-weight:800;color:var(--bright);white-space:nowrap}
.quantity-control{display:flex;align-items:center;gap:10px;padding:4px;border:1px solid rgba(0,237,131,.55);border-radius:10px;background:rgba(0,237,131,.06)}
.quantity-btn{width:27px;height:27px;display:grid;place-items:center;border:0;border-radius:7px;background:var(--green);color:#00351e;font-size:18px;font-weight:800;line-height:1}
.quantity-btn:disabled{opacity:.55;cursor:wait}
.quantity-value{min-width:15px;text-align:center;font-size:13px;font-weight:800}
.remove-btn{border:0;background:transparent;color:#ff858a;font-size:11px;font-weight:700;padding:3px 0}
.remove-btn:hover{color:#ffb4b7;text-decoration:underline}
.summary-box{position:sticky;top:22px;padding:20px;border:1px solid var(--border);border-radius:17px;background:linear-gradient(145deg,#073525,#031f17);box-shadow:0 18px 48px rgba(0,0,0,.18)}
.summary-heading{display:flex;align-items:center;gap:10px;padding-bottom:15px;border-bottom:1px solid var(--border)}
.summary-icon{width:34px;height:34px;display:grid;place-items:center;border-radius:10px;color:var(--gold);background:rgba(255,209,102,.09);border:1px solid rgba(255,209,102,.25)}
.summary-heading h2{font-size:17px;font-weight:800}
.summary-row{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-top:15px;color:var(--muted);font-size:12px}
.summary-row strong{color:var(--text);font-size:12px;font-weight:700;text-align:right}
.summary-divider{height:1px;background:var(--border);margin:18px 0}
.total-row{display:flex;align-items:center;justify-content:space-between;gap:12px}
.total-label{font-size:14px;font-weight:800}
.total-amount{color:var(--bright);font-size:23px;font-weight:800;white-space:nowrap}
.checkout-btn{display:flex;align-items:center;justify-content:center;gap:10px;width:100%;min-height:47px;margin-top:20px;padding:0 14px;border:1px solid rgba(255,255,255,.18);border-radius:11px;background:linear-gradient(100deg,#00e980,#70ff9d);color:#00351e;font-size:13px;font-weight:800;box-shadow:0 7px 20px rgba(0,237,131,.17);transition:transform .2s,box-shadow .2s}
.checkout-btn:hover{transform:translateY(-2px);box-shadow:0 10px 26px rgba(0,237,131,.24)}
.continue-link{display:block;text-align:center;margin-top:15px;color:var(--muted);font-size:12px;font-weight:700}
.continue-link:hover{color:var(--green)}
.empty-state{max-width:650px;margin:30px auto 0;padding:54px 24px;text-align:center;border:1px solid var(--border);border-radius:22px;background:linear-gradient(145deg,#073525,#031f17);box-shadow:0 20px 55px rgba(0,0,0,.2)}
.empty-icon{width:78px;height:78px;display:grid;place-items:center;margin:0 auto 20px;border-radius:22px;border:1px solid rgba(0,237,131,.35);background:rgba(0,237,131,.08);font-size:35px}
.empty-state h2{font-family:'Playfair Display',Georgia,serif;font-size:30px}
.empty-state p{margin:10px auto 22px;color:var(--muted);font-size:13px;line-height:1.7;max-width:400px}
.primary-link{display:inline-flex;align-items:center;justify-content:center;min-height:44px;padding:0 20px;border-radius:10px;background:var(--green);color:#00351e;font-size:12px;font-weight:800}
.feedback{position:fixed;z-index:10000;top:115px;right:22px;max-width:min(380px,calc(100% - 44px));padding:13px 17px;border:1px solid var(--border);border-radius:12px;color:var(--text);background:#073525;box-shadow:0 12px 30px rgba(0,0,0,.35);opacity:0;pointer-events:none;transform:translateY(-8px);transition:opacity .2s,transform .2s;font-size:13px}
.feedback.show{opacity:1;transform:translateY(0)}.feedback.error{border-color:rgba(255,98,104,.65)}
.loading{opacity:.65;pointer-events:none}
@keyframes rise{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
@media(max-width:900px){.cart-layout{grid-template-columns:minmax(0,1.35fr) minmax(260px,.85fr);gap:15px}.cart-item{grid-template-columns:76px minmax(0,1fr) auto;gap:12px;padding:12px}.item-image{width:76px;height:76px}.summary-box{padding:17px}}
@media(max-width:680px){.cart-page{width:94%;margin:25px auto 55px}.cart-layout{grid-template-columns:1fr}.summary-box{position:static;grid-row:1}.cart-main{grid-row:2}.cart-heading{align-items:flex-start}.heading-icon{width:45px;height:45px}.cart-heading h1{font-size:27px}.clear-cart-top{padding:9px 10px;font-size:11px}.cart-item{grid-template-columns:72px minmax(0,1fr);align-items:start}.item-image{width:72px;height:72px;grid-row:1 / 3}.item-info{grid-column:2}.item-actions{grid-column:2;flex-direction:row;align-items:center;justify-content:space-between;width:100%;margin-top:1px}.item-line-total{font-size:14px}.restaurant-strip .restaurant-tag{font-size:10px}}
@media(max-width:380px){.cart-heading{gap:10px}.heading-left{gap:10px}.cart-heading h1{font-size:23px}.cart-heading p{font-size:11px}.clear-cart-top{padding:8px}.quantity-control{gap:7px}.item-info h3{font-size:13px}}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.01ms!important;transition-duration:.01ms!important;scroll-behavior:auto!important}}

/* FoodieHub branded clear-cart confirmation modal */
.confirm-overlay{position:fixed;inset:0;z-index:20000;display:flex;align-items:center;justify-content:center;padding:20px;background:rgba(0,10,7,.78);backdrop-filter:blur(9px);-webkit-backdrop-filter:blur(9px);opacity:0;visibility:hidden;pointer-events:none;transition:opacity .22s ease,visibility .22s ease}
.confirm-overlay.is-open{opacity:1;visibility:visible;pointer-events:auto}
.confirm-dialog{position:relative;width:min(440px,100%);overflow:hidden;padding:30px;border:1px solid rgba(105,255,172,.25);border-radius:24px;background:radial-gradient(ellipse at 50% 0%,rgba(0,237,131,.13),transparent 48%),linear-gradient(145deg,#073525,#021b13 75%);box-shadow:0 30px 90px rgba(0,0,0,.58),0 0 38px rgba(0,237,131,.08);transform:translateY(14px) scale(.97);transition:transform .22s ease}
.confirm-overlay.is-open .confirm-dialog{transform:translateY(0) scale(1)}
.confirm-close{position:absolute;top:14px;right:14px;width:34px;height:34px;display:grid;place-items:center;border:1px solid rgba(255,255,255,.10);border-radius:10px;color:var(--muted);background:rgba(255,255,255,.035);font-size:20px;transition:.2s}
.confirm-close:hover{color:var(--text);border-color:var(--border);background:rgba(255,255,255,.08)}
.confirm-symbol{width:66px;height:66px;display:grid;place-items:center;margin-bottom:20px;border:1px solid rgba(255,98,104,.35);border-radius:20px;color:#ff858a;background:linear-gradient(145deg,rgba(255,98,104,.16),rgba(255,98,104,.04));box-shadow:0 0 30px rgba(255,98,104,.08);font-size:29px}
.confirm-eyebrow{margin-bottom:8px;color:var(--green);font-size:10px;font-weight:800;letter-spacing:2.4px;text-transform:uppercase}
.confirm-dialog h2{margin:0;color:var(--text);font-family:'Playfair Display',Georgia,serif;font-size:29px;line-height:1.2;letter-spacing:-.35px}
.confirm-dialog p{margin-top:12px;color:var(--muted);font-size:13px;line-height:1.75}
.confirm-note{display:flex;align-items:flex-start;gap:10px;margin-top:20px;padding:12px 13px;border:1px solid rgba(255,209,102,.17);border-radius:12px;background:rgba(255,209,102,.045);color:#d8cda8;font-size:11px;line-height:1.6}
.confirm-note span{color:var(--gold);font-size:15px;line-height:1.2}
.confirm-actions{display:flex;gap:10px;margin-top:24px}
.confirm-actions button{display:inline-flex;align-items:center;justify-content:center;gap:8px;min-height:46px;padding:0 15px;border-radius:12px;font-size:12px;font-weight:800;transition:transform .18s,background .18s,box-shadow .18s}
.confirm-keep{flex:1;border:1px solid rgba(105,255,172,.25);color:var(--text);background:rgba(105,255,172,.055)}
.confirm-keep:hover{background:rgba(105,255,172,.12);transform:translateY(-1px)}
.confirm-clear{flex:1;border:1px solid rgba(255,98,104,.55);color:#fff;background:linear-gradient(100deg,#d9434d,#ff6268);box-shadow:0 7px 20px rgba(255,98,104,.13)}
.confirm-clear:hover{transform:translateY(-1px);background:linear-gradient(100deg,#e94b55,#ff7b80);box-shadow:0 10px 25px rgba(255,98,104,.2)}
.confirm-actions button:disabled{opacity:.6;cursor:wait;transform:none}
body.modal-open{overflow:hidden}
@media(max-width:480px){.confirm-dialog{padding:25px 21px;border-radius:21px}.confirm-dialog h2{font-size:25px}.confirm-symbol{width:58px;height:58px;margin-bottom:17px}.confirm-actions{flex-direction:column-reverse}.confirm-actions button{width:100%}}
@media(prefers-reduced-motion:reduce){.confirm-overlay,.confirm-dialog{transition:none}}

</style>
</head>
<body>

<%@ include file="components/navbar.jsp" %>
<div class="feedback" id="feedback" role="status" aria-live="polite"></div>

<main class="cart-page">
    <header class="cart-heading">
        <div class="heading-left">
            <div class="heading-icon" aria-hidden="true">▣</div>
            <div>
                <h1>Your Cart</h1>
                <p>Review your items before checkout</p>
            </div>
        </div>
        <% if (cart != null && !cart.isEmpty()) { %>
        <button type="button" class="clear-cart-top" id="clearCartButton">▣ &nbsp;Clear Cart</button>
        <% } %>
    </header>

    <% if (cart == null || cart.isEmpty() || cartItems == null || cartItems.isEmpty()) { %>
        <section class="empty-state" id="emptyState">
            <div class="empty-icon" aria-hidden="true">🛒</div>
            <h2>Your cart is empty</h2>
            <p>Your next favourite meal is waiting. Explore restaurants and add something delicious to your cart.</p>
            <a class="primary-link" href="<%= cp %>/restaurant">Explore Restaurants &nbsp; →</a>
        </section>
    <% } else { %>
        <section class="cart-layout" id="cartLayout">
            <div class="cart-main">
                <div class="restaurant-strip">
                    <div class="restaurant-icon" aria-hidden="true">♨</div>
                    <div>
                        <small>Ordering from</small>
                        <h2 id="restaurantName"><%= safeRestaurantName %></h2>
                    </div>
                    <span class="restaurant-tag">● One restaurant per order</span>
                </div>

                <div class="cart-items" id="cartItems">
                <% for (CartItem item : cartItems) {
                    if (item == null) continue;
                    String itemName = item.getItemName() == null ? "Food item" : item.getItemName();
                    String safeItemName = itemName.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace("\"", "&quot;").replace("'", "&#39;");
                    String imagePath = item.getImagePath() == null ? "" : item.getImagePath().trim();
                    String safeImagePath = imagePath.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
                    int quantity = item.getQuantity();
                    double price = item.getPrice();
                    double lineTotal = price * quantity;
                    String placeholder = "https://placehold.co/180x160/073a28/eafff0?text=Food";
                %>
                    <article class="cart-item" id="cart-item-<%= item.getMenuId() %>"
                             data-menu-id="<%= item.getMenuId() %>"
                             data-price="<%= String.format(Locale.US, "%.2f", price) %>">
                        <img class="item-image"
                             src="<%= safeImagePath.isEmpty() ? placeholder : safeImagePath %>"
                             alt="<%= safeItemName %>" loading="lazy"
                             onerror="this.onerror=null;this.src='https://placehold.co/180x160/073a28/eafff0?text=Food';">
                        <div class="item-info">
                            <h3><%= safeItemName %></h3>
                            <p class="item-restaurant"><%= safeRestaurantName %></p>
                            <p class="item-unit-price">Price: <strong>₹<%= String.format(Locale.US, "%.2f", price) %></strong></p>
                        </div>
                        <div class="item-actions">
                            <div class="item-line-total" id="line-total-<%= item.getMenuId() %>">₹<%= String.format(Locale.US, "%.2f", lineTotal) %></div>
                            <div class="quantity-control" aria-label="Quantity controls">
                                <button type="button" class="quantity-btn" data-action="decrease" data-menu-id="<%= item.getMenuId() %>" aria-label="Decrease <%= safeItemName %> quantity">−</button>
                                <span class="quantity-value" id="quantity-<%= item.getMenuId() %>"><%= quantity %></span>
                                <button type="button" class="quantity-btn" data-action="increase" data-menu-id="<%= item.getMenuId() %>" aria-label="Increase <%= safeItemName %> quantity">+</button>
                            </div>
                            <button type="button" class="remove-btn" data-action="remove" data-menu-id="<%= item.getMenuId() %>">✕ Remove</button>
                        </div>
                    </article>
                <% } %>
                </div>
            </div>

            <aside class="summary-box" id="summaryBox">
                <div class="summary-heading">
                    <div class="summary-icon" aria-hidden="true">▤</div>
                    <h2>Order Summary</h2>
                </div>
                <div class="summary-row"><span>Items (<span id="summary-item-count"><%= itemCount %></span>)</span><strong id="summary-items-amount">₹<%= String.format(Locale.US, "%.2f", totalAmount) %></strong></div>
                <div class="summary-row"><span>Delivery Fee</span><strong class="delivery-value">₹30.00</strong></div>
                <div class="summary-row"><span>Platform Fee</span><strong>₹10.00</strong></div>
                <div class="summary-divider"></div>
                <div class="total-row"><span class="total-label">Total Amount</span><span class="total-amount" id="cart-total">₹<%= String.format(Locale.US, "%.2f", totalAmount + 40.0) %></span></div>
                <a href="<%= cp %>/checkout.jsp" class="checkout-btn" id="checkoutButton">Proceed to Checkout <span aria-hidden="true">→</span></a>
                <a href="<%= cp %>/restaurant" class="continue-link">← Continue ordering</a>
            </aside>
        </section>
    <% } %>
</main>


<div class="confirm-overlay" id="clearCartModal" aria-hidden="true">
    <section class="confirm-dialog" role="dialog" aria-modal="true" aria-labelledby="clearCartTitle" aria-describedby="clearCartDescription" tabindex="-1">
        <button type="button" class="confirm-close" id="closeClearCartModal" aria-label="Close confirmation">×</button>
        <div class="confirm-symbol" aria-hidden="true">⌫</div>
        <div class="confirm-eyebrow">FOODIEHUB · CART ACTION</div>
        <h2 id="clearCartTitle">Clear your cart?</h2>
        <p id="clearCartDescription">You’re about to remove every item from your cart. Your delicious picks will be gone, but you can always add them again.</p>
        <div class="confirm-note"><span aria-hidden="true">✦</span><span>This action clears all items from this order. Nothing will be removed unless you confirm.</span></div>
        <div class="confirm-actions">
            <button type="button" class="confirm-keep" id="keepCartButton">Keep My Cart</button>
            <button type="button" class="confirm-clear" id="confirmClearCartButton"><span aria-hidden="true">⌫</span> Clear Cart</button>
        </div>
    </section>
</div>

<script>
'use strict';
const contextPath = '<%= cp %>';
const feedback = document.getElementById('feedback');
let feedbackTimer = null;
let cartRequestRunning = false;

function showFeedback(message, isError) {
    feedback.textContent = message;
    feedback.classList.toggle('error', Boolean(isError));
    feedback.classList.add('show');
    if (feedbackTimer) clearTimeout(feedbackTimer);
    feedbackTimer = setTimeout(() => feedback.classList.remove('show'), 2800);
}

function money(value) {
    return '₹' + Number(value || 0).toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
    });
}

function visibleItemCount() {
    let count = 0;
    document.querySelectorAll('#cartItems .cart-item').forEach(function(row) {
        const quantity = row.querySelector('.quantity-value');
        count += quantity ? Math.max(0, Number(quantity.textContent) || 0) : 0;
    });
    return count;
}

function updateSummary(total) {
    const count = visibleItemCount();
    const itemsAmount = Number(total || 0);
    const delivery = count > 0 ? 30 : 0;
    const platform = count > 0 ? 10 : 0;
    const countElement = document.getElementById('summary-item-count');
    const itemsAmountElement = document.getElementById('summary-items-amount');
    const totalElement = document.getElementById('cart-total');
    if (countElement) countElement.textContent = String(count);
    if (itemsAmountElement) itemsAmountElement.textContent = money(itemsAmount);
    if (totalElement) totalElement.textContent = money(itemsAmount + delivery + platform);
}

function showEmptyCart() {
    const layout = document.getElementById('cartLayout');
    if (layout) layout.remove();
    const clearButton = document.getElementById('clearCartButton');
    if (clearButton) clearButton.remove();

    if (!document.getElementById('emptyState')) {
        const empty = document.createElement('section');
        empty.className = 'empty-state';
        empty.id = 'emptyState';
        empty.innerHTML = '<div class="empty-icon" aria-hidden="true">🛒</div>' +
            '<h2>Your cart is empty</h2>' +
            '<p>Your next favourite meal is waiting. Explore restaurants and add something delicious to your cart.</p>' +
            '<a class="primary-link" href="' + contextPath + '/restaurant">Explore Restaurants &nbsp; →</a>';
        document.querySelector('.cart-page').appendChild(empty);
    }
}

async function sendCartAction(menuId, action) {
    if (cartRequestRunning) return;
    cartRequestRunning = true;
    const row = menuId ? document.getElementById('cart-item-' + menuId) : null;
    if (row) row.classList.add('loading');
    const clearButton = document.getElementById('clearCartButton');
    if (action === 'clear' && clearButton) clearButton.disabled = true;

    try {
        const body = new URLSearchParams();
        body.append('action', action);
        if (menuId !== null && menuId !== undefined) body.append('menuId', String(menuId));

        const response = await fetch(contextPath + '/cart', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: body.toString(),
            credentials: 'same-origin'
        });

        const text = await response.text();
        if (!response.ok) throw new Error('Cart update failed. Please try again.');
        let data;
        try { data = JSON.parse(text); }
        catch (e) { throw new Error('CartController did not return JSON. Check CartController.java.'); }
        if (data.success === false) throw new Error(data.message || 'Unable to update the cart.');

        if (action === 'clear' || data.empty === true) {
            showEmptyCart();
            showFeedback('Your cart has been cleared.', false);
            return;
        }

        if (action === 'remove' || (action === 'decrease' && Number(data.quantity) <= 0)) {
            if (row) row.remove();
        } else if (row && data.quantity !== undefined) {
            const quantity = document.getElementById('quantity-' + menuId);
            if (quantity) quantity.textContent = String(data.quantity);
            const price = Number(row.dataset.price || 0);
            const lineTotal = document.getElementById('line-total-' + menuId);
            if (lineTotal) lineTotal.textContent = money(price * Number(data.quantity));
        }

        if (visibleItemCount() === 0 || data.empty === true) {
            showEmptyCart();
        } else {
            updateSummary(data.totalAmount);
            showFeedback(action === 'remove' ? 'Item removed from your cart.' : 'Cart updated successfully.', false);
        }
    } catch (error) {
        console.error(error);
        showFeedback(error.message || 'Unable to update your cart.', true);
        if (row) row.classList.remove('loading');
    } finally {
        // Always restore interaction after the request completes.
        // The loading class disables pointer events, so it must be
        // removed after BOTH successful and failed requests.
        if (row && document.body.contains(row)) row.classList.remove('loading');
        cartRequestRunning = false;
        if (clearButton && document.body.contains(clearButton)) clearButton.disabled = false;
    }
}

document.addEventListener('click', function(event) {
    const button = event.target.closest('[data-action][data-menu-id]');
    if (!button) return;
    const action = button.dataset.action;
    const menuId = button.dataset.menuId;
    if (!['increase', 'decrease', 'remove'].includes(action)) return;
    sendCartAction(menuId, action);
});

const clearCartButton = document.getElementById('clearCartButton');
const clearCartModal = document.getElementById('clearCartModal');
const clearCartDialog = clearCartModal ? clearCartModal.querySelector('.confirm-dialog') : null;
const keepCartButton = document.getElementById('keepCartButton');
const closeClearCartModal = document.getElementById('closeClearCartModal');
const confirmClearCartButton = document.getElementById('confirmClearCartButton');
let lastFocusedElement = null;

function openClearCartModal() {
    if (!clearCartModal) return;
    lastFocusedElement = document.activeElement;
    clearCartModal.classList.add('is-open');
    clearCartModal.setAttribute('aria-hidden', 'false');
    document.body.classList.add('modal-open');
    window.setTimeout(function() {
        if (keepCartButton) keepCartButton.focus();
    }, 30);
}

function closeClearCartConfirmation() {
    if (!clearCartModal) return;
    clearCartModal.classList.remove('is-open');
    clearCartModal.setAttribute('aria-hidden', 'true');
    document.body.classList.remove('modal-open');
    if (lastFocusedElement && document.contains(lastFocusedElement)) {
        lastFocusedElement.focus();
    }
}

if (clearCartButton) {
    clearCartButton.addEventListener('click', openClearCartModal);
}
if (keepCartButton) {
    keepCartButton.addEventListener('click', closeClearCartConfirmation);
}
if (closeClearCartModal) {
    closeClearCartModal.addEventListener('click', closeClearCartConfirmation);
}
if (clearCartModal) {
    clearCartModal.addEventListener('click', function(event) {
        if (event.target === clearCartModal) closeClearCartConfirmation();
    });
}
document.addEventListener('keydown', function(event) {
    if (!clearCartModal || !clearCartModal.classList.contains('is-open')) return;
    if (event.key === 'Escape') {
        event.preventDefault();
        closeClearCartConfirmation();
    }
    if (event.key === 'Tab' && clearCartDialog) {
        const focusable = Array.from(clearCartDialog.querySelectorAll('button:not(:disabled)'));
        if (!focusable.length) return;
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        if (event.shiftKey && document.activeElement === first) {
            event.preventDefault();
            last.focus();
        } else if (!event.shiftKey && document.activeElement === last) {
            event.preventDefault();
            first.focus();
        }
    }
});
if (confirmClearCartButton) {
    confirmClearCartButton.addEventListener('click', async function() {
        confirmClearCartButton.disabled = true;
        keepCartButton.disabled = true;
        try {
            closeClearCartConfirmation();
            await sendCartAction(null, 'clear');
        } finally {
            if (document.body.contains(confirmClearCartButton)) confirmClearCartButton.disabled = false;
            if (document.body.contains(keepCartButton)) keepCartButton.disabled = false;
        }
    });
}
</script>
</body>
</html>
