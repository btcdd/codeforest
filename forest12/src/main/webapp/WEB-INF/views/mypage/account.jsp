<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Code Forest</title>
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/mypage-header.css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/mypage/account.css">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
<script>
var slide = function Slide(str) {
	$("#" + str).slideDown(500);
	$("#" + str).delay(2000).slideUp(500);
}

var checkPasswordPattern = function CheckPasswordPattern(str) {
	var pw = str;
	var num = pw.search(/[0-9]/g);
	var eng = pw.search(/[a-z]/ig);
	var spe = pw.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
		 
	if(pw.length < 8 || pw.length > 20){
		return false;
	}
	 
	if(pw.search(/₩s/) != -1){
		return false;
	}
	 
	if(num < 0 || eng < 0 || spe < 0 ){
		return false;
	}
	return true;
}

var password_pandan = false;
var passwordSecond_pandan = false;

var no = '${authUser.no}';
var email = '${authUser.email}';
var currentURL = '${pageContext.request.contextPath }/mypage/account'

var pandan = false;

var privacy;

var changeNickname = function(nickname) {
	$.ajax({
        url: '${pageContext.request.contextPath }/api/mypage/account/nickname',
        async: true,
        type: 'post',
        dataType: 'json',
        data: {
        	"nickname" : nickname,
        	"no" : no
        },
        success: function(response){
           if(response.result != "success") {
              console.error(response.message);
              return;
           }
           $('.auth-user').text(response.data);
        },
        error: function(xhr, status, e) {
           console.error(status + ":" + e);
        }
     });
}

var changePassword = function(password) {
	$.ajax({
        url: '${pageContext.request.contextPath }/api/mypage/account/password',
        async: true,
        type: 'post',
        dataType: 'json',
        data: {
        	"password" : password,
        	"no" : no
        },
        success: function(response){
           if(response.result != "success") {
              console.error(response.message);
              return;
           }
        },
        error: function(xhr, status, e) {
           console.error(status + ":" + e);
        }
     });
}

var deleteUser = function(password) {
	  $.ajax({
        url: '${pageContext.request.contextPath }/api/mypage/account/delete',
        async: true,
        type: 'post',
        dataType: 'json',
        data: {
        	"password" : password,
        	"email" : email,
        	"no" : no
        },
        success: function(response){
           if(response.data == 0) {
        	   pandan =  false;            	   
           } else {w
        	   pandan = true;
        	   $("#delete-user").dialog("close");
        	   window.location = "${pageContext.request.contextPath }";
           }
           if(response.result != "success") {
        	   pandan = false;
               console.error(response.message);
           }
           return pandan;
        },
        error: function(xhr, status, e) {
           console.error(status + ":" + e);
        }
      });   
	  return pandan;
}

var passwordIncorrect = true;

var privacyChange = function() {
	$.ajax({
        url: '${pageContext.request.contextPath }/api/mypage/account/privacy',
        async: true,
        type: 'post',
        dataType: 'json',
        data: {
        	"privacy" : privacy	
        },
        success: function(response){
           
        },
        error: function(xhr, status, e) {
           console.error(status + ":" + e);
        }
   });
}

$(function() {
	
	$('#password').on("propertychange change keyup paste input", function(){
		var password = $('#password').val();
		
		if($('#password').val().length == 0) {
			$('.error-password-pattern').hide();
			$('#password').css('background-image', 'none');
			$('#password-warning').hide();
			password_pandan = false;			
		} else {
			if(checkPasswordPattern(password) == false) {
				$('.error-password-pattern').show();
				$('#password').css('background-image', 'url("${pageContext.request.contextPath }/assets/images/user/cross.png")');
				$('#password').css('background-position', '190px');
				$('#password').css('background-repeat', 'no-repeat');
				$("#passwordSecond").attr("disabled",true);
				$("#passwordSecond").val('');
				$("#passwordSecond").css('background-color', '#DEDEDE');
				$('#passwordSecond').css('background-image', '');
				password_pandan = false;
			}
			
			if(checkPasswordPattern(password) == true) {
				$('.error-password-pattern').hide();
				$('#password').css('background-image', 'url("${pageContext.request.contextPath }/assets/images/user/check.png")');
				$('#password').css('background-position', '190px');
				$('#password').css('background-repeat', 'no-repeat');
				$("#passwordSecond").removeAttr("disabled");
				$("#passwordSecond").css('background-color', '#fff');
				password_pandan = true;
			}
		}
	});
	
	$('#passwordSecond').on("propertychange change keyup paste input", function(){
		if($('#passwordSecond').val().length == 0) {
			$('#passwordSecond').css('background-image', '');
			$("#passwordSecond").focus();
			passwordSecond_pandan = false;
		} else {
			if( $('#password').val() != $('#passwordSecond').val() ){
				$('#passwordSecond').css('background-image', 'url("${pageContext.request.contextPath }/assets/images/user/cross.png")');
				$('#passwordSecond').css('background-position', '190px');
				$('#passwordSecond').css('background-repeat', 'no-repeat');
				$("#passwordSecond").focus();
				
				passwordSecond_pandan = false;
			} else {
				$('#passwordSecond').css('background-image', 'url("${pageContext.request.contextPath }/assets/images/user/check.png")');
				$('#passwordSecond').css('background-position', '190px');
				$('#passwordSecond').css('background-repeat', 'no-repeat');
				passwordSecond_pandan = true;
			}
		}
		
	});
	
    $("#change-nickname").dialog({
        autoOpen: false,
        resizable: false,
        height: "auto",
        width: 400,
        modal: true,
        buttons: {
            "변경": function() {
            	changeNickname($('#nickname').val());
            	$(this).dialog("close");
            },
            "취소": function() {
                $(this).dialog("close");
            }
        }
    });
    $(document).on("click", "#nickname-btn", function(event) {
    	event.preventDefault();
    	
    	$("#change-nickname").dialog("open");
    	
   	   var len = $('.nickname-input').val().length;
   	   $('.nickname-input').focus();
   	   $('.nickname-input')[0].setSelectionRange(len, len);
    });

    $("#delete-user").dialog({
        autoOpen: false,
        resizable: false,
        height: "auto",
        width: 400,
        modal: true,
        buttons: {
            "탈퇴": function() {
            	if(deleteUser($('#delete').val())) {
            		$('#delete').val('');
            		$(this).dialog("close");
            		
            	} else {
            		if(passwordIncorrect) {
            			$(this).append("<pre id=passwordIncorrect>비밀번호가 맞지 않습니다.</pre>");
            			passwordIncorrect = false;
            		}
            	}
            },
            "취소": function() {
            	passwordIncorrect = true;
            	$('#delete').val('');
            	$('#passwordIncorrect').remove();
                $(this).dialog("close");
            }
        }
    });
    $("#delete-btn").on("click", function(event) {
    	event.preventDefault();
    	
        $("#delete-user").dialog("open");
        
        var hi2 = $('.ui-dialog-buttonset').eq(1).eq(1);
        console.log(hi2);
        hi2.removeClass('ui-dialog-buttonset');
        hi2.addClass('delete-user');
    });

    $("#change-password").dialog({
        autoOpen: false,
        resizable: false,
        height: "auto",
        width: 400,
        modal: true,
        buttons: {
            "변경": function() {
            	if(password_pandan == false || passwordSecond_pandan == false){
            		console.log("password-pandan : " + password_pandan + " / passwordSecond_pandan : " + passwordSecond_pandan);
					slide('wrong-password');
// 					$(this).dialog.dismiss();
            	} else {
	            	changePassword($('#password').val());
	                $(this).dialog("close");
            	}
            },
            "취소": function() {
                $(this).dialog("close");
            }
        }
    });
    $("#password-btn").on("click", function(event) {
    	event.preventDefault();
    	
        $("#change-password").dialog("open");
    });
    
    $("#privacy").dialog({
        autoOpen: false,
        resizable: false,
        height: "auto",
        width: 400,
        modal: true,
        buttons: {
            "확인": function() {
            	privacyChange();
            	$(this).dialog("close");
            },
            "취소": function() {
                $(this).dialog("close");
            }
        }
	});
    
    $('#open').click(function() {
    	privacy = $(this).val();
    	console.log(privacy);
    	
    	$("#privacy").dialog("open");
    })
    
    $('#no-open').click(function() {
    	privacy = $(this).val();
    	console.log(privacy);
    	
    	$("#privacy").dialog("open");
    })
});
</script>
</head>

<body>
	<div class="wrong" id="wrong-password" style="display: none">
		<p class="wrong-ptag">비밀번호가 일치하지 않습니다</p>
	</div>
    <c:import url="/WEB-INF/views/include/mypage-header.jsp" />
    <div class="container">
        <div class="nickname">
            <div class="line">
                <h4>사용자 이름 변경</h4>
            </div>
            <button id="nickname-btn">사용자 이름 변경</button>
        </div>
        <div class="password">
            <div class="line">
                <h4>비밀번호 변경</h4>
            </div>
           	<div class="safe-password"><i class="fas fa-info-circle info"></i>안전한 비밀번호를 만들고 같은 비밀번호를 다른 계정에 사용하지 마세요.</div>
            <button id="password-btn">비밀번호 변경</button>
        </div>
        <div class="disclosure">
            <div class="line">
                <h4>계정 공개 여부</h4>
            </div>
            <strong style="font-size: 0.9em">계정 비공개를 설정하시겠습니까?</strong>
            <div class="safe-password">계정 공개를 설정하시면 문제를 푼 기록, 팔로우와 관련된 모든 기록을 다른 사람이 열람 할 수 있습니다.</div>
			<div class="privacy-div">
	            <input id="open" type="radio" name="chk_info" value="open" checked="checked">공개
	            <input id="no-open" type="radio" name="chk_info" value="private">비공개
			</div>
        </div>
        <div class="delete">
            <div class="line">
                <h4 style="color: #cb2431">계정 삭제</h4>
            </div>
            <strong style="font-size: 0.9em">계정을 삭제하시겠습니까?</strong>
            <div class="safe-password"><i class="fas fa-info-circle info"></i>계정을 삭제하시면 사용자의 모든 기록이 사라집니다.</div>
            <button id="delete-btn">회원 탈퇴</button>
        </div>
    </div>
    
    <div id="change-nickname" title="사용자 이름 변경" style="display:none" >
           <pre class="nickname-pre">변경하실 사용자 이름을 입력해주세요.</pre>
           <form>
               <fieldset class="nickname-fieldset">
                   <label for="name">사용자 이름</label>
                   <input type="text" name="nickname" id="nickname" value="${authUser.nickname }" class="nickname-input" autocomplete="off">
                   <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
               </fieldset>
           </form>
       </div>
	
	    <div id="change-password" title="비밀번호 변경" style="display:none" >
	        <pre class="password-pre">변경하시려는 비밀번호를 입력해주세요.</pre>
	        <form>
	            <fieldset class="password-fieldset">
	                <label for="name">변경 비밀번호</label>
	                <input type="password" name="password" id="password" value="" class="text ui-widget-content ui-corner-all password-input" autocomplete="off">
	                <div class="error-password-pattern" style="display:none">
                   		8~20자 영문 대 소문자, 숫자, 특수문자를 사용하세요.
                   	</div>
	                <label for="name">비밀번호 확인</label>
	                <input type="password" name="passwordSecond" id="passwordSecond" value="" class="text ui-widget-content ui-corner-all password-input2" autocomplete="off">
	                <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
	            </fieldset>
	        </form>
	    </div>
	
	    <div id="delete-user" title="회원 탈퇴" style="display:none" >
	        <pre class="delete-pre">회원 탈퇴를 하시겠습니까?
회원 탈퇴를 하시면 문제를 푼 기록이 다 사라집니다.
아래 비밀번호를 입력하세요.</pre>
	        <form>
	            <fieldset class="delete-fieldset">
	                <label for="name">비밀번호 입력</label>
	                <input type="password" name="delete" id="delete" value="" class="text ui-widget-content ui-corner-all delete-input" autocomplete="off">
	
	                <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
	            </fieldset>
	        </form>
	    </div>
	    
	    <div id="privacy" title="공개 비공개 설정" style="display:none" >
	        <pre>공개 범위를 변경하시겠어요?</pre>
	    </div>
	<c:import url="/WEB-INF/views/include/footer.jsp" />
</body>

</html>