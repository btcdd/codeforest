package com.btcdd.codeforest.linux;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.btcdd.codeforest.runlanguage.RunCLinux;
import com.btcdd.codeforest.runlanguage.RunCppLinux;
import com.btcdd.codeforest.runlanguage.RunCsLinux;
import com.btcdd.codeforest.runlanguage.RunJavaLinux;
import com.btcdd.codeforest.runlanguage.RunJsLinux;
import com.btcdd.codeforest.runlanguage.RunPyLinux;

public class CodeTreeLinux {
	
	private File file;
	private BufferedWriter bufferWriter;
	
	private final String FILENAME = "Test.java";
	
	private Process process;
	
	String c = "#include <stdio.h>\r\n" + 
			"\r\n" + 
			"int main() {\r\n" + 
			"	printf(\"Hello CodeForest!\\n\");\r\n" + 
			"\r\n" + 
			"	return 0;\r\n" + 
			"}";
	String cpp = "#include <iostream>\r\n" + 
			"\r\n" + 
			"using namespace std;\r\n" + 
			"\r\n" + 
			"int main()\r\n" + 
			"{\r\n" + 
			"	cout << \"Hello CodeForest!\" << endl;\r\n" + 
			"\r\n" + 
			"	return 0;\r\n" + 
			"}";
	String cs = "using System;\r\n" + 
			"\r\n" + 
			"class HelloWorld {\r\n" + 
			"\r\n" + 
			"	static void Main() {\r\n" + 
			"		Console.WriteLine(\"Hello CodeForest\");\r\n" + 
			"	}\r\n" + 
			"}";
	String java = "/*\r\n" + 
			"* 기본 언어 : 'JAVA'\r\n" + 
			"* 기본 테마 : 'panda-syntax'\r\n" + 
			"*/\r\n" + 
			"public class Test{\r\n" + 
			"	public static void main(String[] args) {\r\n" + 
			"		System.out.println(\"Hello CodeForest!\");\r\n" + 
			"	}\r\n" + 
			"}";
	String js = "var str = \"Hello CodeForest\";\r\n" + 
			"\r\n" + 
			"console.log(str);";
	String py = "print(\"Hello World\")";
	
	String[] faceCode = { c, cpp, cs, java, js, py };
	
	public void save(Long authUserNo, Long problemNo, Long[] subProblemNoArray) {
		try {
			process = Runtime.getRuntime().exec("mkdir userDirectory/user" + authUserNo + "/prob" + problemNo);
			String[] langArray = { "c", "cpp", "cs", "java", "js", "py" };
			
			for(int i = 0; i < subProblemNoArray.length; i++) {
				process = Runtime.getRuntime().exec("mkdir userDirectory/user" + authUserNo + "/prob" + problemNo + "/subProb" + subProblemNoArray[i]);
				for(int j = 0; j < langArray.length; j++) {
					process = Runtime.getRuntime().exec("mkdir userDirectory/user" + authUserNo + "/prob" + problemNo + "/subProb" + subProblemNoArray[i] + "/" + langArray[j]);
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
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

	public void deleteSaveProblem(Long authUserNo, Long problemNo) {
		try {
			process = Runtime.getRuntime().exec("rm -rf userDirectory/user" + authUserNo + "/prob" + problemNo);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public void linuxSaveCode(Long authUserNo, Long problemNo, Long[] subProblemNoArray) {
		try {
			String[] langArray = { "c", "cpp", "cs", "java", "js", "py" };
			
			for(int i = 0; i < subProblemNoArray.length; i++) {
				for(int j = 0; j < langArray.length; j++) {
					createFileAsSource(faceCode[j], "userDirectory/user" + authUserNo + "/prob" + problemNo + "/subProb" + subProblemNoArray[i] + "/" + langArray[j] + "/Test." + langArray[j]);
				}
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void insertCode(Long authUserNo, Long problemNo, Long subProblemNo, String language, String fileName) {
		String faceCode = "";
		if("c".equals(language)) faceCode = c;
		else if("cpp".equals(language)) faceCode = cpp;
		else if("cs".equals(language)) faceCode = cs;
		else if("java".equals(language)) faceCode = java;
		else if("js".equals(language)) faceCode = js;
		else if("py".equals(language)) faceCode = py;
		
		createFileAsSource(faceCode, "userDirectory/user" + authUserNo + "/prob" + problemNo + "/subProb" + subProblemNo + "/" + language + "/" + fileName);
	}

	public void deleteCode(String packagePath, String language, String fileName) {
		try {
			process = Runtime.getRuntime().exec("rm -rf " + packagePath + "/" + language + "/" + fileName);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	public String findCode(String packagePath, String language, String fileName) {
		String code = "";
		
		Path path = Paths.get(packagePath + "/" + language + "/" + fileName);
		Charset cs = StandardCharsets.UTF_8;
		List<String> list = new ArrayList<String>();
		try {
			FileReader rw = new FileReader(packagePath + "/" + language + "/" + fileName);
			list = Files.readAllLines(path,cs);
			
			rw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		for(String readLines: list) {
			code += readLines;
			code += "\n";
		}

		return code;
	}
	
	public Map<String, Object> javaCompile(String fileName, String packagePath, String language) {

		RunJavaLinux runJavaLinux = new RunJavaLinux(fileName, packagePath, language);
		
		runJavaLinux.execCompile();
		String result = runJavaLinux.execCommand();
		String errorResult = runJavaLinux.execCompile();
		
		String[] res = new String[2];
		res[0] = result;
		res[1] = errorResult;
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", res);
		
		return map;
	}
	
	public Map<String, Object> cCompile(String fileName, String packagePath, String language) {

		RunCLinux runCLinux = new RunCLinux(fileName, packagePath, language);
		
		runCLinux.execCompile();
		String result = runCLinux.execCommand();
		String errorResult = runCLinux.execCompile();
		
		String[] res = new String[2];
		res[0] = result;
		res[1] = errorResult;
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", res);
		
		return map;
	}
	
	public Map<String, Object> cppCompile(String fileName, String packagePath, String language) {

		RunCppLinux runCppLinux = new RunCppLinux(fileName, packagePath, language);
		
		runCppLinux.execCompile();
		String result = runCppLinux.execCommand();
		String errorResult = runCppLinux.execCompile();
		
		String[] res = new String[2];
		res[0] = result;
		res[1] = errorResult;
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", res);
		
		return map;
	}
	
	public Map<String, Object> csCompile(String fileName, String packagePath, String language) {

		RunCsLinux runCsLinux = new RunCsLinux(fileName, packagePath, language);
		
		runCsLinux.execCompile();
		String result = runCsLinux.execCommand();
		String errorResult = runCsLinux.execCompile();
		
		String[] res = new String[2];
		res[0] = result;
		res[1] = errorResult;
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", res);
		
		return map;
	}
	
	public Map<String, Object> jsCompile(String fileName, String packagePath, String language) {

		RunJsLinux runJsLinux = new RunJsLinux(fileName, packagePath, language);
		
		runJsLinux.execCompile();
		String result = runJsLinux.execCommand();
		String errorResult = runJsLinux.execCompile();
		
		String[] res = new String[2];
		res[0] = result;
		res[1] = errorResult;
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", res);
		
		return map;
	}
	
	public Map<String, Object> pyCompile(String fileName, String packagePath, String language) {

		RunPyLinux runPyLinux = new RunPyLinux(fileName, packagePath, language);
		
		runPyLinux.execCompile();
		String result = runPyLinux.execCommand();
		String errorResult = runPyLinux.execCompile();
		
		String[] res = new String[2];
		res[0] = result;
		res[1] = errorResult;
		
		Map<String, Object> map = new HashMap<>();
		map.put("result", res);
		
		return map;
	}
}