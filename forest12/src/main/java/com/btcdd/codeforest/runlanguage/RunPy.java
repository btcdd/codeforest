package com.btcdd.codeforest.runlanguage;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;

public class RunPy {
	
	private StringBuffer buffer;
	private Process process;
	private BufferedReader bufferedReader;
	private StringBuffer readBuffer;
	
	private File file;
	private BufferedWriter bufferWriter;
	
	private final String FILENAME = "testPy.py";
	
	public String inputSource() {
		
		buffer = new StringBuffer();
		
		buffer.append("python testPy.py");
		
		return buffer.toString();
	}
	
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
				System.exit(1);;
			}
		}
	}
	
	public String execCompile() {
		try {
			process = Runtime.getRuntime().exec(inputSource());
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
	
	public String execCommand() {
		try {
			process = Runtime.getRuntime().exec(runClass());
			
			bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
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
	
	private String runClass() {
		buffer = new StringBuffer();
		
		buffer.append("python3 testPy.py");
		
		return buffer.toString();
	}
	
	public String execSave(String cmd) {
		try {
			process = Runtime.getRuntime().exec(cmd);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
}