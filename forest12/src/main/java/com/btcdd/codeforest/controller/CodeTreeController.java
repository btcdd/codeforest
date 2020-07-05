package com.btcdd.codeforest.controller;


import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.btcdd.codeforest.service.CodeTreeService;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.UserVo;
import com.btcdd.security.Auth;

@Auth
@Controller
@RequestMapping("/codetree")
public class CodeTreeController {
	@Autowired
	private CodeTreeService codeTreeService;
	

	@Auth
	@RequestMapping("/list")
	public String mypage() {
		return "codetree/list";
	}
	
	@Auth
	@RequestMapping("/practice")
	public String practice() {
		return "codetree/layout";
	}
	
	@Auth
	@RequestMapping("/{saveNo}")
	public String mirror(@PathVariable("saveNo") Long saveNo, Model model, HttpSession session) {
		SaveVo saveVo = codeTreeService.findSaveVo(saveNo);
		List<SavePathVo> savePathList = codeTreeService.findSavePathList(saveVo.getNo());
		List<CodeVo> codeList = codeTreeService.findCodeList(savePathList.get(0).getNo());
		for(int i = 1; i < savePathList.size(); i++) {
			codeList.addAll(codeTreeService.findCodeList(savePathList.get(i).getNo()));
		}
		List<SubProblemVo> subProblemList = codeTreeService.findSubProblemList(saveVo.getProblemNo());
		
		UserVo authUser = (UserVo)session.getAttribute("authUser");
		if(authUser.getNo() != saveVo.getUserNo()) {
			return "redirect:/main-in";
		}
		
		model.addAttribute("saveVo", saveVo);
		model.addAttribute("savePathList", savePathList);
		model.addAttribute("codeList", codeList);
		model.addAttribute("subProblemList", subProblemList);
		model.addAttribute("authUserNo", authUser.getNo());
		
		return "codetree/codetree";
	}
}
 