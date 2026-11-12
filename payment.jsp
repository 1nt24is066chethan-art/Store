<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*,java.math.BigDecimal" errorPage="" %>
<%!
  static String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;");
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Payment</title>

<style>
  :root{
    --ink:#141414;
    --paper:#f5f4f0;
    --line:#141414;
    --accent:#ff4d1c;
    --accent-ink:#141414;
  }

  *{
    box-sizing:border-box;
    margin:0;
    padding:0;
  }

  body{
    font-family:'Helvetica Neue', Arial, sans-serif;
    background:var(--paper);
    color:var(--ink);
  }

  /* ===== NAVBAR ===== */

  .navbar{
    display:grid;
    grid-template-columns:1fr auto 1fr;
    align-items:center;
    padding:18px 40px;
    background:var(--paper);
    border-bottom:3px solid var(--ink);
  }

  .logo{
    font-size:22px;
    font-weight:800;
    letter-spacing:2px;
    text-transform:uppercase;
    justify-self:start;
  }

  .logo span{
    color:var(--accent);
  }

  /* ===== PAGE CONTENT WRAPPER (Split Layout) ===== */

  .payment-container {
    display: flex;
    justify-content: center;
    align-items: stretch;
    gap: 30px;
    width: 95%;          /* Takes up most of the screen width */
    max-width: 1400px;   /* Wider maximum container */
    margin: 40px auto;
    padding: 0 20px;
    min-height: calc(100vh - 150px);
  }

  /* Left Column: Order Summary (Takes wider half of screen) */
  .left-column {
    flex: 1.2;           /* Wider flex proportion */
    display: flex;
  }

  /* Right Column: QR Scanner (Takes other half) */
  .right-column {
    flex: 1;             
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    background: #fff;
    border: 2px solid var(--ink);
    padding: 30px;
  }

  .right-column h2 {
    margin-bottom: 20px;
    font-size: 24px;
    text-transform: uppercase;
    letter-spacing: 2px;
  }

  .qr-box{
    background:white;
    padding:15px;
    border:3px solid var(--ink);
  }

  .qr-box img{
    display:block;
    width:240px;
    height:240px;
    object-fit:contain;
  }

  .right-column p{
    margin-top:15px;
    font-size:15px;
    font-weight:600;
    letter-spacing:1px;
    text-align: center;
  }

  /* ===== ORDER SUMMARY ===== */

  .order{
    width: 100%;           /* Forces order box to stretch wide horizontally */
    background:#fff;
    border:2px solid var(--ink);
    display: flex;
    flex-direction: column;
  }

  .order h3{
    padding:14px 18px;
    background:#f0ede9;
    border-bottom:2px solid var(--ink);
    text-transform:uppercase;
    letter-spacing:1px;
    font-size:16px;
  }

  .order .item{
    display:flex;
    align-items:center;
    gap:15px;
    padding:14px 18px;
    border-bottom:1px solid #ddd;
  }

  .order .item img{
    width:70px;
    height:60px;
    object-fit:cover;
    border:1px solid #ccc;
  }

  .order .item .info{
    flex:1;
    font-weight:700;
    font-size:15px;
  }

  .order .item .info small{
    display:block;
    font-weight:500;
    color:#555;
    margin-top:4px;
  }

  .order .item .amt{
    font-weight:700;
    font-size:15px;
  }

  .order .line{
    display:flex;
    justify-content:space-between;
    padding:14px 18px;
    font-weight:600;
    font-size:15px;
    border-bottom:1px solid #ddd;
  }

  .order .total{
    background:var(--accent);
    color:var(--accent-ink);
    font-weight:800;
    font-size:18px;
    text-transform:uppercase;
    border-bottom:none;
    margin-top: auto; 
  }

  /* ===== MOBILE ===== */

  @media (max-width:768px){
    .payment-container {
      flex-direction: column;
      align-items: center;
    }

    .navbar{
      grid-template-columns:1fr;
      row-gap:14px;
      padding:16px 20px;
    }

    .logo{
      justify-self:center;
    }

    .right-column h2{
      font-size:20px;
    }

    .qr-box img{
      width:180px;
      height:180px;
    }
  }

</style>

</head>

<body>
<%@ include file="db.jsp" %>
<%
  StringBuilder rows = new StringBuilder();
  BigDecimal subtotal = BigDecimal.ZERO;
  int itemCount = 0;

  String bPrice = request.getParameter("price");

  if (bPrice != null) {
    // ----- BUY button: one item sent from the shop page -----
    try {
      BigDecimal p = new BigDecimal(bPrice.trim());
      int bq = 1;
      try { bq = Integer.parseInt(request.getParameter("qty")); } catch (Exception e) { bq = 1; }
      if (bq < 1)  bq = 1;
      if (bq > 10) bq = 10;

      BigDecimal line = p.multiply(BigDecimal.valueOf(bq));
      subtotal = line;
      itemCount = 1;

      String bImage = request.getParameter("image");
      rows.append("<div class=\"item\">");
      if (bImage != null && !bImage.equals("")) {
        rows.append("<img src=\"" + esc(bImage) + "\" alt=\"\">");
      }
      rows.append("<div class=\"info\">" + esc(request.getParameter("name")));
      if (bq > 1) rows.append("<small>Qty " + bq + "</small>");
      rows.append("</div><div class=\"amt\">" + line.stripTrailingZeros().toPlainString() + " Rs</div></div>");
    } catch (NumberFormatException nfe) {
      itemCount = 0;
    }

  } else if (session.getAttribute("uname") != null) {
    // ----- from My Cart: every item in the user's cart -----
%>
<%@ include file="makecart.jsp" %>
<%
    Object cid = session.getAttribute("cartId");
    if (cid != null) {
      PreparedStatement cps = con.prepareStatement(
        "SELECT * FROM cart_items WHERE cart_id=? ORDER BY item_id");
      cps.setInt(1, ((Integer) cid).intValue());
      ResultSet cr = cps.executeQuery();

      while (cr.next()) {
        itemCount++;
        BigDecimal pr = cr.getBigDecimal("price");
        int q = cr.getInt("quantity");
        String sz = cr.getString("size");
        BigDecimal line = pr.multiply(BigDecimal.valueOf(q));
        subtotal = subtotal.add(line);

        rows.append("<div class=\"item\">");
        rows.append("<img src=\"" + esc(cr.getString("image")) + "\" alt=\"\">");
        rows.append("<div class=\"info\">" + esc(cr.getString("product_name")));
        rows.append("<small>");
        if (sz != null && !sz.equals("")) rows.append(esc(sz) + " &middot; ");
        rows.append("Qty " + q + "</small></div>");
        rows.append("<div class=\"amt\">" + line.stripTrailingZeros().toPlainString() + " Rs</div></div>");
      }
    }
  }

  BigDecimal delivery = (itemCount > 0) ? new BigDecimal("30") : BigDecimal.ZERO;
  BigDecimal grand = subtotal.add(delivery);
  String grandText = grand.stripTrailingZeros().toPlainString();
%>

<!-- ===== NAVBAR ===== -->

<nav class="navbar">

  <div class="logo">
    <span>Payment</span>
  </div>

</nav>


<div class="payment-container">

<% if (itemCount > 0) { %>

  <!-- LEFT COLUMN: Order Summary (Expanded to fill horizontal half of screen) -->
  <div class="left-column">
    <div class="order">
      <h3>Order Summary</h3>
      <%= rows.toString() %>
      <div class="line"><span>Delivery</span><span><%= delivery.toPlainString() %> Rs</span></div>
      <div class="line total"><span>Total to pay</span><span><%= grandText %> Rs</span></div>
    </div>
  </div>

  <!-- RIGHT COLUMN: Scan & Pay Scanner -->
  <div class="right-column">
    <h2>Scan &amp; Pay</h2>
    <div class="qr-box">
      <img src="image/payment.jpeg" alt="Payment QR Code" />
    </div>
    <p>Scan the QR code to pay <%= grandText %> Rs</p>
  </div>

<% } else { %>

  <div style="text-align: center; width: 100%; padding: 50px;">
    <h2>Nothing to pay</h2>
    <p style="margin-top: 10px;">No items found. <a href="loginhome.html">Go to the shop</a></p>
  </div>

<% } %>

</div>

</body>
</html>