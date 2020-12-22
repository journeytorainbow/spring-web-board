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
                		value='<c:out value="${board.content}" />' readonly="readonly">
                	</div>
                	<button type="modify" class="btn btn-default">
                		<a href="/board/modify?bno=<c:out value="${board.bno}"/>">Modify</a>
                	</button>
                	<button type="reset" class="btn btn-default">
                	<a href="/board/list">List</a></button>
                
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<%@ include file="../includes/footer.jsp" %>