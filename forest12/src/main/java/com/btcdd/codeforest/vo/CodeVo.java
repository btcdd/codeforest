package com.btcdd.codeforest.vo;

public class CodeVo {
	private Long no;
	private Long savePathNo;
	private String language;
	private String fileName;
	private Long subProblemNo;
	
	public Long getNo() {
		return no;
	}
	public void setNo(Long no) {
		this.no = no;
	}
	public Long getSavePathNo() {
		return savePathNo;
	}
	public void setSavePathNo(Long savePathNo) {
		this.savePathNo = savePathNo;
	}
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public Long getSubProblemNo() {
		return subProblemNo;
	}
	public void setSubProblemNo(Long subProblemNo) {
		this.subProblemNo = subProblemNo;
	}
	
	@Override
	public String toString() {
		return "CodeVo [no=" + no + ", savePathNo=" + savePathNo + ", language=" + language + ", fileName=" + fileName
				+ ", subProblemNo=" + subProblemNo + "]";
	}
}