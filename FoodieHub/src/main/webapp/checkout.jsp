<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.util.Collection" %>

<%@ page import="java.util.Locale" %>

<%@ page import="com.tap.model.Cart" %>

<%@ page import="com.tap.model.CartItem" %>

<%@ page import="com.tap.model.Restaurant" %>

<%@ page import="com.tap.daoimpl.RestaurantDaoImpl" %>

<%

    String cp = request.getContextPath();



    // Guests may browse and use the cart, but checkout requires login.

    if (session.getAttribute("loggedInUser") == null) {

        session.setAttribute("afterLoginRedirect", cp + "/checkout.jsp");

        response.sendRedirect(cp + "/login.jsp");

        return;

    }



    Cart checkoutCart = (Cart) session.getAttribute("cart");



    if (checkoutCart == null || checkoutCart.isEmpty()) {

        response.sendRedirect(cp + "/cart");

        return;

    }



    Collection<CartItem> checkoutItems = checkoutCart.getItems();

    double itemTotal = checkoutCart.getTotalAmount();

    double deliveryFee = 30.00;

    double platformFee = 10.00;

    double grandTotal = itemTotal + deliveryFee + platformFee;

    int checkoutItemCount = checkoutCart.getItemCount();



    String restaurantName = "Your Restaurant";

    try {

        RestaurantDaoImpl restaurantDao = new RestaurantDaoImpl();

        Restaurant restaurant = restaurantDao.getRestaurant(checkoutCart.getRestaurantId());

        if (restaurant != null && restaurant.getName() != null && !restaurant.getName().trim().isEmpty()) {

            restaurantName = restaurant.getName();

        }

    } catch (Exception ignored) {

        // Keep fallback label if restaurant lookup is unavailable.

    }



    String safeRestaurantName = restaurantName.replace("&","&amp;").replace("<","&lt;")

        .replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");



    String fullName = request.getParameter("fullName") == null ? "" : request.getParameter("fullName");

    String phone = request.getParameter("phone") == null ? "" : request.getParameter("phone");

    String address1 = request.getParameter("addressLine1") == null ? "" : request.getParameter("addressLine1");

    String address2 = request.getParameter("addressLine2") == null ? "" : request.getParameter("addressLine2");

    String city = request.getParameter("city") == null ? "Bengaluru" : request.getParameter("city");

    String state = request.getParameter("state") == null ? "Karnataka" : request.getParameter("state");

    String pinCode = request.getParameter("pinCode") == null ? "" : request.getParameter("pinCode");

    String country = request.getParameter("country") == null ? "India" : request.getParameter("country");



    String escFullName = fullName.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

    String escPhone = phone.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

    String escAddress1 = address1.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

    String escAddress2 = address2.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

    String escCity = city.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

    String escState = state.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

    String escPinCode = pinCode.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

    String escCountry = country.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Checkout | FoodieHub</title>

<link rel="preconnect" href="https://fonts.googleapis.com">

<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">

<style>

:root{--bg:#001b13;--panel:rgba(1,31,22,.94);--green:#00ed91;--mint:#76ffc0;--teal:#16e8cf;--text:#f5fff9;--muted:#a6c7b7;--border:rgba(0,237,145,.24);--red:#ff3d35;--gold:#ffd629}

*{box-sizing:border-box;margin:0;padding:0}

html{scroll-behavior:smooth}

body{min-height:100vh;color:var(--text);font-family:'DM Sans',Arial,sans-serif;background:#00170f;overflow-x:hidden;position:relative}

body:before{content:"";position:fixed;inset:0;z-index:-2;background-image:url('https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=2200&q=85');background-size:cover;background-position:center;background-repeat:no-repeat;filter:saturate(1.18)}

body:after{content:"";position:fixed;inset:0;z-index:-1;background:linear-gradient(90deg,rgba(0,21,14,.94),rgba(0,27,18,.91) 45%,rgba(0,24,16,.94)),radial-gradient(ellipse at 50% 0%,rgba(0,237,145,.13),transparent 55%)}

a{color:inherit;text-decoration:none}button,input,select{font:inherit}

.checkout-page{width:min(1360px,92%);margin:18px auto 36px}

.back-cart{display:inline-flex;align-items:center;gap:9px;margin:0 0 20px 2px;color:var(--green);font-size:14px;font-weight:700;transition:gap .2s}

.back-cart:hover{gap:14px}

.page-heading{display:flex;align-items:center;gap:17px;margin-bottom:24px}

.heading-icon{width:83px;height:78px;display:grid;place-items:center;border:2px solid var(--green);border-radius:25px;color:var(--green);background:rgba(0,237,145,.04);box-shadow:0 0 24px rgba(0,237,145,.08)}

.heading-icon svg{width:43px;height:43px}

.page-heading h1{font-size:clamp(30px,3.2vw,44px);line-height:1.1;font-weight:800;letter-spacing:-1.2px}

.page-heading p{margin-top:5px;color:#c3e3d4;font-size:17px}

.checkout-grid{display:grid;grid-template-columns:minmax(0,1.08fr) minmax(0,.92fr);gap:24px;align-items:start}
.checkout-grid>*{min-width:0}
.checkout-grid .left-column,.checkout-grid .summary-panel{min-width:0;width:100%}

.left-column{display:flex;flex-direction:column;gap:18px;min-width:0}

.panel{border:1px solid var(--border);border-radius:22px;background:linear-gradient(145deg,rgba(0,34,24,.96),rgba(0,25,18,.96));box-shadow:0 16px 42px rgba(0,0,0,.17);backdrop-filter:blur(10px)}

.delivery-panel,.payment-panel{padding:18px 22px}

.panel-heading{display:flex;align-items:center;gap:14px;margin-bottom:17px}

.panel-icon{width:53px;height:53px;display:grid;place-items:center;flex:0 0 auto;border:2px solid var(--green);border-radius:50%;color:var(--green)}

.panel-icon svg{width:29px;height:29px}

.panel-heading h2{font-size:20px;font-weight:800;letter-spacing:-.4px}

.panel-heading p{margin-top:4px;color:#b4d9c9;font-size:14px}

.form-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:18px 20px;width:100%}

.form-group{min-width:0;width:100%}
.form-group .form-control{display:block;box-sizing:border-box;width:100%;max-width:100%;min-width:0}
.form-group label{overflow-wrap:anywhere}

.form-group label{display:block;margin-bottom:5px;color:#d9f1e5;font-size:15px;font-weight:500}

.required{color:#ff756d;font-weight:800}

.form-control{width:100%;height:43px;padding:0 17px;border:1px solid rgba(0,237,145,.38);border-radius:11px;outline:none;background:rgba(0,40,29,.76);color:#f6fff9;font-size:15px;transition:border-color .2s,box-shadow .2s}

.form-control::placeholder{color:#83a99a}

.form-control:focus{border-color:var(--green);box-shadow:0 0 0 3px rgba(0,237,145,.1)}

select.form-control{appearance:auto;color-scheme:dark}

.form-group.full{grid-column:1/-1}

.payment-panel{padding-top:18px;padding-bottom:20px}

.payment-panel .panel-heading{margin-bottom:16px}

.payment-options{display:flex;flex-direction:column;gap:17px}

.payment-option{position:relative}

.payment-option input{position:absolute;opacity:0;pointer-events:none}

.payment-option label{display:flex;align-items:center;gap:18px;min-height:76px;padding:12px 17px;border:1px solid rgba(0,237,145,.28);border-radius:13px;background:rgba(0,32,22,.66);cursor:pointer;transition:border-color .2s,background .2s,box-shadow .2s}

.payment-option label:hover{border-color:rgba(0,237,145,.65)}

.payment-option input:checked+label{border:2px solid #4effa5;background:rgba(0,237,145,.075);box-shadow:inset 0 0 0 1px rgba(0,237,145,.06)}

.radio-mark{width:27px;height:27px;flex:0 0 auto;border:3px solid #688d7e;border-radius:50%;display:grid;place-items:center}

.payment-option input:checked+label .radio-mark{border-color:var(--green)}

.payment-option input:checked+label .radio-mark:after{content:"";width:13px;height:13px;border-radius:50%;background:var(--green)}

.payment-symbol{width:51px;display:grid;place-items:center;flex:0 0 auto;color:#72ffd0}

.payment-symbol svg{width:48px;height:42px}

.payment-copy{min-width:0;flex:1}

.payment-copy strong{display:block;font-size:15px;font-weight:800}

.payment-copy small{display:block;margin-top:7px;color:#b3d7c8;font-size:12px;line-height:1.45}

.payment-brands{display:flex;align-items:center;gap:9px;margin-left:auto}

.brand{height:42px;min-width:58px;padding:5px 8px;display:flex;align-items:center;justify-content:center;border:1px solid rgba(255,255,255,.13);border-radius:8px;background:#031b1a;box-shadow:0 3px 10px rgba(0,0,0,.15)}

.brand.upi{min-width:68px;background:#071e1c}.brand.visa{background:#073779}.brand.mastercard{background:#051e20}.brand.gpay{background:#071f25}

.brand svg{width:100%;height:100%;max-width:60px}

.summary-panel{padding:18px 21px;min-width:0}

.summary-heading{display:flex;align-items:center;gap:14px;margin-bottom:17px}

.summary-icon{width:56px;height:56px;display:grid;place-items:center;flex:0 0 auto;border:2px solid var(--gold);border-radius:50%;color:var(--gold)}

.summary-icon svg{width:30px;height:30px}

.summary-heading h2{font-size:20px;font-weight:800;letter-spacing:-.4px}

.summary-heading p{margin-top:4px;color:#b4d9c9;font-size:14px}

.restaurant-card{display:flex;align-items:center;gap:17px;padding:9px 12px;margin-bottom:14px;border:1px solid rgba(0,237,145,.25);border-radius:14px;background:rgba(0,25,18,.57)}

.restaurant-image{width:88px;height:88px;object-fit:cover;flex:0 0 auto;border-radius:14px;background:#0b3a2b}

.restaurant-name{font-size:20px;font-weight:800}

.restaurant-cuisine{margin-top:6px;color:#b5d9ca;font-size:14px}

.restaurant-rating{display:flex;align-items:center;gap:7px;margin-top:8px;font-size:15px}

.star{color:var(--gold);font-size:22px}.reviews{color:var(--green);margin-left:8px}

.items-list{display:flex;flex-direction:column}

.order-item{display:grid;grid-template-columns:66px minmax(100px,1fr) 90px;align-items:center;gap:13px;padding:10px 0;border-bottom:1px solid rgba(0,237,145,.22)}

.order-item-image{width:66px;height:76px;object-fit:cover;border-radius:12px;background:#0b3a2b}

.order-item-name{font-size:15px;font-weight:800;line-height:1.35;overflow-wrap:anywhere}

.order-item-restaurant{margin-top:6px;color:#b4d9c9;font-size:12px}

.order-item-unit-price{text-align:right;font-size:14px;font-weight:800;white-space:nowrap;color:var(--green)}

.item-actions{display:grid;grid-template-columns:36px 26px 36px 38px;align-items:center;justify-content:end;gap:8px}

.qty-button{width:36px;height:38px;display:grid;place-items:center;border:0;border-radius:10px;background:linear-gradient(135deg,#00e995,#00c97e);color:#003b25;font-size:24px;font-weight:800;cursor:pointer;transition:transform .15s,filter .15s}

.qty-button:hover{transform:translateY(-1px);filter:brightness(1.1)}

.qty-value{text-align:center;font-size:15px;font-weight:700}

.remove-button{width:38px;height:38px;display:grid;place-items:center;margin-left:5px;border:1px solid var(--red);border-radius:10px;background:rgba(255,61,53,.04);color:var(--red);cursor:pointer;transition:background .2s}

.remove-button:hover{background:rgba(255,61,53,.15)}

.remove-button svg{width:20px;height:20px}

.line-total{grid-column:4;text-align:left;margin-top:-7px;color:#e5fff0;font-size:12px;white-space:nowrap}

.summary-totals{padding-top:13px}

.summary-row{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:8px 0;font-size:16px}

.summary-row strong{font-size:16px;font-weight:800;white-space:nowrap}

.summary-rule{height:1px;margin:8px 0 13px;background:rgba(0,237,145,.22)}

.total-row{display:flex;align-items:center;justify-content:space-between;gap:15px;padding:2px 0 15px}

.total-row span:first-child{font-size:23px;font-weight:800;letter-spacing:-.4px}

.total-amount{color:var(--green);font-size:33px;font-weight:800;letter-spacing:-.7px;white-space:nowrap}

.place-order-button{display:flex;align-items:center;justify-content:center;gap:12px;width:100%;height:64px;border:0;border-radius:15px;background:linear-gradient(100deg,#43ff9d,#00e77e);color:#00341e;font-size:20px;font-weight:800;box-shadow:0 9px 25px rgba(0,237,145,.18);cursor:pointer;transition:transform .2s,box-shadow .2s}

.place-order-button:hover{transform:translateY(-2px);box-shadow:0 12px 30px rgba(0,237,145,.28)}

.place-order-button:disabled{opacity:.65;cursor:wait;transform:none}

.secure-note{display:flex;align-items:center;justify-content:center;gap:9px;margin-top:15px;color:#c4e8d7;font-size:13px;text-align:center}

.secure-note svg{width:23px;height:23px;color:var(--green);flex:0 0 auto}

.online-note{margin-top:12px;padding:11px 12px;border:1px solid rgba(255,214,41,.25);border-radius:10px;color:#f6e9a8;font-size:12px;line-height:1.5;background:rgba(255,214,41,.05)}


.field-error { display:block; color:#ff8b86; font-size:12px; margin-top:6px; line-height:1.4; }
.form-control.invalid { border-color:#ff625b !important; box-shadow:0 0 0 3px rgba(255,98,91,.12); }
.validation-summary { padding:14px 16px; margin:0 0 18px; border:1px solid #ff625b; border-radius:12px; background:rgba(255,60,53,.09); color:#ffe3e1; }
.validation-summary strong { display:block; margin-bottom:5px; }
.validation-summary ul { margin:6px 0 0 20px; }
.validation-summary[hidden] { display:none !important; }

[hidden]{display:none!important}

@media(max-width:1150px){.checkout-grid{grid-template-columns:minmax(0,1fr) minmax(0,.95fr);gap:15px}.delivery-panel,.payment-panel{padding:18px}.summary-panel{padding:18px}.order-item{grid-template-columns:58px minmax(85px,1fr) 76px;gap:9px}.order-item-image{width:58px;height:66px}.item-actions{grid-template-columns:32px 22px 32px 34px;gap:5px}.qty-button{width:32px;height:34px}.remove-button{width:34px;height:34px}.payment-option label{gap:11px;padding:10px}.payment-brands{gap:5px}.brand{min-width:48px;height:36px;padding:4px}.brand.upi{min-width:56px}}

@media(max-width:900px){.checkout-grid{grid-template-columns:minmax(0,1fr)}.summary-panel{grid-row:1}.left-column{grid-row:2}.summary-panel{position:static}.order-item{grid-template-columns:66px minmax(100px,1fr) 90px;gap:13px}.order-item-image{width:66px;height:76px}.item-actions{grid-template-columns:36px 26px 36px 38px;gap:8px}.qty-button{width:36px;height:38px}.remove-button{width:38px;height:38px}.brand{min-width:58px;height:42px}.brand.upi{min-width:68px}}

@media(max-width:560px){.form-grid{grid-template-columns:minmax(0,1fr)}.checkout-page{width:94%;margin-top:16px}.page-heading{gap:12px}.heading-icon{width:58px;height:58px;border-radius:18px}.heading-icon svg{width:32px;height:32px}.page-heading h1{font-size:31px}.page-heading p{font-size:13px}.delivery-panel,.payment-panel,.summary-panel{padding:15px;border-radius:17px}.panel-heading h2,.summary-heading h2{font-size:19px}.panel-heading p,.summary-heading p{font-size:12px}.panel-icon,.summary-icon{width:44px;height:44px}.form-grid{gap:13px 12px}.form-group label{font-size:12px}.form-control{height:43px;padding:0 11px;font-size:13px}.restaurant-image{width:68px;height:68px}.restaurant-name{font-size:16px}.restaurant-cuisine{font-size:12px}.restaurant-rating{font-size:13px}.order-item{grid-template-columns:52px minmax(70px,1fr) 68px;gap:9px;padding:10px 0}.order-item-image{width:52px;height:58px}.order-item-name{font-size:13px}.order-item-unit-price{font-size:12px}.order-item{align-items:center}.payment-option label{gap:9px}.payment-symbol{width:35px}.payment-symbol svg{width:35px}.payment-copy strong{font-size:13px}.payment-copy small{font-size:10px}.payment-brands{gap:4px}.brand{height:30px;min-width:37px;padding:3px}.brand.upi{min-width:44px}.brand svg{max-width:43px}.total-row span:first-child{font-size:18px}.total-amount{font-size:27px}.place-order-button{height:54px;font-size:17px}.summary-row,.summary-row strong{font-size:14px}}

@media(prefers-reduced-motion:reduce){*{scroll-behavior:auto!important;transition:none!important}}

</style>

</head>

<body>

<%@ include file="components/navbar.jsp" %>



<main class="checkout-page">

    <a class="back-cart" href="<%= cp %>/cart"><span aria-hidden="true">←</span> Back to Cart</a>



    <header class="page-heading">

        <div class="heading-icon" aria-hidden="true">

            <svg viewBox="0 0 48 48" fill="none"><rect x="7" y="11" width="34" height="27" rx="3" stroke="currentColor" stroke-width="3"/><path d="M8 18h32M13 29h11" stroke="currentColor" stroke-width="3" stroke-linecap="round"/></svg>

        </div>

        <div><h1>Checkout</h1><p>Almost there! Complete your details.</p></div>

    </header>
<div id="validationSummary" class="validation-summary" role="alert" aria-live="assertive" hidden>
    <strong>Please correct these details:</strong>
    <ul id="validationList"></ul>
</div>

<form id="checkoutForm" method="post" action="<%= cp %>/place-order" novalidate>
<input type="hidden" id="payment" name="payment" value="COD">
<div class="checkout-grid">

				<div class="left-column">

					<section class="panel delivery-panel">

						<div class="panel-heading">

							<div class="panel-icon" aria-hidden="true">

								<svg viewBox="0 0 32 32" fill="none">

									<path

										d="M16 28s10-9.4 10-16A10 10 0 0 0 6 12c0 6.6 10 16 10 16Z"

										stroke="currentColor" stroke-width="2.5" />

									<circle cx="16" cy="12" r="3.5" stroke="currentColor"

										stroke-width="2.5" /></svg>

							</div>

							<div>

								<h2 style="color: var(--teal)">Delivery Details</h2>

								<p>Where should we deliver your order?</p>

							</div>

						</div>

						<div class="form-grid">

							<div class="form-group">

								<label for="fullName">Full Name <span class="required">*</span></label><input

									class="form-control" id="fullName" name="fullName"

									value="<%= escFullName %>" placeholder="Enter your full name"

									maxlength="100" autocomplete="name" required>

							</div>

							<div class="form-group">

								<label for="phone">Phone Number <span class="required">*</span></label><input

									class="form-control" type="tel" id="phone" name="phone"

									value="<%= escPhone %>" placeholder="10-digit mobile number"

									inputmode="numeric" pattern="[6-9][0-9]{9}" maxlength="10"

									autocomplete="tel" required>

							</div>

							<div class="form-group">

								<label for="addressLine1">Address Line 1 <span

									class="required">*</span></label><input class="form-control"

									id="addressLine1" name="addressLine1"

									value="<%= escAddress1 %>"

									placeholder="House / Flat number, street" maxlength="180"

									autocomplete="address-line1" required>

							</div>

							<div class="form-group">

								<label for="addressLine2">Address Line 2 (Optional)</label><input

									class="form-control" id="addressLine2" name="addressLine2"

									value="<%= escAddress2 %>"

									placeholder="Landmark, apartment, area" maxlength="180"

									autocomplete="address-line2">

							</div>

							<div class="form-group">

								<label for="city">City <span class="required">*</span></label><input

									class="form-control" id="city" name="city"

									value="<%= escCity %>" placeholder="Bengaluru" maxlength="70"

									autocomplete="address-level2" required>

							</div>

							<div class="form-group">

								<label for="state">State <span class="required">*</span></label><select

									class="form-control" id="state" name="state"

									autocomplete="address-level1" required>

									<option value="Andhra Pradesh"

										<%= "Andhra Pradesh".equals(state) ? "selected" : "" %>>Andhra

										Pradesh</option>

									<option value="Karnataka"

										<%= "Karnataka".equals(state) ? "selected" : "" %>>Karnataka</option>

									<option value="Kerala"

										<%= "Kerala".equals(state) ? "selected" : "" %>>Kerala</option>

									<option value="Tamil Nadu"

										<%= "Tamil Nadu".equals(state) ? "selected" : "" %>>Tamil

										Nadu</option>

									<option value="Telangana"

										<%= "Telangana".equals(state) ? "selected" : "" %>>Telangana</option>

									<option value="Maharashtra"

										<%= "Maharashtra".equals(state) ? "selected" : "" %>>Maharashtra</option>

									<option value="Other"

										<%= "Other".equals(state) ? "selected" : "" %>>Other</option>

								</select>

							</div>

							<div class="form-group">

								<label for="pinCode">Pin Code <span class="required">*</span></label><input

									class="form-control" type="text" id="pinCode" name="pinCode"

									value="<%= escPinCode %>" placeholder="6-digit PIN code"

									inputmode="numeric" pattern="[1-9][0-9]{5}" maxlength="6"

									autocomplete="postal-code" required>

							</div>

							<div class="form-group">

								<label for="country">Country <span class="required">*</span></label><select

									class="form-control" id="country" name="country"

									autocomplete="country-name" required><option

										value="India" <%= "India".equals(country) ? "selected" : "" %>>India</option>

									<option value="Other"

										<%= "Other".equals(country) ? "selected" : "" %>>Other</option></select>

							</div>

						</div>

					</section>



					<section class="panel payment-panel">

						<div class="panel-heading">

							<div class="panel-icon" aria-hidden="true">

								<svg viewBox="0 0 32 32" fill="none">

									<rect x="3.5" y="6" width="25" height="20" rx="3"

										stroke="currentColor" stroke-width="2.5" />

									<path d="M4 12h24M8 20h7" stroke="currentColor"

										stroke-width="2.5" stroke-linecap="round" /></svg>

							</div>

							<div>

								<h2 style="color: var(--teal)">Payment Method</h2>

								<p>Choose how you want to pay</p>

							</div>

						</div>

						<div class="payment-options">

							<div class="payment-option">

								<input type="radio" id="cod" name="paymentMethod" value="COD"

									checked> <label for="cod"> <span

									class="radio-mark" aria-hidden="true"></span> <span

									class="payment-symbol" aria-hidden="true"><svg

											viewBox="0 0 52 46" fill="none">

											<path

												d="M8 27c5-2 8-2 12 0l7 4c2 1 5 0 7-2l9-8c2-2 5 1 3 3L34 38c-2 2-5 3-8 2l-13-4H8"

												stroke="currentColor" stroke-width="3"

												stroke-linecap="round" stroke-linejoin="round" />

											<path

												d="M25 7c-5 0-8 3-8 7 0 9 15 5 15 12 0 4-4 7-9 7m0-29v31"

												stroke="currentColor" stroke-width="3"

												stroke-linecap="round" />

											<path d="M19 12h13" stroke="currentColor" stroke-width="3"

												stroke-linecap="round" /></svg></span> <span class="payment-copy"><strong>Cash

											on Delivery</strong><small>Pay when your order arrives at your

											doorstep</small></span>

								</label>

							</div>

							<div class="payment-option">

								<input type="radio" id="online" name="paymentMethod"

									value="ONLINE"> <label for="online"> <span

									class="radio-mark" aria-hidden="true"></span> <span

									class="payment-symbol" aria-hidden="true"><svg

											viewBox="0 0 52 46" fill="none">

											<rect x="3" y="8" width="46" height="30" rx="4"

												stroke="currentColor" stroke-width="3" />

											<path d="M4 16h44M10 28h13" stroke="currentColor"

												stroke-width="3" stroke-linecap="round" /></svg></span> <span

									class="payment-copy"><strong>Online Payment</strong><small>Pay

											securely with card, UPI or net banking</small></span> <span

									class="payment-brands"

									aria-label="UPI, Visa, Mastercard and Google Pay"> <span

										class="brand upi" title="UPI"><svg viewBox="0 0 70 32"

												role="img" aria-label="UPI">

												<path d="M5 4h6L5 27H0z" fill="#f7a928" />

												<path d="M15 4h6l-6 23H9z" fill="#36b66b" />

												<path d="M25 4h6l-6 23h-6z" fill="#e94d65" />

												<text x="32" y="22" font-size="17" font-weight="800"

													font-style="italic" fill="#fff">UPI</text></svg></span> <span

										class="brand visa" title="Visa"><svg

												viewBox="0 0 60 32" role="img" aria-label="Visa">

												<text x="3" y="23" font-size="25" font-weight="900"

													font-style="italic" fill="#fff">VISA</text></svg></span> <span

										class="brand mastercard" title="Mastercard"><svg

												viewBox="0 0 54 32" role="img" aria-label="Mastercard">

												<circle cx="21" cy="16" r="12" fill="#eb001b" />

												<circle cx="33" cy="16" r="12" fill="#f79e1b" />

												<path d="M27 6.8a12 12 0 0 1 0 18.4 12 12 0 0 1 0-18.4"

													fill="#ff5f00" /></svg></span> <span class="brand gpay"

										title="Google Pay"><svg viewBox="0 0 54 32" role="img"

												aria-label="Google Pay">

												<path d="M16 4 4 16l12 12 5-5-7-7 7-7z" fill="#34a853" />

												<path d="m16 4 6 6-7 6 7 6-6 6 12-12z" fill="#4285f4" />

												<path d="m28 16 7-7-6-5-7 7z" fill="#fbbc04" />

												<path d="m28 16 7 7-6 5-7-7z" fill="#ea4335" />

												<text x="36" y="20" font-size="10" font-weight="800"

													fill="#fff">G</text></svg></span>

								</span>

								</label>

							</div>

						</div>

						<div class="online-note" id="onlineNote" hidden>Online

							payment is a visual option until a real payment gateway is

							configured. Selecting it will not charge your card or UPI

							account.</div>

					</section>

				</div>



				<aside class="panel summary-panel">

					<div class="summary-heading">

						<div class="summary-icon" aria-hidden="true">

							<svg viewBox="0 0 32 32" fill="none">

								<rect x="7" y="5" width="18" height="23" rx="2"

									stroke="currentColor" stroke-width="2.5" />

								<rect x="12" y="3" width="8" height="5" rx="1.5"

									stroke="currentColor" stroke-width="2.5" />

								<path d="M11 13h10M11 18h10M11 23h7" stroke="currentColor"

									stroke-width="2" stroke-linecap="round" /></svg>

						</div>

						<div>

							<h2>Order Summary</h2>

							<p>Review your order details</p>

						</div>

					</div>



					<div class="restaurant-card">

						<img class="restaurant-image"

							src="https://images.unsplash.com/photo-1567337710282-00832b415979?auto=format&fit=crop&w=240&q=80"

							alt="Restaurant food"

							onerror="this.onerror=null;this.src='https://placehold.co/160x160/073a28/eafff0?text=Food';">

						<div>

							<div class="restaurant-name"><%= safeRestaurantName %></div>

							<div class="restaurant-cuisine">Restaurant selection</div>

							<div class="restaurant-rating">

								<span class="star">★</span><strong>FoodieHub</strong><span

									class="reviews">Order summary</span>

							</div>

						</div>

					</div>



					<div class="items-list">

						<% if (checkoutItems != null) {

                    for (CartItem item : checkoutItems) {

                        if (item == null) continue;

                        String itemName = item.getItemName() == null ? "Food item" : item.getItemName();

                        String safeItemName = itemName.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");

                        String imagePath = item.getImagePath() == null ? "" : item.getImagePath().trim();

                        String safeImagePath = imagePath.replace("&","&amp;").replace("\"","&quot;").replace("<","&lt;").replace(">","&gt;");

                        String placeholder = "https://placehold.co/140x140/073a28/eafff0?text=Food";

                        double lineTotal = item.getPrice() * item.getQuantity();

                %>

						<div class="order-item">

							<img class="order-item-image"

								src="<%= safeImagePath.isEmpty() ? placeholder : safeImagePath %>"

								alt="<%= safeItemName %>"

								onerror="this.onerror=null;this.src='https://placehold.co/140x140/073a28/eafff0?text=Food';">

							<div>

								<div class="order-item-name"><%= safeItemName %></div>

								<div class="order-item-restaurant"><%= safeRestaurantName %></div>

							</div>

							<div class="order-item-unit-price">

								₹<%= String.format(Locale.US, "%.2f", item.getPrice()) %></div>

						</div>

						<%  }

                   } %>

					</div>



					<div class="summary-totals">

						<div class="summary-row">

							<span>Items (<%= checkoutItemCount %>)

							</span><strong>₹<%= String.format(Locale.US, "%.2f", itemTotal) %></strong>

						</div>

						<div class="summary-row">

							<span>Delivery Fee</span><strong>₹<%= String.format(Locale.US, "%.2f", deliveryFee) %></strong>

						</div>

						<div class="summary-row">

							<span>Platform Fee</span><strong>₹<%= String.format(Locale.US, "%.2f", platformFee) %></strong>

						</div>

						<div class="summary-rule"></div>

						<div class="total-row">

							<span>Total Amount</span><span class="total-amount">₹<%= String.format(Locale.US, "%.2f", grandTotal) %></span>

						</div>

					</div>



					<input type="hidden" name="restaurantId"

						value="<%= checkoutCart.getRestaurantId() %>"> <input

						type="hidden" name="itemTotal"

						value="<%= String.format(Locale.US, "%.2f", itemTotal) %>">

					<input type="hidden" name="deliveryFee"

						value="<%= String.format(Locale.US, "%.2f", deliveryFee) %>">

					<input type="hidden" name="platformFee"

						value="<%= String.format(Locale.US, "%.2f", platformFee) %>">

					<button class="place-order-button" type="submit"

						id="placeOrderButton">

						Place Order <span aria-hidden="true">→</span>

					</button>

					<div class="secure-note">

						<svg viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">

							<path

								d="M12 2 3 6v5c0 5.6 3.8 9.5 9 11 5.2-1.5 9-5.4 9-11V6l-9-4Zm-1.1 14.5-3.2-3.2 1.6-1.6 1.6 1.6 4.2-4.2 1.6 1.6-5.8 5.8Z" /></svg>

						Your information is secured and safe with us

					</div>

				</aside>

			</div>

		</form>

	</main>



<script>
(function () {
    const form = document.getElementById('checkoutForm');
    const placeButton = document.getElementById('placeOrderButton');
    const phone = document.getElementById('phone');
    const pin = document.getElementById('pinCode');
    const online = document.getElementById('online');
    const cod = document.getElementById('cod');
    const paymentValue = document.getElementById('payment');
    const onlineNote = document.getElementById('onlineNote');
    const summary = document.getElementById('validationSummary');
    const errorList = document.getElementById('validationList');
    if (!form) return;

    const rules = [
        { id:'fullName', label:'Full Name', check:v => /^[A-Za-z][A-Za-z .\'-]{1,99}$/.test(v), message:'Enter your full name. Min 2 characters.' },
        { id:'phone', label:'Phone Number', check:v => /^[6-9][0-9]{9}$/.test(v), message:'Enter a valid 10-digit Indian mobile number.' },
        { id:'addressLine1', label:'Address Line 1', check:v => v.length >= 5 && /[A-Za-z]/.test(v) && /[A-Za-z0-9]/.test(v), message:'Enter your house or flat number and street.' },
        { id:'city', label:'City', check:v => /^[A-Za-z][A-Za-z .\'-]{1,69}$/.test(v), message:'Enter a valid city name using letters.' },
        { id:'state', label:'State', check:v => v !== '', message:'Select your state.' },
        { id:'pinCode', label:'PIN Code', check:v => /^[1-9][0-9]{5}$/.test(v), message:'Enter a valid 6-digit Indian PIN code that does not start with zero.' },
        { id:'country', label:'Country', check:v => v !== '', message:'Select your country.' }
    ];

    function errorElement(field) {
        let el = document.getElementById(field.id + 'Error');
        if (!el) {
            el = document.createElement('span');
            el.id = field.id + 'Error';
            el.className = 'field-error';
            el.setAttribute('aria-live', 'polite');
            field.insertAdjacentElement('afterend', el);
        }
        return el;
    }

    function validateField(rule) {
        const field = document.getElementById(rule.id);
        if (!field) return null;
        const value = field.value.trim();
        let message = '';
        if (!value) message = rule.label + ' is required.';
        else if (!rule.check(value)) message = rule.message;
        field.classList.toggle('invalid', Boolean(message));
        field.setAttribute('aria-invalid', message ? 'true' : 'false');
        errorElement(field).textContent = message;
        return message ? { field, label:rule.label, message } : null;
    }

    function validateAll() {
        const errors = [];
        rules.forEach(rule => {
            const result = validateField(rule);
            if (result) errors.push(result);
        });
        const address2 = document.getElementById('addressLine2');
        if (address2 && /[\u0000-\u001F\u007F]/.test(address2.value)) {
            address2.classList.add('invalid');
            let el = document.getElementById('addressLine2Error');
            if (!el) {
                el = document.createElement('span');
                el.id = 'addressLine2Error';
                el.className = 'field-error';
                address2.insertAdjacentElement('afterend', el);
            }
            el.textContent = 'Remove invalid characters from Address Line 2.';
            errors.push({field:address2, label:'Address Line 2', message:el.textContent});
        }
        errorList.replaceChildren();
        errors.forEach(item => {
            const li = document.createElement('li');
            li.textContent = item.label + ': ' + item.message;
            errorList.appendChild(li);
        });
        summary.hidden = errors.length === 0;
        if (errors.length) {
            errors[0].field.focus();
            errors[0].field.scrollIntoView({behavior:'smooth', block:'center'});
        }
        return errors.length === 0;
    }

    rules.forEach(rule => {
        const field = document.getElementById(rule.id);
        if (field) {
            field.addEventListener('input', () => validateField(rule));
            field.addEventListener('change', () => validateField(rule));
        }
    });
    if (phone) phone.addEventListener('input', () => { phone.value = phone.value.replace(/\D/g, '').slice(0, 10); });
    if (pin) pin.addEventListener('input', () => { pin.value = pin.value.replace(/\D/g, '').slice(0, 6); });
    function updatePaymentNote() {
        if (onlineNote && online) onlineNote.hidden = !online.checked;
        if (paymentValue) paymentValue.value = online && online.checked ? 'Online Payment' : 'COD';
    }
    if (online) online.addEventListener('change', updatePaymentNote);
    if (cod) cod.addEventListener('change', updatePaymentNote);

    form.addEventListener('submit', function (event) {
        event.preventDefault();

        updatePaymentNote();

        if (!validateAll() || placeButton.disabled) {
            return;
        }

        placeButton.disabled = true;
        placeButton.textContent = 'Opening Payment...';

        // Send checkout details to the existing controller, which redirects to payment.jsp.
        form.action = '<%= cp %>/start-demo-payment';
        form.submit();
    });

    updatePaymentNote();
})();
</script>

</body>

</html>
