<%@ page contentType="text/html; charset=iso-8859-1" language="java" import="java.sql.*" errorPage="" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Untitled Document</title>
<style type="text/css">
/* From Uiverse.io by cssbuttons-io */ 
.button {
 --glow-color: rgb(217, 176, 255);
 --glow-spread-color: rgba(191, 123, 255, 0.781);
 --enhanced-glow-color: rgb(231, 206, 255);
 --btn-color: rgb(100, 61, 136);
 border: .25em solid var(--glow-color);
 padding: 1em 3em;
 color: var(--glow-color);
 font-size: 15px;
 font-weight: bold;
 background-color: var(--btn-color);
 border-radius: 1em;
 outline: none;
 box-shadow: 0 0 1em .25em var(--glow-color),
        0 0 4em 1em var(--glow-spread-color),
        inset 0 0 .75em .25em var(--glow-color);
 text-shadow: 0 0 .5em var(--glow-color);
 position: relative;
 transition: all 0.3s;
}

.button::after {
 pointer-events: none;
 content: "";
 position: absolute;
 top: 120%;
 left: 0;
 height: 100%;
 width: 100%;
 background-color: var(--glow-spread-color);
 filter: blur(2em);
 opacity: .7;
 transform: perspective(1.5em) rotateX(35deg) scale(1, .6);
}

.button:hover {
 color: var(--btn-color);
 background-color: var(--glow-color);
 box-shadow: 0 0 1em .25em var(--glow-color),
        0 0 4em 2em var(--glow-spread-color),
        inset 0 0 .75em .25em var(--glow-color);
}

button:active {
 box-shadow: 0 0 0.6em .25em var(--glow-color),
        0 0 2.5em 2em var(--glow-spread-color),
        inset 0 0 .5em .25em var(--glow-color);
}
<!--
.style1 {font-size: 36px}
.style3 {color: #000000}
-->
</style>
</head>

<body>
<%@ include file="db.jsp" %>
<div align="center" class="style1">Login Page</div>
<form id="form1" name="form1" method="post" action="">
  <table width="335" height="290" border="1" align="center">
    <tr>
      <td width="158" bgcolor="#FF0000"><span class="style3">User Name </span></td>
      <td width="161" bgcolor="#000000"><input name="untxt" type="text" /></td>
    </tr>
    <tr>
      <td bgcolor="#FF0000"><span class="style3">Password</span></td>
      <td bgcolor="#000000"><input name="pwtxt" type="password" /></td>
    </tr>
    <tr>
      <td bgcolor="#FF0000">&nbsp;</td>
      <td bgcolor="#000000" ><input name="Submit" class="button" type="submit" value="Submit" /></td>
    </tr>
  </table>
</form>
<% 
if(request.getParameter("Submit")!=null){
String un=request.getParameter("untxt");
String pw=request.getParameter("pwtxt");
rst=stmt.executeQuery("select * from login where name='"+un+"' and password='"+pw+"'");
if(rst.next()){
 %>
 <script>
alert("login successful");
window.open("home.html","_self");
</script>
<%
}else{
%>
<script>
alert("login Failed");
</script>
<%
}


}
%>
</body>
</html>
