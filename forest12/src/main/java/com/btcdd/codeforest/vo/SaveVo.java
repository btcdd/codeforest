package com.btcdd.codeforest.vo;

public class SaveVo {
	Long no;
	Long userNo;
	Long problemNo;
	String title;
	String kind;
	String nickname;
	String userName;
	String userEmail;

	public Long getNo() {
		return no;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
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
				+ kind + ", nickname=" + nickname + ", userName=" + userName + ", userEmail=" + userEmail + "]";
	}



}