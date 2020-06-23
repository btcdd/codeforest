package com.btcdd.codeforest.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubmitVo;
import com.btcdd.codeforest.vo.UserVo;

@Repository
public class MypageRepository {
	
	@Autowired
	private SqlSession sqlSession;
	
	public int changeNickname(UserVo vo ) {
		return sqlSession.update("mypage.changeNickname", vo);
	}

	public int changePassword(UserVo vo) {
		return sqlSession.update("mypage.changePassword", vo);
	}

	public int deleteUser(UserVo vo) {
		return sqlSession.delete("mypage.deleteUser", vo);
	}

	public String lookUpPassword(String email) {
		return sqlSession.selectOne("mypage.lookUpPassword", email);
	}

	public void foreignKeyChecks(long l) {
		sqlSession.update("mypage.foreignKeyChecks", 0L);
	}

	public List<ProblemVo> selectProblemList(int displayPost, int postNum, Long userNo, String keyword) {
		Map<String,Object> map = new HashMap<>();
		map.put("displayPost",displayPost);
		map.put("postNum",postNum);	
		map.put("userNo",userNo);
		map.put("keyword", keyword);
		
		List<ProblemVo> list = sqlSession.selectList("mypage.selectProblemList",map);
		return list;
	}
	
	public int deleteProblem(Long no) {
		return sqlSession.delete("mypage.deleteProblem", no);
	}

	public List<SubmitVo> problemSolveList(Long no) {
		return sqlSession.selectList("mypage.problemSolveList", no);
	}

	public int getTotalCount(Long userNo, String keyword) {
		Map<String, Object> map = new HashMap<>();
		map.put("userNo", userNo);
		map.put("keyword", keyword);
		
		return sqlSession.selectOne("mypage.totalCount", map);
	}

	public List<SubProblemVo> findSubProblem(Long no) {
		return  sqlSession.selectList("mypage.findSubProblem", no);
	}

	public int deleteSubProblem(Long no) {
		int result = sqlSession.update("mypage.deleteSubProblem", no);
		
		return result;
	}

	public List<SubmitVo> findRrightSubmit(Long no) {
		return sqlSession.selectList("mypage.findRrightSubmit", no);
	}

	public List<SubmitVo> findWrongSubmit(Long no) {
		return sqlSession.selectList("mypage.findWrongSubmit", no);
	}

	public void privacyChange(Map<String, Object> map) {
		sqlSession.update("mypage.privacyChange", map);
	}
}