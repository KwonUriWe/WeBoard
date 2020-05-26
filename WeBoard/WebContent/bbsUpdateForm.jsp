<%@page import="bbs.Bbs"%>
<%@page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="boot/css/bootstrap.css">
<%@include file ="icNav.jsp" %>
<title>우리 게시판</title>

<link href="style.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="script.js"></script>
</head>
<body>
<%
	if (session.getAttribute("usrId")!=null){
		usrId = (String) session.getAttribute("usrId");
	}
	if (usrId==null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인 후 수정 가능합니다.')");
		script.println("location.href='usrLoginForm.jsp'");
		script.println("</script>");
	}
	
	int bbsId = 0;
	try{
		if (request.getParameter("bbsId")!=null) {
			bbsId = Integer.parseInt(request.getParameter("bbsId"));
		}
		if (bbsId==0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='bbsList.jsp'");
			script.println("</script>");
		}
		
		BbsDAO bbsDAO = BbsDAO.getInstance(); 
		bbs.Bbs bbs =  bbsDAO.getUpdate(bbsId);
		if (!usrId.equals(bbs.getUsrId())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href='bbsList.jsp'");
			script.println("</script>");
		}
%>
	<div class="container mt-5">
		<form method="post" name="writeform" action="bbsUpdatePro.do" onsubmit="return writeSave(this);" enctype="multipart/form-data">
			<table class="table table-stripded" style="text-align: center; border: 1px solid #ddd">
				<thead>
					<tr>
						<th colspan="2" style="background-color: #eee; text-align: center;">게시글 수정하기</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="2"><input type="text" class="form-control" value="<%=bbs.getBbsTitle()%>" name="bbsTitle" maxlength="75"></td>
					</tr>
					<tr>
						<td colspan="2"><textarea class="form-control" name="bbsContent" maxlength="3000" style="height: 350px;"><%=bbs.getBbsContent()%></textarea></td>
					</tr>
					<tr>
						<td>
							<div class="input-group">
								<div class="input-group-prepend">
									<span class="input-group-text" id="inputGroupFileAddon01">Upload</span>
								</div>
								<div class="custom-file">
									<input type="file" class="custom-file-input" name="selectfile">
									<label class="custom-file-label" for="filename"></label>
								</div>
							</div>
						</td>
<%	String filename = bbs.getFileName();
	if( filename !=null && !filename.equals("")) { %>
								<td>기 업로드 된 파일 : <%=filename %></td>
<%	} else { %>
								<td>기 업로드된 파일이 없습니다.</td>
<%	}  %>
					</tr>
				</tbody>
			</table>
			<input type="hidden" name="bbsId" value="<%=bbsId%>">
			<input type="hidden" name="usrId" value="<%=usrId%>">
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