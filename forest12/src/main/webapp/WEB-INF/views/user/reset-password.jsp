<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Code Forest</title>
<link href="" rel="stylesheet" type="text/css">
<link href="${pageContext.servletContext.contextPath }/assets/css/user/reset-password.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script>
var checkPasswordPattern = function CheckPasswordPattern(str) {
	var pw = str;
	var num = pw.search(/[0-9]/g);
	var eng = pw.search(/[a-z]/ig);
	var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
		 
	if(pw.length < 8 || pw.length > 20){
		return false;
	}
	 
	if(pw.search(/₩s/) != -1){
		return false;
	}
	 
	if(num < 0 || eng < 0 || spe < 0 ){
		return false;
	}
	return true;
}

$(function(){
	
	$("#login-form").submit(function(e){
		e.preventDefault();
		if( $('#password').val() == ''  || $('#passwordcheck').val() == ''){
			alert('비밀번호를 입력하세요');
			return;
		}
		if( $('#password').val() != $('#passwordcheck').val() ){
			alert('비밀번호가 다릅니다');
			return;
		}
		this.submit();
	});
		
	$('#password').on("propertychange change keyup paste input", function(){
		var password = $('#password').val();
		
		if($('#password').val().length == 0) {
			$('.error-password-pattern').hide();
			$('#password').css('background-image', 'none');
			$('#password-warning').hide();
			password_pandan = false;			
		} else {
			if(checkPasswordPattern(password) == false) {
				$('.error-password-pattern').show();
				$('#password').css('background-image', 'url("${pageContext.request.contextPath }/assets/images/user/cross.png")');
				$('#password').css('background-position', '275px');
				$('#password').css('background-repeat', 'no-repeat');
				password_pandan = false;
			}
			
			if(checkPasswordPattern(password) == true) {
				$('.error-password-pattern').hide();
				$('#password').css('background-image', 'url("${pageContext.request.contextPath }/assets/images/user/check.png")');
				$('#password').css('background-position', '275px');
				$('#password').css('background-repeat', 'no-repeat');
				password_pandan = true;
			}
		}
	});
	
	$('#passwordcheck').on("propertychange change keyup paste input", function(){
		if($('#passwordcheck').val() == '') {
			$('#password-warning').hide();
			$('#passwordcheck').css('background-image', 'none');
			$("#passwordcheck").focus();
			passwordcheck_pandan = false;
		}
		
		if( $('#password').val() != $('#passwordcheck').val() ){
			$('#passwordcheck').css('background-image', 'url("${pageContext.request.contextPath }/assets/images/user/cross.png")');
			$('#passwordcheck').css('background-position', '275px');
			$('#passwordcheck').css('background-repeat', 'no-repeat');
			$("#passwordcheck").focus();
			
			$('#password-warning').show();
			$('#password-warning').text('비밀번호가 일치하지 않습니다.');
			$('#password-warning').css('color', '#bf0000');
			$('#password-warning').css('margin', '5px 0 0 22px');
            
			$('#auth').remove();
			
			passwordcheck_pandan = false;
		} else {
			$('#passwordcheck').css('background-image', 'url("${pageContext.request.contextPath }/assets/images/user/check.png")');
			$('#passwordcheck').css('background-position', '275px');
			$('#passwordcheck').css('background-repeat', 'no-repeat');
			$('#password-warning').hide();
			passwordcheck_pandan = true;
		}
	});
	
});

</script>
</head>
<body>
    <div id="container">
    	<div class="logo">
			<a href="${pageContext.servletContext.contextPath }">Code Forest</a>
		</div> <!-- logo -->
        <div id="content">
            <div id="user">
                <form id="login-form" method="post" action="${pageContext.servletContext.contextPath }/user/change">
                	<input type="hidden" name="email" value="${email}" />
                	<input type="hidden" name="nickname" value="${nickname}" />
                    <div>
                        <label for="password"></label>
                        <input id="password" name="password" type="password" placeholder="새로운 비밀번호를 입력해주세요.">
                    </div>
                    <div class="error-password-pattern" style="display:none">
                   		8~20자 영문 대 소문자, 숫자, 특수문자를 사용하세요.
                   	</div>
                    <div>
                        <label for="passwordcheck"></label>
                        <input id="passwordcheck" name="passwordcheck" type="password" placeholder="새로운 비밀번호를 다시 입력해주세요.">
                    </div>
                        <p style="font-weight:bold; color:#f00;  text-align:left; padding-left:0">
                        <spring:hasBindErrors name="userVo">
                        	<c:if test='${errors.hasFieldErrors("password") }' ><br/>
                        		<spring:message
                        			code='${errors.getFieldError("password").codes[0] }'
                        		/>
                        	</c:if>
                        </spring:hasBindErrors>
                        </p>                    
                    <div>
                        <input id="complete" type="submit" value="설정 완료" />          
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>