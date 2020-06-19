<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Code Forest</title>
<link href="${pageContext.servletContext.contextPath }/assets/css/test/list.css" rel="stylesheet" type="text/css">
<link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/ejs/ejs.js"></script>
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>

<script>

var list1 = new EJS({
	url: "${pageContext.request.contextPath }/assets/js/ejs/list1.ejs"
});

var list2 = new EJS({
	url: "${pageContext.request.contextPath }/assets/js/ejs/list2.ejs"
});

var list3 = new EJS({
	url: "${pageContext.request.contextPath }/assets/js/ejs/list3.ejs"
});


$(function(){
	$('#search').on("propertychange change keyup paste", function(){		
		var keyword = $(this).val();
		$.ajax({
			url: '${pageContext.servletContext.contextPath }/api/codingtest/search',
			async: true,
			type: 'post',
			dataType: 'json',
			data: 'keyword='+keyword,
			success: function(response) {
				$(".test").remove();
				
				var html1 = list1.render(response);
				var html2 = list2.render(response);
				var html3 = list3.render(response);

				$(".proceeding-box").append(html1);				
				$(".expected-box").append(html2);				
				$(".deadline-box").append(html3);
				
			
			},
			error: function(xhr, status, e) {
				console.error(status + ":" + e);
			}
		});
		
	});
	
});
</script>
<title>Code Forest</title>
</head>
<body>
	<c:import url="/WEB-INF/views/include/main-header.jsp" />
	<div class="content">
		<div class="search">
           <input type="text" id="search" placeholder="Search..">
        <button class="make-problem" onclick="location.href='${pageContext.servletContext.contextPath }/codingtest/write'">문제 작성</button>
        </div>
		<div class="proceeding-box">
			<c:forEach items='${list1 }' var='vo' step='1' varStatus='status'>
				<div class="test" data-no="${vo.no }" id="priority${vo.priority }" 
				onclick="window.open('${pageContext.servletContext.contextPath }/codingtest/auth/${vo.no}','_blank'); " >
					<div class="test-top">
						<div class="test-no">${fn:length(list1) - status.index }</div>						
						<div class="writer">${vo.nickname }</div>
						<div class="state">진행</div>
					</div>
					<div class="test-mid">
						<div class="title">${vo.title }</div>
					</div>
					<div class="test-bottom">
						<div class="date">
							<div>
								<p class="start-time">시작</p>${vo.startTime }
							</div>
							<div>
								<p class="end-time">마감</p>${vo.endTime }
							</div>
						</div>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="expected-box">
			<c:forEach items='${list2 }' var='vo' step='1' varStatus='status'>
				<div class="test" data-no="${vo.no }" id="priority${vo.priority }">
					<div class="test-top">
						<div class="test-no">${fn:length(list2) - status.index }</div>						
						<div class="writer">${vo.nickname }</div>
						<div class="state">예정</div>
					</div>
					<div class="test-mid">
						<div class="probtitle">${vo.title }</div>
						<c:choose>
							<c:when test="${dday[vo.no] eq 0 }">
								<div class="d-day" data-no="${vo.no }">D-DAY</div>
							</c:when>
							<c:otherwise>
								<div class="d-day" data-no="${vo.no }">D${dday[vo.no] }</div>
							</c:otherwise>
						</c:choose>
					</div>
					<div class="test-bottom">
						<div class="date">시작:${vo.startTime }<br/>마감:${vo.endTime }</div>
					</div>
				</div>
			</c:forEach>
		</div>
		<div class="deadline-box">
			<c:forEach items='${list3 }' var='vo' step='1' varStatus='status'>
				<div class="test" data-no="${vo.no }" id="priority${vo.priority }">
					<div class="test-top">
						<div class="test-no">${fn:length(list3) - status.index }</div>						
						<div class="writer">${vo.nickname }</div>
						<div class="state">마감</div>
					</div>
					<div class="test-mid">
						<div class="title">${vo.title }</div>	
					</div>
					<div class="test-bottom">
						<div class="date">시작:${vo.startTime }<br/>마감:${vo.endTime }</div>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
	<div id="footer">
	    <c:import url="/WEB-INF/views/include/footer.jsp" />
    </div>
</body>
</html>