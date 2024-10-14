<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년   MM월   dd일" />

<title>각서</title>

<script type="text/javascript">
	console.log("${userInfo.SIGN_DIR}");
	$(function(){
		if("${userInfo.EVAL_JANG}" == "Y" && !$("#jangBlindChk").val()){
			evalBlindPopup();
		}

	});

	window.onload = function() {
		history.pushState(null, null, window.location.href);
		history.pushState(null, null, window.location.href);

		window.addEventListener('popstate', function () {
			history.pushState(null, null, window.location.href);
		});
	};


	function evalBlindPopup(){
		window.open(_g_contextPath_ + "/eval/evalBlindPopup?committee_seq=${userInfo.COMMITTEE_SEQ}", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=540,height=240,left=650,top=250');
	}

	var signHwpFileData = "";
	function signSaveBtn(){
		if("${userInfo.EVAL_JANG}" == "Y" && !$("#jangBlindChk").val()){
			alert("평가 집계표 출력 방식을 선택해주세요.");
			evalBlindPopup();
			return;
		}

		_pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
			signHwpFileData = data;
		})

		timeIn = setTimeout(signSave, 600);
	}

	function signSave(){
		var formData = new FormData();
		formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
		formData.append("step", "1");
		formData.append("signHwpFileData", signHwpFileData);

		$.ajax({
			url : "<c:url value='/eval/setSignSetp'/>",
			type : "POST",
			data : formData,
			dataType : "json",
			contentType: false,
			processData: false,
			enctype : 'multipart/form-data',
			async : false,
			success : function(data) {
				if(data.result != "success") {
					alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
					return false ;
				} else {
					location.reload();
				}
			}
		})

	}

	function setSign(imgData){
		_hwpPutImage("sign", "C:\\SignData\\Temp.png");
	}

	/** TODO. 한글뷰어 수정중 */
	function hwpView(e){
		var serverPath = "";
		var hostname = window.location.hostname;
		if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("121.186.165.80") > -1){
			serverPath = "http://121.186.165.80:8010";
		}else{
			serverPath = "http://one.epis.or.kr/"
		}
		// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step2";
		var hwpPath = serverPath + "/upload/evalForm/step2.hwp";
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
		//내용
		var title1 = "본인은 ${userInfo.EVAL_S_DATE3} ~ ${userInfo.EVAL_E_DATE3}까지「${userInfo.TITLE }사업 」의 평가(심사)위원 위촉을 확인하며 다음 사항을 준수할 것을 서약합니다.";
		var title2 = "1. 본인은 「${userInfo.TITLE }」의 평가(심사)를 함에 있어 모든 보안사항을 철저히 이행할 것입니다.";

		var date = "${nowDate}";

		var dept = "${userInfo.ORG_NAME }";
		var postion = "${userInfo.ORG_GRADE }";
		var name = "${userInfo.NAME }";

		_hwpPutText("title1", title1);
		_hwpPutText("title2", title2);
		_hwpPutText("date", date);

		_hwpPutText("dept", dept);
		_hwpPutText("postion", postion);
		_hwpPutText("name", name);

		_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

		$("#signSave").show();
	}

	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}

</script>

<div style="width: 50%;margin: 0 auto;">
	<div id="signSave" style="display: none;display: flex;justify-content: space-between;">
		<div>
			<input type="hidden" id="jangBlindChk" name="jangBlindChk">
	<%--		<input type="button" onclick="OnConnectDevice();" value="서명하기">--%>
			<input type="button" onclick="evalAvoidPopup()" style="background-color: #dee4ea; border-color: black; border-width: thin;" value="기피신청">
		</div>

		<div>
			<input type="button" onclick="signSaveBtn();"  style="float:right; margin-left:10px; background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
			<c:if test="${userInfo.EVAL_JANG eq 'Y'}">
				<input type="button" onclick="evalBlindPopup();" value="평가집계표 출력방식 설정" style="float:right;">
			</c:if>
		</div>

	</div>

	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;"></div>

</div>
<%--<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >--%>
<%--</object>--%>
