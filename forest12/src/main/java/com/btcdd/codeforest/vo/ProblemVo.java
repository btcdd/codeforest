package com.btcdd.codeforest.vo;

public class ProblemVo {
	private Long no;
	private String title;
	private String password;
	private Long hit;
	private Long recommend;
	private String regDate;
	private Long userNo;
	private Long kindNo;
	private String startTime;
	private String endTime;
	private Long levelNo;
	private String nickname;
	private String email;
	private String kind;
	private String state;
	private int priority;
	private String privacy;

	public Long getNo() {
		return no;
	}

	public void setNo(Long no) {
		this.no = no;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public Long getHit() {
		return hit;
	}

	public void setHit(Long hit) {
		this.hit = hit;
	}

	public Long getRecommend() {
		return recommend;
	}

	public void setRecommend(Long recommend) {
		this.recommend = recommend;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public Long getUserNo() {
		return userNo;
	}

	public void setUserNo(Long userNo) {
		this.userNo = userNo;
	}

	public Long getKindNo() {
		return kindNo;
	}

	public void setKindNo(Long kindNo) {
		this.kindNo = kindNo;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public Long getLevelNo() {
		return levelNo;
	}

	public void setLevelNo(Long levelNo) {
		this.levelNo = levelNo;
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

	public String getKind() {
		return kind;
	}

	public void setKind(String kind) {
		this.kind = kind;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public int getPriority() {
		return priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public String getPrivacy() {
		return privacy;
	}

	public void setPrivacy(String privacy) {
		this.privacy = privacy;
	}

	@Override
	public String toString() {
		return "ProblemVo [no=" + no + ", title=" + title + ", password=" + password + ", hit=" + hit + ", recommend="
				+ recommend + ", regDate=" + regDate + ", userNo=" + userNo + ", kindNo=" + kindNo + ", startTime="
				+ startTime + ", endTime=" + endTime + ", levelNo=" + levelNo + ", nickname=" + nickname + ", email="
				+ email + ", kind=" + kind + ", state=" + state + ", priority=" + priority + ", privacy=" + privacy
				+ "]";
	}
}