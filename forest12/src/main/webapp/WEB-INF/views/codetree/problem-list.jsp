<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/codetree/problem-list.css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/scroll/jquery.mCustomScrollbar.css" />
<script src="${pageContext.servletContext.contextPath }/assets/scroll/jquery.mCustomScrollbar.js"></script>

<script>
	//스크롤
	var scrollbar = function() {
		$("#box_1").mCustomScrollbar({
			theme : "inset"
		});
	}

	$(function() {

		scrollbar();

		$('#0').addClass("active");
		$('#0').next().toggleClass("open");
		
		var items = $(".accordion__items");

		items.on("click", function() {
			if ($(this).hasClass("active")) {
				$(this).removeClass("active");
				$(this).next().removeClass("open");
			} else {
				$(this).siblings().removeClass("active");
				$(this).next().siblings().removeClass("open");
				$(this).toggleClass("active");
				$(this).next().toggleClass("open");
			}
		});
	});
</script>


<div class="accordion">
	<c:forEach items='${subProblemList }' var='subproblemvo'
		varStatus='status'>
		<h2 class="accordion__items" id="${status.index }">#
			${subproblemvo.no } &nbsp;&nbsp;&nbsp; ${subproblemvo.title }</h2>
		<div class="accordion__content">
			<div class="problem-content">
				<h3 class="accordion__content__caption">문제 내용</h3>
				<div class="accordion__content__txt">${subproblemvo.contents }</div>
			</div>
			<div class="exam-input-content-large-div">
				<div class="examinput-content">
					<h3 class="accordion__content__caption">예제 입력</h3>
					<pre class="accordion__content__txt consolas">${subproblemvo.examInput }</pre>
				</div>
			</div>
				<div class="examoutput-content">
					<h3 class="accordion__content__caption">예제 출력</h3>
					<pre class="accordion__content__txt consolas" style="margin-bottom: 2.5em;">${subproblemvo.examOutput }</pre>
				</div>
		</div>
	</c:forEach>


</div>
