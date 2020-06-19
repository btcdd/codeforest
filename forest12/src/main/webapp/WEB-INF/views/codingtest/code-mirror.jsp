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
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Coding Test Auth</title>
	<link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/ejs/ejs.js"></script>
	<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
</head>
<script>
var endTime = "${problemVo.endTime}";
var years=0;
var days=0;
var hours=0;
var min=0;
var sec=0;
$(function() {
	console.log("endTime",endTime);

	var timer = setInterval(function(){
		var diff = (Date.parse(new Date(endTime)) - Date.parse(new Date())) / 1000; 
		if(diff <0){
			alert("시험 종료");
			clearInterval(timer);
			return;
		}
		
	 	if (diff >= (365.25 * 86400)) { // 365.25 * 24 * 60 * 60
	     	years = Math.floor(diff / (365.25 * 86400));
	     	diff -= years * 365.25 * 86400;
	  	}
		console.log("years>>",years);
		
	   	if (diff >= 86400) { // 24 * 60 * 60
	   		days = Math.floor(diff / 86400);
	   		diff -= days * 86400;	
	   	}
	   	console.log("days>>",days);
	   	if (diff >= 3600) { // 60 * 60   
	     	hours = Math.floor(diff / 3600);
	     	diff -= hours * 3600;
	   	}
	   	console.log("hours>>",hours);
	   	if (diff >= 60) {
	    	min = Math.floor(diff / 60);
	     	diff -= min * 60;
	   	}
	   	console.log("min>>",min);
	   	var sec = diff;
	   	console.log("sec>>",sec);
    	$("#content table td:first").text(hours+"시");
		$("#content table td+td").text(min+"분");
		$("#content table td:last").text(sec+"초"); 

	},1000);
	
});

</script>
<body>
	<div id="container">
		<div id="content">
			<table>
				<tr>
					<td></td>
					<td></td>
					<td></td>
				</tr>
			</table>						
		</div>
	</div>
</body>
</html>