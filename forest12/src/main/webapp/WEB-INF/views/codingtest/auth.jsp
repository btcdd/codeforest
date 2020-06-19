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
	<title>Coding Test Auth</title>
	<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
	<link href="${pageContext.servletContext.contextPath }/assets/css/test/auth.css" rel="stylesheet" type="text/css">	
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/ejs/ejs.js"></script>
</head>
<script>
var FullendTime = "${problemVo.endTime}";
var FullendTimeSplit = FullendTime.split(" ");
var FullHours = FullendTimeSplit[1];
var FullHoursSplit = FullHours.split(":");

var tempKey = ${tempKey};
var slide = function Slide(str) {
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
	<div id="container">
		<div id="content">
	     	<div class="logo">
				<a href="${pageContext.servletContext.contextPath }">Code Forest</a>
			</div>					
			<div id="user">
				<form id="auth-form" method="POST" action="${pageContext.servletContext.contextPath }/codingtest/codemirror/${problemNo }">
					<div class="name">
						<input type="text" id="name" name="name" value="" placeholder="이름"/>
					</div>
					<div class="birth">
						<input type="date" id="birth" name="birth" value="" />
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
					
		</div>
	</div>
</body>
</html>