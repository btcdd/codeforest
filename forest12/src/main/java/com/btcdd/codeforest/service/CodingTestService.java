package com.btcdd.codeforest.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.btcdd.codeforest.repository.CodingTestRepository;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.UserVo;

@Service
public class CodingTestService {

	@Autowired
	private CodingTestRepository testRepository;

	public List<ProblemVo> selectTestList() {
		return testRepository.selectTestList();
	}

	public UserVo findUserByEmail(String userEmail) {
		return testRepository.findUserByEmail(userEmail);
	}

	public ProblemVo selectProblemOne(Long problemNo) {
		testRepository.updateHit(problemNo);
		return testRepository.selectProblemOne(problemNo);
	}

	public void insertUserInfo(String name, String birth, Long authUserNo) {
		testRepository.insertInputValueByAuthUserNo(name,birth,authUserNo);
		
	}

	public List<SubProblemVo> findSubProblemList(Long problemNo) {
		return testRepository.findSubProblemList(problemNo);
		
	}
}