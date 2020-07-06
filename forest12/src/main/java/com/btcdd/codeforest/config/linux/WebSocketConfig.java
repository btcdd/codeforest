package com.btcdd.codeforest.config.linux;

import javax.servlet.http.HttpSession;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

import com.btcdd.codeforest.vo.UserVo;




class AuthCheck {
	UserVo userVo = null;
	HttpSession session;
	public UserVo auth() {
		userVo = (UserVo) session.getAttribute("authUser");
		this.session = session;
		return userVo;
	}
}


@Configuration
@EnableWebSocketMessageBroker//@EnableWebSocketMessageBroker is used to enable our WebSocket server
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

	AuthCheck authCheck = null;
	
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
    	UserVo userVo = null;
    	userVo = authCheck.auth();
    	registry.addEndpoint("/" + userVo.getNo()).setAllowedOrigins("*").withSockJS();
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.setApplicationDestinationPrefixes("/app");
        registry.enableSimpleBroker("/topic");
    }
}