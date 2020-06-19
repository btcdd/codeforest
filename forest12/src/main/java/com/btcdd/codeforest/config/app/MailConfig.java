package com.btcdd.codeforest.config.app;

import java.util.Properties;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

@Configuration
public class MailConfig {
	
	@Bean
	public JavaMailSender mailSender() {

		JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
		mailSender.setHost("smtp.gmail.com");
		mailSender.setPort(587);
		mailSender.setUsername("codeforest2020@gmail.com");
		mailSender.setPassword("codeforest1!");
		mailSender.setDefaultEncoding("UTF-8");
		
		Properties prop = new Properties();
		
		prop.setProperty("mail.transport.protocol", "smtp");
		prop.setProperty("mail.smtp.auth","true");
		prop.setProperty("mail.smtp.starttls.required","true");
		prop.setProperty("mail.smtp.starttls.enable","true");
		prop.setProperty("mail.smtp.socketFactory.class","javax.net.ssl.SSLSocketFactory");
		prop.setProperty("mail.smtp.socketFactory.fallback","false");
		prop.setProperty("mail.smtp.port","465");
		prop.setProperty("mail.smtp.socketFactory.port","465");
		
		mailSender.setJavaMailProperties(prop);
		return mailSender;
	}
}