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
<script>

var result = '';

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
    </div>
    <c:import url="/WEB-INF/views/include/footer.jsp" />
    <span id="MOVE-TOP"><i class="fas fa-angle-up custom"></i></span>
</body>
</html>