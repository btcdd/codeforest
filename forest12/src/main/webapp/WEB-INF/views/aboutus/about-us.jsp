<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Code Forest</title>
<link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
<link href="${pageContext.servletContext.contextPath }/assets/css/aboutus/about-us.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script>
</head>
<script>
$(document).ready(function(){
	$(".navigation-codetree-span").hide();
	$(".navigation-codingtest-span").hide();
	$(".navigation-training-span").hide();
	
	
	$('#codetree-li').click(function(){
		var offset = $('#codetree').offset(); //선택한 태그의 위치를 반환
		console.log(offset);
        $('html').animate({scrollTop : offset.top - 200}, 500);
	});
	$('#codingtest-li').click(function(){
		var offset = $('#codingtest').offset(); //선택한 태그의 위치를 반환
		console.log(offset);
        $('html').animate({scrollTop : offset.top - 65}, 500);
	});
	$('#training-li').click(function(){
		var offset = $('#training').offset(); //선택한 태그의 위치를 반환
		console.log(offset);
        $('html').animate({scrollTop : offset.top - 65}, 500);
	});
	
	$("#codetree-li").hover(function(){
	  $(".navigation-codetree-span").fadeIn();
	}, function(){
	  $(".navigation-codetree-span").hide();
	});

	$("#codingtest-li").hover(function(){
	  $(".navigation-codingtest-span").fadeIn();
	}, function(){
	  $(".navigation-codingtest-span").hide();
	});

	$("#training-li").hover(function(){
	  $(".navigation-training-span").fadeIn();
	}, function(){
	  $(".navigation-training-span").hide();
	});
	
	
});

</script>
<body>
	<c:import url="/WEB-INF/views/include/main-header.jsp" />
	<div class="container">
		<section class="navigation">
			<div class="navigation-div">
				<nav>
					<ul class="navigation-ul">
						<li class="navigation-li" id="codetree-li" data-target="codetree"><i class="fas fa-laptop-code" style="font-size: 2em; margin-left: -2px;"></i><span class="navigation-codetree-span">CODE TREE</span></li>
						<li class="navigation-li" id="codingtest-li" data-target="codingtest"><i class="far fa-edit" style="font-size: 2em; margin-left: 2px;"></i><span class="navigation-codingtest-span">CODING TEST</span></li>
						<li class="navigation-li" id="training-li" data-target="training"><i class="fas fa-tasks" style="font-size: 2em;"></i><span class="navigation-training-span">CODING TRAINING</span></li>
					</ul>
				</nav>
			</div>
		</section>
		<section class="codetree" id="codetree">
			<div>
				<div class="codetree-start-div">
					<a class="codetree-start" href="${pageContext.servletContext.contextPath }/codetree/list"><i class="far fa-hand-point-right" style="margin-right: 0.5em;"></i>CODE TREE 시작하기</a>
				</div>
				<div class="codetree-img-div">
					<img class="codetree-img" src="${pageContext.servletContext.contextPath }/assets/images/aboutus/about-us-codetree.png">
				</div>
			</div>
		</section>
		<section class="codingtest" id="codingtest">
			<div>
				<div class="codingtest-start-div">
					<a class="codingtest-start" href="${pageContext.servletContext.contextPath }/codingtest"><i class="far fa-hand-point-right" style="margin-right: 0.5em;"></i>CODING TEST 시작하기</a>
				</div>
				<div class="codingtest-img-div">
					<img class="codingtest-img" src="${pageContext.servletContext.contextPath }/assets/images/aboutus/about-us-codingtest.png">
				</div>
			</div>
		</section>
		<section class="training" id="training">
			<div>
				<div class="training-start-div">
					<a class="training-start" href="${pageContext.servletContext.contextPath }/training"><i class="far fa-hand-point-right" style="margin-right: 0.5em;"></i>CODING TRAINING 시작하기</a>
				</div>
				<div class="training-img-div">
					<img class="training-img" src="${pageContext.servletContext.contextPath }/assets/images/aboutus/about-us-training2.png">
				</div>
			</div>
		</section>
	</div>
	<c:import url="/WEB-INF/views/include/footer.jsp" />
</body>
</html>