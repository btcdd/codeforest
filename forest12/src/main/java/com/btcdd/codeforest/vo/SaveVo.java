package com.btcdd.codeforest.vo;

public class SaveVo {
	Long no;
	Long userNo;
	Long problemNo;
	String title;
	String kind;
	String nickname;

	public Long getNo() {
		return no;
	}

	public void setNo(Long no) {
		this.no = no;
	}

	public Long getUserNo() {
		return userNo;
	}

	public void setUserNo(Long userNo) {
		this.userNo = userNo;
	}

	public Long getProblemNo() {
		return problemNo;
	}

	public void setProblemNo(Long problemNo) {
		this.problemNo = problemNo;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	@Override
	public String toString() {
		return "SaveVo [no=" + no + ", userNo=" + userNo + ", problemNo=" + problemNo + ", title=" + title + ", kind="
				+ kind + ", nickname=" + nickname + "]";
	}

}