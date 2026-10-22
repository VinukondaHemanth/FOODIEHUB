
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String cpNav = request.getContextPath();

    Object loggedInObject = session.getAttribute("loggedInUser");
    String usernameNav = null;

    // Use the authenticated account as the source of truth on every page.
    if (loggedInObject instanceof com.tap.model.User) {
        com.tap.model.User loggedUser = (com.tap.model.User) loggedInObject;
        usernameNav = loggedUser.getUsername();
    } else if (loggedInObject instanceof String) {
        usernameNav = (String) loggedInObject;
    }

    // Fall back to the legacy session attribute only when needed.
    if (usernameNav == null || usernameNav.trim().isEmpty()) {
        usernameNav = (String) session.getAttribute("username");
    }

    boolean isLoggedIn = usernameNav != null
        && !usernameNav.trim().isEmpty();

    if (!isLoggedIn) {
        usernameNav = "Guest";
    }

    String safeUsernameNav = usernameNav
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");

    String avatarNav = usernameNav.substring(0, 1).toUpperCase();

    int navbarCartCount = 0;
    Object cartObjectNav = session.getAttribute("cart");

    if (cartObjectNav instanceof com.tap.model.Cart) {
        navbarCartCount =
            ((com.tap.model.Cart) cartObjectNav).getItemCount();
    }

    String currentPath = request.getServletPath();
%>

<style>
.fh-navbar {
    position: sticky;
    top: 0;
    z-index: 9999;
    width: 100%;
    min-height: 94px;
    padding: 0 5%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 25px;
    background: #001f16;
    border-bottom: 1px solid rgba(0,237,131,.2);
    font-family: Arial, sans-serif;
    box-sizing: border-box;
}

.fh-navbar * { box-sizing: border-box; }

.fh-brand {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-shrink: 0;
    color: white;
    text-decoration: none;
}

.fh-brand-icon {
    display: grid;
    place-items: center;
    width: 54px;
    height: 54px;
    border-radius: 50%;
    background: linear-gradient(135deg,#ff8155,#ff412d);
    font-size: 25px;
}

.fh-brand-name {
    color: white;
    font-size: 31px;
    font-weight: 900;
    letter-spacing: -1.2px;
}

.fh-brand-name span { color: #ff6848; }

.fh-nav-links {
    display: flex;
    align-items: center;
    gap: 30px;
}

.fh-nav-links a {
    position: relative;
    padding: 35px 0 31px;
    color: #c7d9ce;
    text-decoration: none;
    font-size: 15px;
    font-weight: 700;
    white-space: nowrap;
}

.fh-nav-links a:hover,
.fh-nav-links a.active { color: white; }

.fh-nav-links a.active::after {
    content: "";
    position: absolute;
    left: 0;
    right: 0;
    bottom: 22px;
    height: 3px;
    border-radius: 5px;
    background: #00ed83;
}

.fh-nav-actions {
    display: flex;
    align-items: center;
    gap: 18px;
}

.fh-cart {
    position: relative;
    display: grid;
    place-items: center;
    width: 49px;
    height: 49px;
    border: 1px solid rgba(0,237,131,.22);
    border-radius: 14px;
    color: white;
    text-decoration: none;
    font-size: 23px;
}

.fh-cart-count {
    position: absolute;
    top: -7px;
    right: -7px;
    display: grid;
    place-items: center;
    min-width: 21px;
    height: 21px;
    padding: 0 5px;
    border-radius: 50%;
    background: #ff5145;
    color: white;
    font-size: 11px;
    font-weight: 800;
}

.fh-user {
    position: relative;
}

.fh-profile-button {
    display: flex;
    align-items: center;
    gap: 10px;
    min-height: 54px;
    padding: 5px 13px 5px 6px;
    border: 1px solid rgba(0,237,131,.3);
    border-radius: 30px;
    background: rgba(0,237,131,.05);
    color: white;
    cursor: pointer;
    font-size: 14px;
    font-weight: 700;
}

.fh-profile-button:hover,
.fh-profile-button[aria-expanded="true"] {
    border-color: #00ed83;
    background: rgba(0,237,131,.12);
}

.fh-avatar {
    display: grid;
    place-items: center;
    width: 42px;
    height: 42px;
    flex-shrink: 0;
    border: 1px solid rgba(130,255,175,.3);
    border-radius: 50%;
    background: linear-gradient(135deg,#15a65c,#075a35);
    color: white;
    font-size: 17px;
    font-weight: 800;
}

.fh-profile-arrow { color: #69ffac; }

.profile-dropdown {
    display: none;
    position: absolute;
    top: calc(100% + 13px);
    right: 0;
    width: 348px;
    max-width: calc(100vw - 24px);
    padding: 16px;
    border: 1px solid rgba(0,237,131,.25);
    border-radius: 21px;
    background: #06291f;
    box-shadow: 0 18px 45px rgba(0,0,0,.42);
    z-index: 10000;
}

.profile-dropdown.open { display: block; }

.profile-dropdown-header {
    padding: 16px 15px;
    margin-bottom: 10px;
    border-bottom: 1px solid rgba(105,255,172,.14);
    overflow-wrap: anywhere;
}

.profile-dropdown-header span {
    display: block;
    margin-bottom: 8px;
    color: #9bb8a8;
    font-size: 12px;
}

.profile-dropdown-header strong {
    color: white;
    font-size: 18px;
}

.profile-dropdown a {
    display: block;
    padding: 14px 15px;
    border-radius: 9px;
    color: #d4e9dc;
    text-decoration: none;
    font-size: 14px;
    font-weight: 700;
}

.profile-dropdown a:hover {
    color: #69ffac;
    background: rgba(0,237,131,.08);
}

.profile-dropdown-divider {
    height: 1px;
    margin: 7px 0;
    background: rgba(105,255,172,.14);
}

.profile-dropdown .logout-link { color: #ff806f; }

.mobile-toggle {
    display: none;
    padding: 9px 12px;
    border: 1px solid rgba(105,255,172,.2);
    border-radius: 9px;
    background: #05291e;
    color: white;
    cursor: pointer;
}

@media (max-width: 1100px) {
    .fh-navbar { padding: 0 3%; gap: 15px; }
    .fh-brand-name { font-size: 25px; }
    .fh-nav-links { gap: 18px; }
    .fh-nav-links a { font-size: 13px; }
}

@media (max-width: 760px) {
    .fh-navbar {
        min-height: 72px;
        flex-wrap: wrap;
        padding: 10px 4%;
        gap: 10px;
    }

    .fh-brand-icon { width: 40px; height: 40px; }
    .fh-brand-name { font-size: 22px; }
    .fh-nav-actions { gap: 9px; margin-left: auto; }
    .fh-profile-button { min-height: 42px; padding: 3px; }
    .fh-avatar { width: 35px; height: 35px; }

    .fh-profile-username,
    .fh-profile-arrow { display: none; }

    .mobile-toggle { display: inline-block; }

    .fh-nav-links {
        display: none;
        flex: 0 0 100%;
        order: 5;
        align-items: stretch;
        flex-direction: column;
        gap: 0;
    }

    .fh-nav-links.open { display: flex; }

    .fh-nav-links a {
        padding: 13px 6px;
        border-bottom: 1px solid rgba(105,255,172,.1);
    }

    .fh-nav-links a.active::after { display: none; }
    .profile-dropdown { width: min(348px,88vw); }
}
</style>

<nav class="fh-navbar">
    <a class="fh-brand" href="<%= cpNav %>/restaurant">
        <span class="fh-brand-icon">🍴</span>
        <span class="fh-brand-name">Foodie<span>Hub</span></span>
    </a>

    <div class="fh-nav-links" id="navLinks">
        <a href="<%= cpNav %>/restaurant"
           class="<%= currentPath.endsWith("/restaurant") ? "active" : "" %>">
            Home
        </a>

        <a href="<%= cpNav %>/restaurant"
           class="<%= currentPath.endsWith("/restaurant") || currentPath.endsWith("/menu") ? "active" : "" %>">
            Restaurants
        </a>

        <a href="<%= cpNav %>/orders">My Orders</a>
        <a href="<%= cpNav %>/help.jsp">Help</a>
    </div>

    <div class="fh-nav-actions">
        <a class="fh-cart" href="<%= cpNav %>/cart" aria-label="Open cart">
            🛒
            <span class="fh-cart-count" id="cartCount"><%= navbarCartCount %></span>
        </a>

        <div class="fh-user" id="profileMenu">
            <button class="fh-profile-button" type="button"
                    id="profileButton" aria-expanded="false"
                    aria-controls="profileDropdown">
                <span class="fh-avatar"><%= avatarNav %></span>
                <span class="fh-profile-username"><%= safeUsernameNav %></span>
                <span class="fh-profile-arrow">⌄</span>
            </button>

            <div class="profile-dropdown" id="profileDropdown">
                <% if (isLoggedIn) { %>
                    <div class="profile-dropdown-header">
                        <span>LOGGED IN AS</span>
                        <strong><%= safeUsernameNav %></strong>
                    </div>

                    <a href="<%= cpNav %>/profile.jsp">♟ &nbsp; My Profile</a>
                    <a href="<%= cpNav %>/orders">📦 &nbsp; My Orders</a>
                    <a href="<%= cpNav %>/cart">🛒 &nbsp; My Cart</a>

                    <div class="profile-dropdown-divider"></div>

                    <a class="logout-link" href="<%= cpNav %>/logout">↪ &nbsp; Logout</a>
                <% } else { %>
                    <div class="profile-dropdown-header">
                        <span>WELCOME TO</span>
                        <strong>FoodieHub Guest</strong>
                    </div>

                    <a href="<%= cpNav %>/login.jsp">🔑 &nbsp; Login</a>
                    <a href="<%= cpNav %>/signup.jsp">📝 &nbsp; Create Account</a>
                <% } %>
            </div>
        </div>

        <button class="mobile-toggle" type="button" id="mobileToggle"
                aria-label="Toggle navigation" aria-expanded="false">☰</button>
    </div>
</nav>

<script>
(function () {
    const button = document.getElementById("profileButton");
    const menu = document.getElementById("profileDropdown");
    const profile = document.getElementById("profileMenu");
    const mobileButton = document.getElementById("mobileToggle");
    const links = document.getElementById("navLinks");

    if (button && menu && profile) {
        button.addEventListener("click", function (event) {
            event.stopPropagation();
            const opened = menu.classList.toggle("open");
            button.setAttribute("aria-expanded", String(opened));
        });

        menu.addEventListener("click", function (event) {
            event.stopPropagation();
        });

        document.addEventListener("click", function (event) {
            if (!profile.contains(event.target)) {
                menu.classList.remove("open");
                button.setAttribute("aria-expanded", "false");
            }
        });

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") {
                menu.classList.remove("open");
                button.setAttribute("aria-expanded", "false");
            }
        });
    }

    if (mobileButton && links) {
        mobileButton.addEventListener("click", function () {
            const opened = links.classList.toggle("open");
            mobileButton.setAttribute("aria-expanded", String(opened));
            mobileButton.textContent = opened ? "✕" : "☰";
        });
    }
})();
</script>
<jsp:include page="/chatbot-widget.jsp" />
