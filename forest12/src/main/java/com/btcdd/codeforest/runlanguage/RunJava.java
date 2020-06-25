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
	
	private final Long TIME = System.currentTimeMillis();
	
	private String content = "";
	private Long time;
	
	public RunJava(Long time) {
		this.time = time;
	}
	
	public void createFileAsSource(String source) {
		try {
			file = new File("mainCompile/test" + time + ".java");
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
			process = Runtime.getRuntime().exec("javac -cp /mainCompile/test" + time + ".java");
			
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
			try {
				process = Runtime.getRuntime().exec("java -cp . Test");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return null;
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