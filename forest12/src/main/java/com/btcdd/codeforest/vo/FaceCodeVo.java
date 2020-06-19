package com.btcdd.codeforest.vo;

public class FaceCodeVo {
	private String language;
	private String code;
	
	public FaceCodeVo(String language, String code) {
		this.language = language;
		this.code = code;
	}
	
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	
	@Override
	public String toString() {
		return "FaceCodeVo [language=" + language + ", code=" + code + "]";
	}
}
