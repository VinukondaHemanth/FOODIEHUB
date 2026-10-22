
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    String helpCp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Help Centre | FoodieHub</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap" rel="stylesheet">
<style>
:root {
    --bg: #001a12;
    --panel: #05291e;
    --panel2: #073525;
    --green: #00ed83;
    --bright: #6dffb0;
    --text: #f3fff8;
    --muted: #9bb9aa;
    --border: rgba(105,255,172,.18);
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
    font-family: 'DM Sans', sans-serif;
    color: var(--text);
    background: radial-gradient(ellipse at 10% 5%, #00ed8310, transparent 35%), var(--bg);
}
a {
    text-decoration: none;
    color: inherit;
}
.hero {
    padding: 52px 6% 48px;
    border-bottom: 1px solid var(--border);
    background: linear-gradient(120deg, #00ed8310, transparent);
    text-align: center;
}
.eyebrow {
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 2.5px;
    color: var(--green);
    margin-bottom: 14px;
}
.hero h1 {
    font-family: 'Playfair Display', serif;
    font-size: clamp(36px, 5vw, 54px);
    line-height: 1.15;
}
.hero h1 span {
    color: var(--green);
}
.hero p {
    max-width: 600px;
    margin: 14px auto 0;
    color: var(--muted);
    font-size: 14px;
    line-height: 1.8;
}
.container {
    width: 88%;
    max-width: 1100px;
    margin: 0 auto;
    padding: 38px 0 60px;
}
.quick-links {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
    margin-bottom: 42px;
}
.quick-card {
    padding: 23px;
    border: 1px solid var(--border);
    border-radius: 17px;
    background: linear-gradient(145deg, var(--panel2), var(--panel));
    transition: transform .2s, border-color .2s;
}
.quick-card:hover {
    transform: translateY(-4px);
    border-color: var(--green);
}
.quick-icon {
    width: 46px;
    height: 46px;
    display: grid;
    place-items: center;
    border-radius: 14px;
    background: #00ed8318;
    font-size: 22px;
    margin-bottom: 15px;
}
.quick-card h3 {
    font-size: 16px;
    margin-bottom: 7px;
}
.quick-card p {
    font-size: 12px;
    line-height: 1.7;
    color: var(--muted);
    margin-bottom: 13px;
}
.quick-card a {
    font-size: 12px;
    font-weight: 800;
    color: var(--green);
}
.section-title {
    font-family: 'Playfair Display', serif;
    font-size: 29px;
    margin-bottom: 8px;
}
.section-desc {
    font-size: 13px;
    color: var(--muted);
    margin-bottom: 22px;
}
.faq-list {
    display: grid;
    gap: 12px;
}
details {
    border: 1px solid var(--border);
    border-radius: 14px;
    background: #05291e;
    overflow: hidden;
    transition: border-color .2s;
}
details[open] {
    border-color: #00ed8366;
}
summary {
    cursor: pointer;
    list-style: none;
    padding: 19px 20px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    font-size: 14px;
    font-weight: 700;
}
summary::-webkit-details-marker {
    display: none;
}
summary::after {
    content: "+";
    color: var(--green);
    font-size: 23px;
    font-weight: 500;
}
details[open] summary::after {
    content: "−";
}
.answer {
    padding: 0 20px 20px;
    color: var(--muted);
    font-size: 13px;
    line-height: 1.85;
}
.answer a {
    color: var(--green);
    font-weight: 700;
}
.support {
    margin-top: 42px;
    padding: 29px;
    border: 1px solid var(--border);
    border-radius: 20px;
    background: linear-gradient(110deg, #00ed8312, #05291e);
}
.support h2 {
    font-family: 'Playfair Display', serif;
    font-size: 25px;
    margin-bottom: 9px;
}
.support p {
    color: var(--muted);
    font-size: 13px;
    line-height: 1.8;
    margin-bottom: 18px;
}
.actions {
    display: flex;
    gap: 12px;
    flex-wrap: wrap;
}
.btn {
    display: inline-block;
    padding: 12px 17px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: 800;
    transition: transform .2s;
}
.btn:hover {
    transform: translateY(-2px);
}
.primary {
    background: linear-gradient(100deg, var(--green), var(--bright));
    color: #002416;
}
.secondary {
    border: 1px solid var(--border);
    color: var(--text);
}
.footer {
    text-align: center;
    border-top: 1px solid var(--border);
    padding: 22px;
    color: #789b88;
    font-size: 11px;
    background: #00150e;
}
@media (max-width: 700px) {
    .container {
        width: 92%;
    }
    .quick-links {
        grid-template-columns: 1fr;
    }
    .hero {
        padding: 38px 5%;
    }
    .section-title {
        font-size: 25px;
    }
    .support {
        padding: 23px;
    }
}
</style>
</head>
<body>

<%@ include file="components/navbar.jsp" %>

<header class="hero">
    <div class="eyebrow">FOODIEHUB SUPPORT</div>
    <h1>How can we <span>help?</span></h1>
    <p>Find answers to common questions about your account, restaurants, cart, checkout, and orders.</p>
</header>

<main class="container">
    <section class="quick-links" aria-label="Quick help links">
        <article class="quick-card">
            <div class="quick-icon">👤</div>
            <h3>Account &amp; Login</h3>
            <p>Create an account or sign in to access your FoodieHub account and order history.</p>
            <a href="<%= helpCp %>/login.jsp">Go to Login →</a>
        </article>

        <article class="quick-card">
            <div class="quick-icon">🍽️</div>
            <h3>Restaurants &amp; Menu</h3>
            <p>Browse restaurants, open a restaurant, and choose dishes from its menu.</p>
            <a href="<%= helpCp %>/restaurant">Explore Restaurants →</a>
        </article>

        <article class="quick-card">
            <div class="quick-icon">📦</div>
            <h3>My Orders</h3>
            <p>Review your order history and check the status of your previous orders.</p>
            <a href="<%= helpCp %>/orders">View My Orders →</a>
        </article>
    </section>

    <section aria-labelledby="faqTitle">
        <h2 class="section-title" id="faqTitle">Frequently Asked Questions</h2>
        <p class="section-desc">Choose a question to see its answer.</p>

        <div class="faq-list">
            <details>
                <summary>How do I create a FoodieHub account?</summary>
                <div class="answer">
                    Open the <a href="<%= helpCp %>/signup.jsp">Sign Up page</a>, enter your username, email, phone number, delivery address, and password, then submit the form. Use your registered credentials to log in.
                </div>
            </details>

            <details>
                <summary>What should I do if I cannot log in?</summary>
                <div class="answer">
                    Check that your username and password are correct. If you do not have an account yet, create one using the <a href="<%= helpCp %>/signup.jsp">Sign Up page</a>. If the problem continues, contact the project administrator.
                </div>
            </details>

            <details>
                <summary>How do I order food?</summary>
                <div class="answer">
                    Open <a href="<%= helpCp %>/restaurant">Restaurants</a>, select a restaurant, choose dishes from that restaurant's menu, add the required quantities to your cart, and continue to checkout.
                </div>
            </details>

            <details>
                <summary>Can my cart contain items from multiple restaurants?</summary>
                <div class="answer">
                    FoodieHub's current cart flow is designed for one restaurant at a time. If you switch to another restaurant, the cart starts fresh for that restaurant.
                </div>
            </details>

            <details>
                <summary>How do I update quantities or remove cart items?</summary>
                <div class="answer">
                    Open your <a href="<%= helpCp %>/cart">Cart</a>. Use the available quantity controls to increase or decrease an item's quantity, remove an item, or clear the cart.
                </div>
            </details>

            <details>
                <summary>Where can I see my previous orders?</summary>
                <div class="answer">
                    Open <a href="<%= helpCp %>/orders">My Orders</a> while logged in. The page displays your order history and lets you filter orders into All Orders, Delivered, and Cancelled.
                </div>
            </details>

            <details>
                <summary>How do I check my order status?</summary>
                <div class="answer">
                    Visit <a href="<%= helpCp %>/orders">My Orders</a> and review the status displayed on the relevant order. The status depends on the order information stored by FoodieHub.
                </div>
            </details>

            <details>
                <summary>Which payment methods can I use?</summary>
                <div class="answer">
                    Continue to checkout and review the payment methods actually displayed by FoodieHub. Select an available method before submitting your order.
                </div>
            </details>

            <details>
                <summary>What should I do if an order or account detail looks incorrect?</summary>
                <div class="answer">
                    Check the details shown on the relevant page. If the problem remains, contact the FoodieHub project administrator with the order ID or a description of the issue. Never share your password.
                </div>
            </details>
        </div>
    </section>

    <section class="support">
        <h2>Still need help?</h2>
        <p>For a login, account, checkout, or order problem that is not covered above, contact the FoodieHub project administrator with a short description of the issue. Do not include your password.</p>
        <div class="actions">
            <a class="btn primary" href="<%= helpCp %>/restaurant">Explore Restaurants →</a>
            <a class="btn secondary" href="<%= helpCp %>/orders">Go to My Orders</a>
        </div>
    </section>
</main>

<footer class="footer">© <%= java.time.Year.now() %> FoodieHub · Here to help food lovers</footer>

</body>
</html>
