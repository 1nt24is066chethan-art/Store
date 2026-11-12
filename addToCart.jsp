<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="db.jsp" %>
<%
  if (session.getAttribute("uname") == null) { response.sendRedirect("login.jsp"); return; }
%>
<%@ include file="makecart.jsp" %>
<%
  Object cid = session.getAttribute("cartId");
  String name  = request.getParameter("name");
  String price = request.getParameter("price");
  String image = request.getParameter("image");

  if (cid == null || name == null || price == null) {
    response.sendRedirect("loginhome.html"); return;
  }
  int cartId = ((Integer) cid).intValue();
  int itemId = 0;

  PreparedStatement chk = con.prepareStatement(
    "SELECT item_id FROM cart_items WHERE cart_id=? AND product_name=? AND image=?");
  chk.setInt(1, cartId);
  chk.setString(2, name);
  chk.setString(3, image);
  ResultSet cr = chk.executeQuery();

  if (cr.next()) {
    itemId = cr.getInt(1);
    PreparedStatement up = con.prepareStatement(
      "UPDATE cart_items SET quantity = quantity + 1 WHERE item_id=?");
    up.setInt(1, itemId);
    up.executeUpdate();
  } else {
    PreparedStatement ins = con.prepareStatement(
      "INSERT INTO cart_items (cart_id, product_name, price, image) VALUES (?,?,?,?)",
      Statement.RETURN_GENERATED_KEYS);
    ins.setInt(1, cartId);
    ins.setString(2, name);
    ins.setBigDecimal(3, new java.math.BigDecimal(price));
    ins.setString(4, image);
    ins.executeUpdate();
    ResultSet gk = ins.getGeneratedKeys();
    if (gk.next()) itemId = gk.getInt(1);
  }
  response.sendRedirect("cart.jsp?id=" + itemId);
%>