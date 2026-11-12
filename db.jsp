<title>db</title><%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<% 
Connection con=null;
Statement stmt=null;
ResultSet rst=null;
try{
Class.forName("com.mysql.jdbc.Driver");
con=DriverManager.getConnection("jdbc:mysql://localhost:3308/newdb","root","root");
stmt=con.createStatement();

//out.print("Success");
}catch(Exception ex){
out.print(ex);
} 
%>
