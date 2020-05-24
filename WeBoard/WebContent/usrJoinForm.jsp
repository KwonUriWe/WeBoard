<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="usr.UsrDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
	if(session.getAttribute("usrId")!=null) {
		usrId = (String) session.getAttribute("usrId");
	}
	if(usrId!=null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 로그인 되어 있습니다.')");
		script.println("location.href='index.jsp'");
		script.println("</script>");
	}	
%>
	<div class="container mt-5">
		<div class="col-lg-5" style="float:none; margin:0 auto">
			<div class="jumbotron bg-transparent" >
				<form class="form-horizontal" method="post" action="usrJoinPro.jsp">
					<h3 style="text-align:center;">회원가입 화면</h3>
					<br>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디" name="usrId" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="usrPasswd" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" name="checkedPwd" maxlength="20" placeholder="비밀번호 확인">
					</div>
					<div class="form-group">
						<input type="email" class="form-control" placeholder="이메일" name="usrEmail" maxlength="20">
					</div>
					<input type="submit" class="btn btn-dark form-control" value="회원가입">
				</form>
			</div> 
			<div class="alert alert-secondary" role="alert">
			  	아이디는 변경할 수 없습니다.
			  	<br>
			  	신중하게 선택해 주세요.
			</div>
		</div>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="boot/js/bootstrap.js"></script>
</body>
</html>
