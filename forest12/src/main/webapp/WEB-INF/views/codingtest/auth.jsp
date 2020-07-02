<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Code Forest</title>
	<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
	<link href="${pageContext.servletContext.contextPath }/assets/css/codingtest/auth.css" rel="stylesheet" type="text/css">	
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/ejs/ejs.js"></script>
</head>
<script>
var checkBirth = function CheckBirth(str){
	var regBirth = /^(19[0-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/;
	if(!regBirth.test(str)){
		return false;
	}else{
		return true;
	}
}

var FullendTime = "${problemVo.endTime}";
var FullendTimeSplit = FullendTime.split(" ");
var FullHours = FullendTimeSplit[1];
var FullHoursSplit = FullHours.split(":");

var tempKey = ${tempKey};
var slide = function Slide(str){
	$("#" + str).slideDown(500);
	$("#" + str).delay(2000).slideUp(500);
};

var messageBox = function(title,message,message2,callback){
	$('#dialog-message p').text(message);
	$('#dialog-message p+p').css({
		'color':'red'
	}).text(message2);
	$('#dialog-message')
		.attr("title",title)
		.dialog({
			modal:true,
			buttons:{
				"OK" : function(){
					callback();
				}, 
			},
			close:function(){}
		});
};

$(function(){
	$("#auth-form").submit(function(e){
		e.preventDefault();
		
		var _this = this;
		if($("#name").val() ==''){
			slide("empty-name");
			$("#name").focus();
			return;
		}
		if($("#birth").val() ==''){
			slide("empty-birth");
			$("#birth").focus();
			return;
		}
		if(!checkBirth($("#birth").val())){
			slide("wrong-birth");
			$("#birth").val("");
			return;			
		}
		
		if($("#tempKey").val() ==''){
			slide("empty-tempKey");
			$("#tempKey").focus();
			return;
		}
		if($("#tempKey").val() != tempKey){
			slide("wrong-tempKey");
			$("#tempKey").focus();			
			return;
		}
		 
		messageBox("Coding Test","코딩 테스트를 시작합니다",FullHoursSplit[0]+"시 "+FullHoursSplit[1]+"분에 시험이 종료됩니다. ",function(){
			_this.submit();
		});
		
	});	
	
});
</script>
<body>
	<div class="wrong" id="empty-name" style="display: none">
		<p class="wrong-ptag">이름이 비었습니다</p>
	</div>
	<div class="wrong" id="empty-birth" style="display: none">
		<p class="wrong-ptag">생일이 비었습니다</p>
	</div>
	<div class="wrong" id="empty-tempKey" style="display: none">
		<p class="wrong-ptag">인증번호가 비었습니다</p>
	</div>
	<div class="wrong" id="wrong-tempKey" style="display: none">
		<p class="wrong-ptag">인증번호가 틀렸습니다</p>
	</div>
	<div class="wrong" id="wrong-birth" style="display: none">
		<p class="wrong-ptag">생일을 다시 확인해주세요</p>
	</div>	
	<div id="container">
		<div class="content" id="content">
	     	<div class="explain">
	     		<div class="logo">
					<a href="${pageContext.servletContext.contextPath }">Code Forest</a>
				</div>
				<div class="explain-content">
					<p>어서오세요!</p>
					<p>코딩테스트를 시작하기 전에 먼저 개인정보 입력이 필요합니다.</p>
					<p>이름과 생년월일 그리고 해당 코딩테스트의 입력 코드를 입력해주세요.</p>
					<p>마감시간이되면 화면이 자동으로 꺼지니 주의하시기 바랍니다.</p>
				</div>
			</div>					
			<div class="user" id="user">
				<form id="auth-form" method="POST" action="${pageContext.servletContext.contextPath }/codingtest/codemirror/${problemNo }">
					<div class="name">
						<input type="text" id="name" name="name" value="" placeholder="이름"/>
					</div>
					<div class="birth">
						<input type="text" id="birth" name="birth" value="" maxlength="10" oninput="numberMaxLength(this);" placeholder="생년월일ex)0000-00-00"/>
					</div>
					<div class="tempKey">
						<input type="text" id="tempKey" name="tempKey" value="" placeholder="인증번호"/>
					</div>
					<input class="auth-button" type="submit" value="테스트 시작"/>
				</form>
			</div>

			<div id="dialog-message" title="" style="display:none">
  				<p></p>
  				<p></p>
			</div>	
			
		</div>	<!-- content -->
	</div> <!--  container  -->
</body>
</html>