<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/codetree/list.css">
    
	<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
    <link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
		  
<script>
function onKeyDown() {
	if(event.keyCode == 13) {
		kwd = $('#kwd').val();
		originList(page, kwd);
	}
}
var page = '1';
var kwd = '';
var originList = function(page, kwd) {
	$.ajax({
		url: '${pageContext.request.contextPath }/api/codetree/list',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'page': page,
			'kwd': kwd
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
	$(".list .problem-box").remove();
	$(".list .pager").remove();
	var str="";
	for(var i=0;i<map.list.length;i++){
		str+= '<div data-user="'+map.list[i].userNo+'" data-no="'+map.list[i].no+'" class="problem-box" >'+
			'<div class="problem-no">'+map.list[i].problemNo+'</div>'+
			'<div class="problem-title">'+map.list[i].title+'</div>'+
			'<div class="problem-user">'+map.list[i].kind +" "+ map.list[i].nickname+'</div>'+
		'</div>';
	}
	$(".problems").append(str);
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
	$(".problems").after(str2);
}
var nextRemove = function() {
	var endPage = map.endPageNum - 1;
	var nextPandan = true;
	
	if(page == endPage) {
		$('.next').remove();
		nextPandan = false;
	} else if(nextPandan == false){
		$('.pager').append('<span class="next">▶</span>');
		nextPandan = true;
	}
}
$(function() {
	originList('1', '');
	$(document).on("click", ".page", function() {
		page = $(this).attr('id');
		console.log("page>>>",page);
		originList(page, kwd);
		nextRemove();
		
	});
	$(document).on("click", ".prev", function() {
		page = $('span b').parent().attr('id');
		var prevNo = parseInt(page) - 1;
		page = String(prevNo);
		
		console.log(typeof(page) + " page: " + page + " / " + typeof(prevNo) + ":" + prevNo);
		originList(page, kwd);
		nextRemove();
	});
	$(document).on("click", ".next", function() {
		page = $('span b').parent().attr('id');
		var prevNo = parseInt(page) + 1;
		page = String(prevNo);
		console.log(typeof(page) + " page: " + page + " / " + typeof(prevNo) + ":" + prevNo);
		originList(page, kwd);
		nextRemove();
	});
	$('#search').on('click', function() {
		page = '1';
		kwd = $('#kwd').val();
		originList(page, kwd);
		nextRemove();
	});	
	
	$(document).on("click",".problem-box",function(){
/* 		var codetreeURL = '${pageContext.request.contextPath }/codetree/codemirror' 
		window.open(codetreeURL,'_blank'); */
		
		
		var saveNo = $(this).data('no');
		$.ajax({
	          url:'${pageContext.request.contextPath }/api/codetree/codemirror/',
	          async:false,
	          type:'post',
	          dataType:'json',
	          data : {
	        	  'saveNo':saveNo
	        	  },
	          success:function(response){
 				 var codetreeURL = '${pageContext.request.contextPath }/codetree/codemirror/' + response.data.saveNo
			     window.open(codetreeURL,'_blank');  
	          },
	          error: function(xhr, status, e) {
	             console.error(status + ":" + e);
	          }
	       }); 
		
	});
 		
/*  	      $.ajax({
	          url:'${pageContext.request.contextPath }/api/codetree/',
	          async:false,
	          type:'get',
	          dataType:'json',
	          data : '',
	          success:function(response){
	             console.log(response.data);
	             console.log(response.data.authUser.email);
var codetreeURL = '${pageContext.request.contextPath }/codetree/list/' + response.data.authUser.no
	          window.open('${pageContext.request.contextPath }/codetree/list/' + response.data.authUser.no,'_blank');
	          window.open(codetreeURL,'_blank');
	          window.open('','_blank');
	              

	              
	          },
	          error: function(xhr, status, e) {
	             console.error(status + ":" + e);
	          }
	       });  */

 	
});

</script>   
</head>
<body>
	<c:import url="/WEB-INF/views/include/main-header.jsp" />
	<!-- <div id="code-tree" class="menu-item"><a>Code Tree</a></div> -->
	<div class="content">
        <div class="search">
            <input type="text" id="kwd" name="kwd" placeholder="Search.." onKeyDown="onKeyDown();">
            <input type="button" id="search" value="검색" >
        </div>
        <div class="list">
            <div class="problems">
            </div>
        </div>			
<%-- 				<div class="list">		
					<c:forEach items="${saveVoList}" var="vo" varStatus="status">
						<div class="problem-box">
							<div class="problem-no">
							${vo.problemNo }<br/>
							</div>
							<div class="problem-title">
								<h4>${vo.title }</h4>
							</div>
							<div class="problem-user">
								${vo.kind }&nbsp;&nbsp;&nbsp;${vo.nickname }
							</div>															
						</div>
					</c:forEach>
				</div>
 --%>				<!-- pager 추가 -->
<!-- 				<div class ="pager">
					
				</div>				
 -->				
	</div>
<%-- 	<c:import url="/WEB-INF/views/include/footer.jsp" /> --%>
</body>
</html>