<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="usr.UsrDAO" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="usr" class="usr.Usr" scope="page"/>
<jsp:setProperty property="*" name="usr"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>우리 게시판</title>
</head>
<body>
<%
		
	String checkedPwd = request.getParameter("checkedPwd");
	if(usr.getUsrId()==null || usr.getUsrPasswd()==null || checkedPwd==null || usr.getUsrEmail()==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력되지 않은 항목이 있습니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else if(!usr.getUsrPasswd().equals(checkedPwd)){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('확인한 비밀번호가 일치하지 않습니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else {
		UsrDAO usrDAO = UsrDAO.getInstance();
		int result = usrDAO.join(usr.getUsrId(), usr.getUsrPasswd(), usr.getUsrEmail());
		
		if (result==0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('사용 불가한 아이디 입니다.')");
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
		else {
			session.setAttribute("usrId", usr.getUsrId());
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href='usrMain.jsp'");
			script.println("</script>");
		}
	}
%>
</body>
</html>




















