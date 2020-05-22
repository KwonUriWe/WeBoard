<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String usrId = null;
	if (session.getAttribute("usrId")!=null){
		usrId = (String) session.getAttribute("usrId");
	}
%>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
	<div class="container-xl">
		<a class="navbar-brand font-weight-bolder" href="index.jsp" >우리 Board</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample07XL" aria-controls="navbarsExample07XL" aria-expanded="false" aria-label="Toggle navigation">
		<span class="navbar-toggler-icon"></span></button>
		<div class="collapse navbar-collapse" id="navbarsExample07XL">
			<ul class="navbar-nav mr-auto">
	        	<li class="nav-item active">
					<a class="nav-link" href="bbsList.jsp">게시판 <span class="sr-only">(current)</span></a>
				</li>
			</ul>
<%	if (usrId==null){	%> 
			<form class="form-inline my-2 my-md-0">
				<a class="btn btn-sm btn-outline-light mr-3" href="usrLoginForm.jsp">로그인</a>
				<a class="btn btn-sm btn-outline-light" href="usrJoinForm.jsp">회원가입</a>
			</form>
<%	} else if (usrId.equals("admin")){	%> 
			<form class="form-inline my-2 my-md-0">
				<a class="btn btn-sm btn-success mr-3" href="#">관리자</a>
				<a class="btn btn-sm btn-outline-light mr-3" href="usrMain.jsp">계정관리</a>
				<a class="btn btn-sm btn-outline-light" href="usrLogoutPro.jsp">로그아웃</a>
			</form>
<%	} else {	%> 
			<form class="form-inline my-2 my-md-0">
				<a class="btn btn-sm btn-light mr-3" href="#"><%= usrId %></a>
				<a class="btn btn-sm btn-outline-light mr-3" href="usrMain.jsp">계정관리</a>
				<a class="btn btn-sm btn-outline-light" href="usrLogoutPro.jsp">로그아웃</a>
			</form>
<%	}	%> 
		</div>
	</div>
</nav>


