package com.btcdd.codeforest.controller.api;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.btcdd.codeforest.dto.JsonResult;
import com.btcdd.codeforest.service.CodeTreeService;
import com.btcdd.codeforest.service.CodingTestService;
import com.btcdd.codeforest.service.TrainingService;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.UserVo;

@RestController("TestController")
@RequestMapping("/api/codingtest")
public class CodingTestController {

	@Autowired
	private CodingTestService testService;

	@Autowired
	private TrainingService trainingService;
	
	@Autowired
	private CodeTreeService codeTreeService;
	
	UserVo _authUser = null;
	
	@PostMapping("/search")
	public JsonResult search(@RequestParam("keyword") String keyword) {
		Map<String, Object> map = new HashMap<>(); 
		
		List<ProblemVo> list = testService.selectTestList();
		
		HashMap<Long, Long> dday = new HashMap<Long, Long>();
		
		Calendar today = Calendar.getInstance();
		Calendar d = Calendar.getInstance();
		today.set(Calendar.MONTH, today.get(Calendar.MONTH)+1);

		String[] fake_token = null;
		String[] token = null;

		long l_today = today.getTimeInMillis() / (24*60*60*1000);
		long l_dday = 0;
		long result = 0;
		
		for(ProblemVo vo : list) {
			if(vo.getPriority() == 2) {
				fake_token = (vo.getStartTime()+"").split(" ");
				token = fake_token[0].split("-");
				d.set(Integer.parseInt(token[0]), Integer.parseInt(token[1]), Integer.parseInt(token[2]));
				l_dday = d.getTimeInMillis() / (24*60*60*1000);
				result = l_today - l_dday;
				dday.put(vo.getNo(), result);
			}
		}

		map.put("dday", dday);

		List<ProblemVo> list1 = new ArrayList<ProblemVo>();
		List<ProblemVo> list2 = new ArrayList<ProblemVo>();
		List<ProblemVo> list3 = new ArrayList<ProblemVo>();

		for(ProblemVo vo : list) {
			if(!keyword.equals("") && vo.getTitle().contains(keyword) || vo.getNickname().contains(keyword) || vo.getStartTime().contains(keyword) || vo.getEndTime().contains(keyword)) {

				vo.setStartTime((vo.getStartTime()+"").replace(keyword, "<span style='background:yellow; color:black'>"+keyword+"</span>"));
				vo.setEndTime(vo.getEndTime().replace(keyword, "<span style='background:yellow; color:black'>"+keyword+"</span>"));
				vo.setTitle(vo.getTitle().replace(keyword, "<span style='background:yellow; color:black'>"+keyword+"</span>"));
				vo.setNickname(vo.getNickname().replace(keyword, "<span style='background:yellow; color:black'>"+keyword+"</span>"));
				
				if(vo.getPriority() == 1) {
					list1.add(vo);
				}
				if(vo.getPriority() == 2) {
					list2.add(vo);
				}
				if(vo.getPriority() == 3) {
					list3.add(vo);
				}
			}
		}
		
		map.put("list1", list1);
		map.put("list2", list2);
		map.put("list3", list3);

		return JsonResult.success(map);
	}
}




/*
// react 코딩테스트 로그인폼경로 
@PostMapping("/auth/{userEmail}/{problemNo}")
public JsonResult auth(@PathVariable("userEmail") String userEmail, @PathVariable("problemNo") Long problemNo,
		@RequestBody Map<String, Object> user) {
	
	// 관우 코드
	////////////////////////////
			
	UserVo authUser = testService.findUserByEmail(userEmail);
	_authUser = authUser;
			
	///////////////
	
	Map<String, Object> map = new HashMap<>();
	JSONParser parser = new JSONParser();
	JSONObject obj = null;
	try {
		obj = (JSONObject) parser.parse((String) user.get("body"));
	} catch (ParseException e) {
		e.printStackTrace();
	}
	System.out.println("obj>>>" + obj);
	String userName = (String) obj.get("name");
	String userBirth = (String) obj.get("birth");
	if (userBirth.equals("") || userName.equals("")) {
		map.put("result", "empty");
		return JsonResult.success(map);
	}
	String tempKey = (String) obj.get("tempKey");
	boolean exist = trainingService.existUser(userEmail); // 유저가 있는지 체크
	ProblemVo problemVo = trainingService.selectProblemOne(problemNo);
	if (problemVo == null || problemVo.getState().equals("n")) {
		System.out.println(
				"http://localhost:9999/?userEmail=2sang@gmail.com&problemNo=123123134 처럼 직접 경로타고 번호 아무렇게나 쓰고 올경우");
		map.put("result", "delete");
		return JsonResult.success(map);
	}
	// 유저가 존재하는데 상태가 n이면 삭제 상태
	if (exist && problemVo.getPassword().equals(tempKey)) { // 인증키가 맞고 유저가 존재한다면
		trainingService.insertUserInfo(userName, userBirth, userEmail);
		codeTreeService.saveUserCodeAndProblems(authUser.getNo(), problemNo);
		
		map.put("result", "ok");
		return JsonResult.success(map);
	}
	map.put("result", "no");
	return JsonResult.success(map);
}	
// 인증번호가 통과하고 나서 들어가지는 경로 - container
@PostMapping("/mylist/{userEmail}/{problemNo}")
public JsonResult mylist(@PathVariable("userEmail") String userEmail,
		@PathVariable("problemNo") Long problemNo) {
	
	
		Map<String, Object> map = new HashMap<>();
		
		
		ProblemVo problemVo = trainingService.selectProblemOne(problemNo);
		List<SubProblemVo> list = trainingService.selectSubProblem(problemNo);
		
		System.out.println("problemVo>>>>"+problemVo);
		System.out.println("list>>>>"+list);
		map.put("problemVo", problemVo);
		map.put("list", list);
	
		//////////////////////////////////
		// 관우 유진 코드
		// 아직 쓸모없음
//		Long saveNo = trainingService.selectSaveNo(_authUser.getNo(), problemVo.getNo());
//
//		List<SavePathVo> savePathVoList = trainingService.selectSavePath(saveNo);
//		Long[] savePathNoArray = new Long[savePathVoList.size()];
//		for (int i = 0; i < savePathVoList.size(); i++) {
//			savePathNoArray[i] = savePathVoList.get(i).getNo();
//		}
//		List<CodeVo> codeVoList = trainingService.selectCode(savePathNoArray);
//		map.put("savePathVoList", savePathVoList);
//		map.put("codeVoList", codeVoList);
		///////////////////////////////
	return JsonResult.success(map);
}	
//리액트에서 파일 추가 경로
@PostMapping("/fileInsert/{userEmail}/{problemNo}/{subProblemNo}")
public JsonResult fileInsert(@PathVariable("userEmail") String userEmail,
		@PathVariable("problemNo") Long problemNo,
		@PathVariable("subProblemNo") Long subProblemNo,
		@RequestBody Map<String, Object> file) {
	
	Map<String, Object> map = new HashMap<>();
	JSONParser parser = new JSONParser();
	JSONObject obj = null;
	
	try {
		obj = (JSONObject) parser.parse((String) file.get("body"));
	} catch (ParseException e) {
		e.printStackTrace();
	}		
	String fileName = (String) obj.get("fileName");
	System.out.println("fileName"+fileName);
	
	System.out.println("problemNo >>>>> "+problemNo);
	System.out.println("subProblemNo >>>>> "+subProblemNo);
	System.out.println("fileName>>>>> " + fileName);
	
	UserVo authUser = testService.findUserByEmail(userEmail);
	
//	codeTreeService.saveUserCodeAndProblems(authUserNo, subProblemNo, savePathVoList, codeVoList)
	
//	List<SavePathVo> savePathVoList = trainingService.selectSavePath(saveNo);
//	Long[] savePathNoArray = new Long[savePathVoList.size()];
//	for(int i = 0; i < savePathVoList.size(); i++) {
//	savePathNoArray[i] = savePathVoList.get(i).getNo();
//	}
//	List<CodeVo> codeVoList = trainingService.selectCode(savePathNoArray);
//	map.put("savePathVoList",savePathVoList);
//	map.put("codeVoList",codeVoList);
	return JsonResult.success(null);
}
//리액트에서 파일 삭제
@PostMapping("/fileDelete/{userEmail}/{problemNo}/{subProblemNo}")
public JsonResult fileDelete(@PathVariable("userEmail") String userEmail,
		@PathVariable("problemNo") Long problemNo,
		@PathVariable("subProblemNo") Long subProblemNo,
		@RequestBody Map<String, Object> file) {
	
	Map<String, Object> map = new HashMap<>();
	JSONParser parser = new JSONParser();
	JSONObject obj = null;
	try {
		obj = (JSONObject) parser.parse((String) file.get("body"));
	} catch (ParseException e) {
		e.printStackTrace();
	}		
	String fileName = (String) obj.get("fileName");
	System.out.println("fileName"+fileName);
	
	return JsonResult.success(null);
}
*/