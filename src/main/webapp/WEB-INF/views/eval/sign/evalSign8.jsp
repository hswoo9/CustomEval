<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년  MM월  dd일" />

<script type="text/javascript">

	var result = JSON.parse('${result}');
	var rates = "${userInfo.RATES}" || "";

	$(function(){
	// 	OnConnectDevice();
		alert('"제안평가위원장은 \"제안서 평가 총괄표\" 및\n\"업체별 제안서 평가집계표\"에 이상이 없는지\n정확히 확인하여 주시기 바라며,\n저장버튼 클릭후에는 수정이 불가능 합니다"');
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
		formData.append("committee_seq", "${userInfo.COMMITTEE_SEQ}");
		formData.append("join_select_type", "${userInfo.JOIN_SELECT_TYPE}");
		formData.append("purc_req_id", "${userInfo.PURC_REQ_ID}");
		formData.append("proba", rates);
		formData.append("step", "8");
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
		// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step9";
		// _pHwpCtrl.Open(hwpPath,"HWP");
		// _pHwpCtrl.EditMode = 0;.

		var serverPath = "";
		var hostname = window.location.hostname;
		if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("121.186.165.80") > -1){
			serverPath = "http://121.186.165.80:8010";
		}else{
			serverPath = "http://one.epis.or.kr/"
		}

		var hwpPath = serverPath + "/upload/evalForm/step9.hwp";
		_hwpOpen(hwpPath, "HWP");

		_pHwpCtrl.EditMode = 0;
		_pHwpCtrl.SetToolBar(1, "TOOLBAR_MENU");
		_pHwpCtrl.SetToolBar(1, "TOOLBAR_STANDARD");
		_pHwpCtrl.ShowRibbon(false);
		_pHwpCtrl.ShowCaret(false);
		_pHwpCtrl.ShowStatusBar(false);
		_pHwpCtrl.SetFieldViewOption(1);

		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
	}

	function _hwpPutData(){
		//내용
		var title1 = "${userInfo.TITLE }";
		var date = "${nowDate}";

		var dept = "${userInfo.ORG_NAME }";
		var name = "${userInfo.NAME }";

		_hwpPutText("title1", title1);
		_hwpPutText("name", name);
		_hwpPutText("date", date);
		_hwpPutText("rates", "환산점수(" + rates + "%)");
		_hwpPutText("sum_rates", String(100 * (rates/100)));

		_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

		setItem();

		//페이지 위로 이동
		_pHwpCtrl.Run("MoveViewUp");

		$("#signSave").show();
	}

	function setItem(){
		//항목 리스트
		var colList = result.colList;
		//기업별 점수
		var list = result.list;

		console.log(colList);

		//채우기
		for (var i = 0; i < list.length; i++) {
			_hwpPutText("company{{"+i+"}}", list[i].DISPLAY_TITLE);
			_hwpPutText("sum{{"+i+"}}", qksdhffla(list[i].TOTAL_SUM));
			_hwpPutText("sum_ave{{"+i+"}}", qksdhffla(list[i].TOTAL_SUM * (rates/100)) );
			_hwpPutText("eval{{"+i+"}}", list[i].TOTAL_SUM >= 85 ? '적격' : '부적격' );
		}


		for (var i = 0; i < colList.length; i++) {
			_hwpPutText("item1{{"+i+"}}", colList[i].item_name);
			_hwpPutText("item2{{"+i+"}}", colList[i].item_name);
			_hwpPutText("item3{{"+i+"}}", colList[i].item_name);
			_hwpPutText("score1{{"+i+"}}", String(colList[i].score));
			_hwpPutText("score2{{"+i+"}}", String(colList[i].score));
			_hwpPutText("score3{{"+i+"}}", String(colList[i].score));
		}

		//나머지 지우기
		//업체
	// 	for (var i = list.length; i < 10; i++) {
	// 		_pHwpCtrl.MoveToField("company{{"+list.length+"}}");
	// 		_pHwpCtrl.Run("TableDeleteColumn");
	// 	}

		//항목
		for (var i = colList.length; i < 30; i++) {
			_pHwpCtrl.MoveToField("item1{{"+colList.length+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
			_pHwpCtrl.MoveToField("item2{{"+colList.length+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
			_pHwpCtrl.MoveToField("item3{{"+colList.length+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}

		//기관 점수 각각 등록
		var cnt = 0;
		var index = 0;
		var companyId = '';

		for (var i = 0; i < list.length; i++) {

			//score_1
			for (var j = 0; j < colList.length; j++) {
				var v = list[i]["ITME_SCORE_" + colList[j].item_seq];
				_hwpPutText("score_"+(i+1)+"{{"+j+"}}", qksdhffla(v));
			}
		}

		var pageCnt = list.length / 10;
		if(pageCnt <= 1){
			_pHwpCtrl.MoveToField("rowTable{{2}}");
			_pHwpCtrl.Run("TableDeleteRow");
			_pHwpCtrl.MoveToField("rowTable{{1}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}else if(pageCnt <= 2){
			_pHwpCtrl.MoveToField("rowTable{{2}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}
	}

	//반올림
	function qksdhffla(v){
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

	function reloadBtn(){
		location.reload();
	}

	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}

</script>
<div style="width: 50%;margin: 0 auto;">
	<div id="signSave" style="display: none;">
<%--		<input type="button" onclick="OnConnectDevice();" value="서명하기">--%>
		<input type="button" onclick="evalAvoidPopup()" value="기피신청">
		<input type="button" onclick="reloadBtn();" value="새로고침">
		<input type="button" onclick="signSaveBtn();" value="저장">
	</div>

	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;"></div>
</div>
