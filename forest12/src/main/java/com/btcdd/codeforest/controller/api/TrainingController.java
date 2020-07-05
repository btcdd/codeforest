package com.btcdd.codeforest.controller.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.btcdd.codeforest.dto.JsonResult;
import com.btcdd.codeforest.linux.CodeTreeLinux;
import com.btcdd.codeforest.linux.TrainingLinux;
import com.btcdd.codeforest.service.TrainingService;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.UserVo;

@RestController("TrainingController")
@RequestMapping("/api/training")
public class TrainingController {

	@Autowired
	private TrainingService trainingService;  
	
	private TrainingLinux trainingLinux = new TrainingLinux();
	
	private CodeTreeLinux codeTreeLinux = new CodeTreeLinux();

	@PostMapping(value = "/list")
	public JsonResult originProblemList(String page, String kwd, String category, String[] checkValues) {

		int p = Integer.parseInt(page);
		Map<String, Object> map = trainingService.getContentsList(p, kwd, category, checkValues);
		
		return JsonResult.success(map);
	}
	

	@PostMapping("/answerlist")
	public JsonResult answerList(String page, String language, String subProblemNo) {

		int p = Integer.parseInt(page);
		Map<String, Object> map = trainingService.selectAnswerUserList(p, Long.parseLong(subProblemNo), language);

		return JsonResult.success(map);
	}

	@PostMapping("/savepandan")
	public JsonResult savePandan(Long problemNo, HttpSession session) {

		UserVo authUser = (UserVo) session.getAttribute("authUser");
		Long saveNo = trainingService.findSaveNo(authUser.getNo(), problemNo);
		
		return JsonResult.success(saveNo);
	}
	
	@PostMapping("/save/problem")
	public JsonResult saveProblem(Long problemNo, HttpSession session, Long[] subProblemNoArray) {

		UserVo authUser = (UserVo) session.getAttribute("authUser");

		trainingService.insertSaveProblemNo(authUser.getNo(), problemNo);
		Long saveNo = trainingService.findSaveNo(authUser.getNo(), problemNo);
		
		trainingService.insertSavePath(subProblemNoArray, saveNo, authUser.getNo(), problemNo);
		
		trainingService.insertCode(saveNo);
	
		trainingLinux.save(authUser.getNo(), problemNo, subProblemNoArray);

		return JsonResult.success(null);
	}
	
	@PostMapping("/delete")
	public JsonResult delete(Long problemNo, HttpSession session, Long[] array) {

		UserVo authUser = (UserVo) session.getAttribute("authUser");
		
		trainingService.findAndDelete(authUser.getNo(), problemNo);

		return JsonResult.success(null);
	}

	@PostMapping("/recommend")
	public JsonResult recommend(Long problemNo, HttpSession session) {

		UserVo authUser = (UserVo) session.getAttribute("authUser");

		Map<String, Object> map = trainingService.updateRecommend(authUser.getNo(), problemNo);

		return JsonResult.success(map);
	}
	
	@PostMapping("/recommend/origin")
	public JsonResult recommendOrigin(Long problemNo, HttpSession session) {

		UserVo authUser = (UserVo) session.getAttribute("authUser");

		Map<String, Object> map = trainingService.originRecommend(authUser.getNo(), problemNo);

		return JsonResult.success(map);
	}
	
	@PostMapping("/linux/savecode")
	public JsonResult linuxSaveCode(Long problemNo, HttpSession session, Long[] subProblemNoArray) {
		UserVo authUser = (UserVo) session.getAttribute("authUser");

		trainingLinux.linuxSaveCode(authUser.getNo(), problemNo, subProblemNoArray);

		return JsonResult.success(null);
	}
	 
	// 코드 보기 눌렀을 때 파일 찾아오기!
	@PostMapping("/find-code")
	public JsonResult findCode(Long subProblemNo, Long userNo, String language) {
		
		List<SavePathVo> list = trainingService.findSavePathAndFileName(subProblemNo, userNo, language);
		List<String> fileNames = new ArrayList();
		List<String> codes = new ArrayList();
		Map<String, Object> map = new HashMap<>();
		for(int i = 0; i < list.size(); i++) {
			fileNames.add(list.get(i).getFileName());
			codes.add("ㅋㅋㅋ");
		}
		
		map.put("fileNames", fileNames);	
		map.put("codes", codes);
		
		return JsonResult.success(map);
	}
	
}
