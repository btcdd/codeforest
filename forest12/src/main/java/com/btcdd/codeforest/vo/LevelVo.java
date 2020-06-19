package com.btcdd.codeforest.vo;

public class LevelVo {
	private Long no;
	private Long state;
	
	public Long getNo() {
		return no;
	}
	public void setNo(Long no) {
		this.no = no;
	}
	public Long getState() {
		return state;
	}
	public void setState(Long state) {
		this.state = state;
	}
	
	@Override
	public String toString() {
		return "LevelVo [no=" + no + ", state=" + state + "]";
	}
}