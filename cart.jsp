<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Shopping Cart</title>
<style>
  :root{
    --ink:#141414;
    --paper:#f5f4f0;
    --line:#141414;
    --accent:#ff4d1c;
    --accent-ink:#141414;
  }

  *{ box-sizing:border-box; margin:0; padding:0; }

  body{
    font-family: 'Helvetica Neue', Arial, sans-serif;
    background:var(--paper);
    color:var(--ink);
  }

  /* ===== NAVBAR ===== */
  .navbar{
    display:grid;
    grid-template-columns: 1fr auto 1fr;
    align-items:center;
    padding: 18px 40px;
    background:var(--paper);
    border-bottom: 3px solid var(--ink);
  }

  .logo{
    font-size: 22px;
    font-weight: 800;
    letter-spacing: 2px;
    text-transform: uppercase;
    justify-self:start;
  }
  .logo span{ color:var(--accent); }

  .nav-center{
    display:flex;
    gap: 28px;
    justify-self:center;
    align-items:center;
  }

  .search-bar{
    display:flex;
    align-items:center;
    border: 2px solid var(--ink);
    border-radius: 999px;
    padding: 8px 16px;
    gap: 8px;
  }

  .search-bar input{
    border:none;
    background:transparent;
    outline:none;
    font-size: 14px;
    font-family: 'Helvetica Neue', Arial, sans-serif;
    color:var(--ink);
    width: 200px;
  }

  .search-bar input::placeholder{
    color:#999;
  }

  .search-btn{
    background:none;
    border:none;
    cursor:pointer;
    font-size: 16px;
    color:var(--ink);
    font-weight:700;
  }

  .nav-center a{
    position:relative;
    text-decoration:none;
    color:var(--ink);
    font-weight:700;
    font-size: 15px;
    letter-spacing: 1px;
    text-transform: uppercase;
    padding: 6px 2px;
  }

  .nav-center a::after{
    content:"";
    position:absolute;
    left:0; bottom:-2px;
    width:0%;
    height:3px;
    background:var(--accent);
    transition: width .25s ease;
  }

  .nav-center a:hover::after{ width:100%; }

  .nav-right{
    display:flex;
    gap: 14px;
    justify-self:end;
    align-items:center;
  }

  .btn{
    text-decoration:none;
    font-weight:700;
    font-size: 13px;
    letter-spacing: 1px;
    text-transform: uppercase;
    padding: 10px 20px;
    border-radius: 999px;
    border: 2px solid var(--ink);
    transition: all .2s ease;
  }

  .btn-login{
    color:var(--ink);
    background:transparent;
  }
  .btn-login:hover{
    background:var(--ink);
    color:var(--paper);
  }

  /* mobile */
  @media (max-width: 700px){
    .navbar{
      grid-template-columns: 1fr;
      row-gap: 14px;
      padding: 16px 20px;
    }
    .logo, .nav-center, .nav-right{ justify-self:center; }
    .nav-center{ gap: 20px; flex-direction: column; }
    .search-bar input{ width: 150px; }
  }

  /* ===== CART CONTAINER ===== */
  .cart-container {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 40px;
    padding: 40px;
    max-width: 1200px;
    margin: 0 auto;
  }

  /* Left side - Image */
  .cart-image {
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fff;
    border: 2px solid var(--ink);
    padding: 30px;
    min-height: 500px;
  }

  .cart-image img {
    width: 100%;
    height: auto;
    max-height: 450px;
    object-fit: contain;
  }

  /* Right side - Details Table */
  .cart-details {
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
  }

  .cart-details h1 {
    font-size: 28px;
    font-weight: 800;
    letter-spacing: 1px;
    text-transform: uppercase;
    margin-bottom: 30px;
    color: var(--ink);
  }

  .details-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
  }

  .details-table tr {
    border-bottom: 2px solid var(--line);
  }

  .details-table td {
    padding: 16px 12px;
    font-size: 15px;
    font-weight: 600;
    text-align: left;
  }

  .details-table .label {
    background: #f0ede9;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    width: 40%;
  }

  .details-table .value {
    background: #fff;
    color: var(--ink);
    font-weight: 500;
  }

  .details-table .value input {
    border: 1px solid var(--ink);
    padding: 8px 12px;
    font-size: 14px;
    font-family: 'Helvetica Neue', Arial, sans-serif;
    width: 100px;
  }

  .total-price {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    background: var(--accent);
    color: var(--accent-ink);
    font-size: 18px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 20px;
    border-radius: 4px;
  }

  .total-price .amount {
    font-size: 24px;
    color: var(--accent-ink);
  }

  /* Action Buttons */
  .action-buttons {
    display: flex;
    gap: 12px;
    flex-direction: column;
  }

  .btn-action {
    text-decoration: none;
    font-weight: 700;
    font-size: 14px;
    letter-spacing: 1px;
    text-transform: uppercase;
    padding: 14px 20px;
    border-radius: 4px;
    border: 2px solid var(--ink);
    cursor: pointer;
    transition: all .2s ease;
    text-align: center;
    display: block;
  }

  .btn-checkout {
    color: var(--accent-ink);
    background: var(--accent);
    border-color: var(--accent);
  }

  .btn-checkout:hover {
    background: var(--ink);
    border-color: var(--ink);
    color: var(--paper);
  }

  /* ===== GALLERY (4 in a row, same as openimage.jsp) ===== */
  .gallery {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 10px;
    width: 100%;
    padding: 20px;
  }

  .gallery-item {
    border: 1px solid #ccc;
    width: 100%;
    transition: all .2s ease;
  }

  .gallery-item:hover {
    border: 1px solid var(--accent);
    box-shadow: 0 4px 12px rgba(255, 77, 28, 0.2);
  }

  .gallery-item img {
    width: 100%;
    height: 40vh;
    min-height: 220px;
    object-fit: cover;
    display: block;
  }

  .gallery-item .desc {
    padding: 12px;
    text-align: center;
    font-weight: 700;
    letter-spacing: 1px;
    text-transform: uppercase;
    font-size: 14px;
  }

  .gallery-item .buttons {
    display: flex;
    gap: 8px;
    padding: 0 10px 10px 10px;
  }

  .btn-item {
    flex: 1;
    text-decoration: none;
    font-weight: 700;
    font-size: 12px;
    letter-spacing: 0.5px;
    text-transform: uppercase;
    padding: 10px 12px;
    border-radius: 4px;
    border: 2px solid var(--ink);
    cursor: pointer;
    transition: all .2s ease;
    text-align: center;
    display: block;
  }

  .btn-add-cart {
    color: var(--ink);
    background: transparent;
  }

  .btn-add-cart:hover {
    background: var(--ink);
    color: var(--paper);
  }

  .btn-buy {
    color: var(--accent-ink);
    background: var(--accent);
    border-color: var(--accent);
  }

  .btn-buy:hover {
    background: var(--ink);
    border-color: var(--ink);
    color: var(--paper);
  }

  /* makes the Add to Cart / Buy forms fit in the button row */
  .gallery-item .buttons form { flex: 1; display: flex; }
  .gallery-item .buttons form .btn-item { width: 100%; }

  /* Mobile Responsive */
  @media (max-width: 900px) {
    .cart-container {
      grid-template-columns: 1fr;
      gap: 30px;
      padding: 30px;
    }

    .cart-image {
      min-height: 350px;
    }

    .details-table .label {
      width: 50%;
    }

    .gallery{ grid-template-columns: repeat(2, 1fr); }
    .gallery-item img{ height: 32vh; }
  }

  @media (max-width: 480px) {
    .cart-container {
      gap: 20px;
      padding: 20px;
    }

    .cart-details h1 {
      font-size: 22px;
      margin-bottom: 20px;
    }

    .details-table td {
      padding: 12px 8px;
      font-size: 13px;
    }

    .total-price {
      flex-direction: column;
      gap: 10px;
      text-align: center;
    }

    .action-buttons {
      flex-direction: column;
    }

    .btn-action {
      padding: 12px 16px;
      font-size: 12px;
    }

    .gallery{ grid-template-columns: 1fr; padding: 12px; }
    .gallery-item img{ height: 45vh; }
    .gallery-item .buttons { flex-direction: column; }
  }

</style>
</head>

<body>
<%@ include file="db.jsp" %>
<%
  boolean found = false;
  String pName = "", pImage = "", pPrice = "0";
  int pQty = 1;

  String sUser  = (String) session.getAttribute("uname");
  Object sCart  = session.getAttribute("cartId");
  String itemId = request.getParameter("id");

  if (sUser != null && sCart != null && itemId != null) {
    try {
      PreparedStatement ips = con.prepareStatement(
        "SELECT * FROM cart_items WHERE item_id=? AND cart_id=?");
      ips.setInt(1, Integer.parseInt(itemId));
      ips.setInt(2, ((Integer) sCart).intValue());
      ResultSet ir = ips.executeQuery();
      if (ir.next()) {
        found  = true;
        pName  = ir.getString("product_name");
        pImage = ir.getString("image");
        pPrice = ir.getBigDecimal("price").stripTrailingZeros().toPlainString();
        pQty   = ir.getInt("quantity");
      }
    } catch (Exception e) { out.println(e); }
  }
%>

  <nav class="navbar">
    <div class="logo"><span>Adidas</span></div>

    <div class="nav-center">
      <div class="search-bar">
        <input type="text" placeholder="Search shoes...">
        <button class="search-btn">Search</button>
      </div>
    </div>

    <div class="nav-right">
		<a href="mycart.jsp" class="btn btn-signup">Cart</a>
      <a href="profile.jsp" class="btn btn-login">Profile</a>
    </div>
  </nav>

<% if (found) { %>
  <div class="cart-container">
    <!-- Left: Product Image -->
    <div class="cart-image">
      <img src="<%= pImage %>" alt="<%= pName %>" id="cartImage">
    </div>

    <!-- Right: Product Details -->
    <div class="cart-details">
      <h1>Summary</h1>

      <table class="details-table">
        <tr>
          <td class="label">Product Name</td>
          <td class="value"><%= pName %></td>
        </tr>
        <tr>
          <td class="label">Price</td>
          <td class="value" id="unitPrice" data-price="<%= pPrice %>"><%= pPrice %> Rs</td>
        </tr>
        <tr>
          <td class="label">Delivery Charge</td>
          <td class="value" id="deliveryCharge" data-delivery="30">30 Rs</td>
        </tr>
        <tr>
          <td class="label">Size</td>
          <td class="value">
            <select style="border: 1px solid var(--ink); padding: 8px; font-family: 'Helvetica Neue', Arial, sans-serif; font-size: 14px;">
              <option>Select Size</option>
              <option>UK 6</option>
              <option>UK 7</option>
              <option>UK 8</option>
              <option>UK 9</option>
              <option>UK 10</option>
              <option>UK 11</option>
              <option>UK 12</option>
            </select>
          </td>
        </tr>
        <tr>
          <td class="label">Quantity</td>
          <td class="value">
            <input type="number" min="1" max="10" value="<%= pQty %>" id="quantity">
          </td>
        </tr>
      </table>

      <!-- Total Price -->
      <div class="total-price">
        <span>Total Price:</span>
        <span class="amount" id="totalPrice"></span>
      </div>
      <div class="action-buttons">
        <a href="payment.jsp" class="btn-action btn-checkout">
          BUY NOW
        </a>
      </div>

    </div>
  </div>
<% } else { %>
  <p style="padding:40px; font-weight:700;">
    Item not found. Please log in and add an item from the shop.
    <a href="loginhome.html">Back to shop</a>
  </p>
<% } %>

  <!-- More items: every product EXCEPT the one already shown above -->
<%
  String[][] shop = {
    // ---- Adidas section (same as adidas.jsp) ----
    {"Adidas Classic", "2999", "image/adidas.jpg"},
    {"Adidas Run",     "1599", "image/adidas1.jpg"},
    {"Adidas Street",  "950",  "image/adidas2.jpg"},
    {"Adidas Sport",   "1999", "image/adidas3.jpg"},
    {"Adidas Sports ", "6666", "image/adidas5.jpg"},
    {"Adidas Jumping", "4321", "image/adidas6.jpg"},
    {"Adidas Samba",   "4455", "image/adidas7.jpg"},
    {"Adidas Gazelle", "5999", "image/adidas8.jpg"},
    // ---- Men section (same as men.html) ----
    {"Men Classic", "2999", "image1/tshirt7.jpg"},
    {"Men Run",     "1599", "image1/tshirt6.jpg"},
    {"Men Street",  "1999", "image1/tshirt5.jpg"},
    {"Men Sport",   "3499", "image1/tshirt4.jpg"},
    {"Men Sport",   "3499", "image1/tshirt.jpg"},
    {"Men Sport",   "3499", "image1/tshirt1.jpg"},
    {"Men Sport",   "3499", "image1/tshirt2.jpg"},
    {"Men Sport",   "3499", "image1/tshirt3.jpg"},
    {"Men Sport",   "3499", "image1/tshirt8.jpg"},
    {"Men Sport",   "3499", "image1/tshirt9.jpg"},
    {"Men Sport",   "3499", "image1/tshirt10.jpg"},
    {"Men Sport",   "3499", "image1/tshirt11.jpg"},
    {"Men Sport",   "3499", "image1/rcb.jpg"},
    {"Men Sport",   "3499", "image1/rcb1.jpg"}
  };
%>
  <div class="gallery">
<%
  for (int gi = 0; gi < shop.length; gi++) {
    // skip the photo that is already displayed in the summary above
    if (found && shop[gi][2].equals(pImage)) continue;
%>
    <div class="gallery-item">
      <a target="_blank" href="<%= shop[gi][2] %>">
        <img src="<%= shop[gi][2] %>" alt="<%= shop[gi][0] %>">
      </a>
      <div class="desc"><%= shop[gi][0] %></div>
      <div class="desc">Price - <%= shop[gi][1] %> Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="<%= shop[gi][0] %>">
          <input type="hidden" name="price" value="<%= shop[gi][1] %>">
          <input type="hidden" name="image" value="<%= shop[gi][2] %>">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <form action="payment.jsp" method="post">
          <input type="hidden" name="name"  value="<%= shop[gi][0] %>">
          <input type="hidden" name="price" value="<%= shop[gi][1] %>">
          <input type="hidden" name="image" value="<%= shop[gi][2] %>">
          <button type="submit" class="btn-item btn-buy">Buy</button>
        </form>
      </div>
    </div>
<%
  }
%>
  </div>

<% if (found) { %>
  <script>
    var qtyInput  = document.getElementById('quantity');
    var totalEl   = document.getElementById('totalPrice');
    var unitPrice = Number(document.getElementById('unitPrice').getAttribute('data-price'));
    var deliveryEl = document.getElementById('deliveryCharge');
    var deliveryFee = Number(deliveryEl.getAttribute('data-delivery'));
    var currency = 'Rs. ';

    function getQty() {
      var qty = parseInt(qtyInput.value, 10);
      if (isNaN(qty) || qty < 1) qty = 1;
      if (qty > 10) qty = 10;
      return qty;
    }

    function updateTotal() {
      var qty = getQty();
      // delivery charge applies when quantity is between 1 and 10
      var delivery = (qty >= 1 && qty <= 10) ? deliveryFee : 0;
      deliveryEl.textContent = currency + delivery.toLocaleString('en-US');
      totalEl.textContent = currency + (unitPrice * qty + delivery).toLocaleString('en-US');
    }

    // update total while typing or clicking the arrows
    qtyInput.addEventListener('input', updateTotal);

    // when the user leaves the box, fix invalid values (empty, 0, above 10)
    qtyInput.addEventListener('change', function () {
      qtyInput.value = getQty();
      updateTotal();
    });

    updateTotal();
  </script>
<% } %>

</body>
</html>