<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="usr.*" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
%>
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
	Usr usr = new Usr();
	
	String usrPasswd = request.getParameter("usrPasswd");
	String checkedPwd = request.getParameter("checkedPwd");
	String usrName = request.getParameter("usrName");    
	String usrGender = request.getParameter("usrGender");  
	String usrEmail = request.getParameter("usrEmail");
	
	if(usrId==null || usrPasswd==null || checkedPwd==null || usrEmail==null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력되지 않은 항목이 있습니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else if(!usrPasswd.equals(checkedPwd)){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('확인한 비밀번호가 일치하지 않습니다.')");
		script.println("history.back()");
		script.println("</script>");
	} else {
		usr.setUsrId(usrId);
		usr.setUsrPasswd(usrPasswd);
		usr.setUsrEmail(usrEmail);
		int result = usrDAO.update(usr);
		
		if (result==-1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('계정정보 수정에 실패하였습니다.')");
		script.println("history.back()");
		script.println("</script>");
		}
		else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('계정정보가 수정되었습니다.')");
		script.println("location.href='index.jsp'");
		script.println("</script>");
		}
	}
%>
</body>
</html>