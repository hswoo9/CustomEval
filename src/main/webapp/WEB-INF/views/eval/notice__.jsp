<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>

<script>
	window.onload = function () {
		window.scrollTo(0, 0);
	};

$(function(){
	
	hwpView();
});

//한글뷰어
var _pHwpCtrl;
function hwpView(){
	_pHwpCtrl = document.getElementById("HwpCtrl_1");

	var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step1";
	_pHwpCtrl.Open(hwpPath,"HWP");
	_pHwpCtrl.EditMode = 0;
	
}

function nextPageBtn(){
	
	location.href = _g_contextPath_ + "/eval/evalView";
	
}

</script>

<div id="signSave">
	<input type="button" onclick="nextPageBtn();" style="background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
</div>

<OBJECT id="HwpCtrl_1" style="LEFT: 0px; TOP: 100px" height="840px;" width="900px;" align=center classid=CLSID:BD9C32DE-3155-4691-8972-097D53B10052 onError="activex_error(${status.count})">
</OBJECT>