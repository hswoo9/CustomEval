<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년  MM월  dd일" />
<title>위원별 제안서 평가표</title>

<script type="text/javascript">
	var list = JSON.parse('${list}');
	var getCompanyList = JSON.parse('${getCompanyList}');
	var getCompanyRemarkList = JSON.parse('${getCompanyRemarkList}');
	var itemList = JSON.parse('${itemList}');
	var getCompanyTotal = JSON.parse('${companyTotal}');

	$(function(){
		alert('"제안평가 위원님은 본인의 평가가 이상이 없는지 확인하시고\n이상이 있으면 수정하여 주시기 바라며,\n저장버튼 클릭후에는 수정이 불가능 합니다"');
	});

	var signHwpFileData = "";
	function signSaveBtn(){
		_pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
			signHwpFileData = data;
		})

		setTimeout(signSave, 600);
	}

	function signSave(){
		var formData = new FormData();
		formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
		formData.append("step", "6");
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
		_hwpPutImage("sign", "C:\\SignData\\Temp.png");
	}

	/** TODO. 한글뷰어 수정중 */
	function hwpView(){
		//로컬 보안 이슈
		// _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
		// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step7";
		// _pHwpCtrl.Open(hwpPath,"HWP");

		var serverPath = "";
		var hostname = window.location.hostname;
		if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("121.186.165.80") > -1){
			serverPath = "http://121.186.165.80:8010";
		}else{
			serverPath = "http://one.epis.or.kr/"
		}

		var hwpPath = serverPath + "/upload/evalForm/step7.hwp";
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
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");

		var title1 = "${userInfo.TITLE }";
		var date = "${nowDate}";
		var dept = "${userInfo.ORG_NAME }";
		var name = "";

		if("${userInfo.EVAL_BLIND_YN}" == "N"){
			name = "${userInfo.NAME }";
		}else{
			name = "${fn:substring(userInfo.NAME, 0, 1)}**";
		}

		_hwpPutText("title1", title1);
		_hwpPutText("date", date);
		_hwpPutText("dept", dept);
		_hwpPutText("name", name);
		_hwpPutText("date", date);

		_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

		setItem();
		//페이지 위로 이동
		_pHwpCtrl.Run("MoveViewUp");

		$("#signSave").show();
	}

	function setItem(){
		//채우기
		for (var i = 0; i < getCompanyList.length; i++) {
			_hwpPutText("company{{"+i+"}}", getCompanyList[i].display_title);
			_hwpPutText("company_sub{{"+i+"}}", getCompanyList[i].display_title);
			_hwpPutText("total{{"+i+"}}", totalToFixed(getCompanyTotal[i].real_score));
		}

		for (var i = 0; i < itemList.length; i++) {
			_hwpPutText("item1{{"+i+"}}", itemList[i].item_name);
			_hwpPutText("item2{{"+i+"}}", itemList[i].item_name);
			_hwpPutText("item3{{"+i+"}}", itemList[i].item_name);
			_hwpPutText("score1{{"+i+"}}", String(itemList[i].score));
			_hwpPutText("score2{{"+i+"}}", String(itemList[i].score));
			_hwpPutText("score3{{"+i+"}}", String(itemList[i].score));
		}

		for (var i = 0; i < getCompanyRemarkList.length; i++) {
			_hwpPutText("remark{{"+i+"}}", getCompanyRemarkList[i].remark);
		}

		//항목
		for (var i = itemList.length; i < 30; i++) {
			_pHwpCtrl.MoveToField("item1{{"+itemList.length+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
			_pHwpCtrl.MoveToField("item2{{"+itemList.length+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
			_pHwpCtrl.MoveToField("item3{{"+itemList.length+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}

		//비고
		for (var i = getCompanyRemarkList.length; i < 10; i++) {
			_pHwpCtrl.MoveToField("remark{{"+getCompanyRemarkList.length+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}

		//기관 점수 각각 등록
		var cnt = 0;
		var index = 0;
		var companyId = '';

		var pageCnt = getCompanyList.length / 10;
		if(pageCnt <= 1){
			_pHwpCtrl.MoveToField("rowTable{{2}}");
			_pHwpCtrl.Run("TableDeleteRow");
			_pHwpCtrl.MoveToField("rowTable{{1}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}else if(pageCnt <= 2){
			_pHwpCtrl.MoveToField("rowTable{{2}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}

		for (var i = 0; i < list.length; i++) {
			if(list[i].EVAL_COMPANY_SEQ != companyId){
				companyId = list[i].EVAL_COMPANY_SEQ;
				cnt++;
				index = 0;
			}
			_hwpPutText("score_"+cnt+"{{"+index+"}}", String(list[i].RESULT_SCORE));
			index++;
		}
	}

	function evalModBtn(){
		$.ajax({
			url: "<c:url value='/eval/evalMod' />",
			data : {commissioner_seq : '${userInfo.COMMISSIONER_SEQ}'},
			type : 'POST',
			success: function(result){
				if(result == 'N'){
					location.reload();
				}else{
					alert('수정할 수 없습니다.');
				}
			}
		});

	}

	//반올림
	function totalToFixed(v){
		var txt = 0;
		if(v % 1 == 0) {
			txt = v;
		}else{
			txt = v.toFixed(4);
			for (var i = 0; i < 4; i++) {
				txt = txt.replace(/0$/g, '');
			}
		}
		return String(txt);
	}

	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}

</script>
<div style="width: 50%;margin: 0 auto;">
	<div id="signSave" style="display: none;">
		<input type="button" onclick="evalAvoidPopup()" value="기피신청">
		<input type="button" onclick="evalModBtn();" value="평가 수정">
		<input type="button" onclick="signSaveBtn();" value="저장">
	</div>

	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;"></div>
</div>

<%--<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >--%>
<%--</object>--%>
