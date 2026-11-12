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
<title>Edit Profile</title>

<style>

  /* ============================================================
     EDIT PROFILE PAGE - same look as the profile page,
     with a live preview card and floating-label fields
     ============================================================ */

  :root{
    --ink:#141414;
    --paper:#f5f4f0;
    --card:#ffffff;
    --accent:#ff4d1c;
    --gold:#ffb347;
    --pink:#ff3d7f;
    --muted:#7a766f;
    --line:rgba(20,20,20,.14);
    --soft:0 20px 50px rgba(20,20,20,.10);
  }

  *{ box-sizing:border-box; margin:0; padding:0; }

  body{
    font-family:'Helvetica Neue', Arial, sans-serif;
    background:var(--paper);
    color:var(--ink);
    overflow-x:hidden;
  }

  /* ---------- navbar ---------- */
  .navbar{
    position:relative;
    z-index:30;
    display:grid;
    grid-template-columns:1fr auto 1fr;
    align-items:center;
    padding:18px 40px;
    background:rgba(245,244,240,.82);
    backdrop-filter:blur(12px);
    -webkit-backdrop-filter:blur(12px);
    border-bottom:3px solid var(--ink);
  }
  .logo{ font-size:22px; font-weight:800; letter-spacing:2px; text-transform:uppercase; justify-self:start; }
  .logo span{ color:var(--accent); }

  .nav-center{ display:flex; gap:48px; justify-self:center; }
  .nav-center a{
    position:relative;
    text-decoration:none;
    color:var(--ink);
    font-weight:700;
    font-size:15px;
    letter-spacing:1px;
    text-transform:uppercase;
    padding:6px 2px;
  }
  .nav-center a::after{
    content:"";
    position:absolute;
    left:0; bottom:-2px;
    width:0; height:3px;
    background:var(--accent);
    transition:width .25s ease;
  }
  .nav-center a:hover::after{ width:100%; }

  .nav-right{ display:flex; gap:14px; justify-self:end; align-items:center; }
  .btn{
    text-decoration:none;
    font-weight:700;
    font-size:13px;
    letter-spacing:1px;
    text-transform:uppercase;
    padding:10px 20px;
    border-radius:999px;
    border:2px solid var(--ink);
    color:var(--ink);
    transition:all .2s ease;
  }
  .btn:hover{ background:var(--ink); color:var(--paper); }
  .btn-cart{ background:var(--accent); border-color:var(--accent); }
  .btn-cart:hover{ background:var(--ink); border-color:var(--ink); }
  .btn.on{ background:var(--ink); color:var(--paper); }

  @media (max-width:700px){
    .navbar{ grid-template-columns:1fr; row-gap:14px; padding:16px 20px; }
    .logo, .nav-center, .nav-right{ justify-self:center; }
    .nav-center{ gap:26px; }
  }

  /* ---------- animated cover ---------- */
  .cover{
    position:relative;
    height:220px;
    overflow:hidden;
    background:linear-gradient(115deg,#ff4d1c,#ff3d7f,#ffb347,#ff4d1c);
    background-size:300% 300%;
    animation:coverFlow 12s ease-in-out infinite;
  }
  @keyframes coverFlow{ 0%{background-position:0% 50%;} 50%{background-position:100% 50%;} 100%{background-position:0% 50%;} }

  .cover .c{
    position:absolute;
    border-radius:50%;
    background:rgba(255,255,255,.18);
    animation:floaty 8s ease-in-out infinite alternate;
  }
  .c1{ width:220px; height:220px; top:-70px; left:8%; }
  .c2{ width:120px; height:120px; top:50px; left:42%; animation-duration:6s; background:rgba(20,20,20,.1); }
  .c3{ width:300px; height:300px; top:-120px; right:6%; animation-duration:10s; }
  .c4{ width:60px; height:60px; top:130px; right:34%; animation-duration:5s; background:rgba(255,255,255,.3); }
  @keyframes floaty{ from{ transform:translateY(0) scale(1);} to{ transform:translateY(26px) scale(1.12);} }

  .cover-text{
    position:absolute;
    left:50%; top:44%;
    transform:translate(-50%,-50%);
    width:100%;
    text-align:center;
    color:#fff;
    z-index:3;
    animation:fadeUp .9s .2s ease both;
  }
  .cover-text small{ font-size:12px; font-weight:800; letter-spacing:5px; text-transform:uppercase; opacity:.9; }
  .cover-text h2{
    margin-top:8px;
    font-size:42px;
    font-weight:900;
    letter-spacing:-1px;
    padding:0 20px;
    text-shadow:0 6px 24px rgba(120,20,20,.3);
  }
  @keyframes fadeUp{ from{ opacity:0; transform:translate(-50%,calc(-50% + 22px)); } to{ opacity:1; transform:translate(-50%,-50%); } }

  .waves{ position:absolute; left:0; bottom:-1px; width:200%; height:80px; z-index:2; }
  .waves svg{ width:100%; height:100%; display:block; }
  .w1{ animation:waveMove 14s linear infinite; opacity:.55; }
  .w2{ animation:waveMove 9s linear infinite reverse; }
  @keyframes waveMove{ from{ transform:translateX(0);} to{ transform:translateX(-50%);} }

  /* ---------- layout ---------- */
  .wrap{
    position:relative;
    z-index:5;
    max-width:1060px;
    margin:-90px auto 70px auto;
    padding:0 22px;
    display:grid;
    grid-template-columns:330px 1fr;
    gap:26px;
    align-items:start;
  }

  .panel{
    background:var(--card);
    border-radius:26px;
    box-shadow:var(--soft);
    border:1px solid rgba(20,20,20,.06);
    animation:rise .9s cubic-bezier(.2,.8,.2,1) both;
  }
  @keyframes rise{ from{ opacity:0; transform:translateY(40px);} to{ opacity:1; transform:none;} }

  /* ---------- left: live preview ---------- */
  .me{ padding:0 26px 28px 26px; text-align:center; animation-delay:.1s; }

  .avatar-wrap{
    position:relative;
    width:150px; height:150px;
    margin:-75px auto 16px auto;
    animation:pop .9s .4s cubic-bezier(.2,1.3,.4,1) both;
  }
  @keyframes pop{ from{ opacity:0; transform:scale(.3) rotate(-25deg);} to{ opacity:1; transform:none;} }

  .avatar-wrap::before{
    content:"";
    position:absolute;
    inset:0;
    border-radius:50%;
    background:conic-gradient(from 0deg,var(--accent),var(--gold),var(--pink),var(--accent));
    animation:spin 6s linear infinite;
  }
  .avatar-wrap::after{
    content:"";
    position:absolute;
    inset:-14px;
    border-radius:50%;
    background:radial-gradient(circle,rgba(255,77,28,.35),transparent 68%);
    z-index:-1;
    animation:pulse 3s ease-in-out infinite;
  }
  @keyframes spin{ to{ transform:rotate(360deg);} }
  @keyframes pulse{ 0%,100%{ transform:scale(.9); opacity:.6;} 50%{ transform:scale(1.15); opacity:1;} }

  .avatar{
    position:absolute;
    inset:6px;
    border-radius:50%;
    overflow:hidden;
    background:#fff;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:58px;
    font-weight:900;
    text-transform:uppercase;
    color:var(--accent);
  }
  .avatar svg{ width:100%; height:100%; display:block; }

  .me h1{ font-size:26px; font-weight:900; letter-spacing:-.3px; word-break:break-word; }
  .me .mail{ margin-top:6px; font-size:13px; font-weight:600; color:var(--muted); word-break:break-all; min-height:18px; }

  .chip{
    display:inline-flex;
    align-items:center;
    gap:8px;
    margin-top:14px;
    padding:7px 15px;
    font-size:11px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:#1c7a45;
    background:#e5f8ec;
    border-radius:999px;
    transition:all .3s ease;
  }
  .chip i{ width:8px; height:8px; border-radius:50%; background:#2ecc71; }
  .chip.dirty{ color:#a5521a; background:#fff1e0; }
  .chip.dirty i{ background:var(--gold); animation:ping 1.6s ease-out infinite; }
  @keyframes ping{
    0%{ box-shadow:0 0 0 0 rgba(255,179,71,.8); }
    80%,100%{ box-shadow:0 0 0 10px rgba(255,179,71,0); }
  }

  .bump{ animation:bump .35s ease; }
  @keyframes bump{ 0%{ transform:scale(1);} 40%{ transform:scale(1.07);} 100%{ transform:scale(1);} }

  .tip{
    margin-top:22px;
    padding:14px 16px;
    text-align:left;
    font-size:12px;
    font-weight:600;
    line-height:1.5;
    color:var(--muted);
    background:#faf8f4;
    border-radius:14px;
  }
  .tip b{ color:var(--ink); }

  /* ---------- right: form ---------- */
  .formpanel{ padding:34px 34px 32px 34px; animation-delay:.2s; }

  .formpanel h3{
    font-size:12px;
    font-weight:800;
    letter-spacing:3px;
    text-transform:uppercase;
    color:var(--muted);
  }
  .formpanel h2{
    margin-top:6px;
    font-size:28px;
    font-weight:900;
    letter-spacing:-.4px;
  }
  .formpanel .sub{ margin-top:4px; font-size:14px; color:var(--muted); }

  form{ margin-top:26px; }

  .fld{ position:relative; margin-bottom:18px; }

  .fld input{
    width:100%;
    padding:24px 46px 9px 52px;
    font-family:inherit;
    font-size:15px;
    font-weight:700;
    color:var(--ink);
    background:#faf8f4;
    border:1.5px solid var(--line);
    border-radius:16px;
    outline:none;
    transition:all .25s ease;
  }
  .fld input:focus{
    background:#fff;
    border-color:var(--accent);
    box-shadow:0 0 0 5px rgba(255,77,28,.12), 0 10px 26px rgba(255,77,28,.10);
  }

  .fld label{
    position:absolute;
    left:52px; top:8px;
    font-size:10px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:var(--muted);
    pointer-events:none;
    transition:color .2s ease;
  }
  .fld input:focus + label{ color:var(--accent); }

  .fld .lead{
    position:absolute;
    left:18px; top:50%;
    width:22px; height:22px;
    margin-top:-11px;
    fill:none; stroke:var(--accent); stroke-width:1.9;
    stroke-linecap:round; stroke-linejoin:round;
    pointer-events:none;
    transition:transform .3s ease;
  }
  .fld input:focus ~ .lead{ transform:scale(1.15) rotate(-6deg); }

  .fld .tag{
    position:absolute;
    right:14px; top:50%;
    margin-top:-10px;
    padding:4px 10px;
    font-size:9px;
    font-weight:800;
    letter-spacing:1.5px;
    text-transform:uppercase;
    color:var(--muted);
    background:#ece8e1;
    border-radius:999px;
    pointer-events:none;
  }
  .fld.locked input{ background:#f1eee8; color:#6b665e; cursor:not-allowed; border-style:dashed; }
  .fld.locked input:focus{ box-shadow:none; border-color:var(--line); }

  /* gender cards */
  .gtitle{
    margin-bottom:8px;
    font-size:11px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:var(--muted);
  }
  .gender{ display:grid; grid-template-columns:1fr 1fr; gap:12px; margin-bottom:26px; }
  .gender input{ position:absolute; opacity:0; pointer-events:none; }
  .gender label{
    display:flex;
    align-items:center;
    gap:12px;
    padding:14px 16px;
    font-size:14px;
    font-weight:800;
    border:1.5px solid var(--line);
    border-radius:16px;
    background:#faf8f4;
    cursor:pointer;
    transition:all .3s ease;
  }
  .gender label:hover{ transform:translateY(-2px); background:#fff; }
  .gender .gi{
    width:36px; height:36px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    background:#fff1ea;
    transition:all .3s ease;
  }
  .gender .gi svg{ width:18px; height:18px; fill:none; stroke:var(--accent); stroke-width:1.9; stroke-linecap:round; stroke-linejoin:round; }
  .gender input:checked + label{
    border-color:var(--accent);
    background:#fff6f1;
    box-shadow:0 0 0 4px rgba(255,77,28,.12);
  }
  .gender input:checked + label .gi{ background:var(--accent); transform:rotate(360deg) scale(1.08); }
  .gender input:checked + label .gi svg{ stroke:#fff; }
  .gender input:focus-visible + label{ outline:2px solid var(--accent); outline-offset:2px; }

  /* buttons */
  .btns{ display:grid; grid-template-columns:1fr auto; gap:12px; }

  .save{
    position:relative;
    overflow:hidden;
    padding:17px 20px;
    font-family:inherit;
    font-size:13px;
    font-weight:900;
    letter-spacing:3px;
    text-transform:uppercase;
    color:#fff;
    background:linear-gradient(135deg,var(--accent),var(--pink));
    border:none;
    border-radius:16px;
    cursor:pointer;
    box-shadow:0 12px 30px rgba(255,61,127,.35);
    transition:transform .25s ease, box-shadow .25s ease;
  }
  .save:hover{ transform:translateY(-3px); box-shadow:0 18px 40px rgba(255,61,127,.5); }
  .save:active{ transform:translateY(0); }
  .save::after{
    content:"";
    position:absolute;
    top:0; left:-80%;
    width:50%; height:100%;
    background:linear-gradient(100deg,transparent,rgba(255,255,255,.6),transparent);
    transform:skewX(-20deg);
  }
  .save:hover::after{ left:130%; transition:left .7s ease; }

  .back{
    display:flex;
    align-items:center;
    justify-content:center;
    padding:17px 26px;
    text-decoration:none;
    font-size:12px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:var(--ink);
    background:#f1eee8;
    border-radius:16px;
    transition:all .25s ease;
  }
  .back:hover{ background:var(--ink); color:#fff; transform:translateY(-3px); }

  /* messages */
  .form-error{
    margin-bottom:18px;
    padding:13px 16px;
    font-size:13px;
    font-weight:700;
    color:#8a1538;
    background:#ffe8ef;
    border:1px solid #ffb3c8;
    border-radius:14px;
    animation:shake .5s ease both;
  }
  @keyframes shake{
    0%,100%{ transform:translateX(0); }
    20%{ transform:translateX(-8px); }
    40%{ transform:translateX(8px); }
    60%{ transform:translateX(-5px); }
    80%{ transform:translateX(5px); }
  }

  .msg-wrap{ max-width:480px; margin:-70px auto 80px auto; padding:0 22px; position:relative; z-index:6; }
  .msg{ padding:50px 28px; text-align:center; font-size:18px; font-weight:800; }
  .msg a{
    display:inline-block;
    margin-top:22px;
    text-decoration:none;
    font-weight:800;
    font-size:12px;
    letter-spacing:2px;
    text-transform:uppercase;
    padding:14px 30px;
    border-radius:999px;
    color:#fff;
    background:linear-gradient(135deg,var(--accent),var(--pink));
    box-shadow:0 12px 30px rgba(255,61,127,.35);
  }

  /* toast */
  .toast{
    position:fixed;
    left:50%; bottom:30px;
    z-index:99;
    padding:13px 24px;
    font-size:13px;
    font-weight:800;
    letter-spacing:1px;
    color:#fff;
    background:var(--ink);
    border-radius:999px;
    box-shadow:0 14px 40px rgba(0,0,0,.3);
    transform:translate(-50%,90px);
    opacity:0;
    transition:all .4s cubic-bezier(.2,1.2,.4,1);
  }
  .toast.show{ transform:translate(-50%,0); opacity:1; }

  @media (max-width:900px){
    .wrap{ grid-template-columns:1fr; margin-top:-80px; }
    .cover-text h2{ font-size:30px; }
    .formpanel{ padding:28px 22px; }
  }
  @media (max-width:560px){
    .cover{ height:190px; }
    .gender{ grid-template-columns:1fr; }
    .btns{ grid-template-columns:1fr; }
  }
  @media (prefers-reduced-motion: reduce){
    *, *::before, *::after{ animation:none !important; transition:none !important; }
  }

</style>
</head>

<body>

<%@ include file="db.jsp" %>

<%
  String un = (String) session.getAttribute("uname");
  String pw = (String) session.getAttribute("upass");

  boolean loaded = false;
  boolean saved  = false;
  String  err    = null;
  String eName = "", eGender = "", eEmail = "", eContact = "";

  // ---------- SAVE (runs when the form is submitted) ----------
  if (un != null && pw != null && request.getParameter("Update") != null) {
    String newname   = request.getParameter("e1");
    String newgender = request.getParameter("gender");
    String newemail  = request.getParameter("e2");

    try {
      PreparedStatement ups = con.prepareStatement(
        "update signin set name=?, gender=?, email=? where name=? and password=?");
      ups.setString(1, newname);
      ups.setString(2, newgender);
      ups.setString(3, newemail);
      ups.setString(4, un);
      ups.setString(5, pw);
      int x = ups.executeUpdate();

      if (x != 0) {
        session.setAttribute("uname", newname);
        un = newname;
        saved = true;
      } else {
        err = "Profile update failed. Please try again.";
      }
    } catch (Exception ex) {
      err = "Something went wrong: " + ex.toString();
    }
  }

  // ---------- LOAD current details ----------
  if (un != null && pw != null) {
    try {
      PreparedStatement lps = con.prepareStatement(
        "select * from signin where name=? and password=?");
      lps.setString(1, un);
      lps.setString(2, pw);
      rst = lps.executeQuery();

      if (rst.next()) {
        loaded   = true;
        eName    = rst.getString(1);
        eGender  = rst.getString(2);
        eEmail   = rst.getString(4);
        eContact = rst.getString(5);
      }
    } catch (Exception ex) {
      err = "Something went wrong: " + ex.toString();
    }
  }
%>

<nav class="navbar">
  <div class="logo"><span>Store</span></div>

  <div class="nav-center">
    <a href="loginhome.html">Home</a>
    <a href="men.html">Men</a>
    <a href="women.html">Women</a>
  </div>

  <div class="nav-right">
    <a href="mycart.jsp" class="btn btn-cart">Cart</a>
    <a href="profile.jsp" class="btn on">Profile</a>
  </div>
</nav>

<div class="cover">
  <div class="c c1"></div><div class="c c2"></div><div class="c c3"></div><div class="c c4"></div>

  <div class="cover-text">
    <small>Your account</small>
    <h2><%= loaded ? "Edit Profile" : "Please login" %></h2>
  </div>

  <div class="waves w1">
    <svg viewBox="0 0 2400 80" preserveAspectRatio="none"><path d="M0 40 Q150 0 300 40 T600 40 T900 40 T1200 40 T1500 40 T1800 40 T2100 40 T2400 40 V80 H0z" fill="#f5f4f0"/></svg>
  </div>
  <div class="waves w2">
    <svg viewBox="0 0 2400 80" preserveAspectRatio="none"><path d="M0 52 Q150 14 300 52 T600 52 T900 52 T1200 52 T1500 52 T1800 52 T2100 52 T2400 52 V80 H0z" fill="#f5f4f0"/></svg>
  </div>
</div>

<% if (loaded) { %>

<div class="wrap">

  <!-- LEFT: live preview -->
  <div class="panel me">
    <div class="avatar-wrap">
      <div class="avatar" id="pvAvatar"><%= esc(eName.length() > 0 ? eName.substring(0,1) : "?") %></div>
    </div>

    <h1 id="pvName"><%= esc(eName) %></h1>
    <div class="mail" id="pvMail"><%= esc(eEmail) %></div>

    <div class="chip" id="chip"><i></i><span id="chipText">All saved</span></div>

    <div class="tip">
      <b>Live preview.</b> This card updates as you type, so you can see your changes before you save them.
    </div>
  </div>

  <!-- RIGHT: form -->
  <div class="panel formpanel">
    <h3>Account</h3>
    <h2>Update your details</h2>
    <p class="sub">Change what you like, then press save.</p>

    <form id="form1" name="form1" method="post" action="">

<% if (err != null) { %>
      <div class="form-error"><%= esc(err) %></div>
<% } %>

      <div class="fld">
        <input type="text" id="e1" name="e1" placeholder=" " required value="<%= esc(eName) %>" autocomplete="username" />
        <label for="e1">Name</label>
        <svg class="lead" viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/></svg>
      </div>

      <div class="fld">
        <input type="email" id="e2" name="e2" placeholder=" " required value="<%= esc(eEmail) %>" autocomplete="email" />
        <label for="e2">E-mail</label>
        <svg class="lead" viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></svg>
      </div>

      <div class="fld locked">
        <input type="text" id="e3" name="e3" placeholder=" " value="<%= esc(eContact) %>" readonly="readonly" />
        <label for="e3">Contact</label>
        <svg class="lead" viewBox="0 0 24 24"><path d="M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z"/></svg>
        <span class="tag">Locked</span>
      </div>

      <div class="gtitle">Gender</div>
      <div class="gender">
        <div>
          <input type="radio" id="gm" name="gender" value="Male" <%= "Male".equals(eGender) ? "checked=\"checked\"" : "" %> />
          <label for="gm">
            <span class="gi"><svg viewBox="0 0 24 24"><circle cx="10" cy="14" r="5"/><path d="M14 10l6-6M15 4h5v5"/></svg></span>
            Male
          </label>
        </div>
        <div>
          <input type="radio" id="gf" name="gender" value="Female" <%= "Female".equals(eGender) ? "checked=\"checked\"" : "" %> />
          <label for="gf">
            <span class="gi"><svg viewBox="0 0 24 24"><circle cx="12" cy="9" r="5"/><path d="M12 14v8M9 19h6"/></svg></span>
            Female
          </label>
        </div>
      </div>

      <div class="btns">
        <button type="submit" name="Update" value="Update" class="save">Save Changes</button>
        <a href="profile.jsp" class="back">Back</a>
      </div>

    </form>
  </div>

</div>

<div class="toast" id="toast">Profile updated!</div>

<script>
  var el = function (id) { return document.getElementById(id); };

  function bump(node) {
    node.classList.remove('bump');
    void node.offsetWidth;
    node.classList.add('bump');
  }

  // same avatar drawings as the profile page
  var MALE_SVG =
    '<svg viewBox="0 0 100 100"><defs><linearGradient id="bgM" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffb347"/><stop offset="1" stop-color="#ff4d1c"/></linearGradient></defs>' +
    '<rect width="100" height="100" fill="url(#bgM)"/>' +
    '<path d="M16 100c0-21 15-31 34-31s34 10 34 31z" fill="#2b2f4a"/>' +
    '<path d="M42 70l8 9 8-9z" fill="#f5f1ea"/>' +
    '<rect x="43" y="55" width="14" height="17" rx="6" fill="#e0b08a"/>' +
    '<circle cx="50" cy="42" r="19" fill="#f2c9a5"/>' +
    '<path d="M30 41c-3-17 9-25 21-24 13 1 21 9 19 25-3-9-8-13-20-13-9 0-15 4-20 12z" fill="#2a1d18"/>' +
    '<circle cx="43" cy="45" r="1.9" fill="#2a1d18"/><circle cx="57" cy="45" r="1.9" fill="#2a1d18"/>' +
    '<path d="M44 52q6 5 12 0" stroke="#a5614a" stroke-width="2" fill="none" stroke-linecap="round"/></svg>';

  var FEMALE_SVG =
    '<svg viewBox="0 0 100 100"><defs><linearGradient id="bgF" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ff7eb3"/><stop offset="1" stop-color="#7b3fe4"/></linearGradient></defs>' +
    '<rect width="100" height="100" fill="url(#bgF)"/>' +
    '<path d="M26 50c-5-26 8-37 24-37s29 11 24 37c-1 14 4 22 7 30H19c3-8 8-16 7-30z" fill="#3a2118"/>' +
    '<path d="M18 100c0-21 15-31 32-31s32 10 32 31z" fill="#ff4d1c"/>' +
    '<rect x="43" y="55" width="14" height="17" rx="6" fill="#e0b08a"/>' +
    '<circle cx="50" cy="43" r="18" fill="#f2c9a5"/>' +
    '<path d="M31 41c3-11 11-16 20-16 11 0 18 7 19 17-6-6-12-8-20-8-8 0-14 3-19 7z" fill="#3a2118"/>' +
    '<circle cx="43" cy="46" r="1.9" fill="#2a1d18"/><circle cx="57" cy="46" r="1.9" fill="#2a1d18"/>' +
    '<path d="M44 53q6 5 12 0" stroke="#c0505f" stroke-width="2" fill="none" stroke-linecap="round"/>' +
    '<circle cx="38" cy="51" r="3" fill="#ff9aa2" opacity=".45"/><circle cx="62" cy="51" r="3" fill="#ff9aa2" opacity=".45"/></svg>';

  // values as loaded, to know if anything changed
  var original = {
    name:   el('e1').value,
    email:  el('e2').value,
    gender: '<%= esc(eGender) %>'
  };
  var gender = original.gender;

  function currentGender() {
    var r = document.getElementsByName('gender');
    for (var i = 0; i < r.length; i++) { if (r[i].checked) return r[i].value; }
    return '';
  }

  function paintAvatar() {
    var av = el('pvAvatar');
    var n  = el('e1').value.trim();
    if (gender === 'Male')        av.innerHTML = MALE_SVG;
    else if (gender === 'Female') av.innerHTML = FEMALE_SVG;
    else                          av.textContent = n ? n.charAt(0) : '?';
  }

  function refresh(bumpId) {
    var name  = el('e1').value.trim();
    var email = el('e2').value.trim();
    gender = currentGender();

    el('pvName').textContent = name || 'Your Name';
    el('pvMail').textContent = email;
    paintAvatar();
    if (bumpId) bump(el(bumpId));

    var dirty = (el('e1').value !== original.name) ||
                (el('e2').value !== original.email) ||
                (gender !== original.gender);
    el('chip').className = dirty ? 'chip dirty' : 'chip';
    el('chipText').textContent = dirty ? 'Unsaved changes' : 'All saved';
  }

  el('e1').addEventListener('input', function () { refresh('pvName'); });
  el('e2').addEventListener('input', function () { refresh('pvMail'); });

  var radios = document.getElementsByName('gender');
  for (var i = 0; i < radios.length; i++) {
    radios[i].addEventListener('change', function () { refresh('pvAvatar'); });
  }

  refresh();

  // ----- toast + redirect after a successful save -----
  var toast = el('toast');
  function showToast(text) {
    toast.textContent = text;
    toast.classList.add('show');
  }
<% if (saved) { %>
  showToast('Profile updated!');
  setTimeout(function () { window.location.href = 'profile.jsp'; }, 1300);
<% } %>
</script>

<% } else { %>

<div class="msg-wrap">
  <div class="panel msg">
    <%= (un != null && pw != null) ? "User details not found." : "Please login first." %>
    <br /><a href="login.jsp">Login</a>
  </div>
</div>

<% } %>

</body>
</html>
