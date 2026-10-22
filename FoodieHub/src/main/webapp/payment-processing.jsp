
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.tap.model.Cart" %>
<%
String cp = request.getContextPath();
Cart cart = (Cart) session.getAttribute("cart");

if (session.getAttribute("loggedInUser") == null) {
    response.sendRedirect(cp + "/login.jsp"); return;
}
if (cart == null || cart.isEmpty()) {
    response.sendRedirect(cp + "/cart"); return;
}

String method = request.getParameter("demoMethod");
if (!"UPI".equals(method) && !"Card".equals(method) && !"Wallet".equals(method)) {
    response.sendRedirect(cp + "/payment.jsp"); return;
}
session.setAttribute("selectedDemoMethod", method);
session.setAttribute("pendingPaymentAmount", cart.getTotalAmount());
double amount = cart.getTotalAmount();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Processing Payment | FoodieHub</title>
<style>
*{box-sizing:border-box}
body{margin:0;min-height:100vh;font-family:Arial,sans-serif;color:white;background:radial-gradient(ellipse at 50% 30%,#087b3b,transparent 48%),linear-gradient(135deg,#021b0c,#04391d 55%,#011509);overflow-x:hidden}
.scene{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:28px 16px;position:relative;overflow:hidden}
.scene:before{content:"";position:absolute;inset:0;opacity:.18;background-image:linear-gradient(#ffffff0b 1px,transparent 1px),linear-gradient(90deg,#ffffff0b 1px,transparent 1px);background-size:40px 40px}
.brand{position:absolute;top:24px;left:27px;font-size:23px;font-weight:800}
.brand span{color:#ff7048}
.badge{position:absolute;top:28px;right:25px;border:1px solid #a8ff7245;padding:9px 13px;border-radius:30px;color:#caffad;font-size:10px}
.content{width:min(760px,100%);position:relative;text-align:center;padding-top:45px}
.pill{display:inline-block;border:1px solid #8dffad35;padding:9px 14px;border-radius:30px;color:#c4ffd2;font-size:11px;letter-spacing:1.4px}
.dot{display:inline-block;width:7px;height:7px;background:#6dff90;border-radius:50%;margin-right:8px;box-shadow:0 0 13px #70ff92;animation:blink 1s infinite}
@keyframes blink{50%{opacity:.3}}
h1{font-size:clamp(30px,5vw,47px);letter-spacing:-1.5px;margin:22px 0 10px}
.green{color:#a8ff72}
.subtitle{color:#c5d9cc;font-size:13px;line-height:1.7}
.track{height:190px;position:relative;margin:10px auto;width:min(690px,100%)}
.line{position:absolute;left:13%;right:13%;top:50%;height:3px;background:linear-gradient(90deg,transparent,#a8ff72,transparent);box-shadow:0 0 18px #7aff9c70}
.dashes{position:absolute;left:15%;right:15%;top:50%;border-top:2px dashed #d9ffbd}
.endpoint{position:absolute;top:50%;transform:translateY(-50%);width:65px;height:65px;display:grid;place-items:center;border-radius:50%;border:1px solid #a8ff7270;background:radial-gradient(circle at 30% 25%,#208b50,#05371e);font-size:27px;box-shadow:0 0 25px #46ff8a20}
.left{left:3%}.right{right:3%}
.endpoint small{position:absolute;top:74px;font-size:9px;white-space:nowrap;color:#c2e8cf}
.coinpath{position:absolute;left:15%;right:15%;top:50%;height:1px}
.coin{position:absolute;left:0;top:50%;width:72px;height:72px;margin-top:-36px;border-radius:50%;display:grid;place-items:center;font-size:35px;font-weight:800;color:#8a4a00;background:radial-gradient(circle at 30% 24%,#fff7b5,#ffdf60 25%,#ffb91f 60%,#d87b00);border:4px solid #ffe98a;box-shadow:0 0 0 7px #ffdf6020,0 0 30px #ffcb43,0 0 60px #ffbf4b85,inset 0 0 0 3px #ffe79a;animation:travel 3s ease-in-out infinite}
@keyframes travel{0%{left:0;transform:translateY(-5px) rotateY(0) scale(.8)}50%{transform:translateY(-12px) rotateY(360deg) scale(1.08)}100%{left:calc(100% - 72px);transform:translateY(-5px) rotateY(720deg) scale(.8)}}
.status{max-width:520px;margin:auto;padding:22px;text-align:left;border:1px solid #77ff9d40;border-radius:19px;background:linear-gradient(145deg,#064b29ed,#022b18f2);box-shadow:0 18px 55px #0002}
.status-head{display:flex;justify-content:space-between;gap:10px;margin-bottom:19px;font-size:13px}
.status-head span{color:#a4d8b5;font-size:10px}
.step{display:flex;align-items:center;gap:12px;margin:14px 0;color:#8eb39c;font-size:12px}
.circle{width:25px;height:25px;flex:0 0 25px;border-radius:50%;display:grid;place-items:center;background:#1d6340}
.step.active{color:white;font-weight:bold}.step.active .circle{background:#b5ff75;color:#06451f;box-shadow:0 0 15px #b5ff7555}
.step.done{color:#c4ffcc}.step.done .circle{background:#149a4e;color:white}
.bar{height:7px;background:#15482d;border-radius:20px;overflow:hidden;margin-top:22px}
.fill{width:4%;height:100%;border-radius:20px;background:linear-gradient(90deg,#42df8c,#d3ff77);box-shadow:0 0 14px #8cff94;transition:width .5s}
.meta{display:flex;justify-content:space-between;margin-top:9px;color:#9fc9ad;font-size:10px}
.footer{margin-top:22px;font-size:11px;color:#a8c7b4;line-height:1.8}
.overlay{position:fixed;inset:0;z-index:10;display:none;align-items:center;justify-content:center;padding:20px;background:#021b0ef5;backdrop-filter:blur(12px)}
.result{width:min(440px,100%);padding:32px 24px;text-align:center;border:1px solid #8cff984d;border-radius:24px;background:linear-gradient(145deg,#07532c,#032d18);box-shadow:0 0 80px #26ff7222;animation:pop .45s ease-out}
@keyframes pop{from{opacity:0;transform:translateY(20px) scale(.95)}to{opacity:1;transform:translateY(0) scale(1)}}
.check{width:90px;height:90px;margin:0 auto 20px;display:grid;place-items:center;border-radius:50%;background:linear-gradient(145deg,#a9ff6a,#36d87a);color:#06421f;font-size:48px;box-shadow:0 0 0 10px #b4ff7020,0 0 45px #aaff6a50}
.result h2{font-size:28px;margin:0 0 10px}.result p{color:#c6e5d0;font-size:13px;line-height:1.7}
.amount{font-size:34px;color:#baff7d;font-weight:800;margin:20px}
button{width:100%;padding:15px;border:0;border-radius:12px;background:linear-gradient(110deg,#ff7045,#ff3e20);color:white;font-size:14px;font-weight:800;cursor:pointer}
.confetti{position:fixed;top:-15px;width:9px;height:14px;z-index:15;animation:fall 3s linear forwards}
@keyframes fall{to{transform:translateY(110vh) rotate(700deg);opacity:0}}
@media(max-width:600px){.brand{left:15px;top:16px;font-size:19px}.badge{right:12px;top:20px;font-size:9px}.track{height:160px}.endpoint{width:52px;height:52px;font-size:22px}.endpoint small{top:60px;font-size:8px}.coin{width:56px;height:56px;margin-top:-28px;font-size:27px}@keyframes travel{0%{left:0;transform:translateY(-4px) rotateY(0) scale(.8)}50%{transform:translateY(-9px) rotateY(360deg) scale(1.04)}100%{left:calc(100% - 56px);transform:translateY(-4px) rotateY(720deg) scale(.8)}}}
@media(prefers-reduced-motion:reduce){*,*:before,*:after{animation-duration:.01ms!important;animation-iteration-count:1!important}}
</style>
</head>
<body>
<main class="scene">
<div class="brand">🍴 Foodie<span>Hub</span></div>
<div class="badge">🔒 DEMO PAYMENT</div>

<div class="content">
<div class="pill"><span class="dot"></span> SECURE PAYMENT SIMULATION</div>
<h1 id="heading">Processing Your <span class="green">Payment</span></h1>
<p class="subtitle" id="subtitle">Please keep this page open while we complete the demo transaction.</p>

<div class="track">
<div class="line"></div><div class="dashes"></div>
<div class="endpoint left">👤<small>CUSTOMER</small></div>
<div class="endpoint right">🏦<small>PAYMENT NODE</small></div>
<div class="coinpath"><div class="coin">₹</div></div>
</div>

<section class="status">
<div class="status-head"><strong id="statusTitle">Initiating secure connection</strong><span id="counter">STEP 1 OF 5</span></div>
<div class="step active"><span class="circle">1</span>Initiating secure connection...</div>
<div class="step"><span class="circle">2</span>Verifying selected payment method...</div>
<div class="step"><span class="circle">3</span>Processing demo transaction...</div>
<div class="step"><span class="circle">4</span>Confirming simulated payment...</div>
<div class="step"><span class="circle">5</span>Preparing order confirmation...</div>
<div class="bar"><div class="fill" id="fill"></div></div>
<div class="meta"><span id="message">Connecting...</span><span id="percent">4%</span></div>
</section>
<div class="footer">🛡️ FoodieHub Demo Mode<br>No real bank connection or charge occurs.</div>
</div>
</main>

<section class="overlay" id="successOverlay">
<div class="result">
<div class="check">✓</div>
<h2>Payment Successful!</h2>
<p>Your demo payment simulation is complete.<br>No real money has been charged.</p>
<div class="amount">₹<%= String.format(java.util.Locale.US,"%.2f",amount) %></div>
<p>Continue to save your order and view the confirmation.</p>
<button type="button" id="continueButton">Continue to Order Confirmation →</button>
</div>
</section>

<script>
(function(){
"use strict";
const cp = <%= "\"" + cp.replace("\\","\\\\").replace("\"","\\\"") + "\"" %>;
const steps = Array.from(document.querySelectorAll(".step"));
const fill = document.getElementById("fill");
const percent = document.getElementById("percent");
const message = document.getElementById("message");
const statusTitle = document.getElementById("statusTitle");
const counter = document.getElementById("counter");
const overlay = document.getElementById("successOverlay");
const continueButton = document.getElementById("continueButton");

const milestones = [
 {value:15,message:"Opening demo session...",title:"Initiating secure connection"},
 {value:35,message:"Checking selected method...",title:"Verifying payment method"},
 {value:58,message:"Running payment simulation...",title:"Processing demo transaction"},
 {value:80,message:"Completing simulated transaction...",title:"Confirming demo payment"},
 {value:100,message:"Preparing your confirmation...",title:"Finalizing payment journey"}
];
let index = 0;
let submitted = false;

function render(n){
 steps.forEach(function(step,i){
  step.classList.remove("active","done");
  const icon=step.querySelector(".circle");
  if(i<n){step.classList.add("done");icon.textContent="✓";}
  else if(i===n){step.classList.add("active");icon.textContent="•";}
  else{icon.textContent=String(i+1);}
 });
 const m=milestones[n];
 fill.style.width=m.value+"%";
 percent.textContent=m.value+"%";
 message.textContent=m.message;
 statusTitle.textContent=m.title;
 counter.textContent="STEP "+(n+1)+" OF 5";
}
function confetti(){
 const colors=["#a8ff72","#ff7045","#ffe16a","#fff","#4ce49a"];
 for(let i=0;i<65;i++){
  const el=document.createElement("span");
  el.className="confetti";
  el.style.left=Math.random()*100+"vw";
  el.style.backgroundColor=colors[Math.floor(Math.random()*colors.length)];
  el.style.animationDelay=Math.random()+"s";
  document.body.appendChild(el);
  setTimeout(()=>el.remove(),4500);
 }
}
function next(){
 if(index<milestones.length-1){
  index++;
  render(index);
  setTimeout(next,900);
 }else{
  document.getElementById("heading").innerHTML='Payment <span class="green">Confirmed!</span>';
  document.getElementById("subtitle").textContent="Your demo payment simulation is complete.";
  overlay.style.display="flex";
  confetti();
 }
}
render(0);
setTimeout(next,800);

continueButton.addEventListener("click",function(){
 if(submitted)return;
 submitted=true;
 continueButton.disabled=true;
 continueButton.textContent="Saving Your Order...";
 const form=document.createElement("form");
 form.method="POST";
 form.action=cp+"/place-order";
 const payment=document.createElement("input");
 payment.type="hidden";
 payment.name="payment";
 payment.value="Online Payment";
 form.appendChild(payment);
 document.body.appendChild(form);
 form.submit();
});
})();
</script>
</body>
</html>
