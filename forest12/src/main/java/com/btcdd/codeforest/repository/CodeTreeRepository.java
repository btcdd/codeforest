package com.btcdd.codeforest.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.btcdd.codeforest.linux.CodeTreeLinux;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubmitVo;

@Repository
public class CodeTreeRepository {
	
	@Autowired
	private SqlSession sqlSession;

	public void saveUserAndProblem(Map<String, Object> map) {
		sqlSession.update("codetree.saveUserAndProblem", map);
	}

	public void savePath(Map<String, Object> map) {
		sqlSession.update("codetree.savePath", map);
	}

	public void saveCode(Map<String, Object> map) {
		sqlSession.update("codetree.saveCode", map);
	}

	public List<CodeVo> findCode(Long subProblemNo) {
		return sqlSession.selectList("codetree.findCode", subProblemNo);
	}

	public Long findSaveNo(Map<String, Object> map) {
		return sqlSession.selectOne("codetree.findSaveNo", map);
	}

	public List<SubProblemVo> findSubProblemNo(Long problemNo) {
		return sqlSession.selectList("codetree.findSubProblemNo", problemNo);
	}

	// 고치던거!
	public void insertSavePath(Long saveNo, List<SubProblemVo> subProblemList) {
		sqlSession.insert("codetree.insertSavePath");
	}

	public int getTotalCount(String keyword,Long authUserNo) {
		Map<String,Object> map = new HashMap<>();
		map.put("keyword", keyword);
		map.put("authUserNo", authUserNo);
		return sqlSession.selectOne("codetree.totalCount",map);
	}

	public List<SaveVo> selectSaveNoList(int displayPost, int postNum,String keyword,Long authUserNo) {
		Map<String,Object> map = new HashMap<>();
		map.put("displayPost",displayPost);
		map.put("postNum",postNum);
		map.put("keyword", keyword);
		map.put("authUserNo", authUserNo);
		return sqlSession.selectList("codetree.selectSaveNoList", map);
	}


	public SaveVo findSaveVo(Long saveNo) {
		return sqlSession.selectOne("codetree.findSaveVo",saveNo);
	}

	public List<SavePathVo> findSavePathList(Long saveNo) {
		return sqlSession.selectList("codetree.findSavePathList", saveNo);
	}

	public List<CodeVo> findCodeList(Long savePathNo) {
		return sqlSession.selectList("codetree.findCodeList", savePathNo);
	}

	public List<SubProblemVo> findSubProblemList(Long problemNo) {
		return sqlSession.selectList("codetree.findSubProblemList", problemNo);
	}

	public int insertFile(Long savePathNo, String language, String fileName) {
		Map<String,Object> map = new HashMap<>();
		map.put("savePathNo", savePathNo);
		map.put("language", language);
		map.put("fileName", fileName);
		return sqlSession.insert("codetree.insertFile", map);
	}


	public CodeVo findByFileName(String fileName,Long savePathNo) {
		Map<String,Object> map = new HashMap<>();
		map.put("fileName", fileName);
		map.put("savePathNo", savePathNo);
		return sqlSession.selectOne("codetree.findByFileName",map);
  }
	public Long findProblemNo(Long subProblemNo) {
		return sqlSession.selectOne("codetree.findProblemNo", subProblemNo);
	}

	public Long findCodeNo(Long savePathNo, String fileName) {
		Map<String,Object> map = new HashMap<>();
		map.put("savePathNo", savePathNo);
		map.put("fileName", fileName);
		return sqlSession.selectOne("codetree.findCodeNo",map);
	}

	public int delete(Long codeNo) {
		return sqlSession.delete("codetree.delete", codeNo);
	}

	public CodeVo findSavePathNoAndFileName(Long codeNo) {
		return sqlSession.selectOne("codetree.findSavePathNoAndFileName", codeNo);
	}

	public SavePathVo findSavePathVo(Long savePathNo) {
		return sqlSession.selectOne("codetree.findSavePathVo", savePathNo);
	}

	public int updateFile(Long codeNo, String fileName) {
		Map<String,Object> map = new HashMap<>();
		map.put("codeNo", codeNo);
		map.put("fileName", fileName);
		return sqlSession.update("codetree.updateFile",map);
	}

	public String getExamOutput(Long subProblemNo) {
		return sqlSession.selectOne("codetree.getExamOutput", subProblemNo);
	}
// 추가한 부분
	public int submitSubProblem(Long authUserNo, Long subProblemNo, String codeValue, String language, String answer) {
		Map<String,Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("subProblemNo", subProblemNo);
		map.put("codeValue", codeValue);
		map.put("language", language);
		map.put("answer", answer);


		return sqlSession.insert("codetree.submitSubProblem", map);
	}
	
	public SubmitVo findSubmitNoBySubProblem(Long authUserNo, Long subProblemNo, String language) {
		Map<String,Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("subProblemNo", subProblemNo);
		map.put("language", language);
		return sqlSession.selectOne("codetree.findSubmitNoBySubProblem",map);
	}
	
	public SubmitVo existAttempt(Long submitNo) {
		return sqlSession.selectOne("codetree.existAttempt",submitNo);
	}

	public int insertAttempt(Long submitNo) {
		return sqlSession.insert("codetree.insertAttempt", submitNo);
	}

	public int updateAttempt(Long submitNo) {
		return sqlSession.update("codetree.updateAttempt", submitNo);
	}

	public int updateSubProblem(Long submitNo,String codeValue, String answer) {
		Map<String, Object> map = new HashMap<>();
		map.put("submitNo", submitNo);
		map.put("codeValue", codeValue);
		map.put("answer", answer);

		
		return sqlSession.update("codetree.updateSubProblem", map);
	}



//	public int getTotalCount(String keyword) {
//		return sqlSession.selectOne("codetree.totalCount",keyword);
//	}

}