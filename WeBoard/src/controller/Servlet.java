package controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Enumeration;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import bbs.BbsDAO;
import bbs.Bbs;

/**
 * Servlet implementation class bbsServlet
 */
@WebServlet("*.do")
public class Servlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Servlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// response.getWriter().append("Served at: ").append(request.getContextPath());
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		// PrintWriter out = response.getWriter();
		// OutputStream out =response.getOutputStream();
		String uri = request.getRequestURI();
		System.out.println("############ WE uri:" + uri);
		int lastIndex = uri.lastIndexOf("/");
		String action = uri.substring(lastIndex + 1);
		System.out.println("############ WE action:" + action);
		String viewPage = null;
		
		////bbsWritePro////
		if (action.equals("bbsWritePro.do")) {
			String realFolder = "";// 웹 어플리케이션상의 절대 경로
			String filename = "";

			// 파일이 업로드되는 폴더를 지정한다.
			String saveFolder = "/fileSave";
			String encType = "utf-8"; // 엔코딩타입
			int maxSize = 5 * 1024 * 1024; // 최대 업로될 파일크기 5Mb

			ServletContext context = getServletContext();
			// 현재 jsp페이지의 웹 어플리케이션상의 절대 경로를 구한다
			realFolder = context.getRealPath(saveFolder);
			MultipartRequest multi = null;
			try {
				// 전송을 담당할 콤포넌트를 생성하고 파일을 전송한다.
				// 전송할 파일명을 가지고 있는 객체, 서버상의 절대경로,최대 업로드될 파일크기, 문자코드, 기본 보안 적용
				multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());

				// 전송한 파일 정보를 가져와 출력한다
				Enumeration<?> files = multi.getFileNames();
				// 파일 정보가 있다면
				while (files.hasMoreElements()) {
					// input 태그의 속성이 file인 태그의 name 속성값 :파라미터이름
					String name = (String) files.nextElement();
					// 서버에 저장된 파일 이름
					filename = multi.getFilesystemName(name);
				}
				

				Bbs bbs = new Bbs();
				BbsDAO bbsDAO = BbsDAO.getInstance();

				bbs.setBbsId(Integer.parseInt(multi.getParameter("bbsId")));
				bbs.setUsrId(multi.getParameter("usrId"));
				bbs.setBbsTitle(multi.getParameter("bbsTitle"));
				bbs.setBbsContent(multi.getParameter("bbsContent"));
				bbs.setRef(Integer.parseInt(multi.getParameter("ref")));
				bbs.setRe_step(Integer.parseInt(multi.getParameter("re_step")));
				bbs.setRe_level(Integer.parseInt(multi.getParameter("re_level")));
				bbs.setBbsDate(new Timestamp(System.currentTimeMillis()));
				bbs.setFileName(filename);
				
				// 공지글 여부 확인
				if (multi.getParameter("option").equals("notice")) {
					bbs.setNotice(1);	//공지글
				} else {
					bbs.setNotice(0);	//일반글
				}
				
				bbsDAO.write(bbs);

			} catch (IOException ioe) {
				System.out.println(ioe);
			} catch (Exception ex) {
				System.out.println(ex);
			}
			viewPage = "bbsWritePro.jsp";
		}
		
		////bbsUpdatePro////
		if (action.equals("bbsUpdatePro.do")) {
			int check=0;
			String pageNum = "";
			String realFolder = "";// 웹 어플리케이션상의 절대 경로
			String filename = "";
			String saveFolder = "/fileSave";
			String encType = "utf-8"; // 엔코딩타입
			int maxSize = 5 * 1024 * 1024; // 최대 업로될 파일크기 5Mb
			ServletContext context = getServletContext();
			realFolder = context.getRealPath(saveFolder);
			MultipartRequest multi = null;
			try {
				multi = new MultipartRequest(request, realFolder, maxSize, encType, new DefaultFileRenamePolicy());
				Enumeration<?> files = multi.getFileNames();
				while (files.hasMoreElements()) {
					String name = (String) files.nextElement();
					filename = multi.getFilesystemName(name);
				}
				
				Bbs bbs = new Bbs();
				bbs.setBbsId(Integer.parseInt(multi.getParameter("bbsId")));
				bbs.setUsrId(multi.getParameter("usrId"));
				bbs.setBbsTitle(multi.getParameter("bbsTitle"));
				bbs.setBbsContent(multi.getParameter("bbsContent"));
				bbs.setFileName(filename);
				pageNum=multi.getParameter("pageNum");
				BbsDAO bbsDAO = BbsDAO.getInstance();
				check=bbsDAO.update(bbs); 
			} catch (IOException ioe) {
				System.out.println(ioe);
			} catch (Exception ex) {
				System.out.println(ex);
			}
			request.setAttribute("check", check);
			request.setAttribute("pageNum", pageNum);
			viewPage = "bbsUpdatePro.jsp";
		}

		////bbsDeletePro////
		if (action.equals("bbsDeletePro.do")) {
			int check = 0;
			int bbsId = Integer.parseInt(request.getParameter("bbsId"));
			String pageNum = request.getParameter("pageNum");
			String usrId = request.getParameter("usrId");
			try {
				BbsDAO bbsDAO = BbsDAO.getInstance();
				check = bbsDAO.delete(bbsId, usrId);
			} catch (Exception e) {
				e.printStackTrace();
			}
			request.setAttribute("pageNum", pageNum);
			request.setAttribute("check", check);
			viewPage = "bbsDeletePro.jsp";
		}
		
		RequestDispatcher rDis = request.getRequestDispatcher(viewPage);
		rDis.forward(request, response);
	}

}