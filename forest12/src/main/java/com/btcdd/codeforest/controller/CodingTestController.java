package com.btcdd.codeforest.controller;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.btcdd.codeforest.linux.TrainingLinux;
import com.btcdd.codeforest.service.CodingTestService;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.UserVo;
import com.btcdd.security.Auth;

@Controller
@RequestMapping("/codingtest")
public class CodingTestController {

	@Autowired
	private CodingTestService testService;
	
	private TrainingLinux trainingLinux = new TrainingLinux();
	
	
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
	public String Auth(@PathVariable("problemNo") Long problemNo,Model model,HttpSession session) {
		
		UserVo authUser = (UserVo) session.getAttribute("authUser");
		
		
		ProblemVo problemVo = testService.selectProblemOne(problemNo); //하나만 뽑혀야 하는데 여러개 뽑히는 오류 여기서 나는듯..
		
		

		
		Long existCount = testService.existSaveNo(authUser.getNo(),problemNo);
		
		if(existCount >=1) {
			System.out.println("바로 코드미러로"); 
			List<SubProblemVo> subProblemList = testService.findSubProblemList(problemNo);
			SaveVo saveVO = testService.findSaveVoByProblemNo(authUser.getNo(), problemNo);
			//태성 코드
			SaveVo saveVo = testService.findSaveVo(saveVO.getNo());
			List<SavePathVo> savePathList = testService.findSavePathList(saveVo.getNo());
			List<CodeVo> codeList = testService.findCodeList(savePathList.get(0).getNo());
			for(int i = 1; i < savePathList.size(); i++) {
				codeList.addAll(testService.findCodeList(savePathList.get(i).getNo()));
			}
			model.addAttribute("problemVo",problemVo);
			model.addAttribute("subProblemList",subProblemList);
			model.addAttribute("saveVo", saveVo);
			model.addAttribute("savePathList", savePathList);
			model.addAttribute("codeList", codeList);			
			
			System.out.println("problemVo>>>>"+problemVo);
			System.out.println("subProblemList>>>>"+subProblemList);
			System.out.println("saveVo>>>>"+saveVo);
			System.out.println("savePathList>>>>"+savePathList);
			System.out.println("codeList>>>>"+codeList);
			
			
			model.addAttribute("userStartTime",saveVO.getEnterTime());
			
			return "codingtest/code-mirror";
		}

		model.addAttribute("problemNo",problemNo);
		model.addAttribute("tempKey",problemVo.getPassword());
		model.addAttribute("problemVo",problemVo);
		
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

		ProblemVo problemVo = testService.selectProblemOne(problemNo); //하나 이상
		
		
		if(problemVo.getState().equals("y") && problemVo.getPassword().equals(tempKey)) {
			testService.insertUserInfo(name,birth,authUser.getNo());
			List<SubProblemVo> subProblemList = testService.findSubProblemList(problemNo);
			
			SaveVo saveVO = testService.findSaveVoByProblemNo(authUser.getNo(), problemNo);
			
			if(saveVO.getEnterTime() == null) {
				DateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				Date time = new Date();
				String userStartTime = format.format(time);
				Date userStartTime2 = null;
				try {
					userStartTime2 = format.parse(userStartTime);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				//관우-유진 코드
				/////////////////////////////////////////////////////////////////////////////////////				
				Long[] subProblemNoArray = new Long[subProblemList.size()];
				for(int i = 0; i < subProblemList.size(); i++) {
					subProblemNoArray[i] = subProblemList.get(i).getNo();
					System.out.println("subProblemNoArray[i]>>>>"+subProblemNoArray[i]);
				}				
				testService.insertSaveProblemNo(authUser.getNo(), problemNo,userStartTime2); //save에 저장 처음입장시간값 저장
				
				saveVO = testService.findSaveVoByProblemNo(authUser.getNo(), problemNo);
				
				testService.insertSavePath(subProblemNoArray, saveVO.getNo(), authUser.getNo(), problemNo);
				
				testService.insertCode(saveVO.getNo());
				
				trainingLinux.save(authUser.getNo(), problemNo, subProblemNoArray);				
				
				/////////////////////////////////////////////////////////////////////////////////////				
				
			}
			

			//태성 코드
			SaveVo saveVo = testService.findSaveVo(saveVO.getNo());
			List<SavePathVo> savePathList = testService.findSavePathList(saveVo.getNo());
			List<CodeVo> codeList = testService.findCodeList(savePathList.get(0).getNo());
			for(int i = 1; i < savePathList.size(); i++) {
				codeList.addAll(testService.findCodeList(savePathList.get(i).getNo()));
			}
			/////////////////////////////////////////////////////////////////////////////////////
			model.addAttribute("problemVo",problemVo);
			model.addAttribute("subProblemList",subProblemList);
			model.addAttribute("saveVo", saveVo);
			model.addAttribute("savePathList", savePathList);
			model.addAttribute("codeList", codeList);

			
			System.out.println("problemVo>>>>"+problemVo);
			System.out.println("subProblemList>>>>"+subProblemList);
			System.out.println("saveVo>>>>"+saveVo);
			System.out.println("savePathList>>>>"+savePathList);
			System.out.println("codeList>>>>"+codeList);
						

			
			model.addAttribute("userStartTime",saveVO.getEnterTime());
		
			
			
			return "codingtest/code-mirror"; //이동
		}
		
		
		return "codingtest/";
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