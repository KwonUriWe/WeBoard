package usr;

import java.sql.Timestamp;

public class Usr {
	
	private String usrId;
	private String usrPasswd;
	private String usrName;
	private String usrGender;
	private String usrEmail;
	private int usrDelete;
	private Timestamp delDate;
	
	public String getUsrId() {
		return usrId;
	}
	public void setUsrId(String usrId) {
		this.usrId = usrId;
	}
	public String getUsrPasswd() {
		return usrPasswd;
	}
	public void setUsrPasswd(String usrPasswd) {
		this.usrPasswd = usrPasswd;
	}
	public String getUsrName() {
		return usrName;
	}
	public void setUsrName(String usrName) {
		this.usrName = usrName;
	}
	public String getUsrGender() {
		return usrGender;
	}
	public void setUsrGender(String usrGender) {
		this.usrGender = usrGender;
	}
	public String getUsrEmail() {
		return usrEmail;
	}
	public void setUsrEmail(String usrEmail) {
		this.usrEmail = usrEmail;
	}
	public int getUsrDelete() {
		return usrDelete;
	}
	public void setUsrDelete(int usrDelete) {
		this.usrDelete = usrDelete;
	}
	public Timestamp getDelDate() {
		return delDate;
	}
	public void setDelDate(Timestamp delDate) {
		this.delDate = delDate;
	}
}