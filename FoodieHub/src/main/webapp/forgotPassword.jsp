
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String cp = request.getContextPath();
    String error = (String) request.getAttribute("error");
    boolean updated = "1".equals(request.getParameter("updated"));
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Forgot Password | FoodieHub</title>

<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap" rel="stylesheet">

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --bg: #001a12;
    --card: #052b20;
    --dark: #001d15;
    --green: #00ed83;
    --light-green: #66ffb3;
    --text: #f4fff8;
    --muted: #a1c6b5;
    --border: rgba(0, 237, 131, 0.24);
    --red: #ff5b43;
}

body {
    min-height: 100vh;
    font-family: 'DM Sans', sans-serif;
    color: var(--text);
    background:
        radial-gradient(ellipse at 15% 10%, rgba(0,237,131,.10), transparent 35%),
        radial-gradient(ellipse at 90% 90%, rgba(0,237,131,.06), transparent 35%),
        var(--bg);
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 35px 18px;
}

.page {
    width: 100%;
    max-width: 580px;
    padding: 30px 46px 38px;
    text-align: center;
    border: 1px solid var(--border);
    border-radius: 0 0 32px 32px;
    background: linear-gradient(145deg, rgba(7,53,38,.98), rgba(1,29,21,.98));
    box-shadow: 0 25px 80px rgba(0,0,0,.22);
    animation: appear .55s ease;
}

@keyframes appear {
    from { opacity: 0; transform: translateY(15px); }
    to { opacity: 1; transform: translateY(0); }
}

.lock-icon {
    width: 85px;
    height: 85px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: -17px auto 25px;
    border-radius: 25px;
    background: var(--red);
    font-size: 42px;
    box-shadow: 0 10px 30px rgba(255,91,67,.12);
}

h1 {
    font-family: 'Playfair Display', serif;
    font-size: clamp(30px, 5vw, 40px);
    line-height: 1.2;
    font-weight: 800;
    margin-bottom: 20px;
}

h1 span {
    color: var(--green);
}

.subtitle {
    color: var(--muted);
    font-size: 15px;
    line-height: 1.9;
    margin: 0 auto 27px;
    max-width: 440px;
}

.form-panel {
    text-align: left;
    padding: 24px 21px;
    border: 1px solid var(--border);
    border-radius: 19px;
    background: rgba(0, 20, 14, .65);
}

.form-title {
    color: var(--green);
    font-size: 18px;
    font-weight: 800;
    margin-bottom: 21px;
}

.form-group {
    margin-bottom: 18px;
}

label {
    display: block;
    margin-bottom: 9px;
    color: #e7fff0;
    font-size: 13px;
    font-weight: 700;
}

.input-wrap {
    display: flex;
    align-items: center;
    border: 1px solid rgba(137, 203, 165, .25);
    border-radius: 10px;
    background: #001a12;
    transition: border-color .2s, box-shadow .2s;
}

.input-wrap:focus-within {
    border-color: var(--green);
    box-shadow: 0 0 0 3px rgba(0,237,131,.09);
}

input {
    width: 100%;
    min-width: 0;
    padding: 14px 13px;
    color: var(--text);
    background: transparent;
    border: none;
    outline: none;
    font-family: inherit;
    font-size: 13px;
}

input::placeholder {
    color: #739786;
}

.password-toggle {
    flex-shrink: 0;
    padding: 10px 12px;
    color: var(--green);
    background: transparent;
    border: none;
    cursor: pointer;
    font-size: 17px;
}

.update-btn {
    width: 100%;
    margin-top: 4px;
    padding: 15px 18px;
    border: none;
    border-radius: 11px;
    background: linear-gradient(100deg, var(--green), var(--light-green));
    color: #002416;
    font-family: inherit;
    font-size: 15px;
    font-weight: 800;
    cursor: pointer;
    transition: transform .2s, box-shadow .2s;
}

.update-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 9px 25px rgba(0,237,131,.18);
}

.error-message {
    margin-bottom: 18px;
    padding: 12px 14px;
    color: #ffdada;
    background: rgba(255,70,70,.09);
    border: 1px solid rgba(255,90,90,.35);
    border-radius: 10px;
    font-size: 13px;
    line-height: 1.6;
    overflow-wrap: anywhere;
}

.links {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 17px;
    margin-top: 29px;
}

.links a {
    color: var(--green);
    text-decoration: none;
    font-size: 15px;
    font-weight: 800;
    transition: color .2s;
}

.links a:hover {
    color: var(--light-green);
    text-decoration: underline;
}

.toast {
    position: fixed;
    top: 22px;
    right: 22px;
    z-index: 9999;
    width: min(390px, calc(100% - 32px));
    padding: 18px;
    display: flex;
    align-items: flex-start;
    gap: 13px;
    border-radius: 15px;
    border: 1px solid rgba(0,237,131,.55);
    background: #073525;
    box-shadow: 0 16px 45px rgba(0,0,0,.4);
    animation: toastIn .35s ease;
}

.toast-check {
    width: 35px;
    height: 35px;
    flex-shrink: 0;
    display: grid;
    place-items: center;
    border-radius: 50%;
    color: #002416;
    background: var(--green);
    font-size: 20px;
    font-weight: 900;
}

.toast strong {
    display: block;
    color: #eafff2;
    font-size: 14px;
    margin: 2px 0 5px;
}

.toast p {
    color: var(--muted);
    font-size: 12px;
    line-height: 1.6;
}

.progress {
    height: 3px;
    margin-top: 12px;
    overflow: hidden;
    background: rgba(255,255,255,.12);
    border-radius: 10px;
}

.progress span {
    display: block;
    width: 100%;
    height: 100%;
    background: var(--green);
    animation: progress 4s linear forwards;
}

@keyframes progress {
    from { width: 100%; }
    to { width: 0%; }
}

@keyframes toastIn {
    from { opacity: 0; transform: translateY(-12px); }
    to { opacity: 1; transform: translateY(0); }
}

@media (max-width: 520px) {
    .page {
        padding: 27px 20px 32px;
        border-radius: 25px;
    }

    .lock-icon {
        width: 72px;
        height: 72px;
        font-size: 35px;
        margin-top: 0;
    }

    .form-panel {
        padding: 20px 15px;
    }

    .subtitle {
        font-size: 13px;
    }

    .links a {
        font-size: 14px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: .01ms !important;
        transition-duration: .01ms !important;
    }
}
</style>
</head>

<body>

<section class="page">

    <div class="lock-icon">🔐</div>

    <h1>Forgot <span>Password?</span></h1>

    <p class="subtitle">
        Create a new password for your FoodieHub account.
        Enter your registered email and confirm your new password.
    </p>

    <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="error-message"><%= error %></div>
    <% } %>

    <div class="form-panel">

        <div class="form-title">Reset your password</div>

        <form id="resetForm"
              action="<%= cp %>/forgot-password"
              method="post">

            <div class="form-group">
                <label for="email">Registered Email</label>
                <div class="input-wrap">
                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter your registered email"
                        autocomplete="email"
                        required>
                </div>
            </div>

            <div class="form-group">
                <label for="newPassword">New Password</label>
                <div class="input-wrap">
                    <input
                        type="password"
                        id="newPassword"
                        name="newPassword"
                        placeholder="Enter your new password"
                        minlength="8"
                        autocomplete="new-password"
                        required>
                    <button
                        type="button"
                        class="password-toggle"
                        data-target="newPassword"
                        aria-label="Show new password">👁</button>
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Re-enter New Password</label>
                <div class="input-wrap">
                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Re-enter your new password"
                        minlength="8"
                        autocomplete="new-password"
                        required>
                    <button
                        type="button"
                        class="password-toggle"
                        data-target="confirmPassword"
                        aria-label="Show confirmed password">👁</button>
                </div>
            </div>

            <button type="submit" class="update-btn">
                Update Password&nbsp; →
            </button>

        </form>
    </div>

    <div class="links">
        <a href="<%= cp %>/login.jsp">← Back to Login</a>
        <a href="<%= cp %>/signup.jsp">Create a new account</a>
        <a href="<%= cp %>/restaurant">Explore Restaurants</a>
    </div>

</section>

<script>
document.querySelectorAll(".password-toggle").forEach(function(button) {
    button.addEventListener("click", function() {
        const input = document.getElementById(this.dataset.target);
        const showing = input.type === "password";

        input.type = showing ? "text" : "password";
        this.textContent = showing ? "🙈" : "👁";
        this.setAttribute(
            "aria-label",
            showing ? "Hide password" : "Show password"
        );
    });
});

document.getElementById("resetForm").addEventListener("submit", function(event) {
    const password = document.getElementById("newPassword").value;
    const confirmPassword = document.getElementById("confirmPassword").value;

    if (password.length < 8) {
        event.preventDefault();
        alert("Password must be at least 8 characters long.");
        return;
    }

    if (password !== confirmPassword) {
        event.preventDefault();
        alert("New password and re-entered password do not match.");
        document.getElementById("confirmPassword").focus();
    }
});

<% if (updated) { %>
(function() {
    const toast = document.createElement("div");
    toast.className = "toast";

    toast.innerHTML =
        '<div class="toast-check">&#10003;</div>' +
        '<div style="flex:1">' +
            '<strong>Password changed successfully!</strong>' +
            '<p>Your password has been updated. Redirecting to Login...</p>' +
            '<div class="progress"><span></span></div>' +
        '</div>';

    document.body.appendChild(toast);

    window.setTimeout(function() {
        window.location.replace("<%= cp %>/login.jsp");
    }, 4000);
})();
<% } %>
</script>

</body>
</html>
