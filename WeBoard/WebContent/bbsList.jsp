<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="bbs.BbsDAO" %>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<% request.setCharacterEncoding("utf-8"); %>
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
</head>
<body>
<%!
    BbsDAO bbsDAO = BbsDAO.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<%
	if (session.getAttribute("usrId")!=null){
		usrId = (String) session.getAttribute("usrId");
	}

	int pageSize = 10; 
	if (request.getParameter("pageSize")!=null){
		pageSize = Integer.parseInt(request.getParameter("pageSize"));
	}

	String option = request.getParameter("option");
	String searchWord = request.getParameter("searchWord");
	
	String pageNum = (String)request.getParameter("pageNum");
    if (pageNum == null) {
        pageNum = "1";
    }

    int currentPage = Integer.parseInt(pageNum);  // 1  // 2
    int startRow = (currentPage - 1) * pageSize + 1;  // 1  // 11
    int endRow = currentPage * pageSize;  //s10  //20
    int totalBbs = 0;
    int totalNotice = 0;
    int number = 0;
    List<bbs.Bbs> bbsList = null; 
    List<bbs.Bbs> noticeList = null;
    
	if (option!=null && searchWord!=null){
		totalBbs = bbsDAO.totalSearch(option, searchWord, startRow, endRow, 0);
		if (totalBbs > 0) {
	    	bbsList = bbsDAO.searchBbs(option, searchWord, startRow, endRow, 0);
	    }
		totalNotice = bbsDAO.totalSearch(option, searchWord, startRow, endRow, 1);
		if (totalNotice > 0){
	    	noticeList = bbsDAO.searchBbs(option, searchWord, 1, 10, 1);
		}
	}
	else {
	    totalBbs = bbsDAO.totalBbs(0);  //16
	    if (totalBbs > 0) {
	    	bbsList = bbsDAO.getBbsList(startRow, endRow, 0);
	    }
	    totalNotice = bbsDAO.totalBbs(1);
	    if (totalNotice > 0) {
			noticeList = bbsDAO.getBbsList(1, 10, 1);
	    }
	    
	}
    number = totalBbs-(currentPage-1)*pageSize;
%>
	<div class="container mt-5">
		<div class="btn-group dropleft mb-2">
			<button type="button" class="btn btn-sm btn-outline-secondary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			    <span class="sr-only"></span>
			  </button>
			<div class="dropdown-menu">
				<a class="dropdown-item" href="bbsList.jsp?pageSize=5">5</a>
				<a class="dropdown-item" href="bbsList.jsp?pageSize=10">10</a>
				<a class="dropdown-item" href="bbsList.jsp?pageSize=20">20</a>
				<a class="dropdown-item" href="bbsList.jsp?pageSize=40">40</a>
			</div>
			<button class="btn btn-outline-secondary btn-sm" type="button">
				<%=pageSize%>씩 보기
			</button>
		</div>
		<form method="post" action="bbsList.jsp">
			<div class="input-group mb-3">
			  <select class="custom-select" name="option" style="width: 10%">
			    <option value="title_content" selected>제목+내용</option>
			    <option value="bbsTitle">제목</option>
			    <option value="bbsContent">내용</option>
			    <option value="usrId">작성자</option>
			  </select>
			  <input type="text" class="form-control" name="searchWord" placeholder="특수문자 X, 한 단어만 입력 가능" style="width: 70%">
			  <div class="input-group-append">
			    <input class="btn btn-outline-secondary" type="submit" value="검색하기">
			  </div>
			</div>
		</form>
		<table class="table" style="text-align: center;">
			<thead>
				<tr>
					<th style="width: 15%; text-align: center;">번호</th>
					<th style="width: 30%; text-align: center;">제목</th>
					<th style="width: 20%; text-align: center;">작성자</th>
					<th style="width: 20%; text-align: center;">작성일</th>
					<th style="width: 15%; text-align: center;">조회수</th>
				</tr>
			</thead>
			<tbody>
<%	if (totalNotice == 0) {	%>
				<tr>
				    <td colspan="5">공지사항이 없습니다.</td>
				</tr>
<%	} else {
		for (int i = 0 ; i < noticeList.size() ; i++) {
		bbs.Bbs bbs = noticeList.get(i);	%>
				<tr>
					<td><strong>공지</strong></td>
					<td class="text-left">
	  					<img src="images/level.png" width="0" height="16">
						<a href="bbsViewForm.jsp?bbsId=<%=bbs.getBbsId()%>&pageNum=<%=currentPage%>"><strong><%=bbs.getBbsTitle()%></strong></a> 
					</td>
					<td>
						<div class="dropdown">
							<a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<strong>관리자</strong>
							</a>
							<div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
								<a class="dropdown-item" href="bbsList.jsp?option=usrId&searchWord=admin">게시글 보기</a>
							    <a class="dropdown-item" href="mailto:<%=bbsDAO.writerEmail("admin")%>">이메일 보내기</a>
							</div>
						</div>
					</td>
					<td><strong><%=sdf.format(bbs.getBbsDate())%></strong></td>
					<td><strong><%=bbs.getReadCount()%></strong></td>
				</tr>
<%		}	
	}	%>
			</tbody>
			<tbody>
<% if (totalBbs == 0) { %>
				<tr>
				    <td colspan="5">글이 없습니다.</td>
				</tr>
				
<% } else {
		for (int i = 0 ; i < bbsList.size() ; i++) {
			bbs.Bbs bbs = bbsList.get(i);	%>
				<tr>
					<td><%=number--%></td>
					<td class="text-left">
<%			int wid=0; 
			if(bbs.getRe_level()>0){
			   wid=10*(bbs.getRe_level());	%>
						<img src="images/level.png" width="<%=wid%>" height="16">
						<img src="images/reply1.png">
<%  		} else {	%>
	  					<img src="images/level.png" width="<%=wid%>" height="16">
<%  		}	%>
           
							<a href="bbsViewForm.jsp?bbsId=<%=bbs.getBbsId()%>&pageNum=<%=currentPage%>"><%=bbs.getBbsTitle()%></a> 
<%			if (bbs.getReadCount()>=10) {	%>
         				<img src="images/star1.png" border="0"  height="16">
<%			}	%> 
					</td>
					<td>
						<div class="dropdown">
							<a class="dropdown-toggle" href="#" role="button" id="dropdownMenuLink" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								<%=bbs.getUsrId()%>
							</a>
							<div class="dropdown-menu" aria-labelledby="dropdownMenuLink">
								<a 	class="dropdown-item" 
									href="bbsList.jsp?option=usrId&searchWord=<%=bbs.getUsrId()%>">
									게시글 보기
								</a>
							    <a  class="dropdown-item" 
							        href="mailto:<%=bbsDAO.writerEmail(usrId)%>">
							                  이메일 보내기
							    </a>
							</div>
						</div>
					</td>
					<td><%=sdf.format(bbs.getBbsDate())%></td>
					<td><%=bbs.getReadCount()%></td>
				</tr>
<%		}	
	}	%>
			</tbody>
		</table>
		<nav aria-label="Page navigation example">
		  <ul class="pagination justify-content-center">
<%	if (totalBbs > 0) {
        int pageCount = totalBbs / pageSize + (totalBbs % pageSize == 0 ? 0 : 1);
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
				<a class="page-link text-dark" href="bbsList.jsp?pageNum=<%= startPage - 10 %>&pageSize=<%=pageSize%>">&laquo;</a>
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
			<li class="page-item"><a class="page-link <%=active%>" href="bbsList.jsp?pageNum=<%= i %>&pageSize=<%=pageSize%>"><%= i %></a></li>
<%      } 
        if (endPage < pageCount) {  %>
			<li class="page-item">
				<a class="page-link text-dark" href="bbsList.jsp?pageNum=<%= startPage + 10 %>&pageSize=<%=pageSize%>">&raquo;</a>
		    </li>
			
<%		} else {	%>
			<li class="page-item disabled">
				<a class="page-link text-dark" href="#"  tabindex="-1" aria-disabled="true">&raquo;</a>
		    </li>
<%		}	 
	}		%>
		  </ul>
		</nav>
		<a href="bbsWriteForm.jsp" class="btn btn-dark float-right">글쓰기</a>
	</div>
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
</body>
</html>