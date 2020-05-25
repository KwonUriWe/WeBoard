<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="usr.UsrDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="usr" class="usr.Usr" scope="page"/>
<jsp:setProperty property="usrId" name="usr"/>
<jsp:setProperty property="usrPasswd" name="usr"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>우리 게시판</title>
</head>
<body>
<%
	String usrId = null;
	if(session.getAttribute("usrId")!=null) {
		usrId = (String) session.getAttribute("usrId");
	}
	
	UsrDAO usrDAO = UsrDAO.getInstance();
	int result = usrDAO.login(usr.getUsrId(), usr.getUsrPasswd());
	
		if (result==1){
		session.setAttribute("usrId", usr.getUsrId());
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href='index.jsp'");
		script.println("</script>");
	}
		if (result==2){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('탈퇴 요청된 계정입니다.')");
		script.println("history.back()");
		script.println("</script>");
	}
	else if (result==0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('아이디 혹은 비밀번호가 틀렸습니다.')");
		script.println("history.back()");
		script.println("</script>");
	}
	else if (result==-1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생하였습니다.')");
		script.println("history.back()");
		script.println("</script>");
	}
%>
</body>
</html>




















