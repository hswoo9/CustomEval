<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년  MM월  dd일" />

<%--<script type="text/javascript" src ="<c:url value='/js/html2canvas.min.js' />"></script>
<script type="text/javascript" src ="<c:url value='/js/es6-promise.auto.js' />"></script>
<script type="text/javascript" src ="<c:url value='/js/jspdf.min.js' />"></script>
<script type="text/javascript" src ="<c:url value='/js/jquery-latest.min.js' />"></script>--%>
<script type="text/javascript" src="<c:url value='/resources/js/html2canvas.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/resources/js/es6-promise.auto.js' />"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jspdf.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jquery-latest.min.js' />"></script>

<style>
    #contentsTemp {
		margin-top : 10px;
		max-width: 100%;
		width: 1000px;
		height: auto;
		overflow: visible;
	}

	/*데스크탑 환경*/
	@media (min-width: 1024px) {
		#contentsTemp {
			width: 1000px;
			font-size: 16px;
		}
	}

	/* 패드 환경 (세로 화면, 작은 화면) */
	@media (max-width: 1024px) and (orientation: portrait) {
		#contentsTemp {
			width: 90%;
			font-size: 12px;
		}
	}

	/*모바일 환경(최소 화면 크기)*/
	@media (max-width: 768px) {
		#contentsTemp {
			width: 100%;
			font-size: 12px;
		}
	}

    th {
        background-color : #8c8c8c;
        color : white;
    }
</style>

<title>위원별 제안서 평가표</title>

<script type="text/javascript">
	window.onload = function() {
		history.pushState(null, null, window.location.href);
		history.pushState(null, null, window.location.href);

		window.addEventListener('popstate', function () {
			history.pushState(null, null, window.location.href);
		});
	};

	var list = JSON.parse('${list}');
	var getCompanyList = JSON.parse('${getCompanyList}');
	var getCompanyRemarkList = JSON.parse('${getCompanyRemarkList}');
	var itemList = JSON.parse('${itemList}');
	var getCompanyTotal = JSON.parse('${companyTotal}');
	var qualitativeGroups = JSON.parse('${qualitativeGroups}');
	var quantitativeGroups = JSON.parse('${quantitativeGroups}');
	console.log("getCompanyTotal",getCompanyTotal);

	var numberOfquality= 0;
	for (var key in qualitativeGroups) {
		if (qualitativeGroups.hasOwnProperty(key)) {
			var group = qualitativeGroups[key];
			numberOfquality += group.length;
		}
	}
	var numberOfquantity = 0;
	for (var key in quantitativeGroups) {
		if (quantitativeGroups.hasOwnProperty(key)) {
			var group = quantitativeGroups[key];
			numberOfquantity += group.length;
		}
	}

/*	console.log("list",list);
	console.log("getCompanyList",getCompanyList);
	console.log("getCompanyRemarkList",getCompanyRemarkList);
	console.log("itemList",itemList);
	console.log("getCompanyTotal",getCompanyTotal);
	console.log("qualitativeGroups",qualitativeGroups);
	console.log("quantitativeGroups",quantitativeGroups);

	console.log("numberOfquality",numberOfquality);
	console.log("numberOfquantity",numberOfquantity);*/

/* 	$(function(){
		alert('"제안평가 위원님은 본인의 평가가 이상이 없는지 확인하시고\n이상이 있으면 수정하여 주시기 바라며,\n저장버튼 클릭후에는 수정이 불가능 합니다"');
	}); */

	var signHwpFileData = "";
	function signSaveBtn(){
		if (confirm('평가확정 이후에는 점수를 수정하실 수 없습니다. 그래도 확정하시겠습니까?')) {
			var result = true;
			if("${userInfo.EVAL_JANG}" == "Y"){
				result = getCommissionerChk();
			}

			if(!result){
				alert("평가가 진행 중입니다.\n위원장은 모든 평가위원의 평가가 종료 된 후에 평가 저장이 가능합니다.");
				return;
			}
			// _pHwpCtrl.GetTextFile("HWPML2X", "", function (data) {
			// 	signHwpFileData = data;
			// })

			const width = window.innerWidth;

			console.log("width",width);

			if (width >= 1024) {
				html2canvas(document.getElementById("contentsTemp"),{
					scale: 2
				}).then(canvas => {
					const imgData = canvas.toDataURL("image/png");
					const pdf = new jsPDF("l", "mm", "a4");

					const pdfWidth = pdf.internal.pageSize.getWidth();
					const pdfHeight = pdf.internal.pageSize.getHeight();
					const imgWidth = canvas.width * 0.2645;
					const imgHeight = canvas.height * 0.2645;

					//캡쳐된 이미지를 0.8배 키워줌
					const scaleFactor = 0.8;

					const scale = Math.min(pdfWidth / imgWidth, pdfHeight / imgHeight) * scaleFactor;
					const imgScaledWidth = imgWidth * scale;
					const imgScaledHeight = imgHeight * scale;

					const xOffset = (pdfWidth - imgScaledWidth) / 2


					pdf.addImage(imgData, "PNG", xOffset, 10, imgScaledWidth, imgScaledHeight);
					//pdf.addImage(imgData, "PNG", 10, 10);
					const pdfBase64 = pdf.output('datauristring');

					signHwpFileData = pdfBase64;
				});

				setTimeout(signSave, 600);

			}else if(width < 1024){

			//pdf
			html2canvas(document.getElementById("contentsTemp"),{
				//scale: 2 * devicePixelRatio,
				scale: window.devicePixelRatio || 1, // 패드의 DPI 기반 스케일 조정
				useCORS: true
			}).then(canvas => {
				const imgData = canvas.toDataURL("image/png");
				const pdf = new jsPDF("l", "mm", "a4");

				const pdfWidth = pdf.internal.pageSize.getWidth();
				const pdfHeight = pdf.internal.pageSize.getHeight();
				const imgWidth = canvas.width * 0.2645;
				const imgHeight = canvas.height * 0.2645;

				const scaleFactor = 0.8;

				const scale = Math.min(pdfWidth / imgWidth, pdfHeight / imgHeight) * scaleFactor;
				const imgScaledWidth = imgWidth * scale;
				const imgScaledHeight = imgHeight * scale;

				const xOffset = (pdfWidth - imgScaledWidth) / 2


				pdf.addImage(imgData, "PNG", xOffset, 10, imgScaledWidth, imgScaledHeight);
				//pdf.addImage(imgData, "PNG", 10, 10);
				const pdfBase64 = pdf.output('datauristring');

				signHwpFileData = pdfBase64;
			});

			setTimeout(signSave, 600);
			//signSave();
			}
		}
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


	function getCommissionerChk(){
		var commissionerChk = true;

		$.ajax({
			url: "<c:url value='/eval/getCommissionerChk' />",
			data : {
				committee_seq : '${userInfo.COMMITTEE_SEQ}',
				commissioner_seq : '${userInfo.COMMISSIONER_SEQ}',
			},
			type : 'POST',
			dataType : "json",
			async : false,
			success: function(result){
				console.log(result);
				commissionerChk = result.commissionerChk;
			}
		});

		return commissionerChk;

		/*$.ajax({
			url: "<c:url value='/eval/evalJangConfirmChk' />",
			data : {evalId : '${userInfo.EVAL_USER_ID}'},
			type : 'POST',
			success: function(result){

				if('${userInfo.EVAL_JANG}' == 'Y'){
					location.reload();
				}else if(result.JANG_CONFIRM_YN == 'Y'){
					location.reload();
				}else{
					alert('평가가 진행 중입니다.');
				}

			}
		}); */

	}

	function setSign(imgData){
		_hwpPutImage("sign", "C:\\SignData\\Temp.png");
	}

	/** TODO. 한글뷰어 수정중 */
	function hwpView(){
		//로컬 보안 이슈
		// _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
		// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step7";
		// _pHwpCtrl.Open(hwpPath,"HWP");51
		var serverPath = "";
		var hostname = window.location.hostname;
		if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("1.233.95.140") > -1){
			serverPath = "http://1.233.95.140:58090/";
		}else{
			serverPath = "http://one.epis.or.kr/"
		}

		// var hwpPath = serverPath + "/upload/evalForm/step7.hwp";
		// _hwpOpen(hwpPath, "HWP");
        //
		// _pHwpCtrl.EditMode = 0;
		// _pHwpCtrl.SetToolBar(1, "TOOLBAR_MENU");
		// _pHwpCtrl.SetToolBar(1, "TOOLBAR_STANDARD");
		// _pHwpCtrl.ShowRibbon(false);
		// _pHwpCtrl.ShowCaret(false);
		// _pHwpCtrl.ShowStatusBar(false);
		// _pHwpCtrl.SetFieldViewOption(1);
	}

	/*function _hwpPutData(){
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

		//setItem();
		//페이지 위로 이동
		_pHwpCtrl.Run("MoveViewUp");

		$("#signSave").show();
	}*/
/*
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

		//셀 병합

		//company
		_pHwpCtrl.MoveToField("company{{"+(getCompanyList.length - 1)+"}}");
		_pHwpCtrl.Run("TableCellBlock");
		_pHwpCtrl.Run("TableCellBlockExtend");
		for (var i = 0; i < 10 - getCompanyList.length; i++) {
			_pHwpCtrl.Run("TableRightCellAppend");
		}
		_pHwpCtrl.Run("TableMergeCell");

		//score
		for (var a = 0; a < list.length + 1; a++) {
			_pHwpCtrl.MoveToField("score_" + getCompanyRemarkList.length);
			_pHwpCtrl.Run("TableCellBlock");
			if (a != 0) {
				for (var l = 1; l < list.length - (list.length - a); l++) {
					_pHwpCtrl.Run("TableLowerCell");
				}
			}
			_pHwpCtrl.Run("TableCellBlockExtend");
			_pHwpCtrl.Run("TableColEnd");

			_pHwpCtrl.Run("TableMergeCell");
		}

		_pHwpCtrl.MoveToField("score_" + (parseInt(getCompanyRemarkList.length) - 1));
		_pHwpCtrl.Run("TableCellBlock");
		_pHwpCtrl.Run("TableCellBlockExtend");

		for (var l = 1; l < itemList.length; l++) {
			_pHwpCtrl.Run("TableLowerCell");
		}
		_pHwpCtrl.Run("TableDistributeCellWidth");


		//total
		_pHwpCtrl.MoveToField("total{{" + (getCompanyRemarkList.length -1 ) + "}}");
		_pHwpCtrl.Run("TableCellBlock");
		_pHwpCtrl.Run("TableCellBlockExtend");
		for (var i = 0; i < 10 - getCompanyRemarkList.length; i++) {
			_pHwpCtrl.Run("TableRightCellAppend");
		}
		_pHwpCtrl.Run("TableMergeCell");

	}*/



	function _hwpPutData(){
		// _pHwpCtrl.MoveToField("contents", true, true, true);
		// _pHwpCtrl.PutFieldText("contents", "\n");

		//var html = '';
		var companyCount = getCompanyTotal.length;
		var maxCompaniesPerTable = 9; // 표 당 최대 9개의 제안업체
		var tableCount = Math.ceil(companyCount / maxCompaniesPerTable); // 필요한 표의 개수 계산

		var html = '';
		for (var t = 0; t < tableCount; t++) {
			var currentCompanyCount = Math.min(companyCount - t * maxCompaniesPerTable, maxCompaniesPerTable); // 현재 표에 들어갈 제안업체 수
			html += '<table style="border:1px solid black; border-collapse: collapse; width: 100%; table-layout: fixed; margin : auto;">';

			html += '<thead>';
			html += '<tr>';
			html += '<th rowspan="2" colspan="3" style="border:1px solid black; border-collapse: collapse; width: 43%; text-align; center;">평가항목</th>';
			html += '<th rowspan="2" style="border:1px solid black; border-collapse: collapse; width: 5%; text-align; center;">배점</th>';
			html += '<th colspan="' + currentCompanyCount + '" style="border:1px solid black; border-collapse: collapse; width: 47%; text-align; center;">제안업체</th>';
			html += '<th rowspan="2" style="border:1px solid black; border-collapse: collapse; width: 5%; text-align; center;">비고</th>';
			html += '</tr>';

			html += '<tr>';
			for (var i = 0; i < currentCompanyCount; i++) {
				html += '<td style="border:1px solid black; border-collapse: collapse; text-align: center; width : ' + (450 / currentCompanyCount) + 'px">' + String.fromCharCode(65 + t * maxCompaniesPerTable + i) + '</td>';
			}
			html += '</tr>';
			html += '</thead>';

			html += '<tbody>';
			html += '<th rowspan="' + numberOfquality + '" style="border:1px solid black;text-align:center; border-collapse: collapse; width: 20px">정성평가</th>';

			// 정성평가 부분
			var qualityGroupArray = [];
			for (var key in qualitativeGroups) {
				if (qualitativeGroups.hasOwnProperty(key)) {
					qualityGroupArray.push(qualitativeGroups[key]);
				}
			}
			for (var i = 0; i < qualityGroupArray.length; i++) {
				var totalScore = 0;
				for (var j = 0; j < qualityGroupArray[i].length; j++) {
					totalScore += qualityGroupArray[i][j].score;
				}
				html += '<td rowspan="' + qualityGroupArray[i].length + '" style="border:1px solid black; width: 150px; border-collapse: collapse; text-align: center;">' + qualityGroupArray[i][0].item_name + '<br>(' + totalScore + '점)</td>';
				for (var j = 0; j < qualityGroupArray[i].length; j++) {
					html += '<td style="border:1px solid black; border-collapse: collapse; width: 250px;">' + qualityGroupArray[i][j].item_medium_name + '</td>';
					html += '<td style="border:1px solid black; border-collapse: collapse; text-align: center;">' + qualityGroupArray[i][j].score + '</td>';
					for (var h = t * maxCompaniesPerTable; h < t * maxCompaniesPerTable + currentCompanyCount; h++) {

						var matchingResultScore = '';
						for (var k = 0; k < list.length; k++) {
							if (list[k].ITEM_SEQ === qualityGroupArray[i][j].item_seq &&
									list[k].EVAL_COMPANY_SEQ === getCompanyTotal[h].EVAL_COMPANY_SEQ) {
								matchingResultScore = totalToFixed(list[k].RESULT_SCORE);
								break;
							}
						}

						html += '<td style="border:1px solid black;text-align:center; border-collapse: collapse;" name="score" it_seq="' + qualityGroupArray[i][j].item_seq + '" data-comp-seq="' + getCompanyTotal[h].EVAL_COMPANY_SEQ + '">' + matchingResultScore + '</td>';
					}
					html += '<td style="border:1px solid black;text-align:center;text-align:center; border-collapse: collapse;"></td>';
					html += '</tr>';
					html += '<tr>';
				}
			}

			// 정량평가 부분
			html += '<th rowspan="' + numberOfquantity + '" style="border:1px solid black; text-align:center;border-collapse: collapse;">정량평가</th>';
			var quantityGroupArray = [];
			for (var key in quantitativeGroups) {
				if (quantitativeGroups.hasOwnProperty(key)) {
					quantityGroupArray.push(quantitativeGroups[key]);
				}
			}
			//상생평가를 배열의 가장 뒤로 보내기
			for (var i = 0; i < quantityGroupArray.length; i++) {
				if (quantityGroupArray[i][0].item_name === "상생기업") {
					var saengsengItem = quantityGroupArray.splice(i, 1)[0];
					quantityGroupArray.push(saengsengItem);
					break;
				}
			}

			for (var i = 0; i < quantityGroupArray.length; i++) {
				var totalScore = 0;
				for (var j = 0; j < quantityGroupArray[i].length; j++) {
					totalScore += quantityGroupArray[i][j].score;
				}
				html += '<td rowspan="' + quantityGroupArray[i].length + '" style="border:1px solid black; border-collapse: collapse; text-align: center;">' + quantityGroupArray[i][0].item_name + '<br>(' + totalScore + '점)</td>';
				for (var j = 0; j < quantityGroupArray[i].length; j++) {
					html += '<td style="border:1px solid black; border-collapse: collapse;">' + quantityGroupArray[i][j].item_medium_name + '</td>';
					html += '<td style="border:1px solid black; border-collapse: collapse; text-align: center;">' + quantityGroupArray[i][j].score + '</td>';
					for (var h = t * maxCompaniesPerTable; h < t * maxCompaniesPerTable + currentCompanyCount; h++) {

						var matchingResultScore = '';
						for (var k = 0; k < list.length; k++) {
							if (list[k].ITEM_SEQ === quantityGroupArray[i][j].item_seq &&
									list[k].EVAL_COMPANY_SEQ === getCompanyTotal[h].EVAL_COMPANY_SEQ) {
								matchingResultScore = totalToFixed(list[k].RESULT_SCORE);
								break;
							}
						}

						html += '<td style="border:1px solid black; border-collapse: collapse;text-align:center;" name="score" it_seq="' + quantityGroupArray[i][j].item_seq + '" data-comp-seq="' + getCompanyTotal[h].EVAL_COMPANY_SEQ + '">' + matchingResultScore + '</td>';
					}
					html += '<td style="border:1px solid black; border-collapse: collapse;text-align:center;"></td>';
					html += '</tr>';
					html += '<tr>';
				}
			}

			// 합계 부분
			html += '<th colspan="3" style="border:1px solid black; border-collapse: collapse;text-align:center;">합계</th>';
			html += '<td style="border:1px solid black; border-collapse: collapse;text-align:center;">100</td>';
			for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
				var totalScoreSum = totalToFixed(getCompanyTotal[i].real_score);
				html += '<td style="border:1px solid black; border-collapse: collapse;text-align:center;">' + totalScoreSum + '</td>';
			}
			html += '<td style="border:1px solid black; border-collapse: collapse;text-align:center;"></td>';
			html += '</tr>';

			// 제안업체 평가의견
			html += '<td rowspan="' + currentCompanyCount + '" style="background-color: #8c8c8c; color: white; border:1px solid black; border-collapse: collapse;text-align:center; height: 27px;">평가의견</td>';
			for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
				html += '<td style="border:1px solid black; border-collapse: collapse; text-align: center;">' + String.fromCharCode(65 + i) + '</td>';
				html += '<td colspan="' + (currentCompanyCount + 3) + '" style="border:1px solid black; border-collapse: collapse; height: 27px; padding: 1px;">' + getCompanyRemarkList[i].remark + '</td>';
				html += '</tr>';
				html += '<tr>';
			}

			html += '</tbody>';
			html += '</table>';
		}


		$("#contentsTemp").append(html);
        $("#signSave").show();


		<%--_pHwpCtrl.SetTextFile($('#contentsTemp').html(), "HTML", "insertfile", function(){--%>

		<%--	var title1 = "${userInfo.TITLE }";--%>
		<%--	var date = "${nowDate}";--%>
		<%--	//var dept = "${userInfo.ORG_NAME }";--%>
		<%--	var name = "";--%>

		<%--	if("${userInfo.EVAL_BLIND_YN}" == "N"){--%>
		<%--		name = "${userInfo.NAME }";--%>
		<%--	}else{--%>
		<%--		name = "${fn:substring(userInfo.NAME, 0, 1)}**";--%>
		<%--	}--%>
		<%--	if(_pHwpCtrl.FieldExist("name" )) {--%>
		<%--		_pHwpCtrl.PutFieldText("name", name);--%>
		<%--	}--%>
		<%--	if(_pHwpCtrl.FieldExist("title1" )){--%>
		<%--		_pHwpCtrl.PutFieldText("title1", title1);--%>
		<%--	}--%>
		<%--	if(_pHwpCtrl.FieldExist("date")){--%>
		<%--		_pHwpCtrl.PutFieldText("date", date);--%>
		<%--	}--%>

		<%--	_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");--%>

		<%--	//$("#contentsTemp").hide();--%>
		<%--})--%>




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
<div style="width: 80%;margin: 0 auto;">
	<div id="signSave">
		<input type="button" onclick="evalAvoidPopup()" style="background-color: #dee4ea; border-color: black; border-width: thin;" value="기피신청">
		<input type="button" onclick="signSaveBtn();" style="float:right; background-color: #dee4ea; border-color: black; border-width: thin; margin-left: 5px;" value="평가확정">
		<input type="button" onclick="evalModBtn();" style="float:right; background-color: #dee4ea; border-color: black; border-width: thin;" value="평가 수정">
	</div>
	<%--<div style="width:100%; padding-bottom: 35px; text-align: center; padding-top: 50px;">
		<h4 style="font-size: 30px;">위원별 제안서 평가표</h4>
	</div>--%>
	<div id="contentsTemp">
		<%--<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>테스트중입니다.</SPAN>--%>
		<%--<c:forEach items="${getCompanyList }" var="companyList" varStatus="mainSt">
			<TABLE style="margin:0 auto">
				<TR>
					<TD colspan="2" valign="bottom" style='width:103px;height:28px;'>
						<P CLASS=HStyle0 STYLE='line-height:180%;'>▣ 제안업체명 :
							<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${companyList.display_title}</SPAN>
						</P>
					</TD>
					<TD colspan="${result[0].list.size()+2}" valign="bottom" style='width:80px;height:28px;'>
						<P CLASS=HStyle0 STYLE='text-align:right;line-height:180%;'>평가일자 :${nowDate} </P>
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" colspan="2" valign="middle" style='width:270px;height:74px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평가항목</SPAN></P>
					</TD>
					<TD colspan="${result[0].list.size() }" valign="middle" style='width:300px;height:28px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평가위원</SPAN></P>
					</TD>
						&lt;%&ndash;					<TD rowspan="2" valign="middle" style='width:40px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>&ndash;%&gt;
						&lt;%&ndash;						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>합계</SPAN></P>&ndash;%&gt;
						&lt;%&ndash;					</TD>&ndash;%&gt;
					<TD rowspan="2" valign="middle" style='width:40px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평균</SPAN></P>
					</TD>
				</TR>
				<!-- 평가위원 이름 -->
				<TR>
					<c:forEach items="${result[0].list }" var="userList">
						<TD valign="middle" style='width: ${300/result[0].list.size()}px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'>
								<c:choose>
									<c:when test="${userInfo.EVAL_BLIND_YN eq 'Y'}">
										<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${fn:substring(userList.NAME, 0, 1)}**</SPAN>
									</c:when>
									<c:otherwise>
										<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${userList.NAME }</SPAN>
									</c:otherwise>
								</c:choose>
							</P>
						</TD>
					</c:forEach>
				</TR>
				<!-- 점수 (아이템)-->
				<c:forEach items="${result[0].colList }" var="itemList" varStatus="colst">
					<c:set var="sss" value="ITME_SCORE_${itemList.item_seq }" />
					<TR>
						<TD valign="middle" style='width:229px;height:30px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:left;line-height:150%;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${itemList.item_name }</SPAN>
							</P>
						</TD>
						<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
									<c:choose>
										<c:when test="${itemList.score == null || itemList.score == 0}">
											-
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${itemList.score}" pattern=".####"/>
										</c:otherwise>
									</c:choose>
								</SPAN>
							</P>
						</TD>

						<c:forEach items="${result[mainSt.index].list }" var="userList" varStatus="st">
							<TD valign="middle" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
								<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'>
									<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
										<c:choose>
											<c:when test="${userList[sss] == null || userList[sss] == 0}">
												-
											</c:when>
											<c:otherwise>
												<fmt:formatNumber value="${userList[sss]}" pattern=".####"/>
											</c:otherwise>
										</c:choose>
									</SPAN>
								</P>
							</TD>
						</c:forEach>

						<TD valign="middle" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
									<c:choose>
										<c:when test="${result[mainSt.index].sumList[mainSt.index][sss] == null || result[mainSt.index].sumList[mainSt.index][sss] == 0}">
											-
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index][sss]}" pattern=".####"/>
										</c:otherwise>
									</c:choose>
								</SPAN>
							</P>
						</TD>
					</TR>
				</c:forEach>
				<!-- 합계 -->
				<TR>
					<TD colspan="2" valign="middle" style='width:128px;height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>합&nbsp; 계 (100점)</SPAN></P>
					</TD>
					<c:forEach items="${result[mainSt.index].list}" var="userList">
						<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
									<c:choose>
										<c:when test="${userList.scoreSum == null}">
											-
										</c:when>
										<c:when test="${userList.scoreSum == 0}">
											-
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${userList.scoreSum}" pattern=".####"/>
										</c:otherwise>
									</c:choose>
								</SPAN>
							</P>
						</TD>
					</c:forEach>
						&lt;%&ndash;					<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>&ndash;%&gt;
						&lt;%&ndash;						<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>&ndash;%&gt;
						&lt;%&ndash;					</TD>&ndash;%&gt;
					<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'><fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index].TOTAL_SUM}" pattern=".####"/></SPAN></P>
					</TD>
				</TR>
				<TR>
					<TD colspan="4" valign="bottom" style='width:103px;height:28px;'>
						<P CLASS=HStyle0 STYLE='line-height:180%;'>* 평가위원이 5인을 초과하는 경우 <b>세부</b>평가항목별 점수의 최고‧최저 점수를 제외</P>
					</TD>
				</TR>
				<TR>
					<TD colspan="4" valign="bottom" style='width:80px;height:28px;'>
						<P CLASS=HStyle0 STYLE='text-align:left;line-height:180%;'>** 소수점 다섯째 자리에서 반올림</P>
					</TD>
				</TR>
			</TABLE>
			<br>
		</c:forEach>--%>

	</div>
<%--	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray; display: none;"></div>--%>
</div>


<script>
    _hwpPutData()
</script>
<%--<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >--%>
<%--</object>--%>
