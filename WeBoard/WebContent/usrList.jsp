<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="usr.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="usr" class="usr.Usr" scope="page"/>
<jsp:setProperty property="usrId" name="usr"/>
<jsp:setProperty property="usrPasswd" name="usr"/>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="boot/css/bootstrap.css">
<%@include file ="icNav.jsp" %>
<title>우리 게시판</title>
<script type="text/javascript" src="script.js"></script>
<style type="text/css">
	a, a:hover {
		color: #000;
	}
</style>
<meta charset="UTF-8">
</head>
<body>
<%
	if(session.getAttribute("usrId")!=null) {
		usrId = (String) session.getAttribute("usrId");
	}
	if(usrId==null || !usrId.equals("admin")) {
		session.setAttribute("usrId", usr.getUsrId());
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('관리자 계정으로 로그인 후 확인 가능합니다.')");
		script.println("location.href='index.jsp'");
		script.println("</script>");
	} else {
%>
<%! 
	    UsrDAO usrDAO = UsrDAO.getInstance();
		int pageSize = 10;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<%
	    String pageNum = request.getParameter("pageNum");
	    if (pageNum == null) {
	        pageNum = "1";
	    }
	    
	    String option = request.getParameter("option");
		String searchWord = request.getParameter("searchWord");
		
	    int currentPage = Integer.parseInt(pageNum);  // 1  // 2
	    int startRow = (currentPage - 1) * pageSize + 1;  // 1  // 11
	    int endRow = currentPage * pageSize;  //10  //20
	    int totalUsr = 0;
	    int number = 0;
	    List<Usr> usrList = null;
	    
	    if (option!=null && searchWord!=null){
	    	totalUsr = usrDAO.totalSearch(option, searchWord, startRow, endRow);
			if (totalUsr > 0) {
				usrList = usrDAO.searchUsr(option, searchWord, startRow, endRow);
		    }
		}
		else {
			totalUsr = usrDAO.getTotalUsr();
		    if (totalUsr > 0) {
		    	usrList = usrDAO.getUsrs(startRow, endRow);
		    }
		}
		number = totalUsr - (currentPage - 1) * pageSize;
%>
	<div class="container mt-5">
		<form method="post" action="usrList.jsp">
			<div class="input-group mb-3">
			  <select class="custom-select" name="option" style="width: 10%">
			    <option value="usrId" selected>아이디</option>
			    <option value="usrEmail">이메일</option>
			  </select>
			  <input type="text" class="form-control" name="searchWord" style="width: 70%">
			  <div class="input-group-append">
			    <input class="btn btn-outline-secondary" type="submit" value="검색하기">
			  </div>
			</div>
		</form>
		<table class="table table-stripded" style="text-align: center; border: 1px solid #ddd">
			<thead>
				<tr>
					<th style="width: 20%; text-align: center;">아이디</th>
					<th style="width: 30%; text-align: center;">이메일</th>
					<th style="width: 20%; text-align: center;">상태</th>
					<th style="width: 30%; text-align: center;">가입/탈퇴일</th>
				</tr>
			</thead>
			<tbody>
<%		if (totalUsr == 0) { %>
				<tr>
				    <td colspan="6">가입 회원이 없습니다.</td>
				</tr>
<%		} else {
			for(int i=0; i<usrList.size(); i++) {
				String del = null;
				if (usrList.get(i).getUsrDelete()==0){
					del = "사용 회원";
				} else {
					del = "탈퇴 회원";
				}	%>
				<tr>
					<td><%=usrList.get(i).getUsrId()%></td>
					<td><a class="dropdown-item" href="mailto:<%=usrList.get(i).getUsrEmail()%>"><%=usrList.get(i).getUsrEmail()%></a></td>
					<td><%=del%></td>
					<td><%=sdf.format(usrList.get(i).getDelDate())%></td>
				</tr>
<%			}
		}	%>				
			</tbody>
		</table>
		<nav aria-label="Page navigation example">
			<ul class="pagination justify-content-center">
<%	if (totalUsr > 0) {
        int pageCount = totalUsr / pageSize + (totalUsr % pageSize == 0 ? 0 : 1);
		int startPage =1;
		
		if(currentPage % 10 != 0)
           startPage = (int)(currentPage/10)*10 + 1;
		else
           startPage = ((int)(currentPage/10)-1)*10 + 1;

		int pageBlock = 10;
        int endPage = startPage + pageBlock - 1;
        if (endPage > pageCount) endPage = pageCount;
        
        if (startPage > 10) { %>
				<li class="page-item">
					<a class="page-link text-dark" href="bbsList.jsp?pageNum=<%= startPage - 10 %>">&laquo;</a>
			    </li>
<%      } else {	%>
		    	<li class="page-item disabled">
					<a class="page-link text-dark" href="#" tabindex="-1" aria-disabled="true">&laquo;</a>
			    </li>
<%		}
	    for (int i = startPage ; i <= endPage ; i++) {  
			String active = "";
	    	if (pageNum.equals(Integer.toString(i))){
	    		active = "text-light bg-dark";
	    	} else {
        		active = "text-dark";
        	}	%>
				<li class="page-item"><a class="page-link <%=active%>" href="bbsList.jsp?pageNum=<%= i %>"><%= i %></a></li>
<%      } 
    	if (endPage < pageCount) {  %>
				<li class="page-item">
					<a class="page-link text-dark" href="bbsList.jsp?pageNum=<%= startPage + 10 %>">&raquo;</a>
			    </li>
		
<%		} else {	%>
				<li class="page-item disabled">
					<a class="page-link text-dark" href="#"  tabindex="-1" aria-disabled="true">&raquo;</a>
			    </li>
<%		}	 
	}		%>
			</ul>
		</nav>
		<a href="usrDelFinalPro.jsp" class="btn btn-dark float-right">30일 전 탈퇴 회원 정보 삭제</a>
	</div>
<%	}	%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="boot/js/bootstrap.js"></script>
</body>
</html>
