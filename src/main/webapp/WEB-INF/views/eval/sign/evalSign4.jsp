<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년   MM월   dd일" />

<title>평가수당</title>

<script type="text/javascript">
	var pageCode = 4;
	var fileDownFlag = false;

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

	function fileDownChk(){
		if(fileDownFlag){
			signSaveBtn()
		}else{
			alert("평가자료를 다운로드 해주세요.");
		}
	}

	var signHwpFileData = "";
	function signSaveBtn(){
		var nnn = $('#num').val().replace(/-/gi,"");
		var p1 = nnn.substr(0,6);
		var p2 = nnn.substr(6,7);
		var flag = isKorJumin(nnn.substr(0,6), nnn.substr(6,7));

		if($('#dept').val().length == 0){
			alert('소속을 입력해 주세요.');
			return
		}

		if($('#num').val().length == 0){
			alert('주민등록 번호를 입력해 주세요.');
			return
		}

		if(!flag){
			alert('주민등록번호를 확인해 주세요.');
			return
		}

		if($('#bank_no').val().length == 0){
			alert('계좌번호를 입력해 주세요.');
			return
		}

		if($('#addr').val().length == 0){
			alert('주소를 입력해 주세요.');
			return
		}

		var ob1 = $('#num').val();
		var ob2 = $('#dept').val();
		var ob3 = $('#bank_name').val();
		//var ob4 = $('#bank_name option:checked').text();
		var ob5 = $('#bank_no').val();
		var ob6 = $('#addr').val();
		var ob7 = $('#oName').val();

		_hwpPutText("dept", ob2);
		/*if($("input[name='publicOrProtected']:checked").val() == "Y"){
			_hwpPutText("num", p1 + '-*******');
		}else{
			_hwpPutText("num", '******-*******');
		}*/
		_hwpPutText("addr", ob6);
		//_hwpPutText("bank_name", ob4);
		_hwpPutText("bank_name", ob3);
		_hwpPutText("bank_no", ob5);

		_pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
			signHwpFileData = data;
		})

		setTimeout(signSave, 600);
	}

	function signSave(){
		var formData = new FormData();
		formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
		formData.append("step", "4");
		formData.append("birth_date", $('#num').val());
		formData.append("org_name", $('#dept').val());
		//formData.append("bank_cd", $('#bank_name').val());
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
		})
	}

	function setSign(imgData){
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

		var hwpPath = "http://121.186.165.80:8010/upload/evalForm/step5.hwp";
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
		var title1 = "「${userInfo.TITLE } 사업」평가수당 지급 확인서";
		var title2 = " ◈ (수집·이용목적)「${userInfo.TITLE }」제안 평가비 지급 증빙";
		var title3 = " ◈ (고유식별정보 수집·이용목적)「${userInfo.TITLE } 사업」제안 평가비 지급 증빙을 위한 실명 확인";
		var name = "${userInfo.NAME }";
	// 	var dept = "${userInfo.ORG_NAME }";
	// 	var num = "${userInfo.BIRTH_DATE }";
	// 	var addr = "${userInfo.ORG_ADDR1 } ${userInfo.ORG_ADDR2 }";
	// 	var bank_name = "${userInfo.BANK_NAME }";
		var bank_no = "${userInfo.BANK_NO }";
		var eval_pay = "${userInfo.EVAL_PAY }";
		var trans_pay = "${userInfo.TRANS_PAY }";
		var total_pay = Number(eval_pay) + Number(trans_pay);
		var date = "${nowDate}";

		_hwpPutText("title1", title1);
		_hwpPutText("title2", title2);
		_hwpPutText("title3", title2);
		_hwpPutText("name", name);
		_hwpPutText("date", date);
	// 	_hwpPutText("dept", dept);
	// 	_hwpPutText("num", num);
	// 	_hwpPutText("addr", addr);
	// 	_hwpPutText("bank_name", bank_name);
	// 	_hwpPutText("bank_no", bank_no);
		_hwpPutText("eval_pay", numberWithCommas(eval_pay) + '원');
		_hwpPutText("trans_pay", numberWithCommas(trans_pay) + '원');
		_hwpPutText("total_pay", numberWithCommas(total_pay) + '원');

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
				if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1 || location.host.indexOf("heco") > -1 || location.host.indexOf("121.186.165.80") > -1){
					zipUrl  = "http://121.186.165.80:8010" + data.zipDir;
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


<div style="width: 40%;margin: 0 auto;">
	<div id="signSave" style="display: none;">
<%--		<input type="button" onclick="OnConnectDevice();" value="서명하기">--%>
		<input type="button" onclick="showModalPop()" value="기피신청">
		<input type="button" onclick="fileDownChk();" value="저장">
		<input type="button" onclick="signFileDown();" value="평가자료 다운로드">
	</div>
</div>


<div id="contentsTemp" style="width: 580px; padding-left: 30%;">
	<TABLE border="1" cellspacing="0" cellpadding="0" style='width:580px; border-collapse:collapse;border:none;'>
	<TR>
		<TD valign="middle" bgcolor="#ffffff"  style='width:580px;height:70px;border-left:none;border-right:none;border-top:none;border-bottom:double #000000 2.0pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:17.0pt;font-weight:bold;line-height:160%'>「${userInfo.TITLE } 사업」평가수당 지급 확인서</SPAN></P>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:17.0pt;font-weight:bold;line-height:160%'>평가수당 지급 확인서</SPAN></P>
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
		<%--<TD valign="middle" bgcolor="#e5e5ff"  style='width:186px;height:31px;border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 1.1pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-size:12.0pt;font-family:"한양중고딕,한컴돋움";font-weight:bold;line-height:160%'>합&nbsp;&nbsp; 계</SPAN></P>
		</TD>--%>
	</TR>
	<TR>
		<TD valign="middle" style='width:186px;height:31px;border-left:solid #000000 1.1pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
		<P CLASS=HStyle0 STYLE='margin-right:5.0pt;text-align:right;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'><fmt:formatNumber type="number" maxFractionDigits="3" value="${userInfo.EVAL_PAY }" />원</SPAN></P>
		</TD>
		<TD valign="middle" style='width:186px;height:31px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
			<P CLASS=HStyle0 STYLE='margin-right:5.0pt;text-align:right;'>
			<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
				내부 규정에 따름
<%--				<fmt:formatNumber type="number" maxFractionDigits="3" value="${userInfo.TRANS_PAY }" />원--%>
			</SPAN>
			</P>
		</TD>
		<%--<TD valign="middle" style='width:186px;height:31px;border-left:solid #000000 0.4pt;border-right:solid #000000 1.1pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 1.1pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
		<P CLASS=HStyle0 STYLE='margin-right:5.0pt;text-align:right;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>내부 규정에 따름</SPAN></P>
		</TD>--%>
	</TR>
	</TABLE></P>
	<P CLASS=HStyle0 STYLE='margin-top:5.0pt;text-align:center;line-height:130%;'></P>
	
	<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'>
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
			<input type="text" style="width: 275px;" id="num" value="${userInfo.BIRTH_DATE }">
			<%--<input type="radio" id="open" name="publicOrProtected" value="Y" onchange="publicOrProtectedRadio(this)" checked>공개
			<input type="radio" id="private" name="publicOrProtected" value="N" onchange="publicOrProtectedRadio(this)">비공개--%>
		</TD>
	</TR>
	<TR>
		<TD colspan="3" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
		<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 소속기관 주소 : </SPAN></P>
		</TD>
		<TD colspan="4" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
		<input type="text" style="width: 275px;" id="addr" value="${userInfo.ORG_ADDR1 } ${userInfo.ORG_ADDR2 }">
		</TD>
	</TR>
	<TR>
		<TD colspan="2" valign="middle" style='width:163px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
		<P CLASS=HStyle34 STYLE='margin-top:3.0pt;line-height:160%;'><SPAN STYLE='font-size:11.0pt;font-family:"휴먼명조";line-height:160%'>○ 은행명: </SPAN></P>
		</TD>
		<TD colspan="5" valign="middle" style='width:417px;height:22px;border-left:none;border-right:none;border-top:none;border-bottom:none;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
			<input type="text" style="width: 275px;" id="bank_name" value="${userInfo.BANK_NAME}">
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
			<span id="signVal"><img alt="(인)" id="sign" src="${userInfo.SIGN_DIR}" style="position: absolute; text-align: center; transform: translate(-46px, -28px);width: 76px"></span>
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



<%--<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >--%>
<%--</object>--%>
<%--<OBJECT id="HwpCtrl_1" name="_pHwpCtrl" style="display:none; LEFT: 0px; TOP: 100px" height="1300px;" width="900px;" align=center classid=CLSID:BD9C32DE-3155-4691-8972-097D53B10052>--%>
<%--</OBJECT>--%>

