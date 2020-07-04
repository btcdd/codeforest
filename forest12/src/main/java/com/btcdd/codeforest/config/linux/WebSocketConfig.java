package com.btcdd.codeforest.config.linux;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker//@EnableWebSocketMessageBroker is used to enable our WebSocket server
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/1").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/2").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/3").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/4").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/5").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/6").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/7").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/8").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/9").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/10").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/11").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/12").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/13").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/14").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/15").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/16").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/17").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/18").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/19").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/20").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/21").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/22").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/23").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/24").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/25").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/26").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/27").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/28").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/29").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/30").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/31").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/32").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/33").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/34").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/35").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/36").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/37").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/38").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/39").setAllowedOrigins("*").withSockJS();
        registry.addEndpoint("/40").setAllowedOrigins("*").withSockJS();
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        registry.setApplicationDestinationPrefixes("/app");
        registry.enableSimpleBroker("/topic");
    }
}