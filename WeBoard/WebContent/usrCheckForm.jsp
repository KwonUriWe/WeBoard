<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="usr.UsrDAO" %>
<%@page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="boot/css/bootstrap.css">
<%@include file ="icNav.jsp" %>
<title>우리 게시판</title>
</head>
<body>
<%
	UsrDAO usrDAO = UsrDAO.getInstance();
	
	if (session.getAttribute("usrId")!=null){
		usrId = (String) session.getAttribute("usrId");
	} 
	else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 이용 가능합니다.')");
		script.println("location.href='usrMain.jsp'");
		script.println("</script>");
	}
	
	String where = request.getParameter("where");
%>
	<div class="container mt-5">
		<div class="col-lg-4" style="float:none; margin:0 auto">
			<div class="jumbotron bg-transparent" >
				<form method="post" action="usrCheckPro.jsp">
					<h3 style="text-align:center;">비밀번호 확인</h3>
					<br>
					<div class="form-group">
						<input type="text" class="form-control" value=<%= usrId %> name="usrId" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="usrPasswd" maxlength="20">
					</div>
					<input type="submit" class="btn btn-dark form-control" value="확인하기">
					<input type="hidden" name="where" value="<%=where%>"> 
				</form>
			</div> 
		</div>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="boot/js/bootstrap.js"></script>
</body>
</html>