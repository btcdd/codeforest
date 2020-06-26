package com.btcdd.codeforest.runlanguage;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;

public class RunC {
	
	private StringBuffer buffer;
	private Process process;
	private BufferedReader bufferedReader;
	private StringBuffer readBuffer;
	
	private File file;
	private BufferedWriter bufferWriter;
	
	private final String FILENAME = "test.c";
	private final Long TIME = System.currentTimeMillis();
	private Long time;
	
	public RunC(Long time) {
		this.time = time;
	}
	
	public String inputSource() {
		
		buffer = new StringBuffer();
		
		buffer.append("gcc -o /mainCompile/c" + time + "/Test.exe /mainCompile/c" + time + "/fakeTest.c");
		return buffer.toString();
	}
	
	public void createFileAsSourceTrue(String source) {
		try {
			process = Runtime.getRuntime().exec("mkdir /mainCompile/c" + time);
			
			Thread.sleep(100);
			
			file = new File("mainCompile/c" + time + "/Test.c");
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
	
	public void createFileAsSourceFake(String source) {
		try {
			file = new File("mainCompile/c" + time + "/fakeTest.c");
			bufferWriter = new BufferedWriter(new FileWriter(file, false));
			
			String fakeSource = "";
			String[] split = source.split("\n");
			for(int i = 0; i < split.length; i++) {
				if(split[i].contains("scanf") || split[i].contains("gets") || split[i].contains("fgets")) {
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
				System.exit(1);
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
			process = Runtime.getRuntime().exec("timeout 2s ./test.exe");
		} catch(Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
	
	private String runClass() {
		buffer = new StringBuffer();
		
		buffer.append("timeout 2s ./test.exe");
		
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