<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Code Tree</title>
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/mypage/codetree.css">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>  
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
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
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css?family=Merriweather" rel="stylesheet">
<script type="text/javascript" src="${pageContext.request.contextPath }/assets/js/ejs/ejs.js"></script>
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/goldenlayout.min.js"></script>
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/codetree/goldenlayout-base.css" />
<link id="goldenlayout-theme" rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/codetree/goldenlayout-dark-theme.css" />
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
var tempFile = null;
var socket;
var prevText = '';
var authUserNo = ${authUserNo };

//채팅 시작하기
function connect(event) {
   if(currentEditor == null){ 
      return;
   }
   $("#Save").trigger("click");
   $("#Run").blur();
   
   $('.terminal').val('');
   $(".terminal").val('프로그램이 시작되었습니다...\n');
   $('.terminal').attr("readonly", false);
   
   code = currentEditor.getValue();
   
   // 서버소켓의 endpoint인 "/ws"로 접속할 클라이언트 소켓 생성
   socket = new SockJS('${pageContext.request.contextPath }/' + authUserNo);
   
   // 전역 변수에 세션 설정
   stompClient = Stomp.over(socket);
   stompClient.connect({}, onConnected, onError);
    
   event.preventDefault();
}


function onConnected() {
    // Subscribe to the Public Topic
    stompClient.subscribe('/topic/public', onMessageReceived);
    
    execPandan = true;
    var chatMessage = {
          language: tempFile.data("language"),
          code: code,
          execPandan: execPandan,
          fileName: tempFile.data("file-name"),
          packagePath: tempFile.data("package-path"),
            type: 'CHAT'
        };
    execPandan = false;
    // Tell your username to the server
    stompClient.send("/app/mypage",
        {},
        JSON.stringify(chatMessage)
    );
}

function onError(error) {
}

function sendMessage(event, res) {
   
   tmp = res;
   
    var messageContent = res;
    var chatMessage = {
        content: messageContent,
        language:$(".lang option:selected").val(),
      code:code,
      execPandan: execPandan,
        type: 'CHAT'
    };
    stompClient.send("/app/mypage", {}, JSON.stringify(chatMessage));
    event.preventDefault();
}

function onMessageReceived(payload) {
    message = JSON.parse(payload.body);
    
   prevText = $('.terminal').val() + '\n';
   $('.terminal').val(prevText + message.content);
   
   prevCursor = $('.terminal').prop('selectionStart') - 1;
   
   $('.terminal').scrollTop($('.terminal').prop('scrollHeight'));
   
   if(message.programPandan || message.errorPandan) {
       $('.terminal').attr("readonly", true);
       socket.close();
   }
}



/////////////////


var listTemplate = new EJS({
	url: "${pageContext.request.contextPath }/assets/js/ejs/codetree-fileList.ejs"
});

var fileFetchList = function(){
	   var saveNo = "${saveVo.no }";
	   var lang = $("select option:selected").val();
	   $.ajax({
	         url: '${pageContext.request.contextPath }/api/codetree/file-list',
	         async: true,
	         type: 'post',
	         dataType: 'json',
				data: {
					'saveNo' : saveNo,
					'language' : lang
				},
	         success: function(response){
	        	 var html = listTemplate.render(response);
	        	
	      	   	 $(".file-tree__item").append(html);  
	         },
	         error: function(xhr, status, e) {
	            console.error(status + ":" + e);
	         }
	      });	
};


var currentEditor = null;

var editorArray = new Array();
var editorArrayIndex = 0;



$(function() {
	fileFetchList();
	
////////////////// code-mirror /////////////////////////////   

   
   var theme = 'panda-syntax';
   $('.theme').click(function() {
	   theme = $(".theme option:selected").val();
	   var containers = document.getElementsByClassName('lm_item_container');
	   if(currentEditor != null) {
		   for (var i = 0; i < editorArray.length; i++ ) {
			   if(containers[i].style.display == "none"){
					containers[i].style.display = '';
					editorArray[i].setOption("theme", theme);
					containers[i].style.display = 'none';
				} else {
					editorArray[i].setOption("theme", theme);
				}
			}
	   }	   
	   var backgroundColor = null;
	   if(theme == "abcdef") {
		   backgroundColor = "#0F0F0F";
	   }
	   if(theme == "blackboard") {
		   backgroundColor = "#0C1021";
	   }
	   if(theme == "dracula") {
		   backgroundColor = "#282A36";
	   }
	   if(theme == "moxer") {
		   backgroundColor = "#090A0F";
	   }
	   if(theme == "panda-syntax") {
		   backgroundColor = "#292A2B";
	   }
	   if(theme == "duotone-light") {
		   backgroundColor = "#FAF8F5";
	   }
	   if(theme == "eclipse") {
		   backgroundColor = "#FFFFFF";
	   }
	   if(theme == "neat") {
		   backgroundColor = "#FFFFFF";
	   }
	   if(theme == "ttcn") {
		   backgroundColor = "#FFFFFF";
	   }
	   if(theme == "solarized") {
		   backgroundColor = "#FFFFFF";
	   }
	   // 터미널 색 변경
	   $(".window .terminal").css('background-color', backgroundColor);
	   $(".ui__sidebar").css('background-color', backgroundColor);
	  
	   if($('.theme option:selected').parent().attr('label') == "white") {
		   $(".window .terminal").css('color', "#000000");
		   $(".window .terminal .prompt").css('color', "#004000");
		   $(".window .terminal .path").css('color', "#1f0d98");
		   $(".folder--open").css('color', "#000000");
		   $(".folder").css('color', "#000000");
		   $(".ui__sidebar").css('color', "#2c2c2c");
		   
		   $("#goldenlayout-theme").attr("href", "${pageContext.servletContext.contextPath }/assets/css/codetree/goldenlayout-light-theme.css");
		   
		   $(".navigator").css("background-color", "rgb(220, 220, 220)");
		   $(".navigator").css("background ", "rgb(220, 220, 220)");
		   $(".box").css("background","rgb(220, 220, 220) !important");
		   
		   $(".resizer[data-resizer-type=H]").css("background", "rgb(220, 220, 220)");
		   $(".resizer[data-resizer-type=V]").css("background", "rgb(220, 220, 220)");
		   
		   $(".action-button").css("border-color","gainsboro");
		   $(".action-button").css("color","#0A93E2");
		   
		   $(".box").css("background", "");
		   $(".box").css("background", "rgb(220, 220, 220)");
		   
		   $(".dropdown").removeClass("dropdown-dark");
		   $(".lm_selected .lm_header").css("background-color","#F4F4F4 !important");
	   }
	   else {
		   $(".window .terminal").css('color', "#FFFFFF");
		   $(".prompt").css('color', "#bde371");
		   $(".path").css('color', "#5ed7ff");
		   $(".folder--open").css('color', "#FFFFFF");
		   $(".folder").css('color', "#FFFFFF");
		   $(".ui__sidebar").css('color', "#FFFFFF");
		   
		   $("#goldenlayout-theme").attr("href", "${pageContext.servletContext.contextPath }/assets/css/codetree/goldenlayout-dark-theme.css");
		   
		   $(".navigator").css("background-color", "#444");
		   $(".navigator").css("background ", "#444");
		   
		   $(".action-button").css("border-color","rgb(118, 118, 118)");
		   $(".action-button").css("color","#086EAA");
		   
		   $(".resizer[data-resizer-type=H]").css("background", "");
		   $(".resizer[data-resizer-type=V]").css("background", "");
		   $(".resizer[data-resizer-type=H]").css("background", "linear-gradient(to right, #9DBFE3, #4E5F70) repeat scroll 0% 0% transparent; cursor: col-resize");
		   $(".resizer[data-resizer-type=V]").css("background", "linear-gradient(to right, #9DBFE3, #4E5F70) repeat scroll 0% 0% transparent; cursor: col-resize");
		   
		   $(".box").css("background", "linear-gradient(45deg, #1D1F20, #2F3031) repeat scroll 0% 0% transparent !important");
		   
		   $(".dropdown").addClass("dropdown-dark");
		   
		   $(".box").css("background", "");
		   $(".box").css("background", "#444");
		   $(".lm_selected .lm_header").css("background-color","#000 !important");
	   }
   });
   
   $('.lang').change(function() {
	  
	   
 	   $(".file-tree__subtree").remove();
	   fileFetchList();

	   
	   
	   
   });
   

 	
///////////////////////////// problem-list //////////////////////////////////
 	var ui = $(".ui"),
 	    sidebar = $(".ui__sidebar");

 	// File Tree
 	$(document).on("click", ".folder", function(e) {
 		$(".contextmenu").hide();
 	    var t = $(this);
 	    var tree = t.closest(".file-tree__item");

 	    if (t.hasClass("folder--open")) {
 	        t.removeClass("folder--open");
 	        tree.removeClass("file-tree__item--open");
 	    } else {
 	        t.addClass("folder--open");
 	        tree.addClass("file-tree__item--open");
 	    }
 
 	});	
 	
 // 파일 열고 닫기
 	$(document).on('click','#folder',function() {
 		if ($(this).hasClass("folder--open")) {
 			$("#file"+$(this).data("no")).show();
 	    } else { 	    	
 	    	$("#file"+$(this).data("no")).hide();
 	    }
 	});
 	

 	// 폰트 사이즈 변경
	$(document).on("click", '#font-size', function(){	
		var fontSize = $("#font-size option:selected").val();
		$(".CodeMirror").css("font-size", fontSize);
	});
	

 	
////////////////파일 추가/////////////////////
 	
 	var savePathNo = null;
 	var subProblemNo = null;
 	var codeNo = null;
 	var prevFileName = null;
 	var str='<div id="file-insert"><li>파일 추가</li></div>';
 	$(".contextmenu").append(str);
 	var str2='<div><li id="userfile-delete">파일 삭제</li><li id="userfile-update">이름변경</li></div>';
 	$(".userfile-menu").append(str2);
 	
 	//Hide contextmenu:
 	$(document).click(function(){
 	   $(".contextmenu").hide();
 	});
 
 	//Hide contextmenu:
 	$(document).click(function(){
 	   $(".userfile-menu").hide();
 	});	
 	
 	$(document).on('click','#file-insert',function(){
 		var lang = $(".lang option:selected").val();
 		var fileName = null;
 		$('<div> <input type="text" style="z-index:10000" class="fileName-input"  placeholder='+'.'+lang+' > </div>')
 		    .attr("title","파일 추가")
 			.dialog({
 			modal: true,
			buttons:{
				"추가": function(){
					var filename = $(this).find(".fileName-input").val();
					var filename2 =filename.replace(/(\s*)/g,""); 
					if(filename2.split(".").length >2 || filename2.split(".")[1] !=lang || filename2.split(".")[0] ==""){
						alert("잘못된 형식입니다");
						return;
					}
					fileName = filename2;
					
					$.ajax({
						url: '${pageContext.servletContext.contextPath }/api/codetree/fileInsert',
						async: true,
						type: 'post',
						dataType: 'json',
						data: {
							'savePathNo' : savePathNo,
							'language' : lang,
							'fileName' : fileName,
							'subProblemNo':subProblemNo
						},
						success: function(response) {
										
							if(response.data.result == 'no'){
								alert("이미 파일이 존재합니다.");//메시지 처리 필요
								return;
							}
							$(".file-tree__subtree").remove();

							fileFetchList();
							
						},
						error: function(xhr, status, e) {
							console.error(status + ":" + e);
						}
					});
					$(this).dialog("close");
				},
				"취소":function(){
					$(this).dialog("close");
				}
			},
			close:function(){}
 		}); 		
 	});
 	
 	
 	$(document).on('click','#userfile-delete',function(){
 		$(".validateTips").css("color","black").html("<p>정말로 삭제하시겠습니까?</p>");
 		dialogDelete.dialog("open");
 	});
 	
 	
 	var dialogDelete = $("#dialog-delete-form").dialog({
			autoOpen: false,
			width:300,
			height:220,
			modal:true,
			buttons:{
				"삭제":function(){
					$.ajax({
						url: '${pageContext.servletContext.contextPath }/api/codetree/fileDelete/'+codeNo,
						async: true,
						type: 'delete',
						dataType:'json',
						data:'',
						success: function(response) {
							
							if(response.result != "success"){
								console.error(response.message);
								return;
							}
							
							if(response.data != -1){
								 
								$(".userFile[data-no="+response.data+"]").remove();
								
								dialogDelete.dialog('close');
								return;
							}							
							
							$(".validateTips").css("color","red").html("<p>삭제실패</p>");
						},
						error: function(xhr, status, e) {
							console.error(status + ":" + e);
						}							
					});
				},
				"취소":function(){
					$(this).dialog("close");
				}
			},
			close:function(){}
 	}); 	
 	
 	var layoutId = null;
 	var tempLayout = null;

 	$(document).on("click", "#userfile-update", function() {
 		var lang = $(".lang option:selected").val();
 		var fileName = null;
 		codeNo = fileNo;
 		$('<div> <input type="text" style="z-index:10000" class="fileName-update" placeholder='+'.'+lang+'></div>')
		    .attr("title","파일 수정")
		    .dialog({
		    	modal: true,
		    	buttons:{
		    		"수정":function(){
						var filename = $(this).find(".fileName-update").val();
						var filename2 =filename.replace(/(\s*)/g,""); 
						if(filename2.split(".").length >2 || filename2.split(".")[1] !=lang || filename2.split(".")[0] ==""){
							alert("잘못된 형식입니다");
							return;
						}
						fileName = filename2;
						$.ajax({
							url: '${pageContext.servletContext.contextPath }/api/codetree/fileUpdate',
							async: true,
							type: 'post',
							dataType: 'json',
							data: {
								'savePathNo' : savePathNo,
								'codeNo' : codeNo,
								'fileName' : fileName,
								'subProblemNo':subProblemNo,
								'prevFileName':prevFileName
							},
							success: function(response) {
				
								 	layoutId = "layout-"+codeNo;
									tempLayout = root.getItemsById(layoutId)[0];
	
									if(tempLayout != null) {
										tempLayout.setTitle(fileName);
									}
								
 								if(response.data.result == 'no'){
									alert("이미 파일이 존재합니다.");//메시지 처리 필요
									return;
								}
								$(".file-tree__subtree").remove();

								fileFetchList(); 
								
								
								
							},
							error: function(xhr, status, e) {
								console.error(status + ":" + e);
							}
						});
						$(this).dialog("close");		    			
		    		},
					"취소":function(){
						$(this).dialog("close");
					}
		    	},
		    	close:function(){}
		    });
			
 	});
 	
 	
 	
 	// 파일을 더블클릭 하면...
 	var fileNo = null
 	var root = null;
	var HashMap = new Map();
 	var fileMap = new Map();
	
 	var SavedCode = new Map();
 	
 	$(document).on("dblclick", ".file", function() {		
 		tempFile = $(this);
 		var language = $(this).data("language");
 		var fileName = $(this).data("file-name");
 		var packagePath = $(this).data("package-path");
 		fileNo = $(this).data("no");
 		
 	
 		
 		if($("#cm"+fileNo).length < 1) { // 켜진 창이 중복되서 안켜지도록 함
 			
 			
 	 		fileMap.set(fileNo+"", tempFile);
 			
	 		root = myLayout.root.contentItems[0] || myLayout.root;
			
			root.addChild({
				type : "component",
				componentName : "newTab",
				title : fileName,
				id : "layout-"+fileNo
			});
			 
			
			
			var code = $('#cm'+fileNo+' > .CodeMirror')[0];		
			
			var editor = CodeMirror.fromTextArea(code, {
				lineNumbers : true,
				mode : 'text/x-java',
				theme : theme,
				matchBrackets : true,
				readOnly : true
			});			
			editorArray[editorArrayIndex++]=editor;
			currentEditor = editor;
			HashMap.set("editor"+fileNo, editor);
			
			$.ajax({
				url: '${pageContext.servletContext.contextPath }/api/codetree/find-code',
				async: true,
				type: 'post',
				dataType:'json',
				data: {
					'language' : language,
					'fileName' : fileName,
					'packagePath' : packagePath
				},
				success: function(response) {	   				   
				   if(response.data != "") {
					currentEditor.setValue(response.data);
				   }
				   else {
					   var face = '';
					   if(fileName.split(".")[0] == "Test") {
						   if(language === 'c') {
							   face = '#include <stdio.h>\n\n' + 
								   'int main() {\n' + 
								   	'\tprintf("Hello CodeForest!\\n");\n\n' + 
								   	'\treturn 0;\n' + 
								   '}';
						   } else if(language === 'cpp') {
							   face = '#include <iostream>\n\n' + 
								   		'using namespace std;\n\n' + 
								   'int main()\n' + 
								   '{\n' + 
								       '\tcout << "Hello CodeForest!" << endl;\n\n' + 
								       '\treturn 0;\n' + 
								   '}';
						   } else if(language === 'cs') {
							   face = 'using System;\n\n' + 
								   		'class HelloWorld {\n\n' + 
								     	'\tstatic void Main() {\n' +  
								       '\t\tConsole.WriteLine("Hello CodeForest");\n' + 
								     '\t}\n' + 
								   '}';
						   } else if(language === 'java') {
							   face = '/*\n' + 
						   		"* 기본 언어 : 'JAVA'\n" + 
							   "* 기본 테마 : 'panda-syntax'\n" + 
							   '*/\n' + 
							  'public class Test{\n' + 
							  		'\tpublic static void main(String[] args) {\n' + 
							      		'\t\tSystem.out.println("Hello CodeForest!");\n' + 
							      '\t}\n' + 
							  '}\n';
						   } else if(language === 'js') {
							   face = 'var str = "Hello CodeForest";\n\n' + 
							   			'console.log(str);';
						   } else if(language === 'py') {
							   face = 'print("Hello World")';
						   }
					   }
					   if(currentEditor != null) {
						   currentEditor.setValue(face);
					   }	
				   }
					SavedCode.set(fileNo+"",response.data);
				},
				error: function(xhr, status, e) {
					console.error(status + ":" + e);
				}							
			});
			
			
	
 		}
 		else {
 			
 			layoutId = "layout-"+fileNo;
 			tempFile = fileMap.get(fileNo+"");
			tempLayout = root.getItemsById(layoutId)[0];
			 
 			root.setActiveContentItem(tempLayout);	
 			   
 			currentEditor = HashMap.get("editor"+fileNo);
 			
 		}
 		
 		
 	});
	$(document).on("mousedown", ".lm_title", function() {

		var tabFileNo = root.getActiveContentItem().config.id.split("-")[1];
		fileNo = tabFileNo;
 		tempFile = fileMap.get(tabFileNo+"");
		$(this).parent().attr("id", "tab"+tabFileNo); //dom 분리시 작업 코드 진행중
 		currentEditor = HashMap.get("editor"+tabFileNo);
		
 		
 		     
	});
	
	$(document).on("click", ".CodeMirror-scroll", function(e) {
 		var cmNo = $(this).parent().parent().attr("id").split("cm")[1];
 		fileNo = cmNo;
 		tempFile = fileMap.get(cmNo+"");
 		currentEditor = HashMap.get("editor"+cmNo);
 		

	});
	
	
	////////////////키보드 입력//////////////////////////// 	
	$(document).keydown(function(event) {
	    if (event.ctrlKey || event.metaKey) {
	        switch (String.fromCharCode(event.which).toLowerCase()) {
	        case 's':
	            event.preventDefault();
	            $("#Save").trigger("click");
	            break;
	        } 
	     }
    });
 	 
	$(document).on("propertychange change keyup paste", function(e){

		if(e.target.nodeName == "TEXTAREA" && e.target.className != "fileName-update"){
			if(currentEditor.getValue() != SavedCode.get(fileNo+"")){
				layoutId = "layout-"+fileNo;
				tempFile = fileMap.get(fileNo+"");
				tempLayout = root.getItemsById(layoutId)[0];
				tempLayout.setTitle("*"+tempFile.data("fileName"));
			}else{
				layoutId = "layout-"+fileNo;
				tempFile = fileMap.get(fileNo+"");
				tempLayout = root.getItemsById(layoutId)[0];
				tempLayout.setTitle(tempFile.data("fileName"));
			}			
		}
	}); 
	
  	
 	//////////////////////////// golden layout /////////////////////////////	
	var config = {
 		settings: {
 			selectionEnabled: true
 		},
	    content: [
		      {
		        type: 'stack',
		      	isClosable: false,
		        content: [
		        ]
		    }]
	};
	 
	var myLayout = new GoldenLayout(config, $('#gl-cover'));

	myLayout.registerComponent("newTab", function(container) {
		container.getElement().html('<textarea name="code" class="CodeMirror code" id="newTab"></textarea>');

		container.getElement().attr("id", "cm"+fileNo);		
		
	});
	
	myLayout.init();
	var glCm = document.getElementsByClassName("lm_root")[0];
	glCm.style = "";
	
	var glCm2 = document.getElementsByClassName("lm_stack")[0];
	glCm2.style = "";
	
	var glCm3 = document.getElementsByClassName("lm_items")[0];
	glCm3.style = "";
	
	$(document).on("click",".sub-menu > li:first-child",function(){
		$("#Save").trigger("click");
	});
	$(document).on("click",".sub-menu > li + li",function(){
		$("#Run").trigger("click");
	});
	$(document).on("click",".sub-menu > li:last-child",function(){
		$("#Submit").trigger("click");
	});

	var d = document.querySelector('#Run');
    d.addEventListener('click', connect, true);
    
    prevCursor = 0;
    var cursorPandan = false;
    
    $('.terminal').keydown(event, function(key) {
       
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
    
    $('.terminal').mousedown(function(){
       $('.terminal').mousemove(function(e){
          return false;
       });
    }); 
    
    $("#info-div").dialog({
        autoOpen: false,
        resizable: false,
        height: "auto",
        width: 400,
        modal: true,
        show: {
            effect: "toggle",
            duration: 270
          },
          hide: {
            effect: "toggle",
            duration: 270
          },
        buttons: {
            "확인": function() {
         	   $(this).dialog("close");
            }
        }
    });
    
    var button;
    $('#info').click(function() {
 	   button = document.getElementsByClassName('ui-button')[4];
 	   button.style = "background-color: #0A93E2 !important; color: #fff; height: 37px;";
 	   
 	   $("#info-div").dialog("open");
    });
    
    $('.ui-button').eq(4).hover(function() {
 	   button.style = "background-color: #A6A6A6 !important; color: #fff; height: 37px;";
    }, function() {
 	   button.style = "background-color: #0A93E2 !important; color: #fff; height: 37px;";
    })
	    
//////function 끝부분 	

});

/////////////////////////////////////////////////////////////////////////////////////////////////	
	
	
	if (typeof Resizer === 'undefined') {

	var Resizer = function(resizerNode, type, options) {
		resizerNode.classList.add('resizer');
		resizerNode.setAttribute('data-resizer-type', type);
		this.hidebar = (typeof options === 'undefined' ? null : options.hidebar);
		this.callbackMove = (typeof options === 'undefined' ? null : options.callbackMove);
		this.callbackStop = (typeof options === 'undefined' ? null : options.callbackStop);
		this.processing = false;
		this.container = {
			node: resizerNode.parentNode,
			playingSize: null,
			playingRatio: null
		};
		this.beforeBox = {
			node: resizerNode.previousElementSibling,
			ratio: null,
			size: null
		};
		this.resizer = {
			node: resizerNode,
			type: type
		};
		this.afterBox = {
			node: resizerNode.nextElementSibling,
			ratio: null,
			size: null
		};
		this.mousePosition = null;
		this.beforeBox.node.style.flexGrow = 1;
		this.afterBox.node.style.flexGrow = 1;
		this.beforeBox.node.style.flexShrink = 1;
		this.afterBox.node.style.flexShrink = 1;
		this.beforeBox.node.style.flexBasis = 0;
		this.afterBox.node.style.flexBasis = 0;
		// ajout des events
		this.resizer.node.addEventListener('mousedown', this.startProcess.bind(this), false);
	};

	Resizer.prototype = {
		startProcess: function(event) {
			// cas processus déjà actif
			if (this.processing) {
				return false;
			}
			// MAJ flag
			this.processing = true;
			// cacher la barre
			if (this.hidebar) {
				this.resizer.node.style.display = 'none';
			}
			// réinitialiser les variables
			this.beforeBox.ratio = parseFloat(this.beforeBox.node.style.flexGrow);
			this.afterBox.ratio = parseFloat(this.afterBox.node.style.flexGrow);
			this.mousePosition = (this.resizer.type === 'H' ? event.clientX : event.clientY);
			this.beforeBox.size = (this.resizer.type === 'H' ? this.beforeBox.node.offsetWidth : this.beforeBox.node.offsetHeight);
			this.afterBox.size = (this.resizer.type === 'H' ? this.afterBox.node.offsetWidth : this.afterBox.node.offsetHeight);
			this.container.playingSize = this.beforeBox.size + this.afterBox.size;
			this.container.playingRatio = this.beforeBox.ratio + this.afterBox.ratio;
			// lancer le processus
			this.stopProcessFunctionBinded = this.stopProcess.bind(this);
			document.addEventListener('mouseup', this.stopProcessFunctionBinded, false);
			this.processFunctionBinded = this.process.bind(this);
			document.addEventListener('mousemove', this.processFunctionBinded, false);
		},
		process: function(event) {
			if (!this.processing) {
				return false;
			}
			// calcul du mouvement de la souris
			var mousePositionNew = (this.resizer.type === 'H' ? event.clientX : event.clientY);
			var delta = mousePositionNew - this.mousePosition;
			// calcul des nouveaux ratios
			var ratio1, ratio2;
			ratio1 = (this.beforeBox.size + delta) * this.container.playingRatio / this.container.playingSize;
			if (ratio1 <= 0) {
				ratio1 = 0;
				ratio2 = this.container.playingRatio;
			} else if (ratio1 >= this.container.playingRatio) {
				ratio1 = this.container.playingRatio;
				ratio2 = 0;
			} else {
				ratio2 = (this.afterBox.size - delta) * this.container.playingRatio / this.container.playingSize;
			}
			// mise à jour du css
			this.beforeBox.node.style.flexGrow = ratio1;
			this.afterBox.node.style.flexGrow = ratio2;
			this.beforeBox.node.style.flexShrink = ratio2;
			this.afterBox.node.style.flexShrink = ratio1;
			// lancer la fonction de callback
			if (typeof this.callbackMove === 'function') {
				this.callbackMove();
			}
		},
		stopProcess: function(event) {
			// stopper le processus
    	document.removeEventListener('mousemove', this.processFunctionBinded, false);
			this.processFunctionBinded = null;
			document.removeEventListener('mouseup', this.stopProcessFunctionBinded, false);
			this.stopProcessFunctionBinded = null;
			// afficher la barre
			if (this.hidebar) {
				this.resizer.node.style.display = '';
			}
			// lancer la fonction de callback
			if (typeof this.callbackStop === 'function') {
				this.callbackStop();
			}
			// réinitialiser le flag
			this.processing = false;
		},
	};
} else {
	console.error('"Resizer" class already exists !');
}

window.onload = function() {
    new Resizer(document.querySelector('[name=resizerH1]'), 'H');
    new Resizer(document.querySelector('[name=resizerH2]'), 'H');
    new Resizer(document.querySelector('[name=resizerV1]'), 'V');
    
   	var el = document.getElementById("box_1");
   	el.style = "flex: 0.30788 1.12466 0px;";
   	
   	var el2 = document.getElementById("box_2");
   	el2.style = "flex: 0.157611 0.91488 auto;";
   	
   	var el4 = document.getElementById("box_4");
   	el4.style = "flex: 0.461282 1.08793 0px;";
  };
  


</script>
</head>
<body>

<nav role="navigation" class='main-nav'>
    <div class="main-nav-wrapper">
		<div class="header-logo">
		  ${saveVo.title }
		</div>
		<div class="user-description">
      		${saveVo.userName } [ ${saveVo.userEmail } ]님의 코드입니다
      	</div>
		<div class="info-div">
			<i class="fas fa-info-circle" id="info"></i>
		</div>
    </div>
 </nav>

<div class="container">

	<div class="frame horizontal">
	  
	    <div id="box_1" class="box" style="flex: 1 1 1">
	    	<c:import url="/WEB-INF/views/codetree/problem-list.jsp"></c:import>
	    </div>
	    
	  <div name="resizerH1"></div>
	  
	  <div class="frame vertical" id="code-mirror">

		  <div class='navigator'>

              <div class='language-selector dropdown dropdown-dark'>
                <select class="lang dropdown-select" name="lang">
                    <option value="c">C</option>
                    <option value="cpp">C++</option>
                    <option value="cs">C#</option>
                    <option value="java" selected="selected">JAVA</option>
                    <option value="js">JavaScript</option>
                    <option value="py">Python</option>
                </select>
              </div>
              
              <div class='theme-selector dropdown dropdown-dark'>
                <select class="theme dropdown-select" name="theme">
                	<optgroup label="black">
                    <option value="abcdef">abcdef</option>
                    <option value="blackboard">blackboard</option>
                    <option value="dracula">dracula</option>
                    <option value="moxer">moxer</option>
                    <option value="panda-syntax" selected="selected">panda-syntax</option>
                  </optgroup>
                  <optgroup label="white">
                    <option value="duotone-light">duotone-light</option>
                    <option value="eclipse">eclipse</option>
                    <option value="neat">neat</option>
                    <option value="ttcn">ttcn</option>
                    <option value="solarized">solarized</option>
                  </optgroup>
                </select>
              </div>
               
              <div class='font-size dropdown dropdown-dark'>
                  <select class="size dropdown-select" id="font-size" name="size">
                    <option value="10px">10px</option>
                    <option value="12px">12px</option>
                    <option value="15px">15px</option>
                    <option value="16px" selected="selected">16px</option>
                    <option value="17px">17px</option>
                    <option value="18px">18px</option>
                    <option value="19px">19px</option>
                    <option value="20px">20px</option>
                    <option value="25px">25px</option>
                    <option value="30px">30px</option>
                    <option value="35px">35px</option>
                </select>
              </div>
              
			  <div class="buttons">
		           	<button class="action-button shadow animate" id="Run" class="Run">Run</button>
		      </div>
          </div> 
  
	    <div class="frame horizontal" id="file-codemirror-cover">	    
	      <div id="box_2" class="box" style="display:flex;flex-direction:column">

		    <div class="ui__sidebar">
		        <ul class="file-tree">
		            <li class="file-tree__item file-tree__item--open">
		                <div class="folder folder--open">problem${saveVo.problemNo }</div>		
		                <ul class="file-tree__subtree">
		                </ul>
		                <!-- /.file-subtree -->
		            </li>
		            
		        </ul>
		        <!-- /.file-tree -->
		    </div>
		    <!-- /.sidebar -->

	      </div>
	      	      
	      <div name="resizerH2"></div>	
	            
	      <div id="box_3" class="box">
	      
         	<div class="gl-cover" id="gl-cover">
         	
         	</div>
         
	      </div>
	      
	    </div>	    
	      <div name="resizerV1"></div>	      
	      <div id="box_4" class="box">
	      	<c:import url="/WEB-INF/views/codetree/terminal2.jsp"></c:import>
	      </div>
	  </div>
	  
	</div>
	
			<div id="dialog-delete-form" class="delete-form" title="메세지 삭제" style="display:none">
				<p class="validateTips"></p>  
			</div>
			<div>
				<ul class="contextmenu">
				</ul>
				<ul class="userfile-menu">
				</ul> 
			</div>
</div>
<div class="info-div-class" id="info-div" title="Compiler Version" style="display:none" >
	<div class="info-content">
		<table border="0" class="info-table">
			<thead>
				<tr>
					<th>
						<span>언어</span>
					</th>
					<th>
						<span>버전</span>
					</th>
				</tr>
			</thead>
			<tbody>
				<tr class="line"><td>C</td><td>gcc 4.8.5</td></tr>
				<tr><td>C++</td><td>gcc 4.8.5</td></tr>
				<tr class="line"><td>C#</td><td>.NET Core 5.16</td></tr>
				<tr><td>Java</td><td>OpenJDK 1.8.0</td></tr>
				<tr class="line"><td>JavaScript</td><td>Node.js 8.17.0</td></tr>
				<tr><td>Python</td><td>2.7.5</td></tr>
			</tbody>
		</table>
	</div>
</div>
</body>
</html>