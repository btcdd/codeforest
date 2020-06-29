package com.btcdd.codeforest.vo;

public class RankVo {

	private String nickname;
	private Long rank;
	private Long realRank;
	private Long last;

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public Long getRank() {
		return rank;
	}

	public void setRank(Long rank) {
		this.rank = rank;
	}

	public Long getRealRank() {
		return realRank;
	}

	public void setRealRank(Long realRank) {
		this.realRank = realRank;
	}

	public Long getLast() {
		return last;
	}

	public void setLast(Long last) {
		this.last = last;
	}

	@Override
	public String toString() {
		return "RankVo [nickname=" + nickname + ", rank=" + rank + ", realRank=" + realRank + ", last=" + last + "]";
	}

}