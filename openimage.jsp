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
      <a href="profile.jsp" class="btn btn-login">Profile</a>
    </div>
  </nav>

  <div class="gallery">

    <div class="gallery-item">
      <a target="_blank" href="img_5terre.jpg">
        <img src="image/adidas.jpg" alt="Adidas">
      </a>
      <div class="desc">Adidas</div>
	  <div class="desc">Price - 2999$</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart" onclick="window.location.href='cart.jsp'">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

    <div class="gallery-item">
      <a target="_blank" href="img_forest.jpg">
        <img src="image/puma.jpg" alt="Puma">
      </a>
      <div class="desc">Puma</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

    <div class="gallery-item">
      <a target="_blank" href="img_lights.jpg">
        <img src="image/sg.jpg" alt="SG">
      </a>
      <div class="desc">SG</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

    <div class="gallery-item">
      <a target="_blank" href="img_mountains.jpg">
        <img src="image/vk.jpg" alt="VK-18">
      </a>
      <div class="desc">VK-18</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

    <div class="gallery-item">
      <a target="_blank" href="img_mountains.jpg">
        <img src="image/vk1.jpg" alt="VK-18">
      </a>
      <div class="desc">VK-18</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

    <div class="gallery-item">
      <a target="_blank" href="img_mountains.jpg">
        <img src="image/puma1.jpg" alt="Puma">
      </a>
      <div class="desc">Puma</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

    <div class="gallery-item">
      <a target="_blank" href="img_mountains.jpg">
        <img src="image/nike1.jpg" alt="Nike">
      </a>
      <div class="desc">Nike</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

    <div class="gallery-item">
      <a target="_blank" href="img_mountains.jpg">
        <img src="image/adidas1.jpg" alt="Adidas">
      </a>
      <div class="desc">Adidas</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

    <div class="gallery-item">
      <a target="_blank" href="img_mountains.jpg">
        <img src="image/nike2.jpg" alt="Nike">
      </a>
      <div class="desc">Nike</div>
      <div class="buttons">
        <button class="btn-item btn-add-cart">Add to Cart</button>
        <button class="btn-item btn-buy">Buy</button>
      </div>
    </div>

  </div>

</body>
</html>
