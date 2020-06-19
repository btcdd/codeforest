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
<link href="${pageContext.servletContext.contextPath }/assets/css/training/view.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
<script>
document.addEventListener('DOMContentLoaded', function() {
	  var likeButton = document.getElementById('like-button');
	  likeButton.addEventListener('click', function() {
	    window.lb = likeButton;
		likeButton.classList.toggle('selected');
	    recommendCheck();
	  });
}, false);

document.addEventListener('DOMContentLoaded', function() {
	  var saveButton = document.getElementById('save-button');
	  saveButton.addEventListener('click', function() {
	    window.lb = saveButton;
	    savePandan();
	    if(savePandanBool == true) {
			console.log("pandan true");
			saveProblem();
			$("#move-to-codetree").dialog('open');
			savePandanBool = false;
		} else {
			console.log("pandan false");
			deleteProblem();
			savePandanBool = true;
		}
	    saveButton.classList.toggle('selected');
	  });
}, false);

var savePandanBool = false;
var problemNo = '${problemVo.no}';
var array = new Array();


var setHeight = function() {
	for(var i = 1; i < ${listSize } + 1; i++) {
		var inputHeight = $('#input' + i).children().height();
		var outputHeight = $('#output' + i).children().height();
		
		console.log("inputHeight : " + inputHeight);
		console.log("outputHeight : " + outputHeight);
		
		if(inputHeight > outputHeight) {
			$('#output' + i).children().css("height", inputHeight);
			$('#input' + i).children().css("height", inputHeight);
// 			$('#output' + i).children().children().eq(1).css("height", inputHeight);
		} else if(inputHeight < outputHeight) {
			$('#input' + i).children().css("height", outputHeight);
			$('#output' + i).children().css("height", outputHeight);
// 			$('#input' + i).children().children().eq(1).css("height", outputHeight);
		}
	}
}

var linuxSaveCode = function() {
	$.ajax({
		url: '${pageContext.request.contextPath }/api/training/linux/savecode',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'problemNo': problemNo,
			'subProblemNoArray': array
		},
		success: function(response){
			if(response.result != "success"){
				console.error(response.message);
				return;
			}
			console.log("linucSaveCode가 안들어오닝?");
		},
		error: function(xhr, status, e){
			console.error(status + ":" + e);
		}
	});
}

var recommendCheck = function() {
	var likeButton = document.getElementById('like-button');
	$.ajax({
		url: '${pageContext.servletContext.contextPath }/api/training/recommend',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'problemNo': problemNo,
		},
		success: function(response){
			if(response.result != "success"){
				console.error(response.message);
				return;
			}
			map = response.data;
			$('#recommend-num').text(map.recommend);
		},
		error: function(xhr, status, e){
			console.error(status + ":" + e);
		}
	});
};

var originRecommend = function() {
	var likeButton = document.getElementById('like-button');
	$.ajax({
		url: '${pageContext.servletContext.contextPath }/api/training/recommend/origin',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'problemNo': problemNo,
		},
		success: function(response){
			if(response.result != "success"){
				console.error(response.message);
				return;
			}
			map = response.data;
			if(map.check > 0) {
				$('#like-button').addClass('selected');
			}
			$('#recommend-num').text(map.recommend);
		},
		error: function(xhr, status, e){
			console.error(status + ":" + e);
		}
	});
};

var savePandan = function() {
	$.ajax({
		url: '${pageContext.servletContext.contextPath }/api/training/savepandan',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'problemNo': problemNo,
		},
		success: function(response){
			if(response.result != "success"){
				console.error(response.message);
				return;
			}
			// 저장이 안되어있다면
			if(response.data == null) {
				$('#save-button').removeClass('selected');
				savePandanBool = true;
			// 저장이 되어있다면
			} else {
				$('#save-button').addClass('selected');
				console.log("removeclass");
				savePandanBool = false;
			}
		},
		error: function(xhr, status, e){
			console.error(status + ":" + e);
		}
	});
};

var saveProblem = function() {
	$.ajax({
		url: '${pageContext.request.contextPath }/api/training/save/problem',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'problemNo': problemNo,
			'subProblemNoArray': array
		},
		success: function(response){
			if(response.result != "success"){
				console.error(response.message);
				return;
			}
			linuxSaveCode();
		},
		error: function(xhr, status, e){
			console.error(status + ":" + e);
		}
	});
}

var deleteProblem = function() {
	$.ajax({
		url: '${pageContext.servletContext.contextPath }/api/training/delete',
		async: false,
		type: 'post',
		dataType: 'json',
		traditional: true,
		data: {
			'problemNo': problemNo,
		},
		success: function(response){
			if(response.result != "success"){
				console.error(response.message);
				return;
			}
		},
		error: function(xhr, status, e){
			console.error(status + ":" + e);
		}
	});
};

$(function() {
	
	$("#move-to-codetree").dialog({
		autoOpen: false,
		resizable: false,
		height: "auto",
		width: "auto",
		modal: true,
		buttons: {
			"이동": function() {	
				window.location.href='${pageContext.request.contextPath }/codetree/list'
			},
			"취소": function() {
				$(this).dialog('close');
			}
		},
		close: function() {
			$(".problem-list-table tr th").removeClass();
			$(".problem-list-table tr th").show();
			$(".box-component").each(function(){
			       $(this).prop('checked',true);
			});
			$(".problem-list-table > #tbody > tr").remove();
			$("#hidden-no").val('');
		}
	});
	
	$(window).scroll(function() {
        if ($(this).scrollTop() > 500) {
            $('#MOVE-TOP').fadeIn();
        } else {
            $('#MOVE-TOP').fadeOut();
        }
    });
    
    $("#MOVE-TOP").click(function() {
        $('html, body').animate({
            scrollTop : 0
        }, 400);
        return false;
    });
    
	originRecommend();
	savePandan();
	
	var no;
	
	$(".open1").show();
	$('.open1').parent().children().first().css("background-color", "#EBEBEB");

	setHeight();
	
	$(".top-prob").click(function() {
		no = $(this).parent().attr("id");
		
		if($(".open" + no).css("display") == "none"){
			$(".open" + no).show("slow");
			$(".open" + no).parent().children().first().css("background-color", "#EBEBEB");
			setHeight();
		} else {
			$(".open" + no).hide("slow");
			$(".open" + no).parent().children().first().css("background-color", "#fff");
		}
	});
  
	$(document).on("click","#code-tree", function() {
      $.ajax({
         url:'${pageContext.request.contextPath }/api/codetraining/mylist/'+problemNo,
         async:false,
         type:'get',
         dataType:'json',
         data : '',
         success:function(response){
             var url = "http://localhost:9999/codingtraining?userEmail=" + response.data.authUser.email+ "&problemNo=" + response.data.problemVo.no;
             
             window.open(url,'_blank');
         },
         error: function(xhr, status, e) {
            console.error(status + ":" + e);
         }
      });
   });
	
	for(var i = 0; i < ${listSize }; i++) {
		var subProblemNo = $('.sub' + i).attr("value");
		array.push(subProblemNo);
	}
});
</script>
</head>

<body>
    <c:import url="/WEB-INF/views/include/main-header.jsp" />
    <div class="container">
        <div class="top">
        	<div class="no">${problemVo.no }</div>
            <div class="problem-title">${problemVo.title }</div>
            <div class="statistics-div">
	            <button type="button" id="statistics-button" onClick="location.href='${pageContext.servletContext.contextPath }/training/statistics/${problemVo.no }'">
	            <i class="fas fa-chart-bar"></i>
				  통계
				</button>
            </div>
            <div class="save-div">
	            <button type="button" id="save-button">
	            <i class="fas fa-save"></i>
				  저장
				</button>
            </div>
            <div class="recommend-div">
	            <button type="button" id="like-button">
	            	<i class="fas fa-heart"></i>
				  추천<p id="recommend-num">${problemVo.recommend }</p>
				</button>
            </div>
        </div>
        <div class="second-block">
        	<div class="hit">
	        	조회수  ${problemVo.hit + 1}
        	</div>
	       <c:if test="${problemVo.userNo eq authUser.no }">
	        	<div class="modify" style="margin-right: 1.5em;">
		       		<a href="${pageContext.servletContext.contextPath }/training/modify/${problemVo.no }">수정하기</a>
	       		</div>
	       </c:if>
        </div>
        <div class="problem-list">
        	<c:forEach items='${list }' var='vo' step='1' varStatus='status'>
				<div class="problem">
					<div class="pro pro${status.index + 1}" id="${status.index + 1}">
						<div class="top-prob">
							<div class="subProblemIndex"><i class="fas fa-bookmark bookmark"></i><strong>${status.index + 1 }</strong></div>
							<div class="subProblemNo"># ${vo.no }</div>
							<input class="sub${status.index }" type="hidden" value="${vo.no }" />
							<div class="subProblemTitle" id="click"><strong>${vo.title }</strong></div>
							<div class="correct-person">
					            <button type="button" id="correct-person-button" onClick="location.href='${pageContext.servletContext.contextPath }/training/answerlist/${status.index + 1}/${vo.no}'">
								  	맞은 사람
								</button>
				            </div>
						</div>
						
						<div class="open${status.index + 1}" style="display:none">
							<div class="explain">
								<pre>${vo.contents }</pre>
							</div>
							<div class="example">
								<div class="input">
									<fieldset>
										<legend class="example-division">예제 입력</legend>
										<div class="input-content" id="input${status.index + 1 }"><pre>${vo.examInput }</pre></div>
									</fieldset>
								</div>
								<div class="result">
									<fieldset>
										<legend class="example-division">예제 출력</legend>
										<div class="result-content" id="output${status.index + 1 }"><pre>${vo.examOutput }</pre></div>
									</fieldset>
								</div>
							</div>
						</div>
						
					</div>
				</div>
			</c:forEach>
        </div>
        
    </div>
    <c:import url="/WEB-INF/views/include/footer.jsp" />
    <span id="MOVE-TOP"><i class="fas fa-angle-up custom"></i></span>
    
    <div id="move-to-codetree" title="저장" style="display: none">
       <p>
          <span class="ui-icon ui-icon-alert" style="float: left; margin: 12px 12px 20px 0;">   
          </span>
          'CODE TREE'로 지금 이동하시겠습니까?
       </p>
       <form>
          <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
       </form>
    </div>
</body>

</html>
