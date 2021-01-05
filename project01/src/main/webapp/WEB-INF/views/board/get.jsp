<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../includes/header.jsp" %>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Tables</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">
                Details
            </div>
            <!-- /.panel-heading -->
            <div class="panel-body">
            
               	<div class="form-group">
               		<label for="bno">Bno</label>
               		<input class="form-control" name="bno" 
               		value='<c:out value="${board.bno}" />' readonly="readonly">
               	</div>
               	<div class="form-group">
               		<label for="title">Title</label>
               		<input class="form-control" name="title" 
               		value='<c:out value="${board.title}" />' readonly="readonly">
               	</div>
               	<div class="form-group">
               		<label for="content">Content</label>
               		<input class="form-control" name="content"
               		value='<c:out value="${board.content}" />' readonly="readonly">
               	</div>
               	<div class="form-group">
               		<label for="writer">Writer</label>
               		<input class="form-control" name="writer"
               		value='<c:out value="${board.writer}" />' readonly="readonly">
               	</div>
               
               	<button data-oper="modify" class="btn btn-default">Modify</button>
               	<button data-oper="list" class="btn btn-default">List</button>
                
                <form id="operForm" action="/board/modify" method="get">
                	<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>'>
                	<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
                	<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
                	<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
                	<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
                </form>
                
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class='row'>
	
	<!-- /.panel -->
	<div class="panel panel-default">
		<div class="panel-heading">
			<i class="fa fa-comments fa-fw"></i> Reply
		</div>
		
	<!-- /.panel-body -->
	<div class="panel-body">
		<ul class="chat">
			<!-- start reply -->
			<li class="left clearfix" data-rno="12">
				<div>
					<div class="header">
						<strong class="primary-font">user00</strong>
						<small class="pull-right text-muted">2020-01-05 01:01</small>
					</div>
					<p>Good job!</p>
				</div>
			</li>
			<li class="left clearfix" data-rno="12">
				<div>
					<div class="header">
						<strong class="primary-font">user01</strong>
						<small class="pull-right text-muted">2020-01-05 01:09</small>
					</div>
					<p>Good job!</p>
				</div>
			</li>
			<!-- end reply -->
		</ul>
		<!-- ./ end ul -->
	</div>
	<!-- /.panel.chat-panel -->
	</div>
</div>

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
$(document).ready(function() {
	
	var bnoValue = '<c:out value="${board.bno}"/>';
	var replyUL = $(".chat");
	
	showList(1);
	
	function showList(page) {
		
		replyService.getList({bno:bnoValue, page:page || 1}, function(list) {
			
			var str = "";
			if(list == null || list.length == 0) {
				
				replyUL.html("");
				return;
			}
			
			for (var i = 0, len = list.length || 0; i < len; i++) {
				
				str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
				str += "	<div><div class='header'><strong class='primary-font'>" + list[i].replyer + "</strong>";
				str += "		<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
				str += "			<p>" + list[i].reply + "</p></div></li>";
			}
			
			replyUL.html(str);
		}); //end function
	} //end showList
});
</script>

<script>
// console.log("===============");
// console.log("JS TEST");

// var bnoValue = '<c:out value="${board.bno}"/>';

// //댓글 추가 테스트
// replyService.add(
// 		{reply:"JS Test", replyer:"tester", bno:bnoValue},
// 		function(result) {
// 			alert("RESULT : " + result);
// 		});

// //댓글 리스트 가져오기 테스트
// replyService.getList({bno:bnoValue, page:1}, function(list){
	
// 	for(var i = 0, len = list.length||0; i < len; i++) {
// 		console.log(list[i]);	
// 	}
// });

// // 86번 댓글 삭제 테스트
// replyService.remove(86, function(count){

// 	console.log(count);

// 	if (count == "success") {
// 		alert("댓글이 삭제되었습니다.");
// 	}
// }, function(err) {
// 	alert("댓글 삭제 실패!");
// });

// // 87번 댓글 수정 테스트
// replyService.update({
// 	rno : 87,
// 	bno : bnoValue,
// 	reply : "2차 수정된 댓글 내용"
// }, function(result) {
// 	alert("수정 완료");
// });

// // 특정 번호(87)의 댓글 조회
// replyService.get(87, function(data){
// 	console.log(data);
// });
</script>

<script type="text/javascript">
$(document).ready(function() {
  
  var operForm = $("#operForm"); 
  
  $("button[data-oper='modify']").on("click", function(e){
    
    operForm.attr("action","/board/modify").submit();
    
  });
  
    
  $("button[data-oper='list']").on("click", function(e){
    
    operForm.find("#bno").remove();
    operForm.attr("action","/board/list")
    operForm.submit();
    
  });  
});
</script>

<%@ include file="../includes/footer.jsp" %>