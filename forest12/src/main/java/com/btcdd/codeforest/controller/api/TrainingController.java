package com.btcdd.codeforest.controller.api;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.btcdd.codeforest.dto.JsonResult;
import com.btcdd.codeforest.linux.TrainingLinux;
import com.btcdd.codeforest.service.TrainingService;
import com.btcdd.codeforest.vo.UserVo;

@RestController("TrainingController")
@RequestMapping("/api/training")
public class TrainingController {

	@Autowired
	private TrainingService trainingService;  
	
	private TrainingLinux trainingLinux = new TrainingLinux();

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
}

/*
package com.compile.compiletest.controller.api;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.compile.compiletest.dto.JsonResult;
import com.compile.compiletest.service.TrainingService;
import com.compile.compiletest.vo.ProblemVo;
import com.compile.compiletest.vo.UserVo;
@RestController("CodeTrainingController")
@RequestMapping("/api/codetraining")
public class CodeTrainingController {
	@Autowired
	private TrainingService trainingService;
	UserVo _authUser = null;
	
	@GetMapping("/mylist/{problemNo}") //view.jsp에서 get방식으로 열때 경로
	public JsonResult codeTree(@PathVariable("problemNo") Long problemNo,HttpSession session) {
		Map<String, Object> map = new HashMap<>();
		
		_authUser = (UserVo) session.getAttribute("authUser");
		ProblemVo problemVo = trainingService.selectProblemOne(problemNo);
		map.put("problemVo", problemVo);
		map.put("authUser", _authUser);
		System.out.println("problemNo만 있을 때");
		return JsonResult.success(map);
	}	
	
	// 리액트에서 CodeTrainingErrorPage와 통신하는 위치
	@PostMapping("/training/{userEmail}/{problemNo}")
	public JsonResult codingTrainingAccess(@PathVariable("userEmail") String userEmail,
			@PathVariable("problemNo") Long problemNo) {
		
		Map<String, Object> map = new HashMap<>();
		
		boolean exist = trainingService.existUser(userEmail); //유저가 있는지 체크
		if(!exist || userEmail=="undifiend") {
			System.out.println("유저가 존재하지 않는다!!!");
			map.put("result", "emptyUser");
			return JsonResult.success(map);
		}
		System.out.println("_authUser>>>>"+_authUser);
		if(_authUser == null) {
			System.out.println("잘못된 접근 경로 !!!");
			map.put("result", "wrongAccess");
			return JsonResult.success(map);
		}
		System.out.println("정상 경로 !!!");
		
		
		map.put("result", "ok");
		
		return JsonResult.success(map);
	}		
	
}
*/