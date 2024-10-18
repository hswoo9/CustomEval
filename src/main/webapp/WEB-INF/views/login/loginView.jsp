<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년  MM월  dd일" />

<style>
#login_b2_type .login_wrap .login_form_wrap form .inp1{margin:7px 0 0 0;padding:8px 10px;width:107px;border:1px solid #c9cac9;outline:none;background:#fff;font-size:15px;color:#4a4a4a;text-indent:0;}

</style>

<body name="0" style="background-image:url('/upload/img/logo/epis/IMG_COMP_LOGIN_BANNER_B_epis.png?1589091744978');background-size:cover;">

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
                       <input type="password" class="inp engfix" id="userPw" name="pw" placeholder="비밀번호 입력" value="">
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
   
<script>
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


function actionLogin(){

	$('#loginForm').submit();
	
}

function evalSearchPopup() {
    window.open(_g_contextPath_ + "/login/evalSearchPopup", 'evalSearchPopup', 'scrollbars=yes, resizeble=yes, menubar=no, toolbar=no, location=no, directories=yes, status=yes, width=1000, height=700');
}
</script>

	   
</body>