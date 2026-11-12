<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*,java.math.BigDecimal" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>My Cart</title>
<style>
  :root{
    --ink:#141414;
    --paper:#f5f4f0;
    --accent:#ff4d1c;
  }
  *{ box-sizing:border-box; margin:0; padding:0; }
  body{ font-family:'Helvetica Neue', Arial, sans-serif; background:var(--paper); color:var(--ink); }

  /* NAVBAR */
  .navbar{
    display:grid; grid-template-columns:1fr auto 1fr; align-items:center;
    padding:18px 40px; background:var(--paper); border-bottom:3px solid var(--ink);
  }
  .logo{ font-size:22px; font-weight:800; letter-spacing:2px; text-transform:uppercase; justify-self:start; }
  .logo span{ color:var(--accent); }
  .nav-center{ display:flex; gap:48px; justify-self:center; }
  .nav-center a{
    text-decoration:none; color:var(--ink); font-weight:700; font-size:15px;
    letter-spacing:1px; text-transform:uppercase; padding:6px 2px;
  }
  .nav-right{ display:flex; gap:14px; justify-self:end; align-items:center; }
  .btn{
    text-decoration:none; font-weight:700; font-size:13px; letter-spacing:1px; text-transform:uppercase;
    padding:10px 20px; border-radius:999px; border:2px solid var(--ink); color:var(--ink);
    transition:all .2s ease;
  }
  .btn:hover{ background:var(--ink); color:var(--paper); }
  .btn-cart{ background:var(--accent); border-color:var(--accent); }
  @media (max-width:700px){
    .navbar{ grid-template-columns:1fr; row-gap:14px; padding:16px 20px; }
    .logo, .nav-center, .nav-right{ justify-self:center; }
    .nav-center{ gap:28px; }
  }

  /* CART */
  .wrap{ max-width:1100px; margin:0 auto; padding:30px 20px; }
  .wrap h1{ font-size:28px; font-weight:800; letter-spacing:1px; text-transform:uppercase; margin-bottom:20px; }
  .table-box{ overflow-x:auto; }
  .cart-table{ width:100%; border-collapse:collapse; background:#fff; border:2px solid var(--ink); }
  .cart-table th{
    background:#f0ede9; text-transform:uppercase; letter-spacing:.5px; font-size:13px;
    padding:12px; text-align:left; border-bottom:2px solid var(--ink);
  }
  .cart-table td{ padding:12px; border-bottom:1px solid #ddd; font-size:15px; vertical-align:middle; }
  .cart-table img{ width:90px; height:70px; object-fit:cover; display:block; border:1px solid #ccc; }
  .empty{ text-align:center; padding:30px; font-weight:700; }

  .btn-remove, .btn-edit{
    display:inline-block; font-weight:700; font-size:12px; letter-spacing:.5px; text-transform:uppercase;
    padding:8px 12px; border-radius:4px; border:2px solid var(--ink); cursor:pointer;
    text-decoration:none; color:var(--ink); background:transparent; font-family:inherit;
  }
  .btn-remove:hover{ background:#c0392b; border-color:#c0392b; color:#fff; }
  .btn-edit:hover{ background:var(--ink); color:var(--paper); }
  .edit-input{ border:1px solid var(--ink); padding:6px 8px; font-family:inherit; font-size:14px; background:#fff; }
  .edit-input.qty{ width:70px; }
  .actions{ display:flex; gap:8px; align-items:center; }
  .actions form{ margin:0; }

  .summary{ margin-top:20px; margin-left:auto; max-width:380px; background:#fff; border:2px solid var(--ink); }
  .summary .row{ display:flex; justify-content:space-between; padding:12px 16px; border-bottom:1px solid #ddd; font-weight:600; }
  .summary .grand{ background:var(--accent); font-weight:800; font-size:18px; text-transform:uppercase; border-bottom:none; }
  .btn-checkout{
    display:block; text-align:center; text-decoration:none; font-weight:700; letter-spacing:1px;
    text-transform:uppercase; padding:14px; background:var(--ink); color:var(--paper);
  }
  .btn-checkout:hover{ background:var(--accent); color:var(--ink); }
  .msg{ padding:40px; font-weight:700; }
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
      <a href="profile.jsp" class="btn">Profile</a>
    </div>
  </nav>

<% if (session.getAttribute("uname") == null) { %>

  <p class="msg">Please log in to see your cart. <a href="login.jsp">Login</a></p>

<% } else { %>

<%@ include file="makecart.jsp" %>

<%
  Object cid = session.getAttribute("cartId");
  if (cid == null) {
%>
  <p class="msg">Cart not found. Please log in again. <a href="login.jsp">Login</a></p>
<%
  } else {

    // ---- UPDATE size / quantity when the Update button was clicked ----
    if (request.getParameter("Update") != null) {
      String uid2  = request.getParameter("id");
      String usize = request.getParameter("size");
      String uqty  = request.getParameter("qty");

      int uq = 1;
      try { uq = Integer.parseInt(uqty); } catch (Exception e) { uq = 1; }
      if (uq < 1)  uq = 1;
      if (uq > 10) uq = 10;

      try {
        PreparedStatement ups = con.prepareStatement(
          "UPDATE cart_items SET size=?, quantity=? WHERE item_id=? AND cart_id=?");
        if (usize == null || usize.equals("")) {
          ups.setNull(1, java.sql.Types.VARCHAR);
        } else {
          ups.setString(1, usize);
        }
        ups.setInt(2, uq);
        ups.setInt(3, Integer.parseInt(uid2));
        ups.setInt(4, ((Integer) cid).intValue());
        ups.executeUpdate();
      } catch (Exception e2) {
        out.println(e2);
      }
    }
    // ---- end of update ----

    PreparedStatement lps = con.prepareStatement(
      "SELECT * FROM cart_items WHERE cart_id=? ORDER BY item_id");
    lps.setInt(1, ((Integer) cid).intValue());
    ResultSet lr = lps.executeQuery();

    BigDecimal subtotal = BigDecimal.ZERO;
    int count = 0;
%>

  <div class="wrap">
    <h1>My Cart</h1>

    <div class="table-box">
      <table class="cart-table">
        <tr>
          <th>Image</th>
          <th>Product</th>
          <th>Price</th>
          <th>Size</th>
          <th>Qty</th>
          <th>Total</th>
          <th>&nbsp;</th>
        </tr>

<%
    while (lr.next()) {
      count++;
      int iid        = lr.getInt("item_id");
      String iname   = lr.getString("product_name");
      String iimage  = lr.getString("image");
      BigDecimal pr  = lr.getBigDecimal("price");
      int q          = lr.getInt("quantity");
      String sz      = lr.getString("size");
      if (sz == null || sz.equals("")) sz = "-";
      BigDecimal line = pr.multiply(BigDecimal.valueOf(q));
      subtotal = subtotal.add(line);
%>
        <tr>
          <td><img src="<%= iimage %>" alt="<%= iname %>"></td>
          <td><strong><%= iname %></strong></td>
          <td><%= pr.stripTrailingZeros().toPlainString() %> Rs</td>
          <td>
            <select name="size" form="f<%= iid %>" class="edit-input">
              <option value="">Select</option>
              <% for (int s = 6; s <= 12; s++) { String v = "UK " + s; %>
              <option value="<%= v %>" <%= v.equals(sz) ? "selected" : "" %>><%= v %></option>
              <% } %>
            </select>
          </td>
          <td><input type="number" name="qty" min="1" max="10" value="<%= q %>" form="f<%= iid %>" class="edit-input qty"></td>
          <td><%= line.stripTrailingZeros().toPlainString() %> Rs</td>
          <td>
            <div class="actions">
              <form id="f<%= iid %>" action="mycart.jsp" method="post">
                <input type="hidden" name="id" value="<%= iid %>">
                <button type="submit" name="Update" value="1" class="btn-edit">Update</button>
              </form>
              <form action="removeItem.jsp" method="post"
                    onsubmit="return confirm('Remove this item from your cart?');">
                <input type="hidden" name="id" value="<%= iid %>">
                <button type="submit" class="btn-remove">Remove</button>
              </form>
            </div>
          </td>
        </tr>
<%
    }

    if (count == 0) {
%>
        <tr>
          <td colspan="7" class="empty">
            Your cart is empty. <a href="loginhome.html">Continue shopping</a>
          </td>
        </tr>
<%
    }
%>
      </table>
    </div>

<%
    if (count > 0) {
      BigDecimal delivery = new BigDecimal("30");
      BigDecimal grand = subtotal.add(delivery);
%>
    <div class="summary">
      <div class="row"><span>Subtotal</span><span><%= subtotal.stripTrailingZeros().toPlainString() %> Rs</span></div>
      <div class="row"><span>Delivery</span><span><%= delivery.toPlainString() %> Rs</span></div>
      <div class="row grand"><span>Total</span><span><%= grand.stripTrailingZeros().toPlainString() %> Rs</span></div>
      <a href="payment.jsp" class="btn-checkout">Checkout</a>
    </div>
<%
    }
%>
  </div>

<%
  }
%>

<% } %>

</body>
</html>