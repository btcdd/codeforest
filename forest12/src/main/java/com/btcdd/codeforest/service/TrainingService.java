package com.btcdd.codeforest.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.btcdd.codeforest.linux.TrainingLinux;
import com.btcdd.codeforest.repository.TrainingRepository;
import com.btcdd.codeforest.vo.AnswerUserListVo;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.FaceCodeVo;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.StatisticsVo;
import com.btcdd.codeforest.vo.SubProblemList;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubStatisticsVo;
import com.btcdd.codeforest.vo.UserVo;

@Service
public class TrainingService {

	private static final int postNum = 12; //한 페이지에 출력할 게시물 갯수
	private static final int pageNum_cnt = 5; 		//한번에 표시할 페이징 번호의 갯수
	
	@Autowired
	private TrainingRepository trainingRepository;

	public List<ProblemVo> selectProblemListOrigin() {
		
		return trainingRepository.selectProblemListOrigin();
	}

	public void insert(SubProblemList subProblemList, ProblemVo problemVo, Long authUserNo) {
		
		if(problemVo.getPassword() != null) {
			if("on".equals(problemVo.getPrivacy())) {
				problemVo.setPrivacy("y");
			} else {
				problemVo.setPrivacy("n");
			}
		}
		
		Map<String, Object> insertProblemMap = new HashMap<>();
		insertProblemMap.put("problemVo", problemVo);
		insertProblemMap.put("authUserNo", authUserNo);
		
		trainingRepository.insertProblem(insertProblemMap);
		Long problemNo = trainingRepository.selectProblemNo();
		
		Map<String, Object> map = new HashMap<>();
		map.put("problemNo", problemNo);
		
		List<SubProblemVo> list = subProblemList.getSubProblemList();
		
		for(int i = 0; i < list.size(); i++) {
			if(list.get(i).getTitle() == null) {
				list.remove(i);
			}
		}
		System.out.println(list);
		
		for(int i = 0; i < list.size(); i++) {
			if(list.get(i).getExamInput() == "") {
				list.get(i).setExamInput("null");
			}
		}
		
		map.put("subProblemList", list);
		
		trainingRepository.insertSubProblem(map);
	}

	public ProblemVo selectProblemOne(Long problemNo) {
		trainingRepository.updateHit(problemNo);
		return trainingRepository.selectProblemOne(problemNo);
	}

	public List<SubProblemVo> selectSubProblem(Long no) {
		return trainingRepository.selectSubProblem(no);
	}

	public Map<String, Object> getContentsList(int currentPage, String keyword, String category, String[] checkValues) {
		int count;
		
		//게시물 총 갯수
		if("".equals(category) || checkValues == null) {
			count = trainingRepository.getTotalCount(keyword);
		} else {
			int size = checkValues.length;
			
			if("level".equals(category)) {
				count = trainingRepository.getLevelListCount(keyword, size, checkValues);
			} else {
				count = trainingRepository.getOrganizationListCount(keyword, size, checkValues);
			}
		}
		
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
		
		List<ProblemVo> list;
		
		if("".equals(category) || checkValues == null) {
			list = trainingRepository.selectTrainingList(displayPost,postNum,keyword);
		} else {
			int size = checkValues.length;
			
			if("level".equals(category)) {
				list = trainingRepository.selectLevelList(displayPost,postNum,keyword, size, checkValues);
			} else {
				list = trainingRepository.selectOrganizationList(displayPost,postNum,keyword, size, checkValues);
			}
		}
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("list",list);		
		map.put("pageNum",pageNum);
		map.put("select",currentPage);
		map.put("startPageNum",startPageNum);
		map.put("endPageNum",endPageNum + 1);
		map.put("next",next);
		map.put("keyword",keyword);
		map.put("count", count);
		
		return map;
	}

	public void modify(SubProblemList subProblemList, Long problemNo) {
		List<SubProblemVo> list = subProblemList.getSubProblemList();

		Map<String, Object> map = new HashMap<>();
		map.put("problemNo", problemNo);
		map.put("listSize", list.size());
		
		for(int i = 0; i < list.size(); i++) {
			if(list.get(i).getExamInput() == "") {
				list.get(i).setExamInput("null");
			}
		}
		
		map.put("subProblemList", list);
		
		trainingRepository.modify(map);
	}

	public void deleteSubProblem(SubProblemList subProblemList, Long[] array) {
		List<SubProblemVo> list = subProblemList.getSubProblemList();
		Map<String, Object> map = new HashMap<>();
		map.put("subProblemList", list);
		map.put("deleteNoList", array);
		
		trainingRepository.deleteSubProblem(map);
	}
	
	public boolean existUser(String email) {
		return trainingRepository.findByUserEmail(email) != null;
	}


	public Map<String, Object> selectStatistics(List<SubProblemVo> subProblemList, List<Long> subProblemNoList) {
		Map<String, Object> map = new HashMap<>();
		
		List<SubStatisticsVo> subStatisticsList = new ArrayList<>();
		
		for(int i = 0; i < subProblemNoList.size(); i++) {
			map.put("subProblemNo", subProblemNoList.get(i));
			
			List<StatisticsVo> list = trainingRepository.selectStatistics(map);
			
			for(int j = 0; j < list.size(); j++) {
				if(!(list.get(j).getCount() > 0)) {
					list.get(j).setCount(0);
				}
			}
			
			SubStatisticsVo subStatisticsVo = new SubStatisticsVo();
			
			for(int j = 0; j < list.size(); j++) {
				String language = list.get(j).getLanguage();
				
				if("c".equals(language)) {
					subStatisticsVo.setC(list.get(j).getCount());
				} else if("cpp".equals(language)) {
					subStatisticsVo.setCpp(list.get(j).getCount());
				} else if("cs".equals(language)) {
					subStatisticsVo.setCs(list.get(j).getCount());
				} else if("java".equals(language)) {
					subStatisticsVo.setJava(list.get(j).getCount());
				} else if("js".equals(language)) {
					subStatisticsVo.setJs(list.get(j).getCount());
				} else if("py".equals(language)) {
					subStatisticsVo.setPy(list.get(j).getCount());
				} else if("y".equals(language)) {
					subStatisticsVo.setY(list.get(j).getCount());
				} else if("n".equals(language)) {
					subStatisticsVo.setN(list.get(j).getCount());
				}
			}
			int y = subStatisticsVo.getY();
			int n = subStatisticsVo.getN();
			
			double tmp = (double)y / (double)(y+n) * 100.0;
			double rate = Math.round(tmp * 100) / 100.0;
			
			subStatisticsVo.setRate(rate);
			
			subStatisticsList.add(subStatisticsVo);
		}
		
		map.put("size", subProblemList.size());
		map.put("subProblemList", subProblemList);
		map.put("subStatisticsList", subStatisticsList);
		
		return map;
	}
	
	public UserVo userFindByProblemNo(Long problemNo) {
		return trainingRepository.userFindByProblemNo(problemNo);
	}

	public Map<String, Object> selectAnswerList(Long subProblemNo) {
		Map<String, Object> map = new HashMap<>();
		List<StatisticsVo> list = trainingRepository.selectStatistics(subProblemNo);
		
		for(int j = 0; j < list.size(); j++) {
			if(!(list.get(j).getCount() > 0)) {
				list.get(j).setCount(0);
			}
		}
		
		SubStatisticsVo subStatisticsVo = new SubStatisticsVo();
		
		for(int j = 0; j < list.size(); j++) {
			String language = list.get(j).getLanguage();
			
			if("c".equals(language)) {
				subStatisticsVo.setC(list.get(j).getCount());
			} else if("cpp".equals(language)) {
				subStatisticsVo.setCpp(list.get(j).getCount());
			} else if("cs".equals(language)) {
				subStatisticsVo.setCs(list.get(j).getCount());
			} else if("java".equals(language)) {
				subStatisticsVo.setJava(list.get(j).getCount());
			} else if("js".equals(language)) {
				subStatisticsVo.setJs(list.get(j).getCount());
			} else if("py".equals(language)) {
				subStatisticsVo.setPy(list.get(j).getCount());
			} else if("y".equals(language)) {
				subStatisticsVo.setY(list.get(j).getCount());
			} else if("n".equals(language)) {
				subStatisticsVo.setN(list.get(j).getCount());
			}
		}
		int y = subStatisticsVo.getY();
		int n = subStatisticsVo.getN();
		
		double tmp = (double)y / (double)(y+n) * 100.0;
		double rate = Math.round(tmp * 100) / 100.0;
		
		subStatisticsVo.setRate(rate);
		
		map.put("subStatisticsVo", subStatisticsVo);
		return map;
	}

//	public Map<String, Object> selectAnswerUserList(Long subProblemNo) {
//		Map<String, Object> map = new HashMap<>();
//		List<AnswerUserListVo> list = trainingRepository.selectAnswerUserList(subProblemNo);
//		map.put("list",list);
//		return map;
//	}
	
	public Map<String, Object> selectAnswerUserList(int currentPage, Long subProblemNo, String language) {
		int count;
		//게시물 총 갯수
		if("".equals(language)) {
			count = trainingRepository.getAnswerUserListTotalCount(subProblemNo);
		} else {
			count = trainingRepository.getAnswerUserLangListTotalCount(subProblemNo, language);
		}
		
		//하단 페이징 번호([게시물 총 갯수 / 한 페이지에 출력할 갯수]의 올림)
		int pageNum = (int)Math.ceil((double)count/postNum);
		//출력할 게시물
		int displayPost = (currentPage -1) * postNum;
		//표시되는 페이지 번호 중 마지막 번호
		int endPageNum = (int)(Math.ceil((double)currentPage / (double)pageNum_cnt) * postNum);
		//표시되는 페이지 번호 중 첫번째 번호
		int startPageNum = endPageNum - (pageNum_cnt - 1);
		//마지막번호 재계산
		int endPageNum_tmp = (int)(Math.ceil((double)count / (double)postNum));
		if(endPageNum > endPageNum_tmp) {
			endPageNum = endPageNum_tmp;
		}
		boolean next = endPageNum * pageNum_cnt >= count ? false : true;//마지막 페이지 번호가 총 게시물 갯수보다 작다면, 다음 구간이 있다는 의미이므로 출력
		
		List<AnswerUserListVo> list;
		
		if("".equals(language)) {
			list = trainingRepository.selectAnswerUserList(displayPost,postNum,subProblemNo);
		} else {
			list = trainingRepository.selectAnswerUserLangList(displayPost,postNum,subProblemNo, language);
		}
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		map.put("list",list);		
		map.put("pageNum",pageNum);
		map.put("select",currentPage);
		map.put("startPageNum",startPageNum);
		map.put("endPageNum",endPageNum + 1);
		map.put("next",next);
		map.put("count", count);
		
		return map;
	}

	public void insertSaveProblemNo(Long no, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("userNo", no);
		map.put("problemNo", problemNo);
		
		trainingRepository.insertSaveProblemNo(map);
	}

	public Long findSaveNo(Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		return trainingRepository.findSaveNo(map);
	}

	public void insertSavePath(Long[] subProblemNoArray, Long saveNo, Long authUserNo, Long problemNo) {
		
		trainingRepository.insertSavePath(subProblemNoArray, saveNo, authUserNo, problemNo);
	}
	
	// 회원이 이전에 저장했던 문제 모음을 가져올 때
	public Long selectSaveNo(Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		return trainingRepository.selectSaveNo(map);
	}

	public List<SavePathVo> selectSavePath(Long saveNo) {
		return trainingRepository.selectSavePath(saveNo);
	}

	public List<CodeVo> selectCode(Long[] savePathNoArray) {
		return trainingRepository.selectCode(savePathNoArray);
	}

	public List<SaveVo> selectSaveNoList(Long authUserNo) {
		return trainingRepository.selectSaveNoList(authUserNo);
	}

	public Map<String, Object> updateRecommend(Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		Long check = trainingRepository.checkUserRecommend(map);
		if(check > 0) {
			
			trainingRepository.deleteRecommendValue(map);
			trainingRepository.updateMinusRecommend(problemNo);
		} else {
			
			trainingRepository.updatePlusRecommend(problemNo);
			trainingRepository.insertRecommendValue(map);
		}
		Long recommend = trainingRepository.selectRecommend(problemNo);
		
		map.put("recommend", recommend);
		
		return map;
	}
	
	public Map<String, Object> originRecommend(Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		Long check = trainingRepository.checkUserRecommend(map);
		Long recommend = trainingRepository.selectRecommend(problemNo);
		
		map.put("check", check);
		map.put("recommend", recommend);
		
		return map;
	}

	public void modifyProblem(ProblemVo problemVo) {
		if(problemVo.getPassword() != null) {
			if("on".equals(problemVo.getPrivacy())) {
				problemVo.setPrivacy("y");
			} else {
				problemVo.setPrivacy("n");
			}
			trainingRepository.updateTestProblem(problemVo);
		} else {
			trainingRepository.updateTrainingProblem(problemVo);
		}
	}

	public void findAndDelete(Long authUserNo, Long problemNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("authUserNo", authUserNo);
		map.put("problemNo", problemNo);
		
		Long saveNo = trainingRepository.findSaveNo(map);
		
		List<SavePathVo> savePathVoList = trainingRepository.findSavePathNo(saveNo);
		map.put("savePathVoList", savePathVoList);
		trainingRepository.deleteCode(map);
		trainingRepository.deleteSavePath(saveNo);
		trainingRepository.deleteSaveByProblemNo(map);
		
		TrainingLinux trainingLinux = new TrainingLinux();
		trainingLinux.deleteSaveProblem(authUserNo, problemNo);
	}

	public void insertCode(Long saveNo) {
		List<SavePathVo> savePathVoList = trainingRepository.findSavePathNo(saveNo);
		
		Map<String, Object> map = new HashMap<>();
		map.put("savePathVoList", savePathVoList);
		
		String[] langArray = { "c", "cpp", "cs", "java", "js", "py" };
		map.put("langArray", langArray);
		
		trainingRepository.insertSubProblemFaceCode(map);
	}

	public List<Long> findSubProblemNo(Long problemNo) {
		return trainingRepository.findSubProblemNo(problemNo);
	}

}