<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
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
	if (session.getAttribute("usrId")!=null){
		usrId = (String) session.getAttribute("usrId");
	}
%>
	<div class="container mt-5">
		<div class="jumbotron bg-transparent">
			<div class="container">
<%	if (usrId==null){	
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 이용 가능합니다.')");
		script.println("location.href='usrLoginForm.jsp'");
		script.println("</script>");
} else if (usrId.equals("admin")){	%>
				<h2>관리자용 계정관리</h2>
				<br>
				<a class="btn btn-success btn-pull mb-2" href="usrList.jsp" role="button" style="width: 100%;">회원 정보 관리</a>
				<a class="btn btn-success btn-pull" href="usrLogoutPro.jsp" role="button" style="width: 100%;">로그아웃</a>
<%	} else {	%>
				<h2><%= usrId %>님의 계정관리</h2>
				<br>
				<a class="btn btn-dark btn-pull mb-2" href="usrCheckForm.jsp?where=up" role="button" style="width: 100%;">회원 정보 수정</a>
				<a class="btn btn-dark btn-pull mb-2" href="usrCheckForm.jsp?where=del" role="button" style="width: 100%;">회원 탈퇴</a>
				<a class="btn btn-dark btn-pull" href="usrLogoutPro.jsp" role="button" style="width: 100%;">로그아웃</a>
<%	}	%>
			</div>
		</div>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="boot/js/bootstrap.js"></script>
</body>
</html>