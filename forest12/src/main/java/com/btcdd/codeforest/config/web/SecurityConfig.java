package com.btcdd.codeforest.config.web;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.btcdd.security.AuthInterceptor;
import com.btcdd.security.AuthUserHandlerMethodArgumentResolver;
import com.btcdd.security.LoginInterceptor;
import com.btcdd.security.LogoutInterceptor;

@Configuration
public class SecurityConfig extends WebMvcConfigurerAdapter {

	@Bean
	public HandlerMethodArgumentResolver authUserHandlerMethodArgumentResolver() {
		return new AuthUserHandlerMethodArgumentResolver();
	}
	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
		argumentResolvers.add(authUserHandlerMethodArgumentResolver());
	}

	@Bean
	public HandlerInterceptor loginInterceptor() {
		return new LoginInterceptor();
	}
	@Bean
	public HandlerInterceptor logoutInterceptor() {
		return new LogoutInterceptor();
	}
	@Bean
	public HandlerInterceptor authInterceptor() {
		return new AuthInterceptor();
	}
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(loginInterceptor()).addPathPatterns("/user/auth");
		registry.addInterceptor(logoutInterceptor()).addPathPatterns("/user/logout");
		registry.addInterceptor(authInterceptor()).addPathPatterns("/**").excludePathPatterns("/user/auth").excludePathPatterns("/user/logout").excludePathPatterns("/assets/**");
	}


}