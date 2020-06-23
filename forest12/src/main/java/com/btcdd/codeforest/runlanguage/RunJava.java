package com.btcdd.codeforest.runlanguage;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.concurrent.Executors;

import com.btcdd.codeforest.dto.JsonResult;

public class RunJava {
	
	private StringBuffer buffer;
	private Process process;
	private BufferedReader bufferedReader;
	private BufferedReader bufferedReader2;
	private BufferedWriter bufferedWriter;
	private StringBuffer readBuffer;
	
	private File file;
	private BufferedWriter bufferWriter;
	
	private final String FILENAME = "Test.java";
	
	private String content = "";
	
	public void createFileAsSource(String source) {
		try {
			file = new File(FILENAME);
			bufferWriter = new BufferedWriter(new FileWriter(file, false));
			
			bufferWriter.write(source);
			bufferWriter.flush();
		} catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		} finally {
			try {
				bufferWriter.close();
				file = null;
			} catch (IOException e) {
				e.printStackTrace();
				System.exit(1);
			}
		}
	}
	
	public void createFileAsSource(String source, String fileName) {
		try {
			file = new File(fileName);
			bufferWriter = new BufferedWriter(new FileWriter(file, false));
			
			bufferWriter.write(source);
			bufferWriter.flush();
		} catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
		} finally {
			try {
				bufferWriter.close();
				file = null;
			} catch (IOException e) {
				e.printStackTrace();
				System.exit(1);
			}
		}
	}
	
	public String execCompile() {
		try {
			process = Runtime.getRuntime().exec("cmd");
			process = Runtime.getRuntime().exec("javac -cp . Test.java");
			
			bufferedReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			String line = null;
			readBuffer = new StringBuffer();
			
			while((line = bufferedReader.readLine()) != null) {
				readBuffer.append(line);
				readBuffer.append("\n");
			}
			return readBuffer.toString();
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}

//	public void runProcess() throws IOException {
//	}
	
	public String execCommand() {
		Map<String, Object> map = new HashMap<>();
		StringBuffer readBuffer = new StringBuffer();
		try {
			// Linux의 경우는 /bin/bash
			process = Runtime.getRuntime().exec("java -cp . Test");
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
				// 문자 깨짐이 발생할 경우 InputStreamReader(stdout)에 인코딩 타입을 넣는다. ex)
				// InputStreamReader(stdout, "euc-kr")
				// try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout,
				// "euc-kr"))) {
				try (BufferedReader reader = new BufferedReader(new InputStreamReader(stdout, "euc-kr"))) {
					System.out.println("111111");
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
				try (Scanner scan = new Scanner(System.in)) {
//				BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin));
					try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(stdin))) {
						System.out.println("33333333");
						String fakeinput = scan.nextLine();
						String input = content;
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
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			});
		} catch (Throwable e) {
			e.printStackTrace();
		} finally {
			System.out.println("44444");
			map.put("readbuffer", readBuffer);
		}
		System.out.println("여기인가:" + readBuffer.toString());
		
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return readBuffer.toString();
	}
	
	public String writer(String content) {
		this.content = content;
		return content;
	}
	
	
	private String runClass() {
		buffer = new StringBuffer();
		
		buffer.append("java -cp . Test");
		
		return buffer.toString();
	}
}