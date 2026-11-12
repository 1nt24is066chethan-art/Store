<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Adidas </title>
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

  .btn-signup{
    color:var(--accent-ink);
    background:var(--accent);
    border-color:var(--accent);
  }
  .btn-signup:hover{
    background:var(--ink);
    border-color:var(--ink);
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

  .navbar a.active {
    color: var(--accent);
    border-bottom: 3px solid var(--accent);
    padding-bottom: 10px;
  }

  /* ===== GALLERY ===== */
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

  /* makes the Add to Cart form fit in the button row */
  .gallery-item .buttons form { flex: 1; display: flex; }
  .gallery-item .buttons form .btn-item { width: 100%; }

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

  /* stack to 2 columns on tablets, 1 on phones */
  @media (max-width: 900px){
    .gallery{ grid-template-columns: repeat(2, 1fr); }
    .gallery-item img{ height: 32vh; }
  }
  @media (max-width: 480px){
    .gallery{ grid-template-columns: 1fr; padding: 12px; }
    .gallery-item img{ height: 45vh; }
    .gallery-item .buttons { flex-direction: column; }
  }
</style>
</head>

<body>
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

  <div class="gallery">

    <!-- SHOE 1 -->
    <div class="gallery-item">
      <a target="_blank" href="image/adidas.jpg">
        <img src="image/adidas.jpg" alt="Adidas Classic">
      </a>
      <div class="desc">Adidas Classic</div>
      <div class="desc">Price - 2999 Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="Adidas Classic">
          <input type="hidden" name="price" value="2999">
          <input type="hidden" name="image" value="image/adidas.jpg">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <button type="button" class="btn-item btn-buy" onclick="window.location.href='payment.jsp'">Buy</button>
      </div>
    </div>

    <!-- SHOE 2 -->
    <div class="gallery-item">
      <a target="_blank" href="image/adidas1.jpg">
        <img src="image/adidas1.jpg" alt="Adidas Run">
      </a>
      <div class="desc">Adidas Run</div>
      <div class="desc">Price - 1599 Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="Adidas Run">
          <input type="hidden" name="price" value="1599">
          <input type="hidden" name="image" value="image/adidas1.jpg">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <button type="button" class="btn-item btn-buy" onclick="window.location.href='payment.jsp'">Buy</button>
      </div>
    </div>

    <!-- SHOE 3 -->
    <div class="gallery-item">
      <a target="_blank" href="image/adidas2.jpg">
        <img src="image/adidas2.jpg" alt="Adidas Street">
      </a>
      <div class="desc">Adidas Street</div>
      <div class="desc">Price - 950 Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="Adidas Street">
          <input type="hidden" name="price" value="950">
          <input type="hidden" name="image" value="image/adidas2.jpg">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <button type="button" class="btn-item btn-buy" onclick="window.location.href='payment.jsp'">Buy</button>
      </div>
    </div>

    <!-- SHOE 4 -->
    <div class="gallery-item">
      <a target="_blank" href="image/adidas3.jpg">
        <img src="image/adidas3.jpg" alt="Adidas Sport">
      </a>
      <div class="desc">Adidas Sport</div>
      <div class="desc">Price - 1999 Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="Adidas Sport">
          <input type="hidden" name="price" value="1999">
          <input type="hidden" name="image" value="image/adidas3.jpg">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <button type="button" class="btn-item btn-buy" onclick="window.location.href='payment.jsp'">Buy</button>
      </div>
    </div>
	
	 <div class="gallery-item">
      <a target="_blank" href="image/adidas5.jpg">
        <img src="image/adidas5.jpg" alt="Adidas Sport">
      </a>
      <div class="desc">Adidas Sports </div>
      <div class="desc">Price - 6666 Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="Adidas Sports ">
          <input type="hidden" name="price" value="6666">
          <input type="hidden" name="image" value="image/adidas5.jpg">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <button type="button" class="btn-item btn-buy" onclick="window.location.href='payment.jsp'">Buy</button>
      </div>
    </div>
	
	 <div class="gallery-item">
      <a target="_blank" href="image/adidas6.jpg">
        <img src="image/adidas6.jpg" alt="Adidas Sport">
      </a>
      <div class="desc">Adidas Jumping</div>
      <div class="desc">Price - 4321 Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="Adidas Jumping">
          <input type="hidden" name="price" value="4321">
          <input type="hidden" name="image" value="image/adidas6.jpg">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <button type="button" class="btn-item btn-buy" onclick="window.location.href='payment.jsp'">Buy</button>
      </div>
    </div>
	
	 <div class="gallery-item">
      <a target="_blank" href="image/adidas7.jpg">
        <img src="image/adidas7.jpg" alt="Adidas Sport">
      </a>
      <div class="desc">Adidas Samba</div>
      <div class="desc">Price - 4455 Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="Adidas Samba">
          <input type="hidden" name="price" value="4455">
          <input type="hidden" name="image" value="image/adidas7.jpg">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <button type="button" class="btn-item btn-buy" onclick="window.location.href='payment.jsp'">Buy</button>
      </div>
    </div>
	
	 <div class="gallery-item">
      <a target="_blank" href="image/adidas8.jpg">
        <img src="image/adidas8.jpg" alt="Adidas Sport">
      </a>
      <div class="desc">Adidas Gazelle</div>
      <div class="desc">Price - 5999 Rs</div>
      <div class="buttons">
        <form action="addToCart.jsp" method="post">
          <input type="hidden" name="name"  value="Adidas Gazelle">
          <input type="hidden" name="price" value="5999">
          <input type="hidden" name="image" value="image/adidas8.jpg">
          <button type="submit" class="btn-item btn-add-cart">Add to Cart</button>
        </form>
        <button type="button" class="btn-item btn-buy" onclick="buyNow(this)">Buy</button>
      </div>
    </div>

  </div>
    <form id="buyForm" action="payment.jsp" method="post" style="display:none;">
    <input type="hidden" name="name"  id="bName">
    <input type="hidden" name="price" id="bPrice">
    <input type="hidden" name="image" id="bImage">
  </form>

  <script>
    function buyNow(btn) {
      var src = btn.parentNode.querySelector('form');
      document.getElementById('bName').value  = src.querySelector('[name=name]').value;
      document.getElementById('bPrice').value = src.querySelector('[name=price]').value;
      document.getElementById('bImage').value = src.querySelector('[name=image]').value;
      document.getElementById('buyForm').submit();
    }
  </script>

</body>
</html>