<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Code Forest</title>
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/mypage-header.css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/include/footer.css">
<link rel="stylesheet" href="${pageContext.servletContext.contextPath }/assets/css/mypage/problem.css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery-3.4.1.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" src="${pageContext.servletContext.contextPath }/assets/js/jquery/table2excel.js"></script>
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.0/css/all.min.css" rel="stylesheet">
<script>
function onKeyDown() {
	if(event.keyCode == 13) {
		var kwd = $('#kwd').val();
		originList('1', kwd);
		$('span b').trigger('click');
	}
}

var page = '1';
var endPageTrueNum;

var originList = function(page2, keyword) {
	
   $.ajax({
      url: '${pageContext.request.contextPath }/api/mypage/problem',
      async: false,
      type: 'post',
      dataType: 'json',
      traditional: true,
      data: {
         'page': page2,
         'keyword': keyword
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
    $("#problem-tbody").remove();
   $("#pager").remove();
   
   var str = "";
   var codingTestStr = "";
   var fileDownloadStr = "";
   str += '<tbody id="problem-tbody">';
   for(var i = 0; i < map.list.length; i++){
	   if(map.list[i].startTime <= getTimeStamp() && map.list[i].endTime >= getTimeStamp()) {
		   codingTestStr = '<td><button class="blinking" id="modify-btn" style="padding: 2px 9px; background-color: #fc9303; border: 1px solid #fc9303; outline: none; cursor: default" >진행중</button></a></td>';
		   fileDownloadStr = '<td><i class="list-none fas fa-file-download"></i></td>';
		   titleStr = map.list[i].title;
	   } else if(map.list[i].startTime > getTimeStamp()) {
		   titleStr = map.list[i].title + '<span class="blinking" id="expected" style="color: #fff; background-color: #3e91b5; border: 1px solid #3e91b5; border-radius: 0.5rem; padding: 0 1em; margin-left: 1em; font-size: 0.8em; margin-top: 2px;outline: none; cursor: default" >예정</span>';
		   codingTestStr = '<td><a href="${pageContext.servletContext.contextPath }/training/modify/' + map.list[i].no + '"><button id="modify-btn">수정</button></a></td>';
		   fileDownloadStr = '<td><i class="list-none fas fa-file-download"></i></td>';
	   } else {
		   titleStr = map.list[i].title;
		   codingTestStr = '<td><a href="${pageContext.servletContext.contextPath }/training/modify/' + map.list[i].no + '"><button id="modify-btn">수정</button></a></td>';
		   fileDownloadStr = '<td><i data-no="' + map.list[i].no + '" data-title="' + map.list[i].title + '" type="button" alt="list" class="list fas fa-file-download"></i></td>';
	   }
       str += '<tr class="list-contents" id="list-contents" data-no="' + map.list[i].no + '">' + 
                '<td><a data-no="' + map.list[i].no + '">' + map.list[i].no + '</a></td>' + 
                  '<td class="problem-title" data-no="' + map.list[i].no + '" style="text-align: left">' + titleStr + '</td>' + 
                  '<td>' + map.list[i].hit + '</td>' + 
                  '<td>' + map.list[i].recommend + '</td>' + 
                  codingTestStr + 
                  fileDownloadStr + 
                  '<td><i data-no="' + map.list[i].no + '" alt="delete" class="delete fas fa-minus-circle"></i></td>' + 
                '</tr>' + 
             '<tr class="sub-problem-contents' + map.list[i].no + '">' + 
                '<td></td>' + 
                 '<td colspan="5">' + 
                     '<table id="sub-problem-table" class="' + map.list[i].no + '" style="display: none;">' + 
                        '<tbody class="sub-problem-tbody"></tbody>' + 
                     '</table>' + 
                 '</td>' + 
                '</tr>';
   }
   str += '</tbody>';
   $(".quiz-table").append(str);
   
   var str2 = '<div class="pager" id="pager">';
   
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
   if(map.endPageNum != page){
      str2 += '<span class="next"><i class="fas fa-angle-right"></i></span>';
   }    
   str2 += "</div>";
      
   $(".quiz-table").after(str2);
}

var nextRemove = function() {
	var endPage = endPageTrueNum;
	
	if(page == endPage) {
		$('.next').remove();
	}
}
	

$(function() {
	
	originList('1', '');
	
	$(document).on("click", ".page", function() {
	      page = $(this).attr('id');
	      
	      var kwd = $('#kwd').val();
		  originList(page, kwd);
	      nextRemove();
	   });
	   
	   $(document).on("click", ".prev", function() {
	      page = $('span b').parent().attr('id');
	      var prevNo = parseInt(page) - 1;
	      page = String(prevNo);
	      
	      var kwd = $('#kwd').val();
		  originList(page, kwd);
	      nextRemove();
	   });
	   
	   $(document).on("click", ".next", function() {
	      page = $('span b').parent().attr('id');
	      var prevNo = parseInt(page) + 1;
	      page = String(prevNo);
	      
	      var kwd = $('#kwd').val();
		  originList(page, kwd);
	      nextRemove();
	   });
	
	var dialogDelete = $("#dialog-delete").dialog({
		autoOpen: false,
		resizable: false,
		height: "auto",
		width: 400,
		modal: true,
		buttons: {
			"삭제": function() {
				var no = $("#hidden-no").val();
				$.ajax({
					url: '${pageContext.servletContext.contextPath }/api/mypage/problem/delete/' + no,
					async: true,
					type: 'delete',
					dataType: 'json',
					data: '',
					success: function(response) {
						dialogDelete.dialog('close');
						// 삭제 추가해야하는 곳
						$(".list-contents[data-no=" + no + "]").remove();
						$(".sub-problem-contents" + no).remove();
					},
					error: function(xhr, status, e) {
						console.error(status + ":" + e);
					}
				});
			},
			"취소": function() {
				$(this).dialog('close');
			}
		},
		close: function() {
			$("#hidden-no").val('');
			$("#dialog-delete-form p.validateTips.error").hide();
		}
	});
	
	$(document).on('click', '.delete', function(event) {
		event.preventDefault();
		
		var no = $(this).data('no');
		$('#hidden-no').val(no);
		dialogDelete.dialog('open');
	});
	
	// ------------------------------------- 문제 푼 사람 리스트 출력 --------------------------------------
	var dialogList = $(".problem-list").dialog({
		autoOpen: false,
		resizable: false,
		height: 600,
		width: 1040,
		modal: true,
		buttons: {
			"다운로드": function() {		
				var title = $("#hidden-title").val();
				$(".problem-list-table").table2excel({
					exclude: ".discard",
					filename: title.concat(".xls")
				})
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
	
	$(document).on('click', '.list', function(event) {
		event.preventDefault();
		
		var no = $(this).data('no');		
		var title = $(this).data('title');
		$('#hidden-title').val(title);
		
		$.ajax({
			url: '${pageContext.servletContext.contextPath }/api/mypage/problem/list/' + no,
			async: true,
			type: 'post',
			dataType: 'json',
			data: '',
			success: function(response) {
				var table = "";
				for(var i in response.data) {
					table += "<tbody id='tbody'>" +
							"<tr><td id='name'>" + response.data[i].name + "</td>" +
							"<td id='email'>" + response.data[i].email + "</td>" + 
							"<td id='nickname'>" + response.data[i].nickname + "</td>" +
							"<td id='try-count'>" + response.data[i].tryCount + "</td>" + 
							"<td id='lang'>" + response.data[i].lang + "</td>" +
							"<td id='solve-time'>" + response.data[i].solveTime + "</td></tr></tbody>";
				}
				$(".problem-list-table").append(table);
				dialogList.dialog('open');
			},
			error: function(xhr, status, e) {
				console.error(status + ":" + e);
			}
		});
	});
	
	
	$(document).ready(function(){
	    $(".check-box input").on('click', function(){
	    	var value = $(this).val();
	        if($(this).prop("checked")){
	        	$(".problem-list-table > #tbody > tr > td#".concat(value)).show();
	        	$(".problem-list-table > #tbody > tr > td#".concat(value)).removeClass();
				$(".problem-list-table tr th#".concat(value)).show();
				$(".problem-list-table tr th#".concat(value)).removeClass();
	        }else{
	        	$(".problem-list-table > #tbody > tr > td#".concat(value)).hide();
	        	$(".problem-list-table > #tbody > tr > td#".concat(value)).addClass('discard');
				$(".problem-list-table tr th#".concat(value)).hide();
				$(".problem-list-table tr th#".concat(value)).addClass('discard');
	        }
	    });
	});
	
	// ------------------------------------------- 서브 문제 출력 -------------------------------------------------------
	$(document).on('click', ".problem-title", function() { 
    	var no = $(this).data('no');
    	
    	if($("." + no).css('display') == 'none') {
    		$("." + no + " > .sub-problem-tbody > tr").remove();
    	}
    	
        $.ajax({
			url: '${pageContext.servletContext.contextPath }/api/mypage/sub-problem/' + no,
			async: true,
			type: 'post',
			dataType: 'json',
			data: '',
			success: function(response) {
				if(response.data.length == 0) {
					return;
				}
				var tr = "";
				deleteStr = "";
				
				var expected = $(".problem-title[data-no='" + no + "']").children().attr('id');
				for(var i in response.data) {
					if(expected == "expected") {
						deleteStr = '<td><i data-no="' + response.data[i].no + '" type="button" alt="delete" class="sp-delete fas fa-minus-circle"></i></td>';
					} else {
						deleteStr = '<td></td>';
					}
					tr += '<tr id="sub-problem' + response.data[i].no + '"><td class="sub-problem-padding1"># ' + response.data[i].no +'</td>' + 
						'<td class="sub-problem-padding2">' + response.data[i].title + '</td>' + deleteStr + '</tr>'
				}			
				$("." + no + " .sub-problem-tbody").append(tr);
				$("." + no).toggle();
			},
			error: function(xhr, status, e) {
				console.error(status + ":" + e);
			}
		});    
	});
	
	// ----------------------------------------------- 서브 문제 삭제 ----------------------------------------
	var dialogSpDelete = $("#dialog-delete-sp").dialog({
		autoOpen: false,
		resizable: false,
		height: "auto",
		width: 400,
		modal: true,
		buttons: {
			"삭제": function() {
				var no = $("#hidden-sp-no").val();
				var tableClass = $("#hidden-table-class").val();
				$.ajax({
					url: '${pageContext.servletContext.contextPath }/api/mypage/sub-problem/delete/' + no,
					async: true,
					type: 'delete',
					dataType: 'json',
					data: '',
					success: function(response) {		
						dialogSpDelete.dialog('close');						
						$('#sub-problem'+no).remove();
					},
					error: function(xhr, status, e) {
						console.error(status + ":" + e);
					}
				});
			},
			"취소": function() {
				$(this).dialog('close');
			}
		},
		close: function() {			
			$("#hidden-sp-no").val('');
			$("#hidden-table-class").val('');
		}
	});
	
	$(document).on('click', '.sp-delete', function(event) {
		event.preventDefault();
		
		var spNo = $(this).data('no');
		var tableClass = $("#sub-problem-table").attr('class');
		$('#hidden-sp-no').val(spNo);
		$('#hidden-table-class').val(tableClass);
		dialogSpDelete.dialog('open');
	});
	
	$('#search').on('click', function() {
		var kwd = $('#kwd').val();
		originList('1', kwd);
		$('span b').trigger('click');
	});
});
</script>
    
</head>
<body>
    <c:import url="/WEB-INF/views/include/mypage-header.jsp" />
    <div class="container">
        <div class="quizlist">
            <div class="line">
                <h4>문제 관리</h4>
            </div>
            <div class="search">
                <input type="text" id="kwd" name="kwd" placeholder="Search.." onKeyDown="onKeyDown();" autoComplete="off">
                <input type="button" id="search" value="검색" >
            </div>
            <br>
            <table class="quiz-table">
               <thead>
                   <tr>
                       <th width="9%">번호</th>
                       <th width="47%">제목</th>
                       <th width="10%">조회수</th>
                       <th width="10%">추천수</th>
                       <th width="10%">수정하기</th>
                       <th width="10%">내보내기</th>
                       <th width="10%">삭제</th>
                   </tr>
                </thead>
            </table>
            
            <br>
        </div>

    </div>
    
    <div id="dialog-delete" title="문제 모음 삭제" style="display: none">
       <p>
          <span class="ui-icon ui-icon-alert" style="float: left; margin: 12px 12px 20px 0;">   
          </span>
          해당 문제 모음을 삭제하시겠습니까?
       </p>
       <form>
          <input type="hidden" id="hidden-no" value="">
          <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
       </form>
    </div>
    
    <div id="dialog-delete-sp" title="서브 문제 삭제" style="display: none">
       <p>
          <span class="ui-icon ui-icon-alert" style="float: left; margin: 12px 12px 20px 0;">   
          </span>
          해당 서브 문제를 삭제하시겠습니까?
       </p>
       <form>
          <input type="hidden" id="hidden-sp-no" value="">
          <input type="hidden" id="hidden-table-class" value="">
          <input type="submit" tabindex="-1" style="position:absolute; top:-1000px">
       </form>
    </div>
    
    <div class="problem-list" title="문제 푼 사람 리스트" style="display: none">
       <input type="hidden" id="hidden-title" value="">
       <div class="check-box">
          <label><input class="box-component" type="checkbox" name="problem-list-table" value="name" checked>이름</label>
          <label><input class="box-component" type="checkbox" name="problem-list-table" value="email" checked>이메일</label>
          <label><input class="box-component" type="checkbox" name="problem-list-table" value="nickname" checked>닉네임</label>
          <label><input class="box-component" type="checkbox" name="problem-list-table" value="try-count" checked>시도횟수</label>
          <label><input class="box-component" type="checkbox" name="problem-list-table" value="lang" checked>언어</label>
          <label><input class="box-component" type="checkbox" name="problem-list-table" value="solve-time" checked>해결시간</label>
       </div>
       <table class="problem-list-table rtable">
          <tr>
               <th id="name">이름</th>
                <th id="email">이메일</th>
                <th id="nickname">닉네임</th>
                <th id="try-count">시도횟수</th>
                <th id="lang">언어</th>
                <th id="solve-time">해결시간</th>
            </tr>           
       </table>
    </div>
    <c:import url="/WEB-INF/views/include/footer.jsp" />
</body>

</html>