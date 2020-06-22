package com.btcdd.codeforest.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.btcdd.codeforest.vo.UserVo;

@Controller
public class MainController {
	
	@RequestMapping({"", "/main"})
	public String index(Model model) {
		return "main/main";
	}
	
	@RequestMapping(value = "/chatting.do", method = RequestMethod.GET)
	   public ModelAndView chat(ModelAndView mv, HttpSession session) {
	      mv.setViewName("chat/chattingview");
	      
	      //사용자 정보 출력(세션)//
	      UserVo user = (UserVo) session.getAttribute("authUser");
	      System.out.println("user name :" + user.getNickname());
	            
	      System.out.println("normal chat page");
	      
	      mv.addObject("userid", user.getNickname());
	      
	      return mv;
	}
}