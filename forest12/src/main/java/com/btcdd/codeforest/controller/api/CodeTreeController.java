package com.btcdd.codeforest.controller.api;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
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
		int p = Integer.parseInt(page);
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
	public JsonResult fileInsert(Long savePathNo,String language,String fileName,Long subProblemNo, String packagePath, HttpSession session) {

		boolean exist = codetreeService.existFile(fileName,savePathNo); // false면 존재하지 않고 true면 존재한다
		
		Map<String,Object> map = new HashMap<>();
				
		if(!exist) {
			codetreeService.insertFile(savePathNo,language,fileName);
			
			String[] split = fileName.split("\\.");
			
			String codeValue = "public class " + split[0] + " {\n\n}";
			codeTreeLinux.createFileAsSource(codeValue, packagePath + "/" + language + "/" + fileName);
			
			Long codeNo = codetreeService.findCodeNo(savePathNo,fileName);
			
			map.put("fileName", fileName);
			map.put("savePathNo", savePathNo);
			map.put("codeNo",codeNo);
		}else {
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
		boolean exist = codetreeService.existFile(fileName,savePathNo); //false면 존재하지 않고 true면 존재한다
		Map<String,Object> map = new HashMap<>();

		if(!exist) {
			codetreeService.updateFile(codeNo,fileName);
		} else {
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
		// 관우 유진 코드
		//////////
		if("c".equals(language) || "cpp".equals(language)) {
			try {
				Runtime.getRuntime().exec("mkdir " + packagePath + "/" + language + "/Main");
				
				Thread.sleep(300);
				
				codeTreeLinux.createFileAsSourceFake(codeValue, packagePath + "/" + language + "/Main/" + fileName);
				
				Thread.sleep(500);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		codeTreeLinux.createFileAsSource(codeValue, packagePath + "/" + language + "/" + fileName);
		
		//////////
		return JsonResult.success(null);
	}
	@Auth
	@PostMapping("/submit")
	public JsonResult Submit(String language, String fileName, String packagePath,
			Long subProblemNo,String codeValue, Long problemNo,
			String compileResult1, Boolean compileResult2, String outputResult, HttpSession session) {
		
		UserVo authUser = (UserVo)session.getAttribute("authUser");	
		
		String examOutput = codetreeService.getExamOutput(subProblemNo);
		
		boolean compileResult = true;
		boolean compileError = false;
		
		Map<String, Object> map = new HashMap<>();
		
		String[] examOutputSplit = {};
		String[] outputResultSplit = {};
		
		examOutputSplit[0] = examOutput;
		outputResultSplit[0] = outputResult;
		
		try {
			File file = new File("examOutputSplit.txt");
			BufferedWriter bufferWriter = new BufferedWriter(new FileWriter(file, false));
			
			String str = examOutputSplit.length + "_\n" + outputResultSplit.length + "_\n" + examOutputSplit[0] + "_\n" + outputResultSplit[0] + "_";
			
			bufferWriter.write(str);
			bufferWriter.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		if(examOutput.contains("<br />") ) {
			examOutputSplit = examOutput.split("<br />");
			outputResultSplit =outputResult.split("\n");
		}
		
		try {
			File file = new File("examOutputSplit.txt");
			BufferedWriter bufferWriter = new BufferedWriter(new FileWriter(file, false));
			
			String str = examOutputSplit.length + "_\n" + outputResultSplit.length + "_\n" + examOutputSplit[0] + "_\n" + examOutputSplit[1] + "_\n" + outputResultSplit[0] + "_\n" + outputResultSplit[1] + "_";
			
			bufferWriter.write(str);
			bufferWriter.flush(); 
		} catch (IOException e) {
			e.printStackTrace();
		}	
		
		if(compileResult2 == false) {
			if(examOutputSplit.length == outputResultSplit.length) {
				for(int i = 0; i < examOutputSplit.length; i++) {
					if(examOutputSplit[i].equals(outputResultSplit[i]) == false) {
						compileResult = false;
						compileError = false;
						break;
					}
					else {
						compileResult = true;
						compileError = false;
					}
				}
			} else {
				compileResult = false;
				compileError = false;
			}
		}
		else {
			compileError = true;
			compileResult = false;
		}
		
		map.put("compileError", compileError);
		map.put("compileResult", compileResult);

		codetreeService.submitSubProblem(authUser.getNo(),subProblemNo,codeValue,language, compileResult);//정보 삽입
		
		SubmitVo submitVo = codetreeService.findSubmitNoBySubProblem(authUser.getNo(),subProblemNo, language);
		
		codetreeService.increaseAttemptCount(submitVo.getNo());//시도횟수 증가
		
		/////// [User] AnswerCount increase method
		if(compileResult == true) {
			codetreeService.updateUserAnswerCount(authUser.getNo());
		}
		/////////////////////////////////////////
		
		return JsonResult.success(map);
	}		
}


