<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Code Forest</title>
    <link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/mypage-header.css">
    <link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
    <link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/mypage/mypage.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
    <script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
</head>
<script>

function leadingZeros(n, digits) {
	  var zero = '';
	  n = n.toString();

	  if (n.length < digits) {
	    for (i = 0; i < digits - n.length; i++)
	      zero += '0';
	  }
	  return zero + n;
}

function getTimeStamp() {
	  var d = new Date();
	  var s =
	    leadingZeros(d.getFullYear(), 4) + '-' +
	    leadingZeros(d.getMonth() + 1, 2) + '-' +
	    leadingZeros(d.getDate(), 2) + ' ' +

	    leadingZeros(d.getHours(), 2) + ':' +
	    leadingZeros(d.getMinutes(), 2) + ':' +
	    leadingZeros(d.getSeconds(), 2);

	  return s;
}

var time = getTimeStamp();

$(function() {
	$('#MOVE-TOP').remove();
});

</script>
<body>
	<c:import url="/WEB-INF/views/include/mypage-header.jsp" />
    <div class="container">
        <div class="">
            <div class="ranking">
                <h4>랭킹 ${rank } 위</h4>
                <div class="safe-password"><i class="fas fa-info-circle info"></i>삭제되거나, 비공개인 문제는 이동이 불가능합니다.</div>
            </div>
            <div>
                <div class="correct">
                    <h4>맞은 문제</h4>
                </div>
                <div class="correct-answer">
                	<c:if test="${empty rightSubmit }">
                		<div class="empty-right-submit"><i class="far fa-lightbulb"></i><span class="light">아직 <strong>맞은 문제</strong>가 없습니다.</span></div>
                	</c:if>
                    <c:forEach items='${rightSubmit }' var='vo' varStatus='status'>
	                	<c:set var="time" value="${time }" />
                    	<c:choose>
                    		<c:when test="${vo.state eq 'n' }">
		                    	<span><a id="right-problem-none" style="color: #616161">${vo.subproblemNo }</a></span>
                    		</c:when>
                    		<c:when test="${vo.privacy eq 'n' }">
		                    	<span><a id="right-problem-none" style="color: #616161">${vo.subproblemNo }</a></span>
                    		</c:when>
                    		<c:when test="${vo.startTime >= time && vo.endTime <= time}">
		                    	<span><a id="right-problem-none" style="color: #616161">${vo.subproblemNo }</a></span>
                    		</c:when>
                    		<c:otherwise>
		                    	<span><a id="right-problem" href="${pageContext.servletContext.contextPath }/training/view/${vo.problemNo }">${vo.subproblemNo }</a></span>
                    		</c:otherwise>
                    	</c:choose>
                    </c:forEach>
                </div>
            </div>
            <br>
            <div>
                <div class="wrong">
                    <h4>틀린 문제</h4>
                </div>
                <c:if test="${empty wrongSubmit }">
                		<div class="empty-wrong-submit"><i class="far fa-lightbulb"></i><span class="light">아직 <strong>틀린 문제</strong>가 없습니다.</span></div>
                	</c:if>
                <div class="wrong-answer">
                    <c:forEach items='${wrongSubmit }' var='vo' varStatus='status'>
	                	<c:set var="time" value="${time }" />
                    	<c:choose>
                    		<c:when test="${vo.state eq 'n' }">
		                    	<span><a id="wrong-problem-none" style="color: #616161">${vo.subproblemNo }</a></span>
                    		</c:when>
                    		<c:when test="${vo.privacy eq 'n' }">
		                    	<span><a id="wrong-problem-none" style="color: #616161">${vo.subproblemNo }</a></span>
                    		</c:when>
                    		<c:when test="${vo.startTime >= time && vo.endTime <= time}">
		                    	<span><a id="wrong-problem-none" style="color: #616161">${vo.subproblemNo }</a></span>
                    		</c:when>
                    		<c:otherwise>
		                    	<span><a id="wrong-problem" href="${pageContext.servletContext.contextPath }/training/view/${vo.problemNo }">${vo.subproblemNo }</a></span>
                    		</c:otherwise>
                    	</c:choose>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
	<c:import url="/WEB-INF/views/include/footer.jsp" />
</body>

</html>