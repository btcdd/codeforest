package com.btcdd.codeforest.controller;

import java.io.IOException;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.btcdd.codeforest.service.UserService;
import com.btcdd.codeforest.vo.UserVo;
import com.btcdd.security.Auth;
import com.btcdd.security.AuthUser;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private UserService userService;	
	
	@RequestMapping(value="/join", method=RequestMethod.GET)
	public String join(@ModelAttribute UserVo vo) {
		return "user/join";
	}
	
	@RequestMapping(value="/join", method=RequestMethod.POST)
	public String join(@ModelAttribute UserVo vo, BindingResult result, Model model) throws IOException, InterruptedException {
		if(result.hasErrors()) {
			model.addAllAttributes(result.getModel());
			return "/user/join";
		}
		userService.join(vo);
		return "redirect:/";
	}
		
	@RequestMapping(value="/login", method=RequestMethod.GET)
	public String login() {
		return "user/login";
	}
	
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(@AuthUser UserVo authUser, UserVo vo) {
		return "redirect:/";
	}
	
	@RequestMapping(value="/auth", method = RequestMethod.POST)
	public void auth() {
	}
	
	@Auth
	@RequestMapping(value="/logout", method = RequestMethod.GET)
	public void logout() {	
	}
	
	@RequestMapping(value="/find",method = RequestMethod.GET)
	public String find() {
		return "/user/find-password";
	}
	
	@RequestMapping(value="/reset",method=RequestMethod.POST)
	public String reset(@RequestParam("email") String email,Model model) {
		
		String nickname = userService.getNickname(email);
		model.addAttribute("email",email);
		model.addAttribute("nickname",nickname);
		return "/user/reset-password";
	}
	
	@RequestMapping(value="/change",method=RequestMethod.POST)
	public String change(@ModelAttribute @Valid UserVo vo,BindingResult result,Model model) {
		if(result.hasErrors()) {
			model.addAttribute("email",vo.getEmail());
			model.addAttribute("nickname",vo.getNickname());
			model.addAllAttributes(result.getModel());
			return "/user/reset-password";
		}		
		userService.updatePassword(vo);
		return "redirect:/user/login";
	}
	
}