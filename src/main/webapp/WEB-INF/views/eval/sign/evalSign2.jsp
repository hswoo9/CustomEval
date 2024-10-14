<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년   MM월   dd일" />

<title>사전 결의사항</title>

<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='/resources/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;업체별 시간설정을 진행중입니다.</span>
				</td>
			</tr>
		</table>
	</div>
	<!-- //pop_con -->
</div>

<script type="text/javascript">

	window.onload = function() {
		history.pushState(null, null, window.location.href);
		history.pushState(null, null, window.location.href);

		window.addEventListener('popstate', function () {
			history.pushState(null, null, window.location.href);
		});
	};

	$(function(){
		$('#loadingPop').kendoWindow({
			width: "443px",
			visible: false,
			modal: true,
			actions: [],
			close: false,
			title: false,
		}).data("kendoWindow").center();

		window.onbeforeunload = function (event) {
			if (typeof event == 'undefined') {
				event = window.event;
			}
			if (event) {
				OnDisconnectDevice();
			}
		};
	});





		<%--var html = $('#signBody').clone();--%>

		<%--$.each(html.find('input'), function(i, v){--%>
		<%--	var item = $(v).parent();--%>
		<%--	var itemTxt = item.text();--%>
		<%--	item.text(itemTxt + $(v).val());--%>
		<%--});--%>

		<%--html.find('input').remove();--%>

		<%--var data = {--%>
		<%--	commissioner_seq : '${userInfo.COMMISSIONER_SEQ}',	--%>
		<%--	html : html.get(0).outerHTML,--%>
		<%--	step : 2,--%>
		<%--	org_name : $('#org_name').val(),--%>
		<%--	birth_date : $('#birth_date').val(),--%>
		<%--	org_addr : $('#org_addr').val(),--%>
		<%--	bank_name : $('#bank_name').val(),--%>
		<%--	bank_no : $('#bank_no').val(),--%>

		<%--}--%>

		<%--$.ajax({--%>
		<%--	url: "<c:url value='/eval/setSignSetp' />",--%>
		<%--	data : data,--%>
		<%--	type : 'POST',--%>
		<%--	success: function(result){--%>
		<%--		if(result == 'FILE_NM'){--%>

		<%--			if(location.href.indexOf('evalView') > -1){--%>
		<%--				location.reload();					--%>
		<%--			}else{--%>
		<%--				window.close();--%>
		<%--			}--%>
		<%--		}--%>
		<%--	}--%>
		<%--});--%>
	function signSaveBtn() {
		var comboBox = _pHwpCtrl.GetFieldText("sign_2_minute1");
		var comboBox1 = _pHwpCtrl.GetFieldText("sign_2_minute2");
		// 성공여부 변수

		if (comboBox === "") {
			alert("제안업체별 제안발표 분을 선택해주세요.");
			return;
		} else if (comboBox1 === "") {
			alert("제안업체별 질의응답 분을 선택해주세요.");
			return;
		}

		evalApplyData = {
			committee_seq: '${userInfo.COMMITTEE_SEQ}'
		}

		$('#loadingPop').data("kendoWindow").open();
		$("#HwpCtrl_1").css("display", "none");

		timeIn = setInterval(fnSetSignSetpChk, 1000);

		// 값을 다시 NULL로 변경해주는
	}

	/** TODO. 데이터, PDF 서버 저장 */
	var signHwpFileData = "";
	function fnSetSignSetpChk (){
		$.ajax({
			url: "<c:url value='/eval/setSignSetpChk' />",
			data : {
				commissioner_seq : "${userInfo.COMMISSIONER_SEQ}",
				committee_seq : "${userInfo.COMMITTEE_SEQ}",
				step : "2",
				comboBox: _pHwpCtrl.GetFieldText("sign_2_minute1"),
				comboBox1: _pHwpCtrl.GetFieldText("sign_2_minute2"),
			},
			type : 'POST',
			success: function(result){
				if(result == "nullFail"){
					// alert("입력하지 않은 평가위원이 있습니다.");
					// return;
				}else if(result == "groupFail"){
					alert("다른 값을 입력한 평가위원이 있습니다.\n데이터가 초기화됩니다.");
					clearInterval(timeIn);
					location.reload();
					fnSetSignSetpChk2();
				}else if(result == 'notFail'){
					_pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
						signHwpFileData = data;
					})

					setTimeout(signSave, 600);
				}
			}
		})
	}
	//기존 groupFail 프로세스 후 데이터 초기와에 필요한 함수
	function fnSetSignSetpChk2 (){
		$.ajax({
			url: "<c:url value='/eval/setSignSetpChk' />",
			data : {
				commissioner_seq : "${userInfo.COMMISSIONER_SEQ}",
				committee_seq : "${userInfo.COMMITTEE_SEQ}",
				step : "99",
				comboBox: _pHwpCtrl.GetFieldText("sign_2_minute1"),
				comboBox1: _pHwpCtrl.GetFieldText("sign_2_minute2"),
			},
			type : 'POST',
			success: function(result){
			}

		})

	}



	function signSave(){
		var formData = new FormData();
		formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
		formData.append("committee_seq", "${userInfo.COMMITTEE_SEQ}");
		formData.append("step", "2");
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
					clearInterval(timeIn);
					location.reload();
				}
			}
		})
	}
	/** TODO. 데이터, PDF 서버 저장 */

	function setSign(imgData){
		_hwpPutImage("sign", "C:\\SignData\\Temp.png");
	}

	/** TODO. 한글뷰어 수정중 */
	function hwpView(){
		// _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
		// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step3";
		// _pHwpCtrl.Open(hwpPath,"HWP");
		//_pHwpCtrl.EditMode = 1;
		var serverPath = "";
		var hostname = window.location.hostname;
		if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("121.186.165.80") > -1){
			serverPath = "http://121.186.165.80:8010";
		}else{
			serverPath = "http://one.epis.or.kr/"
		}

		var hwpPath = "";
		if('${userInfo.EVAL_JANG}' != ''){
			if('${userInfo.EVAL_JANG}' == "Y"){
				hwpPath = serverPath + "/upload/evalForm/step3_jang.hwp";
			}else{
				hwpPath = serverPath + "/upload/evalForm/step3.hwp";
			}
		}else{
			hwpPath = serverPath + "/upload/evalForm/step3.hwp";
		}

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
		var title1 = "7. 평가위원장은  ${jangName}로 호선한다.";
		var date = "${nowDate}";
		var name = "${userInfo.NAME}";

		_hwpPutText("title1", title1);

		_hwpPutText("date", date);

		if('${userInfo.EVAL_JANG}' != ''){
			if('${userInfo.EVAL_JANG}' == "Y"){
				_hwpPutText("jangName", name);
				_hwpPutText("jangSign", "(인)");
				_hwpPutSignImg("jangSign", "${userInfo.SIGN_DIR }");

				var formData = new FormData();
				formData.append("committeeSeq", '${userInfo.COMMITTEE_SEQ}');
				$.ajax({
					url : "<c:url value='/eval/getSignList'/>",
					type : "POST",
					data : formData,
					dataType : "json",
					contentType: false,
					processData: false,
					async : false,
					success : function(data) {
						if(data.signList != null) {
							if(data.signList.length > 0){
								for(var i = 0 ; i < data.signList.length ; i++){
									_hwpPutText("field" + i, "평가위원");
									_hwpPutText("name" + i, data.signList[i].NAME);
									_hwpPutText("sign" + i, "(인)");
									_hwpPutSignImg("sign" + i, data.signList[i].SIGN_DIR);
								}
							}else{
								alert("오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
								return false ;
							}
						}else{
							alert("오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
							return false ;
						}
					}
				})


			}else{
				_hwpPutText("name", name);
				_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");
			}
		}else{
			_hwpPutText("name", name);
			_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");
		}


		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");
		_pHwpCtrl.Run("MoveViewUp");






		$("#signSave").show();
	}

	function minuteChange(e){
		if($(e).attr("id") == "minute1"){
			_hwpPutText("sign_2_minute1", $(e).val());
		}else{
			_hwpPutText("sign_2_minute2", $(e).val());
		}

	}
	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}

</script>
<div style="width: 50%;margin: 0 auto;">
	<div id="signSave" style="display: none;display: flex;justify-content: space-between;">
		<div>
			<input type="button" onclick="evalAvoidPopup()" style="background-color: #dee4ea; border-color: black; border-width: thin;" value="기피신청">
			<sapn style="padding-left: 10px;">※업체별 시간 입력 가이드</sapn>
		</div>
		<div>
			제안발표
			<select id="minute1" onchange="minuteChange(this)" style="width:50px;">
				<option>선택</option>
				<c:forEach var="minute" begin="5" step="5" end="200">
					<option>${minute}</option>
				</c:forEach>
			</select>

			질의응답
			<select id="minute2" onchange="minuteChange(this)" style="width:50px;">
				<option>선택</option>
				<c:forEach var="minute" begin="5" step="5" end="200">
					<option>${minute}</option>
				</c:forEach>
			</select>
			<input type="button" onclick="signSaveBtn();" style="margin-left:23px; background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
		</div>
	</div>

	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;"></div>

</div>
<%--<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >--%>
<%--</object>--%>
