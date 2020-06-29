package com.btcdd.codeforest.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.btcdd.codeforest.service.CodeTreeService;
import com.btcdd.codeforest.service.MypageService;
import com.btcdd.codeforest.vo.CodeVo;
import com.btcdd.codeforest.vo.SavePathVo;
import com.btcdd.codeforest.vo.SaveVo;
import com.btcdd.codeforest.vo.SubProblemVo;
import com.btcdd.codeforest.vo.SubmitVo;
import com.btcdd.codeforest.vo.UserVo;
import com.btcdd.security.Auth;

@Controller
@RequestMapping("/mypage")
public class MypageController {
		
	@Autowired
	private MypageService mypageService;
	
	@Autowired
	private CodeTreeService codeTreeService;
	
	@Auth
	@RequestMapping(value="/mypage", method=RequestMethod.GET)
	public String mypage(HttpSession session, Model model) {
		UserVo authUser = (UserVo)session.getAttribute("authUser");
		List<SubmitVo> rightSubmit = mypageService.findRrightSubmit(authUser.getNo());
		
		List<SubmitVo> wrongSubmit = mypageService.findWrongSubmit(authUser.getNo());
		
		model.addAttribute("rightSubmit", rightSubmit);	
		model.addAttribute("wrongSubmit", wrongSubmit);	
		
		return "mypage/mypage";
	}
	
	@Auth
	@RequestMapping(value="/account", method=RequestMethod.GET)
	public String account() {
		return "mypage/account";
	}
	
	@Auth
	@RequestMapping(value="/problem", method=RequestMethod.GET)
	public String problem() {
		return "mypage/problem";
	}
	
	@Auth
	@RequestMapping("/codemirror/{saveNo}")
	public String mirror(@PathVariable("saveNo") Long saveNo, Model model, HttpSession session) {
		SaveVo saveVo = codeTreeService.findSaveVo(saveNo);
		List<SavePathVo> savePathList = codeTreeService.findSavePathList(saveVo.getNo());
		List<CodeVo> codeList = codeTreeService.findCodeList(savePathList.get(0).getNo());
		for(int i = 1; i < savePathList.size(); i++) {
			codeList.addAll(codeTreeService.findCodeList(savePathList.get(i).getNo()));
		}
		List<SubProblemVo> subProblemList = codeTreeService.findSubProblemList(saveVo.getProblemNo());
		
		UserVo writer = mypageService.findWriterByProblemNo(saveVo.getProblemNo());
		
		UserVo authUser = (UserVo)session.getAttribute("authUser");
		if(authUser.getNo() != writer.getNo()) {
			return "redirect:/main";
		}
		
		model.addAttribute("saveVo", saveVo);
		model.addAttribute("savePathList", savePathList);
		model.addAttribute("codeList", codeList);
		model.addAttribute("subProblemList", subProblemList);

		return "mypage/codetree";
	}
	
}