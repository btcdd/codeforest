package com.btcdd.codeforest.vo;

public class SubStatisticsVo {
	private int c;
	private int cpp;
	private int cs;
	private int java;
	private int js;
	private int py;
	private int y;
	private int n;
	private double rate;
	
	public int getC() {
		return c;
	}
	public void setC(int c) {
		this.c = c;
	}
	public int getCpp() {
		return cpp;
	}
	public void setCpp(int cpp) {
		this.cpp = cpp;
	}
	public int getCs() {
		return cs;
	}
	public void setCs(int cs) {
		this.cs = cs;
	}
	public int getJava() {
		return java;
	}
	public void setJava(int java) {
		this.java = java;
	}
	public int getJs() {
		return js;
	}
	public void setJs(int js) {
		this.js = js;
	}
	public int getPy() {
		return py;
	}
	public void setPy(int py) {
		this.py = py;
	}
	public int getY() {
		return y;
	}
	public void setY(int y) {
		this.y = y;
	}
	public int getN() {
		return n;
	}
	public void setN(int n) {
		this.n = n;
	}
	public double getRate() {
		return rate;
	}
	public void setRate(double rate) {
		this.rate = rate;
	}
	
	@Override
	public String toString() {
		return "SubStatisticsVo [c=" + c + ", cpp=" + cpp + ", cs=" + cs + ", java=" + java + ", js=" + js + ", py="
				+ py + ", y=" + y + ", n=" + n + ", rate=" + rate + "]";
	}
}