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
<title>Sign In</title>

<style>

  /* ============================================================
     SIGN-IN PAGE  -  dark aurora + live profile preview
     ============================================================ */

  :root{
    --bg:#070b1a;
    --ink:#eef2ff;
    --muted:rgba(238,242,255,.58);
    --teal:#19d3c5;
    --violet:#7b5cff;
    --pink:#ff5fa2;
    --line:rgba(255,255,255,.14);
    --glass:rgba(255,255,255,.06);
  }

  *{ box-sizing:border-box; margin:0; padding:0; }

  html, body{ min-height:100%; }

  body{
    font-family:'Helvetica Neue', Arial, sans-serif;
    background:var(--bg);
    color:var(--ink);
    overflow-x:hidden;
    position:relative;
  }

  /* ---------- aurora background ---------- */
  .aurora{ position:fixed; inset:0; z-index:0; overflow:hidden; pointer-events:none; }

  .wave{
    position:absolute;
    width:70vw; height:70vw;
    max-width:900px; max-height:900px;
    border-radius:42% 58% 63% 37% / 41% 44% 56% 59%;
    filter:blur(80px);
    opacity:.5;
  }
  .w1{ background:var(--violet); top:-30%; left:-15%; animation:wave1 20s ease-in-out infinite alternate; }
  .w2{ background:var(--teal);   bottom:-35%; right:-15%; animation:wave2 24s ease-in-out infinite alternate; opacity:.38; }
  .w3{ background:var(--pink);   top:30%; left:40%; width:40vw; height:40vw; animation:wave3 28s ease-in-out infinite alternate; opacity:.22; }

  @keyframes wave1{
    0%  { transform:translate(0,0) rotate(0deg); border-radius:42% 58% 63% 37% / 41% 44% 56% 59%; }
    100%{ transform:translate(18vw,14vh) rotate(60deg); border-radius:58% 42% 38% 62% / 55% 60% 40% 45%; }
  }
  @keyframes wave2{
    0%  { transform:translate(0,0) rotate(0deg); }
    100%{ transform:translate(-18vw,-12vh) rotate(-70deg); border-radius:60% 40% 55% 45% / 45% 55% 45% 55%; }
  }
  @keyframes wave3{
    0%  { transform:translate(0,0) scale(1); }
    100%{ transform:translate(-25vw,10vh) scale(1.3); }
  }

  /* twinkling stars */
  .stars{
    position:absolute;
    inset:0;
    background-image:
      radial-gradient(1.5px 1.5px at 12% 22%, #fff, transparent),
      radial-gradient(1.5px 1.5px at 74% 12%, #fff, transparent),
      radial-gradient(1px 1px at 38% 70%, #fff, transparent),
      radial-gradient(1.5px 1.5px at 88% 64%, #fff, transparent),
      radial-gradient(1px 1px at 22% 88%, #fff, transparent),
      radial-gradient(1px 1px at 58% 34%, #fff, transparent),
      radial-gradient(1.5px 1.5px at 92% 90%, #fff, transparent),
      radial-gradient(1px 1px at 6% 56%, #fff, transparent);
    animation:twinkle 4s ease-in-out infinite alternate;
  }
  @keyframes twinkle{ from{ opacity:.25; } to{ opacity:.9; } }

  /* ---------- navbar ---------- */
  .navbar{
    position:relative;
    z-index:5;
    display:grid;
    grid-template-columns:1fr auto 1fr;
    align-items:center;
    padding:18px 40px;
    background:rgba(7,11,26,.5);
    backdrop-filter:blur(14px);
    -webkit-backdrop-filter:blur(14px);
    border-bottom:1px solid var(--line);
    animation:fadeDown .8s ease both;
  }
  @keyframes fadeDown{ from{ opacity:0; transform:translateY(-14px);} to{ opacity:1; transform:none;} }

  .logo{
    font-size:22px;
    font-weight:800;
    letter-spacing:3px;
    text-transform:uppercase;
    justify-self:start;
  }
  .logo span{
    background:linear-gradient(90deg,var(--teal),var(--violet));
    -webkit-background-clip:text;
    background-clip:text;
    color:transparent;
  }

  .nav-center{ display:flex; gap:48px; justify-self:center; }
  .nav-center a{
    position:relative;
    text-decoration:none;
    color:var(--ink);
    font-weight:700;
    font-size:14px;
    letter-spacing:1.5px;
    text-transform:uppercase;
    padding:6px 2px;
    opacity:.8;
    transition:opacity .2s ease;
  }
  .nav-center a:hover{ opacity:1; }
  .nav-center a::after{
    content:"";
    position:absolute;
    left:0; bottom:-3px;
    width:0; height:2px;
    background:linear-gradient(90deg,var(--teal),var(--violet));
    transition:width .3s ease;
  }
  .nav-center a:hover::after{ width:100%; }

  .nav-right{ display:flex; gap:12px; justify-self:end; }

  .btn{
    text-decoration:none;
    font-weight:700;
    font-size:12px;
    letter-spacing:1.5px;
    text-transform:uppercase;
    padding:10px 20px;
    border-radius:999px;
    border:1px solid var(--line);
    color:var(--ink);
    background:var(--glass);
    transition:all .25s ease;
  }
  .btn:hover{ background:var(--ink); color:#0b1020; transform:translateY(-2px); }
  .btn-hot{
    background:linear-gradient(135deg,var(--teal),var(--violet));
    border-color:transparent;
    color:#04101a;
  }
  .btn-hot:hover{ background:var(--ink); color:#0b1020; }

  @media (max-width:700px){
    .navbar{ grid-template-columns:1fr; row-gap:14px; padding:16px 20px; }
    .logo, .nav-center, .nav-right{ justify-self:center; }
    .nav-center{ gap:26px; }
  }

  /* ---------- page + big card ---------- */
  .page{
    position:relative;
    z-index:2;
    min-height:calc(100vh - 80px);
    display:flex;
    align-items:center;
    justify-content:center;
    padding:46px 20px;
  }

  .shell{
    width:100%;
    max-width:1020px;
    display:grid;
    grid-template-columns:1.15fr 1fr;
    border-radius:30px;
    overflow:hidden;
    background:var(--glass);
    border:1px solid var(--line);
    backdrop-filter:blur(22px);
    -webkit-backdrop-filter:blur(22px);
    box-shadow:0 36px 90px rgba(0,0,0,.55), inset 0 1px 0 rgba(255,255,255,.18);
    animation:shellIn 1s cubic-bezier(.2,.8,.2,1) both;
  }
  @keyframes shellIn{ from{ opacity:0; transform:translateY(60px) scale(.95);} to{ opacity:1; transform:none;} }

  /* ---------- LEFT: form ---------- */
  .formcol{ padding:44px 44px 40px 44px; }

  .formcol h1{
    font-size:34px;
    font-weight:900;
    letter-spacing:-.5px;
    background:linear-gradient(90deg,#fff,#b9f6f0 55%,var(--teal));
    -webkit-background-clip:text;
    background-clip:text;
    color:transparent;
    animation:up .8s .3s ease both;
  }

  .sub{
    margin-top:6px;
    font-size:14px;
    color:var(--muted);
    animation:up .8s .4s ease both;
  }

  @keyframes up{ from{ opacity:0; transform:translateY(20px);} to{ opacity:1; transform:none;} }

  /* progress bar */
  .progress{
    margin-top:22px;
    animation:up .8s .5s ease both;
  }
  .progress-top{
    display:flex;
    justify-content:space-between;
    font-size:11px;
    font-weight:700;
    letter-spacing:2px;
    text-transform:uppercase;
    color:var(--muted);
    margin-bottom:8px;
  }
  .progress-track{
    height:6px;
    border-radius:999px;
    background:rgba(255,255,255,.1);
    overflow:hidden;
  }
  .progress-fill{
    height:100%;
    width:0%;
    border-radius:999px;
    background:linear-gradient(90deg,var(--teal),var(--violet),var(--pink));
    transition:width .5s cubic-bezier(.2,.8,.2,1);
  }

  form{ margin-top:24px; }

  .grid2{ display:grid; grid-template-columns:1fr 1fr; gap:0 16px; }

  /* boxed fields with floating labels */
  .fld{
    position:relative;
    margin-bottom:18px;
    animation:up .7s ease both;
  }
  .fld:nth-child(1){ animation-delay:.55s; }
  .fld:nth-child(2){ animation-delay:.65s; }
  .fld:nth-child(3){ animation-delay:.75s; }
  .fld:nth-child(4){ animation-delay:.85s; }

  .fld input{
    width:100%;
    padding:22px 44px 9px 16px;
    font-family:inherit;
    font-size:15px;
    font-weight:600;
    color:var(--ink);
    background:rgba(255,255,255,.06);
    border:1px solid var(--line);
    border-radius:14px;
    outline:none;
    transition:all .25s ease;
  }

  .fld label{
    position:absolute;
    left:16px; top:17px;
    font-size:14px;
    font-weight:600;
    color:var(--muted);
    pointer-events:none;
    transition:all .22s ease;
  }

  .fld input:focus + label,
  .fld input:not(:placeholder-shown) + label{
    top:7px;
    font-size:10px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:var(--teal);
  }

  .fld input:focus{
    background:rgba(255,255,255,.1);
    border-color:var(--teal);
    box-shadow:0 0 0 4px rgba(25,211,197,.16);
  }

  /* green tick appears once a field is filled */
  .fld .tick{
    position:absolute;
    right:14px; top:50%;
    width:20px; height:20px;
    margin-top:-10px;
    border-radius:50%;
    background:var(--teal);
    display:flex;
    align-items:center;
    justify-content:center;
    transform:scale(0);
    transition:transform .35s cubic-bezier(.2,1.6,.4,1);
  }
  .fld input:not(:placeholder-shown) ~ .tick{ transform:scale(1); }
  .fld .tick svg{
    width:12px; height:12px;
    fill:none; stroke:#04101a; stroke-width:3;
    stroke-linecap:round; stroke-linejoin:round;
  }

  /* password: eye button sits left of the tick */
  .eye{
    position:absolute;
    right:40px; top:50%;
    margin-top:-16px;
    width:32px; height:32px;
    display:flex;
    align-items:center;
    justify-content:center;
    background:transparent;
    border:none;
    border-radius:50%;
    cursor:pointer;
    transition:background .2s ease;
  }
  .eye:hover{ background:rgba(255,255,255,.12); }
  .eye svg{
    width:18px; height:18px;
    fill:none; stroke:var(--muted); stroke-width:1.8;
    stroke-linecap:round; stroke-linejoin:round;
  }
  #s4{ padding-right:76px; }

  /* password strength meter */
  .meter{
    display:flex;
    gap:6px;
    margin:-6px 0 6px 0;
    animation:up .7s .9s ease both;
  }
  .meter i{
    flex:1;
    height:4px;
    border-radius:999px;
    background:rgba(255,255,255,.1);
    transition:background .3s ease;
  }
  .meter-text{
    font-size:11px;
    font-weight:700;
    letter-spacing:1.5px;
    text-transform:uppercase;
    color:var(--muted);
    margin-bottom:18px;
    min-height:14px;
  }

  /* gender choice cards */
  .gender-title{
    font-size:11px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:var(--muted);
    margin-bottom:8px;
    animation:up .7s 1s ease both;
  }
  .gender{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:12px;
    margin-bottom:24px;
    animation:up .7s 1.05s ease both;
  }
  .gender input{ position:absolute; opacity:0; pointer-events:none; }

  .gender label{
    display:flex;
    align-items:center;
    gap:12px;
    padding:14px 16px;
    font-size:14px;
    font-weight:700;
    border:1px solid var(--line);
    border-radius:14px;
    background:rgba(255,255,255,.05);
    cursor:pointer;
    transition:all .3s ease;
  }
  .gender label:hover{ background:rgba(255,255,255,.11); transform:translateY(-2px); }

  .gender .gi{
    width:34px; height:34px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    background:rgba(255,255,255,.1);
    transition:all .3s ease;
  }
  .gender .gi svg{
    width:18px; height:18px;
    fill:none; stroke:var(--ink); stroke-width:1.9;
    stroke-linecap:round; stroke-linejoin:round;
  }

  .gender input:checked + label{
    border-color:var(--teal);
    background:rgba(25,211,197,.16);
    box-shadow:0 0 0 3px rgba(25,211,197,.18), 0 10px 26px rgba(25,211,197,.18);
  }
  .gender input:checked + label .gi{ background:var(--teal); transform:rotate(360deg) scale(1.08); }
  .gender input:checked + label .gi svg{ stroke:#04101a; }
  .gender input:focus-visible + label{ outline:2px solid var(--teal); outline-offset:2px; }

  /* error */
  .form-error{
    margin-bottom:18px;
    padding:12px 16px;
    font-size:13px;
    font-weight:700;
    color:#ffc2d9;
    background:rgba(255,95,162,.15);
    border:1px solid rgba(255,95,162,.5);
    border-radius:12px;
    animation:shake .5s ease both;
  }
  @keyframes shake{
    0%,100%{ transform:translateX(0); }
    20%{ transform:translateX(-8px); }
    40%{ transform:translateX(8px); }
    60%{ transform:translateX(-5px); }
    80%{ transform:translateX(5px); }
  }

  /* submit */
  .submit{
    position:relative;
    width:100%;
    overflow:hidden;
    padding:17px 20px;
    font-family:inherit;
    font-size:13px;
    font-weight:800;
    letter-spacing:3px;
    text-transform:uppercase;
    color:#04101a;
    background:linear-gradient(135deg,var(--teal),var(--violet));
    border:none;
    border-radius:14px;
    cursor:pointer;
    box-shadow:0 12px 34px rgba(123,92,255,.4);
    transition:transform .25s ease, box-shadow .25s ease;
    animation:up .7s 1.15s ease both;
  }
  .submit:hover{ transform:translateY(-3px); box-shadow:0 18px 44px rgba(123,92,255,.6); }
  .submit:active{ transform:translateY(0); }
  .submit::after{
    content:"";
    position:absolute;
    top:0; left:-80%;
    width:50%; height:100%;
    background:linear-gradient(100deg,transparent,rgba(255,255,255,.6),transparent);
    transform:skewX(-20deg);
  }
  .submit:hover::after{ left:130%; transition:left .7s ease; }

  .already{
    margin-top:18px;
    text-align:center;
    font-size:13px;
    color:var(--muted);
    animation:up .7s 1.25s ease both;
  }
  .already a{ color:var(--teal); font-weight:800; text-decoration:none; }
  .already a:hover{ text-decoration:underline; }

  /* ---------- RIGHT: live preview ---------- */
  .previewcol{
    position:relative;
    overflow:hidden;
    padding:44px 36px;
    display:flex;
    flex-direction:column;
    align-items:center;
    justify-content:center;
    background:linear-gradient(160deg, rgba(123,92,255,.55), rgba(25,211,197,.35) 70%, rgba(255,95,162,.3));
    border-left:1px solid var(--line);
  }

  /* rotating light behind the preview card */
  .previewcol::before{
    content:"";
    position:absolute;
    width:520px; height:520px;
    background:conic-gradient(from 0deg, transparent, rgba(255,255,255,.22), transparent 40%);
    animation:spin 9s linear infinite;
  }
  @keyframes spin{ to{ transform:rotate(360deg); } }

  .pv-label{
    position:relative;
    font-size:11px;
    font-weight:800;
    letter-spacing:3px;
    text-transform:uppercase;
    opacity:.85;
    margin-bottom:18px;
  }

  .pv-card{
    position:relative;
    width:100%;
    max-width:290px;
    padding:28px 22px 24px 22px;
    text-align:center;
    border-radius:24px;
    background:rgba(8,12,30,.55);
    border:1px solid rgba(255,255,255,.22);
    backdrop-filter:blur(14px);
    -webkit-backdrop-filter:blur(14px);
    box-shadow:0 24px 60px rgba(0,0,0,.45);
    animation:hover 5s ease-in-out infinite;
  }
  @keyframes hover{ 0%,100%{ transform:translateY(0);} 50%{ transform:translateY(-12px);} }

  .pv-avatar{
    width:96px; height:96px;
    margin:0 auto 14px auto;
    border-radius:50%;
    overflow:hidden;
    border:3px solid rgba(255,255,255,.85);
    background:linear-gradient(135deg,var(--violet),var(--teal));
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:40px;
    font-weight:900;
    text-transform:uppercase;
    box-shadow:0 0 0 6px rgba(255,255,255,.1);
  }
  .pv-avatar svg{ width:100%; height:100%; display:block; }

  .pv-name{
    font-size:21px;
    font-weight:800;
    word-break:break-word;
  }
  .pv-chip{
    display:inline-flex;
    align-items:center;
    gap:7px;
    margin-top:8px;
    padding:5px 12px;
    font-size:10px;
    font-weight:800;

    letter-spacing:2px;
    text-transform:uppercase;
    border-radius:999px;
    background:rgba(255,255,255,.12);
  }
  .pv-chip i{
    width:7px; height:7px;
    border-radius:50%;
    background:#3ddc84;
    animation:ping 2s ease-out infinite;
  }
  @keyframes ping{
    0%{ box-shadow:0 0 0 0 rgba(61,220,132,.7); }
    80%,100%{ box-shadow:0 0 0 9px rgba(61,220,132,0); }
  }

  .pv-rows{ margin-top:18px; text-align:left; }
  .pv-row{
    padding:10px 12px;
    margin-top:8px;
    border-radius:12px;
    background:rgba(255,255,255,.07);
  }
  .pv-row small{
    display:block;
    font-size:9px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    opacity:.6;
  }
  .pv-row span{
    display:block;
    margin-top:2px;
    font-size:13px;
    font-weight:700;
    word-break:break-all;
  }

  /* little pop whenever a preview value changes */
  .bump{ animation:bump .35s ease; }
  @keyframes bump{ 0%{ transform:scale(1);} 40%{ transform:scale(1.07);} 100%{ transform:scale(1);} }

  /* ---------- phones / tablets ---------- */
  @media (max-width:900px){
    .shell{ grid-template-columns:1fr; max-width:520px; }
    .previewcol{ display:none; }
    .formcol{ padding:34px 24px 30px 24px; }
    .grid2{ grid-template-columns:1fr; }
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
  // ---------- CREATE ACCOUNT (runs when the form is submitted) ----------
  String s1 = request.getParameter("s1");   // name
  String s2 = request.getParameter("s2");   // gender
  String s3 = request.getParameter("s3");   // e-mail
  String s4 = request.getParameter("s4");   // password
  String s5 = request.getParameter("s5");   // contact

  boolean tried = request.getParameter("Submit") != null;
  boolean ok    = false;
  String  err   = null;

  if (tried) {
    try {
      PreparedStatement ips = con.prepareStatement(
        "insert into signin(name,gender,password,email,contact) values(?,?,?,?,?)");
      ips.setString(1, s1);
      ips.setString(2, s2);
      ips.setString(3, s4);
      ips.setString(4, s3);
      ips.setString(5, s5);
      int x = ips.executeUpdate();

      if (x != 0) {
        ok = true;
        session.setAttribute("uname", s1);
        session.setAttribute("upass", s4);
      }
    } catch (Exception ex) {
      err = ex.toString();
    }
  }
%>

<!-- animated background -->
<div class="aurora">
  <div class="wave w1"></div>
  <div class="wave w2"></div>
  <div class="wave w3"></div>
  <div class="stars"></div>
</div>

<nav class="navbar">
  <div class="logo"><span>Store</span></div>

  <div class="nav-center">
    <a href="home.html">Home</a>
    <a href="login.jsp">Men</a>
    <a href="login.jsp">Women</a>
  </div>

  <div class="nav-right">
    <a href="login.jsp" class="btn">Login</a>
    <a href="signin.jsp" class="btn btn-hot">Sign In</a>
  </div>
</nav>

<div class="page">
<div class="shell">

  <!-- LEFT: form -->
  <div class="formcol">

    <h1>Create your account</h1>
    <p class="sub">It takes less than a minute. Watch your profile card come alive &rarr;</p>

    <div class="progress">
      <div class="progress-top"><span>Profile complete</span><span id="pct">0%</span></div>
      <div class="progress-track"><div class="progress-fill" id="fill"></div></div>
    </div>

    <form id="form1" name="form1" method="post" action="">

<% if (err != null) { %>
      <div class="form-error">Could not create the account: <%= esc(err) %></div>
<% } %>

      <div class="grid2">
        <div class="fld">
          <input type="text" id="s1" name="s1" placeholder=" " required autocomplete="username" value="<%= (err != null) ? esc(s1) : "" %>" />
          <label for="s1">Name</label>
          <span class="tick"><svg viewBox="0 0 24 24"><path d="M5 12l5 5 9-10"/></svg></span>
        </div>

        <div class="fld">
          <input type="text" id="s5" name="s5" placeholder=" " required inputmode="tel" autocomplete="tel" value="<%= (err != null) ? esc(s5) : "" %>" />
          <label for="s5">Contact</label>
          <span class="tick"><svg viewBox="0 0 24 24"><path d="M5 12l5 5 9-10"/></svg></span>
        </div>
      </div>

      <div class="fld">
        <input type="email" id="s3" name="s3" placeholder=" " required autocomplete="email" value="<%= (err != null) ? esc(s3) : "" %>" />
        <label for="s3">E-mail</label>
        <span class="tick"><svg viewBox="0 0 24 24"><path d="M5 12l5 5 9-10"/></svg></span>
      </div>

      <div class="fld">
        <input type="password" id="s4" name="s4" placeholder=" " required autocomplete="new-password" />
        <label for="s4">Password</label>
        <button type="button" class="eye" id="eye" aria-label="Show or hide password">
          <svg viewBox="0 0 24 24"><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></svg>
        </button>
        <span class="tick"><svg viewBox="0 0 24 24"><path d="M5 12l5 5 9-10"/></svg></span>
      </div>

      <div class="meter" id="meter"><i></i><i></i><i></i><i></i></div>
      <div class="meter-text" id="meterText"></div>

      <div class="gender-title">Gender</div>
      <div class="gender">
        <div>
          <input type="radio" id="gm" name="s2" value="Male" required />
          <label for="gm">
            <span class="gi"><svg viewBox="0 0 24 24"><circle cx="10" cy="14" r="5"/><path d="M14 10l6-6M15 4h5v5"/></svg></span>
            Male
          </label>
        </div>
        <div>
          <input type="radio" id="gf" name="s2" value="Female" />
          <label for="gf">
            <span class="gi"><svg viewBox="0 0 24 24"><circle cx="12" cy="9" r="5"/><path d="M12 14v8M9 19h6"/></svg></span>
            Female
          </label>
        </div>
      </div>

      <input type="hidden" name="Submit" value="Sign-In" />
      <button type="submit" class="submit">Create Account</button>

      <div class="already">Already a member? <a href="login.jsp">Login</a></div>

    </form>
  </div>

  <!-- RIGHT: live preview of the profile card -->
  <div class="previewcol">
    <div class="pv-label">Live preview</div>

    <div class="pv-card">
      <div class="pv-avatar" id="pvAvatar">?</div>
      <div class="pv-name" id="pvName">Your Name</div>
      <div class="pv-chip"><i></i>New Member</div>

      <div class="pv-rows">
        <div class="pv-row"><small>Gender</small><span id="pvGender">-</span></div>
        <div class="pv-row"><small>E-mail</small><span id="pvEmail">you@example.com</span></div>
        <div class="pv-row"><small>Contact</small><span id="pvContact">-</span></div>
      </div>
    </div>
  </div>

</div>
</div>

<script>
  var el = function (id) { return document.getElementById(id); };

  // small pop animation on the element that changed
  function bump(node) {
    node.classList.remove('bump');
    void node.offsetWidth;
    node.classList.add('bump');
  }

  // ----- avatars (same drawings as the profile page) -----
  var MALE_SVG =
    '<svg viewBox="0 0 100 100"><defs><linearGradient id="pbm" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#19d3c5"/><stop offset="1" stop-color="#7b5cff"/></linearGradient></defs>' +
    '<rect width="100" height="100" fill="url(#pbm)"/>' +
    '<path d="M16 100c0-21 15-31 34-31s34 10 34 31z" fill="#2b2f4a"/>' +
    '<path d="M42 70l8 9 8-9z" fill="#f5f1ea"/>' +
    '<rect x="43" y="55" width="14" height="17" rx="6" fill="#e0b08a"/>' +
    '<circle cx="50" cy="42" r="19" fill="#f2c9a5"/>' +
    '<path d="M30 41c-3-17 9-25 21-24 13 1 21 9 19 25-3-9-8-13-20-13-9 0-15 4-20 12z" fill="#2a1d18"/>' +
    '<circle cx="43" cy="45" r="1.9" fill="#2a1d18"/><circle cx="57" cy="45" r="1.9" fill="#2a1d18"/>' +
    '<path d="M44 52q6 5 12 0" stroke="#a5614a" stroke-width="2" fill="none" stroke-linecap="round"/></svg>';

  var FEMALE_SVG =
    '<svg viewBox="0 0 100 100"><defs><linearGradient id="pbf" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ff7eb3"/><stop offset="1" stop-color="#7b5cff"/></linearGradient></defs>' +
    '<rect width="100" height="100" fill="url(#pbf)"/>' +
    '<path d="M26 50c-5-26 8-37 24-37s29 11 24 37c-1 14 4 22 7 30H19c3-8 8-16 7-30z" fill="#3a2118"/>' +
    '<path d="M18 100c0-21 15-31 32-31s32 10 32 31z" fill="#19d3c5"/>' +
    '<rect x="43" y="55" width="14" height="17" rx="6" fill="#e0b08a"/>' +
    '<circle cx="50" cy="43" r="18" fill="#f2c9a5"/>' +
    '<path d="M31 41c3-11 11-16 20-16 11 0 18 7 19 17-6-6-12-8-20-8-8 0-14 3-19 7z" fill="#3a2118"/>' +
    '<circle cx="43" cy="46" r="1.9" fill="#2a1d18"/><circle cx="57" cy="46" r="1.9" fill="#2a1d18"/>' +
    '<path d="M44 53q6 5 12 0" stroke="#c0505f" stroke-width="2" fill="none" stroke-linecap="round"/>' +
    '<circle cx="38" cy="51" r="3" fill="#ff9aa2" opacity=".45"/><circle cx="62" cy="51" r="3" fill="#ff9aa2" opacity=".45"/></svg>';

  var gender = '';

  // ----- live preview + progress -----
  function update(changedId) {
    var name    = el('s1').value.trim();
    var email   = el('s3').value.trim();
    var contact = el('s5').value.trim();
    var pass    = el('s4').value;

    // preview text
    el('pvName').textContent    = name    || 'Your Name';
    el('pvEmail').textContent   = email   || 'you@example.com';
    el('pvContact').textContent = contact || '-';
    el('pvGender').textContent  = gender  || '-';

    // avatar: drawing by gender, otherwise the first letter of the name
    var av = el('pvAvatar');
    if (gender === 'Male')        av.innerHTML = MALE_SVG;
    else if (gender === 'Female') av.innerHTML = FEMALE_SVG;
    else                          av.textContent = name ? name.charAt(0) : '?';

    if (changedId) bump(el(changedId));

    // progress: 5 things to fill in
    var done = 0;
    if (name)    done++;
    if (contact) done++;
    if (email)   done++;
    if (pass)    done++;
    if (gender)  done++;
    var pct = done * 20;
    el('fill').style.width = pct + '%';
    el('pct').textContent  = pct + '%';
  }

  // ----- password strength -----
  function strength(p) {
    var s = 0;
    if (p.length >= 6)  s++;
    if (p.length >= 10) s++;
    if (/[A-Z]/.test(p) && /[a-z]/.test(p)) s++;
    if (/[0-9]/.test(p) && /[^A-Za-z0-9]/.test(p)) s++;
    return p ? Math.max(1, s) : 0;
  }

  var colors = ['', '#ff5fa2', '#ffb347', '#19d3c5', '#3ddc84'];
  var words  = ['', 'Weak', 'Okay', 'Good', 'Strong'];

  function showStrength() {
    var s = strength(el('s4').value);
    var bars = el('meter').getElementsByTagName('i');
    for (var i = 0; i < bars.length; i++) {
      bars[i].style.background = (i < s) ? colors[s] : '';
    }
    el('meterText').textContent = words[s];
    el('meterText').style.color = s ? colors[s] : '';
  }

  // wire everything up
  var ids = { s1:'pvName', s3:'pvEmail', s5:'pvContact' };
  for (var key in ids) {
    (function (k) {
      el(k).addEventListener('input', function () { update(ids[k]); });
    })(key);
  }

  el('s4').addEventListener('input', function () { showStrength(); update(); });

  var radios = document.getElementsByName('s2');
  for (var r = 0; r < radios.length; r++) {
    radios[r].addEventListener('change', function () {
      gender = this.value;
      update('pvAvatar');
    });
  }

  el('eye').addEventListener('click', function () {
    var p = el('s4');
    p.type = (p.type === 'password') ? 'text' : 'password';
  });

  update();
</script>

<%
  // ---------- ACCOUNT CREATED: create the cart, then go to the shop ----------
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
