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
			<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">
			Add Reply
			</button>
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
	<div class="panel-footer"></div>
	</div>
</div>

<!-- Modal 추가 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">
            	<div class="form-group">
            		<label>Reply</label>
            		<input class="form-control" name="reply" value="New Reply!!!">
            	</div>
            	<div class="form-group">
            		<label>Replyer</label>
            		<input class="form-control" name="replyer" value="replyer">
            	</div>
            	<div class="form-group">
            		<label>Reply Date</label>
            		<input class="form-control" name="replyDate" value="2018-01-01 13:13">
            	</div>
            </div>
            <div class="modal-footer">
                <button class="btn btn-waring" id="modalModBtn" type="button">Modify</button>
                <button class="btn btn-danger" id="modalRemoveBtn" type="button">Remove</button>
                <button class="btn btn-primary" id="modalRegisterBtn" type="button">Register</button>
                <button class="btn btn-default" id="modalCloseBtn" type="button">Close</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->

<script type="text/javascript" src="/resources/js/reply.js"></script>

<script>
$(document).ready(function() {
	
	var bnoValue = '<c:out value="${board.bno}"/>';
	var replyUL = $(".chat");
	
	showList(1);
	
	function showList(page) {
		
		console.log("show list : " + page);

		replyService.getList({bno:bnoValue, page:page || 1}, function(replyCnt, list) {
			
			console.log("replyCnt : " + replyCnt);
			console.log("list : " + list);

			if (page == -1) {
				pageNum = Math.ceil(replyCnt/10.0); // 댓글목록의 마지막 페이지 번호
				showList(pageNum);
				return;
			}

			var str = "";
			if(list == null || list.length == 0) {
				
				replyUL.html("");
				if(page > 1) {
					pageNum = page - 1;
					showList(pageNum);
				} else {
					replyPageFooter.html("");
				}
				return;
			}
			
			for (var i = 0, len = list.length || 0; i < len; i++) {
				
				str += "<li class='left clearfix' data-rno='" + list[i].rno + "'>";
				str += "	<div><div class='header'><strong class='primary-font'>" + list[i].replyer + "</strong>";
				str += "		<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate) + "</small></div>";
				str += "			<p>" + list[i].reply + "</p></div></li>";
			}
			
			replyUL.html(str);

			showReplyPageList(replyCnt);
		}); //end function
	} //end showList
	
	var pageNum = 1;
	var replyPageFooter = $(".panel-footer");
	
	function showReplyPageList(replyCnt) {
		
		var endNum = Math.ceil(pageNum / 10.0) * 10;
		var startNum = endNum - 9;

		var prev = startNum != 1;
		var next = false;
		
		if (endNum * 10 >= replyCnt) {
			endNum = Math.ceil(replyCnt / 10.0);
		}

		if (endNum * 10 < replyCnt) {
			next = true;
		}

		var str = "<ul class='pagination pull-right'>";
			
		if (prev) {
			str += "<li class='page-item'><a class='page-link' href='" + (startNum-1) + "'>Previous</a></li>";
		}

		for (var i = startNum; i <= endNum; i++) {

			var active = pageNum == i ? "active" : "";

			str += "<li class='page-item " + active + "'><a class='page-link' href='" + i + "'>" + i + "</a></li>";
		}

		if (next) {
			
			str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";

		}
		
		str += "</ul>";
		console.log(str);

		replyPageFooter.html(str);
	}

	replyPageFooter.on("click","li a", function(e){
       e.preventDefault();
       console.log("page click");
       
       var targetPageNum = $(this).attr("href");
       
       console.log("targetPageNum: " + targetPageNum);
       
       pageNum = targetPageNum;
       
       showList(pageNum);
     });

	var modal = $(".modal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $("#modalModBtn");
	var modalRemoveBtn = $("#modalRemoveBtn");
	var modalRegisterBtn = $("#modalRegisterBtn");

	$("#modalCloseBtn").on("click", function(e) {
		
		$(".modal").modal("hide");
	});

	$("#addReplyBtn").on("click", function(e){
		
		modal.find("input").val("");
		modalInputReplyDate.closest("div").hide();
		modal.find("button[id != 'modalCloseBtn']").hide();
		
		modalRegisterBtn.show();
		
		$(".modal").modal("show");
	});

	modalRegisterBtn.on("click", function(e) {

		var reply = {
			reply : modalInputReply.val(),
			replyer : modalInputReplyer.val(),
			bno : bnoValue
		};
		replyService.add(reply, function(result){
			alert(result);

			modal.find("input").val("");
			modal.modal("hide");

			// showList(1);
			showList(-1);
		});
	});

	modalModBtn.on("click", function(e) {

	var reply = {rno : modal.data("rno"), reply : modalInputReply.val()};

	replyService.update(reply, function(result) {
			alert(result);
			
			modal.modal("hide");
			showList(pageNum);	
		});
	});

	modalRemoveBtn.on("click", function(e) {

	var rno = modal.data("rno");

	replyService.remove(rno, function(result) {
			alert(result);

			modal.modal("hide");
			showList(pageNum);	
		});
	});

	$(".chat").on("click", "li", function(e) {

		var rno = $(this).data("rno");

		replyService.get(rno, function(result) {
			modalInputReply.val(result.reply);
			modalInputReplyer.val(result.replyer);
			modalInputReplyDate.val(replyService.displayTime(result.replyDate))
			.attr("readonly", "readonly");
			modal.data("rno", result.rno);

			modal.find("button[id != 'modalCloseBtn']").hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			
			console.log(rno);
			$(".modal").modal("show");
		});
	});
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
    operForm.attr("action","/board/list");
    operForm.submit();
    
  });  
});
</script>

<%@ include file="../includes/footer.jsp" %>