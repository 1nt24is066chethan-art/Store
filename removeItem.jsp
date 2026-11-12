<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<%@ include file="db.jsp" %>
<%
  Object cid = session.getAttribute("cartId");
  if (session.getAttribute("uname") == null || cid == null) {
    response.sendRedirect("login.jsp"); return;
  }

  String id = request.getParameter("id");

  if (id != null) {
    try {
      PreparedStatement del = con.prepareStatement(
        "DELETE FROM cart_items WHERE item_id=? AND cart_id=?");
      del.setInt(1, Integer.parseInt(id));
      del.setInt(2, ((Integer) cid).intValue());
      del.executeUpdate();
    } catch (NumberFormatException e) {
      // bad id: ignore it and just go back to the cart
    }
  }
  response.sendRedirect("mycart.jsp");
%>