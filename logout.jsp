<%@ page contentType="text/html; charset=iso-8859-1" language="java" errorPage="" %>
<%
  // ends the login session, then goes back to the first page
  session.invalidate();
  response.sendRedirect("home.html");
%>
