package com.btcdd.codeforest.controller.api;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.btcdd.codeforest.dto.JsonResult;
import com.btcdd.codeforest.linux.CodeTreeLinux;
import com.btcdd.codeforest.service.CodeTreeService;
import com.btcdd.codeforest.service.CodingTestService;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.ProblemVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubmitVo;
import com.btcdd.codeforest.vo.UserVo;
import com.btcdd.security.Auth;

@RestController("TestController")
@RequestMapping("/api/codingtest")
public class CodingTestController {

	@Autowired
	private CodingTestService testService;

	CodeTreeLinux codeTreeLinux = new CodeTreeLinux();
	
	
	
	@Autowired 
	private CodeTreeService codetreeService;	
	
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
	
	
	
	
	
	
	
	
	
	
	@Auth
	@PostMapping("/fileInsert")
	public JsonResult fileInsert(Long savePathNo,String language,String fileName,Long subProblemNo, HttpSession session) {
		UserVo authUser = (UserVo)session.getAttribute("authUser");

		Long problemNo = codetreeService.findProblemNo(subProblemNo);
		boolean exist = codetreeService.existFile(fileName,savePathNo); //false면 존재하지 않고 true면 존재한다
		
		System.out.println("exist>>>>"+exist);
		
		Map<String,Object> map = new HashMap<>();
				
		if(!exist) {
			System.out.println("기존 존재하지 않는다");
			codetreeService.insertFile(savePathNo,language,fileName);
			
			CodeTreeLinux codetreeLinux = new CodeTreeLinux();
			codetreeLinux.insertCode(authUser.getNo(), problemNo, subProblemNo, language, fileName);
			
			Long codeNo = codetreeService.findCodeNo(savePathNo,fileName);
			System.out.println("codeNo>>"+codeNo);
			map.put("fileName", fileName);
			map.put("savePathNo", savePathNo);
			map.put("codeNo",codeNo);
		}else {
			System.out.println("기존파일이 존재한다");
			map.put("result", "no");
		}
		
		return JsonResult.success(map);
	}	
	
	@Auth
	@DeleteMapping("/fileDelete/{codeNo}")
	public JsonResult deleteFile(@PathVariable("codeNo") Long codeNo) {
		CodeVo codeVo = codetreeService.findSavePathNoAndFileName(codeNo);
		boolean result = codetreeService.deleteFile(codeNo);
		
		SavePathVo savePathVo = codetreeService.findSavePathVo(codeVo.getSavePathNo());
		

		CodeTreeLinux codeTreeLinux = new CodeTreeLinux();
		codeTreeLinux.deleteCode(savePathVo.getPackagePath(), codeVo.getLanguage(), codeVo.getFileName());


		return JsonResult.success(result ? codeNo : -1);
	}	

	@Auth
	@PostMapping("/fileUpdate")
	public JsonResult fileUpdate(Long savePathNo,Long codeNo,String fileName,Long subProblemNo,String prevFileName,Model model) {
		System.out.println("savePathNo>>"+savePathNo);
		System.out.println("codeNo>>"+codeNo);
		System.out.println("fileName>>"+fileName);
		System.out.println("prevFileName"+prevFileName);
		boolean exist = codetreeService.existFile(fileName,savePathNo); //false면 존재하지 않고 true면 존재한다
		Map<String,Object> map = new HashMap<>();
		
		if(!exist) {
			System.out.println("기존 존재하지 않는다");
			codetreeService.updateFile(codeNo,fileName);
			// 여기!!
		}else {
			System.out.println("기존파일이 존재한다");
			map.put("result", "no");
		}
		
		return JsonResult.success(map);
	}		
	
	
	
	@Auth
	@PostMapping("/file-list")
	public JsonResult fileList(Long saveNo, String language) {
		SaveVo saveVo = codetreeService.findSaveVo(saveNo);
		List<SavePathVo> savePathList = codetreeService.findSavePathList(saveVo.getNo());
		List<CodeVo> codeList = codetreeService.findCodeList(savePathList.get(0).getNo());
		for(int i = 1; i < savePathList.size(); i++) {
			codeList.addAll(codetreeService.findCodeList(savePathList.get(i).getNo()));
		}

		
		Iterator<CodeVo> iterator = codeList.iterator();
		while(iterator.hasNext()) {
			CodeVo it = iterator.next();
			if(!it.getLanguage().equals(language)) {
				iterator.remove();
			}
		}
		System.out.println(">>>>123123>>>>>>>>>>>>>>>>>>"+codeList);
		List<SubProblemVo> subProblemList = codetreeService.findSubProblemList(saveVo.getProblemNo());
		
		Map<String,Object> map = new HashMap<>();
		map.put("saveVo", saveVo);
		map.put("savePathList", savePathList);
		map.put("codeList", codeList);
		map.put("subProblemList", subProblemList);
		
		return JsonResult.success(map);
	}	

	

	@Auth
	@PostMapping("/find-code")
	public JsonResult findCode(String language, String packagePath, String fileName) {
		// 여기야 여기!
		CodeTreeLinux codetreeLinux = new CodeTreeLinux();
		String code = codetreeLinux.findCode(packagePath, language, fileName);
		return JsonResult.success(code);
	}
	
	@Auth
	@PostMapping("/run")
	public JsonResult Run(String language, String packagePath, String fileName,Long subProblemNo,String codeValue, Long problemNo,
							HttpSession session) {
		// 관우 유진 코드
		/////////////////////
		Map<String, Object> map = new HashMap<>();
		
		switch(language) {
		case "c": 
			map = codeTreeLinux.cCompile(fileName, packagePath, language);
			break;
		case "cpp": 
			map = codeTreeLinux.cppCompile(fileName, packagePath, language);
			break;
		case "cs": 
			map = codeTreeLinux.csCompile(fileName, packagePath, language);
			break;
		case "java": 
			map = codeTreeLinux.javaCompile(fileName, packagePath, language);
			break;
		case "js": 
			map = codeTreeLinux.jsCompile(fileName, packagePath, language);
			break;
		case "py": 
			map = codeTreeLinux.pyCompile(fileName, packagePath, language);
			break;
		}
		
		//////////////////////
		
		return JsonResult.success(map);
	}
	
	@Auth
	@PostMapping("/save")
	public JsonResult Save(String language, String fileName, String packagePath,Long subProblemNo,String codeValue, Long problemNo) {
		//db에 저장 필요
		
		// 관우 유진 코드
		//////////
		codeTreeLinux.createFileAsSource(codeValue, packagePath + "/" + language + "/" + fileName);
		
		//////////
		return JsonResult.success(null);
	}
	@Auth
	@PostMapping("/submit")
	public JsonResult Submit(String language, String fileName, String packagePath,
			Long subProblemNo,String codeValue, Long problemNo,
			String compileResult1, String compileResult2,HttpSession session) {
		
		UserVo authUser = (UserVo)session.getAttribute("authUser");	
		
		String examOutput = codetreeService.getExamOutput(subProblemNo);
		
		boolean compileResult = false;
		boolean compileError = false;
 		
		Map<String, Object> map = new HashMap<>();
		
		
		if(compileResult2 == null || compileResult2.equals("")) {
			if(compileResult1.equals(examOutput)) {
				compileResult = true;
			}
		} else {
			compileError = true;
		}
		map.put("codeValue", codeValue);
		map.put("subProblemNo",subProblemNo);
		map.put("language",language);
//		codetreeService.submitSubProblem(authUser.getNo(),subProblemNo,codeValue,language, compileResult);//정보 삽입
//		SubmitVo submitVo = codetreeService.findSubmitNoBySubProblem(authUser.getNo(),subProblemNo, language);
//		codetreeService.increaseAttemptCount(submitVo.getNo());//시도횟수 증가
		
		map.put("compileResult", compileResult);
		map.put("compileError", compileError);
		
		
		
		return JsonResult.success(map);
	}			
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}




