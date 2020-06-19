package com.btcdd.codeforest.vo;

public class AnswerUserListVo {

	private String code;
	private String nickname;
	private String lang;
	private int tryCnt;

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}

	public int getTryCnt() {
		return tryCnt;
	}

	public void setTryCnt(int tryCnt) {
		this.tryCnt = tryCnt;
	}

	@Override
	public String toString() {
		return "AnswerUserListVo [code=" + code + ", nickname=" + nickname + ", lang=" + lang + ", tryCnt=" + tryCnt
				+ "]";
	}

}