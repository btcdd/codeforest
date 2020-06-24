package com.btcdd.codeforest.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
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

	public void insertSaveProblemNo(Map<String, Object> map) {
		sqlSession.insert("codingtest.insertSaveProblemNo", map);
		
	}

	public Long findSaveNo(Map<String, Object> map) {
		return sqlSession.selectOne("codingtest.findSaveNo", map);
	}

	public void insertSavePath(Long[] subProblemNoArray, Long saveNo, Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("subProblemNoArray", subProblemNoArray);
		map.put("saveNo", saveNo);
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		sqlSession.insert("codingtest.insertSavePath", map);
	}

	public List<SavePathVo> findSavePathNo(Long saveNo) {
		return sqlSession.selectList("codingtest.findSavePathNo", saveNo);
	}

	public void insertSubProblemFaceCode(Map<String, Object> map) {
		sqlSession.insert("codingtest.insertSubProblemFaceCode", map);
	}

	public SaveVo findSaveVo(Long saveNo) {
		return sqlSession.selectOne("codingtest.findSaveVo",saveNo);
	}

	public List<SavePathVo> findSavePathList(Long saveNo) {
		return sqlSession.selectList("codingtest.findSavePathList", saveNo);
	}

	public List<CodeVo> findCodeList(Long savePathNo) {
		return sqlSession.selectList("codingtest.findCodeList", savePathNo);
	}

	public SaveVo findByProblemNo(Map<String, Object> map) {
		return sqlSession.selectOne("codingtest.findByProblemNo", map);
	}


	
}