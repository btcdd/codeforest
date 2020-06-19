package com.btcdd.codeforest.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.btcdd.codeforest.service.CodeTreeService;
import com.btcdd.codeforest.service.CodingTestService;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.UserVo;
import com.btcdd.security.Auth;

@Controller
@RequestMapping("/codingtest")
public class CodingTestController {

	@Autowired
	private CodingTestService testService;
	@Autowired
	private CodeTreeService codeTreeService;

	@Auth
	@RequestMapping(value="", method=RequestMethod.GET)
	public String training(Model model) {
		List<ProblemVo> list = testService.selectTestList();
		
		List<ProblemVo> list1 = new ArrayList<ProblemVo>();
		List<ProblemVo> list2 = new ArrayList<ProblemVo>();
		List<ProblemVo> list3 = new ArrayList<ProblemVo>();
		for(ProblemVo vo : list) {
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
		model.addAttribute("list1", list1);
		model.addAttribute("list2", list2);
		model.addAttribute("list3", list3);

		HashMap<Long, Long> map = new HashMap<Long, Long>();

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
				map.put(vo.getNo(), result);
			}
		}
		
		model.addAttribute("dday", map);

		return "codingtest/list";
	}
	
	@Auth
	@RequestMapping(value="/write", method=RequestMethod.GET)
	public String testWrite() {

		return "codingtest/write";
	}
	
	@Auth
	@RequestMapping(value="/write", method=RequestMethod.POST)
	public String testWritePost() {

		return "codingtest/write";
	}
	
	@Auth
	@RequestMapping(value="/auth/{problemNo}", method=RequestMethod.GET)
	public String Auth(@PathVariable("problemNo") Long problemNo,Model model) {
		model.addAttribute("problemNo",problemNo);
		ProblemVo problemVo = testService.selectProblemOne(problemNo);
		model.addAttribute("problemVo",problemVo);
		model.addAttribute("tempKey",problemVo.getPassword());
		return "codingtest/auth";
	}
	@Auth
	@RequestMapping(value="/codemirror/{problemNo}", method=RequestMethod.POST)
	public String Codemirror(@PathVariable("problemNo") Long problemNo,
			@RequestParam("name") String name,
			@RequestParam("birth") String birth,
			@RequestParam("tempKey") String tempKey,
			HttpSession session,
			Model model) {
		UserVo authUser = (UserVo) session.getAttribute("authUser");

		ProblemVo problemVo = testService.selectProblemOne(problemNo);

		if(problemVo.getState().equals("y") && problemVo.getPassword().equals(tempKey)) {
			testService.insertUserInfo(name,birth,authUser.getNo());
			List<SubProblemVo> subProblemList = testService.findSubProblemList(problemNo);
			model.addAttribute("problemVo",problemVo);
			model.addAttribute("subProblemList",subProblemList);
			System.out.println("subProblemList>>>"+subProblemList);
			
			return "codingtest/code-mirror"; //이동
		}
		return "codingtest/auth";
	}	
//	@PostMapping("/auth/{userEmail}/{problemNo}")
//	public JsonResult auth(@PathVariable("userEmail") String userEmail, @PathVariable("problemNo") Long problemNo,
//			@RequestBody Map<String, Object> user) {
//		
//		// 관우 코드
//		////////////////////////////
//				
//		UserVo authUser = testService.findUserByEmail(userEmail);
//		_authUser = authUser;
//				
//		///////////////
//		
//		Map<String, Object> map = new HashMap<>();
//		JSONParser parser = new JSONParser();
//		JSONObject obj = null;
//		try {
//			obj = (JSONObject) parser.parse((String) user.get("body"));
//		} catch (ParseException e) {
//			e.printStackTrace();
//		}
//		System.out.println("obj>>>" + obj);
//		String userName = (String) obj.get("name");
//		String userBirth = (String) obj.get("birth");
//		if (userBirth.equals("") || userName.equals("")) {
//			map.put("result", "empty");
//			return JsonResult.success(map);
//		}
//		String tempKey = (String) obj.get("tempKey");
//		boolean exist = trainingService.existUser(userEmail); // 유저가 있는지 체크
//		ProblemVo problemVo = trainingService.selectProblemOne(problemNo);
//		if (problemVo == null || problemVo.getState().equals("n")) {
//			System.out.println(
//					"http://localhost:9999/?userEmail=2sang@gmail.com&problemNo=123123134 처럼 직접 경로타고 번호 아무렇게나 쓰고 올경우");
//			map.put("result", "delete");
//			return JsonResult.success(map);
//		}
//		// 유저가 존재하는데 상태가 n이면 삭제 상태
//		if (exist && problemVo.getPassword().equals(tempKey)) { // 인증키가 맞고 유저가 존재한다면
//			trainingService.insertUserInfo(userName, userBirth, userEmail);
//			codeTreeService.saveUserCodeAndProblems(authUser.getNo(), problemNo);
//			
//			map.put("result", "ok");
//			return JsonResult.success(map);
//		}
//		map.put("result", "no");
//		return JsonResult.success(map);
//	}		
	
}