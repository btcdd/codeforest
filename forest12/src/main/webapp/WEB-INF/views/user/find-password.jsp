<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Code Forest</title>
<link href="" rel="stylesheet" type="text/css">
<link href="${pageContext.servletContext.contextPath }/assets/css/user/find-password.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script>

var pandan = false;
var inputEmail = '';

var loadingWithMask = function LoadingWithMask(){
		
	var widthWindow = window.innerWidth;
	var heightWindow = window.innerHeight;
		
	var mask = "<div id='mask' style='width: 100%;height: 100%;top: 0px;left: 0px;position: fixed;display: none; opacity: 0.9; background-color: #fff; z-index: 99;text-align: center;'></div>";
	var loadingImg = '';
		
	loadingImg += "<div id='loadingImg'>";
	loadingImg += "<img src='${pageContext.request.contextPath}/assets/images/user/spin.svg' style='position: absolute; top: 43%; left: 45%;z-index: 100;'/>";
	loadingImg += "</div>";
					
	$('body').append(mask).append(loadingImg);
		
	$('#mask').css({
		'width':widthWindow,
		'height':heightWindow,
		'opacity':'0.3'
	});
	$('#mask').show();
	$('#loadingImg').show();
}
	
var closeLoadingWithMask = function CloseLoadingWithMask(){
	$('#mask, #loadingImg').hide();
	$('#mask, #loadingImg').empty();
}

var slide = function Slide(str) {
	$("#" + str).slideDown(500);
	$("#" + str).delay(2000).slideUp(500);
}

$(function(){
	var tempKey = null;
	
	var email = $('#email').val();	
	if(email == ''){
		$('#btn-auth').attr("disabled",true);
		$('#btn-auth').css('color', '#8E8E8E');
	}
	
	$('#email').on("propertychange change keyup paste input", function() {
		var email = $('#email').val();
		
		if(email != ''){
			$('#btn-auth').attr("disabled",false);
			$('#btn-auth').css('color', '#0C0C0C');
		} else {
			$('#btn-auth').attr("disabled",true);
			$('#btn-auth').css('color', '#8E8E8E');
		}
		if(email != inputEmail) {
			$('#btn-auth').val('인증번호 전송');
			inputEmail = '';
			$('#auth-check').val('');
		}
	});
	
	$('#btn-auth').on('click', function(){
		var email = $('#email').val();	
		if($(this).val() == '인증번호 전송') {
			
			loadingWithMask();
			
			$.ajax({
				url:'${pageContext.request.contextPath}/api/user/emailAuth',
				async:true,
				type:'post',
				dataType:'json',
				data:'email='+ email,
				success:function(response){	
					
					if(response.data == false) {
						closeLoadingWithMask();
						slide("none-email");
						return;
					}
					
					$('#btn-auth').val('인증번호 확인');
					slide("send-auth-num");
					console.log(response.data);//인증키
					tempKey = response.data;
					closeLoadingWithMask();
					
					inputEmail = $('#email').val();
				},
				error: function(xhr, status, e) {
					console.error(status + ":" + e);
				}
			});
		} else {
			if(($('#auth-check').val() == tempKey) && ($('#auth-check').val() != "")){
				slide("check-auth-num");
				$('#email').attr("readonly", true);
				$('#auth-check').attr("readonly", true);
				pandan = true;
			} else {
				slide("disagree-auth");
			}
		}
	});
	
	$('#btn-auth-check').on('click',function(){
		if(!pandan) {
			slide("none-check-auth");
			return;
		}
		if(($('#auth-check').val() == tempKey) && ($('#auth-check').val() != "")){
			$('#find-form').submit();
		}
	});
});
</script>
</head>
<body>
	<div class="none-email" id="none-email" style="display: none">
		<p class="none-email-ptag">사용자를 찾을 수 없습니다</p>
	</div>
	<div class="disagree-auth" id="disagree-auth" style="display: none">
		<p class="disagree-auth-ptag">인증번호가 일치하지 않습니다</p>
	</div>
	<div class="none-check-auth" id="none-check-auth" style="display: none">
		<p class="none-check-auth-ptag">인증번호 확인 후 변경이 가능합니다</p>
	</div>
	<div class="check-auth-num" id="check-auth-num" style="display: none">
		<p class="check-auth-num-ptag">인증번호가 확인되었습니다</p>
	</div>
	<div class="send-auth-num" id="send-auth-num" style="display: none">
		<p class="send-auth-num-ptag">인증번호가 발송되었습니다</p>
	</div>
    <div id="container">
    	<div class="logo">
			<a href="${pageContext.servletContext.contextPath }">Code Forest</a>
		</div> <!-- logo -->
        <div id="content">
            <div id="user">
                <form id="find-form" method="post" action="${pageContext.servletContext.contextPath }/user/reset">
                	<div class="find-password">비밀번호 찾기</div>
                    <div class="email">
                        <label for="email"></label>
                        <input id="email" name="email" type="email" placeholder="가입하신 이메일을 입력해주세요."/>
                    </div>
                    <div id="auth" >
                    	<label for="auth-check"></label>
                    	<input id="auth-check" type="text" name="Auth" placeholder="인증번호 입력">
                        <input id="btn-auth" type="button" value="인증번호 전송" />
                    </div>
                    <input id="btn-auth-check" type="button" value="계속">
                </form>
            </div>
        </div>
    </div>
</body>
</html>

