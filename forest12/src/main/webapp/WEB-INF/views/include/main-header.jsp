<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<div class="header" id="header">
    <div class="head-navigation">
        <div class="logo">
            <a class="title" href="${pageContext.servletContext.contextPath }">Code Forest</a>
        </div>
        <div class="menulist clearfix">
        	<ul class="menu">
			  <li><a href="${pageContext.servletContext.contextPath }/about" data-hover="About Us">About Us</a></li>
			  <li><a href="${pageContext.servletContext.contextPath }/codetree/list" data-hover="Code Tree">Code Tree</a></li>
			  <li><a href="${pageContext.servletContext.contextPath }/codingtest" data-hover="Coding Test">Coding Test</a></li>
			  <li><a href="${pageContext.servletContext.contextPath }/training" data-hover="Coding Training">Coding Training</a></li>
			</ul>
        </div>
        <div class="menu-user clearfix">
	        <c:choose>
				<c:when test="${empty authUser }">
					<div class="menu-item"><a href="${pageContext.servletContext.contextPath }/user/login">Sign In</a></div>
					<div class="menu-item"><a href="${pageContext.servletContext.contextPath }/user/join">Sign Up</a></div>
				</c:when>
				<c:otherwise>
					<div class="menu-item"><a href="${pageContext.servletContext.contextPath }/mypage/account">Settings</a></div>
					<div class="menu-item"><a href="${pageContext.request.contextPath }/user/logout">Sign Out</a></div>
				</c:otherwise>
			</c:choose>
        </div>
        
    </div>
</div>