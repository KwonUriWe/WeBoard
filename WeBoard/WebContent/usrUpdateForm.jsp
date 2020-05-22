<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="usr.*" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
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
	else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 수정 가능합니다.')");
		script.println("location.href='usrMain.jsp'");
		script.println("</script>");
	}

	UsrDAO usrDAO = UsrDAO.getInstance();
	Usr usr = usrDAO.getUsr(usrId);

	if(usr.getUsrPasswd()==null || usr.getUsrName()==null || usr.getUsrGender()==null || usr.getUsrEmail()==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 수정 가능합니다.')");
		script.println("location.href='usrMain.jsp'");
		script.println("</script>");
	}
%>
	<div class="container mt-5">
		<div class="col-lg-4" style="float:none; margin:0 auto">
			<div class="jumbotron bg-transparent" >
				<form method="post" action="usrUpdatePro.jsp">
					<h3 style="text-align:center;"><%= usrId %>님의 정보</h3>
					<br>
					<div class="form-group">
						<input type="text" class="form-control" name="usrId" maxlength="20" value="<%= usrId %>" disabled>
					</div>
					<div class="form-group">
						<input type="password" class="form-control" name="usrPasswd" maxlength="20" value="<%= usr.getUsrPasswd() %>">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" name="checkedPwd" maxlength="20" placeholder="비밀번호 확인">
					</div>
					<div class="form-group">
						<input type="text" class="form-control" name="usrName" maxlength="20" value="<%= usr.getUsrName() %>">
					</div>
					<div class="form-group" style="text-align: center;">
						<div class="btn-group btn-group-toggle" data-toggle="buttons">
							<label class="btn btn-dark <% if(usr.getUsrGender().equals("여자")){%>active focus<%}%>">
								<input type="radio" name="usrGender" autocomplete="off" value="여자" <% if(usr.getUsrGender().equals("여자")){%>checked="checked"<%}%>>여자
							</label>
							<label class="btn btn-dark <% if(usr.getUsrGender().equals("남자")){%>active focus<%}%>">
								<input type="radio" name="usrGender" value="남자" <% if(usr.getUsrGender().equals("남자")){%>checked="checked"<%}%>>남자
							</label>
						</div>
					</div>
					<div class="form-group">
						<input type="email" class="form-control" name="usrEmail" maxlength="20" value="<%= usr.getUsrEmail() %>">
					</div>
					<input type="submit" class="btn btn-dark form-control" value="수정하기">
				</form>
			</div> 
		</div>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="boot/js/bootstrap.js"></script>
</body>
</html>




















