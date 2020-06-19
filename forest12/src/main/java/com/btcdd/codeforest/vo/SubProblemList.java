package com.btcdd.codeforest.vo;

import java.util.List;

public class SubProblemList {
	private List<SubProblemVo> subProblemList;

	public List<SubProblemVo> getSubProblemList() {
		return subProblemList;
	}

	public void setSubProblemList(List<SubProblemVo> subProblemList) {
		this.subProblemList = subProblemList;
	}

	@Override
	public String toString() {
		return "subProblemList [subProblemList=" + subProblemList + "]";
	}
}