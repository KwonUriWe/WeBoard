<%@page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8");%>

<%
    String pageNum = (String)request.getAttribute("pageNum");
	int check = (int)request.getAttribute("check");

    if(check==1){	%>
	<meta http-equiv="Refresh" content="0;url=bbsList.jsp?pageNum=<%=pageNum%>" >
<% }else{
 		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류 발생. 관리자에게 문의하십시오.')");
		script.println("history.back()");
		script.println("</script>");
  }	%> 