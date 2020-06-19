package com.btcdd.codeforest.vo;

public class SubProblemVo {
	private Long no;
	private String title;
	private String contents;
	private String examInput;
	private String examOutput;
	private Long problemNo;
	private String state;
	
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
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getExamInput() {
		return examInput;
	}
	public void setExamInput(String examInput) {
		this.examInput = examInput;
	}
	public String getExamOutput() {
		return examOutput;
	}
	public void setExamOutput(String examOutput) {
		this.examOutput = examOutput;
	}
	public Long getProblemNo() {
		return problemNo;
	}
	public void setProblemNo(Long problemNo) {
		this.problemNo = problemNo;
	}	
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	
	@Override
	public String toString() {
		return "SubProblemVo [no=" + no + ", title=" + title + ", contents=" + contents + ", examInput=" + examInput
				+ ", examOutput=" + examOutput + ", problemNo=" + problemNo + ", state=" + state + "]";
	}
}