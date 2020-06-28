<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Code Forest</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link href="${pageContext.servletContext.contextPath }/assets/css/include/header.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/main/main.css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

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
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

<script>

var result = '';
var tmp = '';
var lang;
var code;
var editor;
var execPandan;
var prevCursor;
var message;
var prevText = '';

//채팅 시작하기
function connect(event) {
	
	$('#result').val('');
	
// 	$('#result').val('프로그램이 시작되었습니다...\n');
	
// 	$('#result').attr("readonly", false);
	
// 	prevText = '';
	
// 	code = editor.getValue();
	
// 	// 서버소켓의 endpoint인 "/ws"로 접속할 클라이언트 소켓 생성
//     var socket = new SockJS('${pageContext.request.contextPath }/ws');
   
//     // 전역 변수에 세션 설정
//     stompClient = Stomp.over(socket);
//     stompClient.connect({}, onConnected, onError);
    
//     event.preventDefault();
}


function onConnected() {
	prevText = '';
    // Subscribe to the Public Topic
    stompClient.subscribe('/topic/public', onMessageReceived);

    execPandan = true;
    var chatMessage = {
            language:$(".lang option:selected").val(),
    		code:code,
    		execPandan: execPandan,
            type: 'CHAT'
        };
    execPandan = false;
    // Tell your username to the server
    stompClient.send("/app/chat",
        {},
        JSON.stringify(chatMessage)
    );
}


function onError(error) {
}

function sendMessage(event, res) {
	prevText = '';
	
	tmp = res;
	
    var messageContent = res;
    
    var chatMessage = {
        content: messageContent,
        language:$(".lang option:selected").val(),
		code:code,
		execPandan: execPandan,
        type: 'CHAT'
    };
    stompClient.send("/app/chat", {}, JSON.stringify(chatMessage));
    event.preventDefault();
}


function onMessageReceived(payload) {
    message = JSON.parse(payload.body);
    
    console.log('prevText:' + $('#result').val());
    
    prevText = '';
    prevText = $('#result').val() + '\n';
    $('#result').val(prevText + message.content);
    
    prevCursor = $('#result').prop('selectionStart') - 1;
    
    $('#result').scrollTop($('#result').prop('scrollHeight'));
    
    if(message.programPandan) {
    	$('#result').attr("readonly", true);
    }
}

$(function() {
	
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

   
    
   var save = false;
   
   var d = document.querySelector('.codeTest');
   d.addEventListener('submit', connect, true);
   
   var code = $('.CodeMirror')[0];
   editor = CodeMirror.fromTextArea(code, {
         lineNumbers: true,
         mode: 'text/x-java',
         theme: 'duotone-light',
         matchBrackets: true
   });
   
   $('.theme').click(function() {
      var theme = $(".theme option:selected").val();
      
      editor.setOption("theme", theme);
   });
   
   $('.lang').change(function() {
      lang = $(".lang option:selected").val();
      
      var face = '';
      
      if(lang === 'c') {
         face = '#include <stdio.h>\n\n' + 
            'int main() {\n' + 
               '\tprintf("Hello CodeForest!\\n");\n\n' + 
               '\treturn 0;\n' + 
            '}';
      } else if(lang === 'cpp') {
         face = '#include <iostream>\n\n' + 
                  'using namespace std;\n\n' + 
            'int main()\n' + 
            '{\n' + 
                '\tcout << "Hello CodeForest!" << endl;\n\n' + 
                '\treturn 0;\n' + 
            '}';
      } else if(lang === 'cs') {
         face = 'using System;\n\n' + 
                  'class HelloWorld {\n\n' + 
                 '\tstatic void Main() {\n' +  
                '\t\tConsole.WriteLine("Hello CodeForest");\n' + 
              '\t}\n' + 
            '}';
      } else if(lang === 'java') {
         face = '/*\n' + 
            "* 기본 언어 : 'JAVA'\n" + 
         "* 기본 테마 : 'panda-syntax'\n" + 
         '*/\n' + 
        'public class Test{\n' + 
              '\tpublic static void main(String[] args) {\n' + 
                  '\t\tSystem.out.println("Hello CodeForest!");\n' + 
            '\t}\n' + 
        '}\n';
      } else if(lang === 'js') {
         face = 'var str = "Hello CodeForest";\n\n' + 
                  'console.log(str);';
      } else if(lang === 'py') {
         face = 'print("Hello World")';
      }
      
      editor.setValue(face);
      $('#code').val(editor.getValue());
   });
   
    $('.CodeMirror').addClass('code');
    
    prevCursor = 0;
    var cursorPandan = false;
    $('#result').keydown(event, function(key) {
    	
    	if(message.programPandan) {
    		if(key.keyCode === 8 || key.keyCode === 13) {
    			return false;
    		}
    	}
    	
		if($(this).prop('selectionStart') < prevCursor + 1) {
			if(key.keyCode !== 37 && key.keyCode !== 38 && key.keyCode !== 39 && key.keyCode !== 40) {
				return false;
			}
		} else if($(this).prop('selectionStart') == prevCursor + 1) {
			if(key.keyCode === 8) {
				return false;
			}
		}
		
    	if(cursorPandan == false) {
	    	prevCursor = $(this).prop('selectionStart') - 1;
	    	cursorPandan = true;
    	}
    	if (key.keyCode == 13) {
    		cursorPandan = false;
    		
	        result = $(this).val().substring(prevCursor).replace("\n", ""); 
	        
	        sendMessage(event, result);
	        result = '';
    	}
   });
    
    $('#result').mousedown(function(){
    	$('#result').mousemove(function(e){
    		return false;
    	});
    });   

});

</script>
</head>
<body>
   <c:import url="/WEB-INF/views/include/main-header.jsp" />
   <div class="head-image">
      <div class="intro">
         <p>온라인에서</p>
         <p>쉽고 간단하게</p>
         <p class="end">코딩을 시작해보세요</p>
      </div>
      <c:choose>
         <c:when test="${empty authUser }">
            <a  class="join-btn" href="${pageContext.request.contextPath }/user/login">Get Started</a>
         </c:when>
         <c:otherwise>
            <a  class="join-btn" href="${pageContext.request.contextPath }/codetree/list">Get Started</a>
         </c:otherwise>
      </c:choose>
   </div>
   <div class="codeTest">
        <form action="" method="post">
            <table class="tbl-ex">
               <tr>
                  <td style="float:left; width: 150px;">
                     <select class="lang" name="lang">
                         <option value="c">C</option>
                         <option value="cpp">C++</option>
                         <option value="cs">C#</option>
                         <option value="java" selected="selected">JAVA</option>
                         <option value="js">JavaScript</option>
                         <option value="py">Python</option>
                     </select>
                  </td>
                  <td style="float:left">
                     <select class="theme" name="theme">
                        <optgroup label="dark">
                         <option value="abcdef">abcdef</option>
                         <option value="blackboard">blackboard</option>
                         <option value="dracula">dracula</option>
                         <option value="moxer">moxer</option>
                         <option value="panda-syntax">panda-syntax</option>
                       </optgroup>
                       <optgroup label="light">
                         <option value="duotone-light" selected="selected">duotone-light</option>
                         <option value="eclipse">eclipse</option>
                         <option value="neat">neat</option>
                         <option value="ttcn">ttcn</option>
                         <option value="solarized">solarized</option>
                       </optgroup>
                     </select>
                  </td>
                  <td style="margin:0">
                   <span style="float: right;">
                     <input type="submit" class="btn-run" value="Run">
                   </span>
                 </td>
               </tr>
               <tr>
                  <td colspan="4">
                      <textarea name="code" class="CodeMirror code" id="code">
/*
* 기본 언어 : 'JAVA'
* 기본 테마 : 'panda-syntax'
*/
public class Test{
   public static void main(String[] args) {
      System.out.println("Hello CodeForest!");
   }
}</textarea>
                  </td>
                  <td>
                     <textarea name="" id="result" class="res" readonly></textarea>
                  </td>
               </tr>
            </table>
         </form>
    </div>
    <c:import url="/WEB-INF/views/include/footer.jsp" />
    <span id="MOVE-TOP"><i class="fas fa-angle-up custom"></i></span>
</body>
</html>