
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%
    String signupCp = request.getContextPath();
    String signupError = (String) request.getAttribute("error");
    String signupMessage = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Create Account | FoodieHub</title>
<link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700;800&display=swap" rel="stylesheet">
<style>
:root{--bg:#001a12;--panel:#05291e;--green:#00ed83;--bright:#6dffb0;--text:#f3fff8;--muted:#9bb9aa;--border:rgba(105,255,172,.2)}
*{box-sizing:border-box;margin:0;padding:0}
body{min-height:100vh;font-family:'DM Sans',sans-serif;color:var(--text);background:radial-gradient(ellipse at 10% 10%,#00ed8317,transparent 35%),radial-gradient(ellipse at 90% 90%,#00b46414,transparent 35%),var(--bg)}
a{color:inherit;text-decoration:none}
.page{min-height:100vh;display:grid;place-items:center;padding:35px 16px}
.card{width:min(700px,100%);padding:36px;border:1px solid var(--border);border-radius:25px;background:linear-gradient(145deg,rgba(7,53,37,.97),rgba(2,29,21,.98));box-shadow:0 25px 80px #0005;animation:appear .6s ease both}
@keyframes appear{from{opacity:0;transform:translateY(18px)}to{opacity:1;transform:translateY(0)}}
.header{text-align:center;margin-bottom:25px}
.logo{width:60px;height:60px;border-radius:19px;display:grid;place-items:center;margin:0 auto 12px;background:linear-gradient(135deg,#ff684f,#ff4b2b);font-size:28px}
h1{font-family:'Playfair Display',serif;font-size:32px}
h1 span{color:var(--green)}
.header p{font-size:13px;color:var(--muted);margin-top:8px}
.section-title{font-size:22px;margin-bottom:6px}
.subtitle{color:var(--muted);font-size:13px;margin-bottom:22px}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:17px}
.group{min-width:0}
.full{grid-column:1/-1}
label{display:block;font-size:12px;font-weight:700;margin-bottom:8px;color:#dff9e9}
.wrap{display:flex;align-items:center;background:#001a12;border:1px solid var(--border);border-radius:11px;transition:.2s}
.wrap:focus-within{border-color:var(--green);box-shadow:0 0 0 3px #00ed8318}
input{width:100%;min-width:0;padding:13px;color:var(--text);background:transparent;border:0;outline:0;font:inherit;font-size:13px}
input::placeholder{color:#658575}
.toggle{border:0;background:transparent;color:var(--green);padding:10px;cursor:pointer}
.hint{font-size:11px;color:var(--muted);margin-top:6px}
.submit{width:100%;margin-top:22px;border:0;border-radius:12px;padding:14px;background:linear-gradient(100deg,var(--green),var(--bright));color:#002416;font-size:14px;font-weight:800;cursor:pointer;transition:.2s}
.submit:hover{transform:translateY(-2px);box-shadow:0 10px 25px #00ed8330}
.notice{padding:11px 13px;margin-bottom:17px;border-radius:10px;font-size:13px;line-height:1.5}
.error{color:#ffdede;background:#ff626f16;border:1px solid #ff626f55}
.success{color:#d6ffe7;background:#00ed8312;border:1px solid var(--border)}
.bottom{text-align:center;margin-top:20px;font-size:13px;color:var(--muted)}
.bottom a{color:var(--green);font-weight:700}
.back{display:block;text-align:center;margin-top:15px;color:var(--muted);font-size:12px}
@media(max-width:560px){.card{padding:26px 20px}.grid{grid-template-columns:1fr}.full{grid-column:auto}h1{font-size:29px}}
</style>
</head>
<body>
<main class="page">
  <section class="card">
    <header class="header">
      <div class="logo">🍴</div>
      <h1>Join Foodie<span>Hub</span></h1>
      <p>Your next favourite meal is just around the corner.</p>
    </header>

    <h2 class="section-title">Create your account</h2>
    <p class="subtitle">Enter your details to get started.</p>

    <% if (signupError != null && !signupError.trim().isEmpty()) { %>
      <div class="notice error"><%= signupError %></div>
    <% } %>

    <% if (signupMessage != null && !signupMessage.trim().isEmpty()) { %>
      <div class="notice success"><%= signupMessage %></div>
    <% } %>

    <form id="signupForm" action="<%= signupCp %>/signup" method="post">
      <div class="grid">
        <div class="group">
          <label for="username">Username *</label>
          <div class="wrap">
            <input id="username" name="username" type="text"
                   placeholder="Choose a username" autocomplete="username"
                   maxlength="100" required>
          </div>
        </div>

        <div class="group">
          <label for="email">Email address *</label>
          <div class="wrap">
            <input id="email" name="email" type="email"
                   placeholder="you@example.com" autocomplete="email"
                   maxlength="150" required>
          </div>
        </div>

        <div class="group">
          <label for="phone">Mobile number *</label>
          <div class="wrap">
            <input id="phone" name="phone" type="tel"
                   placeholder="10-digit mobile number" autocomplete="tel"
                   inputmode="numeric" maxlength="10" pattern="[0-9]{10}" required>
          </div>
          <p class="hint">Enter a 10-digit mobile number.</p>
        </div>

        <div class="group">
          <label for="password">Password *</label>
          <div class="wrap">
            <input id="password" name="password" type="password"
                   placeholder="Create a password" autocomplete="new-password"
                   minlength="8" required>
            <button class="toggle" type="button" data-target="password"
                    aria-label="Show password">👁</button>
          </div>
        </div>

        <div class="group full">
          <label for="address">Delivery address *</label>
          <div class="wrap">
            <input id="address" name="address" type="text"
                   placeholder="Enter your complete address"
                   autocomplete="street-address" maxlength="500" required>
          </div>
        </div>

        <div class="group full">
          <label for="confirmPassword">Confirm password *</label>
          <div class="wrap">
            <input id="confirmPassword" name="confirmPassword" type="password"
                   placeholder="Re-enter your password"
                   autocomplete="new-password" required>
            <button class="toggle" type="button" data-target="confirmPassword"
                    aria-label="Show password">👁</button>
          </div>
        </div>
      </div>

      <button class="submit" type="submit">Create Account →</button>
    </form>

    <p class="bottom">Already have an account?
      <a href="<%= signupCp %>/login.jsp">Login here</a>
    </p>
    <a class="back" href="<%= signupCp %>/restaurant">← Back to restaurants</a>
  </section>
</main>

<script>
document.querySelectorAll(".toggle").forEach(function (button) {
  button.addEventListener("click", function () {
    const field = document.getElementById(this.dataset.target);
    const visible = field.type === "password";
    field.type = visible ? "text" : "password";
    this.textContent = visible ? "🙈" : "👁";
    this.setAttribute("aria-label", visible ? "Hide password" : "Show password");
  });
});

document.getElementById("signupForm").addEventListener("submit", function (event) {
  const phone = document.getElementById("phone").value.trim();
  const password = document.getElementById("password").value;
  const confirmPassword = document.getElementById("confirmPassword").value;

  if (!/^[0-9]{10}$/.test(phone)) {
    event.preventDefault();
    alert("Please enter a valid 10-digit mobile number.");
    document.getElementById("phone").focus();
    return;
  }

  if (password.length < 8) {
    event.preventDefault();
    alert("Password must contain at least 8 characters.");
    document.getElementById("password").focus();
    return;
  }

  if (password !== confirmPassword) {
    event.preventDefault();
    alert("Passwords do not match.");
    document.getElementById("confirmPassword").focus();
  }
});
</script>
</body>
</html>
