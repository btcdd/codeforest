<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	pageContext.setAttribute("newLine", "\n");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="${pageContext.servletContext.contextPath }/assets/css/training/modify.css" rel="stylesheet" type="text/css">
<link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/ckeditor/ckeditor.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
<title>Code Forest</title>
<script>
var index = ${listSize };

var array = [];
var top = 0;

var str;

var buttonStr;

var fetchStr;
var fetchButtonStr;

var password = '${problemVo.password }';

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
			+ '<div class="answer-code' + index + '">'
			+ '</div></div>';

	buttonStr = '<li id="' + index + '" class="tablinks">' + (index + 1) + '<span class="delete" style="display: none"><img src="${pageContext.request.contextPath}/assets/images/training/delete.png"></span></li>';
}

function leadingZeros(n, digits) {
	  var zero = '';
	  n = n.toString();

	  if (n.length < digits) {
	    for (i = 0; i < digits - n.length; i++)
	      zero += '0';
	  }
	  return zero + n;
}

function getTimeStamp() {
	  var d = new Date();
	  var s =
	    leadingZeros(d.getFullYear(), 4) + '-' +
	    leadingZeros(d.getMonth() + 1, 2) + '-' +
	    leadingZeros(d.getDate(), 2) + ' ' +

	    leadingZeros(d.getHours(), 2) + ':' +
	    leadingZeros(d.getMinutes(), 2) + ':' +
	    leadingZeros(d.getSeconds(), 2);

	  return s;
}

var fetchList = function() {
	var endTime = '${problemVo.endTime}';
	
	if(endTime !== '' && endTime < getTimeStamp()) {
		$('.codingtest-div').remove();
	} else if(password !== '') {
		
		var sd = '${problemVo.startTime}';
		var startDate = sd.substring(0, 10);
		startDate = startDate + 'T';
		startDate = startDate + sd.substring(11, 16);
		
		var ed = '${problemVo.endTime}';
		var endDate = ed.substring(0, 10);
		endDate = endDate + 'T';
		endDate = endDate + sd.substring(11, 16);
		
		var privateStr = '<div class="private">코딩테스트 <input class="codingtest" type="checkbox" checked></div>';
		
		if('${problemVo.privacy}' == 'y') {
			var privacyStr = '<div class="privacy"><div class="privacy-check-title">문제 공개 여부</div><div><input type="radio" name="privacy" value="hi" checked="checked">공개<input class="privacy-check-radio" type="radio" name="privacy" value="on">비공개</div></div>';
		} else {
			var privacyStr = '<div class="privacy"><div class="privacy-check-title">문제 공개 여부</div><div><input type="radio" name="privacy" value="hi">공개<input class="privacy-check-radio" type="radio" name="privacy" value="on" checked="checked">비공개</div></div>';
		}
		
		var passwordStr = '<div class="password"><div class="password-title">코딩 테스트 입력 코드</div><div class="password-input-div"><input class="password-input" type="text" name="password" value="${problemVo.password}" required></div></div>';
		var startDateStr = '<div class="date"><div class="start-date"><div class="start-date-title">시작 일자</div><input class="input-date" type="datetime-local" name="startTime" value="' + startDate + '" required></div><div class="end-date"><div class="end-date-title">종료 일자</div><input class="input-date" type="datetime-local" name="endTime" value="' + endDate + '" required></div></div>';
		
		$(".privateAndPassword").append(privateStr).append(passwordStr).append(privacyStr).append(startDateStr);
	} else {
		$('.codingtest-div').remove();
	}
	
	$('.prob0').show();
	$('#0').attr('name', 'selected');
}

var setStyle = function(index2) {
	setTimeout(function() {
		var ckeContents2 = document.getElementsByClassName("cke_contents")[index2];
		ckeContents2.style = "height: 400px";
	}, 50);
}

$(function() {
	
	fetchList();
	
	for(var i = 0; i < index; i++) {
		CKEDITOR.replace('prob-content-text' + i);
	}
	
	$('#addSubProblem').click(function() {
		event.preventDefault();

		problemAdd();

		$("#" + (index - 1)).after(buttonStr);
		$(".prob" + (index - 1)).after(str);
		$('.prob' + (index - 1)).hide();
		
		// 추가된 문제에 CKEditor 적용
		CKEDITOR.replace('prob-content-text' + index);
		
		$('#' + index).hover(function() {
			$(this).children().show();
		}, function() {
			$(this).children().hide();
		});
		
		$('li[name=selected]').removeAttr('name');
		$('#' + index).attr('name', 'selected');
		$('#' + index).trigger('click');
		
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
		var deleteNo = $(this).parent().attr("value");
		array.push(deleteNo);
		
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
	});
	
	var no;
	
	$('#fake-submit').click(function() {
		event.preventDefault();
		
		for(var i = 0; i < index; i++) {
			var str = $('.content').eq(i).val();
			str = str.replace(/(?:\r\n|\r|\n)/g, '<br />');
			$('.content').eq(i).val(str);
		}
		
		$('.privateAndPassword').append('<input type="hidden" name="array" value="' + array + '">');
		$("#true-submit").trigger("click");
	});
	
	if(!$('.codingtest').is(':checked')) {
		$('#addSubProblem').remove();
		$('.delete').remove();
		$('.privateAndPassword').remove();
	}
	
	for(var i = 1; i < index; i++) {
		$('.prob' + i).hide();
	}
	
	for(var i = 0; i < index; i++) {
		$('#' + i).hover(function() {
			$(this).children().show();
		}, function() {
			$(this).children().hide();
		});
	}
});

window.onload = function(){
	setTimeout(function() {
		for(var i = 0; i < index; i++) {
			var ckeContents = document.getElementsByClassName("cke_contents")[i];
			ckeContents.style = "height: 400px";
		}
	}, 50);
};

</script>
</head>
<body>
	<c:import url="/WEB-INF/views/include/main-header.jsp" />
	<form method="post" action="${pageContext.servletContext.contextPath }/training/modify/${problemVo.no }">
		<div class="regist">
		<div class="codingtest-div">
			<div class="privateAndPassword">
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
				<input id="title-text" type="text" name="title" value="${problemVo.title }" placeholder="문제집 제목을 입력하세요" required autocomplete="off"/>
				<a id="btn-cancel"
					href="${pageContext.servletContext.contextPath }/training">취소</a> 
				<input id="fake-submit" type="submit" value="등록">
				<input id="true-submit" type="submit" value="등록" style="display:none">
			</div>
			<br />
			<div class="write-container">
				<div class="tab">
					<ul class="tab-ul">
						<c:forEach items="${list }" var="item" varStatus="status" begin="0">
							<li id="${status.index }" class="tablinks" value="${item.no }">${status.index + 1}<span class="delete" style="display: none"><img src="${pageContext.request.contextPath}/assets/images/training/delete.png"></span></li>
						</c:forEach>
						<li id="addSubProblem">+</li>
					</ul>
					
				</div>

				<div id="problem" class="tabcontent">
					<c:forEach items="${list }" var="item" varStatus="status" begin="0">
						<c:set var="index" value="${status.index }" />
						<div class="prob${index }">
							<input type="hidden" name="subProblemList[${index }].no" value="${item.no }" />
							<div class="sub-title">
								<input class="sub-problem-title" type="text" name="subProblemList[${index }].title" value="${item.title }" placeholder="문제 제목을 입력하세요" required autocomplete="off" />
							</div>
							<div class="sub-prob-content">
								<textarea class="content" id="prob-content-text${index }" name="subProblemList[${index }].contents" placeholder="내용을 입력하세요" required autocomplete="off">${fn:replace(item.contents, "<br />", newLine)}</textarea>
							</div>
							<br />
	
							<div class="ex-input">
								<div class="ex-input-title">예제 입력</div>
								<textarea id="ex-input-text" name="subProblemList[${index }].examInput" placeholder="입력 예제를 작성하세요" autocomplete="off">${item.examInput }</textarea>
							</div>
	
							<div class="ex-output">
								<div class="ex-output-title">예제 출력</div>
								<textarea id="ex-output-text" name="subProblemList[${index }].examOutput" placeholder="출력 예제를 작성하세요" required autocomplete="off">${item.examOutput }</textarea>
							</div>
						</div> <!--  prob0 -->
					</c:forEach>
				</div>
			</div>
		</div>
	</form>
	<c:import url="/WEB-INF/views/include/footer.jsp" />
</body>
</html>