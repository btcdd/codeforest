package com.btcdd.security;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({ElementType.METHOD, ElementType.TYPE})	// ElementType.TYPE을 같이 써주면 클래스에서 어노테이션 가능
@Retention(RetentionPolicy.RUNTIME)
public @interface Auth {
	public enum Role{USER, ADMIN}	
	// 다른곳에서 사용할경우 @Auth(value="", test=)
	String value() default "USER";	// default값 설정
	boolean test() default false;
	
	public Role role() default Role.USER;
}