package com.btcdd.codeforest.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.btcdd.codeforest.repository.CodingTestRepository;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
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

	public void insertSaveProblemNo(Long no, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("userNo", no);
		map.put("problemNo", problemNo);
		
		testRepository.insertSaveProblemNo(map);
		
	}

	public Long findSaveNo(Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		return testRepository.findSaveNo(map);
	}

	public void insertSavePath(Long[] subProblemNoArray, Long saveNo, Long authUserNo, Long problemNo) {
		
		testRepository.insertSavePath(subProblemNoArray, saveNo, authUserNo, problemNo);
	}

	public void insertCode(Long saveNo) {
		List<SavePathVo> savePathVoList = testRepository.findSavePathNo(saveNo);
		
		Map<String, Object> map = new HashMap<>();
		map.put("savePathVoList", savePathVoList);
		
		String[] langArray = { "c", "cpp", "cs", "java", "js", "py" };
		map.put("langArray", langArray);
		
		testRepository.insertSubProblemFaceCode(map);
	}

	public SaveVo findSaveVo(Long saveNo) {
		return testRepository.findSaveVo(saveNo);
	}

	public List<SavePathVo> findSavePathList(Long saveNo) {
		return testRepository.findSavePathList(saveNo);
	}

	public List<CodeVo> findCodeList(Long savePathNo) {
		return testRepository.findCodeList(savePathNo);
	}

	public boolean existSaveNo(Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		return testRepository.findByProblemNo(map) != null;
	}
}