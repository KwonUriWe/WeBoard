<%@page import="bbs.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="boot/css/bootstrap.css">
<%@include file ="icNav.jsp" %>
<title>우리 게시판</title>


<script type="text/javascript" src="script.js"></script>
</head>
<body>
<%
 	if (session.getAttribute("usrId")!=null){
		usrId = (String) session.getAttribute("usrId");
	}

 	if(usrId==null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 작성 가능합니다.')");
		script.println("location.href='usrLoginForm.jsp'");
		script.println("</script>");
	}
 	
 	BbsDAO bbsDAO = BbsDAO.getInstance();
	int bbsId = 0, ref = 1, re_step = 0, re_level = 0;
	String strV = "";
	
	try{
		if(request.getParameter("bbsId")!=null){
			bbsId=Integer.parseInt(request.getParameter("bbsId"));
			ref=Integer.parseInt(request.getParameter("ref"));
			re_step=Integer.parseInt(request.getParameter("re_step"));
			re_level=Integer.parseInt(request.getParameter("re_level"));
		} 
%>
	<div class="container mt-5">
		<form method="post" name="writeform" action="bbsWritePro.do" enctype="multipart/form-data" onsubmit="return writeSave(this);">
			<input type="hidden" name="bbsId" value="<%=bbsId%>">
			<input type="hidden" name="usrId" value="<%=usrId%>">
			<input type="hidden" name="ref" value="<%=ref%>"> 
			<input type="hidden" name="re_step" value="<%=re_step%>"> 
			<input type="hidden" name="re_level" value="<%=re_level%>">
			<table class="table table-stripded" style="text-align: center; border: 1px solid #ddd">
				<thead>
					<tr>
						<th colspan="2" style="background-color: #eee; text-align: center;">게시글 작성하기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="2"><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="75"></td>
					</tr>
<%	 	if (usrId.equals("admin")){	 %>
					<tr>
						<td colspan="2">
							<select name="option" class="form-control">
<%			if (bbsDAO.totalBbs(1)<5) {	%>
								<option value="notice" class="form-control" selected="selected">공지글</option>
<%			}else{	 %>
								<option value="notice" class="form-control" disabled>공지글 // 최대 5개 까지만 작성 가능합니다.</option>
<%			}	%>
								<option value="normal" class="form-control">일반글</option>
							</select>
						</td>
					</tr>
<%	 	}else{	%>
					<tr style="display:none;">
						<td colspan="2">
							<select name="option" class="form-control">
								<option value="normal" selected="selected">일반글</option>
							</select>
						</td>
					</tr>
<%	 	}	  %>
					<tr>
						<td colspan="2"><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="3000" style="height: 350px;"></textarea></td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="input-group mb-3">
							  <div class="input-group-prepend">
							    <span class="input-group-text" id="inputGroupFileAddon01">Upload</span>
							  </div>
							  <div class="custom-file">
							    <input type="file" class="custom-file-input" id="inputGroupFile01" aria-describedby="inputGroupFileAddon01">
							    <label class="custom-file-label" for="inputGroupFile01">파일을 선택하세요</label>
							  </div>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<input type="submit" class="btn btn-dark float-right" value="저장하기">
			<input type="reset" class="btn btn-dark float-right mr-1" value="다시쓰기">
			<a href="bbsList.jsp" class="btn btn-dark float-left">목록보기</a>
		</form>
	</div>
<%	} catch (Exception e) { e.printStackTrace(); } %>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="boot/js/bootstrap.js"></script>
</body>
</html>
