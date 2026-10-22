<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="java.util.Locale" %>
<%!
    private String trackEscape(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;").replace("<", "&lt;")
                    .replace(">", "&gt;").replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>
<%
    String cp = request.getContextPath();
    User loggedUser = (User) session.getAttribute("loggedInUser");
    if (loggedUser == null) { response.sendRedirect(cp + "/login.jsp"); return; }
    Order order = (Order) request.getAttribute("trackedOrder");
    Restaurant restaurant = (Restaurant) request.getAttribute("trackedRestaurant");
    if (order == null) { response.sendRedirect(cp + "/orders"); return; }
    String status = (String) request.getAttribute("trackingStatus");
    if (status == null) status = "Preparing";
    Integer stepObject = (Integer) request.getAttribute("trackingStep");
    int step = stepObject == null ? 2 : stepObject.intValue();
    Boolean cancelledObject = (Boolean) request.getAttribute("trackingCancelled");
    boolean cancelled = cancelledObject != null && cancelledObject.booleanValue();
    String restaurantName = restaurant == null || restaurant.getName() == null ? "FoodieHub Restaurant" : restaurant.getName();
    String restaurantAddress = restaurant == null || restaurant.getAddress() == null ? "Restaurant location" : restaurant.getAddress();
    String deliveryAddress = loggedUser.getAddress() == null || loggedUser.getAddress().trim().isEmpty() ? "Your saved delivery address" : loggedUser.getAddress();
    int scooterPosition = step >= 4 ? 92 : step == 3 ? 68 : step == 2 ? 38 : 18;
    String eta = step >= 4 ? "Delivered" : step == 3 ? "Arriving soon" : "Preparing your order";
    Long remainingObject = (Long) request.getAttribute("trackingRemainingMs");
    long remainingSeconds = remainingObject == null ? 0L : Math.max(0L, (remainingObject.longValue()+999L)/1000L);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Track Order #<%= order.getOrderId() %> | FoodieHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap" rel="stylesheet">
<style>
:root{--bg:#001a12;--panel:#05291e;--panel2:#073525;--green:#00ed83;--bright:#6dffb0;--text:#f3fff8;--muted:#9bb9aa;--border:rgba(105,255,172,.18);--red:#ff625f;--gold:#ffd56b}
*{box-sizing:border-box;margin:0;padding:0}body{min-height:100vh;font-family:'DM Sans',sans-serif;color:var(--text);background:radial-gradient(ellipse at 10% 8%,rgba(0,237,131,.08),transparent 32%),var(--bg)}a{text-decoration:none;color:inherit}
.track-wrap{width:90%;max-width:1200px;margin:0 auto;padding:32px 0 60px}.eyebrow{font-size:10px;letter-spacing:2px;color:var(--green);font-weight:800;margin-bottom:10px}.title-row{display:flex;justify-content:space-between;align-items:flex-start;gap:18px;margin-bottom:22px}.title-row h1{font-family:'Playfair Display',serif;font-size:clamp(29px,4vw,42px)}.title-row h1 span{color:var(--green)}.title-row p{color:var(--muted);font-size:13px;margin-top:8px;line-height:1.6}.order-pill{padding:10px 13px;border:1px solid var(--border);border-radius:12px;background:#05291e;color:var(--bright);font-size:12px;font-weight:800;white-space:nowrap}
.status-card{border:1px solid var(--border);border-radius:20px;background:linear-gradient(135deg,#073525,#031f16);padding:23px;margin-bottom:20px}.status-top{display:flex;align-items:center;justify-content:space-between;gap:15px;flex-wrap:wrap}.status-top h2{font-size:21px}.status-top p{color:var(--muted);font-size:12px;margin-top:6px}.status-badge{padding:9px 13px;border-radius:30px;background:rgba(0,237,131,.1);border:1px solid rgba(0,237,131,.28);color:var(--bright);font-size:12px;font-weight:800}.status-badge.cancelled{color:#ff8582;background:#ff625f15;border-color:#ff625f44}
.steps{display:grid;grid-template-columns:repeat(4,1fr);margin-top:27px;position:relative}.steps:before{content:"";position:absolute;left:12.5%;right:12.5%;top:18px;height:3px;background:#244b3a;border-radius:4px}.steps:after{content:"";position:absolute;left:12.5%;top:18px;width:<%= Math.max(0,Math.min(100,(step-1)*33.333)) %>%;max-width:75%;height:3px;background:linear-gradient(90deg,var(--green),#7dffb1);border-radius:4px;transition:width .4s;display:<%= cancelled ? "none" : "block" %>}.step{text-align:center;position:relative;z-index:1}.step-icon{width:38px;height:38px;margin:0 auto 10px;border-radius:50%;display:grid;place-items:center;background:#092c20;border:2px solid #315c47;color:#a9c7b5;font-size:16px}.step.done .step-icon,.step.active .step-icon{background:linear-gradient(135deg,#00ed83,#7dffb1);border-color:#8bffb8;color:#00331e;box-shadow:0 0 18px #00ed8340}.step strong{display:block;font-size:11px}.step small{display:block;margin-top:5px;font-size:10px;color:var(--muted)}
.track-grid{display:grid;grid-template-columns:minmax(0,1.65fr) minmax(280px,.8fr);gap:20px;align-items:stretch}.map-card,.details-card{border:1px solid var(--border);border-radius:20px;overflow:hidden;background:#05291e}.map-heading{display:flex;justify-content:space-between;align-items:center;gap:10px;padding:17px 19px;border-bottom:1px solid var(--border)}.map-heading h3{font-size:15px}.live-tag{display:flex;align-items:center;gap:7px;font-size:10px;color:#007747;background:#d7ffe7;padding:7px 10px;border-radius:30px;font-weight:800}.live-dot{width:7px;height:7px;border-radius:50%;background:#00a75c;animation:pulse 1.5s infinite}@keyframes pulse{50%{opacity:.3;box-shadow:0 0 0 5px #00a75c18}}
/* Stylized locator map matching the supplied reference; it is a visual demo, not live GPS. */
.map-canvas{height:365px;position:relative;overflow:hidden;background:#dce5df;background-image:linear-gradient(25deg,transparent 46%,#fff 47%,#fff 51%,transparent 52%),linear-gradient(115deg,transparent 42%,#fff 43%,#fff 47%,transparent 48%),linear-gradient(75deg,transparent 65%,#f9fbf8 66%,#f9fbf8 70%,transparent 71%),linear-gradient(0deg,transparent 88%,#cbd8cf 89%,#cbd8cf 91%,transparent 92%);background-size:240px 210px,300px 250px,260px 240px,100% 100%}
.map-canvas:before{content:"";position:absolute;inset:-20px;background:repeating-linear-gradient(12deg,transparent 0 52px,rgba(255,255,255,.95) 53px 61px,transparent 62px 120px),repeating-linear-gradient(102deg,transparent 0 86px,rgba(255,255,255,.92) 87px 95px,transparent 96px 155px);opacity:.9}
.park{position:absolute;border-radius:30% 42% 35% 24%;background:#a9d9a7;opacity:.8}.park.one{width:120px;height:75px;left:5%;top:12%;transform:rotate(-18deg)}.park.two{width:105px;height:90px;right:8%;bottom:8%;transform:rotate(24deg)}.building{position:absolute;background:#c4d0c8;border:2px solid #eef3ef;border-radius:4px;box-shadow:inset 0 0 0 5px #d2ddd5}.building.b1{width:90px;height:52px;left:28%;top:10%;transform:rotate(-12deg)}.building.b2{width:78px;height:65px;right:18%;top:25%;transform:rotate(12deg)}.building.b3{width:115px;height:58px;left:18%;bottom:12%;transform:rotate(8deg)}.street-label{position:absolute;font-size:9px;font-weight:800;letter-spacing:1px;color:#73877a;text-transform:uppercase;transform:rotate(-25deg)}.street-label.l1{top:37%;left:8%}.street-label.l2{right:7%;top:58%;transform:rotate(25deg)}.route-svg{position:absolute;inset:0;width:100%;height:100%;z-index:2}.map-pin{position:absolute;z-index:3;width:36px;height:36px;border-radius:50% 50% 50% 8px;transform:rotate(-45deg);display:grid;place-items:center;box-shadow:0 5px 15px #0002;border:3px solid white}.map-pin span{transform:rotate(45deg);font-size:17px}.map-pin{width:48px;height:48px;transform:none;border:0;border-radius:0;background:transparent;box-shadow:none;display:block;object-fit:contain}
.map-pin.restaurant{position:absolute;left:9%;bottom:9%;z-index:4}.map-pin.home{position:absolute;right:8%;top:7%;z-index:4}
.route-svg{display:none}.map-canvas.route-active .route-svg{display:block}
.scooter-marker{position:absolute;z-index:5;width:112px;height:auto;object-fit:contain;transform:translate(-50%,-50%);filter:drop-shadow(0 5px 4px #0003);display:none}
.map-canvas.route-active .scooter-marker{display:block}
.preparing-overlay{position:absolute;inset:0;z-index:6;display:flex;align-items:center;justify-content:center;background:rgba(2,35,24,.82);backdrop-filter:blur(2px);text-align:center;padding:24px}
.preparing-inner{max-width:320px}.prep-orbit{width:72px;height:72px;margin:0 auto 15px;border:2px solid #00ed83;border-radius:50%;display:grid;place-items:center;color:#00ed83;font-size:30px;animation:prepPulse 1.4s ease-in-out infinite}
@keyframes prepPulse{50%{box-shadow:0 0 0 14px #00ed8300;transform:scale(1.04)}}
.preparing-inner strong{display:block;font-size:17px}.preparing-inner p{margin-top:8px;color:#b6d9c8;font-size:12px}.countdown{display:inline-block;margin-top:13px;color:#00f59a;font-weight:800}
.route-popup{position:fixed;right:22px;top:92px;z-index:9999;padding:15px 18px;border:1px solid #00ed83;border-radius:14px;background:#05291e;color:#eafff3;opacity:0;transform:translateY(-12px);pointer-events:none;transition:.3s}.route-popup.show{opacity:1;transform:translateY(0)}.route-popup strong{display:block;color:#00f5a0;margin-bottom:4px}.map-legend{display:flex;flex-wrap:wrap;gap:18px;padding:13px 18px;background:#f7faf7;color:#52665a;font-size:10px;font-weight:700}.legend-item{display:flex;align-items:center;gap:7px}.legend-dot{width:9px;height:9px;border-radius:50%;background:#16d978}.legend-dot.red{background:#ff625f}.legend-dot.orange{background:#ff7d31}
.details-card{padding:20px}.details-card h3{font-size:16px;margin-bottom:15px}.eta-box{display:flex;align-items:center;gap:13px;padding:15px;border-radius:14px;background:rgba(0,237,131,.08);border:1px solid rgba(0,237,131,.17);margin-bottom:19px}.eta-icon{width:44px;height:44px;display:grid;place-items:center;border-radius:12px;background:#0b4a31;font-size:23px}.eta-box small{display:block;color:var(--muted);font-size:10px;margin-bottom:4px}.eta-box strong{font-size:18px;color:var(--bright)}.place-row{display:flex;gap:12px;padding:13px 0;border-bottom:1px solid var(--border)}.place-row:last-of-type{border-bottom:0}.place-symbol{width:35px;height:35px;flex-shrink:0;display:grid;place-items:center;border-radius:11px;background:#0b3928;font-size:17px}.place-info{min-width:0}.place-info small{display:block;font-size:9px;color:var(--muted);font-weight:800;letter-spacing:1px;margin-bottom:5px}.place-info strong{display:block;font-size:12px;overflow-wrap:anywhere}.place-info p{font-size:11px;line-height:1.5;color:var(--muted);margin-top:4px;overflow-wrap:anywhere}.order-total{display:flex;justify-content:space-between;gap:10px;padding:16px 0;color:var(--muted);font-size:12px}.order-total strong{font-size:18px;color:var(--bright)}.btn-row{display:flex;gap:9px;margin-top:8px}.btn{display:inline-flex;align-items:center;justify-content:center;flex:1;padding:12px 10px;border-radius:11px;font-size:11px;font-weight:800}.btn.primary{background:linear-gradient(120deg,#00ed83,#6dffb0);color:#00301b}.btn.secondary{border:1px solid var(--border);color:var(--bright)}.note{font-size:10px;color:var(--muted);line-height:1.6;margin-top:14px}.cancelled-note{padding:14px;border:1px solid #ff625f55;background:#ff625f10;border-radius:12px;color:#ffaaa7;font-size:12px;line-height:1.6}
@media(max-width:850px){.track-grid{grid-template-columns:1fr}.map-canvas{height:330px}.track-wrap{width:92%}}@media(max-width:520px){.title-row{display:block}.order-pill{display:inline-block;margin-top:14px}.status-card{padding:17px}.steps:before{left:12.5%;right:12.5%}.step strong{font-size:10px}.step small{font-size:9px}.map-canvas{height:280px}.map-heading{padding:14px}.details-card{padding:16px}}
</style>
</head>
<body>
<jsp:include page="/components/navbar.jsp" />
<main class="track-wrap">
  <div class="title-row">
    <div><div class="eyebrow">FOODIEHUB DELIVERY</div><h1>Your order is <span><%= trackEscape(status) %>!</span></h1><p>Follow your order journey from the restaurant to your doorstep.</p></div>
    <div class="order-pill">ORDER #<%= order.getOrderId() %></div>
  </div>
  <section class="status-card">
    <div class="status-top"><div><h2><%= cancelled ? "This order was cancelled" : (step >= 4 ? "Enjoy your meal!" : step == 3 ? "Your delivery partner is on the way" : "Your food is being prepared") %></h2><p><%= cancelled ? "This order is no longer in delivery." : (step >= 4 ? "Your order has been delivered successfully." : "Estimated delivery time may vary based on the restaurant and route.") %></p></div><span class="status-badge <%= cancelled ? "cancelled" : "" %>"><%= trackEscape(status) %></span></div>
    <% if (!cancelled) { %>
    <div class="steps">
      <div class="step <%= step >= 1 ? "done" : "" %>"><div class="step-icon">✓</div><strong>Confirmed</strong><small>Order received</small></div>
      <div class="step <%= step >= 2 ? "done" : "" %>"><div class="step-icon">♨</div><strong>Preparing</strong><small>Freshly prepared</small></div>
      <div class="step <%= step >= 3 ? "active" : "" %>"><div class="step-icon">🛵</div><strong>On the Way</strong><small>Out for delivery</small></div>
      <div class="step <%= step >= 4 ? "done" : "" %>"><div class="step-icon">⌂</div><strong>Delivered</strong><small>At your door</small></div>
    </div>
    <% } %>
  </section>

  <div class="track-grid">
    <section class="map-card">
      <div class="map-heading"><h3>Live Delivery Route</h3><span class="live-tag"><span class="live-dot"></span> DELIVERY TRACKER</span></div>
      <% if (cancelled) { %>
      <div class="map-canvas"><img class="map-pin restaurant" src="<%= cp %>/images/restaurant.png" alt="Restaurant"><img class="map-pin home" src="<%= cp %>/images/home.png" alt="Home"><div class="preparing-overlay"><div class="preparing-inner"><div class="prep-orbit">×</div><strong>Order cancelled</strong><p>Delivery simulation stopped.</p></div></div></div>
      <% } else { %>
      <div class="map-canvas <%= step >= 3 ? "route-active" : "" %>" id="deliveryMap" data-step="<%= step %>" data-order-id="<%= order.getOrderId() %>" data-remaining="<%= remainingSeconds %>">
        <div class="park one"></div><div class="park two"></div><div class="building b1"></div><div class="building b2"></div><div class="building b3"></div><div class="street-label l1">Restaurant Road</div><div class="street-label l2">Main Street</div>
        <svg class="route-svg" id="routeSvg" viewBox="0 0 800 365" preserveAspectRatio="none">
          <path id="routeHalo" d="M115 285 L185 245 L265 260 L340 195 L420 218 L500 145 L575 160 L680 65" fill="none" stroke="#fff" stroke-width="13" stroke-linecap="round" stroke-linejoin="round"/>
          <path id="routePath" d="M115 285 L185 245 L265 260 L340 195 L420 218 L500 145 L575 160 L680 65" fill="none" stroke="#00b86b" stroke-width="6" stroke-linecap="round" stroke-linejoin="round" stroke-dasharray="12 8"/>
        </svg>
        <img class="map-pin restaurant" src="<%= cp %>/images/restaurant.png" alt="Restaurant location">
        <img class="map-pin home" src="<%= cp %>/images/home.png" alt="Home location">
        <img class="scooter-marker" id="deliveryScooter" src="<%= cp %>/images/delivery-person.png" alt="Delivery person">
        <% if (step < 3) { %><div class="preparing-overlay"><div class="preparing-inner"><div class="prep-orbit">♨</div><strong>Your food is being prepared</strong><p>Your route will appear when your order is on the way.</p><span class="countdown" id="prepCountdown">02:00</span></div></div><% } %>
      </div>
      <% } %>
      <div class="map-legend"><span class="legend-item">Restaurant pin</span><span class="legend-item">Delivery person</span><span class="legend-item">Home pin</span></div>
    </section>

    <aside class="details-card">
      <h3>Delivery Details</h3>
      <% if (cancelled) { %><div class="cancelled-note">This order is cancelled. Please return to My Orders to review your other orders.</div><% } else { %>
      <div class="eta-box"><div class="eta-icon">🛵</div><div><small><%= step >= 4 ? "DELIVERY STATUS" : "ESTIMATED DELIVERY" %></small><strong><%= trackEscape(eta) %></strong></div></div>
      <% } %>
      <div class="place-row"><div class="place-symbol">🍴</div><div class="place-info"><small>PICKUP FROM</small><strong><%= trackEscape(restaurantName) %></strong><p><%= trackEscape(restaurantAddress) %></p></div></div>
      <div class="place-row"><div class="place-symbol">⌂</div><div class="place-info"><small>DELIVER TO</small><strong><%= trackEscape(loggedUser.getUsername() == null ? "Customer" : loggedUser.getUsername()) %></strong><p><%= trackEscape(deliveryAddress) %></p></div></div>
      <div class="order-total"><span>Order total</span><strong>₹<%= String.format(Locale.US, "%.2f", order.getTotalAmount()) %></strong></div>
      <div class="btn-row"><a class="btn primary" href="<%= cp %>/orders">My Orders</a><a class="btn secondary" href="<%= cp %>/restaurant">Continue Exploring</a></div>
      <p class="note">Illustrated route for the FoodieHub project demo. This screen does not access a delivery partner's real-time GPS location. The progress shown reflects the status saved for this order.</p>
    </aside>
  </div>
</main>
<div class="route-popup" id="routePopup"><strong>Your order is on the way!</strong><span>Your delivery partner has started the journey.</span></div>
<script>
(()=>{const m=document.getElementById('deliveryMap');if(!m)return;const step=+m.dataset.step,id=+m.dataset.orderId;let rem=+m.dataset.remaining;const c=document.getElementById('prepCountdown'),pop=document.getElementById('routePopup'),scoot=document.getElementById('deliveryScooter'),p=document.getElementById('routePath'),h=document.getElementById('routeHalo'),svg=document.getElementById('routeSvg');
const routes=['M115 285 L185 245 L265 260 L340 195 L420 218 L500 145 L575 160 L680 65','M115 285 L170 310 L250 270 L305 285 L390 205 L470 225 L535 135 L610 110 L680 65','M115 285 L190 220 L250 180 L330 215 L400 150 L475 175 L545 95 L610 125 L680 65','M115 285 L190 285 L245 230 L320 250 L390 170 L455 195 L520 205 L590 115 L680 65'];p.setAttribute('d',routes[Math.abs(id)%4]);h.setAttribute('d',routes[Math.abs(id)%4]);
function pos(t){let q=p.getPointAtLength(Math.max(0,Math.min(1,t))*p.getTotalLength()),v=svg.viewBox.baseVal;scoot.style.left=(q.x/v.width*m.clientWidth)+'px';scoot.style.top=(q.y/v.height*m.clientHeight)+'px';}
if(step>=3){m.classList.add('route-active');let initial=Math.max(0,Math.min(1,(180-rem)/180));pos(step>=4?1:initial);if(step===3){let st=Date.now();function anim(){let t=Math.min(1,initial+(Date.now()-st)/180000);pos(t);if(t<1)requestAnimationFrame(anim)}requestAnimationFrame(anim);if(rem>0)setTimeout(()=>location.reload(),rem*1000)}}else{function tick(){if(c)c.textContent=String(Math.floor(rem/60)).padStart(2,'0')+':'+String(rem%60).padStart(2,'0');if(rem<=0){pop.classList.add('show');setTimeout(()=>location.reload(),1300);return}rem--;setTimeout(tick,1000)}tick()}})();
</script>
</body>
</html>
