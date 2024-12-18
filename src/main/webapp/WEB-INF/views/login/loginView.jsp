<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년  MM월  dd일" />
<meta name="mobile-web-app-capable" content="yes">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="manifest" href="/manifest.json">


<style>
#login_b2_type .login_wrap .login_form_wrap form .inp1{margin:7px 0 0 0;padding:8px 10px;width:107px;border:1px solid #c9cac9;outline:none;background:#fff;font-size:15px;color:#4a4a4a;text-indent:0;}


@media (pointer:coarse) {
    /* custom css for "touch targets" */
    #login_b2_type {top:150px;}
}

/*body {
    background-image: url('/resources/Images/03.jpg');
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center center;
}*/

</style>



<body name="0" style="background-image:url(<c:url value='/resources/Images/main.jpg'/>);background-size:cover;">


<script>
$(function(){

	if('${message}' != ''){
		alert('${message}');
	}
	
});

</script>

   <div id="login_b2_type">
       
           <div class="company_logo">
               
               
               <img src="<c:url value='/resources/Images/bg/bg_main_login.png' />" alt="" id="" height="46px">               
                           
           </div>
           <div class="login_wrap">
           <div class="login_form_wrap">
               <p class="log_tit" style="padding:6px 0 10px 100px;">
                	평가위원 로그인
               </p>
               <form id="loginForm" action="<c:url value='/login' />" method="post">
               	<input type="hidden" id="isScLogin" name="isScLogin" value="">
                   <fieldset>
                       <div style="position: relative;">
                           <input type="text" class="inp engfix" id="commtitle" name="title" placeholder="평가제목 입력" value="" readonly>
                               <button type="button"
                                       class="k-button k-button-md k-button-solid k-button-solid-base"
                                       onclick="evalSearchPopup()"
                                       style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); margin-right: 130px; margin-top: 3.5px;">
                                   <span class="k-icon k-i-search k-button-icon"></span>
                               </button>
                         </div>
                       <input type="text" class="inp engfix" id="userId" name="id" placeholder="이름 입력" value="">
                       <%--<input type="password" class="inp engfix" id="userPw" name="pw" placeholder="비밀번호 입력" value="">--%>
                       <input type="text" class="inp engfix" id="userPhone" name="phone" placeholder="전화번호 입력" value="" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');">

                       <div class="log_btn">
                           <input type="image" value="로그인" src="<c:url value='/resources/Images/btn/login_b2_type_btn.png' />" onclick="actionLogin();return false;">
                       </div> 
                   </fieldset>
               </form>
           </div>
       </div>
        <div class="copy" style="display:none;">Copyright DOUZONE ICT GROUP. All rights reserved.</div>

   </div>
<%--<button type="button" class="k-button k-button-md k-button-solid k-button-solid-base" id="fullScreen" onclick="toggleFullscreen()">전체화면</button>--%>
   
<script>
    window.onload = function () {
        window.scrollTo(0, 0);
    };

    var _g_contextPath_ = "${pageContext.request.contextPath}";
var left = window.innerWidth / 2 - 283;
var top = window.innerHeight / 2 - 183;

$(window).resize(function(){
	left = window.innerWidth / 2 - 283;
	top = window.innerHeight / 2 - 183;
	
	$('#login_b2_type').css('left', left);
	$('#login_b2_type').css('top', top);
});

$(function(){
	
	$('#login_b2_type').css('left', left);
	$('#login_b2_type').css('top', top);
});


    function toggleFullscreen() {
        if (!document.fullscreenElement) {
            // 전체 화면이 아닐 때 전체 화면 모드로 전환
            $("#fullScreen").text("축소화면");
            document.documentElement.requestFullscreen()
                .catch((err) => {
                    console.error(`Error attempting to enable full-screen mode: ${err.message} (${err.name})`);
                });


        } else {
            $("#fullScreen").text("전체화면");

            document.exitFullscreen();

        }
    }


function actionLogin(){

	$('#loginForm').submit();
	
}

function evalSearchPopup() {
    window.open(_g_contextPath_ + "/login/evalSearchPopup", 'evalSearchPopup', 'scrollbars=yes, resizeble=yes, menubar=no, toolbar=no, location=no, directories=yes, status=yes, width=1000, height=700');
}
</script>

	   
</body>