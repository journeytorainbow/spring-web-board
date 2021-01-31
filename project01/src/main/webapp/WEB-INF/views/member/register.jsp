<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
	<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>SB Admin 2 - Bootstrap Admin Theme</title>

    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">회원가입</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" method="post" action="/member/register">
                            <fieldset>
                                <div class="form-group">
                                    <input class="form-control" id="userid" placeholder="Id" name="userid" type="text" autofocus>
                                    <button class="idCheckBtn" type="button">중복체크</button>
                                    <span class="showText" style=""></span>
                                </div>
                                <div class="form-group">
                                    <input class="form-control" id="userpw" placeholder="Password" name="userpw" type="password" value="">
                                </div>
                                <div class="form-group">
                                    <input class="form-control" id="username" placeholder="Name" name="userName" type="text" value="">
                                </div>
                                <!-- Change this to a button or input when using this as a form -->
                                <a href="index.html" class="btn btn-lg btn-success btn-block">Register</a>
                                <a href="/board/list" class="btn btn-lg btn-danger btn-block">Cancel</a>
                            </fieldset>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" id="role" name="auth" value="ROLE_USER" />
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="/resources/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/resources/dist/js/sb-admin-2.js"></script>
    
    <script>
    var str = "";
    var userid = $("#userid");
    var userpw = $("#userpw");
    var username = $("#username");
    
    var role = $("#role");
    
    // 공백 체크
    var pattern = /\s/g;
    
    $(".btn-success").on("click", function(e) {
    	
    	e.preventDefault();
    	
    	if(userid.val() == "" || userid.val().match(pattern)) {
    		alert("아이디를 입력해주세요!");
    		userid.focus();
    		return;
    	}
    	
    	if(userpw.val() == "" || userpw.val().match(pattern)) {
    		alert("비밀번호를 입력해주세요!");
    		userpw.focus();
    		return;
    	}
    	
    	if(username.val() == "" || username.val().match(pattern)) {
    		alert("이름을 입력해주세요!");
    		username.focus();
    		return;
    	}
    	
    	str += "<input type='hidden' name='authList[0].userid' value='" + userid.val() + "'>";
    	str += "<input type='hidden' name='authList[0].auth' value='" + role.val() + "'>";
    	
    	$("form").append(str);
    	$("form").submit();
    });
     
    var csrfHeaderName = "${_csrf.headerName}";
    var csrfTokenValue = "${_csrf.token}";
    
    function checkId() {
    	$.ajax({
    		url : "/member/idCheck",
    		type : "post",
    		contentType : "application/json; charset=utf-8",
    		dataType : "json",
    		data : JSON.stringify({"userid" : userid.val()}),
    		beforeSend : function(xhr) {
    			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
    		},
    		success : function(data) {
    			console.log("checkId Ajax call");
    			console.log("data : " + data);
    			if(data == 1) {
    				showNotAvailable();
    				return false;
    			} else if(data == 0) {
    				showAvailable();
    				return true;
    			}
    		}
    	});
    }
    
    var idCheckBtn = $(".idCheckBtn");
    var showText = $(".showText");
    var str = "";
    
    function showAvailable() {
    	str = "사용 가능한 아이디입니다.";
    	showText.attr("style", "color:blue");
    	showText.html(str);
    }
    
    function showNotAvailable() {
    	str = "이미 존재하는 아이디입니다.";
    	showText.attr("style", "color:red");
    	showText.html(str);
    }
    
    idCheckBtn.on("click", function(e) {
    	e.preventDefault();
    	
    	if(userid.val() == "" || userid.val().match(pattern)) {
    		alert("아이디를 입력해주세요!");
    		userid.focus();
    		return;
    	}
    	
    	checkId();
    });
    </script>

</body>
</html>