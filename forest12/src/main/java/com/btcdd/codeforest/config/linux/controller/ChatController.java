package com.btcdd.codeforest.config.linux.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.text.ParseException;
import java.util.concurrent.Executors;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

import com.btcdd.codeforest.model.ChatMessage;
import com.btcdd.codeforest.runlanguage.RunC;
import com.btcdd.codeforest.runlanguage.RunCpp;
import com.btcdd.codeforest.runlanguage.RunCs;
import com.btcdd.codeforest.runlanguage.RunJava;
import com.btcdd.codeforest.runlanguage.RunJs;
import com.btcdd.codeforest.runlanguage.RunPy;
import com.btcdd.codeforest.vo.SubmitVo;

@Controller
public class ChatController {
	
	private StringBuffer buffer;
	private BufferedReader bufferedReader;
	
	private File file;
	private BufferedWriter bufferWriter;
	
	private Process process;
	private StringBuffer readBuffer = new StringBuffer();
	private StringBuffer readBuffer2 = new StringBuffer();

	@MessageMapping("/chat")
	@SendTo("/topic/public")
	public ChatMessage addUser(String data, @Payload ChatMessage chatMessage, SimpMessageHeaderAccessor headerAccessor) {
		String errorResult = "";
		Boolean pandan = false;
		
		JSONParser parser = new JSONParser();
		JSONObject obj = null;
		try {
			obj = (JSONObject) parser.parse(data);
		} catch (Exception e) {
			e.printStackTrace();
		}		
		pandan = (Boolean) obj.get("execPandan");
		String language = (String) obj.get("language");
		String code = (String) obj.get("code");
		try {
			if(pandan) {
				process = Runtime.getRuntime().exec("cmd");
				if("c".equals(language)) {
					RunC rc = new RunC();
					rc.createFileAsSourceTrue(code);
					rc.createFileAsSourceFake(code);
					errorResult = rc.execCompile();
					process = Runtime.getRuntime().exec("./test.exe");
				} else if("cpp".equals(language)) {
					RunCpp rcpp = new RunCpp();
					rcpp.createFileAsSourceTrue(code);
					rcpp.createFileAsSourceFake(code);
					errorResult = rcpp.execCompile();
					process = Runtime.getRuntime().exec("./cppTest.exe");
				} else if("cs".equals(language)) {
					RunCs rcs = new RunCs();
					rcs.createFileAsSource(code);
					errorResult = rcs.execCompile();
					process = Runtime.getRuntime().exec("mono testCs.exe");
				} else if("java".equals(language)) {
					RunJava rj = new RunJava();
					rj.createFileAsSource(code);
					errorResult = rj.execCompile();
					process = Runtime.getRuntime().exec("java -cp . Test");
				} else if("js".equals(language)) {
					RunJs rjs = new RunJs();
					rjs.createFileAsSource(code);
//					errorResult = rjs.execCompile();
					process = Runtime.getRuntime().exec("node test.js");
				} else if("py".equals(language)) {
					RunPy rpy = new RunPy();
					rpy.createFileAsSource(code);
					errorResult = rpy.execCompile();
					process = Runtime.getRuntime().exec("python3 testPy.py");
				}
				readBuffer.setLength(0);
				if(!("".equals(errorResult))) {
					chatMessage.setContent(errorResult);
					
					return chatMessage;
				}
			}
			
			OutputStream stdin = process.getOutputStream();
			InputStream stderr = process.getErrorStream();
			InputStream stdout = process.getInputStream();

			StringBuffer readBuffer2 = new StringBuffer();

			// 에러 stream을 BufferedReader로 받아서 에러가 발생할 경우 console 화면에 출력시킨다.
			Executors.newCachedThreadPool().submit(() -> {
				try {
					System.out.println("1");
					BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "euc-kr"));
//					BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "utf-8"));
					int c = 0;
					while ((c = reader.read()) != -1) {
						char line = (char) c;
						readBuffer2.append(line);
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			});

			// 입력 stream을 BufferedWriter로 받아서 콘솔로부터 받은 입력을 Process 클래스로 실행시킨다.
			Executors.newCachedThreadPool().submit(() -> {
				try {
					System.out.println("2");
					BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin));
					String input = chatMessage.getContent();
					// 지술이형 코드!!
					if(input == null) {
						return;
					}

					if (!("".equals(input)) || input != null) {
						try {
							input += "\n";
							readBuffer2.append(input);
							writer.write(input);
							writer.flush();
							readBuffer.setLength(0);
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				} catch (Exception e) {
				} finally {
				}
			});
			
			// 출력 stream을 BufferedReader로 받아서 라인 변경이 있을 경우 console 화면에 출력시킨다.
				Executors.newCachedThreadPool().submit(() -> {
					try {
						System.out.println("3");
//								BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "euc-kr"));
//								InputStreamReader is = new InputStreamReader(stdout, "utf-8");
						InputStreamReader is = new InputStreamReader(stdout, "euc-kr");
						
//								BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "utf-8"));
						int c = 0;
						readBuffer.setLength(0);
						while ((c = is.read()) != -1) {
							char line = (char) c;
							readBuffer.append(line);
						}
						//reader.reset();
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
					}
				});
		} catch (Throwable e) {
			e.printStackTrace();
		} 

		try {
			Thread.sleep(94);
		} catch (Exception e) {
			e.printStackTrace();
		}

		chatMessage.setContent(readBuffer.toString());
		
		return chatMessage;
	}
}