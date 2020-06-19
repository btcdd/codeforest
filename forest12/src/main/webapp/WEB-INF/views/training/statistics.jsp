<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Code Forest</title>
<link href="${pageContext.servletContext.contextPath }/assets/css/training/statistics.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script>
$(function() {
	var tableWidth = $('#statistics-table').width();
	
	$('.line').css('width', tableWidth + 64 + 'px');
});
</script>
</head>

<body>
    <c:import url="/WEB-INF/views/include/main-header.jsp" />
	    <div class="side">
	        <nav>
	            <ul>
	            	<c:forEach items='${subProblemList }' var='vo' step='1' varStatus='status'>
		                <li class="menulist" title="${vo.title }">문제 ${status.index + 1} - ${vo.title }</li>
		            </c:forEach>
	            </ul>
	        </nav>
	    </div>
	    <div class="statistics-container">
	        <div class="quizlist">
	            <div class="line">
	                <h4>문제 통계</h4>
	            </div>
	            <br />
	            <table id="statistics-table">
	                <thead>
	                    <tr>
	                        <th></th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<th>문제 ${status.index+1 }</th>
	                        </c:forEach>
	                    </tr>
	                </thead>
	                <tbody>
	                    <tr>
	                        <th>맞았습니다</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.y }</td>
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>틀렸습니다</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.n }</td>
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>C</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.c }</td>
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>C++</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.cpp }</td>
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>C#</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.cs }</td>
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>Java</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.java }</td>	                        
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>JavaScript</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.js }</td>	                        
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>Python</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.py }</td>	                        
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>정답율</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.rate }%</td>	                        
	                        </c:forEach>
	                    </tr>
	                </tbody>
	            </table>
	        </div>
	    </div>
	    <c:import url="/WEB-INF/views/include/footer.jsp" />
</body>
</html>