package com.duzon.custom.login.vo;

public class EvalLoginVO {

	/**
	 * 2020. 5. 11.
	 * yh
	 * :
	 */
	
	private String id;
	/*private String pw;*/
    private String birth;
	private String title;
	private String phone;
	private boolean evalFlag;
	private String committeeSeq;

	public String getPhone() { return phone;}

	public void setPhone(String phone) {this.phone = phone;}

    public String getBirth() {
        return birth;
    }

    public void setBirth(String birth) {
        this.birth = birth;
    }

	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}

    public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}

	/*public String getPw() {
		return pw;
	}
	public void setPw(String pw) {
		this.pw = pw;
	}*/

	public boolean isEvalFlag() {
		return evalFlag;
	}
	public void setEvalFlag(boolean evalFlag) {
		this.evalFlag = evalFlag;
	}


    public String getCommitteeSeq() {
        return committeeSeq;
    }

    public void setCommitteeSeq(String committeeSeq) {
        this.committeeSeq = committeeSeq;
    }
}
