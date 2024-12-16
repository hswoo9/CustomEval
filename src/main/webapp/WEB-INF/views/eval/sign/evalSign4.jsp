<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년   MM월   dd일" />
<%--<script type="text/javascript" src="http://10.10.10.112:8080/js/hwpctrlapp/utils/util.js"></script>
<script type="text/javascript" src="http://10.10.10.112:8080/js/webhwpctrl.js"></script>--%>

<title>평가수당</title>
<style>
	.modern-table-container {
		width: 800px;
		margin: 20px auto;
		font-family: 'Noto Sans KR', sans-serif;
	}
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
	.modern-table {
		width: 100%;
		margin-bottom: 20px;
		border-collapse: collapse;
		background: white;
		border: 2px solid #2c3e50;
	}

	.table-title {
		background-color: #2c3e50;
		color: white;
		padding: 12px 15px;
		font-size: 1.1em;
		text-align: left;
		border: none;
	}

	.modern-table td {
		padding: 10px 15px;
		border: 1px solid #ddd;
	}

	.modern-table .header {
		background-color: #f8f9fa;
		color: #2c3e50;
		font-weight: 500;
		width: 20%;
		border: 1px solid #ddd;
		text-align: center;
	}

	.modern-table .data {
		width: 30%;
		color: #34495e;
		border: 1px solid #ddd;
	}

	.total-amount {
		font-weight: bold;
		color: #e74c3c;
		font-size: 1.1em;
	}

	.modern-table tr {
		border: 1px solid #ddd;
	}

	.modern-table tr:hover {
		background-color: #f8f9fa;
	}

	@media (max-width: 820px) {
		.modern-table-container {
			width: 95%;
			margin: 10px auto;
		}
	}
</style>
<script type="text/javascript">
	window.onload = function () {
		window.scrollTo(0, 0);
	};

	var pageCode = 4;
	var fileDownFlag = false;

	window.onload = function() {
		history.pushState(null, null, window.location.href);
		history.pushState(null, null, window.location.href);

		window.addEventListener('popstate', function () {
			history.pushState(null, null, window.location.href);
		});
	};

	$(function(){
		var avoidFailMessage = "${avoidFailMessage}";
		if(avoidFailMessage != ""){
			alert(avoidFailMessage);
		}

		window.onbeforeunload = function (event) {
			if (typeof event == 'undefined') {
				event = window.event;
			}
			if (event) {
				OnDisconnectDevice();
			}
		};
	});

	/*	function fileDownChk(){
            if(fileDownFlag){
                signSaveBtn()
            }else{
                alert("평가자료를 다운로드 해주세요.");
            }
        }*/
	$(document).ready(function() {
		$('#bank_name').on('input', function() {
			this.value = this.value.replace(/\d/g, ''); // 숫자 제거
		});
		$('#bank_no').on('input', function() {
			this.value = this.value.replace(/[^-\d]/g, ''); // 숫자와 '-' 이외의 문자 제거
		});
		$('#evaluationFee').on('input', function() {
			let numericValue = this.value.replace(/[^\d]/g, '');
			this.value = numberWithCommas(numericValue);
		});
	});

	function showModifyConfirmButtons() {
		var p1 = $('#num1').val();
		var p2 = $('#num2').val();
		var flag = isKorJumin(p1, p2);

		if (p1.length == 0 || p2.length == 0) {
			alert('주민등록 번호를 입력해 주세요.');
			return;
		}

		if ($('#dept').val().length == 0) {
			alert('소속을 입력해 주세요.');
			return;
		}

		if (/\d/.test($('#dept').val())) {
			alert('소속에 숫자를 입력할 수 없습니다.');
			return;
		}

/*		if (/\d/.test($('#bank_name').val())) {
			alert('은행명에 숫자를 입력할 수 없습니다.');
			return;
		}

		if (/[^\d\s]/.test($('#bank_no').val())) {
			alert('계좌번호에 문자를 입력할 수 없습니다.');
			return;
		}*/
		/*if (!flag || (p1 + p2).length !== 13) {
            alert('주민등록번호를 확인해 주세요.');
            return;
        }*/

		/*if ($('#bank_no').val().length == 0) {
            alert('계좌번호를 입력해 주세요.');
            return;
        }*/

		if ($('#addr').val().length == 0) {
			alert('주소를 입력해 주세요.');
			return;
		}

		/*alert("작성하신 평가수당을 확인 하시고 확정/수정 버튼을 눌러주시기 바랍니다.")*/

		createSummaryTable();

		$('input[type="text"]').prop('readonly', true);

		$('#region').prop('disabled', true);

		document.getElementById("nextButton").style.display = "none";
		document.getElementById("modifyButton").style.display = "inline-block";
		document.getElementById("confirmButton").style.display = "inline-block";

		document.getElementById("contentsTemp").style.display = "none";
	}


	function createSummaryTable() {
		// 입력된 값을 변수에 저장
		var evaluationFee = parseInt($('#evaluationFee').val().replace(/,/g, '') || '0', 10);
		var transportFee = parseInt($('#transportFee').text().replace(/[^0-9]/g, '') || '0', 10);
		var totalFee = evaluationFee + transportFee;
		var dept = $('#dept').val() || '';
		var oName = $('#oName').val() || '';
		var addr = $('#addr').val() || '';
		var bankName = $('#bank_name').val() || '';
		var bankNo = $('#bank_no').val() || '';
		var ssn1 = $('#num1').val() || '';
		var ssn2 = $('#num2').val() || '';

		// 테이블 HTML 생성
		var tableHtml = `
        <!--<table border="1" cellspacing="0" cellpadding="0" style='width:580px; border-collapse:collapse; padding-left: 30%;'>
            <tr>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 33%">평가비</td>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 33%">교통비</td>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 33%">합계</td>
            </tr>
            <tr>
                <td style="text-align: right; padding: 10px;" id="evaluationFeeCell"></td>
                <td style="text-align: right; padding: 10px;" id="transportFeeCell"></td>
                <td style="text-align: right; padding: 10px;" id="totalFeeCell"></td>
            </tr>
            <tr>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 33%">소속</td>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 33%">성명</td>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 33%">주소</td>
            </tr>
            <tr>
                <td style="text-align: right; padding: 10px;" id="deptCell"></td>
                <td style="text-align: right; padding: 10px;" id="oNameCell"></td>
                <td style="text-align: right; padding: 10px;" id="addrCell"></td>
            </tr>
            <tr>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 34%">은행명</td>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 34%">계좌번호</td>
                <td style="text-align: center; background-color: #e5e5ff; padding: 10px; width: 34%">주민번호</td>
            </tr>
            <tr>
                <td style="text-align: right; padding: 10px;" id="bankName"></td>
                <td style="text-align: right; padding: 10px;" id="bankNo"></td>
                <td style="text-align: right; padding: 10px;" id="ssn"></td>
            </tr>
        </table>-->
<div class="title-container" style="margin-left: 45%">
    <h1 style="font-size: x-large;">평가수당 지급 확인</h1>
</div>

<div class="modern-table-container">
      <!-- 개인 정보 섹션 -->
      <table class="modern-table">
        <tr>
          <th colspan="4" class="table-title">개인 정보</th>
        </tr>
        <tr>
          <td class="header">성명</td>
          <td class="data" id="oNameCell"></td>
          <td class="header">소속</td>
          <td class="data" id="deptCell"></td>
        </tr>
        <tr>
          <td class="header">주소</td>
          <td class="data" colspan="3" id="addrCell"></td>
        </tr>
        <tr>
          <td class="header">주민번호</td>
          <td class="data" id="ssn"></td>
          <td class="header">연락처</td>
          <td class="data" id="phoneCell"></td>
        </tr>
      </table>

      <!-- 계좌 정보 섹션 -->
      <table class="modern-table">
        <tr>
          <th colspan="4" class="table-title">계좌 정보</th>
        </tr>
        <tr>
          <td class="header">은행명</td>
          <td class="data" id="bankName"></td>
          <td class="header">계좌번호</td>
          <td class="data" id="bankNo"></td>
        </tr>
      </table>

      <!-- 비용 정보 섹션 -->
      <table class="modern-table">
        <tr>
          <th colspan="4" class="table-title">비용 내역</th>
        </tr>
        <tr>
          <td class="header" style="text-align: center">평가비</td>
          <td class="data" id="evaluationFeeCell" style="text-align: right"></td>
          <td class="header" style="text-align: center" >교통비</td>
          <td class="data" id="transportFeeCell" style="text-align: right"></td>
        </tr>
        <tr>
          <td class="header" colspan="2" style="text-align: center">총 합계</td>
          <td class="data total-amount" colspan="2" id="totalFeeCell" style="text-align: right"></td>
        </tr>
      </table>
    </div>
    `;

		// summaryTable 요소가 존재하는지 확인
		var summaryTable = document.getElementById("summaryTable");

		if (summaryTable) {
			summaryTable.innerHTML = tableHtml; // 테이블을 summaryTable에 삽입
			summaryTable.style.display = "block"; // 테이블이 보이도록 설정

			// 각 셀에 값 삽입
			document.getElementById('evaluationFeeCell').innerHTML = evaluationFee.toLocaleString() + ' 원';
			document.getElementById('transportFeeCell').innerHTML = transportFee.toLocaleString() + ' 원';
			document.getElementById('totalFeeCell').innerHTML = totalFee.toLocaleString() + ' 원';
			document.getElementById('deptCell').innerHTML = dept;
			document.getElementById('oNameCell').innerHTML = oName;
			document.getElementById('addrCell').innerHTML = addr;
			document.getElementById('bankName').innerHTML = bankName;
			document.getElementById('bankNo').innerHTML = bankNo;
			document.getElementById('ssn').innerHTML = ssn1 + '-' + ssn2;
		} else {
			console.error("summaryTable 요소를 찾을 수 없습니다.");
		}
	}

	function showNextButton() {
		$('input[type="text"]').prop('readonly', false);

		$('#region').prop('disabled', false);
		$('#oName').prop('readonly', true);
		$('#transportFee').prop('readonly', true);
		$('#totalFee').prop('readonly', true);

		document.getElementById("modifyButton").style.display = "none";
		document.getElementById("confirmButton").style.display = "none";
		document.getElementById("nextButton").style.display = "inline-block";

		document.getElementById("contentsTemp").style.display = "block";
		document.getElementById("summaryTable").style.display = "none";
	}

	/*function confirmEvaluation() {
		if (confirm("이대로 평가수당을 확정시키겠습니까?")) {
			signSaveBtn();
		}
	}*/

	function confirmEvaluation() {
		if (confirm("이대로 평가수당을 확정시키겠습니까?")) {
			var result = true;
			console.log("초기 result 값:", result);

			if ("${userInfo.EVAL_JANG}" == "Y") {
				result = getCommissionerChk2();
				console.log("getCommissionerChk2() 호출 후 result 값:", result);
			}

			if (!result) {
				alert("평가가 진행 중입니다. \n위원장은 모든 평가위원의 평가가 종료 된 후에 저장이 가능합니다.");
				return;
			}

			signSaveBtn();
		}
	}

	function getCommissionerChk2() {
		var commissionerChk = true;
		$.ajax({
			url: "<c:url value='/eval/getCommissionerChk2' />",
			data: {
				committee_seq: '${userInfo.COMMITTEE_SEQ}',
				commissioner_seq: '${userInfo.COMMISSIONER_SEQ}'
			},
			type: 'POST',
			dataType: "json",
			async: false,
			success: function(result) {
				console.log("AJAX 결과:", result);
				commissionerChk = result.commissionerChk;
			},
			error: function(xhr, status, error) {
				console.error("AJAX 오류:", status, error);
				commissionerChk = false;
			}
		});
		return commissionerChk;
	}


	var signHwpFileData = "";
	function signSaveBtn(){
		var p1 = $('#num1').val();
		var p2 = $('#num2').val();
		var flag = isKorJumin(p1, p2);

		/*if (p1.length == 0 || p2.length == 0) {
			alert('주민등록 번호를 입력해 주세요.');
			return;
		}

		if($('#dept').val().length == 0){
			alert('소속을 입력해 주세요.');
			return
		}

		/!*if (!flag || (p1 + p2).length !== 13) {
			alert('주민등록번호를 확인해 주세요.');
			return;
		}*!/

		/!*if($('#bank_no').val().length == 0){
			alert('계좌번호를 입력해 주세요.');
			return
		}*!/

		if($('#addr').val().length == 0){
			alert('주소를 입력해 주세요.');
			return
		}*/
		var title1 = "「${userInfo.TITLE } 사업」평가수당 지급 확인서";

		var ob1 = $('#num1').val() + $('#num2').val();
		var ob2 = $('#dept').val();
		var ob3 = $('#bank_name').val();
		//var ob4 = $('#bank_name option:checked').text();
		var ob5 = $('#bank_no').val();
		var ob6 = $('#addr').val();
		var ob7 = $('#oName').val();
		/*var ob7 = $('#oName').val();*/
        // 평가비 처리 (input value)
        var ob8 = document.getElementById("evaluationFee").value.replace(/[^0-9]/g, '') || "0";
        // 교통비 처리 (span innerText)
        var ob9 = document.getElementById("transportFee").innerText.replace(/[^0-9]/g, '') || "0";
        // 합계 계산
        var ob10 = parseInt(ob8) + parseInt(ob9);


        _hwpPutText("title1", title1);
		_hwpPutText("dept", ob2);
		/*if($("input[name='publicOrProtected']:checked").val() == "Y"){
			_hwpPutText("num", p1 + '-*******');
		}else{
			_hwpPutText("num", '******-*******');
		}*/
		_hwpPutText("oName", ob7);
        _hwpPutText("eval_pay", numberWithCommas(ob8) + '원');
		_hwpPutText("trans_pay", numberWithCommas(ob9) + '원');
		_hwpPutText("total_pay", numberWithCommas(ob10.toString()) + '원');
		_hwpPutText("addr", ob6);
		_hwpPutText("num", ob1);
		//_hwpPutText("bank_name", ob4);
		_hwpPutText("bank_name", ob3);
		_hwpPutText("bank_no", ob5);
		_hwpPutImage("sign", "${userInfo.SIGN_DIR}");

		_pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
			signHwpFileData = data;
		})

		setTimeout(signSave, 600);
	}

	function signSave(){
		var formData = new FormData();
		formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
		formData.append("step", "4");
		formData.append("oName", $('#oName').val());
		formData.append("totalFee", $('#totalFee').text());
		formData.append("birth_date", $('#num').val());
		formData.append("org_name", $('#dept').val());
		formData.append("region", $('#region').val());
		formData.append("bank_name", $('#bank_name').val());
		//formData.append("bank_name", $('#bank_name option:checked').text());
		formData.append("bank_no", $('#bank_no').val());
		formData.append("addr", $('#addr').val());
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
		});
	}

	function setSign(imgData) {
		$('#sign').attr('src', 'data:image/png;base64,' + imgData);
		_hwpPutImage("sign", "C:\\SignData\\Temp.png");
	}

	//한글뷰어
	function hwpView(){
		//로컬 보안 이슈
		// _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
		// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step5";
		// _pHwpCtrl.Open(hwpPath,"HWP");
		//_pHwpCtrl.EditMode = 1;

		var hwpPath = "http://1.233.95.140:58090/upload/evalForm/step5.hwp";
		_hwpOpen(hwpPath, "HWP");

		_pHwpCtrl.EditMode = 0;
		_pHwpCtrl.SetToolBar(1, "TOOLBAR_MENU");
		_pHwpCtrl.SetToolBar(1, "TOOLBAR_STANDARD");
		_pHwpCtrl.ShowRibbon(false);
		_pHwpCtrl.ShowCaret(false);
		_pHwpCtrl.ShowStatusBar(false);
		_pHwpCtrl.SetFieldViewOption(1);

	}

	function _hwpPutData() {
		// 내용
		var title1 = "「${userInfo.TITLE } 사업」평가수당 지급 확인서";
		var title2 = " ◈ (수집·이용목적)「${userInfo.TITLE }」제안 평가비 지급 증빙";
		var title3 = " ◈ (고유식별정보 수집·이용목적)「${userInfo.TITLE } 사업」제안 평가비 지급 증빙을 위한 실명 확인";
		var oName = $('#oName').val();
		var bank_name = "${userInfo.BANK_NAME }";
        var eval_pay = parseInt(document.getElementById("evaluationFee").value.replace(/,/g, ''), 10) || 0; // 평가비 숫자 변환
        var trans_pay = parseInt(document.getElementById("transportFee").innerText.replace(/[^0-9]/g, ''), 10) || 0; // 교통비 숫자 변환
        var total_pay = eval_pay + trans_pay;
		var date = "${nowDate}";

		_hwpPutText("title1", title1);
		//_hwpPutText("toptitle",title1);
		_hwpPutText("title2", title2);
		_hwpPutText("title3", title3);
		_hwpPutText("oName", oName);
		_hwpPutText("date", date);
		_hwpPutText("eval_pay", numberWithCommas(eval_pay) + '원');
		_hwpPutText("trans_pay", numberWithCommas(trans_pay) + '원');
		_hwpPutText("total_pay", numberWithCommas(total_pay) + '원');
		_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

		// 주민등록번호와 계좌번호 추가
		var num1 = $('#num1').val();
		var num2 = $('#num2').val();
		var bank_no = $('#bank_no').val();

		_hwpPutText("num", num1 + "-" + num2);
		_hwpPutText("bank_no", bank_no);

		_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

		$("#signSave").show();
	}

	function numberWithCommas(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}


	function isKorJumin(ssn1, ssn2) {
		var n = 2;
		var sum = 0;

		if(ssn1 == 111111 && ssn2 == 1111111){
			return true
		}

		for (var i = 0; i < ssn1.length; i++) {
			sum += parseInt(ssn1.substr(i, 1)) * n++;
		}
		for (var i = 0; i < ssn2.length - 1; i++) {
			sum += parseInt(ssn2.substr(i, 1)) * n++;
			if (n == 10) {
				n = 2;
			}
		}
		var checkSum = 11 - sum % 11;
		if (checkSum == 11) {
			checkSum = 1;
		}
		if (checkSum == 10) {
			checkSum = 0;
		}
		if (checkSum != parseInt(ssn2.substr(6, 1))) {
			return false;
		}
		return true;
	}

	function htmlToHwp(){
		_pHwpCtrl.MoveToField("contents", true, true, true);
		_pHwpCtrl.PutFieldText("contents", " ");
		_pHwpCtrl.SetTextFile($('#contentsTemp')[0].innerHTML, "HTML", "insertfile");
	}

	function showModalPop(){
		absentModal = $('<div id="absentModal"  style="width:650px; height:200px; margin-top:10px; margin-left:10px; line-height:35px;">' +
				'<span>● 평가위원이 당해 평가 대상과 관련 전년도 1월 1일부터 현재까지 하도급을 포함하여 용역, 자문, 연구 등을 수행한 경우</span><br>'+
				'<span>● 평가위원 또는 소속기관이 당해 평가 대상 용역 시행으로 인하여 이해당사자가 되는 경우(대리관계 포함)</span><br>'+
				'<span>● 평가위원이 당해 평가대상 업체에 재직한 경우</span><br>'+
				'<span>● 그 밖에 제1호부터 제3호까지에 준하는 경우로서 기타 공정한 평가를 수행할 수 없다고 판단하는 경우</span><br>'+
				'</div>');

		absentModal.kendoWindow({
			title: "기피사유",
			visible: false,
			modal: true,
			width : 700,
			height : 250,
			position : {
				top : 200,
				left : 470
			},
			close: function () {
				absentModal.remove();
				evalAvoidPopup();
			}
		});
		absentModal.data("kendoWindow").open();
	}

	function evalAvoidPopup() {
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=350');
	}

	function publicOrProtectedRadio(e){
		if($(e).val() == "Y"){
			$("#num").prop("type", "text");
		}else{
			$("#num").prop("type", "password");
		}
	}

	function signFileDown(){
		$.ajax({
			url : _g_contextPath_+"/eval/makeZipFile?commissioner_seq=${userInfo.COMMISSIONER_SEQ}",
			type : 'get',
		}).success(function(data) {
			if(data.result == "success"){
				var zipUrl = "";
				if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1 || location.host.indexOf("heco") > -1 || location.host.indexOf("1.233.95.140") > -1){
					zipUrl  = "http://1.233.95.140:58090/" + data.zipDir;
				}else{
					zipUrl  = "http://10.10.10.82:80" + data.zipDir;
				}
				var downWin = window.open('','_self');
				downWin.location.href = zipUrl;

				fileDownFlag = true;
			}
		});
	}

	function agreeCheckYn(e) {
		if ($(e).val() == "Y") {
			$("#agree").prop("checked", true);
			$("#disagree").prop("checked", false);
		} else {
			$("#disagree").prop("checked", true);
			$("#agree").prop("checked", false);
			alert("(동의 거부권리 안내) 본 개인정보 수집·이용에 대한 동의를\n거부할 수 있으나, 이 경우 정부 예산회계 처리가 불가하여\n수당지급이 곤란할 수 있습니다.");
		}
	}

	function agreeCheckYn2(e) {
		if ($(e).val() == "Y") {
			$("#agree2").prop("checked", true);
			$("#disagree2").prop("checked", false);
		} else {
			$("#disagree2").prop("checked", true);
			$("#agree2").prop("checked", false);
			alert("(동의 거부권리 안내) 본 개인정보 수집·이용에 대한 동의를\n거부할 수 있으나, 이 경우 정부 예산회계 처리가 불가하여\n수당지급이 곤란할 수 있습니다.");
		}
	}

</script>


<div style="width: 85%;margin: 0 auto;">
	<div id="signSave" style=" width:78%;">
		<%--		<input type="button" onclick="OnConnectDevice();" value="서명하기">--%>
		<c:if test="${userInfo.EVAL_AVOID eq 'N'}">
			<input type="hidden" onclick="showModalPop()" style="background-color: #dee4ea; border-color: black; font-weight : bold; color: red; border-width: thin;" value="기피신청">
		</c:if>
		<input type="button" id="nextButton" onclick="showModifyConfirmButtons();" style="float:right; margin-left:10px; background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
		<input type="button" id="confirmButton" style="float:right; margin-left:10px; background-color: #dee4ea; border-color: black; border-width: thin; display: none;" value="확정" onclick="confirmEvaluation();">
		<input type="button" id="modifyButton" style="float:right; margin-left:10px; background-color: #dee4ea; border-color: black; border-width: thin; display: none;" value="수정" onclick="showNextButton();">
		<%--<input type="button" onclick="signFileDown();" style="float:right;" value="평가자료 다운로드">--%>
	</div>
</div>

<div id="summaryTable" style="display: none; margin-top: 50px;  "></div>

<div id="contentsTemp" style="width: 580px; padding-left: 25%;">
	<TABLE border="1" cellspacing="0" cellpadding="0" style='width:580px; border-collapse:collapse;border:none;'>
		<TR>
			<TD valign="middle" bgcolor="#ffffff"  style='width:580px;height:70px;border-left:none;border-right:none;border-top:none;border-bottom:double #000000 2.0pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS="HStyle0" STYLE="text-align:center;">
					 <SPAN STYLE="font-size:17.0pt;font-weight:bold;line-height:160%">「${userInfo.TITLE} 사업」</SPAN><br>
					 <SPAN STYLE="font-size:17.0pt;font-weight:bold;line-height:160%">평가수당 지급 확인</SPAN>
				</P>
			</TD>
		</TR>
	</TABLE>

	<P CLASS=HStyle0 STYLE='text-align:center;line-height:180%;'></P>

	<TABLE border="1" cellspacing="0" cellpadding="0" style='width:580px; border-collapse:collapse;border:none;'>
		<TR>
			<TD valign="middle" bgcolor="#e5e5ff"  style='width:186px;height:31px;border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;font-family:"한양중고딕,한컴돋움";font-weight:bold;line-height:160%'>평 가 비</SPAN></P>
			</TD>
			<TD valign="middle" bgcolor="#e5e5ff"  style='width:186px;height:31px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;font-family:"한양중고딕,한컴돋움";font-weight:bold;line-height:160%'>교 통 비</SPAN></P>
			</TD>
			<TD valign="middle" bgcolor="#e5e5ff"  style='width:186px;height:31px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;font-family:"한양중고딕,한컴돋움";font-weight:bold;line-height:160%'>합 계</SPAN></P>
			</TD>
			<%--<TD valign="middle" bgcolor="#e5e5ff"  style='width:186px;height:31px;border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
            <P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;font-family:"한양중고딕,한컴돋움";font-weight:bold;line-height:160%'>합&nbsp;&nbsp; 계</SPAN></P>
            </TD>--%>
		</TR>
		<TR>
			<TD valign="middle" style='width:186px;height:31px;border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt; text-align: right;'>
				<input type="text" id="evaluationFee" style="width: 90%; text-align: right; box-sizing: border-box; border: none;" placeholder="평가비를 입력하세요." value="${userInfo.ALLOWANCE}" oninput="updateTotal()" />
				<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>원</SPAN>
			</TD>

			<TD valign="middle" style='width:186px;height:31px;border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt; text-align: right;'>
				<select id="region" style="width: 110px; margin-right: 5px;" onchange="updateTransportFee()">
					<option value="------">회사주소지 선택</option>
					<option value="서울/경기">서울/경기</option>
					<option value="강원영동">강원(영동)</option>
					<option value="강원영서">강원(영서)</option>
					<option value="대전/충청">대전/충청</option>
					<option value="전북">전북</option>
					<option value="광주/전남">광주/전남</option>
					<option value="대구/경북">대구/경북</option>
					<option value="부산/경남">부산/경남</option>
					<option value="제주">제주</option>
				</select>
				<span id="transportFee" style="width: 35%; text-align: right; box-sizing: border-box; border: none;">0 원</span>
			</TD>

			<TD valign="middle" style='width:186px;height:31px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt; text-align: right;'>
				<span id="totalFee" style="width: 90%; text-align: right; box-sizing: border-box;">0 원</span>
			</TD>
		</TR>
	</TABLE></P>
	<P CLASS=HStyle0 STYLE='margin-top:5.0pt;text-align:center;line-height:130%;'></P>

	<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'>
	<P CLASS=HStyle34 style="color:red; font-size: 12px;"> * 농정원 사업담당자 확인 필수</P>
	<TABLE border="1" cellspacing="0" cellpadding="0" style='width:580px; border-collapse:collapse;border:none;'>
		<TR>
			<TD colspan="3" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 소 속 : </SPAN></P>
			</TD>
			<TD colspan="4" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<input type="text" style="width: 275px;" id="dept" value="${userInfo.ORG_NAME }">
			</TD>
		</TR>
		<TR>
			<TD colspan="3" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 성 명 : </SPAN></P>
			</TD>
			<TD colspan="4" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<input type="text" style="width: 275px;" id="oName" value="${userInfo.NAME }" readonly="readonly">
			</TD>
		</TR>
		<TR>
			<TD colspan="3" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 주민등록번호 : </SPAN></P>
			</TD>
			<TD colspan="4" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<input type="text" style="width: 100px;" id="num1" maxlength="6" placeholder="6자리" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
				<span>-</span>
				<input type="text" style="width: 100px;" id="num2" maxlength="7" placeholder="7자리" oninput="this.value = this.value.replace(/[^0-9]/g, '');">
			</TD>
		</TR>
		<TR>
			<TD colspan="3" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 소속기관 주소 : </SPAN></P>
			</TD>
			<TD colspan="4" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>

				<input type="text" style="width: 198px;" id="addr" value="" placeholder="그 외 주소 입력">
			</TD>
		</TR>
		<TR>
			<TD colspan="2" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 은행명 :</SPAN></P>
			</TD>
			<TD colspan="5" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<input type="text" style="width: 275px;" id="bank_name" value="">
				<%--<select id="bank_name">
                    <c:forEach items="${bankList }" var="list">
                        <option value="${list.BANK_CD }" ${userInfo.BANK_NAME == list.BANK_CD ? 'selected="selected"' : '' } >${list.BANK_NM }</option>
                    </c:forEach>
                </select>--%>
			</TD>
		</TR>
		<TR>
			<TD colspan="2" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 계좌번호 : </SPAN></P>
			</TD>
			<TD colspan="5" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<input type="text" style="width: 275px;" id="bank_no" value="${userInfo.BANK_NO }">
			</TD>
		</TR>
		<%--<TR>
            <TD colspan="2" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
            <P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 계좌번호 : </SPAN></P>
            </TD>
            <TD colspan="5" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
            <input type="text" style="width: 275px;" id="bank_no" value="${userInfo.BANK_NO }">
            </TD>
        </TR>--%>
		<TR>
			<TD colspan="7" valign="middle" style='text-align:center; width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>${nowDate }</SPAN></P>
			</TD>
			</TD>
		</TR>
		<TR>
			<TD colspan="4" valign="middle" style='width:250px;height:62px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle0 STYLE='text-align:right;'>&nbsp;</P>
			</TD>
			<TD valign="middle" style='width:91px;height:62px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle0 STYLE='text-align:right;'>성&nbsp; 명 :</P>
			</TD>
			<TD valign="middle" style='width:76px;height:62px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				<P CLASS=HStyle0 STYLE='text-align:center;'>${userInfo.NAME }</P>
			</TD>
			<TD valign="middle" style='width:91px;height:62px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
				(인)
				<span id="signVal"><img alt="(인)" id="sign" src="${userInfo.SIGN_DIR}" style="position: absolute; text-align: center; transform: translate(-46px, -28px);width: 75px; margin-top:5px;"></span>
			</TD>
		</TR>
	</TABLE>


	<TABLE border="1" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
		<TR>
			<TD valign="middle" style='width:84px;height:13px;border-left:none;border-right:none;border-top:none;border-bottom:dotted #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
				<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:3.0pt;font-family:"한양중고딕,한컴돋움";line-height:100%'>&nbsp;</SPAN></P>
			</TD>
			<TD rowspan="2" valign="middle" style='width:399px;height:29px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
				<P CLASS=HStyle0 STYLE='margin-bottom:2.8pt;text-align:center;line-height:100%;'><SPAN STYLE='font-size:12.0pt;font-family:"한양중고딕,한컴돋움";letter-spacing:-15%;font-weight:bold;line-height:100%'>＜</SPAN><SPAN STYLE='font-size:12.0pt;font-family:"한양중고딕,한컴돋움";font-weight:bold;line-height:100%'> 개인정보 및 고유식별정보 수집·이용 동의서</SPAN><SPAN STYLE='font-size:12.0pt;font-family:"한양중고딕,한컴돋움";letter-spacing:-15%;font-weight:bold;line-height:100%'>＞</SPAN></P>
			</TD>
			<TD valign="middle" style='width:81px;height:13px;border-left:none;border-right:none;border-top:none;border-bottom:dotted #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
				<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:1.0pt;font-family:"한양중고딕,한컴돋움";line-height:100%'>&nbsp;</SPAN></P>
			</TD>
		</TR>
		<TR>
			<TD valign="middle" style='width:84px;height:16px;border-left:dotted #000000 0.9pt;border-right:none;border-top:dotted #000000 0.9pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
				<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:1.0pt;font-family:"한양중고딕,한컴돋움";line-height:100%'>&nbsp;</SPAN></P>
			</TD>
			<TD valign="middle" style='width:81px;height:16px;border-left:none;border-right:dotted #000000 0.9pt;border-top:dotted #000000 0.9pt;border-bottom:none;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
				<P CLASS=HStyle0 STYLE='line-height:100%;'><SPAN STYLE='font-size:1.0pt;font-family:"한양중고딕,한컴돋움";line-height:100%'>&nbsp;</SPAN></P>
			</TD>
		</TR>
		<TR>
			<TD colspan="3" valign="middle" style='width:563px;height:257px;border-left:dotted #000000 0.9pt;border-right:dotted #000000 0.9pt;border-top:none;border-bottom:none;padding:2.8pt 2.8pt 2.8pt 2.8pt'>
				<P CLASS=HStyle0 STYLE='margin-top:10.0pt;margin-bottom:2.8pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>★ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";font-weight:bold'>개인정보 수집·이용</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:21.7pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-21.7pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>&nbsp;◈ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-6%'>(수집·이용목적)</SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-3%'>「${userInfo.TITLE }」</SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-8%'>제안 평가비 지급 증빙</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.5pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-29.5pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>&nbsp;◈ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'>(수집항목) 성명, 소속, 주소, 거래 은행명, 계좌번호</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.5pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-29.5pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>&nbsp;◈ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'>(보유·이용기간) 지출 증빙문서 보존기한 완료시까지</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.5pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-29.5pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'>&nbsp;&nbsp;&nbsp; </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:7%'>* </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>근거: 국고금관리법, 공공기록물관리에관한법률 등</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:21.6pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-21.6pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>&nbsp;◈ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-5%'>(동의 거부권리 안내) </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-3%'>본 개인정보 수집·이용에 대한 동의를 거부할 수 있으나,</SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-1%'> 이 경우</SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'> 정부 예산회계 처리가 불가하여 수당지급이 곤란할 수 있습니다.</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.2pt;margin-right:5.0pt;margin-top:10.0pt;text-align:right;text-indent:-29.2pt;line-height:130%;'>
					<%--<SPAN STYLE='font-family:"한양중고딕,한컴돋움";font-weight:bold'>V 동의&nbsp; □ 동의안함</SPAN>--%>
					<input type="checkbox" id="agree" name="agreeCheckYn" value="Y"  onchange="agreeCheckYn(this)" checked><span>동의</span>
					<input type="checkbox" id="disagree" name="agreeCheckYn" value="N"  onchange="agreeCheckYn(this)"><span>동의안함</span>
				</P>
				<P CLASS=HStyle0 STYLE='margin-left:29.2pt;margin-right:5.0pt;margin-top:4.0pt;text-align:right;text-indent:-29.2pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
			</TD>
		</TR>
		<TR>
			<TD colspan="3" valign="middle" style='width:563px;height:142px;border-left:dotted #000000 0.9pt;border-right:dotted #000000 0.9pt;border-top:none;border-bottom:dotted #000000 0.9pt;padding:2.8pt 2.8pt 2.8pt 2.8pt'>
				<P CLASS=HStyle0 STYLE='margin-top:10.0pt;margin-bottom:2.8pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>★ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";font-weight:bold'>고유식별정보 수집·이용</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.5pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-29.5pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>&nbsp;◈ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'>(고유식별정보 수집·이용목적)「${userInfo.TITLE} 사업」제안 평가비 지급 증빙을 위한 실명 확인</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.5pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-29.5pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>&nbsp;◈ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'>(수집 고유식별정보) 주민등록번호</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.5pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-29.5pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>&nbsp;◈ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'>(보유·이용기간) 지출문서 보존기한 완료시까지</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.5pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-29.5pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'>&nbsp;&nbsp; </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:1%'>* </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-1%'>근거: 금융실명거래및비밀보장에관한법률, 공공기록물관리에관한법률 등</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:23.1pt;margin-right:5.0pt;margin-top:4.0pt;text-indent:-23.1pt;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:5%'>&nbsp;◈ </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'>(</SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-3%'>동의 거부권리 안내) </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-1%'>본 고유식별정보 수집·이용에 대한 동의를 거부할 수 </SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-3%'>있으나, 이 경우 D-brain 등 정부 예산회계 처리가</SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움";letter-spacing:-2%'> 불가하여 수당지급이 곤란</SPAN><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>할 수 있습니다.</SPAN></P>
				<P CLASS=HStyle0 STYLE='margin-left:29.2pt;margin-right:5.0pt;margin-top:10.0pt;text-align:right;text-indent:-29.2pt;line-height:130%;'>
					<%--<SPAN STYLE='font-family:"한양중고딕,한컴돋움";font-weight:bold'>V 동의&nbsp; □ 동의안함</SPAN>--%>
					<input type="checkbox" id="agree2" name="agreeCheckYn2" value="Y"  onchange="agreeCheckYn2(this)" checked><span>동의</span>
					<input type="checkbox" id="disagree2" name="agreeCheckYn2" value="N"  onchange="agreeCheckYn2(this)"><span>동의안함</span>
				</P>
			</TD>
		</TR>
	</TABLE>

</div>

<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;display: none"></div>

<script type="text/javascript">
	function updateTransportFee() {
		var region = document.getElementById("region").value;
		var transportFee = 0;

		if (region === "제주") {
			transportFee = 100000;
		} else if (region === "대전/충청" || region === "------") {
			transportFee = 0;
		} else {
			transportFee = 50000;
		}

		document.getElementById("transportFee").innerText = transportFee.toLocaleString() + ' 원';
		updateTotal();
	}

	function updateTotal() {
		var dept = document.getElementById("dept").value;
		var evaluationFeeInput = document.getElementById("evaluationFee");
		var transportFeeSpan = document.getElementById("transportFee");
		var totalFeeSpan = document.getElementById("totalFee");

		// 소속에 따라 값 변경
		if (dept === "농림수산식품교육문화정보원" || dept === "농정원") {
			evaluationFeeInput.value = "-";
			transportFeeSpan.innerText = "-";
			totalFeeSpan.innerText = "-";
		} else {
			var evaluationFee = parseInt(evaluationFeeInput.value.replace(/,/g, '') || 0);
			var transportFee = parseInt(transportFeeSpan.innerText.replace(/[^0-9]/g, '') || 0);
			var totalFee = evaluationFee + transportFee;

			totalFeeSpan.innerText = totalFee.toLocaleString() + ' 원';
		}
	}

	// 소속 변경 시 호출
	document.getElementById("dept").addEventListener("input", function() {
		updateTotal();
	});

	// 지역 변경 시 호출
	document.getElementById("region").addEventListener("change", function() {
		updateTransportFee();
	});
</script>

<%--<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >--%>
<%--</object>--%>
<%--<OBJECT id="HwpCtrl_1" name="_pHwpCtrl" style="display:none; LEFT: 0px; TOP: 100px" height="1300px;" width="900px;" align=center classid=CLSID:BD9C32DE-3155-4691-8972-097D53B10052>--%>
<%--</OBJECT>--%>
