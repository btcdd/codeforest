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
<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.5/sockjs.js"></script>
<script src="resources/js/dialog/zebra_dialog.src.js"></script>
   <link rel="stylesheet" href="resources/css/dialog/zebra_dialog.css" type="text/css"/>
   <script src="http://code.jquery.com/jquery-migrate-1.2.1.js"></script> 
<script>
// websocket을 지정한 URL로 연결
var sock = new SockJS("<c:url value="/echo"/>");
// websocket 서버에서 메시지를 보내면 자동으로 실행된다.
sock.onmessage = onMessage;
// websocket 과 연결을 끊고 싶을때 실행하는 메소드
sock.onclose = onClose;

function sendMessage() {
	// websocket으로 메시지를 보내겠다.
	sock.send($('#message').val());
}

function onMessage(evt) {
	var data = evt.data;
	var sessinid = null;
	var message = null;
	
	// 문자열을 split //
	var strArray = data.split('|');
	
	for(var i = 0; i < strArray.length; i++) {
		console.log('str['+i+']: ' + strArray[i]);
	}
	
	// current session id //
	var currentuser_session = $('#sessionuserid').val();
	console.log('current session id: ' + currentuser_session);
	
	sessionid = strArray[0]; // 현재 메세지를 보낸 사람의 세션 등록
	message = strArray[1]; // 현재 메세지를 저장 //
	
	// 나와 상대방이 보낸 메세지를 구분하여 영역을 나눈다. //
	if(sessionid == currentuser_session) {
		var printHTML = "<div class='well'>";
		printHTML += "<div class='alert alert-info'>";
		printHTML += "<strong>["+sessionid+"] -> "+message+"</strong>";
		printHTML += "</div>";
		printHTML += "</div>";
		
		$('#chatdata').append(printHTML);
	} else {
		var printHTML = "<div class='well'>";
		printHTML += "<div class='alert alert-warning'>";
		printHTML += "<strong>["+sessionid+"] -> "+message+"</strong>";
		printHTML += "</div>";
		printHTML += "</div>";
		
		$('#chatdata').append(printHTML);
	}
	
	console.log('chatting data: ' + data);
	
	/* sock.close(); */
}

function onClose(evt) {
	$('#data').append('연결 끊김');
}

var result = '';
$(function() {
	
	$("#chattinglistbtn").click(function(){
	      var infodialog = new $.Zebra_Dialog('<strong>Message:</strong><br><br><p>채팅방 참여자 리스트</p>',{
	         title: 'Chatting List',
	         type: 'confirmation',
	         print: false,
	         width: 260,
	         buttons: ['닫기'],
	         onClose: function(caption){
	            if(caption == '닫기'){
	               //alert('yes click');
	            }
	         }
	      });
	    });
	
	$('#sendBtn').click(function() {
		console.log('send message...');
		sendMessage();
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

	
   var save = false;
   $(".codeTest").submit(function(event) {
      event.preventDefault();
      var lang = $("select option:selected").val();
      
      var code = editor.getValue();

      $.ajax({
         url: '${pageContext.request.contextPath }/compile/' + lang,
         async: true,
         type: 'post',
         dataType: 'json',
         data: {code:code},
         success: function(response){
            if(response.result != "success") {
               console.error(response.message);
               return;
            }
            if(response.data[1] != "") {
               console.log("data[1]\n" + response.data[1]);
               $("#result").val(response.data[1]);
            } else {
               console.log("data[0]\n" + response.data[0]);
               $('#result').val(response.data[0]);
            }
         
         },
         error: function(xhr, status, e) {
            console.error(status + ":" + e);
         }
      });
   });
   
   
   
   var code = $('.CodeMirror')[0];
   var editor = CodeMirror.fromTextArea(code, {
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
	   var lang = $(".lang option:selected").val();
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
   });
   
 	$('.CodeMirror').addClass('code');
 	
 	$('#result').keydown(function(key) {
 		var keyCode = typeof key.which === "number" ? key.which : key.keyCode;
 		result += String.fromCharCode(keyCode);
 		
 		if (key.keyCode == 13) {

     	 content = result;
 			result = '';
 			
 			$.ajax({
 		         url: '${pageContext.request.contextPath }/compile/test',
 		         async: true,
 		         type: 'post',
 		         dataType: 'json',
 		         data: {content: content},
 		         success: function(response){
 		            if(response.result != "success") {
 		               console.error(response.message);
 		               return;
 		            }
					console.log('content : ' + content);
					console.log('response : ' + response.data.readbuffer);
					console.log('response2 : ' + response.data.readbuffer2);
//  		            $('#result').keyUp();
 		            $('#result').val(content + "\n" + "> " + response.data.readbuffer);
 		            
 		            return;
 		         },
 		         error: function(xhr, status, e) {
 		            console.error(status + ":" + e);
 		         }
 		      });
 		}
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
                     <textarea name="" id="result"></textarea>
                  </td>
               </tr>
            </table>
         </form>
         
         
          <h1>Chatting Page (id: ${userid})</h1>
   <div>
      <input type="button" id="chattinglistbtn" value="채팅 참여자 리스트">
   </div>
   <br>
   <div>
      <div>
         <input type="text" id="message"/>
          <input type="button" id="sendBtn" value="전송"/>
       </div>
       <br>
       <div class="well" id="chatdata">
          <!-- User Session Info Hidden -->
          <input type="hidden" value='${userid}' id="sessionuserid">
       </div>
   </div>
         
         
    </div>
    <c:import url="/WEB-INF/views/include/footer.jsp" />
    <span id="MOVE-TOP"><i class="fas fa-angle-up custom"></i></span>
    
    
    
</body>
</html>