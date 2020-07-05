<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script>
$(function() {
	
	$('#MOVE-TOP').hide();
	
	$(window).scroll(function() {
	    if ($(this).scrollTop() > 250) {
	        $('#MOVE-TOP').fadeIn();
	    } else {
	        $('#MOVE-TOP').fadeOut();
	    }
	});
	
	$("#MOVE-TOP").click(function() {
	    $('body, html').animate({
	        scrollTop : 0
	    }, 400);
	    return false;
	});
});
</script>
<div class="footer">
	<h3 >Code Forest</h3> 
	<p>Code Forest - Online Compiler
	<address> 연락처 : 
		<a id="codeforest" href="codeforest@gmail.com">codeforest2020@gmail.com</a> 
	</address> 
	<small>Copyright &copy; 2020 Code Forest</small> 
</div>
<span id="MOVE-TOP"><i class="fas fa-angle-up custom"></i></span>
