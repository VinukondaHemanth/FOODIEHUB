<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.Cart" %>
<%@ page import="com.tap.model.CartItem" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="com.tap.daoimpl.RestaurantDaoImpl" %>
<%
    String cp = request.getContextPath();

    Order placedOrder = (Order) session.getAttribute("placedOrder");
    Cart successCart = (Cart) session.getAttribute("successCart");
    if (successCart == null) {
        successCart = (Cart) session.getAttribute("cart");
    }

    Collection<CartItem> orderedItems = null;
    String restaurantName = "FoodieHub Restaurant";
    int itemCount = 0;
    double itemTotal = 0.0;
    double orderTotal = 0.0;
    String paymentMethod = "Payment method saved with your order";
    String orderStatus = "Confirmed";
    String orderIdText = "FH-" + System.currentTimeMillis();

    if (successCart != null) {
        orderedItems = successCart.getItems();
        itemCount = successCart.getItemCount();
        itemTotal = successCart.getTotalAmount();

        try {
            RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();
            Restaurant restaurant = restaurantDao.getRestaurant(successCart.getRestaurantId());
            if (restaurant != null && restaurant.getName() != null
                    && !restaurant.getName().trim().isEmpty()) {
                restaurantName = restaurant.getName();
            }
        } catch (Exception ignored) {
            // Keep the safe fallback restaurant label if the lookup is unavailable.
        }
    }

    if (placedOrder != null) {
        orderIdText = String.valueOf(placedOrder.getOrderId());
        orderTotal = placedOrder.getTotalAmount();
        if (placedOrder.getPaymentMode() != null && !placedOrder.getPaymentMode().trim().isEmpty()) {
            paymentMethod = placedOrder.getPaymentMode();
        }
        if (placedOrder.getStatus() != null && !placedOrder.getStatus().trim().isEmpty()) {
            orderStatus = placedOrder.getStatus();
        }
    } else {
        orderTotal = itemTotal + 40.00;
    }

    String safeRestaurantName = restaurantName.replace("&","&amp;").replace("<","&lt;")
        .replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
    String safePaymentMethod = paymentMethod.replace("&","&amp;").replace("<","&lt;")
        .replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
    String safeOrderStatus = orderStatus.replace("&","&amp;").replace("<","&lt;")
        .replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Order Confirmed | FoodieHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<style>
:root{--bg:#001a12;--panel:#05291e;--panel2:#073525;--green:#00ed83;--bright:#69ffac;--text:#f4fff8;--muted:#9bb8a8;--border:rgba(105,255,172,.18);--gold:#ffd166}
*{box-sizing:border-box;margin:0;padding:0}
html{scroll-behavior:smooth}
body{min-height:100vh;color:var(--text);font-family:'DM Sans',Arial,sans-serif;background:radial-gradient(ellipse at 78% 0%,rgba(0,237,131,.13),transparent 34%),radial-gradient(ellipse at 0% 78%,rgba(0,100,65,.14),transparent 32%),var(--bg);overflow-x:hidden}
a{color:inherit;text-decoration:none}
.site-header{height:72px;position:sticky;top:0;z-index:20;display:flex;align-items:center;justify-content:space-between;gap:22px;padding:0 clamp(18px,5vw,76px);background:rgba(0,29,20,.97);border-bottom:1px solid rgba(0,237,145,.15);box-shadow:0 8px 28px rgba(0,0,0,.14);backdrop-filter:blur(14px)}
.site-brand{display:flex;align-items:center;gap:10px;white-space:nowrap;font-size:24px;font-weight:800;letter-spacing:-1px}
.site-brand-icon{width:42px;height:42px;display:grid;place-items:center;border-radius:50%;background:linear-gradient(135deg,#ff6b4a,#ff3c2f);font-size:22px}
.site-brand .hub{color:#ff6448}
.site-nav{display:flex;align-items:center;gap:clamp(15px,2.5vw,34px);font-size:13px;font-weight:700;white-space:nowrap}
.site-nav a{color:#ecfff5;transition:color .2s}.site-nav a:hover{color:var(--green)}
.header-right{display:flex;align-items:center;gap:12px}
.header-search{height:34px;width:clamp(125px,15vw,205px);display:flex;align-items:center;gap:7px;padding:0 11px;border:1px solid rgba(0,237,145,.22);border-radius:18px;background:rgba(0,0,0,.18);color:#a9c9b9;font-size:11px}
.cart-link{position:relative;width:42px;height:42px;display:grid;place-items:center;border:1px solid rgba(0,237,145,.24);border-radius:13px;font-size:20px}
.user-pill{display:flex;align-items:center;gap:8px;padding:5px 11px 5px 5px;border:1px solid rgba(0,237,145,.3);border-radius:24px;font-size:12px;font-weight:800;white-space:nowrap}
.user-avatar{width:31px;height:31px;display:grid;place-items:center;border-radius:50%;background:linear-gradient(135deg,#19d981,#087343);border:1px solid rgba(255,255,255,.25)}
.page{width:min(1120px,92%);margin:28px auto 54px}
.success-hero{text-align:center;padding:26px 18px 22px;position:relative;overflow:hidden;border:1px solid rgba(0,237,131,.17);border-radius:22px;background:radial-gradient(ellipse at 50% 0%,rgba(0,237,131,.13),transparent 62%),linear-gradient(145deg,rgba(4,46,32,.88),rgba(1,25,18,.92));}
.success-hero:before,.success-hero:after{content:"";position:absolute;width:180px;height:180px;border-radius:50%;background:rgba(0,237,131,.06);filter:blur(18px);pointer-events:none}
.success-hero:before{left:-85px;top:-95px}.success-hero:after{right:-85px;bottom:-120px}
.success-check{width:62px;height:62px;display:grid;place-items:center;margin:0 auto 12px;border:2px solid #b9ff36;border-radius:50%;background:radial-gradient(circle,#50ff9a,#008b50);color:#fff;font-size:35px;font-weight:800;box-shadow:0 0 0 7px rgba(0,237,131,.08),0 0 28px rgba(0,237,131,.38);animation:pop .65s ease-out both}
@keyframes pop{0%{transform:scale(.65);opacity:0}75%{transform:scale(1.08)}100%{transform:scale(1);opacity:1}}
.success-hero h1{font-size:clamp(25px,3.3vw,36px);font-weight:800;letter-spacing:-.8px}
.success-hero p{margin-top:7px;color:#b8d9c8;font-size:14px}
.delivery-estimate{display:inline-flex;align-items:center;gap:8px;margin-top:14px;padding:8px 13px;border:1px solid rgba(0,237,131,.25);border-radius:999px;background:rgba(0,237,131,.07);color:#caffdf;font-size:12px;font-weight:700}
.delivery-estimate strong{color:var(--bright)}
.order-progress{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));max-width:850px;margin:25px auto 0;position:relative;gap:8px}
.order-progress:before{content:"";position:absolute;top:17px;left:12.5%;right:12.5%;height:2px;background:linear-gradient(90deg,var(--green),rgba(0,237,131,.18))}
.progress-step{position:relative;z-index:1;text-align:center}
.progress-dot{width:36px;height:36px;margin:0 auto 8px;border:2px solid var(--green);border-radius:50%;display:grid;place-items:center;background:#063b29;color:var(--bright);font-size:15px;font-weight:800}
.progress-step.done .progress-dot{background:linear-gradient(135deg,#00ed83,#73ffb0);color:#00341e;box-shadow:0 0 18px rgba(0,237,131,.18)}
.progress-step.done[data-stage="3"] .progress-dot{border-color:#b9ff36;box-shadow:0 0 0 5px rgba(0,237,131,.09),0 0 25px rgba(0,237,131,.55)}
.progress-step.current .progress-dot{box-shadow:0 0 0 5px rgba(0,237,131,.08),0 0 22px rgba(0,237,131,.3)}
.progress-step strong{display:block;font-size:11px}.progress-step small{display:block;margin-top:3px;color:var(--muted);font-size:10px}
.content-grid{display:grid;grid-template-columns:minmax(0,1.35fr) minmax(290px,.8fr);gap:18px;align-items:start;margin-top:20px}
.panel{border:1px solid var(--border);border-radius:17px;background:linear-gradient(145deg,rgba(5,41,30,.97),rgba(2,29,21,.98));box-shadow:0 14px 35px rgba(0,0,0,.12);overflow:hidden}
.panel-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:16px 18px;border-bottom:1px solid rgba(105,255,172,.12)}
.panel-title{display:flex;align-items:center;gap:10px;font-size:16px;font-weight:800}
.panel-icon{width:34px;height:34px;display:grid;place-items:center;border:1px solid rgba(0,237,131,.25);border-radius:10px;background:rgba(0,237,131,.08);color:var(--green);font-size:17px}
.order-number{color:var(--bright);font-size:11px;font-weight:800}
.restaurant-line{display:flex;align-items:center;gap:11px;padding:13px 17px;background:rgba(0,237,131,.035);border-bottom:1px solid rgba(105,255,172,.1)}
.restaurant-mark{width:38px;height:38px;display:grid;place-items:center;border-radius:11px;background:rgba(0,237,131,.12);font-size:19px}
.restaurant-line strong{display:block;font-size:13px}.restaurant-line small{display:block;margin-top:3px;color:var(--muted);font-size:11px}
.items{padding:0 17px}
.item{display:grid;grid-template-columns:60px minmax(0,1fr) auto;align-items:center;gap:11px;padding:13px 0;border-bottom:1px solid rgba(105,255,172,.12)}
.item:last-child{border-bottom:0}
.item-image{width:60px;height:60px;object-fit:cover;border-radius:12px;border:1px solid rgba(105,255,172,.14);background:#073525}
.item-image-fallback{width:60px;height:60px;display:grid;place-items:center;border-radius:12px;background:linear-gradient(135deg,#164d35,#09291d);font-size:25px}
.item-name{font-size:13px;font-weight:800}.item-meta{margin-top:4px;color:var(--muted);font-size:11px}
.item-price{text-align:right;white-space:nowrap;font-size:12px;font-weight:800;color:#dffff0}
.item-price small{display:block;margin-top:4px;color:var(--muted);font-size:10px;font-weight:500}
.empty-items{padding:22px 18px;color:var(--muted);font-size:13px;line-height:1.6}
.summary-body{padding:17px 18px}
.summary-row{display:flex;justify-content:space-between;gap:15px;margin-bottom:13px;color:#b5d2c2;font-size:12px}
.summary-row strong{color:#edfff5;font-weight:700;white-space:nowrap}
.summary-divider{height:1px;background:rgba(105,255,172,.15);margin:16px 0}
.total-row{display:flex;justify-content:space-between;align-items:center;gap:10px;font-size:14px;font-weight:800}
.total-row strong{color:var(--bright);font-size:23px;white-space:nowrap}
.method-box{margin-top:18px;padding:13px;border:1px solid rgba(0,237,131,.17);border-radius:12px;background:rgba(0,237,131,.045)}
.method-box small{display:block;color:var(--muted);font-size:10px;text-transform:uppercase;letter-spacing:1.2px}
.method-box strong{display:block;margin-top:5px;font-size:12px}
.status-pill{display:inline-flex;align-items:center;gap:6px;padding:6px 9px;border-radius:999px;background:rgba(0,237,131,.1);color:var(--bright);font-size:10px;font-weight:800}
.actions{display:flex;flex-direction:column;gap:9px;margin-top:17px}
.btn{min-height:43px;display:flex;align-items:center;justify-content:center;gap:8px;padding:0 15px;border-radius:11px;font-size:12px;font-weight:800;transition:transform .2s,filter .2s}
.btn:hover{transform:translateY(-2px);filter:brightness(1.07)}
.btn-primary{background:linear-gradient(100deg,#42ff9d,#00e77e);color:#00341e;border:0;box-shadow:0 7px 22px rgba(0,237,131,.15)}
.btn-secondary{border:1px solid rgba(0,237,131,.3);background:rgba(0,237,131,.04);color:#dffff0}
.note{text-align:center;margin:18px 0 0;color:#7fa895;font-size:10px;line-height:1.6}

/* Order journey simulation */
.journey-card{max-width:720px;margin:20px auto 0;padding:18px 20px;text-align:center;border:1px solid rgba(0,237,131,.28);border-radius:18px;background:linear-gradient(145deg,rgba(4,57,38,.96),rgba(1,30,21,.98));box-shadow:0 12px 35px rgba(0,0,0,.12)}
.journey-icon{height:58px;display:flex;align-items:center;justify-content:center;gap:12px;font-size:35px}
.steam-bowl{display:inline-block;animation:bowlFloat 1.8s ease-in-out infinite}
.sparkle{display:inline-block;color:#69ffac;font-size:20px;animation:sparkleFloat 1.5s ease-in-out infinite}
.sparkle:nth-child(3){animation-delay:.45s}.sparkle:nth-child(4){animation-delay:.8s}
@keyframes bowlFloat{0%,100%{transform:translateY(2px) rotate(-3deg)}50%{transform:translateY(-7px) rotate(3deg)}}
@keyframes sparkleFloat{0%,100%{transform:translateY(5px) scale(.75);opacity:.45}50%{transform:translateY(-8px) scale(1.15);opacity:1}}
.journey-title{margin-top:6px;color:var(--bright);font-size:16px;font-weight:800}
.journey-copy{margin-top:6px;color:#b8d9c8;font-size:13px}
.journey-countdown{margin-top:8px;font-size:32px;font-weight:800;font-variant-numeric:tabular-nums;letter-spacing:1px}
.journey-sub{margin-top:3px;color:var(--muted);font-size:11px}
.route-panel{display:none;margin:20px auto 0;max-width:1000px;border:1px solid var(--border);border-radius:18px;overflow:hidden;background:#dce7df}
.route-panel.visible{display:block;animation:routeReveal .65s ease both}
@keyframes routeReveal{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:translateY(0)}}
.route-head{display:flex;justify-content:space-between;align-items:center;gap:12px;padding:15px 18px;background:#05291e;color:#f4fff8;font-weight:800}
.route-badge{padding:7px 11px;border-radius:999px;background:#d3ffea;color:#00613d;font-size:10px;white-space:nowrap}
.route-map{position:relative;width:100%;background:#dce7df}
.route-map svg{display:block;width:100%;height:auto;min-height:210px}
.route-road{fill:none;stroke:#fff;stroke-width:27;stroke-linecap:round;stroke-linejoin:round}
.route-minor{fill:none;stroke:#f7fbf8;stroke-width:13;stroke-linecap:round;stroke-linejoin:round}
.route-line-base{fill:none;stroke:#9ab9a7;stroke-width:8;stroke-linecap:round;stroke-linejoin:round;stroke-dasharray:13 12}
.route-line-active{fill:none;stroke:#00b96b;stroke-width:8;stroke-linecap:round;stroke-linejoin:round;stroke-dasharray:13 12;filter:drop-shadow(0 0 4px rgba(0,185,107,.35))}
.route-pin-label{font-size:18px;font-weight:800;paint-order:stroke;stroke:#dce7df;stroke-width:5px;stroke-linejoin:round;fill:#143c2a}
.route-pin{stroke:#fff;stroke-width:4}
.route-footer{padding:11px 16px;background:#05291e;color:#b8d9c8;font-size:12px;display:flex;justify-content:space-between;gap:10px;flex-wrap:wrap}
.status-toast{position:fixed;top:88px;right:22px;z-index:1000;max-width:min(390px,calc(100vw - 28px));padding:15px 19px;border:1px solid rgba(105,255,172,.4);border-radius:15px;background:#063b29;color:#eafff2;box-shadow:0 15px 45px rgba(0,0,0,.35);display:flex;align-items:center;gap:12px;opacity:0;transform:translateY(-12px);pointer-events:none}
.status-toast.show{animation:toastIn .35s ease forwards}
.status-toast .toast-icon{font-size:26px}.status-toast strong{display:block;color:#69ffac;font-size:13px}.status-toast small{display:block;margin-top:4px;color:#b8d9c8;font-size:11px}
@keyframes toastIn{to{opacity:1;transform:translateY(0)}}
.progress-step.current .progress-dot{animation:stepPulse 1.4s ease-in-out infinite}
@keyframes stepPulse{0%,100%{box-shadow:0 0 0 4px rgba(0,237,131,.08),0 0 12px rgba(0,237,131,.2)}50%{box-shadow:0 0 0 9px rgba(0,237,131,.04),0 0 27px rgba(0,237,131,.55)}}
.progress-track{position:absolute;top:17px;left:12.5%;width:0;height:4px;background:linear-gradient(90deg,#00ed83,#69ffac);border-radius:8px;z-index:0;transition:width .7s linear;box-shadow:0 0 9px rgba(0,237,131,.55)}
@media(max-width:600px){.journey-card{margin-top:14px;padding:15px 12px}.journey-countdown{font-size:28px}.route-head{padding:12px;font-size:13px}.route-map svg{min-height:180px}.status-toast{top:72px;right:12px}}

@media(max-width:820px){.site-header{padding:0 18px}.site-nav{gap:13px}.header-search{display:none}.content-grid{grid-template-columns:1fr}}
@media(max-width:600px){.site-header{height:62px;padding:0 12px;gap:8px}.site-brand{font-size:19px;gap:7px}.site-brand-icon{width:34px;height:34px;font-size:18px}.site-nav{display:none}.header-right{gap:7px}.user-pill{font-size:10px;padding-right:8px}.user-avatar{width:28px;height:28px}.page{width:94%;margin:16px auto 32px}.success-hero{padding:22px 12px 18px;border-radius:17px}.success-check{width:53px;height:53px;font-size:30px}.success-hero p{font-size:12px}.order-progress{gap:2px;margin-top:20px}.order-progress:before{top:15px}.progress-dot{width:31px;height:31px;font-size:13px}.progress-step strong{font-size:10px}.progress-step small{font-size:9px}.content-grid{gap:13px;margin-top:14px}.panel-head{padding:13px}.items{padding:0 12px}.item{grid-template-columns:52px minmax(0,1fr) auto;gap:9px}.item-image,.item-image-fallback{width:52px;height:52px}.item-name{font-size:12px}.item-price{font-size:11px}.summary-body{padding:15px}}
@media(prefers-reduced-motion:reduce){*,*:before,*:after{animation:none!important;transition:none!important}}
</style>
</head>
<body>
<%-- Use the same shared navbar as My Orders so the active session username is displayed dynamically. --%>
<jsp:include page="/components/navbar.jsp" />

<main class="page">
    <section class="success-hero">
        <div class="success-check">✓</div>
        <h1>Your feast is on its way!</h1>
        <p>Your order is confirmed and our kitchen is getting started.</p>
        <div class="delivery-estimate"><span>✦</span> Order status: <strong><%= safeOrderStatus %></strong></div>

        <div class="order-progress" id="orderProgress" aria-label="Order progress">
            <div class="progress-track" id="progressTrack"></div>
            <div class="progress-step done" data-stage="0"><div class="progress-dot">✓</div><strong>Order confirmed</strong><small>Order received</small></div>
            <div class="progress-step current" data-stage="1"><div class="progress-dot">♨</div><strong>Preparing</strong><small>Kitchen started</small></div>
            <div class="progress-step" data-stage="2"><div class="progress-dot">🛵</div><strong>On the way</strong><small>Out for delivery</small></div>
            <div class="progress-step" data-stage="3"><div class="progress-dot">⌂</div><strong>Delivered</strong><small>Enjoy your meal</small></div>
        </div>
        <section class="journey-card" id="journeyCard" aria-live="polite">
            <div class="journey-icon" id="journeyAnimation"><span class="sparkle">✦</span><span class="steam-bowl">🍲</span><span class="sparkle">✧</span><span class="sparkle">✦</span></div>
            <div class="journey-title" id="journeyTitle">YOUR ORDER IS PREPARING</div>
            <div class="journey-copy" id="journeyCopy">Our kitchen is preparing something delicious for you.</div>
            <div class="journey-countdown" id="journeyCountdown">02:00</div>
            <div class="journey-sub" id="journeySub">Estimated preparation time remaining</div>
        </section>
        <section class="route-panel" id="routePanel" aria-label="Simulated delivery route">
            <div class="route-head"><span>🛵 Live Delivery Route</span><span class="route-badge" id="routeBadge">DELIVERY TRACKER</span></div>
            <div class="route-map">
                <svg id="routeSvg" viewBox="0 0 1000 330" role="img" aria-label="Illustrated route from restaurant to home">
                    <rect width="1000" height="330" fill="#dce7df"/>
                    <g opacity=".7"><path class="route-road" d="M-20 70 L250 145 L460 35 L710 120 L1020 48"/><path class="route-road" d="M90 -20 L170 350 M390 -20 L310 350 M690 -20 L610 350 M900 -20 L830 350"/><path class="route-minor" d="M-20 260 L250 205 L480 300 L720 220 L1020 290"/><path class="route-minor" d="M-20 160 L250 220 L520 150 L780 205 L1020 140"/></g>
                    <path id="routeBase" class="route-line-base" d="M90 260 L200 220 L300 250 L400 160 L500 190 L600 100 L720 130 L850 55"/>
                    <path id="routeActive" class="route-line-active" d="M90 260 L200 220 L300 250 L400 160 L500 190 L600 100 L720 130 L850 55"/>
                    <g id="restaurantPin" transform="translate(90 260)"><path d="M0 -31 C-19 -31 -29 -17 -29 0 C-29 20 0 39 0 39 C0 39 29 20 29 0 C29 -17 19 -31 0 -31Z" fill="#276ef1" class="route-pin"/><circle r="17" fill="#9fc4ff" stroke="#1450b5" stroke-width="3"/><path d="M-7 -10 V8 M-12 -10 V-2 M-7 -10 V-2 M-2 -10 V8 M7 -10 V10 M7 -10 Q15 -5 7 0" fill="none" stroke="#0648b7" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round"/></g>
                    <g id="homePin" transform="translate(850 55)"><path d="M0 -29 C-18 -29 -28 -15 -28 0 C-28 19 0 39 0 39 C0 39 28 19 28 0 C28 -15 18 -29 0 -29Z" fill="#111" class="route-pin"/><text text-anchor="middle" y="7" font-size="23" fill="#fff">⌂</text></g>
                    <image id="riderImage" href="<%= cp %>/images/delivery-person.png" x="55" y="225" width="70" height="55" preserveAspectRatio="xMidYMid meet"/>
                    <text x="40" y="310" class="route-pin-label">RESTAURANT</text><text x="800" y="115" class="route-pin-label">YOUR HOME</text>
                </svg>
            </div>
            <div class="route-footer"><span id="routeMessage">Your delivery partner will start moving when preparation is complete.</span><span id="routeTime">Estimated travel: 03:00</span></div>
        </section>
    </section>

    <div class="content-grid">
        <section class="panel">
            <div class="panel-head">
                <div class="panel-title"><span class="panel-icon">🍽</span> Your order</div>
                <span class="order-number">Order #<%= orderIdText %></span>
            </div>
            <div class="restaurant-line">
                <div class="restaurant-mark">🍴</div>
                <div><strong><%= safeRestaurantName %></strong><small>Thanks for ordering with FoodieHub</small></div>
                <span style="margin-left:auto;color:var(--gold)">★ 4.8</span>
            </div>

            <div class="items">
            <% if (orderedItems != null && !orderedItems.isEmpty()) { %>
                <% for (CartItem item : orderedItems) {
                    String itemName = item.getItemName() == null ? "Food item" : item.getItemName();
                    String safeItemName = itemName.replace("&","&amp;").replace("<","&lt;")
                        .replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
                    String imagePath = item.getImagePath() == null ? "" : item.getImagePath().trim();
                    String safeImagePath = imagePath.replace("&","&amp;").replace("\"","&quot;")
                        .replace("<","&lt;").replace(">","&gt;");
                    int quantity = item.getQuantity();
                    double price = item.getPrice();
                    double lineTotal = price * quantity;
                %>
                <article class="item">
                    <% if (!safeImagePath.isEmpty()) { %>
                        <img class="item-image" src="<%= safeImagePath %>" alt="<%= safeItemName %>" onerror="this.style.display='none';this.nextElementSibling.style.display='grid';">
                        <div class="item-image-fallback" style="display:none">🍛</div>
                    <% } else { %>
                        <div class="item-image-fallback">🍛</div>
                    <% } %>
                    <div><div class="item-name"><%= safeItemName %></div><div class="item-meta">Qty: <%= quantity %> × ₹<%= String.format(Locale.US,"%.2f",price) %></div></div>
                    <div class="item-price">₹<%= String.format(Locale.US,"%.2f",lineTotal) %><small>Item total</small></div>
                </article>
                <% } %>
            <% } else { %>
                <div class="empty-items">Your order has been recorded. Item details are not available in the current session, but you can view the saved order in My Orders.</div>
            <% } %>
            </div>
        </section>

        <aside class="panel">
            <div class="panel-head"><div class="panel-title"><span class="panel-icon">▤</span> Order summary</div></div>
            <div class="summary-body">
                <div class="summary-row"><span>Items (<%= itemCount %>)</span><strong>₹<%= String.format(Locale.US,"%.2f",itemTotal) %></strong></div>
                <div class="summary-row"><span>Delivery fee</span><strong>₹30.00</strong></div>
                <div class="summary-row"><span>Platform fee</span><strong>₹10.00</strong></div>
                <div class="summary-divider"></div>
                <div class="total-row"><span>Total paid</span><strong>₹<%= String.format(Locale.US,"%.2f",orderTotal) %></strong></div>
                <div class="method-box"><small>Payment method</small><strong>✓ &nbsp;<%= safePaymentMethod %></strong></div>
                <div class="method-box"><small>Order reference</small><strong>FH-<%= orderIdText %></strong></div>
                <div class="actions">
                    <a class="btn btn-primary" href="<%= cp %>/orders">Track your order&nbsp; →</a>
                    <a class="btn btn-secondary" href="<%= cp %>/restaurant">Continue exploring</a>
                </div>
            </div>
        </aside>
    </div>
    <p class="note">FoodieHub order confirmation · Payment UI is a demo unless a real payment gateway is connected.</p>
</main>
<div class="status-toast" id="statusToast" role="status" aria-live="polite"><span class="toast-icon" id="toastIcon">🍲</span><div><strong id="toastTitle">YOUR ORDER IS PREPARING</strong><small id="toastCopy">The kitchen has started preparing your order.</small></div></div>
<script>
(function(){
  const orderId = '<%= orderIdText %>';
  const serverStatus = '<%= safeOrderStatus %>'.toLowerCase();
  const storageKey = 'foodiehub-journey-' + orderId;
  const PREP_SECONDS = 120, TRAVEL_SECONDS = 180, TOTAL_SECONDS = PREP_SECONDS + TRAVEL_SECONDS;
  const journeyCard = document.getElementById('journeyCard');
  const routePanel = document.getElementById('routePanel');
  const title = document.getElementById('journeyTitle');
  const copy = document.getElementById('journeyCopy');
  const countdown = document.getElementById('journeyCountdown');
  const sub = document.getElementById('journeySub');
  const animation = document.getElementById('journeyAnimation');
  const toast = document.getElementById('statusToast');
  const track = document.getElementById('progressTrack');
  const rider = document.getElementById('riderImage');
  const routeBase = document.getElementById('routeBase');
  const routeActive = document.getElementById('routeActive');
  const routeMessage = document.getElementById('routeMessage');
  const routeTime = document.getElementById('routeTime');
  const routeBadge = document.getElementById('routeBadge');
  const stageEls = Array.from(document.querySelectorAll('.progress-step'));
  let toastTimer;
  function fmt(sec){sec=Math.max(0,Math.ceil(sec));return String(Math.floor(sec/60)).padStart(2,'0')+':'+String(sec%60).padStart(2,'0')}
  function notify(head, body, icon){document.getElementById('toastTitle').textContent=head;document.getElementById('toastCopy').textContent=body;document.getElementById('toastIcon').textContent=icon;toast.classList.remove('show');void toast.offsetWidth;toast.classList.add('show');clearTimeout(toastTimer);toastTimer=setTimeout(()=>toast.classList.remove('show'),5000)}
  function setStage(stage){stageEls.forEach((el,i)=>{el.classList.toggle('done',i<stage);el.classList.toggle('current',i===stage);const dot=el.querySelector('.progress-dot');if(i===0)dot.textContent='✓';else if(i===1)dot.textContent='♨';else if(i===2)dot.textContent='🛵';else dot.textContent=(stage===3?'✓':'⌂')});track.style.width=stage===0?'0%':stage===1?'25%':stage===2?'62.5%':'75%'}
  // Different order IDs select different route shapes while keeping the same start/end pins.
  const routes=[
    'M90 260 L200 220 L300 250 L400 160 L500 190 L600 100 L720 130 L850 55',
    'M90 260 L180 275 L260 205 L360 215 L430 115 L540 140 L650 65 L745 95 L850 55',
    'M90 260 L175 205 L265 235 L350 285 L455 215 L510 125 L630 155 L735 105 L850 55',
    'M90 260 L205 285 L285 235 L355 155 L455 180 L555 235 L660 145 L760 160 L850 55'
  ];
  const routeIndex=Math.abs(Array.from(String(orderId)).reduce((a,c)=>a+c.charCodeAt(0),0))%routes.length;
  const routeD=routes[routeIndex];routeBase.setAttribute('d',routeD);routeActive.setAttribute('d',routeD);
  const pathLength=routeActive.getTotalLength();
  routeActive.style.strokeDasharray=pathLength+' '+pathLength;routeActive.style.strokeDashoffset=pathLength;
  function placeRider(progress){const pt=routeActive.getPointAtLength(Math.max(0,Math.min(1,progress))*pathLength);rider.setAttribute('x',pt.x-35);rider.setAttribute('y',pt.y-27);}
  function render(){
    if(serverStatus.includes('cancel')){journeyCard.style.display='block';routePanel.classList.remove('visible');setStage(0);title.textContent='YOUR ORDER WAS CANCELLED';copy.textContent='This order has been cancelled. Delivery simulation stopped.';countdown.textContent='—';sub.textContent='No delivery is in progress';animation.innerHTML='<span>✕</span>';return;}
    let start=Number(sessionStorage.getItem(storageKey));if(!start||!Number.isFinite(start)){start=Date.now();sessionStorage.setItem(storageKey,String(start));}
    const elapsed=Math.max(0,(Date.now()-start)/1000);
    if(elapsed<PREP_SECONDS){
      const remain=PREP_SECONDS-elapsed;setStage(1);routePanel.classList.remove('visible');title.textContent='YOUR ORDER IS PREPARING';copy.textContent='Our kitchen is preparing something delicious for you.';countdown.textContent=fmt(remain);sub.textContent='Estimated preparation time remaining';animation.innerHTML='<span class="sparkle">✦</span><span class="steam-bowl">🍲</span><span class="sparkle">✧</span><span class="sparkle">✦</span>';placeRider(0);routeMessage.textContent='Your delivery partner is waiting at the restaurant.';routeTime.textContent='Estimated travel: 03:00';
    }else if(elapsed<TOTAL_SECONDS){
      const travelElapsed=elapsed-PREP_SECONDS, progress=Math.min(1,travelElapsed/TRAVEL_SECONDS), remain=TRAVEL_SECONDS-travelElapsed;setStage(2);routePanel.classList.add('visible');title.textContent='YOUR ORDER IS ON THE WAY';copy.textContent='Your delivery partner is bringing your order to you.';countdown.textContent=fmt(remain);sub.textContent='Estimated delivery time remaining';animation.innerHTML='<span class="steam-bowl">🛵</span><span class="sparkle">✦</span>';placeRider(progress);routeActive.style.strokeDashoffset=pathLength*(1-progress);routeMessage.textContent='Your delivery partner is on the way to your home.';routeTime.textContent='Time remaining: '+fmt(remain);routeBadge.textContent='RIDER EN ROUTE';
      if(!sessionStorage.getItem(storageKey+'-way-notified')){notify('YOUR ORDER IS ON THE WAY','Your delivery partner has left the restaurant.','🛵');sessionStorage.setItem(storageKey+'-way-notified','1');}
    }else{
      setStage(3);routePanel.classList.add('visible');title.textContent='YOUR ORDER IS SUCCESSFULLY DELIVERED';copy.textContent='Enjoy your meal! Your delivery has reached your home.';countdown.textContent='✓';sub.textContent='Delivered successfully';animation.innerHTML='<span>🎉</span><span class="sparkle">✦</span><span>🍽️</span>';placeRider(1);routeActive.style.strokeDashoffset=0;routeMessage.textContent='Delivered to your home. Enjoy your meal!';routeTime.textContent='Delivery completed';routeBadge.textContent='DELIVERED';
      if(!sessionStorage.getItem(storageKey+'-delivered-notified')){notify('YOUR ORDER IS SUCCESSFULLY DELIVERED','Your delivery partner has reached the home locator.','🎉');sessionStorage.setItem(storageKey+'-delivered-notified','1');}
    }
  }
  if(serverStatus.includes('cancel')){render();}else{render();setInterval(render,1000);}
  // If the page is restored from the browser back/forward cache, refresh the displayed stage.
  window.addEventListener('pageshow',render);
})();
</script>



</body>
</html>
