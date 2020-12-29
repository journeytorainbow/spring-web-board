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
            
            	<form role="form" action="/board/modify" method="post">
            		<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum}"/>'>
            		<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
            		<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
            		<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
                	<div class="form-group">
                		<label for="bno">Bno</label>
                		<input class="form-control" name="bno" 
                		value='<c:out value="${board.bno}" />' readonly="readonly">
                	</div>
                	<div class="form-group">
                		<label for="title">Title</label>
                		<input class="form-control" name="title" 
                		value='<c:out value="${board.title}" />'>
                	</div>
                	<div class="form-group">
                		<label for="content">Content</label>
                		<input class="form-control" name="content"
                		value='<c:out value="${board.content}" />'>
                	</div>
                	<div class="form-group">
                		<label for="writer">Writer</label>
                		<input class="form-control" name="writer"
                		value='<c:out value="${board.writer}" />' readonly="readonly">
                	</div>
                	<div class="form-group">
                		<label for="regDate">Register Date</label>
                		<input class="form-control" name="regDate"
                		value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regDate}" />' readonly="readonly">
                	</div>
                	<div class="form-group">
                		<label for="updateDate">Update Date</label>
                		<input class="form-control" name="updateDate"
                		value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updateDate}" />' readonly="readonly">
                	</div>
                	
                	<button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
                	<button type="submit" data-oper="remove" class="btn btn-default">Remove</button>
                	<button type="submit" data-oper="list" class="btn btn-default">List</button>
                </form>
                
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<script type="text/javascript">
	$(document).ready(function() {
		
		var formObj = $("form");
		
		$("button").on("click", function(e) {
			
			e.preventDefault(); // 기본 동작 막기
			
			var operation = $(this).data("oper");
			
			console.log(operation);
			
			if(operation === "remove") {
				formObj.attr("action", "/board/remove");
			} else if(operation === "list") {
				
				// list페이지로 이동
				// self.location="/board/list";
				
				formObj.attr("action", "/board/list").attr("method", "get");
				var pageNumTag = $("input[name='pageNum']").clone(); // form 태그에서 필요한 부분만 복사해둠
				var amountTag = $("input[name='amount']").clone();
				var typeTag = $("input[name='type']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				
				formObj.empty(); // form태그 내용 전부 지우기
				formObj.append(pageNumTag); // 필요한 태그만 추가
				formObj.append(amountTag);
				formObj.append(typeTag);
				formObj.append(keywordTag);
			}
			formObj.submit(); // 직접 submit 수행
		});
	});
</script>

<%@ include file="../includes/footer.jsp" %>