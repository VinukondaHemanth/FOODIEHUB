
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.User" %>

<%!
    private String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String cp = request.getContextPath();

    User profileUser = (User) session.getAttribute("loggedInUser");

    if (profileUser == null) {
        response.sendRedirect(cp + "/login.jsp");
        return;
    }

    String username = profileUser.getUsername();
    String email = profileUser.getEmail();
    String phone = profileUser.getPhone();
    String address = profileUser.getAddress();
    String role = profileUser.getRole();

    String displayName = (username == null || username.trim().isEmpty())
            ? "FoodieHub User" : username.trim();

    String initial = displayName.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Profile | FoodieHub</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap"
      rel="stylesheet">

<style>
:root {
    --bg: #001a12;
    --panel: #052c20;
    --panel-dark: #001e15;
    --green: #00ed83;
    --mint: #70ffb8;
    --text: #f4fff8;
    --muted: #a0c3b2;
    --border: rgba(0,237,131,.20);
    --orange: #ff5a43;
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    min-height: 100vh;
    font-family: 'DM Sans', sans-serif;
    color: var(--text);
    background:
        radial-gradient(ellipse at 10% 10%, rgba(0,237,131,.10), transparent 34%),
        radial-gradient(ellipse at 90% 70%, rgba(0,237,131,.05), transparent 35%),
        var(--bg);
}

a {
    text-decoration: none;
}

.profile-hero {
    padding: 44px 7% 38px;
    border-bottom: 1px solid var(--border);
    background: linear-gradient(110deg, rgba(0,237,131,.07), transparent 75%);
}

.breadcrumb {
    color: var(--muted);
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 2px;
    text-transform: uppercase;
    margin-bottom: 17px;
}

.breadcrumb span {
    color: var(--green);
}

.hero-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 25px;
}

.hero-title {
    font-family: 'Playfair Display', serif;
    font-size: clamp(39px, 5vw, 62px);
    line-height: 1.15;
    letter-spacing: -1.5px;
}

.hero-title span {
    color: var(--green);
}

.hero-description {
    margin-top: 13px;
    max-width: 570px;
    color: var(--muted);
    line-height: 1.8;
    font-size: 15px;
}

.hero-icon {
    width: 108px;
    height: 108px;
    display: grid;
    place-items: center;
    flex-shrink: 0;
    border: 1px solid var(--border);
    border-radius: 30px;
    background: rgba(0,237,131,.07);
    color: var(--green);
    font-size: 48px;
    box-shadow: 0 0 35px rgba(0,237,131,.07);
}

.main {
    width: min(1100px, 88%);
    margin: 38px auto 70px;
}

.welcome-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
    margin-bottom: 28px;
}

.welcome-row h2 {
    font-size: 23px;
    font-weight: 800;
}

.welcome-row p {
    color: var(--muted);
    margin-top: 7px;
    font-size: 14px;
}

.status {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 15px;
    color: var(--mint);
    background: rgba(0,237,131,.07);
    border: 1px solid var(--border);
    border-radius: 30px;
    font-size: 12px;
    font-weight: 800;
    white-space: nowrap;
}

.status-dot {
    width: 8px;
    height: 8px;
    background: var(--green);
    border-radius: 50%;
    box-shadow: 0 0 10px rgba(0,237,131,.7);
}

.profile-layout {
    display: grid;
    grid-template-columns: 310px minmax(0, 1fr);
    gap: 23px;
    align-items: start;
}

.card {
    border: 1px solid var(--border);
    border-radius: 23px;
    background: linear-gradient(145deg, rgba(7,53,38,.95), rgba(1,29,21,.96));
    box-shadow: 0 15px 45px rgba(0,0,0,.13);
    overflow: hidden;
}

.identity-card {
    padding: 29px 23px;
    text-align: center;
}

.avatar {
    width: 100px;
    height: 100px;
    display: grid;
    place-items: center;
    margin: 0 auto 18px;
    border-radius: 30px;
    background: linear-gradient(135deg, var(--green), var(--mint));
    color: #00321e;
    font-size: 42px;
    font-weight: 800;
    box-shadow: 0 12px 30px rgba(0,237,131,.15);
}

.identity-card h2 {
    font-size: 22px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

.identity-card .email-preview {
    color: var(--muted);
    font-size: 12px;
    line-height: 1.7;
    margin-top: 7px;
    overflow-wrap: anywhere;
}

.role-pill {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    margin-top: 17px;
    padding: 8px 14px;
    border: 1px solid rgba(0,237,131,.25);
    border-radius: 30px;
    background: rgba(0,237,131,.08);
    color: var(--mint);
    font-size: 11px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: .7px;
}

.identity-divider {
    height: 1px;
    margin: 24px 0;
    background: var(--border);
}

.identity-note {
    color: var(--muted);
    font-size: 12px;
    line-height: 1.8;
}

.details-card {
    padding: 29px;
}

.section-heading {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
    padding-bottom: 21px;
    border-bottom: 1px solid var(--border);
}

.section-heading h2 {
    font-size: 21px;
    font-weight: 800;
}

.section-heading p {
    color: var(--muted);
    font-size: 12px;
    margin-top: 6px;
}

.section-symbol {
    width: 43px;
    height: 43px;
    display: grid;
    place-items: center;
    border: 1px solid var(--border);
    border-radius: 13px;
    background: rgba(0,237,131,.07);
    font-size: 20px;
}

.detail-list {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 20px;
}

.detail-item {
    padding: 20px 0;
    min-width: 0;
    border-bottom: 1px solid rgba(0,237,131,.11);
}

.detail-item.full {
    grid-column: 1 / -1;
}

.detail-label {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 10px;
    color: var(--muted);
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
}

.detail-value {
    color: var(--text);
    font-size: 14px;
    line-height: 1.8;
    font-weight: 600;
    overflow-wrap: anywhere;
    white-space: pre-wrap;
}

.empty-value {
    color: #7d9e8d;
    font-style: italic;
    font-weight: 400;
}

.actions-heading {
    margin: 35px 0 17px;
    font-size: 20px;
    font-weight: 800;
}

.action-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 17px;
}

.action-card {
    min-height: 150px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 21px;
    border: 1px solid var(--border);
    border-radius: 18px;
    background: rgba(4,43,30,.8);
    transition: transform .22s, border-color .22s, background .22s;
}

.action-card:hover {
    transform: translateY(-4px);
    border-color: rgba(0,237,131,.65);
    background: rgba(0,237,131,.07);
}

.action-icon {
    width: 43px;
    height: 43px;
    display: grid;
    place-items: center;
    margin-bottom: 15px;
    border: 1px solid var(--border);
    border-radius: 13px;
    background: rgba(0,237,131,.08);
    font-size: 20px;
}

.action-card strong {
    color: var(--text);
    font-size: 14px;
    font-weight: 800;
}

.action-card p {
    margin-top: 7px;
    color: var(--muted);
    font-size: 12px;
    line-height: 1.7;
}

.bottom-links {
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
    gap: 14px;
    margin-top: 30px;
}

.button {
    min-height: 47px;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 9px;
    padding: 0 21px;
    border-radius: 12px;
    font-family: inherit;
    font-size: 13px;
    font-weight: 800;
    transition: transform .2s, filter .2s;
}

.button:hover {
    transform: translateY(-2px);
    filter: brightness(1.08);
}

.button-primary {
    color: #002416;
    background: linear-gradient(100deg, var(--green), var(--mint));
}

.button-secondary {
    color: var(--mint);
    border: 1px solid var(--border);
    background: rgba(0,237,131,.04);
}

@media (max-width: 850px) {
    .profile-layout {
        grid-template-columns: 1fr;
    }

    .identity-card {
        display: grid;
        grid-template-columns: 80px minmax(0,1fr);
        align-items: center;
        text-align: left;
        gap: 0 18px;
    }

    .avatar {
        width: 75px;
        height: 75px;
        grid-row: span 3;
        margin: 0;
        border-radius: 22px;
        font-size: 32px;
    }

    .identity-card h2 {
        font-size: 18px;
    }

    .identity-card .email-preview {
        margin-top: 3px;
    }

    .identity-card .role-pill {
        justify-self: start;
        margin-top: 9px;
    }

    .identity-divider,
    .identity-note {
        display: none;
    }
}

@media (max-width: 600px) {
    .profile-hero {
        padding: 31px 6%;
    }

    .hero-icon {
        display: none;
    }

    .hero-title {
        font-size: 41px;
    }

    .hero-description {
        font-size: 13px;
    }

    .main {
        width: 90%;
        margin-top: 26px;
    }

    .welcome-row {
        align-items: flex-start;
        flex-direction: column;
    }

    .details-card {
        padding: 21px 17px;
    }

    .detail-list {
        grid-template-columns: 1fr;
    }

    .detail-item.full {
        grid-column: auto;
    }

    .action-grid {
        grid-template-columns: 1fr;
    }

    .action-card {
        min-height: 0;
    }

    .section-heading h2 {
        font-size: 18px;
    }

    .bottom-links {
        flex-direction: column;
    }

    .button {
        width: 100%;
    }
}
</style>
</head>

<body>

<jsp:include page="/components/navbar.jsp" />

<header class="profile-hero">
    <div class="breadcrumb">FOODIEHUB / <span>YOUR ACCOUNT</span></div>

    <div class="hero-row">
        <div>
            <h1 class="hero-title">My <span>Profile.</span></h1>
            <p class="hero-description">
                Your FoodieHub account, all in one place.
                View your personal details and access your favourite food
                experiences.
            </p>
        </div>

        <div class="hero-icon" aria-hidden="true">👤</div>
    </div>
</header>

<main class="main">

    <div class="welcome-row">
        <div>
            <h2>Welcome back, <%= escapeHtml(displayName) %>!</h2>
            <p>Here are the details associated with your account.</p>
        </div>

        <div class="status">
            <span class="status-dot"></span>
            Logged In
        </div>
    </div>

    <section class="profile-layout">

        <!-- USER IDENTITY CARD -->
        <aside class="card identity-card">
            <div class="avatar"><%= escapeHtml(initial) %></div>

            <h2><%= escapeHtml(displayName) %></h2>

            <p class="email-preview">
                <%= (email == null || email.trim().isEmpty())
                    ? "Email not provided" : escapeHtml(email) %>
            </p>

            <div class="role-pill">
                <%= (role == null || role.trim().isEmpty())
                    ? "Customer" : escapeHtml(role) %>
            </div>

            <div class="identity-divider"></div>

            <p class="identity-note">
                Your account information is displayed here so you can
                review your registered details whenever you need.
            </p>
        </aside>

        <!-- ACCOUNT DETAILS -->
        <section class="card details-card">
            <div class="section-heading">
                <div>
                    <h2>Personal Information</h2>
                    <p>Your registered FoodieHub account details</p>
                </div>
                <div class="section-symbol">📋</div>
            </div>

            <div class="detail-list">

                <div class="detail-item">
                    <div class="detail-label">👤 Username</div>
                    <div class="detail-value">
                        <%= escapeHtml(displayName) %>
                    </div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">✉️ Email Address</div>
                    <div class="detail-value <%= (email == null || email.trim().isEmpty()) ? "empty-value" : "" %>">
                        <%= (email == null || email.trim().isEmpty())
                            ? "Not provided" : escapeHtml(email) %>
                    </div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">📱 Phone Number</div>
                    <div class="detail-value <%= (phone == null || phone.trim().isEmpty()) ? "empty-value" : "" %>">
                        <%= (phone == null || phone.trim().isEmpty())
                            ? "Not provided" : escapeHtml(phone) %>
                    </div>
                </div>

                <div class="detail-item">
                    <div class="detail-label">🛡️ Account Role</div>
                    <div class="detail-value">
                        <%= (role == null || role.trim().isEmpty())
                            ? "Customer" : escapeHtml(role) %>
                    </div>
                </div>

                <div class="detail-item full">
                    <div class="detail-label">📍 Delivery Address</div>
                    <div class="detail-value <%= (address == null || address.trim().isEmpty()) ? "empty-value" : "" %>">
                        <%= (address == null || address.trim().isEmpty())
                            ? "No delivery address added" : escapeHtml(address) %>
                    </div>
                </div>

            </div>
        </section>

    </section>

    <h2 class="actions-heading">Your FoodieHub</h2>

    <section class="action-grid">

        <a class="action-card" href="<%= cp %>/orders">
            <div class="action-icon">🧾</div>
            <strong>My Orders</strong>
            <p>View your order history and check order status.</p>
        </a>

        <a class="action-card" href="<%= cp %>/restaurant">
            <div class="action-icon">🍽️</div>
            <strong>Explore Restaurants</strong>
            <p>Discover restaurants and choose your next meal.</p>
        </a>

        <a class="action-card" href="<%= cp %>/cart">
            <div class="action-icon">🛒</div>
            <strong>My Cart</strong>
            <p>Review the items in your cart before checkout.</p>
        </a>

    </section>

    <div class="bottom-links">
        <a class="button button-primary" href="<%= cp %>/restaurant">
            🍴 Order Something Delicious
        </a>

        <a class="button button-secondary" href="<%= cp %>/forgotPassword.jsp">
            🔐 Change Password
        </a>

        <a class="button button-secondary" href="<%= cp %>/logout">
            🚪 Logout
        </a>
    </div>

</main>

</body>
</html>
