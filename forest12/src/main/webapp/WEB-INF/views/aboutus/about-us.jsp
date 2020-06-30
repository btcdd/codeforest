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
</head>
<body>
	<c:import url="/WEB-INF/views/include/main-header.jsp" />
	<div class="container">
		<section class="codetree">
			<div>CODE TREE</div>
		</section>
		<section class="codingtest">
			<div>
				<div class="codingtest-img-div">
					<img class="codingtest-img" src="${pageContext.servletContext.contextPath }/assets/images/aboutus/about-us-codingtest.png">
				</div>
			</div>
		</section>
		<section class="training">
			<div>
				<div class="training-img-div">
					<img class="training-img" src="${pageContext.servletContext.contextPath }/assets/images/aboutus/about-us-training2.png">
				</div>
			</div>
		</section>
	</div>
	<c:import url="/WEB-INF/views/include/footer.jsp" />
</body>
</html>