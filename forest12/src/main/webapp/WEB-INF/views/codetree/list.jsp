<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code Forest</title>
    <link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/codetree/list.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
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
			
			if(map.count / 10 % 1 == 0) {
	        	 endPageTrueNum = map.count / 10;
	        } else {
		         endPageTrueNum = parseInt(map.count / 10 + 1);
	        }
			
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
	
	if(map.list.length == 0) {
		str = '<div class="nothing-save-problem"><div><i class="fas fa-hourglass-half fa-rotate-180" style="margin-right: 0.5em"></i><span>아직 저장된 문제가 존재하지 않습니다</span></div><div class="move-to-training"><a class="training-start" href="${pageContext.servletContext.contextPath }/training">CODING TRAINING 시작하기</a></div></div>';
		$(".problems").css('height','45vh');
	}
	
	for(var i=0;i<map.list.length;i++){
		str+= '<div data-user="'+map.list[i].userNo+'" data-no="'+map.list[i].no+'" class="problem-box" >'+
			'<div><div class="problem-no">'+map.list[i].problemNo+'</div>'+
			'<img class="top-right-arrow" src="${pageContext.servletContext.contextPath }/assets/images/codetree/top-right-arrow.png"></div>'+
			'<div class="problem-title">'+map.list[i].title+'</div>'+
			'<div class="subproblem-category-writer-content"><div class="sub-problem-count-title">문제 개수<div class="sub-problem-count">'+ map.subProblemNoCountList[i] +'</div></div>'+
			'<div class="category">카테고리<div class="category-title">' + map.list[i].kind + '</div></div>'+
			'<div class="writer">작성자<div class="writer-title">' + map.list[i].nickname + '</div></div></div>'+
		'</div>';
	}
	$(".problems").append(str);
	var str2 = "<div class='pager'>";
	if(page != '1'){
		str2 += '<span class="prev"><i class="fas fa-angle-left"></i></span>';
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
		str2 += '<span class="next"><i class="fas fa-angle-right"></i></span>';
	}	
	str2 += "</div>";
	$(".problems").after(str2);
	
	$('.problem-box').hover(function() {
		$(this).children().children('img').attr("src", '${pageContext.servletContext.contextPath }/assets/images/codetree/top-right-arrow-hover.png');
	}, function(){
		$(this).children().children('img').attr("src", '${pageContext.servletContext.contextPath }/assets/images/codetree/top-right-arrow.png');
	});
}
var nextRemove = function() {
	var endPage = map.endPageNum - 1;
	var nextPandan = true;
	
	if(page == endPage) {
		$('.next').remove();
		nextPandan = false;
	} else if(nextPandan == false){
		$('.pager').append('<span class="next"><i class="fas fa-angle-right"></i></span>');
		nextPandan = true;
	}
}
$(function() {
	originList('1', '');
	
	nextRemove();
	
	$(document).on("click", ".page", function() {
		page = $(this).attr('id');
		originList(page, kwd);
		nextRemove();
		
	});
	$(document).on("click", ".prev", function() {
		page = $('span b').parent().attr('id');
		var prevNo = parseInt(page) - 1;
		page = String(prevNo);
		originList(page, kwd);
		nextRemove();
	});
	$(document).on("click", ".next", function() {
		page = $('span b').parent().attr('id');
		var prevNo = parseInt(page) + 1;
		page = String(prevNo);
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
		var saveNo = $(this).data('no');
		$.ajax({
	          url:'${pageContext.request.contextPath }/api/codetree/codemirror',
	          async:false,
	          type:'post',
	          dataType:'json',
	          data : {
	        	  'saveNo':saveNo
	        	  },
	          success:function(response){
 				 var codetreeURL = '${pageContext.request.contextPath }/codetree/' + response.data.saveNo
			     window.open(codetreeURL,'_blank');  
	          },
	          error: function(xhr, status, e) {
	             console.error(status + ":" + e);
	          }
	       }); 
	});
});

</script>   
</head>
<body>
	<c:import url="/WEB-INF/views/include/main-header.jsp" />
	<div class="content">
        <div class="search">
            <input type="text" id="kwd" name="kwd" placeholder="Search.." onKeyDown="onKeyDown();">
            <input type="button" id="search" value="검색" >
        </div>
        <div class="list">
            <div class="problems">
            	<div class="explain-div">
            		<div class="explain"><strong class="title-strong">CODE TREE</strong><br/><br/>
회원님이 어려워 하는 알고리즘/자료구조는 무엇인가요?<br/>회원님이 직접 저장한 문제들을 풀어보면서, 회원님의 알고리즘 능력을 향상시켜 보세요. </div>
            		<img class="img" src="${pageContext.request.contextPath }/assets/images/codetree/codetree-logo.png">
            	</div>
            </div>
        </div>
	</div>
	<c:import url="/WEB-INF/views/include/footer.jsp" />
</body>
</html>