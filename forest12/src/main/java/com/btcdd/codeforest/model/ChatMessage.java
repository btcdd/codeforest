package com.btcdd.codeforest.model;

public class ChatMessage {

    private MessageType type;
    private String content;
    
	public MessageType getType() {
		return type;
	}
	public void setType(MessageType type) {
		this.type = type;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
	@Override
	public String toString() {
		return "ChatMessage [type=" + type + ", content=" + content + "]";
	}
}