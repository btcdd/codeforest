package com.btcdd.codeforest.controller.api;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.btcdd.codeforest.dto.JsonResult;
import com.btcdd.codeforest.linux.CodeTreeLinux;
import com.btcdd.codeforest.service.CodeTreeService;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubmitVo;
import com.btcdd.codeforest.vo.UserVo;
import com.btcdd.security.Auth;

@RestController("CodeTreeController")
@RequestMapping("/api/codetree")
public class CodeTreeController {

	
	@Autowired 
	private CodeTreeService codetreeService;
	
	CodeTreeLinux codeTreeLinux = new CodeTreeLinux();
	
	@Auth
	@PostMapping(value="/list")// main-header에서 처음 열때
	public JsonResult codeTree(String page, String kwd,HttpSession session) {
		UserVo authUser = (UserVo)session.getAttribute("authUser");
		System.out.println("kwd>>>>"+kwd);
		int p = Integer.parseInt(page);
		System.out.println("p>>>"+p);
		Map<String, Object> map = codetreeService.getContentsList(p,kwd,authUser.getNo());
		map.get("list");
		
		return JsonResult.success(map);
	}
	
	@Auth
	@PostMapping(value="/codemirror")// Code Tree에서 리스트 창 띄울때
	public JsonResult codemirror(Long saveNo) {
		Map<String, Object> map = new HashMap<>();
		map.put("saveNo",saveNo);				
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
	public JsonResult fileUpdate(Long savePathNo,Long codeNo,String fileName,Long subProblemNo,String prevFileName) {
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
		
		String[] examOutputSplit = examOutput.split("\n");
		String[] compileResult1Split =compileResult1.split("\n");
		

		
		
		if(compileResult2 == null || compileResult2.equals("")) {
			for(int i=0;i<examOutputSplit.length;i++) {
				String tempString1 = examOutputSplit[i];
				String tempString2 = compileResult1Split[i];
				if(tempString1.contentEquals(tempString2)) {
					compileResult = true;
				}else {
					compileResult = false;
				}
			}				
			codetreeService.submitSubProblem(authUser.getNo(),subProblemNo,codeValue,language, compileResult);//정보 삽입
			SubmitVo submitVo = codetreeService.findSubmitNoBySubProblem(authUser.getNo(),subProblemNo, language);
			codetreeService.increaseAttemptCount(submitVo.getNo());//시도횟수 증가				
		} else {
			compileError = true;
		}
		
		 

		
		map.put("compileResult", compileResult);
		map.put("compileError", compileError);
		
		
		
		return JsonResult.success(map);
	}		
}


