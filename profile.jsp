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
<title>Profile</title>

<style>

  /* ============================================================
     PROFILE PAGE  -  bright dashboard with an animated cover
     ============================================================ */

  :root{
    --ink:#141414;
    --paper:#f5f4f0;
    --card:#ffffff;
    --accent:#ff4d1c;
    --gold:#ffb347;
    --pink:#ff3d7f;
    --muted:#7a766f;
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

  .logo{
    font-size:22px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    justify-self:start;
  }
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
    height:250px;
    overflow:hidden;
    background:linear-gradient(115deg,#ff4d1c,#ff3d7f,#ffb347,#ff4d1c);
    background-size:300% 300%;
    animation:coverFlow 12s ease-in-out infinite;
  }
  @keyframes coverFlow{
    0%  { background-position:0% 50%; }
    50% { background-position:100% 50%; }
    100%{ background-position:0% 50%; }
  }

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
    left:50%; top:46%;
    transform:translate(-50%,-50%);
    width:100%;
    text-align:center;
    color:#fff;
    z-index:3;
    animation:fadeUp .9s .2s ease both;
  }
  .cover-text small{
    font-size:12px;
    font-weight:800;
    letter-spacing:5px;
    text-transform:uppercase;
    opacity:.9;
  }
  .cover-text h2{
    margin-top:8px;
    font-size:44px;
    font-weight:900;
    letter-spacing:-1px;
    padding:0 20px;
    word-break:break-word;
    text-shadow:0 6px 24px rgba(120,20,20,.3);
  }

  /* two layers of waves along the bottom edge of the cover */
  .waves{ position:absolute; left:0; bottom:-1px; width:200%; height:80px; z-index:2; }
  .waves svg{ width:100%; height:100%; display:block; }
  .w1{ animation:waveMove 14s linear infinite; opacity:.55; }
  .w2{ animation:waveMove 9s linear infinite reverse; bottom:-1px; }
  @keyframes waveMove{ from{ transform:translateX(0);} to{ transform:translateX(-50%);} }

  @keyframes fadeUp{ from{ opacity:0; transform:translate(-50%,calc(-50% + 22px)); } to{ opacity:1; transform:translate(-50%,-50%); } }

  /* ---------- layout ---------- */
  .wrap{
    position:relative;
    z-index:5;
    max-width:1060px;
    margin:-110px auto 70px auto;
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

  /* ---------- left: identity card ---------- */
  .me{
    padding:0 26px 28px 26px;
    text-align:center;
    animation-delay:.1s;
  }

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
  .avatar svg{ width:100%; height:100%; display:block; transition:transform .5s ease; }
  .avatar-wrap:hover .avatar svg{ transform:scale(1.12) rotate(3deg); }

  .me h1{
    font-size:26px;
    font-weight:900;
    letter-spacing:-.3px;
    word-break:break-word;
  }

  .chip{
    display:inline-flex;
    align-items:center;
    gap:8px;
    margin-top:10px;
    padding:7px 15px;
    font-size:11px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:#1c7a45;
    background:#e5f8ec;
    border-radius:999px;
  }
  .chip i{
    width:8px; height:8px;
    border-radius:50%;
    background:#2ecc71;
    animation:ping 2s ease-out infinite;
  }
  @keyframes ping{
    0%{ box-shadow:0 0 0 0 rgba(46,204,113,.7); }
    80%,100%{ box-shadow:0 0 0 10px rgba(46,204,113,0); }
  }

  .me .actions{ margin-top:24px; display:grid; gap:12px; }

  .act{
    position:relative;
    overflow:hidden;
    display:block;
    text-align:center;
    text-decoration:none;
    font-weight:800;
    font-size:12px;
    letter-spacing:2px;
    text-transform:uppercase;
    padding:15px 14px;
    border-radius:14px;
    transition:transform .25s ease, box-shadow .25s ease, background .25s ease;
  }
  .act-edit{
    color:#fff;
    background:linear-gradient(135deg,var(--accent),var(--pink));
    box-shadow:0 12px 30px rgba(255,61,127,.35);
  }
  .act-edit:hover{ transform:translateY(-3px); box-shadow:0 18px 40px rgba(255,61,127,.5); }
  .act-edit::after{
    content:"";
    position:absolute;
    top:0; left:-80%;
    width:50%; height:100%;
    background:linear-gradient(100deg,transparent,rgba(255,255,255,.6),transparent);
    transform:skewX(-20deg);
  }
  .act-edit:hover::after{ left:130%; transition:left .7s ease; }

  .act-out{ color:var(--ink); background:#f1eee8; }
  .act-out:hover{ transform:translateY(-3px); background:var(--ink); color:#fff; }

  /* ---------- right column ---------- */
  .main{ display:grid; gap:26px; }

  /* stat tiles */
  .stats{ display:grid; grid-template-columns:repeat(3,1fr); gap:18px; }

  .stat{
    padding:22px 20px;
    transition:transform .3s ease, box-shadow .3s ease;
  }
  .stat:nth-child(1){ animation-delay:.2s; }
  .stat:nth-child(2){ animation-delay:.3s; }
  .stat:nth-child(3){ animation-delay:.4s; }
  .stat:hover{ transform:translateY(-6px); box-shadow:0 26px 60px rgba(20,20,20,.16); }

  .stat .si{
    width:46px; height:46px;
    display:flex;
    align-items:center;
    justify-content:center;
    border-radius:14px;
    margin-bottom:16px;
    color:#fff;
    transition:transform .4s ease;
  }
  .stat:hover .si{ transform:rotate(-10deg) scale(1.12); }
  .si.a{ background:linear-gradient(135deg,var(--accent),var(--gold)); }
  .si.b{ background:linear-gradient(135deg,var(--pink),var(--accent)); }
  .si.c{ background:linear-gradient(135deg,#2ecc71,#19b5c9); }
  .si svg{
    width:22px; height:22px;
    fill:none; stroke:#fff; stroke-width:1.9;
    stroke-linecap:round; stroke-linejoin:round;
  }

  .stat .num{ font-size:30px; font-weight:900; letter-spacing:-1px; }
  .stat .num small{ font-size:15px; font-weight:800; margin-left:2px; }
  .stat .lab{
    margin-top:4px;
    font-size:11px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:var(--muted);
  }

  /* details */
  .details{ padding:12px 14px; animation-delay:.45s; }
  .details h3, .quick h3{
    padding:14px 14px 6px 14px;
    font-size:12px;
    font-weight:800;
    letter-spacing:3px;
    text-transform:uppercase;
    color:var(--muted);
  }

  .row{
    display:flex;
    align-items:center;
    gap:16px;
    padding:14px;
    margin-top:6px;
    border-radius:16px;
    transition:background .25s ease, transform .25s ease;
  }
  .row:hover{ background:#faf8f4; transform:translateX(6px); }

  .ico{
    width:46px; height:46px;
    flex-shrink:0;
    display:flex;
    align-items:center;
    justify-content:center;
    border-radius:14px;
    background:#fff1ea;
    transition:transform .35s ease, background .25s ease;
  }
  .row:hover .ico{ transform:rotate(-8deg) scale(1.1); background:var(--accent); }
  .ico svg{
    width:21px; height:21px;
    fill:none; stroke:var(--accent); stroke-width:1.9;
    stroke-linecap:round; stroke-linejoin:round;
    transition:stroke .25s ease;
  }
  .row:hover .ico svg{ stroke:#fff; }

  .txt{ flex:1; min-width:0; }
  .label{
    font-size:11px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    color:var(--muted);
  }
  .value{ margin-top:3px; font-size:17px; font-weight:800; word-break:break-word; }

  .copy{
    flex-shrink:0;
    padding:9px 14px;
    font-family:inherit;
    font-size:11px;
    font-weight:800;
    letter-spacing:1.5px;
    text-transform:uppercase;
    color:var(--ink);
    background:#f1eee8;
    border:none;
    border-radius:10px;
    cursor:pointer;
    opacity:0;
    transform:translateX(10px);
    transition:all .25s ease;
  }
  .row:hover .copy, .copy:focus{ opacity:1; transform:none; }
  .copy:hover{ background:var(--ink); color:#fff; }

  /* quick actions */
  .quick{ padding:12px 14px 18px 14px; animation-delay:.55s; }

  .tiles{ display:grid; grid-template-columns:repeat(2,1fr); gap:14px; padding:8px 14px 0 14px; }

  .tile{
    position:relative;
    overflow:hidden;
    display:flex;
    align-items:center;
    gap:16px;
    padding:18px;
    text-decoration:none;
    color:var(--ink);
    border-radius:18px;
    background:#faf8f4;
    border:1px solid rgba(20,20,20,.06);
    transition:transform .3s ease, box-shadow .3s ease, color .3s ease;
    z-index:0;
  }
  /* color floods the tile on hover */
  .tile::before{
    content:"";
    position:absolute;
    inset:0;
    z-index:-1;
    transform:translateY(101%);
    transition:transform .4s cubic-bezier(.2,.8,.2,1);
  }
  .tile.t1::before{ background:linear-gradient(135deg,#141414,#3a3a3a); }
  .tile.t2::before{ background:linear-gradient(135deg,var(--pink),var(--accent)); }
  .tile.t3::before{ background:linear-gradient(135deg,var(--accent),var(--gold)); }
  .tile.t4::before{ background:linear-gradient(135deg,#19b5c9,#2ecc71); }
  .tile:hover::before{ transform:none; }
  .tile:hover{ color:#fff; transform:translateY(-5px); box-shadow:0 22px 44px rgba(20,20,20,.2); }

  .tile .ti{
    width:44px; height:44px;
    flex-shrink:0;
    display:flex;
    align-items:center;
    justify-content:center;
    border-radius:13px;
    background:#fff;
    transition:transform .35s ease;
  }
  .tile:hover .ti{ transform:rotate(-8deg) scale(1.1); }
  .tile .ti svg{
    width:21px; height:21px;
    fill:none; stroke:var(--ink); stroke-width:1.9;
    stroke-linecap:round; stroke-linejoin:round;
  }

  .tile b{ display:block; font-size:15px; font-weight:800; }
  .tile small{ display:block; margin-top:2px; font-size:12px; font-weight:600; opacity:.65; }

  .tile .go{
    margin-left:auto;
    font-size:20px;
    font-weight:900;
    transition:transform .3s ease;
  }
  .tile:hover .go{ transform:translateX(6px); }

  /* message card (not logged in) */
  .msg-wrap{ max-width:480px; margin:-80px auto 80px auto; padding:0 22px; position:relative; z-index:6; }
  .msg{
    padding:50px 28px;
    text-align:center;
    font-size:18px;
    font-weight:800;
  }
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
    transition:transform .25s ease;
  }
  .msg a:hover{ transform:translateY(-3px); }

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

  /* ---------- tablets / phones ---------- */
  @media (max-width:900px){
    .wrap{ grid-template-columns:1fr; margin-top:-90px; }
    .stats{ grid-template-columns:1fr 1fr 1fr; }
    .cover-text h2{ font-size:32px; }
  }
  @media (max-width:560px){
    .cover{ height:210px; }
    .stats{ grid-template-columns:1fr; }
    .tiles{ grid-template-columns:1fr; }
    .copy{ opacity:1; transform:none; }
    .cover-text h2{ font-size:26px; }
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

<%
String uname = (String)session.getAttribute("uname");
String upass = (String)session.getAttribute("upass");

boolean showCard = false;
String pName = "", pGender = "", pEmail = "", pContact = "";

if (uname != null && upass != null)
{
    rst = stmt.executeQuery(
        "select * from signin where name='" + uname +
        "' and password='" + upass + "'"
    );

    if (rst.next())
    {
        showCard = true;
        pName    = rst.getString(1);
        pGender  = rst.getString(2);
        pEmail   = rst.getString(4);
        pContact = rst.getString(5);
    }
}

if (showCard)
{
    // ----- cart numbers for the stat tiles -----
    int cartCount = 0;
    java.math.BigDecimal cartTotal = java.math.BigDecimal.ZERO;
%>
<%@ include file="makecart.jsp" %>
<%
    Object pcid = session.getAttribute("cartId");
    if (pcid != null) {
      try {
        PreparedStatement pcs = con.prepareStatement(
          "SELECT COALESCE(SUM(quantity),0), COALESCE(SUM(price*quantity),0) FROM cart_items WHERE cart_id=?");
        pcs.setInt(1, ((Integer) pcid).intValue());
        ResultSet pcr = pcs.executeQuery();
        if (pcr.next()) {
          cartCount = pcr.getInt(1);
          cartTotal = pcr.getBigDecimal(2);
        }
      } catch (Exception ce) { /* cart tables not ready: just show 0 */ }
    }

    String initial = "?";
    if (pName != null && pName.length() > 0) initial = pName.substring(0,1);
    String totalText = cartTotal.stripTrailingZeros().toPlainString();
    if (totalText.indexOf("E") >= 0) totalText = cartTotal.toPlainString();
%>

<!-- animated cover -->
<div class="cover">
  <div class="c c1"></div><div class="c c2"></div><div class="c c3"></div><div class="c c4"></div>

  <div class="cover-text">
    <small>Welcome back</small>
    <h2><%= esc(pName) %></h2>
  </div>

  <div class="waves w1">
    <svg viewBox="0 0 2400 80" preserveAspectRatio="none"><path d="M0 40 Q150 0 300 40 T600 40 T900 40 T1200 40 T1500 40 T1800 40 T2100 40 T2400 40 V80 H0z" fill="#f5f4f0"/></svg>
  </div>
  <div class="waves w2">
    <svg viewBox="0 0 2400 80" preserveAspectRatio="none"><path d="M0 52 Q150 14 300 52 T600 52 T900 52 T1200 52 T1500 52 T1800 52 T2100 52 T2400 52 V80 H0z" fill="#f5f4f0"/></svg>
  </div>
</div>

<div class="wrap">

  <!-- LEFT: identity -->
  <div class="panel me">

    <div class="avatar-wrap">
      <div class="avatar">
<% if ("Male".equalsIgnoreCase(pGender)) { %>
        <svg viewBox="0 0 100 100" aria-label="Male avatar">
          <defs><linearGradient id="bgM" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ffb347"/><stop offset="1" stop-color="#ff4d1c"/></linearGradient></defs>
          <rect width="100" height="100" fill="url(#bgM)"/>
          <path d="M16 100c0-21 15-31 34-31s34 10 34 31z" fill="#2b2f4a"/>
          <path d="M42 70l8 9 8-9z" fill="#f5f1ea"/>
          <rect x="43" y="55" width="14" height="17" rx="6" fill="#e0b08a"/>
          <circle cx="50" cy="42" r="19" fill="#f2c9a5"/>
          <path d="M30 41c-3-17 9-25 21-24 13 1 21 9 19 25-3-9-8-13-20-13-9 0-15 4-20 12z" fill="#2a1d18"/>
          <circle cx="43" cy="45" r="1.9" fill="#2a1d18"/><circle cx="57" cy="45" r="1.9" fill="#2a1d18"/>
          <path d="M44 52q6 5 12 0" stroke="#a5614a" stroke-width="2" fill="none" stroke-linecap="round"/>
        </svg>
<% } else if ("Female".equalsIgnoreCase(pGender)) { %>
        <svg viewBox="0 0 100 100" aria-label="Female avatar">
          <defs><linearGradient id="bgF" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#ff7eb3"/><stop offset="1" stop-color="#7b3fe4"/></linearGradient></defs>
          <rect width="100" height="100" fill="url(#bgF)"/>
          <path d="M26 50c-5-26 8-37 24-37s29 11 24 37c-1 14 4 22 7 30H19c3-8 8-16 7-30z" fill="#3a2118"/>
          <path d="M18 100c0-21 15-31 32-31s32 10 32 31z" fill="#ff4d1c"/>
          <rect x="43" y="55" width="14" height="17" rx="6" fill="#e0b08a"/>
          <circle cx="50" cy="43" r="18" fill="#f2c9a5"/>
          <path d="M31 41c3-11 11-16 20-16 11 0 18 7 19 17-6-6-12-8-20-8-8 0-14 3-19 7z" fill="#3a2118"/>
          <circle cx="43" cy="46" r="1.9" fill="#2a1d18"/><circle cx="57" cy="46" r="1.9" fill="#2a1d18"/>
          <path d="M44 53q6 5 12 0" stroke="#c0505f" stroke-width="2" fill="none" stroke-linecap="round"/>
          <circle cx="38" cy="51" r="3" fill="#ff9aa2" opacity=".45"/><circle cx="62" cy="51" r="3" fill="#ff9aa2" opacity=".45"/>
        </svg>
<% } else { %>
        <span><%= esc(initial) %></span>
<% } %>
      </div>
    </div>

    <h1><%= esc(pName) %></h1>
    <div class="chip"><i></i>Active Member</div>

    <div class="actions">
      <a href="edit.jsp" class="act act-edit">Edit Profile</a>
      <a href="logout.jsp" class="act act-out">Log-out</a>
    </div>
  </div>

  <!-- RIGHT: stats, details, shortcuts -->
  <div class="main">

    <div class="stats">
      <div class="panel stat">
        <div class="si a"><svg viewBox="0 0 24 24"><path d="M3 4h2l2.4 11h10.2L20 7H6"/><circle cx="9" cy="19.5" r="1.4"/><circle cx="17" cy="19.5" r="1.4"/></svg></div>
        <div class="num" data-count="<%= cartCount %>">0</div>
        <div class="lab">Items in cart</div>
      </div>

      <div class="panel stat">
        <div class="si b"><svg viewBox="0 0 24 24"><rect x="3" y="6" width="18" height="13" rx="2.5"/><path d="M3 10h18M7 15h4"/></svg></div>
        <div class="num" data-count="<%= totalText %>" data-money="1">0</div>
        <div class="lab">Cart value</div>
      </div>

      <div class="panel stat">
        <div class="si c"><svg viewBox="0 0 24 24"><path d="M12 3l7 3v5c0 5-3.2 8.4-7 10-3.8-1.6-7-5-7-10V6z"/><path d="M9 12l2.2 2.2L15 10"/></svg></div>
        <div class="num">Active</div>
        <div class="lab">Account status</div>
      </div>
    </div>

    <div class="panel details">
      <h3>Account details</h3>

      <div class="row">
        <div class="ico"><svg viewBox="0 0 24 24"><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"/></svg></div>
        <div class="txt"><div class="label">Name</div><div class="value"><%= esc(pName) %></div></div>
        <button type="button" class="copy" data-copy="<%= esc(pName) %>">Copy</button>
      </div>

      <div class="row">
        <div class="ico"><svg viewBox="0 0 24 24"><circle cx="12" cy="12" r="8"/><path d="M12 8v8M8 12h8"/></svg></div>
        <div class="txt"><div class="label">Gender</div><div class="value"><%= esc(pGender) %></div></div>
        <button type="button" class="copy" data-copy="<%= esc(pGender) %>">Copy</button>
      </div>

      <div class="row">
        <div class="ico"><svg viewBox="0 0 24 24"><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></svg></div>
        <div class="txt"><div class="label">E-mail</div><div class="value"><%= esc(pEmail) %></div></div>
        <button type="button" class="copy" data-copy="<%= esc(pEmail) %>">Copy</button>
      </div>

      <div class="row">
        <div class="ico"><svg viewBox="0 0 24 24"><path d="M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z"/></svg></div>
        <div class="txt"><div class="label">Contact</div><div class="value"><%= esc(pContact) %></div></div>
        <button type="button" class="copy" data-copy="<%= esc(pContact) %>">Copy</button>
      </div>
    </div>

    <div class="panel quick">
      <h3>Quick actions</h3>
      <div class="tiles">
        <a href="mycart.jsp" class="tile t3">
          <span class="ti"><svg viewBox="0 0 24 24"><path d="M3 4h2l2.4 11h10.2L20 7H6"/><circle cx="9" cy="19.5" r="1.4"/><circle cx="17" cy="19.5" r="1.4"/></svg></span>
          <span><b>My Cart</b><small>See what you picked</small></span>
          <span class="go">&rarr;</span>
        </a>
        <a href="men.html" class="tile t1">
          <span class="ti"><svg viewBox="0 0 24 24"><path d="M3 8l5-3 4 2 4-2 5 3-2 4-3-1v9H8v-9l-3 1z"/></svg></span>
          <span><b>Shop Men</b><small>T-shirts &amp; more</small></span>
          <span class="go">&rarr;</span>
        </a>
        <a href="women.html" class="tile t2">
          <span class="ti"><svg viewBox="0 0 24 24"><path d="M9 3l3 3 3-3 3 4-2 3v11H8V10L6 7z"/></svg></span>
          <span><b>Shop Women</b><small>New styles</small></span>
          <span class="go">&rarr;</span>
        </a>
        <a href="edit.jsp" class="tile t4">
          <span class="ti"><svg viewBox="0 0 24 24"><path d="M4 20l4-1 11-11-3-3L5 16z"/><path d="M14 7l3 3"/></svg></span>
          <span><b>Edit Profile</b><small>Update your details</small></span>
          <span class="go">&rarr;</span>
        </a>
      </div>
    </div>

  </div>
</div>

<div class="toast" id="toast">Copied!</div>

<script>
  // ----- numbers count up when the page opens -----
  var nums = document.querySelectorAll('[data-count]');
  for (var i = 0; i < nums.length; i++) {
    (function (node) {
      var target = parseFloat(node.getAttribute('data-count')) || 0;
      var money  = node.getAttribute('data-money');
      var start  = null;
      var dur    = 1400;

      function fmt(v) {
        var s = Math.round(v).toLocaleString('en-IN');
        return money ? s + '<small>Rs</small>' : s;
      }

      function step(t) {
        if (!start) start = t;
        var p = Math.min(1, (t - start) / dur);
        var e = 1 - Math.pow(1 - p, 3);
        node.innerHTML = fmt(target * e);
        if (p < 1) requestAnimationFrame(step);
      }
      setTimeout(function () { requestAnimationFrame(step); }, 500);
    })(nums[i]);
  }

  // ----- copy buttons -----
  var toast = document.getElementById('toast');
  var timer;

  function showToast(text) {
    toast.textContent = text;
    toast.classList.add('show');
    clearTimeout(timer);
    timer = setTimeout(function () { toast.classList.remove('show'); }, 1600);
  }

  function copyText(text) {
    if (navigator.clipboard && navigator.clipboard.writeText) {
      return navigator.clipboard.writeText(text);
    }
    return new Promise(function (resolve) {
      var t = document.createElement('textarea');
      t.value = text;
      document.body.appendChild(t);
      t.select();
      document.execCommand('copy');
      document.body.removeChild(t);
      resolve();
    });
  }

  var btns = document.querySelectorAll('.copy');
  for (var b = 0; b < btns.length; b++) {
    btns[b].addEventListener('click', function () {
      var text = this.getAttribute('data-copy');
      copyText(text).then(function () { showToast('Copied: ' + text); });
    });
  }
</script>

<%
}
else
{
%>

<div class="cover" style="height:230px;">
  <div class="c c1"></div><div class="c c3"></div>
  <div class="cover-text"><small>Profile</small><h2>Please login</h2></div>
  <div class="waves w1"><svg viewBox="0 0 2400 80" preserveAspectRatio="none"><path d="M0 40 Q150 0 300 40 T600 40 T900 40 T1200 40 T1500 40 T1800 40 T2100 40 T2400 40 V80 H0z" fill="#f5f4f0"/></svg></div>
  <div class="waves w2"><svg viewBox="0 0 2400 80" preserveAspectRatio="none"><path d="M0 52 Q150 14 300 52 T600 52 T900 52 T1200 52 T1500 52 T1800 52 T2100 52 T2400 52 V80 H0z" fill="#f5f4f0"/></svg></div>
</div>

<div class="msg-wrap">
  <div class="panel msg">
    <%= (uname != null && upass != null) ? "User details not found." : "Please login first." %>
    <br /><a href="login.jsp">Login</a>
  </div>
</div>

<%
}
%>

</body>
</html>
