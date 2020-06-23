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

	private StringBuffer buffer;
	private Process process;
	private BufferedReader bufferedReader;
	private BufferedReader bufferedReader2;
	private BufferedWriter bufferedWriter;
	private StringBuffer readBuffer = new StringBuffer();

	private File file;
	private BufferedWriter bufferWriter;

	private String content = "";

	Map<String, Object> map = new HashMap<>();

	@MessageMapping("/chat.sendMessage")
	@SendTo("/topic/public")
	public ChatMessage sendMessage(@Payload ChatMessage chatMessage) {
		try {

//			 Process process = Runtime.getRuntime().exec(content);
//			process.waitFor();

			// Process의 각 stream을 받는다.
			// process의 입력 stream3
			OutputStream stdin = process.getOutputStream();
			// process의 에러 stream
			InputStream stderr = process.getErrorStream();
			// process의 출력 stream
			InputStream stdout = process.getInputStream();

			StringBuffer readBuffer2 = new StringBuffer();

			// 쓰레드 풀을 이용해서 3개의 stream을 대기시킨다.
			// 출력 stream을 BufferedReader로 받아서 라인 변경이 있을 경우 console 화면에 출력시킨다.
			Executors.newCachedThreadPool().execute(() -> {
				try {
					BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "euc-kr"));
					System.out.println("111111");
//				try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "utf-8"))) {

					String line;
					while ((line = reader.readLine()) != null) {
						System.out.println("line:" + line);
						readBuffer.append(line);
						readBuffer.append("\n");
						System.out.println("readBuffer > " + readBuffer.toString());
						System.out.println("input > " + line);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
			// 에러 stream을 BufferedReader로 받아서 에러가 발생할 경우 console 화면에 출력시킨다.
			Executors.newCachedThreadPool().execute(() -> {
				try {
					BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "euc-kr"));
					System.out.println("22222");
//				try (BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "utf-8"))) {
					String line;
					while ((line = reader.readLine()) != null) {
						readBuffer2.append(line);
						readBuffer2.append("\n");
						System.out.println("err > " + line);
					}
					map.put("readbuffer2", readBuffer2.toString());
				} catch (IOException e) {
					e.printStackTrace();
				}
			});

			// 입력 stream을 BufferedWriter로 받아서 콘솔로부터 받은 입력을 Process 클래스로 실행시킨다.
			Executors.newCachedThreadPool().execute(() -> {

				// Scanner 클래스는 콘솔로 부터 입력을 받기 위한 클래스 입니다.
//				try (Scanner scan = new Scanner(System.in)) {
//					try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin))) {
				BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin));
				try {
					System.out.println("33333333");
//						String fakeinput = scan.nextLine();
					String input = chatMessage.getContent();
//						if(!("".equals(content))) {
					try {
						input += "\n";
						writer.write(input);
						System.out.println("outputStreamWriter");
						writer.flush();
//								readBuffer.append(writer.flush());
						if ("exit\n".equals(input)) {
							System.exit(0);
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
//						}
					System.out.println("outputStreamWriter2");
				} catch (Exception e) {
				}
//				}
			});
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			System.out.println("44444");
			map.put("readbuffer", readBuffer);
		}
		System.out.println("여기인가:");

		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		System.out.println(readBuffer.toString());
		chatMessage.setContent(readBuffer.toString());

		return chatMessage;
	}

	@MessageMapping("/chat")
	@SendTo("/topic/public")
	public ChatMessage addUser(@Payload ChatMessage chatMessage, SimpMessageHeaderAccessor headerAccessor) {

		try {
			process = Runtime.getRuntime().exec("cmd");
			process = Runtime.getRuntime().exec("java Test");
			// Process의 각 stream을 받는다.
			// process의 입력 stream3
			OutputStream stdin = process.getOutputStream();
			// process의 에러 stream
			InputStream stderr = process.getErrorStream();
			// process의 출력 stream
			InputStream stdout = process.getInputStream();

			StringBuffer readBuffer2 = new StringBuffer();

			// 쓰레드 풀을 이용해서 3개의 stream을 대기시킨다.
			// 출력 stream을 BufferedReader로 받아서 라인 변경이 있을 경우 console 화면에 출력시킨다.
			Executors.newCachedThreadPool().execute(() -> {
				try {
					BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "euc-kr"));
					System.out.println("111111");
//							try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "utf-8"))) {

//					String line;
					int c = 0;
					while ((c = reader.read()) != -1) {
						char line = (char) c;
						System.out.println("line:" + line);
						readBuffer.append(line);
						System.out.println("readBuffer > " + readBuffer.toString());
						System.out.println("input > " + line);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
			// 에러 stream을 BufferedReader로 받아서 에러가 발생할 경우 console 화면에 출력시킨다.
			Executors.newCachedThreadPool().execute(() -> {
				try {
					BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "euc-kr"));
					System.out.println("22222");
//							try (BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "utf-8"))) {
//					String line;
					int c = 0;
					while ((c = reader.read()) != -1) {
						char line = (char) c;
						readBuffer2.append(line);
						System.out.println("err > " + line);
					}
					map.put("readbuffer2", readBuffer2.toString());
				} catch (IOException e) {
					e.printStackTrace();
				}
			});

			// 입력 stream을 BufferedWriter로 받아서 콘솔로부터 받은 입력을 Process 클래스로 실행시킨다.
			Executors.newCachedThreadPool().execute(() -> {

				// Scanner 클래스는 콘솔로 부터 입력을 받기 위한 클래스 입니다.
//							try (Scanner scan = new Scanner(System.in)) {
//								try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin))) {
				BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin));
				try {
					System.out.println("33333333");
//									String fakeinput = scan.nextLine();
					String input = chatMessage.getContent();
					System.out.println("input:" + input);
					// 지술이형 코드!!
					if(input == null) {
						return;
					}
					if (!("".equals(input)) || input != null) {
						try {
							input += "\n";
							writer.write(input);
							System.out.println("outputStreamWriter");
							writer.flush();
//											readBuffer.append(writer.flush());
							if ("exit\n".equals(input)) {
								System.exit(0);
							}
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
					System.out.println("outputStreamWriter2");
				} catch (Exception e) {
				}
//							}
			});
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			System.out.println("44444");
			map.put("readbuffer", readBuffer);
		}
		System.out.println("여기인가:");

		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		System.out.println(readBuffer.toString());
		chatMessage.setContent(readBuffer.toString());
		readBuffer.setLength(0);

		return chatMessage;
	}
}