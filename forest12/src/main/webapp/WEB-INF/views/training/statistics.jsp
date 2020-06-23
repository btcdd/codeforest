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
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.bundle.min.js"></script>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js"></script>
<script>

$(function() {
	
	var title = [];
	var rate = [];
	for(var i = 0; i < ${size}; i++) {
		title.push('문제 ' + (i + 1));
		var rateTmp = $('#rate' + i).text();
		rate.push(rateTmp.substring(0, rateTmp.length - 3));
	}
	
    var rgbaRandom1 = [];
    var rgbaRandom2 = [];
    
    var randomNumber = function() {
    	var min=0;
        var max=255;
    	return Math.floor(Math.random() * (+max - +min)) + +min;
    }

    for(var i = 0; i < ${size}; i++) {
    	rgbaRandom1.push('rgba(' +  randomNumber() + ', ' + randomNumber() + ', ' + randomNumber()
    						+ ', 0.2)');
    }
    for(var i = 0; i < ${size}; i++) {
    	rgbaRandom2.push(rgbaRandom1[i].replace('0.2', '1'));
    }
	
	var ctx = document.getElementById('chart');
	var myChart = new Chart(ctx, {
		type: 'polarArea',
		data: {
			labels: title,
			datasets: [{
				label: '# of Votes',
				data: rate,
				backgroundColor: rgbaRandom1,
				borderColor: rgbaRandom2,
				borderWidth: 1
			}]
		},
		options: {
			responsive: false,
			scales: {
				yAxes: [{
					ticks: {
						beginAtZero: true
					}
				}]
			},
		}
	});
});
</script>
</head>

<body>
    <c:import url="/WEB-INF/views/include/main-header.jsp" />
	    <div class="statistics-container">
            <div class="line">
                <h4>문제 통계</h4>
            </div>
	        <div class="quizlist">
	            <table id="statistics-table">
	                <thead>
	                    <tr>
	                        <th></th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<th class="problem-title">문제 ${status.index+1 }</th>
	                        </c:forEach>
	                    </tr>
	                </thead>
	                <tbody>
	                    <tr>
	                        <th>정답</th>
	                        <c:forEach items='${subStatisticsList }' var='vo' step='1' varStatus='status'>
								<td>${vo.y }</td>
	                        </c:forEach>
	                    </tr>
	                    <tr>
	                        <th>오답</th>
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
								<td id="rate${status.index }" value="${vo.rate }">${vo.rate }%</td>	                        
	                        </c:forEach>
	                    </tr>
	                </tbody>
	            </table>
	        </div>
	        <div class="chart-div">
	            <canvas class="chart" id="chart" width="400" height="400"></canvas>
	        </div>
	    </div>
	    <c:import url="/WEB-INF/views/include/footer.jsp" />
</body>
</html>