package com.btcdd.codeforest.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Import;

import com.btcdd.codeforest.config.app.DBConfig;
import com.btcdd.codeforest.config.app.MailConfig;
import com.btcdd.codeforest.config.app.MyBatisConfig;

@Configuration
@EnableAspectJAutoProxy
@ComponentScan({"com.btcdd.codeforest.service", "com.btcdd.codeforest.repository"})
@Import({DBConfig.class, MyBatisConfig.class,MailConfig.class})
public class AppConfig {

}