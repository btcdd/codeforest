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
<link href="${pageContext.servletContext.contextPath }/assets/css/training/answer-list.css" rel="stylesheet" type="text/css">
<link href="${pageContext.servletContext.contextPath }/assets/css/training/header.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>

<!-- code mirror -->
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/css/codemirror.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/abcdef.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/blackboard.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/dracula.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/duotone-light.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/eclipse.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/moxer.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/neat.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/panda-syntax.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/solarized.css">
<link rel="stylesheet" href="${pageContext.request.contextPath }/assets/codemirror/theme/ttcn.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/codemirror/js/codemirror.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/codemirror/mode/clike.js"></script>

<script>
var page = '1';
var language = '';

var originList = function(page, language) {
	
	$.ajax({
		url: '${pageContext.request.contextPath }/api/training/answerlist',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'page': page,
			'language': language,
			'subProblemNo' : ${subProblemNo}
		},
		success: function(response){
			if(response.result != "success"){
				console.error(response.message);
				return;
			}
			map = response.data;
						 
			fetchList();
		},
		error: function(xhr, status, e){
			console.error(status + ":" + e);
		}
	});
}

var fetchList = function() {

    $("#answer-user tbody tr").remove();
	$(".correct-person-list .pager").remove();
	var str = "";
	for(var i = 0; i < map.list.length; i++){
		str += '<tr>' + 
            '<td>' + map.list[i].nickname + '</td>' + 
            '<td>' + map.list[i].lang + '</td>' + 
            '<td>' + map.list[i].tryCnt + '</td>' + 
            '<td class="' + i + '" id="showCode">코드 보기</td>' + 
            '<td id="hiddenCode' + i + '" style="display:none">' + map.list[i].code + '</td>' + 
         '</tr>';		
	}
	
	$("#answer-user tbody").append(str);
	
	var str2 = "<div class='pager'>";
	
	if(page != '1'){
		str2 += '<span class="prev">◀</span>';
	}	
	for(var i = map.startPageNum; i < map.endPageNum; i++){
		str2 += '<span class="page" id="' + i + '">';
		if(map.select != i ) {
			str2 += i;
		}
		if(map.select == i){
			str2 += '<b>'+i+'</b>';
		}
		str2 += '</span>';
	}
	if(map.next){
		str2 += '<span class="next">▶</span>';
	}	 
	str2 += "</div>";
		
	$("#answer-user").after(str2);
}

$(function() {
   var code = $('.CodeMirror')[0];
   var editor = CodeMirror.fromTextArea(code, {
   		lineNumbers: true,
   		mode: 'text/x-java',
   		theme: 'panda-syntax',
   		matchBrackets: true
   });
   
   $('.theme').click(function() {
	   var theme = $(".theme option:selected").val();
	   
	   editor.setOption("theme", theme);
   });
   
   $(document).on('click', '#showCode', function(event) {
	  var index = $(this).attr("class");
	  var code = $("#hiddenCode" + index).text();
	  editor.setValue(code);
   });
   
   // ---------------------------------------------------------------

	originList(page, language);
	
	$(document).on("click", ".page", function() {
		page = $(this).attr('id');
		originList(page, language);
	});
	
	$(document).on("click", ".prev", function() {
		page = $('span b').parent().attr('id');
		var prevNo = parseInt(page) - 1;
		page = String(prevNo);
		originList(page, language);
	});
	
	$(document).on("click", ".next", function() {
		page = $('span b').parent().attr('id');
		var prevNo = parseInt(page) + 1;
		page = String(prevNo);
		originList(page, language);
	});
   
	$('.language').change(function() {
		language = $(".language option:selected").val();
		originList(page, language);
	});
});

</script>

</head>
<body>
    <c:import url="/WEB-INF/views/include/main-header.jsp" />
    <div class="container">
       <div class="statistics">
           <table class="type09">
               <thead>
               <tr>
                   <th colspan = "2" scope="cols" style="text-align: center;">문제 ${index } </th>
               </tr>
               </thead>
               <tbody>
               <tr>
                   <th scope="row">정답</th>
                   <td>${subStatisticsVo.y }</td>
               </tr>
               <tr>
                   <th scope="row">오답</th>
                   <td>${subStatisticsVo.n }</td>
               </tr>
               <tr>
                   <th scope="row">C</th>
                   <td>${subStatisticsVo.c }</td>
               </tr>
               <tr>
                   <th scope="row">C++</th>
                   <td>${subStatisticsVo.cpp }</td>
               </tr>
               <tr>
                   <th scope="row">C#</th>
                   <td>${subStatisticsVo.cs }</td>
               </tr>
               <tr>
                   <th scope="row">JAVA</th>
                   <td>${subStatisticsVo.java }</td>
               </tr>
               <tr>
                   <th scope="row">Java Script</th>
                   <td>${subStatisticsVo.js }</td>
               </tr>
               <tr>
                   <th scope="row">Python</th>
                   <td>${subStatisticsVo.py }</td>
               </tr>
               <tr>
                   <th scope="row">정답율</th>
                   <td>${subStatisticsVo.rate } %</td>
               </tr>
               </tbody>
           </table>
       </div>
       	<div>
	       <select class="language" name="language">
	           <option value="all-language" selected="selected">모든 언어</option>	       	
	           <option value="c">C</option>
	           <option value="cpp">C++</option>
	           <option value="cs">C#</option>
	           <option value="java">JAVA</option>
	           <option value="js">Java Script</option>
	           <option value="py">Python</option>
	       </select>
      </div>
       <div class="correct-person-list">
           <table class="type09" id="answer-user">
               <thead>
               <tr>
                   <th scope="cols" style="text-align: center;">닉네임</th>
                   <th scope="cols" style="text-align: center;">언어</th>
                   <th scope="cols" style="text-align: center;">시도 횟수</th>
                   <th scope="cols" style="text-align: center;">코드 보기</th>
               </tr>
               </thead>
               <tbody>
				<c:forEach items='${list }' var='vo' step='1' varStatus='status'>
<!-- 	                <tr> -->
<%-- 	                   <td>${vo.nickname }</td> --%>
<%-- 	                   <td>${vo.lang }</td> --%>
<%-- 	                   <td>${vo.tryCnt }</td> --%>
<%-- 	                   <td class="${status.index }" id="showCode">코드 보기</td> --%>
<%-- 	                   <td id="hiddenCode${status.index }" style="display:none">${vo.code }</td> --%>
<!-- 	                </tr> -->
				</c:forEach>
               </tbody>
           </table>
       </div>
       <div class="code-mirror">
	       <select class="theme" name="theme">
	       	<optgroup label="black">
	           <option value="abcdef">abcdef</option>
	           <option value="blackboard">blackboard</option>
	           <option value="dracula">dracula</option>
	           <option value="moxer">moxer</option>
	           <option value="panda-syntax" selected="selected">panda-syntax</option>
	         </optgroup>
	         <optgroup label="white">
	           <option value="duotone-light">duotone-light</option>
	           <option value="eclipse">eclipse</option>
	           <option value="neat">neat</option>
	           <option value="ttcn">ttcn</option>
	           <option value="solarized">solarized</option>
	         </optgroup>
	       </select>
	       <textarea name="code" class="CodeMirror" id="code"></textarea>
      </div>
   </div>
</body>
</html>