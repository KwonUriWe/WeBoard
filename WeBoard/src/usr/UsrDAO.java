package usr;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import usr.Usr;

public class UsrDAO {
	//DB 연결
	    private static UsrDAO instance = new UsrDAO();
	    //.jsp페이지에서 DB연동빈인 BoardDBBean클래스의 메소드에 접근시 필요
	    public static UsrDAO getInstance() {
	        return instance;
	    }
	    private UsrDAO() {}
		
		private Connection getConnection() throws Exception {
			Context initCtx= new InitialContext();
			Context envCtx = (Context)initCtx.lookup("java:comp/env");
			DataSource ds = (DataSource)envCtx.lookup("jdbc/oracledb");
	    	return ds.getConnection();
	    }
	
	//로그인
	public int login(String usrId, String usrPasswd) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;    
		String sql = "select usrDelete from Usr where usrId = ? and usrPasswd = ?";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, usrId);
			pstmt.setString(2, usrPasswd);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getInt("usrDelete")==0) {
					return 1;		//로그인 성공
				} else if (rs.getInt("usrDelete")==1) {
					return 2;	//탈퇴계정
				} 	
			} else return 0;	//로그인 실패
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(rs, pstmt, conn);
		}
		return -1;	//DB오류
	}
	
	//회원가입
	public int join(String usrId, String usrPasswd, String usrName, String usrGender, String usrEmail) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;    
		String sql = "select usrName from Usr where usrId = ?";
	    try {
	    	conn = getConnection();
	    	pstmt = conn.prepareStatement(sql);
	    	pstmt.setString(1, usrId);
	    	rs = pstmt.executeQuery();
	    	if (rs.next()) {
	    		return 0;	//아이디 중복 오류
	    	} else {
	    		closeDBResources(pstmt);
	    		sql = "insert into Usr (usrId, usrPasswd, usrName, usrGender, usrEmail, delDate) values (?, ?, ?, ?, ?, ?)";
	    		pstmt = conn.prepareStatement(sql);
	    		pstmt.setString(1, usrId);
	    		pstmt.setString(2, usrPasswd);
	    		pstmt.setString(3, usrName);
	    		pstmt.setString(4, usrGender);
	    		pstmt.setString(5, usrEmail);
	    		pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
	    		return pstmt.executeUpdate();	//회원가입 요청
	    	}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(rs, pstmt, conn);
		}
		return -1;	//DB오류
	}
	
	//회원정보 읽기
	public Usr getUsr(String usrId) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;    
		String sql = "select * from Usr where usrId = ?";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, usrId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				Usr usr = new Usr();
				usr.setUsrId(rs.getString("usrId"));
				usr.setUsrPasswd(rs.getString("usrPasswd"));
				usr.setUsrName(rs.getString("usrName"));
				usr.setUsrGender(rs.getString("usrGender"));
				usr.setUsrEmail(rs.getString("usrEmail"));
				return usr;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(rs, pstmt, conn);
		}
		return null;
	}
	
	//회원정보 수정하기
	public int update(Usr usr) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		String sql = "update Usr set usrPasswd = ?, usrName = ?, usrGender = ?, usrEmail = ? where usrId = ?";
	    try {
	    	conn = getConnection();
    		pstmt = conn.prepareStatement(sql);
    		pstmt.setString(1, usr.getUsrPasswd());
    		pstmt.setString(2, usr.getUsrName());
    		pstmt.setString(3, usr.getUsrGender());
    		pstmt.setString(4, usr.getUsrEmail());
    		pstmt.setString(5, usr.getUsrId());
    		return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(pstmt, conn);
		}
		return -1;	//DB오류
	}
	
	//사용자 비밀번호 확인
	public int checkPwd(String usrId, String usrPasswd) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;    
		String SQL = "select usrName from Usr where usrId = ? and usrPasswd = ?";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, usrId);
			pstmt.setString(2, usrPasswd);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return 1;	//확인됨
			} else return 0;	//확인 안됨
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(rs, pstmt, conn);
		}
		return -1;	//DB오류
	}

	//회원 탈퇴하기
	public int delete(String usrId) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		String sql = "update Usr set usrDelete = 1, delDate = ? where usrId = ?";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
			pstmt.setString(2, usrId);
			return pstmt.executeUpdate(); //계정 삭제 요청
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(pstmt, conn);
		}
		return -1;	//DB오류
	}
	
	//전체 회원 수 추출
	public int getTotalUsr() throws Exception {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;    
	    String sql = "select count(*) from Usr";
	    try {
			conn = getConnection();
	    	pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	           return rs.getInt(1);
			}
	    } catch(Exception ex) {
	        ex.printStackTrace();
	    } finally {
			closeDBResources(rs, pstmt, conn);
		}
		return -1;
	}
	
	//회원 목록 보기
	public List<Usr> getUsrs(int start, int end) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		ResultSet rs = null;    
		List<Usr> usrList = null;
		try {
			conn = getConnection();
			String sql = "select * from (select rowNum rnum, B.* from (select * from Usr order by usrDelete asc, delDate desc) B) where rnum >= ? and rnum <= ?";
		    pstmt = conn.prepareStatement(sql);
		    pstmt.setInt(1, start);
			pstmt.setInt(2, end);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				usrList = new ArrayList<Usr>(end);
	            do {
	            	Usr usr = new Usr();
					usr.setUsrId(rs.getString("usrId"));
					usr.setUsrName(rs.getString("usrName"));
					usr.setUsrGender(rs.getString("usrGender"));
					usr.setUsrEmail(rs.getString("usrEmail"));
					usr.setUsrDelete(rs.getInt("usrDelete"));
					usr.setDelDate(rs.getTimestamp("delDate"));
					usrList.add(usr);
			    } while (rs.next());
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(rs, pstmt, conn);
		}
		return usrList;
	}
	
	//검색 후 추출된 계정정보의 개수 
	public int totalSearch(String option, String searchWord, int start, int end) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = null;
        try {
        	conn = getConnection();
            switch (option) {
			case "usrId":
                sql = "select count(*) from (select rowNum rnum, B.* from (select * from Usr where usrId like ? "
                		+ "order by usrDelete asc, delDate desc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchWord + "%");
                pstmt.setString(2, "%" + searchWord + "%");
    	        pstmt.setInt(3, start);
    			pstmt.setInt(4, end);
    			break;
    			
			case "usrName":
                sql = "select count(*) from (select rowNum rnum, B.* from (select * from Usr where usrName like ? "
                		+ "order by usrDelete asc, delDate desc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchWord + "%");
                pstmt.setInt(2, start);
    			pstmt.setInt(3, end);
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
	
	//목록에서 검색하기
	public ArrayList<Usr> searchUsr(String option, String searchWord, int start, int end) {
        ArrayList<Usr> usrList = new ArrayList<Usr>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String sql = null;
        try {
        	conn = getConnection();
        	switch (option) {
			case "usrId":
                sql = "select * from (select rowNum rnum, B.* from (select * from Usr where usrId like ? "
                		+ "order by usrDelete asc, delDate desc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchWord + "%");
    	        pstmt.setInt(3, start);
    			pstmt.setInt(4, end);
    			break;
    			
			case "usrName":
                sql = "select * from (select rowNum rnum, B.* from (select * from Usr where usrName like ? "
                		+ "order by usrDelete asc, delDate desc) B) where rnum >= ? and rnum <= ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchWord + "%");
                pstmt.setInt(2, start);
    			pstmt.setInt(3, end);
    			break;
            }
            rs = pstmt.executeQuery();
 
	        if (rs.next()) {
	        	usrList = new ArrayList<Usr>(end);
	            do{
	            	Usr usr = new Usr();
					usr.setUsrId(rs.getString("usrId"));
					usr.setUsrName(rs.getString("usrName"));
					usr.setUsrGender(rs.getString("usrGender"));
					usr.setUsrEmail(rs.getString("usrEmail"));
					usr.setUsrDelete(rs.getInt("usrDelete"));
					usr.setDelDate(rs.getTimestamp("delDate"));
			      usrList.add(usr);
			    }while(rs.next());
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        	closeDBResources(rs, pstmt, conn);
        }
        return usrList;
    }
	
	//탈퇴한 지 30일이 지난 회원정보 삭제
	public int deleteFinal(String usrId) {
		Connection conn = null; 
		PreparedStatement pstmt = null;
		String sql = "delete from Usr where usrDelete = 1 and trunc(MONTHS_BETWEEN(SYSDATE, deldate)) >= 1";
		try {
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			if (usrId.equals("admin")) {
				return pstmt.executeUpdate();
			} else return 0;	//사용자 계정이 아님
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeDBResources(pstmt, conn);
		}
		return -1;	//DB오류
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
	
	private void closeDBResources(PreparedStatement pstmt, Connection conn) {
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





















