<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년   MM월   dd일" />

<title>가산금</title>

<script type="text/javascript">
$(function(){
	
	hwpView();
	
});


function signSaveBtn(){
	_pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
		signHwpFileData = data;
	})

	setTimeout(signSave, 600);

	<%--var filePath = "" ;--%>
	<%--var filePathName = _pHwpCtrl.Path() ;--%>
	<%--var point = filePathName.lastIndexOf("\\") ;--%>
	<%--filePath = filePathName.substring(0,point+1);--%>

	<%--var fileName = "evelTemp";--%>
	<%--var fileNameBak = fileName+"_bak";--%>
	<%--fileName = fileName + ".pdf";--%>
	<%--fileNameBak = fileNameBak + ".pdf";--%>
	<%--var filePathName = filePath + fileName;--%>
	<%--var filePathNameBak = filePath + fileNameBak;--%>
	<%--var srcFilePathName = _pHwpCtrl.Path() ;--%>
	
	<%--var isSave = _pHwpCtrl.SaveAs(filePathName,"PDF");--%>
	<%--_pHwpCtrl.SaveAs(filePathNameBak,"PDF");--%>
	
	<%--var uploader = document.getElementById('uploader');	--%>
   	<%--uploader.addFile("docFile", filePathName);		//서버에 올릴 파일 경로+파일명--%>
	<%--uploader.addParam("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");	//눈구--%>
	<%--uploader.addParam("step", "10");	//단계--%>
	<%--var uploadUri = "<c:url value='/eval/setSignSetp' />";--%>
	<%--var result = uploader.sendRequest(_g_serverName, _g_serverPort, uploadUri);--%>
	
	<%--if(result != "FILE_NM") {--%>
	<%--	alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");--%>
	<%--	return false ;--%>
	<%--}else{--%>
	<%--	location.reload();--%>
	<%--}--%>
	
}
function signSave(){
	var formData = new FormData();
	formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
	formData.append("step", "10");
	formData.append("signHwpFileData", signHwpFileData);

	$.ajax({
		url : "<c:url value='/eval/setSignSetp'/>",
		type : "POST",
		data : formData,
		dataType : "json",
		contentType: false,
		processData: false,
		async : false,
		success : function(data) {
			if(data.result != "success") {
				alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
				return false ;
			} else {
				location.reload();
			}
		},
		error : function(request, status, error) {
			alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
			return false ;
		}
	})
}

function setSign(imgData){
// 	$('#signSrc').attr('src', 'data:image/png;base64,' + imgData);
// 	signSaveBtn();
	_hwpPutImage("sign", "C:\\SignData\\Temp.png");

}

//한글뷰어
function hwpView(){
	//로컬 보안 이슈
	// _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
	// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step10";
	// _pHwpCtrl.Open(hwpPath,"HWP");
	// _pHwpCtrl.EditMode = 0;
	var serverPath = "";
	var hostname = window.location.hostname;
	if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("121.186.165.80") > -1){
		serverPath = "http://121.186.165.80:8010";
	}else{
		serverPath = "http://one.epis.or.kr/"
	}

	var hwpPath = serverPath + "/upload/evalForm/step10.hwp";
	_hwpOpen(hwpPath, "HWP");

	_pHwpCtrl.EditMode = 0;
	_pHwpCtrl.SetToolBar(1, "TOOLBAR_MENU");
	_pHwpCtrl.SetToolBar(1, "TOOLBAR_STANDARD");
	_pHwpCtrl.ShowRibbon(false);
	_pHwpCtrl.ShowCaret(false);
	_pHwpCtrl.ShowStatusBar(false);
	_pHwpCtrl.SetFieldViewOption(1);
}

function _hwpPutData(){
	var date = "${nowDate}";
	var name = "${userInfo.NAME }";

	_hwpPutText("date", date);
	_hwpPutText("name", name);

	_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

	$("#signSave").show();
}

function evalAvoidPopup(){
	window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
}

</script>

<div style="width: 50%;margin: 0 auto;">
	<div id="signSave" style="display: none;">
		<%--<input type="button" onclick=";" value="서명하기">--%>
		<input type="button" onclick="evalAvoidPopup()" value="기피신청">
		<input type="button" onclick="signSaveBtn();" style="float:right;" value="다음">
	</div>

	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;"></div>
	
</div>
<%--<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >--%>
<%--</object>--%>
