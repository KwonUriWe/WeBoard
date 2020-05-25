<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	UsrDAO usrDAO = UsrDAO.getInstance();

	String usrId = request.getParameter("usrId");
	String usrPasswd = request.getParameter("usrPasswd");
	String where = request.getParameter("where");

	int check = usrDAO.checkPwd(usrId, usrPasswd);
	
	if (check==-1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류가 발생하였습니다.')");
		script.println("history.back()");
		script.println("</script>");
	}
	else if (check==0){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('아이디 혹은 비밀번호 오류입니다.')");
		script.println("history.back()");
		script.println("</script>");
	}
	else if (check==1){
		if (where.equals("del")){	// 탈퇴버튼 거쳐옴
			int result = usrDAO.delete(usrId);
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('탈퇴요청이 접수되었습니다.')");
			script.println("location.href='usrLogoutPro.jsp'");
			script.println("</script>");
		} else if (where.equals("up")){	//수정버튼 거쳐옴
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href='usrUpdateForm.jsp'");
			script.println("</script>");
		}
	}
%>
</body>
</html>
