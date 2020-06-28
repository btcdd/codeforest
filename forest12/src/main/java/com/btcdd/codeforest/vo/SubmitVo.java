package com.btcdd.codeforest.vo;

public class SubmitVo {
	private Long no;
	private String name;
	private String nickname;
	private String email;
	private String code;
	private char answer;
	private Long subproblemNo;
	private Long userNo;
	private String solveTime;
	private String lang;
	private int tryCount;
	private int problemNo;
	private String privacy;
	private String state;
	private String endTime;
	private String startTime;

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getPrivacy() {
		return privacy;
	}

	public void setPrivacy(String privacy) {
		this.privacy = privacy;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public Long getNo() {
		return no;
	}

	public void setNo(Long no) {
		this.no = no;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public char getAnswer() {
		return answer;
	}

	public void setAnswer(char answer) {
		this.answer = answer;
	}

	public Long getSubproblemNo() {
		return subproblemNo;
	}

	public void setSubproblemNo(Long subproblemNo) {
		this.subproblemNo = subproblemNo;
	}

	public Long getUserNo() {
		return userNo;
	}

	public void setUserNo(Long userNo) {
		this.userNo = userNo;
	}

	public String getSolveTime() {
		return solveTime;
	}

	public void setSolveTime(String solveTime) {
		this.solveTime = solveTime;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public int getTryCount() {
		return tryCount;
	}

	public void setTryCount(int tryCount) {
		this.tryCount = tryCount;
	}

	public int getProblemNo() {
		return problemNo;
	}

	public void setProblemNo(int problemNo) {
		this.problemNo = problemNo;
	}

	@Override
	public String toString() {
		return "SubmitVo [no=" + no + ", name=" + name + ", nickname=" + nickname + ", email=" + email + ", code="
				+ code + ", answer=" + answer + ", subproblemNo=" + subproblemNo + ", userNo=" + userNo + ", solveTime="
				+ solveTime + ", lang=" + lang + ", tryCount=" + tryCount + ", problemNo=" + problemNo + "]";
	}

}