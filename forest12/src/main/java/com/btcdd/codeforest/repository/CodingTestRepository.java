package com.btcdd.codeforest.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.UserVo;

@Repository
public class CodingTestRepository {
	
	@Autowired
	private SqlSession sqlSession;

	public List<ProblemVo> selectTestList() {
		return sqlSession.selectList("codingtest.selectTestList");
	}

	public UserVo findUserByEmail(String userEmail) {
		return sqlSession.selectOne("codingtest.findUserByEmail", userEmail);
	}
	public void updateHit(Long problemNo) {
		sqlSession.update("codingtest.updateHit", problemNo);
	}
	public ProblemVo selectProblemOne(Long problemNo) {
		return sqlSession.selectOne("codingtest.selectProblemOne", problemNo);
	}

	public int insertInputValueByAuthUserNo(String name, String birth, Long authUserNo) {
		Map<String,Object> map = new HashMap<>();
		map.put("name",name);
		map.put("birth",birth);
		map.put("authUserNo",authUserNo);
		return sqlSession.update("codingtest.insertInputValueByAuthUserNo", map);
		
	}

	public List<SubProblemVo> findSubProblemList(Long problemNo) {
		return sqlSession.selectList("codingtest.findSubProblemList", problemNo);
	}


	
}