package com.btcdd.codeforest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.btcdd.codeforest.repository.CodeTreeRepository;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubmitVo;

@Service
public class CodeTreeService {
	private static final int postNum = 10; //한 페이지에 출력할 게시물 갯수
	private static final int pageNum_cnt = 5; 		//한번에 표시할 페이징 번호의 갯수
	
	@Autowired
	private CodeTreeRepository codetreeRepository;
	
	public Map<String, Object> saveUserCodeAndProblems(Long authUserNo, Long problemNo, List<SavePathVo> savePathVoList, List<CodeVo> codeVoList) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		// 저장 테이블에 회원 번호와 문제 모음 번호를 저장
		codetreeRepository.saveUserAndProblem(map);

		// 저장 경로 테이블에 저장
		map.put("savePathVoList", savePathVoList);
		codetreeRepository.savePath(map);
		
		// 코드 테이블에 저장
		map.put("codeVoList", codeVoList);
		
		codetreeRepository.saveCode(map);
		
		return map;
	}

	public List<CodeVo> findCode(Long subProblemNo) {
		return codetreeRepository.findCode(subProblemNo);
	}

	public void saveUserCodeAndProblems(Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		// 저장 테이블에 회원 번호와 문제 모음 번호를 저장
		codetreeRepository.saveUserAndProblem(map);
		Long saveNo = codetreeRepository.findSaveNo(map);
		
		List<SubProblemVo> subProblemList = codetreeRepository.findSubProblemNo(problemNo);
		map.put("saveNo", saveNo);
		map.put("subProblemList", subProblemList);
//		codetreeRepository.insertSavePath(saveNo, subProblemList);

//		// 저장 경로 테이블에 저장
//		map.put("savePathVoList", savePathVoList);
//		codetreeRepository.savePath(map);
//		
//		// 코드 테이블에 저장
//		map.put("codeVoList", codeVoList);
//		
//		codetreeRepository.saveCode(map);
	}

	public Map<String, Object> getContentsList(int currentPage, String keyword,Long authUserNo) {
		int count = codetreeRepository.getTotalCount(keyword,authUserNo);
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
		
		
		List<SaveVo> saveVoList = codetreeRepository.selectSaveNoList(displayPost,postNum,keyword,authUserNo);
		Map<String, Object> map = new HashMap<>();
		map.put("list",saveVoList);		
		map.put("pageNum",pageNum);
		map.put("select",currentPage);
		map.put("startPageNum",startPageNum);
		map.put("endPageNum",endPageNum + 1);
		map.put("next",next);
		map.put("keyword",keyword);
		map.put("count", count);		
		return map;
	}

	public SaveVo findSaveVo(Long saveNo) {
		return codetreeRepository.findSaveVo(saveNo);
	}

	public List<SavePathVo> findSavePathList(Long saveNo) {
		return codetreeRepository.findSavePathList(saveNo);
	}

	public List<CodeVo> findCodeList(Long savePathNo) {
		return codetreeRepository.findCodeList(savePathNo);
	}

	public List<SubProblemVo> findSubProblemList(Long problemNo) {
		return codetreeRepository.findSubProblemList(problemNo);
	}

	public boolean insertFile(Long savePathNo, String language, String fileName) {
		return codetreeRepository.insertFile(savePathNo,language,fileName) == 1;
		
	}

	public Long existFile(String fileName,Long savePathNo) {
		return codetreeRepository.findByFileName(fileName,savePathNo);
  }
	public Long findProblemNo(Long subProblemNo) {
		return codetreeRepository.findProblemNo(subProblemNo);
	}

	public Long findCodeNo(Long savePathNo, String fileName) {
		return codetreeRepository.findCodeNo(savePathNo,fileName);
	}

	public boolean deleteFile(Long codeNo) {
		int count = codetreeRepository.delete(codeNo);
		return count == 1;
	}

	public CodeVo findSavePathNoAndFileName(Long codeNo) {
		return codetreeRepository.findSavePathNoAndFileName(codeNo);
	}

	public SavePathVo findSavePathVo(Long savePathNo) {
		return codetreeRepository.findSavePathVo(savePathNo);
	}

	public boolean updateFile(Long codeNo, String fileName) {
		return codetreeRepository.updateFile(codeNo,fileName) == 1;
		
	}

	public String getExamOutput(Long subProblemNo) {
		return codetreeRepository.getExamOutput(subProblemNo);
	}
//  추가한 부분
	
	public boolean submitSubProblem(Long authUserNo, Long subProblemNo, String codeValue, String language, boolean compileResult) {
		String answer = "n";
		
		if((compileResult+"").equals("true")) {  
			answer = "y";
		}else{
			answer = "n";
		}
		
		SubmitVo submitVo = codetreeRepository.findSubmitNoBySubProblem(authUserNo,subProblemNo,language);
		
		
		if(submitVo == null) {
			return codetreeRepository.submitSubProblem(authUserNo,subProblemNo,codeValue,language,answer) == 1;
		} else {
			return codetreeRepository.updateSubProblem(submitVo.getNo(), codeValue, answer) == 1;
		}
		
		
	}	
	
	
	public boolean submitSubProblem(Long authUserNo, Long subProblemNo, String codeValue, String language, boolean compileResult,String solveTime) {
		String answer = "n";
		
		if((compileResult+"").equals("true")) {  
			answer = "y";
		}else{
			answer = "n";
		}
		
		SubmitVo submitVo = codetreeRepository.findSubmitNoBySubProblem(authUserNo,subProblemNo,language);
		
		if(submitVo == null) {
			return codetreeRepository.submitSubProblem(authUserNo,subProblemNo,codeValue,language,answer,solveTime) == 1;
		} else {
			return codetreeRepository.updateSubProblem(submitVo.getNo(), codeValue, answer,solveTime) == 1;
		}
		
		
	}

	public SubmitVo findSubmitNoBySubProblem(Long authUserNo, Long subProblemNo, String language) {
		return codetreeRepository.findSubmitNoBySubProblem(authUserNo,subProblemNo, language);
	}
	
	public boolean increaseAttemptCount(Long submitNo) {
		boolean exist = codetreeRepository.existAttempt(submitNo) != null;
		if(exist==true) {
			//기존에 존재하면 시도 update
			return codetreeRepository.updateAttempt(submitNo)==1;
		}else {
			//시도는 1로 삽입
			return codetreeRepository.insertAttempt(submitNo) == 1;
		}
	}

	public int updateUserAnswerCount(Long authUserNo) {
		return codetreeRepository.updateUserAnswerCount(authUserNo);
	}

}