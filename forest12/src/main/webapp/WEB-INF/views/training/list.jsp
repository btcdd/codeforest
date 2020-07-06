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
    <link href="${pageContext.servletContext.contextPath }/assets/css/training/list.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
    <link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
<script>

function onKeyDown() {
	if(event.keyCode == 13) {
		kwd = $('#kwd').val();
		levelChecked(page, kwd);
	}
}

var checkValues = new Array();
var page = '1';
var category = '';
var kwd = '';
var selectTag = '';
var hashtagText = '';
var scrollPandan = false;
var endPageTrueNum;

var originList = function(page, kwd, category) {
	
	$.ajax({
		url: '${pageContext.request.contextPath }/api/training/list',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'page': page,
			'kwd': kwd,
			'category': category,
			'checkValues': checkValues
		},
		success: function(response){
			if(response.result != "success"){
				console.error(response.message);
				return;
			}
			map = response.data;
			
			if(map.count / 12 % 1 == 0) {
	        	 endPageTrueNum = map.count / 12;
	        } else {
		         endPageTrueNum = parseInt(map.count / 12 + 1);
	        }
			
			for(i = 0; i < map.rankList.length; i++) {
				$("#rank" + (i+1)).text( map.rankList[i].nickname);
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
	var str = "";
	for(var i = 0; i < map.list.length;i++){
		str += '<div class="problem-box" onclick="location.href=' + "'" + '${pageContext.servletContext.contextPath }/training/view/' + map.list[i].no + "'" + '">' +
		'<div class="problem-no"><a class="problem-number" data-no=' + map.list[i].no + '>' + map.list[i].no +'</a></div>' +
		'<div class="problem-title" id="title">' + map.list[i].title + '</div>' +
        '<div class="problem-box-bottom"><div class="problem-recommend"><i class="fas fa-heart like"></i><span class="recommend-count">' + map.list[i].recommend + '</span></div><div class="problem-user">' + map.list[i].nickname + '</div>' + 
        '<div class="problem-kind">' + map.list[i].kind + '</div></div>' + 
	'</div>';
	}
	$(".problems").append(str).hide();
	$(".problems").fadeIn(800);
	
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
}

var levelChecked = function(page, kwd) {
	
	$("input[name=level]:checked").each(function(i) {
		checkValues.push($(this).val());
		category = 'level';
	})
	$("input[name=organization]:checked").each(function(i) {
		checkValues.push($(this).val());
		category = 'organization';
	})
	
	originList(page, kwd, category);
	checkValues = new Array();
}

var disabled = function(add, remove) {
	if(category === add) {
		$("input[name=" + remove + "]").attr("disabled", true);
	} else if(category === '') {
		$("input[name=" + add + "]").removeAttr("disabled");
		$("input[name=" + remove + "]").removeAttr("disabled");
	} else {
		$("input[name=" + remove + "]").removeAttr("disabled");
	}
	category = '';
}

var nextRemove = function() {
	var endPage = endPageTrueNum;
	
	if(page == endPage) {
		$('.next').remove();
	}
}

$(function() {

	originList('1', '', '');
	
	nextRemove();
	
	$(document).on("click", ".page", function() {
		page = $(this).attr('id');
		
		levelChecked(page, kwd);
		
		nextRemove();
	});
	
	$(document).on("click", ".prev", function() {
		page = $('span b').parent().attr('id');
		var prevNo = parseInt(page) - 1;
		page = String(prevNo);
		
		levelChecked(page, kwd);
		
		nextRemove();
	});
	
	$(document).on("click", ".next", function() {
		page = $('span b').parent().attr('id');
		var prevNo = parseInt(page) + 1;
		page = String(prevNo);
		levelChecked(page, kwd);
		
		nextRemove();
	});

	$('input[name=level]').change(function() {
		selectTag = $(this).attr('id');
		var text = $(this).parent().text().trim();
		var tagStr = '<div class="hashtag" name="' + selectTag + '">#' + text + ' </div>';
		
		if($("input[name=level]").is(":checked")) {
			
			$('.tag-content').css('margin-bottom', '-140px');
			
			if($('#' + selectTag).is(':checked')) {
				$('#tag-content').append(tagStr);
				$('.hashtag').hide();
				$('.hashtag').css('background-color', '#fff');
				$('.hashtag').css('border', '1.5px #fff solid');
				$('.hashtag').fadeIn(500);
				$('.hashtag').css('background-color', '#F0F0F0');
				$('.hashtag').css('color', '#0A93E2');
				$('.hashtag').css('border', '1.5px #F0F0F0 solid');
			} else {
				$('div[name=' + selectTag + ']').remove();
			}
			page = $('span b').parent().attr('id');
		} else {
			
			$('.tag-content').css('margin-bottom', '0');
			
			$('div[name=' + selectTag + ']').remove();
			
			page = '1';
			category = '';
		}
		levelChecked(page, kwd);
		
		disabled('level', 'organization');
		nextRemove();
	});
	
	$('input[name=organization]').change(function() {
		selectTag = $(this).attr('id');
		var text = $(this).parent().text().trim();
		var tagStr = '<div class="hashtag" name="' + selectTag + '">#' + text + ' </div>';
		
		if($("input[name=organization]").is(":checked")) {
			$('.tag-content').css('margin-bottom', '-140px');
			
			if($('#' + selectTag).is(':checked')) {
				$('#tag-content').append(tagStr);
				$('.hashtag').hide();
				$('.hashtag').css('background-color', '#fff');
				$('.hashtag').css('border', '1.5px #fff solid');
				$('.hashtag').fadeIn(500);
				$('.hashtag').css('background-color', '#F0F0F0');
				$('.hashtag').css('color', '#0A93E2');
				$('.hashtag').css('border', '1.5px #F0F0F0 solid');
			} else {
				$('div[name=' + selectTag + ']').remove();
			}
			page = $('span b').parent().attr('id');
		} else {
			
			$('.tag-content').css('margin-bottom', '0');
			
			$('div[name=' + selectTag + ']').remove();
			
			page = '1';
			category = '';
		}
		levelChecked(page, kwd);
		
		disabled('organization','level');
		nextRemove();
	});
	
	$('#search').on('click', function() {
		page = '1';
		kwd = $('#kwd').val();
		levelChecked(page, kwd);
		nextRemove();
	});
	
	$('.reset').click(function() {
		var inp = document.getElementsByTagName('input');
		for(var i = 0; i < inp.length; i++) {
			if(inp[i].type == 'checkbox') {
				inp[i].checked = false;
				inp[i].disabled = false;
			}
		}
		$('#kwd').val('');
		
		originList('1', '', '');
		
		$('.hashtag').remove();
		$('.tag-content').css('margin-bottom', '0');
	});
	
	$(window).scroll(function() {
		var height = $(document).scrollTop();
		
		if(height < 320) {
			$('.menu-bar-change').attr('class', 'menu-bar');
		}
		if(height >= 320) {
			$('.menu-bar').attr('class', 'menu-bar-change');
		}
	});
	
	$('#algorithm-toggle').click(function(){
	    if($('#algorithm-table').css('display') == 'none'){
		    $('#algorithm-table').show();
		    $(this).attr('class','fas fa-chevron-up up-menu');
		}else{
		    $('#algorithm-table').hide();
		    $(this).attr('class','fas fa-chevron-down up-menu');
		}
	});
	
	$('#category-toggle').click(function(){
	    if($('#category-table').css('display') == 'none'){
		    $('#category-table').show();
		    $(this).attr('class','fas fa-chevron-up up-menu');
		}else{
		    $('#category-table').hide();
		    $(this).attr('class','fas fa-chevron-down up-menu');
		}
	});
	
	$('#rank-toggle').click(function(){
	    if($('#rank-table').css('display') == 'none'){
		    $('#rank-table').show();
		    $(this).attr('class','fas fa-chevron-up up-menu');
		}else{
		    $('#rank-table').hide();
		    console.log($(this).attr('class'));
		    $(this).attr('class','fas fa-chevron-down up-menu');
		}
	});
});


</script>
</head>
<body>
    <c:import url="/WEB-INF/views/include/main-header.jsp" />
    <div class="tag-content" id="tag-content">
<!--     	<div class="hashtag">#Level1 </div> -->
    </div>
    <div class="content">
        <div class="menu-bar" id="menu-bar">
            <div class="algo">
            	<div class="algorithm"><span class="algorithm-title">알고리즘</span><i class="fas fa-chevron-up up-menu" id="algorithm-toggle"></i></div>
                <table id="algorithm-table">
                    <tr id="sub">
                        <td><input type="checkbox" id="one" name="level" value="one">
                            <label for="one"><span></span>level 1</label></td>
                    </tr>
                    <tr id="sub">
                        <td><input type="checkbox" id="two" name="level" value="two">
                            <label for="two"><span></span>level 2</label></td>
                    </tr>
                    <tr id="sub">
                        <td><input type="checkbox" id="three" name="level" value="three">
                            <label for="three"><span></span>level 3</label></td>
                    </tr>
                    <tr id="sub">
                        <td><input type="checkbox" id="four" name="level" value="four">
                            <label for="four"><span></span>level 4</label></td>
                    </tr>
                    <tr id="sub">
                        <td><input type="checkbox" id="five" name="level" value="five">
                            <label for="five"><span></span>level 5</label></td>
                    </tr>
                </table>
            </div>

            <div class="category-content">
            	<div class="category"><span class="category-title">분류</span><i class="fas fa-chevron-up up-menu" id="category-toggle"></i></div>
                <table id="category-table">
                    <tr id="sub">
                        <td><input type="checkbox" id="enterprise" name="organization" value="enterprise">
                            <label for="enterprise"><span></span>기업</label></td>
                    </tr>
                    <tr id="sub">
                        <td><input type="checkbox" id="individual" name="organization" value="individual">
                            <label for="individual"><span></span>개인</label></td>
                    </tr>
                    <tr id="sub">
                        <td><input type="checkbox" id="academy" name="organization" value="academy">
                            <label for="academy"><span></span>학원</label></td>
                    </tr>
                    <tr id="sub">
                        <td><input type="checkbox" id="school" name="organization" value="school">
                            <label for="school"><span></span>학교</label></td>
                    </tr>
                    <tr id="sub">
                        <td><input type="checkbox" id="other" name="organization" value="other">
                            <label for="other"><span></span>기타</label></td>
                    </tr>
                </table>
            </div>
            
            <div class="ranking">
            	<div class="rank"><span class="rank-title">랭킹</span><i class="fas fa-chevron-up up-menu" id="rank-toggle"></i></div>
                <table id="rank-table">
                    <tr id="sub">
                        <td><label><span class="rank-num">1</span><span class="rank-user-nickname" id="rank1"></span><img class="gold" src="${pageContext.servletContext.contextPath }/assets/images/training/gold.png" /></label></td>
                    </tr>
                    <tr id="sub">
                        <td><label><span class="rank-num">2</span><span class="rank-user-nickname" id="rank2"></span><img class="silver" src="${pageContext.servletContext.contextPath }/assets/images/training/silver.png" /></label></td>
                    </tr>
                    <tr id="sub">
                        <td><label><span class="rank-num">3</span><span class="rank-user-nickname" id="rank3"></label><img class="bronze" src="${pageContext.servletContext.contextPath }/assets/images/training/bronze.png" /></span></td>
                    </tr>
                    <tr id="sub">
                        <td><label><span class="rank-num">4</span><span class="rank-user-nickname" id="rank4"></span></label></td>
                    </tr>
                    <tr id="sub">
                        <td><label><span class="rank-num">5</span><span class="rank-user-nickname" id="rank5"></span></label></td>
                    </tr>
                </table>
            </div>
        </div> <!-- div menu-bar -->

        <div class="list">
            <div class="search">
                <input type="text" id="kwd" name="kwd" placeholder="Search.." onKeyDown="onKeyDown();" autoComplete="off">
                <input type="button" id="search" value="검색" >
                <button class="reset"><i class="fas fa-redo-alt"></i></button>
                <button class="make-problem" onclick="location.href='${pageContext.servletContext.contextPath }/training/write'">문제작성</button>
            </div>
            <div class="problems">
            </div> <!-- div problems -->
        </div> <!-- div list -->
    </div>
    <c:import url="/WEB-INF/views/include/footer.jsp" />
</body>

</html>
