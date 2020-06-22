package com.btcdd.codeforest.linux;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import com.btcdd.codeforest.vo.SubProblemVo;

public class MypageLinux {
	
	private Process process;
	
	public int deleteProblemAllUsers(Long problemNo) {	
		
		try {
			process = Runtime.getRuntime().exec("find . -name \\'prob" + problemNo + "\\' -type d | xargs rm -rf");
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		return 10000;
	}
}