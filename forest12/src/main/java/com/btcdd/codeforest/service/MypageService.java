package com.btcdd.codeforest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.btcdd.codeforest.repository.MypageRepository;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubmitVo;
import com.btcdd.codeforest.vo.UserVo;

@Service
public class MypageService {

	private static final int postNum = 10; //한 페이지에 출력할 게시물 갯수
	private static final int pageNum_cnt = 5; 		//한번에 표시할 페이징 번호의 갯수	
	
	@Autowired
	private MypageRepository mypageRepository;

	public int changeNickname(UserVo vo) {
		return mypageRepository.changeNickname(vo);
	}

	public int changePassword(UserVo vo) {
		return mypageRepository.changePassword(vo);
	}

	public int deleteUser(UserVo vo) {
		String email = vo.getEmail();
		String result = mypageRepository.lookUpPassword(email);
		
		if(!result.equals(vo.getPassword())) {
			return 0;
		}
		
		mypageRepository.foreignKeyChecks(0L);
		int deleteUser = mypageRepository.deleteUser(vo);
		mypageRepository.foreignKeyChecks(1L);
		
		
		
		return deleteUser;
	}

	public int deleteProblem(Long no) {
		return mypageRepository.deleteProblem(no);
	}

	public List<SubmitVo> problemSolveList(Long no) {
		return mypageRepository.problemSolveList(no);
	}

	public Map<String, Object> getContentsList(int currentPage, Long userNo) {
		//게시물 총 갯수
		int count = mypageRepository.getTotalCount(userNo);
		//하단 페이징 번호([게시물 총 갯수 / 한 페이지에 출력할 갯수]의 올림)
		int pageNum = (int)Math.ceil((double)count/postNum);
		//출력할 게시물
		int displayPost = (currentPage -1) * postNum;
		//표시되는 페이지 번호 중 마지막 번호
		int endPageNum = (int)(Math.ceil((double)currentPage / (double)pageNum_cnt) * pageNum_cnt);
		//표시되는 페이지 번호 중 첫번째 번호
		int startPageNum = endPageNum - (pageNum_cnt - 1);
		//마지막번호 재계산
		int endPageNum_tmp = (int)(Math.ceil((double)count / (double)postNum));
		if(endPageNum > endPageNum_tmp) {
			endPageNum = endPageNum_tmp;
		}
		boolean next = endPageNum * pageNum_cnt >= count ? false : true;//마지막 페이지 번호가 총 게시물 갯수보다 작다면, 다음 구간이 있다는 의미이므로 출력		
		
		List<ProblemVo> list = mypageRepository.selectProblemList(displayPost, postNum, userNo);
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("list",list);		
		map.put("pageNum",pageNum);
		map.put("select",currentPage);
		map.put("startPageNum",startPageNum);
		map.put("endPageNum", endPageNum + 1);
		map.put("next",next);
		map.put("count", count);
		
		return map;
	}

	public List<SubProblemVo> findSubProblem(Long no) {
		return mypageRepository.findSubProblem(no);
	}

	public int deleteSubProblem(Long no) {
		return mypageRepository.deleteSubProblem(no);
	}

	public List<SubmitVo> findRrightSubmit(Long no) {
		return mypageRepository.findRrightSubmit(no);
	}

	public List<SubmitVo> findWrongSubmit(Long no) {
		return mypageRepository.findWrongSubmit(no);
	}

	public void privacyChange(Long authUserNo, String privacy) {
		if("open".equals(privacy)) {
			privacy = "y";
		} else {
			privacy = "n";
		}
		
		Map<String, Object> map = new HashMap<>();
		map.put("privacy", privacy);
		map.put("authUserNo", authUserNo);
		
		mypageRepository.privacyChange(map);
	}
}