<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Locale" %>
<%@ page import="com.tap.model.Order" %>
<%@ page import="com.tap.model.Cart" %>
<%
    String cp = request.getContextPath();
    // This page is shown BEFORE PlaceOrderController saves the new order.
    // Use the active cart and the payment choice saved by checkout.
    Order paymentOrder = null;
    Cart paymentCart = (Cart) session.getAttribute("cart");

    double paymentAmount = 0.0;
    Object savedAmount = session.getAttribute("pendingPaymentAmount");
    if (savedAmount instanceof Number) {
        paymentAmount = ((Number) savedAmount).doubleValue();
    } else if (paymentCart != null && !paymentCart.isEmpty()) {
        paymentAmount = paymentCart.getTotalAmount() + 30.00 + 10.00;
    }

    String paymentMode = (String) session.getAttribute("selectedOrderPayment");
    if (paymentMode == null || paymentMode.trim().isEmpty()) {
        paymentMode = request.getParameter("paymentMethod");
    }
    if (paymentMode == null || paymentMode.trim().isEmpty()) {
        paymentMode = "Online Payment";
    }
    String paymentOrderId = "";

    boolean isCashOnDelivery = paymentMode != null &&
        (paymentMode.trim().equalsIgnoreCase("COD") ||
         paymentMode.trim().equalsIgnoreCase("Cash on Delivery") ||
         paymentMode.trim().toUpperCase(Locale.ROOT).contains("CASH ON DELIVERY"));
    String safePaymentMode = paymentMode.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payment Processing | FoodieHub</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap" rel="stylesheet">
<style>
:root{--bg:#001b13;--panel:rgba(0,31,22,.9);--green:#00ed91;--mint:#79ffc0;--teal:#16e8cf;--text:#f4fff8;--muted:#b2d3c3;--border:rgba(0,237,145,.28);--gold:#ffdf35}
*{box-sizing:border-box;margin:0;padding:0}
body{min-height:100vh;overflow-x:hidden;background:#00180f;color:var(--text);font-family:'DM Sans',Arial,sans-serif;padding-top:72px}
body:before{content:"";position:fixed;inset:0;z-index:-2;background:url('https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=2200&q=85') center/cover no-repeat;filter:saturate(1.15)}
body:after{content:"";position:fixed;inset:0;z-index:-1;background:linear-gradient(90deg,rgba(0,20,13,.83),rgba(0,27,18,.80),rgba(0,20,13,.86)),radial-gradient(circle at 50% 30%,rgba(0,237,145,.13),transparent 55%)}
a{text-decoration:none;color:inherit}
.site-header{height:72px;position:fixed;top:0;left:0;right:0;z-index:20;display:flex;align-items:center;justify-content:space-between;gap:22px;padding:0 clamp(18px,5vw,76px);background:rgba(0,29,20,.97);border-bottom:1px solid rgba(0,237,145,.15);box-shadow:0 8px 28px rgba(0,0,0,.14);backdrop-filter:blur(14px)}.site-brand{display:flex;align-items:center;gap:11px;white-space:nowrap;font-size:25px;font-weight:800;letter-spacing:-1px}.site-brand-icon{width:43px;height:43px;display:grid;place-items:center;border-radius:50%;background:linear-gradient(135deg,#ff6b4a,#ff3c2f);font-size:23px}.site-brand span span{color:#ff6448}.site-nav{display:flex;align-items:center;gap:clamp(15px,2.5vw,34px);font-size:13px;font-weight:700;white-space:nowrap}.site-nav a{color:#ecfff5;transition:color .2s}.site-nav a:hover{color:var(--green)}.header-right{display:flex;align-items:center;gap:13px}.header-search{height:34px;width:clamp(125px,15vw,205px);display:flex;align-items:center;gap:7px;padding:0 11px;border:1px solid rgba(0,237,145,.22);border-radius:18px;background:rgba(0,0,0,.18);color:#a9c9b9;font-size:11px}.cart-link{position:relative;width:43px;height:43px;display:grid;place-items:center;border:1px solid rgba(0,237,145,.24);border-radius:13px;font-size:21px}.cart-count{position:absolute;top:-6px;right:-5px;min-width:19px;height:19px;padding:0 4px;display:grid;place-items:center;border-radius:50%;background:#ff4d48;color:white;font-size:10px;font-weight:800}.user-pill{display:flex;align-items:center;gap:9px;padding:5px 12px 5px 5px;border:1px solid rgba(0,237,145,.3);border-radius:24px;font-size:12px;font-weight:800;white-space:nowrap}.user-avatar{width:32px;height:32px;display:grid;place-items:center;border-radius:50%;background:linear-gradient(135deg,#19d981,#087343);border:1px solid rgba(255,255,255,.25)}.payment-page{width:min(1050px,92%);margin:25px auto 45px}
.back-link{display:inline-flex;gap:9px;align-items:center;color:var(--green);font-size:14px;font-weight:800;margin-bottom:20px;transition:gap .2s}
.back-link:hover{gap:14px}
.payment-card{position:relative;overflow:hidden;border:1px solid var(--border);border-radius:24px;padding:clamp(23px,3.2vw,36px);background:linear-gradient(145deg,rgba(0,42,28,.80),rgba(0,19,13,.88));box-shadow:0 24px 75px rgba(0,0,0,.35),0 0 35px rgba(0,237,145,.06)}
.payment-card:before{content:"";position:absolute;width:350px;height:350px;right:-120px;top:-150px;border-radius:50%;background:rgba(0,237,145,.08);filter:blur(8px);pointer-events:none}
.brand-mark{display:flex;justify-content:center;align-items:center;gap:11px;color:#fff;font-size:23px;font-weight:800;letter-spacing:-.7px}
.brand-icon{display:grid;place-items:center;width:45px;height:45px;border-radius:50%;background:linear-gradient(135deg,#ff6b4a,#ff3c2f);font-size:24px;box-shadow:0 0 22px rgba(255,82,57,.2)}
.brand-mark span span{color:#ff6448}
.page-title{text-align:center;margin-top:12px;font-size:clamp(24px,3.2vw,32px);font-weight:800;letter-spacing:-.7px}
.page-subtitle{text-align:center;margin-top:8px;color:#c4e5d5;font-size:15px}
.amount-chip{width:max-content;max-width:100%;margin:13px auto 18px;padding:6px 17px;border:1px solid rgba(0,237,145,.25);border-radius:999px;background:rgba(0,237,145,.05);text-align:center}.amount-chip small{font-size:9px}.amount-chip strong{font-size:19px}
.amount-chip small{display:block;color:#b5d8c7;font-size:11px;text-transform:uppercase;letter-spacing:1.5px}
.amount-chip strong{display:block;margin-top:3px;color:var(--green);font-size:28px;font-weight:800}
.steps{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));position:relative;gap:8px;margin:0 auto 22px;max-width:780px}
.steps:before{content:"";position:absolute;left:12%;right:12%;top:23px;height:2px;background:linear-gradient(90deg,var(--green),rgba(0,237,145,.2));z-index:0}
.step{text-align:center;position:relative;z-index:1}
.step-circle{display:grid;place-items:center;width:48px;height:48px;margin:0 auto 10px;border:2px solid var(--green);border-radius:50%;background:#063b29;color:var(--mint);box-shadow:0 0 18px rgba(0,237,145,.16);font-size:20px;font-weight:800}
.step.active .step-circle{background:var(--green);color:#00331e;box-shadow:0 0 0 7px rgba(0,237,145,.08),0 0 30px rgba(0,237,145,.45);animation:pulse 1.6s infinite}
.step.done .step-circle{background:linear-gradient(135deg,#00ed91,#6dffb4);color:#00331e}
.step-label{font-size:12px;font-weight:700;color:#e7fff0}
.step-caption{margin-top:4px;color:#91bba4;font-size:10px}
@keyframes pulse{0%,100%{box-shadow:0 0 0 5px rgba(0,237,145,.06),0 0 20px rgba(0,237,145,.25)}50%{box-shadow:0 0 0 10px rgba(0,237,145,.02),0 0 32px rgba(0,237,145,.55)}}
.illustration{display:flex;align-items:center;justify-content:center;gap:clamp(20px,6vw,75px);margin:2px auto 18px;min-height:120px}
.device{width:75px;height:105px;border:3px solid #77aaff;border-radius:17px;background:linear-gradient(145deg,#0a2861,#04152f);box-shadow:0 0 20px rgba(69,139,255,.35),inset 0 0 0 3px #102f6a;display:flex;align-items:center;justify-content:center;position:relative}
.device:before{content:"";position:absolute;top:7px;left:50%;transform:translateX(-50%);width:25px;height:4px;border-radius:8px;background:#77aaff}
.device svg{width:45px;height:45px;color:#a5d4ff}
.transfer-path{width:clamp(50px,12vw,140px);height:50px;position:relative}
.transfer-path:before{content:"";position:absolute;left:0;right:0;top:25px;border-top:3px dashed var(--green);filter:drop-shadow(0 0 5px rgba(0,237,145,.7))}
.transfer-dot{position:absolute;top:18px;left:0;width:14px;height:14px;border-radius:50%;background:#d7ff5b;box-shadow:0 0 18px #00ed91;animation:travel 2s linear infinite}
@keyframes travel{0%{left:0;opacity:.25}15%{opacity:1}85%{opacity:1}100%{left:calc(100% - 14px);opacity:.25}}
.rupee-orb{width:76px;height:76px;display:grid;place-items:center;border:2px solid #ffe08a;border-radius:50%;background:radial-gradient(circle,#fff1a6 0,#d99a16 48%,#704508 100%);color:#fffdf0;font-size:47px;font-weight:800;text-shadow:0 0 10px #fff2bd;box-shadow:0 0 0 8px rgba(255,196,55,.10),0 0 35px rgba(255,190,35,.48);animation:orb 2.3s ease-in-out infinite}
.success-splash{position:fixed;inset:0;z-index:1000;overflow-y:auto;background:linear-gradient(145deg,#079b60,#00a86b 55%,#078b58);display:flex;justify-content:center;align-items:stretch;padding:22px 16px;color:#fff;text-align:center}.success-splash[hidden]{display:none}.success-inner{width:min(520px,100%);min-height:calc(100vh - 44px);display:flex;flex-direction:column;align-items:center}.success-countdown{font-size:clamp(17px,3.5vw,22px);color:#d9ffeb;margin:12px 0}.success-title{font-size:clamp(30px,6vw,43px);letter-spacing:-1px;line-height:1.12}.success-check{width:138px;height:138px;flex:0 0 auto;margin:auto 0;display:grid;place-items:center;border:11px solid #b9ff36;border-radius:50%;background:#16d783;box-shadow:0 0 0 9px #08a76a,0 0 45px #baff3670;font-size:76px;font-weight:800;color:#d7ff7a;animation:successPop .7s cubic-bezier(.2,.8,.2,1) both}.success-receipt{width:100%;text-align:left;background:#fff3e7;color:#241d18;border-radius:22px;padding:24px;box-shadow:0 14px 34px #004b3433}.success-receipt-top{display:flex;justify-content:space-between;align-items:flex-start;gap:12px;font-size:16px;font-weight:800}.success-amount{font-size:clamp(24px,5vw,32px);white-space:nowrap}.success-date{margin-top:12px;color:#81776f;font-size:14px}.success-rule{border-top:1px dashed #d9cfc4;margin:18px 0 15px}.success-reference{display:flex;justify-content:space-between;align-items:center;gap:10px;color:#5b514a;overflow-wrap:anywhere}.success-reference strong{color:#29231f;font-size:13px}.success-disclaimer{font-size:11px;line-height:1.5;color:#71675f;margin-top:14px}.success-powered{background:#fff9f1;color:#84786f;border-radius:18px;padding:13px 24px;margin-top:16px;font-size:13px}.success-powered strong{color:#187b52;margin-left:8px}@keyframes successPop{0%{transform:scale(.55);opacity:0}75%{transform:scale(1.08)}100%{transform:scale(1);opacity:1}}
@keyframes orb{50%{transform:translateY(-5px) scale(1.04);box-shadow:0 0 0 12px rgba(0,237,145,.04),0 0 46px rgba(0,237,145,.6)}}
.bank{width:88px;height:80px;color:#7eb9ff;filter:drop-shadow(0 0 12px rgba(74,142,255,.5))}.bank .bank-bolt{fill:#fff;stroke:#fff;filter:drop-shadow(0 0 5px rgba(255,255,255,.95))}
.progress-wrap{max-width:650px;margin:0 auto}
.progress-top{display:flex;justify-content:space-between;align-items:center;margin-bottom:9px;color:#d8f7e6;font-size:13px;font-weight:700}
.progress-track{height:16px;padding:3px;border:1px solid rgba(0,237,145,.35);border-radius:999px;background:#00180f;overflow:hidden;box-shadow:inset 0 2px 6px rgba(0,0,0,.4)}
.progress-bar{width:0;height:100%;border-radius:999px;background:linear-gradient(90deg,#39ed70,#a1ff55,#00ed91);box-shadow:0 0 17px rgba(0,237,145,.65);transition:width .5s ease}
.progress-percent{text-align:center;margin-top:8px;color:#fff;font-size:16px;font-weight:800}
.demo-note{display:flex;justify-content:center;gap:9px;align-items:flex-start;margin:15px auto 0;max-width:690px;color:#c0dfce;font-size:12px;line-height:1.6;text-align:center}
.demo-note span{color:var(--gold);font-size:17px;line-height:1}
.footer-actions{display:flex;justify-content:center;flex-wrap:wrap;gap:12px;margin-top:25px}
.action-button{display:inline-flex;align-items:center;justify-content:center;min-height:46px;padding:0 20px;border-radius:12px;border:1px solid rgba(0,237,145,.35);font-size:13px;font-weight:800;transition:transform .2s,filter .2s}
.action-button:hover{transform:translateY(-2px);filter:brightness(1.08)}
.action-primary{background:linear-gradient(100deg,#42ff9d,#00e77e);color:#00341e;border:0}
.action-secondary{background:rgba(0,237,145,.04);color:#dfffee}
.status-message{text-align:center;margin-top:16px;color:var(--mint);font-size:13px;min-height:20px}
@media(max-width:760px){body{padding-top:64px}.site-header{height:64px;padding:0 13px;gap:10px}.site-brand{font-size:19px;gap:7px}.site-brand-icon{width:35px;height:35px;font-size:19px}.site-nav{gap:10px;font-size:11px}.header-search{display:none}.header-right{gap:7px}.user-pill{font-size:10px;padding-right:8px}.user-avatar{width:29px;height:29px}.cart-link{width:37px;height:37px}}@media(max-width:600px){.site-nav{display:none}.payment-page{width:94%;margin:15px auto 25px}.payment-card{padding:24px 16px;border-radius:20px}.brand-mark{font-size:20px}.steps{gap:3px}.steps:before{left:12%;right:12%}.step-circle{width:39px;height:39px;font-size:16px;margin-bottom:8px}.steps:before{top:19px}.step-label{font-size:10px}.step-caption{font-size:9px}.illustration{gap:13px;min-height:112px}.device{width:62px;height:95px}.device svg{width:32px}.rupee-orb{width:65px;height:65px;font-size:35px}.bank{width:66px;height:70px}.transfer-path{width:35px}.amount-chip strong{font-size:24px}.page-subtitle{font-size:13px}}
@media(prefers-reduced-motion:reduce){*,*:before,*:after{animation:none!important;transition:none!important}}
</style>
</head>
<body>
<header class="site-header">
    <a class="site-brand" href="<%= cp %>/restaurant"><span class="site-brand-icon">🍴</span><span>Foodie<span>Hub</span></span></a>
    <nav class="site-nav" aria-label="Main navigation">
        <a href="<%= cp %>/restaurant">Home</a>
        <a href="<%= cp %>/restaurant">Restaurants</a>
        <a href="<%= cp %>/orders">My Orders</a>
        <a href="<%= cp %>/help.jsp">Help</a>
    </nav>
    <div class="header-right">
        <div class="header-search">⌕ <span>Search for restaurants, dishes...</span></div>
        <a class="cart-link" href="<%= cp %>/cart" aria-label="View cart">🛒<span class="cart-count"><%= (paymentCart != null && paymentCart.getItems() != null) ? paymentCart.getItems().size() : 0 %></span></a>
        <div class="user-pill"><span class="user-avatar">H</span><span>Hemanth</span><span style="color:var(--green)">⌄</span></div>
    </div>
</header>
<main class="payment-page">
    <a class="back-link" href="<%= cp %>/checkout.jsp" style="margin-bottom:12px">← Back to Checkout</a>
    <section class="payment-card">
        <div class="brand-mark"><div class="brand-icon">🍴</div><span>Foodie<span>Hub</span></span></div>
        <h1 class="page-title" id="pageTitle">Processing Your Payment</h1>
        <p class="page-subtitle" id="pageSubtitle">Please wait while we securely process your payment.</p>
        <p style="margin:8px auto 0;text-align:center;color:#b7dcc9;font-size:12px">Payment method: <strong style="color:#79ffc0"><%= safePaymentMode %></strong></p>
        <div class="amount-chip"><small>Order total</small><strong>₹<%= String.format(Locale.US, "%.2f", paymentAmount) %></strong></div>

        <div class="steps" aria-label="Payment progress">
            <div class="step active" id="step1"><div class="step-circle">①</div><div class="step-label">Initiating</div><div class="step-caption">Payment</div></div>
            <div class="step" id="step2"><div class="step-circle">②</div><div class="step-label">Verifying</div><div class="step-caption">Securely</div></div>
            <div class="step" id="step3"><div class="step-circle">③</div><div class="step-label">Processing</div><div class="step-caption">With Bank</div></div>
            <div class="step" id="step4"><div class="step-circle">④</div><div class="step-label">Finalizing</div><div class="step-caption">Your Order</div></div>
        </div>

        <div class="illustration" aria-hidden="true">
            <div class="device"><svg viewBox="0 0 48 48" fill="none"><rect x="6" y="8" width="36" height="30" rx="4" stroke="currentColor" stroke-width="3"/><path d="M7 16h34M13 25h12M13 31h7" stroke="currentColor" stroke-width="3" stroke-linecap="round"/></svg></div>
            <div class="transfer-path"><span class="transfer-dot"></span></div>
            <div class="rupee-orb">₹</div>
            <div class="transfer-path"><span class="transfer-dot"></span></div>
            <svg class="bank" viewBox="0 0 100 95" fill="none" role="img" aria-label="Bank with lightning bolt"><path d="M7 31 50 8l43 23H7Z" stroke="currentColor" stroke-width="4" stroke-linejoin="round"/><path d="M14 38h72M18 72h64M9 82h82M25 40v30M42 40v30M59 40v30M76 40v30" stroke="currentColor" stroke-width="5" stroke-linecap="round"/><path d="M4 89h92" stroke="currentColor" stroke-width="5" stroke-linecap="round"/><path class="bank-bolt" d="M54 35 39 54h12l-5 17 19-25H53l6-11Z" fill="#fff" stroke="#fff" stroke-width="1.5" stroke-linejoin="round"/></svg>
        </div>

        <div class="progress-wrap">
            <div class="progress-top"><span id="progressLabel">Connecting securely…</span><span id="progressNumber">0%</span></div>
            <div class="progress-track" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0" id="progressTrack"><div class="progress-bar" id="progressBar"></div></div>
            <div class="progress-percent" id="percentText">0%</div>
        </div>

        <p class="demo-note"><span>⚠</span><span>This is a payment UI demonstration only. No money is charged, and this page does not verify a real bank, UPI, or card transaction.</span></p>
        <p class="status-message" id="statusMessage">Keep this page open while the demonstration runs.</p>

        <div class="footer-actions" id="footerActions" hidden>
            <% if (paymentOrder != null) { %>
                <a class="action-button action-primary" href="<%= cp %>/order-success.jsp">Continue to Order Confirmation →</a>
                <a class="action-button action-secondary" href="<%= cp %>/orders">View My Orders</a>
            <% } else { %>
                <a class="action-button action-primary" href="<%= cp %>/checkout.jsp">Return to Checkout →</a>
                <a class="action-button action-secondary" href="<%= cp %>/cart">Back to Cart</a>
            <% } %>
        </div>
    </section>
</main>

<div class="success-splash" id="successSplash" hidden>
    <div class="success-inner">
        <p class="success-countdown"><%= isCashOnDelivery ? "Redirecting to your orders in" : "Redirecting to your order in" %> <strong id="successCountdown">4</strong> seconds</p>
        <h1 class="success-title"><%= isCashOnDelivery ? "Order Placed Successfully!" : "Payment Successful" %></h1>
        <div class="success-check" aria-label="Success">✓</div>
        <section class="success-receipt" aria-label="FoodieHub demo payment receipt">
            <div class="success-receipt-top">
                <span>FOODIEHUB ORDER <%= paymentOrder != null ? "#" + paymentOrder.getOrderId() : "CONFIRMATION" %></span>
                <span class="success-amount">₹<%= String.format(Locale.US, "%.2f", paymentAmount) %></span>
            </div>
            <div class="success-date"><%= isCashOnDelivery ? "Your Cash on Delivery order is confirmed." : "FoodieHub payment confirmation" %></div>
            <div class="success-rule"></div>
            <div class="success-reference">
                <span><%= safePaymentMode %></span>
                <strong><%= paymentOrder != null ? "DEMO-" + paymentOrder.getOrderId() : "DEMO-PAYMENT" %></strong>
            </div>
            <p class="success-disclaimer">Demo confirmation only. No money was charged and this is not a verified UPI, Visa, Mastercard, or bank transaction.</p>
        </section>
        <div class="success-powered">Powered by <strong>FoodieHub</strong></div>
    </div>
</div>

<script>
(function(){
    const isCOD = <%= isCashOnDelivery ? "true" : "false" %>;
    const splash = document.getElementById('successSplash');
    const countdown = document.getElementById('successCountdown');
    const status = document.getElementById('statusMessage');
    let orderSubmissionStarted = false;

    function startCountdown(destination) {
        let seconds = 4;
        countdown.textContent = seconds;
        const timer = window.setInterval(function(){
            seconds--;
            countdown.textContent = seconds;
            if(seconds <= 0){
                window.clearInterval(timer);
                window.location.href = destination;
            }
        }, 1000);
    }

    // Submit the order only after the server can save it in the database.
    function submitOrderToServer() {
        if (orderSubmissionStarted) return;
        orderSubmissionStarted = true;
        status.textContent = 'Saving your order to FoodieHub...';

        const body = new URLSearchParams();
        body.append('payment', isCOD ? 'COD' : 'Online Payment');

        fetch('<%= cp %>/place-order', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: body.toString(),
            credentials: 'same-origin'
        }).then(function(response) {
            return response.text().then(function(responseText) {
                let result;
                try {
                    result = JSON.parse(responseText);
                } catch (parseError) {
                    throw new Error(
                        'The server returned an unexpected response. Check the Eclipse Console.'
                    );
                }

                if (!response.ok || !result || result.success !== true) {
                    throw new Error(
                        result && result.message
                            ? result.message
                            : 'The server could not confirm that your order was saved.'
                    );
                }

                // The AJAX controller returns JSON rather than an HTTP redirect.
                const destination = result.redirect || '<%= cp %>/order-success.jsp';
                splash.hidden = false;
                status.textContent = 'Order saved successfully.';
                startCountdown(destination);
            });
        }).catch(function(error) {
            console.error('[FoodieHub] Place order request failed:', error);
            orderSubmissionStarted = false;
            status.textContent = error.message ||
                'Order could not be saved. Please return to Checkout.';
            const actions = document.getElementById('footerActions');
            if (actions) actions.hidden = false;
        });
    }

    if (isCOD) {
        // COD skips the progress animation, but still must save through the controller.
        submitOrderToServer();
        return;
    }

    const bar = document.getElementById('progressBar');
    const number = document.getElementById('progressNumber');
    const percent = document.getElementById('percentText');
    const track = document.getElementById('progressTrack');
    const label = document.getElementById('progressLabel');
    const steps = [
        document.getElementById('step1'),
        document.getElementById('step2'),
        document.getElementById('step3'),
        document.getElementById('step4')
    ];
    const stages = [
        {limit:25,label:'Initiating payment…',status:'Starting the FoodieHub demo payment.'},
        {limit:50,label:'Verifying securely…',status:'Simulating secure verification.'},
        {limit:75,label:'Processing with bank…',status:'Simulating payment processing. No real transaction is sent.'},
        {limit:100,label:'Finalizing your order…',status:'Saving your order to the database.'}
    ];
    let progress = 0;

    function update(){
        progress = Math.min(100, progress + 1);
        bar.style.width = progress + '%';
        number.textContent = progress + '%';
        percent.textContent = progress + '%';
        track.setAttribute('aria-valuenow', String(progress));

        let stageIndex = stages.findIndex(stage => progress <= stage.limit);
        if (stageIndex < 0) stageIndex = 3;
        label.textContent = stages[stageIndex].label;
        status.textContent = stages[stageIndex].status;

        steps.forEach(function(step, index){
            const stageStart = index * 25;
            const stageEnd = (index + 1) * 25;
            step.classList.toggle('done', progress >= stageEnd);
            step.classList.toggle('active', progress >= stageStart && progress < stageEnd);
        });

        if (progress < 100) {
            window.setTimeout(update, 70);
            return;
        }

        steps.forEach(function(step){
            step.classList.remove('active');
            step.classList.add('done');
        });
        label.textContent = 'Finalizing order…';
        submitOrderToServer();
    }

    window.setTimeout(update, 250);
})();
</script>
</body>
</html>
