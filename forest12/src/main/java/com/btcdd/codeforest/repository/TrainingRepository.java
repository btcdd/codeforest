package com.btcdd.codeforest.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.btcdd.codeforest.vo.AnswerUserListVo;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.StatisticsVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.UserVo;

@Repository
public class TrainingRepository {
	
	@Autowired
	private SqlSession sqlSession;

	public List<ProblemVo> selectLevelList(int displayPost, int postNum, String keyword, int size, String[] checkValues) {
		Map<String,Object> map = new HashMap<>();
		map.put("displayPost",displayPost);
		map.put("postNum",postNum);
		map.put("keyword",keyword);
		map.put("size", size);
		
		for(int i = 0; i < size; i++) {
			map.put(checkValues[i], checkValues[i]);
		}
		
		return sqlSession.selectList("training.selectLevelList", map);
	}

	public List<ProblemVo> selectProblemListOrigin() {
		return sqlSession.selectList("training.selectProblemListOrigin");
	}

	public List<ProblemVo> selectOrganizationList(int displayPost, int postNum, String keyword, int size, String[] checkValues) {
		Map<String,Object> map = new HashMap<>();
		map.put("displayPost",displayPost);
		map.put("postNum",postNum);
		map.put("keyword",keyword);
		map.put("size", size);
		
		for(int i = 0; i < size; i++) {
			map.put(checkValues[i], checkValues[i]);
		}
		
		return sqlSession.selectList("training.selectOrganizationList", map);
	}

	public int insertProblem(Map<String, Object> map) {
		System.out.println(map);
		return sqlSession.insert("training.insertProblem", map);
	}

	public Long selectProblemNo() {
		return sqlSession.selectOne("training.selectProblemNo");
	}

	public int insertSubProblem(Map<String, Object> map) {
		return sqlSession.insert("training.insertSubProblem", map);
	}

	public ProblemVo selectProblemOne(Long problemNo) {
		return sqlSession.selectOne("training.selectProblemOne", problemNo);
	}

	public List<SubProblemVo> selectSubProblem(Long no) {
		return sqlSession.selectList("training.selectSubProblem", no);
	}

	public int getTotalCount(String keyword) {
		return sqlSession.selectOne("training.totalCount",keyword);
	}


	public List<ProblemVo> selectTrainingList(int displayPost, int postNum, String keyword) {
		Map<String,Object> map = new HashMap<>();
		map.put("displayPost",displayPost);
		map.put("postNum",postNum);
		map.put("keyword",keyword);
		return sqlSession.selectList("training.selectProblemListOrigin",map);
	}

	public int modify(Map<String, Object> map) {
		return sqlSession.update("training.modify", map);
	}

	public int deleteSubProblem(Map<String, Object> map) {
		return sqlSession.update("training.deleteSubProblem", map);
	}

	public int getLevelListCount(String keyword, int size, String[] checkValues) {
		Map<String,Object> map = new HashMap<>();
		map.put("keyword",keyword);
		map.put("size",size);
		for(int i = 0; i < size; i++) {
			map.put(checkValues[i], checkValues[i]);
		}
		return sqlSession.selectOne("training.getLevelListCount", map);
	}

	public int getOrganizationListCount(String keyword, int size, String[] checkValues) {
		Map<String,Object> map = new HashMap<>();
		map.put("keyword",keyword);
		map.put("size",size);
		for(int i = 0; i < size; i++) {
			map.put(checkValues[i], checkValues[i]);
		}
		return sqlSession.selectOne("training.getOrganizationListCount", map);
	}

	public UserVo findByUserEmail(String email) {
		return sqlSession.selectOne("training.findByUserEmail",email);
	}



	public List<StatisticsVo> selectStatistics(Map<String, Object> map) {
		return sqlSession.selectList("training.selectStatistics", map);
	}
	
	public List<StatisticsVo> selectStatistics(Long subProblemNo) {
		return sqlSession.selectList("training.selectStatisticsOne", subProblemNo);
	}
  
	public UserVo userFindByProblemNo(Long problemNo) {
		return sqlSession.selectOne("training.userFindByProblemNo", problemNo);
	}
	
	public int getAnswerUserListTotalCount(Long subProblemNo) {
		return sqlSession.selectOne("training.getAnswerUserListTotalCount",subProblemNo);
	}
	
	public int getAnswerUserLangListTotalCount(Long subProblemNo, String lang) {
		Map<String, Object> map = new HashMap<>();
		map.put("subProblemNo", subProblemNo);
		map.put("lang", lang);
		return sqlSession.selectOne("training.getAnswerUserLangListTotalCount", map);
	}
	
	public List<AnswerUserListVo> selectAnswerUserList(int displayPost, int postNum,Long subProblemNo) {
		Map<String,Object> map = new HashMap<>();
		map.put("displayPost",displayPost);
		map.put("postNum",postNum);
		map.put("subProblemNo",subProblemNo);
		return sqlSession.selectList("training.selectAnswerUserList", map);
	}
	
	public List<AnswerUserListVo> selectAnswerUserLangList(int displayPost, int postNum,Long subProblemNo, String lang) {
		Map<String, Object> map = new HashMap<>();
		map.put("displayPost",displayPost);
		map.put("postNum",postNum);
		map.put("subProblemNo", subProblemNo);
		map.put("lang", lang);
		return sqlSession.selectList("training.selectAnswerUserLangList", map);
	}

	public void insertSaveProblemNo(Map<String, Object> map) {
		sqlSession.insert("training.insertSaveProblemNo", map);
	}

	public Long findSaveNo(Map<String, Object> map) {
		return sqlSession.selectOne("training.findSaveNo", map);
	}

	public void insertSavePath(Long[] subProblemNoArray, Long saveNo, Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("subProblemNoArray", subProblemNoArray);
		map.put("saveNo", saveNo);
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		sqlSession.insert("training.insertSavePath", map);
	}

	public Long selectSaveNo(Map<String, Object> map) {
		return sqlSession.selectOne("training.selectSaveNo", map);
	}

	public List<SavePathVo> selectSavePath(Long saveNo) {
		return sqlSession.selectList("training.selectSavepath", saveNo);
	}

	public List<CodeVo> selectCode(Long[] savePathNoArray) {
		Map<String, Object> map = new HashMap<>();
		map.put("savePathNoArray", savePathNoArray);
		
		return sqlSession.selectList("training.selectCode", map);
	}

	public List<SaveVo> selectSaveNoList(Long authUserNo) {
		return sqlSession.selectList("training.selectSaveNoList", authUserNo);
	}

	public void updateHit(Long problemNo) {
		sqlSession.update("training.updateHit", problemNo);
	}

	public Long checkUserRecommend(Map<String, Object> map) {
		return sqlSession.selectOne("training.checkUserRecommend", map);
	}

	public void updatePlusRecommend(Long problemNo) {
		sqlSession.update("training.updatePlusRecommend", problemNo);
	}

	public void insertRecommendValue(Map<String, Object> map) {
		sqlSession.insert("training.insertRecommendValue", map);
	}

	public void deleteRecommendValue(Map<String, Object> map) {
		sqlSession.delete("training.deleteRecommendValue", map);
	}

	public void updateMinusRecommend(Long problemNo) {
		sqlSession.update("training.updateMinusRecommend", problemNo);
	}

	public void updateTestProblem(ProblemVo problemVo) {
		System.out.println(problemVo);
		sqlSession.update("training.updateTestProblem", problemVo);
	}

	public void updateTrainingProblem(ProblemVo problemVo) {
		sqlSession.update("training.updateTrainingProblem", problemVo);
	}

	public Long selectRecommend(Long problemNo) {
		return sqlSession.selectOne("training.selectRecommend", problemNo);
	}

	public List<SavePathVo> findSavePathNo(Long saveNo) {
		return sqlSession.selectList("training.findSavePathNo", saveNo);
	}

	public void deleteCode(Map<String, Object> map) {
		sqlSession.delete("training.deleteCode", map);
	}

	public void deleteSavePath(Long saveNo) {
		sqlSession.delete("training.deleteSavePath", saveNo);
	}

	public void deleteSaveByProblemNo(Map<String, Object> map) {
		sqlSession.delete("training.deleteSaveByProblemNo", map);
	}

	public void insertSubProblemFaceCode(Map<String, Object> map) {
		sqlSession.insert("training.insertSubProblemFaceCode", map);
	}

	public List<Long> findSubProblemNo(Long problemNo) {
		return sqlSession.selectList("training.findSubProblemNo", problemNo);
	}
}