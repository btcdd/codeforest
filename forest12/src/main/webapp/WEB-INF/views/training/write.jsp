<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="${pageContext.servletContext.contextPath }/assets/css/training/write.css" rel="stylesheet" type="text/css">
<link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/ckeditor/ckeditor.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
<title>Code Forest</title>
<script>
var index = 1;

var str;

var buttonStr;

var problemAdd = function() {

	str = '<div class="prob' + index + '">'
			+ '<div class="sub-title">'
			+ '<input class="sub-problem-title" type="text" name="subProblemList[' + index + '].title" placeholder="문제 제목을 입력하세요" required autocomplete="off"/>'
			+ '</div>'
			+ '<div class="sub-prob-content">'
			+ '<textarea class="content" id="prob-content-text' + index + '" name="subProblemList[' + index + '].contents" placeholder="내용을 입력하세요" required autocomplete="off"></textarea>'
			+ '</div>'
			+ '<br>'
			+ '<div class="ex-input">'
			+ '<div class="ex-input-title">입력 예제</div>'
			+ '<textarea id="ex-input-text" name="subProblemList[' + index + '].examInput" placeholder="입력 예제를 작성하세요" autocomplete="off"></textarea>'
			+ '</div>'
			+ '<div class="ex-output">'
			+ '<div class="ex-output-title">출력 예제</div>'
			+ '<textarea id="ex-output-text" name="subProblemList[' + index + '].examOutput" placeholder="출력 예제를 작성하세요" required autocomplete="off"></textarea>'
			+ '</div>'
			+ '</div>';

	buttonStr = '<li id="' + index + '" class="tablinks">' + (index + 1) + '<span class="delete" style="display: none" ><img src="${pageContext.request.contextPath}/assets/images/training/delete.png"></span></li>';
}

var setStyle = function(index2) {
	setTimeout(function() {
		var ckeContents2 = document.getElementsByClassName("cke_contents")[index2];
		ckeContents2.style = "height: 400px";
	}, 50);
}

$(function() {
	
	$('#addSubProblem').click(function() {
		event.preventDefault();

		problemAdd();

		$("#" + (index - 1)).after(buttonStr);
		$(".prob" + (index - 1)).after(str);
		$('.prob' + (index - 1)).hide();
		
		// 추가된 문제에 CKEditor 적용
		CKEDITOR.replace('prob-content-text' + index);
		
		$('li[name=selected]').removeAttr('name');
		$('#' + index).attr('name', 'selected');
		$('#' + index).trigger('click');
		
		$('#' + index).hover(function() {
			$(this).children().show();
			$(this).addClass('hover-tablinks');
		}, function() {
			$(this).children().hide();
			$(this).removeClass('hover-tablinks');
		});
		
		setStyle(index);
		
		index++;
	});

	$(document).on("click", ".tablinks", function() {
		event.preventDefault();

		$('.tabcontent').children().hide();
		
		var ind = $(this).attr('id');
		$('li[name=selected]').removeAttr('name');
		$('#' + ind).attr('name', 'selected');
		
		$('.prob' + (ind)).show();
	});

	// 코딩테스트 체크박스를 체크하면, 비밀번호와 시작 일자, 마감 일자를 설정할 수 있는 칸이 나타난다.
	$('.codingtest').click(function() {
		if ($(this).prop("checked")) {
			var passwordStr = '<div class="password"><div class="password-title">코딩 테스트 입력 코드</div><div class="password-input-div"><input class="password-input" type="text" name="password" required></div></div>';
			var privacyStr = '<div class="privacy"><div class="privacy-check-title">문제 공개 여부</div><div><input type="radio" name="privacy" value="hi" checked="checked">공개<input class="privacy-check-radio" type="radio" name="privacy" value="on">비공개</div></div>';
			var startDateStr = '<div class="date"><div class="start-date"><div class="start-date-title">시작 일자</div><input class="input-date" type="datetime-local" name="startTime" required></div><div class="end-date"><div class="end-date-title">종료 일자</div><input class="input-date" type="datetime-local" name="endTime" required></div></div>';

			$(".privateAndPassword").append(passwordStr).append(privacyStr).append(startDateStr);
		} else {
			$(".privateAndPassword .password").remove();
			$(".privacy").remove();
			$(".date").remove();
		}
	});

	$(document).on("click", ".delete", function() {
		if(index == 1) {
			alert('최소 1문제는 등록하셔야 합니다.');
			return;
		}
		
		var ind = $(this).parent().attr('id');
		$("#" + ind).remove();
		$('.prob' + ind).remove();
		
		for(var i = 0; i < index; i++) {
			if(!($('#' + i).attr('id'))) {
				for(var j = i + 1; j < index; j++) {
					$('#' + j).text(j.toString());
					$('#' + j).append('<span class="delete" style="display:none"><img src="${pageContext.request.contextPath}/assets/images/training/delete.png"></span>');
					
					// li id 설정
					$('#' + j).attr('id', (j-1).toString());
					// prob class 설정
					$('.prob' + j).attr('class', 'prob' + (j-1).toString());
					$('#prob-content-text' + j).attr('id', 'prob-content-text' + (j-1).toString());
				}
			}
		}
		
		index--;
		
		$('#' + (index-1)).trigger('click');
	});
	
	$('#fake-submit').click(function() {
		event.preventDefault();
		
		for(var i = 0; i < index; i++) {
			var str = $('.content').eq(i).val();
			str = str.replace(/(?:\r\n|\r|\n)/g, '<br />');
			$('.content').eq(i).val(str);
		}
		$("#true-submit").trigger("click");
	});
	
	$('#0').hover(function() {
		$(this).children().show();
		$(this).addClass('hover-tablinks');
	}, function() {
		$(this).children().hide();
		$(this).removeClass('hover-tablinks');
	});
	
	CKEDITOR.replace('prob-content-text0');
});

window.onload = function(){
	setTimeout(function() {
		var ckeContents = document.getElementsByClassName("cke_contents")[0];
		ckeContents.style = "height: 400px";
	}, 50);
};

function captureReturnKey(e) { 
    if(e.keyCode==13 && e.srcElement.type != 'textarea') 
    return false;
}

</script>
</head>
<body>
	<c:import url="/WEB-INF/views/include/main-header.jsp" />
	<form method="post"
		action="${pageContext.servletContext.contextPath }/training/write" onkeydown="return captureReturnKey(event)">
		<div class="regist">
			<pre class="make-coding-test-problem-info"><i class="fas fa-info-circle info"></i>  새로운 코딩 테스트 문제를 만들기 위해서는 아래의 체크 버튼을 눌러주세요</pre>
			<div class="codingtest-div">
				<div class="privateAndPassword">
					<div class="private">
						<input class="codingtest" type="checkbox">새 코딩 테스트 만들기
					</div>
				</div>
			</div>

			<div class="division">
				<div class="division-radio-title-div"><span class="division-radio-title">분류</span></div>
				<input name="kindNo" value="5" type="radio" checked="checked"/>기타
				<input name="kindNo" value="1" type="radio" />기업
				<input name="kindNo" value="2" type="radio" />개인
				<input name="kindNo" value="3" type="radio" />학원
				<input name="kindNo" value="4" type="radio" />학교
			</div>
			<div class="title">
				<input id="title-text" type="text" name="title" placeholder="문제집 제목을 입력하세요" autocomplete="off"/>
				<a id="btn-cancel"
					href="${pageContext.servletContext.contextPath }/training">취소</a> 
				<input id="fake-submit" type="submit" value="등록">
				<input id="true-submit" type="submit" value="등록" style="display:none">
			</div>
			<br />

			<div class="write-container">
			<div class="tab">
				<ul class="tab-ul">
					<li id="0" class="tablinks" name="selected">1<span class="delete" style="display: none"><img src="${pageContext.request.contextPath}/assets/images/training/delete.png"></span></li>
					<li id="addSubProblem">+</li>
				</ul>
			</div>
				<div id="problem" class="tabcontent">
					<div class="prob0">
						<div class="sub-title">
							<input class="sub-problem-title" type="text" name="subProblemList[0].title" placeholder="문제 제목을 입력하세요" required autocomplete="off" />
						</div>
						<div class="sub-prob-content">
							<textarea class="content" id="prob-content-text0" name="subProblemList[0].contents" placeholder="내용을 입력하세요" required autocomplete="off"></textarea>
						</div>
						<br />

						<div class="ex-input">
							<div class="ex-input-title">입력 예제</div>
							<textarea id="ex-input-text" name="subProblemList[0].examInput" placeholder="입력 예제를 작성하세요" autocomplete="off"></textarea>
						</div>

						<div class="ex-output">
							<div class="ex-output-title">출력 예제</div>
							<textarea id="ex-output-text" name="subProblemList[0].examOutput" placeholder="출력 예제를 작성하세요" required autocomplete="off"></textarea>
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
	<c:import url="/WEB-INF/views/include/footer.jsp" />
</body>
</html>