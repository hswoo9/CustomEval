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
    html, body {
        overflow-y: scroll !important;
        scrollbar-width: auto !important;
        -ms-overflow-style: scrollbar !important; }

    ::-webkit-scrollbar {
        width: 8px;
    }

    ::-webkit-scrollbar-thumb {
        background-color: #888;
        border-radius: 3px;
    }

    ::-webkit-scrollbar-track {
        background: #f1f1f1;
    }
</style>

<script>
    window.onload = function () {
        window.scrollTo(0, 0);
    };
</script>

<body name="0" style="background-image:url('/resources/Images/main.jpg');background-size:cover;">


<div id="login_b2_type" style="top: 20% !important; left: 28% !important;">

    <div class="company_logo">


        <img src="<c:url value='/resources/Images/bg/bg_main_login.png' />" alt="" id="" height="46px">

    </div>
    <div class="login_wrap">
        <div class="login_form_wrap" style="display: flex; justify-content: center; align-items: center; height: 100%;">
            <span style="font-size: 18px; font-weight: bold; text-align: center;">평가가 완료되었습니다. 수고하셨습니다.</span>
        </div>
    </div>
    <div class="copy" style="display:none;">Copyright DOUZONE ICT GROUP. All rights reserved.</div>
</div>



</body>