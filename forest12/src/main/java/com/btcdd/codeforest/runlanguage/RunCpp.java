package com.btcdd.codeforest.runlanguage;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;

public class RunCpp {
	
	private StringBuffer buffer;
	private Process process;
	private BufferedReader bufferedReader;
	private StringBuffer readBuffer;
	
	private File file;
	private BufferedWriter bufferWriter;
	
	private Long time;
	
	public RunCpp(Long time) {
		this.time = time;
	}
	
	public String inputSource() {
		
		buffer = new StringBuffer();
		
		buffer.append("g++ -o /mainCompile/cpp" + time + "/Test.exe mainCompile/cpp" + time + "/fakeTest.cpp");
		
		return buffer.toString();
	}
	
	public void createFileAsSourceTrue(String source) {
		try {
			process = Runtime.getRuntime().exec("mkdir /mainCompile/cpp" + time);
			
			Thread.sleep(100);
			file = new File("mainCompile/cpp" + time + "/Test.cpp");
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
	
	public void createFileAsSourceFake(String source) {
		try {
			file = new File("mainCompile/cpp" + time + "/fakeTest.cpp");
			bufferWriter = new BufferedWriter(new FileWriter(file, false));
			
			String fakeSource = "";
			String[] split = source.split("\n");
			for(int i = 0; i < split.length; i++) {
				if(split[i].contains("scanf") || split[i].contains("cin") || split[i].contains("cin.get") || split[i].contains("cin.getline")) {
					split[i] = "fflush(stdout);\n" + split[i] + "\n";
				}
				fakeSource += split[i] + "\n";
			}
			
			bufferWriter.write(fakeSource);
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
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	private String runClass() {
		buffer = new StringBuffer();
		
		buffer.append("timeout 2s ./cppTest.exe");
		
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