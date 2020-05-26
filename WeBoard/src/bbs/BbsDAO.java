package bbs;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.naming.*;
import javax.sql.*;

public class BbsDAO {
    private static BbsDAO instance = new BbsDAO();
    //.jsp페이지에서 DB연동빈인 BoardDBBean클래스의 메소드에 접근시 필요
    public static BbsDAO getInstance() {
        return instance;
    }
    private BbsDAO() {}
	
    private Connection getConnection() throws Exception {
		Context initCtx= new InitialContext();
		Context envCtx = (Context)initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource)envCtx.lookup("jdbc/oracledb");
    	return ds.getConnection();
    }

	//각 글의 총 개수
	public int totalBbs(int what) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        conn = getConnection();
	        pstmt = conn.prepareStatement("select count(*) from Bbs where notice = ?");
            pstmt.setInt(1, what);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	           return rs.getInt(1);
			}
	    } catch(Exception ex) {
	        ex.printStackTrace();
	    } finally {
	        closeDBResources(rs, pstmt, conn);
	    }
		return 0;
	}
	
	//각 글의 전체 목록 보기	//1:공지//0:일반
	public List<Bbs> getBbsList(int start, int end, int what) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    List<Bbs> bbsList = null;
	    try {
	        conn = getConnection();
	
	        //페이징 처리
	        String sql = "select * from (select rowNum rnum, B.* from (select * from Bbs where notice = ? order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
	        pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, what);
	        pstmt.setInt(2, start);
			pstmt.setInt(3, end);
	        rs = pstmt.executeQuery();
	
	        if (rs.next()) {
	        	bbsList = new ArrayList<Bbs>(end);
	            do{
	              Bbs bbs = new Bbs();
	              bbs.setBbsId(rs.getInt("bbsId"));
				  bbs.setUsrId(rs.getString("usrId"));
	              bbs.setBbsTitle(rs.getString("bbsTitle"));
			      bbs.setBbsDate(rs.getTimestamp("bbsDate"));
				  bbs.setReadCount(rs.getInt("readCount"));
	              bbs.setRef(rs.getInt("ref"));
	              bbs.setRe_step(rs.getInt("re_step"));
				  bbs.setRe_level(rs.getInt("re_level"));
	              bbs.setBbsContent(rs.getString("bbsContent"));
	              bbs.setNotice(rs.getInt("notice"));
			      bbs.setFileName(rs.getString("fileName"));
			      bbsList.add(bbs);
			    }while(rs.next());
			}
	    } catch(Exception ex) {
	        ex.printStackTrace();
	    } finally {
	    	closeDBResources(rs, pstmt, conn);
	    }
		return bbsList;
	}
	
	//검색 후 추출된 각 글의 개수 
	public int totalSearch(String option, String searchWord, int start, int end, int what) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = null;
        try {
        	conn = getConnection();
        	switch (option) {
			case "usrId":
                sql = "select count(*) from (select rowNum rnum, B.* from (select * from Bbs where notice = ? and usrId like ? "
                		+ "order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, what);
                pstmt.setString(2, searchWord);
                pstmt.setInt(3, start);
    			pstmt.setInt(4, end);
				break;
				
			case "bbsTitle":
				sql = "select count(*) from (select rowNum rnum, B.* from (select * from Bbs where notice = ? and bbsTitle like ? "
                		+ "order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, what);
                pstmt.setString(2, "%" + searchWord + "%");
                pstmt.setInt(3, start);
    			pstmt.setInt(4, end);
				break;
				
			case "bbsContent":
				sql = "select count(*) from (select rowNum rnum, B.* from (select * from Bbs where notice = ? and bbsContent like ? "
                		+ "order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, what);
                pstmt.setString(2, "%" + searchWord + "%");
                pstmt.setInt(3, start);
    			pstmt.setInt(4, end);
				break;
				
			case "title_content":
				sql = "select count(*) from (select rowNum rnum, B.* from (select * from (select * from bbs"
						+ " where bbsTitle like ? or bbsContent like ?) where notice = ? "
						+ "order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchWord + "%");
                pstmt.setString(2, "%" + searchWord + "%");
                pstmt.setInt(3, what);
                pstmt.setInt(4, start);
    			pstmt.setInt(5, end);
				break;
			}
            rs = pstmt.executeQuery();
	        if (rs.next()) {
	           return rs.getInt(1);
			}
	    } catch(Exception ex) {
	        ex.printStackTrace();
	    } finally {
	        closeDBResources(rs, pstmt, conn);
	    }
		return 0;
    }
	
	//검색 후 추출된 각 글의 목록 보기
	public ArrayList<Bbs> searchBbs(String option, String searchWord, int start, int end, int what) {
        ArrayList<Bbs> bbsList = new ArrayList<Bbs>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = null;
        try {
        	conn = getConnection();
        	switch (option) {
			case "usrId":
                sql = "select * from (select rowNum rnum, B.* from (select * from Bbs where notice = ? and usrId like ? "
                		+ "order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, what);
                pstmt.setString(2, searchWord);
                pstmt.setInt(3, start);
    			pstmt.setInt(4, end);
				break;
				
			case "bbsTitle":
				sql = "select * from (select rowNum rnum, B.* from (select * from Bbs where notice = ? and bbsTitle like ? "
                		+ "order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, what);
                pstmt.setString(2, "%" + searchWord + "%");
                pstmt.setInt(3, start);
    			pstmt.setInt(4, end);
				break;
				
			case "bbsContent":
				sql = "select * from (select rowNum rnum, B.* from (select * from Bbs where notice = ? and bbsContent like ? "
                		+ "order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, what);
                pstmt.setString(2, "%" + searchWord + "%");
                pstmt.setInt(3, start);
    			pstmt.setInt(4, end);
				break;
				
			case "title_content":
				sql = "select * from (select rowNum rnum, B.* from (select * from (select * from bbs"
						+ " where bbsTitle like ? or bbsContent like ?) where notice = ? "
						+ "order by ref desc, re_step asc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchWord + "%");
                pstmt.setString(2, "%" + searchWord + "%");
                pstmt.setInt(3, what);
                pstmt.setInt(4, start);
    			pstmt.setInt(5, end);
				break;
			}
            rs = pstmt.executeQuery();
 
	        if (rs.next()) {
	        	bbsList = new ArrayList<Bbs>(end);
	            do{
	              Bbs bbs = new Bbs();
	              bbs.setBbsId(rs.getInt("bbsId"));
				  bbs.setUsrId(rs.getString("usrId"));
	              bbs.setBbsTitle(rs.getString("bbsTitle"));
			      bbs.setBbsDate(rs.getTimestamp("bbsDate"));
				  bbs.setReadCount(rs.getInt("readCount"));
	              bbs.setRef(rs.getInt("ref"));
	              bbs.setRe_step(rs.getInt("re_step"));
				  bbs.setRe_level(rs.getInt("re_level"));
	              bbs.setBbsContent(rs.getString("bbsContent"));
	              bbs.setNotice(rs.getInt("notice"));
			      bbs.setFileName(rs.getString("fileName"));
			      bbsList.add(bbs);
			    }while(rs.next());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	closeDBResources(rs, pstmt, conn);
        }
        return bbsList;
    }
	
	//공지글 여부 확인
	public int checkNotice(int bbsId) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;    
		String sql = "select notice from Bbs where bbsId = ? and notice = 1";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, bbsId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return 1;	//공지글
			} else return 0;	//일반글
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(rs, pstmt, conn);
		}
		return -1;	//DB오류
	}
	
	//작성자의 이메일 주소 추출
	public String writerEmail(String usrId) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String email = "데이터베이스 오류가 발생하였습니다.";
		String sql = "select usrEmail from Usr where usrId = ?";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, usrId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				email = rs.getString(1);
				return email;
			}
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(rs, pstmt, conn);
		}
		return email;
	}
	
	//글 쓰기
	public void write(Bbs bbs) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int bbsId = bbs.getBbsId();
		int ref = bbs.getRef();
		int re_step = bbs.getRe_step();
		int re_level = bbs.getRe_level();
		int number = 0;
		String sql = "";
		
		try {
			conn = getConnection();
			if (conn == null)
				System.out.println("fail");
			else
				System.out.println("Connected");
			sql = "select max(bbsId) from Bbs";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				number = rs.getInt(1) + 1;
			} else {
				number = 1;
			}
			closeDBResources(rs, pstmt);			
			if(bbsId!=0) {  // 댓글
				sql = "update Bbs set re_step=re_step+1 where ref=? and re_step>?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, re_step);
				pstmt.executeUpdate();
				re_step = re_step + 1;
				re_level = re_level + 1;
			} else {  // 원본글쓰기 - 댓글x
				ref = number;
				re_step = 0;
				re_level = 0;				
			}
			closeDBResources(rs, pstmt);			
			sql = "insert into Bbs (bbsId, usrId, bbsTitle, bbsDate, ref, re_step, "
					+ "re_level, bbsContent, notice, fileName) values (?,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, number);
            pstmt.setString(2, bbs.getUsrId());
            pstmt.setString(3, bbs.getBbsTitle());
			pstmt.setTimestamp(4, bbs.getBbsDate());
            pstmt.setInt(5, ref);
            pstmt.setInt(6, re_step);
            pstmt.setInt(7, re_level);
			pstmt.setString(8, bbs.getBbsContent());
			pstmt.setInt(9, bbs.getNotice());
			pstmt.setString(10, bbs.getFileName());
			pstmt.executeUpdate();
		} catch(Exception ex) {
			ex.printStackTrace();
		} finally {
			closeDBResources(rs, pstmt, conn);
		}
	}

	//글 읽기
	public Bbs getBbs(int bbsId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Bbs bbs = null;
        try {
            conn = getConnection();

            pstmt = conn.prepareStatement("update bbs set readCount = readCount+1 where bbsId = ?");
			pstmt.setInt(1, bbsId);
			pstmt.executeUpdate();
			
			closeDBResources(pstmt);
			
            pstmt = conn.prepareStatement("select * from bbs where bbsId = ?");
            pstmt.setInt(1, bbsId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                bbs = new Bbs();
			    bbs.setBbsId(rs.getInt("bbsId"));
			    bbs.setUsrId(rs.getString("usrId"));
                bbs.setBbsTitle(rs.getString("bbsTitle"));
		        bbs.setBbsDate(rs.getTimestamp("bbsDate"));
			    bbs.setReadCount(rs.getInt("readCount"));
                bbs.setRef(rs.getInt("ref"));
                bbs.setRe_step(rs.getInt("re_step"));
		   	    bbs.setRe_level(rs.getInt("re_level"));
                bbs.setBbsContent(rs.getString("bbsContent"));
                bbs.setNotice(rs.getInt("notice"));
		        bbs.setFileName(rs.getString("fileName"));
			}
        } catch(Exception ex) {
            ex.printStackTrace();
        } finally {
        	closeDBResources(rs, pstmt, conn);
        }
		return bbs;
    }

	//수정할 글 불러오기
	public Bbs getUpdate(int bbsId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Bbs bbs = null;
        try {
            conn = getConnection();

            pstmt = conn.prepareStatement(
            	"select * from bbs where bbsId = ?");
            pstmt.setInt(1, bbsId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
            	bbs = new Bbs();
                  bbs.setBbsId(rs.getInt("bbsId"));
                  bbs.setUsrId(rs.getString("usrId"));
				  bbs.setBbsTitle(rs.getString("bbsTitle"));
				  bbs.setBbsDate(rs.getTimestamp("bbsDate"));
				  bbs.setReadCount(rs.getInt("readCount"));
				  bbs.setRef(rs.getInt("ref"));
				  bbs.setRe_step(rs.getInt("re_step"));
				  bbs.setRe_level(rs.getInt("re_level"));
				  bbs.setBbsContent(rs.getString("bbsContent"));
				  bbs.setFileName(rs.getString("fileName")); 
			}
        } catch(Exception ex) {
            ex.printStackTrace();
        } finally {
        	closeDBResources(rs, pstmt, conn);
        }
		return bbs;
    }
    
	//글 수정하기
	public int update(Bbs bbs) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = "";
        try {
            conn = getConnection();
            
			pstmt = conn.prepareStatement("select usrId from Bbs where bbsId = ?");
            pstmt.setInt(1, bbs.getBbsId());
            rs = pstmt.executeQuery();
			if(rs.next()){
				if(rs.getString("usrId").equals(bbs.getUsrId())){
					closeDBResources(pstmt);
					sql = "update Bbs set bbsTitle = ?, bbsContent = ?, fileName = ? where bbsId = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, bbs.getBbsTitle());
					pstmt.setString(2, bbs.getBbsContent());
					pstmt.setString(3, bbs.getFileName());
					pstmt.setInt(4, bbs.getBbsId());
					pstmt.executeUpdate();
					return 1;
			  }else{
				return 0;
			  }
			}
        } catch(Exception ex) {
            ex.printStackTrace();
        } finally {
            closeDBResources(rs, pstmt, conn);
        }
		return -1;
    }
    
	//글 삭제하기
	public int delete(int bbsId, String usrId) throws Exception {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
			conn = getConnection();

            pstmt = conn.prepareStatement("select usrId from Bbs where bbsId = ?");
            pstmt.setInt(1, bbsId);
            rs = pstmt.executeQuery();
            
			if(rs.next()){
				if(rs.getString("usrId").equals(usrId)){
					closeDBResources(pstmt);
					pstmt = conn.prepareStatement("delete from bbs where bbsId=?");
                    pstmt.setInt(1, bbsId);
                    pstmt.executeUpdate();
                    return 1; //글삭제 성공
				}else
					return 0; //작성자와 로그인아이디가 다름//글삭제 실패
			}
        } catch(Exception ex) {
            ex.printStackTrace();
        } finally {
            closeDBResources(rs, pstmt, conn);
        }
		return -1;
    }
	
	private void closeDBResources(ResultSet rs, PreparedStatement pstmt, Connection conn) {
		if (rs != null) {
			try {
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (conn != null) {
			try {
				conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	private void closeDBResources(ResultSet rs, PreparedStatement pstmt) {
		if (rs != null) {
			try {
				rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	private void closeDBResources(PreparedStatement pstmt) {
		if (pstmt != null) {
			try {
				pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}


}