package com.btcdd.codeforest.config.linux.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.Executors;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

import com.btcdd.codeforest.model.ChatMessage;

@Controller
public class ChatController {

	private Process process;
	private StringBuffer readBuffer = new StringBuffer();
	private StringBuffer readBuffer2 = new StringBuffer();

	@MessageMapping("/chat")
	@SendTo("/topic/public")
	public ChatMessage addUser(String data, @Payload ChatMessage chatMessage, SimpMessageHeaderAccessor headerAccessor) {

		try {
			if("{}".equals(data)) {
//				process = Runtime.getRuntime().exec("cmd");
//				process = Runtime.getRuntime().exec("java Test");
				process = Runtime.getRuntime().exec("java -cp . Test");
			}
			OutputStream stdin = process.getOutputStream();
			InputStream stderr = process.getErrorStream();
			InputStream stdout = process.getInputStream();

			StringBuffer readBuffer2 = new StringBuffer();

			// 출력 stream을 BufferedReader로 받아서 라인 변경이 있을 경우 console 화면에 출력시킨다.
			Executors.newCachedThreadPool().execute(() -> {
				try {
//					BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "euc-kr"));
					BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "utf-8"));
					int c = 0;
					while ((c = reader.read()) != -1) {
						char line = (char) c;
						readBuffer.append(line);
					}
					reader.reset();
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
				}
			});
			// 에러 stream을 BufferedReader로 받아서 에러가 발생할 경우 console 화면에 출력시킨다.
			Executors.newCachedThreadPool().execute(() -> {
				try {
//					BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "euc-kr"));
					BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "utf-8"));
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
			Executors.newCachedThreadPool().execute(() -> {
				try {
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
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				} catch (Exception e) {
				} finally {
				}
			});
		} catch (Throwable e) {
			e.printStackTrace();
		} 

		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		chatMessage.setContent(readBuffer.toString());
		chatMessage.setSender(readBuffer2.toString());

		return chatMessage;
	}
}