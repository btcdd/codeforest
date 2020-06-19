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
</head>

<body>
	<c:import url="/WEB-INF/views/include/mypage-header.jsp" />
    <div class="container">
        <div class="">
            <div class="ranking">
                <h4>랭킹 1위</h4>
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
                    	<span><a id="right-problem" href="${pageContext.servletContext.contextPath }/training/view/${vo.problemNo }">${vo.subproblemNo }</a></span>
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
                    	<span><a id="wrong-problem" href="${pageContext.servletContext.contextPath }/training/view/${vo.problemNo }">${vo.subproblemNo }</a></span>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
	<c:import url="/WEB-INF/views/include/footer.jsp" />
</body>

</html>