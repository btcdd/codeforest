package com.btcdd.codeforest.controller.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.btcdd.codeforest.dto.JsonResult;
import com.btcdd.codeforest.service.UserService;

@RestController("UserApiController")
@RequestMapping("/api/user")
public class UserController {

	@Autowired
	private UserService userService;

	@RequestMapping(value = "/checkemail", method = RequestMethod.POST)
	public JsonResult checkEmail(@RequestParam(value="email", required = true, defaultValue = "")String email) {
		boolean exist = userService.existUser(email);
		return JsonResult.success(exist);
	}
	
	@RequestMapping(value = "/nickname", method = RequestMethod.POST)
	public JsonResult checkNickname(@RequestParam(value="nickname", required = true, defaultValue = "")String nickname) {
		boolean exist = userService.existNickname(nickname);
		return JsonResult.success(exist);
	}

	@ResponseBody
	@PostMapping("emailAuth")
	public JsonResult emailAuth(
			@RequestParam(value="email",required=true,defaultValue="") String email,
			String pandan) {
		Boolean emailCheck = userService.existUser(email);
		if(!emailCheck && pandan == null) {
			return JsonResult.success(false);
		} else {
			int tempKey = userService.getTempKey();
			userService.sendMail(email,tempKey);
			return JsonResult.success(tempKey);
		}
		
	}

}