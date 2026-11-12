<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%!
  // makes text safe to print inside HTML
  static String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Login</title>

<style>

  /* ============================================================
     LOGIN PAGE  -  sunset sky + a friendly character
     that watches you type and covers its eyes for the password
     ============================================================ */

  :root{
    --ink:#fff7f0;
    --muted:rgba(255,247,240,.7);
    --sun:#ffb347;
    --hot:#ff4d1c;
    --pink:#ff3d7f;
    --glass:rgba(255,255,255,.12);
    --line:rgba(255,255,255,.28);
  }

  *{ box-sizing:border-box; margin:0; padding:0; }

  html, body{ min-height:100%; }

  body{
    font-family:'Helvetica Neue', Arial, sans-serif;
    color:var(--ink);
    overflow-x:hidden;
    position:relative;
    background:#1b0f3a;
  }

  /* ---------- sunset sky ---------- */
  .sky{
    position:fixed;
    inset:0;
    z-index:0;
    background:linear-gradient(180deg,#1b0f3a 0%,#4b1d6b 30%,#b0306a 58%,#ff6a3d 82%,#ffb347 100%);
    background-size:100% 160%;
    animation:skyShift 16s ease-in-out infinite alternate;
    overflow:hidden;
  }
  @keyframes skyShift{ from{ background-position:0 0; } to{ background-position:0 100%; } }

  /* the sun, slowly rising and falling */
  .sun{
    position:absolute;
    left:50%;
    bottom:-140px;
    width:380px; height:380px;
    margin-left:-190px;
    border-radius:50%;
    background:radial-gradient(circle,#fff3c4 0%,#ffd067 38%,#ff8a3d 68%,rgba(255,138,61,0) 72%);
    box-shadow:0 0 140px 60px rgba(255,160,70,.45);
    animation:sunRise 9s ease-in-out infinite alternate;
  }
  @keyframes sunRise{ from{ transform:translateY(40px) scale(.95);} to{ transform:translateY(-30px) scale(1.05);} }

  /* stars in the dark part of the sky */
  .stars{
    position:absolute;
    left:0; right:0; top:0;
    height:50%;
    background-image:
      radial-gradient(1.5px 1.5px at 10% 20%, #fff, transparent),
      radial-gradient(1.5px 1.5px at 30% 10%, #fff, transparent),
      radial-gradient(1px 1px at 52% 28%, #fff, transparent),
      radial-gradient(1.5px 1.5px at 70% 14%, #fff, transparent),
      radial-gradient(1px 1px at 86% 30%, #fff, transparent),
      radial-gradient(1px 1px at 20% 42%, #fff, transparent),
      radial-gradient(1.5px 1.5px at 94% 8%, #fff, transparent),
      radial-gradient(1px 1px at 62% 6%, #fff, transparent);
    animation:twinkle 3.5s ease-in-out infinite alternate;
  }
  @keyframes twinkle{ from{ opacity:.25; } to{ opacity:1; } }

  /* little glowing dots floating upwards */
  .dots span{
    position:absolute;
    bottom:-20px;
    width:10px; height:10px;
    border-radius:50%;
    background:rgba(255,230,190,.55);
    animation:rise 12s linear infinite;
  }
  .dots span:nth-child(1){ left:8%;  animation-duration:11s; animation-delay:0s; }
  .dots span:nth-child(2){ left:20%; animation-duration:14s; animation-delay:2s; width:6px; height:6px; }
  .dots span:nth-child(3){ left:34%; animation-duration:10s; animation-delay:4s; }
  .dots span:nth-child(4){ left:48%; animation-duration:15s; animation-delay:1s; width:7px; height:7px; }
  .dots span:nth-child(5){ left:63%; animation-duration:12s; animation-delay:3s; }
  .dots span:nth-child(6){ left:77%; animation-duration:13s; animation-delay:5s; width:6px; height:6px; }
  .dots span:nth-child(7){ left:90%; animation-duration:10s; animation-delay:2.5s; }
  @keyframes rise{
    from{ transform:translateY(0) scale(1); opacity:0; }
    10% { opacity:1; }
    to  { transform:translateY(-105vh) scale(.4); opacity:0; }
  }

  /* ---------- top bar ---------- */
  .topbar{
    position:relative;
    z-index:10;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:24px 44px;
    animation:fadeDown .8s ease both;
  }
  @keyframes fadeDown{ from{ opacity:0; transform:translateY(-14px);} to{ opacity:1; transform:none;} }

  .logo{
    font-size:22px;
    font-weight:800;
    letter-spacing:3px;
    text-transform:uppercase;
    text-decoration:none;
    color:var(--ink);
  }
  .logo b{ color:var(--sun); }

  .toplinks{ display:flex; gap:26px; align-items:center; }
  .toplinks a{
    text-decoration:none;
    color:var(--ink);
    font-weight:700;
    font-size:13px;
    letter-spacing:1.5px;
    text-transform:uppercase;
    position:relative;
    padding:4px 0;
  }
  .toplinks a::after{
    content:"";
    position:absolute;
    left:0; bottom:-3px;
    width:0; height:2px;
    background:var(--sun);
    transition:width .3s ease;
  }
  .toplinks a:hover::after{ width:100%; }
  .toplinks a.pill{
    padding:10px 20px;
    border:1.5px solid var(--line);
    background:var(--glass);
    border-radius:999px;
    transition:all .25s ease;
  }
  .toplinks a.pill::after{ display:none; }
  .toplinks a.pill:hover{ background:var(--ink); color:#4b1d6b; transform:translateY(-2px); }

  /* ---------- page + card ---------- */
  .page{
    position:relative;
    z-index:5;
    min-height:calc(100vh - 80px);
    display:flex;
    align-items:center;
    justify-content:center;
    padding:30px 20px 60px 20px;
  }

  .card{
    position:relative;
    width:100%;
    max-width:420px;
    padding:0 34px 34px 34px;
    margin-top:80px;
    border-radius:30px;
    background:var(--glass);
    border:1px solid var(--line);
    backdrop-filter:blur(20px);
    -webkit-backdrop-filter:blur(20px);
    box-shadow:0 34px 80px rgba(20,5,40,.5), inset 0 1px 0 rgba(255,255,255,.35);
    animation:cardIn 1s cubic-bezier(.2,.8,.2,1) both;
  }
  @keyframes cardIn{ from{ opacity:0; transform:translateY(60px) scale(.95);} to{ opacity:1; transform:none;} }

  /* ---------- the character ---------- */
  .mascot{
    width:170px;
    height:170px;
    margin:-84px auto 0 auto;
    position:relative;
    animation:bob 4s ease-in-out infinite;
  }
  @keyframes bob{ 0%,100%{ transform:translateY(0);} 50%{ transform:translateY(-8px);} }

  .mascot svg{ width:100%; height:100%; overflow:visible; display:block; }

  .pupil{ transition:transform .12s ease-out; }
  .eye-white{ transition:transform .3s ease; transform-origin:center; transform-box:fill-box; }

  /* hands start below the body and rise to cover the eyes */
  .hand{ transition:transform .45s cubic-bezier(.3,1.5,.5,1); }
  .mascot.cover .hand-l{ transform:translate(17px,-86px); }
  .mascot.cover .hand-r{ transform:translate(-17px,-86px); }
  /* "show password": peek through the fingers */
  .mascot.peek  .hand-l{ transform:translate(-2px,-70px); }
  .mascot.peek  .hand-r{ transform:translate(2px,-70px); }

  /* blinking */
  .lid{ transform-origin:center; transform-box:fill-box; animation:blink 5s infinite; }
  @keyframes blink{ 0%,92%,100%{ transform:scaleY(0);} 95%{ transform:scaleY(1);} }

  /* mouth: happy by default, sad when the login failed */
  .mouth-sad{ display:none; }
  .mascot.sad .mouth-happy{ display:none; }
  .mascot.sad .mouth-sad{ display:block; }
  .mascot.sad{ animation:headShake .6s ease both; }
  @keyframes headShake{
    0%,100%{ transform:translateX(0) rotate(0); }
    20%{ transform:translateX(-14px) rotate(-6deg); }
    40%{ transform:translateX(14px) rotate(6deg); }
    60%{ transform:translateX(-9px) rotate(-3deg); }
    80%{ transform:translateX(9px) rotate(3deg); }
  }

  /* ---------- heading ---------- */
  .card h1{
    margin-top:10px;
    text-align:center;
    font-size:30px;
    font-weight:900;
    letter-spacing:-.3px;
    animation:up .8s .4s ease both;
  }
  .sub{
    margin-top:6px;
    text-align:center;
    font-size:14px;
    color:var(--muted);
    animation:up .8s .5s ease both;
  }
  @keyframes up{ from{ opacity:0; transform:translateY(20px);} to{ opacity:1; transform:none;} }

  form{ margin-top:26px; }

  /* ---------- round inputs ---------- */
  .field{
    position:relative;
    margin-bottom:16px;
    animation:up .7s ease both;
  }
  .field.a{ animation-delay:.6s; }
  .field.b{ animation-delay:.72s; }

  .field input{
    width:100%;
    padding:17px 50px 17px 52px;
    font-family:inherit;
    font-size:15px;
    font-weight:600;
    color:#fff;
    background:rgba(255,255,255,.14);
    border:1.5px solid transparent;
    border-radius:999px;
    outline:none;
    transition:all .3s ease;
  }
  .field input::placeholder{ color:rgba(255,247,240,.6); font-weight:500; }

  .field input:focus{
    background:rgba(255,255,255,.24);
    border-color:var(--sun);
    box-shadow:0 0 0 5px rgba(255,179,71,.22), 0 10px 30px rgba(255,100,40,.25);
  }

  .field .lead{
    position:absolute;
    left:20px; top:50%;
    width:20px; height:20px;
    margin-top:-10px;
    fill:none;
    stroke:rgba(255,247,240,.8);
    stroke-width:1.8;
    stroke-linecap:round;
    stroke-linejoin:round;
    pointer-events:none;
    transition:stroke .25s ease, transform .3s ease;
  }
  .field input:focus ~ .lead{ stroke:var(--sun); transform:scale(1.15); }

  .eye{
    position:absolute;
    right:10px; top:50%;
    margin-top:-18px;
    width:36px; height:36px;
    display:flex;
    align-items:center;
    justify-content:center;
    background:transparent;
    border:none;
    border-radius:50%;
    cursor:pointer;
    transition:background .2s ease;
  }
  .eye:hover{ background:rgba(255,255,255,.2); }
  .eye svg{
    width:19px; height:19px;
    fill:none;
    stroke:#fff;
    stroke-width:1.8;
    stroke-linecap:round;
    stroke-linejoin:round;
  }

  /* ---------- error ---------- */
  .form-error{
    margin-bottom:16px;
    padding:13px 18px;
    font-size:13px;
    font-weight:700;
    text-align:center;
    color:#fff;
    background:rgba(120,10,40,.45);
    border:1px solid rgba(255,120,150,.6);
    border-radius:16px;
    animation:shake .5s ease both;
  }
  @keyframes shake{
    0%,100%{ transform:translateX(0); }
    20%{ transform:translateX(-9px); }
    40%{ transform:translateX(9px); }
    60%{ transform:translateX(-5px); }
    80%{ transform:translateX(5px); }
  }

  /* ---------- button ---------- */
  .go{
    position:relative;
    width:100%;
    margin-top:8px;
    padding:18px 20px;
    overflow:hidden;
    font-family:inherit;
    font-size:13px;
    font-weight:900;
    letter-spacing:3px;
    text-transform:uppercase;
    color:#3a0f2a;
    background:linear-gradient(90deg,#ffd067,#ff8a3d,#ff3d7f,#ff8a3d,#ffd067);
    background-size:300% 100%;
    border:none;
    border-radius:999px;
    cursor:pointer;
    box-shadow:0 14px 36px rgba(255,90,40,.45);
    animation:up .7s .86s ease both, flow 6s linear infinite;
    transition:transform .25s ease, box-shadow .25s ease;
  }
  @keyframes flow{ from{ background-position:0 0; } to{ background-position:300% 0; } }

  .go:hover{ transform:translateY(-3px) scale(1.02); box-shadow:0 20px 46px rgba(255,90,40,.65); }
  .go:active{ transform:scale(.98); }

  /* ripple circle on click */
  .go .ripple{
    position:absolute;
    border-radius:50%;
    background:rgba(255,255,255,.65);
    transform:scale(0);
    animation:ripple .65s ease-out;
    pointer-events:none;
  }
  @keyframes ripple{ to{ transform:scale(4); opacity:0; } }

  .below{
    margin-top:22px;
    display:flex;
    justify-content:space-between;
    align-items:center;
    font-size:13px;
    font-weight:600;
    color:var(--muted);
    animation:up .7s 1s ease both;
  }
  .below a{
    color:var(--ink);
    font-weight:800;
    text-decoration:none;
    position:relative;
  }
  .below a::after{
    content:"";
    position:absolute;
    left:0; bottom:-3px;
    width:100%; height:2px;
    background:var(--sun);
    transform:scaleX(0);
    transform-origin:left;
    transition:transform .3s ease;
  }
  .below a:hover::after{ transform:scaleX(1); }
  .below a.hot{ color:var(--sun); }

  @media (max-width:560px){
    .topbar{ padding:18px 20px; }
    .toplinks a:not(.pill){ display:none; }
    .card{ padding:0 22px 28px 22px; }
    .below{ flex-direction:column; gap:12px; }
  }

  @media (prefers-reduced-motion: reduce){
    *, *::before, *::after{
      animation:none !important;
      transition:none !important;
    }
  }

</style>
</head>

<body>

<%@ include file="db.jsp" %>

<%
  // ---------- LOGIN CHECK (runs when the form is submitted) ----------
  String un = request.getParameter("untxt");
  String pw = request.getParameter("pwtxt");

  boolean tried  = request.getParameter("Submit") != null;
  boolean ok     = false;
  boolean failed = false;
  String  err    = null;

  if (tried) {
    try {
      PreparedStatement lps = con.prepareStatement(
        "select * from signin where name=? and password=?");
      lps.setString(1, un);
      lps.setString(2, pw);
      rst = lps.executeQuery();

      if (rst.next()) {
        ok = true;
        session.setAttribute("uname", un);
        session.setAttribute("upass", pw);
      } else {
        failed = true;
      }
    } catch (Exception ex) {
      err = ex.toString();
    }
  }
%>

<!-- sunset sky -->
<div class="sky">
  <div class="stars"></div>
  <div class="sun"></div>
  <div class="dots">
    <span></span><span></span><span></span><span></span><span></span><span></span><span></span>
  </div>
</div>

<div class="topbar">
  <a href="home.html" class="logo">Sto<b>re</b></a>
  <div class="toplinks">
    <a href="home.html">Home</a>
    <a href="signin.jsp" class="pill">Sign In</a>
  </div>
</div>

<div class="page">
<div class="card">

  <!-- the character -->
  <div class="mascot<%= (failed || err != null) ? " sad" : "" %>" id="mascot">
    <svg viewBox="0 0 200 200" aria-hidden="true">
      <defs>
        <radialGradient id="body" cx="40%" cy="30%" r="80%">
          <stop offset="0" stop-color="#ffe29a"/>
          <stop offset="0.6" stop-color="#ffb347"/>
          <stop offset="1" stop-color="#ff7a2f"/>
        </radialGradient>
        <linearGradient id="hand" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stop-color="#ffe29a"/>
          <stop offset="1" stop-color="#ff9a3d"/>
        </linearGradient>
      </defs>

      <!-- ground shadow -->
      <ellipse cx="100" cy="188" rx="52" ry="7" fill="rgba(0,0,0,.22)"/>

      <!-- ears -->
      <circle cx="40"  cy="70" r="18" fill="#ff9a3d"/>
      <circle cx="160" cy="70" r="18" fill="#ff9a3d"/>
      <circle cx="40"  cy="70" r="9"  fill="#ffd9b0"/>
      <circle cx="160" cy="70" r="9"  fill="#ffd9b0"/>

      <!-- body -->
      <circle cx="100" cy="108" r="72" fill="url(#body)"/>

      <!-- cheeks -->
      <circle cx="56"  cy="124" r="11" fill="#ff5f7a" opacity=".5"/>
      <circle cx="144" cy="124" r="11" fill="#ff5f7a" opacity=".5"/>

      <!-- eyes -->
      <g id="eyeL">
        <ellipse class="eye-white" cx="72" cy="98" rx="19" ry="21" fill="#fff"/>
        <circle  class="pupil" id="pupilL" cx="72" cy="100" r="9" fill="#2a1233"/>
        <circle  cx="68" cy="95" r="3" fill="#fff"/>
        <ellipse class="lid" cx="72" cy="98" rx="20" ry="22" fill="#ffb347"/>
      </g>
      <g id="eyeR">
        <ellipse class="eye-white" cx="128" cy="98" rx="19" ry="21" fill="#fff"/>
        <circle  class="pupil" id="pupilR" cx="128" cy="100" r="9" fill="#2a1233"/>
        <circle  cx="124" cy="95" r="3" fill="#fff"/>
        <ellipse class="lid" cx="128" cy="98" rx="20" ry="22" fill="#ffb347"/>
      </g>

      <!-- mouth -->
      <path class="mouth-happy" d="M82 138q18 18 36 0" stroke="#7a2a1a" stroke-width="5" fill="none" stroke-linecap="round"/>
      <path class="mouth-sad"   d="M82 150q18 -16 36 0" stroke="#7a2a1a" stroke-width="5" fill="none" stroke-linecap="round"/>

      <!-- hands (they slide up over the eyes) -->
      <g class="hand hand-l"><circle cx="54"  cy="186" r="22" fill="url(#hand)" stroke="#ff8a3d" stroke-width="2"/></g>
      <g class="hand hand-r"><circle cx="146" cy="186" r="22" fill="url(#hand)" stroke="#ff8a3d" stroke-width="2"/></g>
    </svg>
  </div>

  <h1>Welcome Back!</h1>
  <p class="sub">Login to continue your shopping</p>

  <form id="form1" name="form1" method="post" action="">

<% if (failed) { %>
    <div class="form-error">Oops! Wrong user name or password. Try again.</div>
<% } %>
<% if (err != null) { %>
    <div class="form-error">Something went wrong: <%= esc(err) %></div>
<% } %>

    <div class="field a">
      <input id="untxt" name="untxt" type="text" placeholder="User name" value="<%= failed ? esc(un) : "" %>" autocomplete="username" />
      <svg class="lead" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/></svg>
    </div>

    <div class="field b">
      <input id="pwtxt" name="pwtxt" type="password" placeholder="Password" autocomplete="current-password" />
      <svg class="lead" viewBox="0 0 24 24"><rect x="5" y="11" width="14" height="10" rx="2.5"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/></svg>
      <button type="button" class="eye" id="eye" aria-label="Show or hide password">
        <svg viewBox="0 0 24 24"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></svg>
      </button>
    </div>

    <input type="hidden" name="Submit" value="Submit" />
    <button type="submit" class="go" id="go">Login</button>

    <div class="below">
      <a href="home.html">&larr; Back</a>
      <span>New here? <a href="signin.jsp" class="hot">Create Account</a></span>
    </div>

  </form>

</div>
</div>

<script>
  var mascot = document.getElementById('mascot');
  var user   = document.getElementById('untxt');
  var pass   = document.getElementById('pwtxt');
  var pL     = document.getElementById('pupilL');
  var pR     = document.getElementById('pupilR');

  // ---------- pupils follow the mouse ----------
  function look(x, y) {
    var t = 'translate(' + x + 'px,' + y + 'px)';
    pL.style.transform = t;
    pR.style.transform = t;
  }

  var userFocused = false;

  document.addEventListener('mousemove', function (e) {
    if (userFocused || document.activeElement === pass) return;
    var r  = mascot.getBoundingClientRect();
    var cx = r.left + r.width  / 2;
    var cy = r.top  + r.height / 2;
    var dx = e.clientX - cx;
    var dy = e.clientY - cy;
    var d  = Math.sqrt(dx * dx + dy * dy) || 1;
    var m  = Math.min(7, d / 40);
    look(dx / d * m, dy / d * m);
  });

  // ---------- user name: look down and follow the text ----------
  user.addEventListener('focus', function () {
    userFocused = true;
    mascot.classList.remove('sad');
    syncLook();
  });
  user.addEventListener('blur', function () { userFocused = false; });
  user.addEventListener('input', syncLook);

  function syncLook() {
    var n = user.value.length;
    var x = Math.min(7, -6 + n * 0.8);
    look(x, 5);
  }

  // ---------- password: cover eyes ----------
  var shown = false;

  function updateHands() {
    mascot.classList.remove('cover', 'peek');
    if (document.activeElement === pass) {
      mascot.classList.add(shown ? 'peek' : 'cover');
    }
  }

  pass.addEventListener('focus', function () { mascot.classList.remove('sad'); updateHands(); });
  pass.addEventListener('blur', updateHands);

  document.getElementById('eye').addEventListener('click', function () {
    shown = !shown;
    pass.type = shown ? 'text' : 'password';
    pass.focus();
    updateHands();
  });

  // ---------- ripple on the button ----------
  document.getElementById('go').addEventListener('click', function (e) {
    var b = this, r = b.getBoundingClientRect();
    var s = Math.max(r.width, r.height);
    var d = document.createElement('span');
    d.className = 'ripple';
    d.style.width = d.style.height = s + 'px';
    d.style.left = (e.clientX - r.left - s / 2) + 'px';
    d.style.top  = (e.clientY - r.top  - s / 2) + 'px';
    b.appendChild(d);
    setTimeout(function () { d.remove(); }, 700);
  });
</script>

<%
  // ---------- LOGIN SUCCESS: create the cart, then go to the shop ----------
  if (ok) {
%>
<%@ include file="makecart.jsp" %>

<script>
  window.location.href = "loginhome.html";
</script>
<%
  }
%>

</body>
</html>
