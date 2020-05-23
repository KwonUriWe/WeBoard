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
<jsp:setProperty property="usrName" name="usr"/>
<jsp:setProperty property="usrGender" name="usr"/>
<jsp:setProperty property="usrEmail" name="usr"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>우리 게시판</title>
</head>
<body>
<%
	String usrId = null;
	UsrDAO usrDAO = UsrDAO.getInstance();
	if(session.getAttribute("usrId")!=null) {
		usrId = (String) session.getAttribute("usrId");
	}
	if(usrId==null) {
		session.setAttribute("usrId", usr.getUsrId());
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('관리자 계정으로 로그인 후 확인 가능합니다.')");
		script.println("location.href='usrMain.jsp'");
		script.println("</script>");
	} 
	else if (usrId.equals("admin")) {
		int result = usrDAO.deleteFinal(usrId);

		if (result==-1){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생하였습니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('탈퇴한 회원의 정보를 최종 삭제하였습니다.')");
			script.println("location.href='usrList.jsp'");
			script.println("</script>");
		}
	} else {
		session.setAttribute("usrId", usr.getUsrId());
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('관리자 계정으로 로그인 후 확인 가능합니다.')");
		script.println("location.href='usrLoginForm.jsp'");
		script.println("</script>");
	}
%>
</body>
</html>