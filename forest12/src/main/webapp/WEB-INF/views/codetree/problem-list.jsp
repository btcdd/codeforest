<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/codetree/problem-list.css">
<script>
$(function() {
	  var items = $(".accordion__items");

	  items.on("click",function(){
	    if($(this).hasClass("active")) {
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
  <h1 class="accordion__title">${saveVo.problemNo }. ${saveVo.title }</h1>
  <c:forEach items='${subProblemList }' var='subproblemvo' varStatus='status'>
	  <h2 class="accordion__items">문제 0${status.index + 1}</h2>
	  <div class="accordion__content">
	    <h3 class="accordion__content__caption">문제 내용</h3>
	    <div class="accordion__content__txt">${subproblemvo.contents }</div>
	    <h3 class="accordion__content__caption">예제 입력</h3>
	    <pre class="accordion__content__txt">${subproblemvo.examInput }</pre>
	    <h3 class="accordion__content__caption">예제 출력</h3>
	    <pre class="accordion__content__txt">${subproblemvo.examOutput }</pre>
	  </div>
  </c:forEach>


</div>
