<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.common-custom.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.silver.min.css' />" />
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/reKendo.css' />">
    

	<link rel="stylesheet" type="text/css" href="<c:url value='/resources/js/Scripts/jqueryui/jquery-ui.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/common.css'/>"/>
	
    <!--js-->
	<script type="text/javascript" src="<c:url value='/resources/js/Scripts/jquery-1.9.1.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/Scripts/jqueryui/jquery-ui.min.js'/>"></script> 

	<!--jsTree js-->
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>

	<script type="text/javascript" src="<c:url value='/resources/js/common/sweetalert.min.js'/>"></script>

</head>

<body>
<div class="sub_wrap">
<div class="sub_contents">
	<div class="iframe_wrap">

		<!-- 컨텐츠타이틀영역 -->
<!-- 		<div class="sub_title_wrap"> -->
			<div class="location_info">
				 <ul id="menuHistory"></ul> 
			</div>
			<div class="title_div">
				<h4></h4>
			</div>  
			<script>
			_g_serverName = "<%=request.getServerName()%>" ;
			_g_serverPort = "<%=request.getServerPort()%>" ;
			_g_contextPath_ = "${pageContext.request.contextPath}";

            /*아이콘 종류
            * success
            * warning
            * error
            * info
            * */

            function customAlert(msg, icon) {
                return swal({
                    title: '',
                    text: msg,
                    type: '',
                    icon: icon == '' ? 'success' : icon,
                    closeOnClickOutside : false,
                    button: '확인'
                })
            }

            function customConfirm(msg, icon) {
                return swal({
                    title: '',
                    text: msg,
                    type: '',
                    icon: icon == '' ? 'info' : icon,
                    buttons: {
                        agree: {
                            text : "예",
                            value : true
                        },
                        cancel: "아니요"
                    },
                    closeOnClickOutside : false
                })
            }
			</script>
<!-- 		</div> -->
		
		<tiles:insertAttribute name="body" />
	
	</div><!-- //iframe wrap -->
</div>
</div>
<div id="loading_spinner">
	<div class="cv_spinner">
		<span class="spinner"></span>
	</div>
</div>
</body>
</html>