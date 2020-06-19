package com.btcdd.codeforest.runlanguage;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.List;

import com.btcdd.codeforest.vo.CodeVo;

public class RunPyLinux {
	
	private String fileName;
	private String language;
	private String packagePath;
	
	private StringBuffer buffer;
	private Process process;
	private BufferedReader bufferedReader;
	private BufferedReader bufferedReader2;
	private StringBuffer readBuffer;
	
	private File file;
	private BufferedWriter bufferWriter;
	
	
	public RunPyLinux(String fileName, String packagePath, String language) {
		this.fileName = fileName;
		this.packagePath = packagePath;
		this.language = language;
	}

	public void createFileAsSource(String source, String fileName) {
		try {
			bufferWriter = new BufferedWriter(new FileWriter(fileName, false));
			
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
			
			process = Runtime.getRuntime().exec("python3 " + packagePath + "/" + language + "/Test.py");	
			
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
			bufferedReader2 = new BufferedReader(new InputStreamReader(process.getErrorStream()));
						
			String line = null;
			readBuffer = new StringBuffer();
			
			while((line = bufferedReader.readLine()) != null) {
				readBuffer.append(line);
				readBuffer.append("\n");
			}
			while((line = bufferedReader2.readLine()) != null) {
				readBuffer.append(line);
				readBuffer.append("\n");
			}
			return readBuffer.substring(0, readBuffer.length() - 1).toString();
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	public String runClass() {
		buffer = new StringBuffer();
		
		buffer.append("python3 " + packagePath + "/" + language + "/Test.py");
		
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