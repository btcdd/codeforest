package com.btcdd.codeforest.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Import;

import com.btcdd.codeforest.config.web.MessageConfig;
import com.btcdd.codeforest.config.web.MvcConfig;
import com.btcdd.codeforest.config.web.SecurityConfig;

@Configuration
@EnableAspectJAutoProxy
@ComponentScan("com.btcdd.codeforest.controller")
@Import({MvcConfig.class, SecurityConfig.class,MessageConfig.class})
public class WebConfig {
	 
}