<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

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
                	
                	<sec:authentication property="principal" var="pinfo"/>
           			<sec:authorize access="isAuthenticated()">
           				<c:if test="${pinfo.username eq board.writer}">					
	                		<button type="submit" data-oper="modify" class="btn btn-default">Modify</button>
    	            		<button type="submit" data-oper="remove" class="btn btn-default">Remove</button>
        				</c:if>
              		</sec:authorize>
                	<button type="submit" data-oper="list" class="btn btn-default">List</button>
                	
                	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                </form>
                
            </div>
            <!-- /.panel-body -->
        </div>
        <!-- /.panel -->
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	
	.uploadResult ul {
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	
	.uploadResult ul li img {
		width: 100px;
	}

	.uploadResult ul li span {
		color:white;
	}

	.bigPictureWrapper {
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background: rgba(255, 255, 255, 0.5);
	}

	.bigPicture {
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}

	.bigPicture img {
		width: 600px;
	}
</style>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Files</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
				<div class="form-group">
					<input type="file" name="uploadFile" multiple="multiple">
				</div>

				<div class="uploadResult">
					<ul>


					</ul>
				</div>
			</div>
			<!-- end panel-body -->
		</div>
		<!-- end panel -->
	</div>
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

			} else if(operation === "modify") {

				console.log("modify button click");
				
				var str = "";

				$(".uploadResult ul li").each(function(i, obj) {

					var jobj = $(obj); // 각 li

					console.dir("jobj : " + jobj);

					str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
					str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";
				});

				formObj.append(str);
			}
			formObj.submit(); // 직접 submit 수행
		});
	});
</script>

<script>
	$(document).ready(function() {

		// 해당 게시글에 기존에 등록되어 있던 첨부 파일이 보여짐
		(function() {
			var bno = '<c:out value="${board.bno}"/>';

			$.getJSON("/board/getAttachList", {bno : bno}, function(arr) {

				console.log("attachList : " + arr);

				var str = "";

				$(arr).each(function(i, attach) {

					// image type
					if(attach.fileType) {

						var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);

						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename ='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
						str += "<span> " + attach.fileName + "</span>";
						str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image'";
						str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/display?fileName=" + fileCallPath + "'>";
						str += "</div>"
						str += "</li>";
					} else {
						str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename ='" + attach.fileName + "' data-type='" + attach.fileType + "'><div>";
						str += "<span>" + attach.fileName + "</span>";
						str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image'";
						str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
						str += "<img src='/resources/img/attach.png'>";
						str += "</div>";
						str += "</li>";
					}
				}); // end each

				$(".uploadResult ul").html(str);
			}); // end getJson
		})(); // end function

		$(".uploadResult").on("click", "button", function(e) {

			console.log("delete file");

			if (confirm("파일을 삭제하시겠습니까?")) { 
				
				var targetLi = $(this).closest("li");
				targetLi.remove(); // 화면에서만 삭제
			}
		});

		var regex = new RegExp("(.*)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; // 5MB

		function checkExtension(fileName, fileSize) {

			if(fileSize >= maxSize) {
				alert("파일 사이즈가 초과되었습니다.");
				return false;
			}

			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			
			return true;
		}

		// 새로운 첨부 파일 추가
		$("input[type='file']").change(function(e) {

			var formData = new FormData();
			
			var inputFile = $("input[name='uploadFile']");

			var files = inputFile[0].files;

			for (var i = 0; i < files.length; i++) {

				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				formData.append("uploadFile", files[i]);
			}

			$.ajax({
				url: '/uploadAjaxAction',
				processData : false, // 반드시 false로 지정
				contentType : false, // 반드시 false로 지정
				data : formData, // 서버로 전송될 데이터
				type : 'POST',
				dataType : 'json',
				success : function(result) { // 파라미터 : json list
					console.log(result);

					showUploadResult(result); // 업로드된 파일 처리 함수
				}
			}); // ajax end
		});

		// 새롭게 추가된 첨부 파일을 화면에 보여주기 위한 함수
		function showUploadResult(uploadResultArr) {

			if(!uploadResultArr || uploadResultArr.length == 0) {
				return;
			}

			var uploadUL = $(".uploadResult ul");

			var str = "";

			$(uploadResultArr).each(function(i, obj) {

				//image type
				if(obj.image) {
				var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
					str += "<li data-path='"+obj.uploadPath+"'";
					str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'"
					str +" ><div>";
					str += "<span> "+ obj.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' "
					str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str +"</li>";
				} else {
					var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);			      
					var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
					
					str += "<li "
					str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
					str += "<span> "+ obj.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' " 
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/attach.png'></a>";
					str += "</div>";
					str += "</li>";
				}
			});

			uploadUL.append(str);
		}
	});
</script>

<%@ include file="../includes/footer.jsp" %>