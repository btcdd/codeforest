package com.btcdd.codeforest.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.btcdd.codeforest.dto.JsonResult;
import com.btcdd.codeforest.runlanguage.RunPy;

@Controller
@RequestMapping("/compile")
public class CompileControllerPy {
	
	StringBuffer buffer = new StringBuffer();

	RunPy rtt = new RunPy();
	
	@ResponseBody
	@PostMapping("/py")
	public JsonResult javaCompile(@RequestParam String code) {
		
		String[] token = code.split("\n");
		
		buffer.append("# -*- coding: utf-8 -*-\n");
		
		for(int i = 0; i < token.length; i++) {
			buffer.append(token[i] + "\n");
		}
		rtt.createFileAsSource(buffer.toString());
		rtt.execCompile();
		String result = rtt.execCommand();
		String errorResult = rtt.execCompile();
		
		String[] res = new String[2];
		res[0] = result;
		res[1] = errorResult;
		
		return JsonResult.success(res);
	}
}