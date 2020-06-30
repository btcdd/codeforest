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
import java.util.concurrent.Executors;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

import com.btcdd.codeforest.model.ChatMessage;
import com.btcdd.codeforest.runlanguage.RunCLinux;
import com.btcdd.codeforest.runlanguage.RunCppLinux;
import com.btcdd.codeforest.runlanguage.RunCsLinux;
import com.btcdd.codeforest.runlanguage.RunJavaLinux;
import com.btcdd.codeforest.runlanguage.RunJsLinux;
import com.btcdd.codeforest.runlanguage.RunPyLinux;
import com.btcdd.codeforest.service.CodeTreeService;

@Controller
public class CodeTreeChatController {
	
	private Process process;
	private StringBuffer readBuffer = new StringBuffer();

	@MessageMapping("/codetree")
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
		String fileName = (String) obj.get("fileName");
		String packagePath = (String) obj.get("packagePath");
		Boolean submitPandan = (Boolean) obj.get("submitPandan");
		Long subProblemNo = (Long) obj.get("subProblemNo");
		
		CodeTreeService codetreeService = new CodeTreeService();
		
		try {
			if(pandan) {
				if("c".equals(language)) {
					RunCLinux runCLinux = new RunCLinux(fileName, packagePath, language);
				    errorResult = runCLinux.execCompile();
					process = Runtime.getRuntime().exec("timeout 120s " + packagePath + "/" + language + "/Test.exe");
				} else if("cpp".equals(language)) {
					RunCppLinux runCppLinux = new RunCppLinux(fileName, packagePath, language);
				    errorResult = runCppLinux.execCompile();
					process = Runtime.getRuntime().exec("timeout 120s " + packagePath + "/" + language + "/Test.exe");
				} else if("cs".equals(language)) {
					RunCsLinux runCsLinux = new RunCsLinux(fileName, packagePath, language);
				    errorResult = runCsLinux.execCompile();
					process = Runtime.getRuntime().exec("timeout 120s mono " + packagePath + "/" + language + "/Test.exe");
				} else if("java".equals(language)) {
					RunJavaLinux runJavaLinux = new RunJavaLinux(fileName, packagePath, language);
				    errorResult = runJavaLinux.execCompile();
				    String[] split = fileName.split("\\.");
					process = Runtime.getRuntime().exec("timeout 120s java -cp " + packagePath + "/" + language + "/ " + split[0]);
				} else if("js".equals(language)) {
					RunJsLinux runJsLinux = new RunJsLinux(fileName, packagePath, language);
					errorResult = runJsLinux.execCompile();
					process = Runtime.getRuntime().exec("timeout 120s node " + packagePath + "/" + language + "/Test.js");
				} else if("py".equals(language)) {
					RunPyLinux runPyLinux = new RunPyLinux(fileName, packagePath, language);
					errorResult = runPyLinux.execCompile();
					process = Runtime.getRuntime().exec("timeout 120s python3 " + packagePath + "/" + language + "/Test.py");
				}
				readBuffer.setLength(0);
				if(!("".equals(errorResult))) {
					chatMessage.setContent(errorResult);
					chatMessage.setProgramPandan(true);
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
					BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "utf-8"));
					int c = 0;
					while ((c = reader.read()) != -1) {
						char line = (char) c;
						readBuffer2.append(line);
					}
				} catch (IOException e) {
					e.printStackTrace();
				} finally {
				}
			});

			// 입력 stream을 BufferedWriter로 받아서 콘솔로부터 받은 입력을 Process 클래스로 실행시킨다.
			Executors.newCachedThreadPool().submit(() -> {
				try {
					BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin));
					String input = chatMessage.getContent();
					
					if(submitPandan == true) {
						try {
							File file = new File("gwanwooooo22222.txt");
							BufferedWriter bufferWriter = new BufferedWriter(new FileWriter(file, false));
							
							bufferWriter.write("gdgd");
							bufferWriter.flush(); 
						} catch(Exception e) {
							e.printStackTrace();
							System.exit(1);
						}
					}
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
					InputStreamReader is = new InputStreamReader(stdout, "utf-8");
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
		} finally {
		}

		try {
			Thread.sleep(300);
		} catch (Exception e) {
			e.printStackTrace();
		}

		chatMessage.setContent(readBuffer.toString());
		if(!process.isAlive()) {
			chatMessage.setContent(readBuffer.toString() + "\n프로그램이 종료되었습니다!");
			chatMessage.setProgramPandan(true);
			return chatMessage;
		}
		
		return chatMessage;
	}
}