package com.btcdd.codeforest.vo;

public class StatisticsVo {
	private String language;
	private int count;
	
	public String getLanguage() {
		return language;
	}
	public void setLanguage(String language) {
		this.language = language;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	
	@Override
	public String toString() {
		return "StatisticsVo [language=" + language + ", count=" + count + "]";
	}
}