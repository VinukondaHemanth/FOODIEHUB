
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    String cp = request.getContextPath();
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | FoodieHub</title>

<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap" rel="stylesheet">

<style>
:root {
    --bg: #001a12;
    --panel: #05291e;
    --green: #00ed83;
    --bright: #6dffb0;
    --text: #f3fff8;
    --muted: #9bb9aa;
    --border: rgba(105,255,172,.2);
}
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    font-family: 'DM Sans', sans-serif;
    color: var(--text);
    background:
        radial-gradient(ellipse at 10% 10%, rgba(0,237,131,.13), transparent 35%),
        radial-gradient(ellipse at 90% 90%, rgba(0,180,100,.10), transparent 30%),
        var(--bg);
}
a {
    text-decoration: none;
    color: inherit;
}
.page {
    flex: 1;
    display: grid;
    place-items: center;
    padding: 35px 18px;
}
.card {
    width: min(450px, 100%);
    padding: 36px;
    border: 1px solid var(--border);
    border-radius: 25px;
    background: linear-gradient(145deg, rgba(7,53,37,.97), rgba(2,29,21,.98));
    box-shadow: 0 25px 80px #0005;
    animation: appear .6s ease both;
}
@keyframes appear {
    from { opacity: 0; transform: translateY(18px); }
    to { opacity: 1; transform: translateY(0); }
}
.brand {
    text-align: center;
    margin-bottom: 28px;
}
.brand-icon {
    width: 66px;
    height: 66px;
    margin: 0 auto 14px;
    display: grid;
    place-items: center;
    border-radius: 20px;
    background: linear-gradient(135deg, #ff684f, #ff4b2b);
    font-size: 30px;
    box-shadow: 0 10px 28px #ff4b2b30;
}
.brand h1 {
    font-family: 'Playfair Display', serif;
    font-size: 34px;
}
.brand h1 span {
    color: var(--green);
}
.brand p {
    margin-top: 9px;
    color: var(--muted);
    font-size: 13px;
    line-height: 1.7;
}
.card h2 {
    font-size: 23px;
    margin-bottom: 7px;
}
.subtitle {
    color: var(--muted);
    font-size: 13px;
    margin-bottom: 24px;
}
.group {
    margin-bottom: 18px;
}
label {
    display: block;
    margin-bottom: 8px;
    color: #dff9e9;
    font-size: 12px;
    font-weight: 700;
}
.input-wrap {
    display: flex;
    align-items: center;
    border: 1px solid var(--border);
    border-radius: 12px;
    background: #001a12;
    transition: .2s;
}
.input-wrap:focus-within {
    border-color: var(--green);
    box-shadow: 0 0 0 3px #00ed8318;
}
.input-wrap input {
    width: 100%;
    min-width: 0;
    padding: 14px 13px;
    border: 0;
    outline: 0;
    color: var(--text);
    background: transparent;
    font-family: inherit;
    font-size: 13px;
}
.input-wrap input::placeholder {
    color: #658575;
}
.toggle {
    flex-shrink: 0;
    padding: 10px 12px;
    border: 0;
    background: transparent;
    color: var(--green);
    cursor: pointer;
    font-size: 17px;
}
.forgot-row {
    display: flex;
    justify-content: flex-end;
    margin: -5px 0 20px;
}
.forgot-row a {
    color: var(--green);
    font-size: 12px;
    font-weight: 700;
}
.forgot-row a:hover,
.links a:hover,
.back:hover {
    color: var(--bright);
    text-decoration: underline;
}
.submit {
    width: 100%;
    padding: 14px;
    border: 0;
    border-radius: 12px;
    background: linear-gradient(100deg, var(--green), var(--bright));
    color: #002416;
    font-size: 14px;
    font-weight: 800;
    cursor: pointer;
    transition: transform .2s, box-shadow .2s;
}
.submit:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px #00ed8330;
}
.notice {
    padding: 12px 13px;
    margin-bottom: 17px;
    border-radius: 10px;
    font-size: 13px;
    line-height: 1.6;
    overflow-wrap: anywhere;
}
.error {
    color: #ffdede;
    background: #ff626f18;
    border: 1px solid #ff626f55;
}
.success {
    color: #d6ffe7;
    background: #00ed8312;
    border: 1px solid var(--border);
}
.links {
    margin-top: 22px;
    text-align: center;
    color: var(--muted);
    font-size: 13px;
    line-height: 2;
}
.links a {
    color: var(--green);
    font-weight: 700;
}
.back {
    display: block;
    margin-top: 20px;
    text-align: center;
    color: var(--muted);
    font-size: 12px;
}
.footer {
    padding: 18px;
    text-align: center;
    color: #789b88;
    font-size: 11px;
}
@media (max-width: 480px) {
    .card { padding: 27px 22px; }
    .brand h1 { font-size: 30px; }
}
</style>
</head>

<body>
<main class="page">
    <section class="card">

        <div class="brand">
            <div class="brand-icon">🍴</div>
            <h1>Foodie<span>Hub</span></h1>
            <p>Good food. Great moments. Welcome back.</p>
        </div>

        <h2>Welcome back!</h2>
        <p class="subtitle">
            Login to continue your FoodieHub journey.
        </p>

        <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="notice error"><%= error %></div>
        <% } %>

        <% if (message != null && !message.trim().isEmpty()) { %>
            <div class="notice success"><%= message %></div>
        <% } %>

        <form action="<%= cp %>/login" method="post">

            <div class="group">
                <label for="loginInput">Username or Email</label>
                <div class="input-wrap">
                    <input
                        type="text"
                        id="loginInput"
                        name="loginInput"
                        placeholder="Enter your username or email"
                        autocomplete="username"
                        required>
                </div>
            </div>

            <div class="group">
                <label for="password">Password</label>
                <div class="input-wrap">
                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>

                    <button
                        class="toggle"
                        type="button"
                        id="togglePassword"
                        aria-label="Show password"
                        title="Show password">👁</button>
                </div>
            </div>


				<div class="forgot-row">
					<a href="<%=request.getContextPath()%>/forgotPassword.jsp">
						Forgot Password? </a>
				</div>


				<button class="submit" type="submit">
                Login to FoodieHub →
            </button>
        </form>

        <div class="links">
            Don't have an account?
            <a href="<%= cp %>/signup.jsp">Create an account</a>
        </div>

        <a class="back" href="<%= cp %>/restaurant">
            ← Back to Restaurants
        </a>

    </section>
</main>

<footer class="footer">
    © <%= java.time.Year.now() %> FoodieHub · Made for food lovers
</footer>

<script>
document.getElementById("togglePassword").addEventListener("click", function () {
    const password = document.getElementById("password");
    const visible = password.type === "password";

    password.type = visible ? "text" : "password";
    this.textContent = visible ? "🙈" : "👁";
    this.setAttribute(
        "aria-label",
        visible ? "Hide password" : "Show password"
    );
    this.setAttribute(
        "title",
        visible ? "Hide password" : "Show password"
    );
});
</script>
</body>
</html>
