package com.btcdd.codeforest.service;

import java.util.Random;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.btcdd.codeforest.repository.UserRepository;
import com.btcdd.codeforest.vo.UserVo;

@Service
public class UserService {
	
	@Autowired
	private JavaMailSender mailSender;

	private Process process;
	
	@Autowired
	private UserRepository userRepository;
	
	public void join(UserVo vo) {
		userRepository.insert(vo);
		
		Long no = userRepository.findByEmail(vo.getEmail());
		
		try {
			process = Runtime.getRuntime().exec("mkdir userDirectory/user" + no);
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public String sendMail(String email,int tempKey) {

		try {
			
			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			messageHelper.setTo(email);
			messageHelper.setText("인증번호 : "+tempKey);
			messageHelper.setFrom("codeforest2020@gmail.com");
			messageHelper.setSubject("[회원가입 인증번호]");
			
			mailSender.send(message);

		}catch(Exception e) {
			System.out.println(e);
		}
		
		return "success";



	}

	public int getTempKey() {
		int random = new Random().nextInt(900000)+100000;
		return random;
		
	}

	public UserVo getUser(UserVo vo) {
		return userRepository.findByEmailAndPassword(vo);
	}

	public boolean existUser(String email) {
		return userRepository.findByEmail(email) != null;
	}

	public boolean existNickname(String nickname) {
		return userRepository.findNickname(nickname) != null;
	}

	public boolean updatePassword(UserVo vo) {
		return userRepository.update(vo) == 1;
		
	}

	public String getNickname(String email) {
		return userRepository.findNicknameByEmail(email);
	}
	
}