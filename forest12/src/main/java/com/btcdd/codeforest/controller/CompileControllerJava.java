package com.btcdd.codeforest.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.concurrent.Executors;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.btcdd.codeforest.dto.JsonResult;
import com.btcdd.codeforest.runlanguage.RunJava;

@Controller
@RequestMapping("/compile")
public class CompileControllerJava {
	
	StringBuffer buffer = new StringBuffer();

	RunJava rtt = new RunJava();
	
	@ResponseBody
	@PostMapping("/java")
	public JsonResult javaCompile(@RequestParam String code) {
		rtt.createFileAsSource(code);
		rtt.execCompile();
		String result = rtt.execCommand();
		String errorResult = rtt.execCompile();
		
		String[] res = new String[2];
		res[0] = result;
		res[1] = errorResult;
		
		return JsonResult.success(res);
	}
	
	@ResponseBody
	@PostMapping("/test")
	public JsonResult javaTest(@RequestParam String content) {
		
		Map<String, Object> map = new HashMap<>();
		StringBuffer readBuffer = new StringBuffer();
		try {
			// Linux의 경우는 /bin/bash
//			 Process process = Runtime.getRuntime().exec(content);
			Process process = Runtime.getRuntime().exec("cmd");
			System.out.println(content);
      
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
				// 문자 깨짐이 발생할 경우 InputStreamReader(stdout)에 인코딩 타입을 넣는다. ex)
				// InputStreamReader(stdout, "euc-kr")
				// try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout,
				// "euc-kr"))) {
				try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "euc-kr"))) {
//				try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "utf-8"))) {
					
					String line;
					while ((line = reader.readLine()) != null) {
						readBuffer.append(line);
						readBuffer.append("\n");
						System.out.println("readBuffer > " + readBuffer.toString());
						System.out.println("input > " + line);
					}
//					map.put("readbuffer", readBuffer.toString());
				} catch (IOException e) {
					e.printStackTrace();
				}
			});
			// 에러 stream을 BufferedReader로 받아서 에러가 발생할 경우 console 화면에 출력시킨다.
			Executors.newCachedThreadPool().execute(() -> {
				// 문자 깨짐이 발생할 경우 InputStreamReader(stdout)에 인코딩 타입을 넣는다. ex)
				// InputStreamReader(stdout, "euc-kr")
				// try (BufferedReader reader = new BufferedReader(new InputStreamReader(stderr,
				// "euc-kr"))) {
				try (BufferedReader reader = new BufferedReader(new InputStreamReader(stderr, "euc-kr"))) {
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
				String contents = content;
				// Scanner 클래스는 콘솔로 부터 입력을 받기 위한 클래스 입니다.
				try (Scanner scan = new Scanner(System.in)) {
					try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin))) {
						System.out.println("contents >>> " + contents);
						String input = scan.nextLine();
							input += "\n";
							writer.write(input);
							// Process로 명령어 입력
							System.out.println("outputStreamWriter");
//							if(contents != null) {
//							}
							writer.flush();
						// 콘솔로 부터 엔터가 포함되면 input String 변수로 값이 입력됩니다.
						// 콘솔에서 \n가 포함되어야 실행된다.(엔터의 의미인듯 싶습니다.)
						// exit 명령어가 들어올 경우에는 프로그램을 종료합니다.
						if ("exit\n".equals(contents)) {
							System.exit(0);
						}
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			});
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			map.put("readbuffer", readBuffer);
		}

		readBuffer.delete(0,readBuffer.length());
		readBuffer.trimToSize();
		return JsonResult.success(map);
	}
}