<%@page import="bbs.Bbs"%>
<%@page import="bbs.BbsDAO"%>
<%@ page import="java.io.PrintWriter" %>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<script type="text/javascript">
	function download(filename) {
		document.downloadFrm.filename.value=filename;
		document.downloadFrm.submit();
	}
</script>
</head>
<body>
<%
		if (session.getAttribute("usrId")!=null){
			usrId = (String) session.getAttribute("usrId");
		}
		int bbsId = 0;
		String pageNum = null;
		BbsDAO bbsDAO = BbsDAO.getInstance(); 
		
		if (request.getParameter("bbsId")!=null && (String)request.getParameter("pageNum")!=null) {
			bbsId = Integer.parseInt(request.getParameter("bbsId"));
			pageNum = (String)request.getParameter("pageNum");
		}
		
		if (bbsId==0 && pageNum==null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href='bbsList.jsp'");
			script.println("</script>");
		}
		
		bbs.Bbs bbs = bbsDAO.getBbs(bbsId);
		int ref = bbs.getRef();
		int re_step = bbs.getRe_step();
		int re_level = bbs.getRe_level();
	  
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
	<div class="container mt-5">
		<table class="table table-stripded" style="text-align: center; border: 1px solid #ddd">
			<thead>
				<tr>
					<th colspan="4" style="background-color: #eee; text-align: center;">게시글 내용보기</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td></td>
					<td style="width: 50%"></td>
<%	if (bbsDAO.checkNotice(bbsId)==0) { %>
					<td>글번호   [<%=bbs.getBbsId()%>]</td>
<%	} else { %>
					<td>공지사항</td>
<%	} %>
					<td>조회수   [<%=bbs.getReadCount()%>]</td>
				</tr>
				<tr>
					<td style="width:20%;">글제목</td>
					<!-- 특수문자나 공백 등이 추가될 경우 html기호와 구분이 되지 않아 제대로 출력이 되지 않을 수 있음. replaceAll로 내용을 치환해줌. -->
					<td colspan="3"><%= bbs.getBbsTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
				</tr>
				<tr>
					<td>작성자</td>
					<td colspan="3"><%= bbs.getUsrId() %></td>
				</tr>
				<tr>
					<td>작성일</td>
					<td colspan="3"><%= sdf.format(bbs.getBbsDate())%></td>
				</tr>
				<tr>
					<td>글내용</td>
					<!-- 특수문자나 공백 등이 추가될 경우 html기호와 구분이 되지 않아 제대로 출력이 되지 않을 수 있음. replaceAll로 내용을 치환해줌. -->
					<td colspan="3" style="min-hieght:200px; text-align:left;"><%= bbs.getBbsContent().replaceAll(" ", "&nbsp").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>") %></td>
				</tr>
				<tr>
					<td>파일</td>
					<td colspan="3">           
<%	String filename = bbs.getFileName();
	if( filename !=null && !filename.equals("")) { %>
						<a href="javascript:download('<%=filename %>')"><%=filename %></a>
<%	} else { %>
	파일이 없습니다.
<%	}  %>
					</td>
				</tr>
			</tbody>
		</table>
		<input type="hidden" name=filename value="<%=filename%>">
		<a href="bbsList.jsp?pageNum=<%=pageNum%>" class="btn btn-dark float-left">글목록</a>
<%	/* 공지글일 경우 답글작성 불가 */
	if (bbsDAO.checkNotice(bbsId)==0) {	%>
		<a href="bbsWriteForm.jsp?bbsId=<%=bbsId%>&ref=<%=ref%>&re_step=<%=re_step%>&re_level=<%=re_level%>" class="btn btn-dark float-right">답글쓰기</a>
<%	}
	/* 작성자와 같은 UsrID로 접속할 경우 수정, 삭제 버튼 생성 */
	if (usrId!=null && usrId.equals(bbs.getUsrId())) {	%>
				<a href="bbsDeletePro.do?bbsId=<%=bbsId%>&pageNum=<%=pageNum%>&usrId=<%=usrId%>" class="btn btn-dark float-right mr-1" onclick="return confirm('게시글을 삭제하시겠습니까?')">삭제</a>
				<a href="bbsUpdateForm.jsp?bbsId=<%=bbsId%>&pageNum=<%=pageNum%>" class="btn btn-dark float-right mr-1">수정</a>
<%	}	%>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script type="text/javascript" src="boot/js/bootstrap.js"></script>
</body>
</html>