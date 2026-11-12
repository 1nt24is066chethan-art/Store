<%
{
  String mcName = (String) session.getAttribute("uname");
  String mcPass = (String) session.getAttribute("upass");
  if (mcName != null && mcPass != null) {
    PreparedStatement mcUser = con.prepareStatement(
      "SELECT user_id FROM signin WHERE name=? AND password=?");
    mcUser.setString(1, mcName);
    mcUser.setString(2, mcPass);
    ResultSet mcR = mcUser.executeQuery();
    if (mcR.next()) {
      int mcUid = mcR.getInt(1);

      PreparedStatement mcMk = con.prepareStatement(
        "INSERT IGNORE INTO carts (user_id) VALUES (?)");
      mcMk.setInt(1, mcUid);
      mcMk.executeUpdate();

      PreparedStatement mcGet = con.prepareStatement(
        "SELECT cart_id FROM carts WHERE user_id=?");
      mcGet.setInt(1, mcUid);
      ResultSet mcC = mcGet.executeQuery();
      if (mcC.next()) session.setAttribute("cartId", mcC.getInt(1));
    }
  }
}
%>