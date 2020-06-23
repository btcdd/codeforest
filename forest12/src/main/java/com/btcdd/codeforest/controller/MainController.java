package com.btcdd.codeforest.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.btcdd.security.Auth;

@Controller
public class MainController {
	
//	@Auth
	@RequestMapping({"", "/main"})
	public String index(Model model) {
		return "main/main";
	}
	
}