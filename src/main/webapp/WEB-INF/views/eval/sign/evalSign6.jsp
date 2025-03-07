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
		width: 1155px;
		height: auto;
		overflow: visible;
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
	/*데스크탑 환경*/
	@media (min-width: 1024px) {
		#contentsTemp {
			width: 1155px;
			font-size: 13px;
		}
	}

	/* 패드 환경 (세로 화면, 작은 화면) */
	@media (max-width: 1024px) and (orientation: portrait) {
		#contentsTemp {
			width: 1155px;
			font-size: 11px;
		}
	}

	/*모바일 환경(최소 화면 크기)*/
	@media (max-width: 768px) {
		#contentsTemp {
			width: 100%;
			font-size: 11px;
		}
	}

	#thcell {
		background-color : #8c8c8c;
		color : white;
		padding:1.4pt 1.4pt 1.4pt 1.4pt !important;
	}

	#cell {
		background-color : #8c8c8c;
		color : white;
		padding:1.4pt 1.4pt 1.4pt 1.4pt !important;
	}

	table {
		font-family:"한양중고딕","한컴돋움",sans-serif;
		border-collapse: collapse !important;
		border-left:solid #000000 0.05pt !important;
		border-right:solid #000000 0.05pt !important;
		border-top:solid #000000 0.05pt !important;
		border-bottom:solid #000000 0.05pt !important;
	}

	th {
		font-weight: normal !important;
	}



	span.hs {
		font-family:"한양중고딕","한컴돋움",sans-serif;
	}

</style>

<title>위원별 제안서 평가표</title>
<script type="text/javascript" src="<c:url value='/resources/js/common/sweetalert.min.js'/>"></script>

<script type="text/javascript">
	window.onload = function () {
		window.scrollTo(0, 0);
	};

	window.onload = function() {
		history.pushState(null, null, window.location.href);
		history.pushState(null, null, window.location.href);

		window.addEventListener('popstate', function () {
			history.pushState(null, null, window.location.href);
		});
	};


	var list = JSON.parse('${list}');
	var getCompanyList = JSON.parse('${getCompanyList}');
	var userTitle = "${userInfo.TITLE}" || "";
	var userDate = "${nowDate}";
	var userName = "${userInfo.NAME}" || "";

	var userSign = "${userInfo.SIGN_DIR}" || "";
    var baseURL = window.location.origin;
    if (baseURL.includes("http://one.epis.or.kr")) {
        userSign = userSign.replace("http://10.10.10.114", "http://one.epis.or.kr");
    }

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

	function signSaveBtn() {
		customConfirm('평가확정 이후에는 점수를 수정하실 수 없습니다.\n그래도 확정하시겠습니까?', 'warning').then((willConfirm) => {
			if (willConfirm) {
				var result = true;
				if ("${userInfo.EVAL_JANG}" == "Y") {
					result = getCommissionerChk();
				}

				if (!result) {
					customAlert("평가가 진행 중입니다.\n위원장은 모든 평가위원의 평가가 종료 된 후에 평가 저장이 가능합니다.", "warning").then(() => {

					});
					return;
				}

                $('#loading_spinner').show();

				const width = window.innerWidth;
				const header = document.getElementById("header");

				console.log("width", width);

				var companyCount = getCompanyTotal.length;
				var maxCompaniesPerTable = 10; // 표 당 최대 10개의 제안업체
				var tableCount = Math.ceil(companyCount / maxCompaniesPerTable); // 필요한 표의 개수 계산

				const pdf = new jsPDF("l", "mm", "a4");
				const pdfWidth = pdf.internal.pageSize.getWidth();
				const pdfHeight = pdf.internal.pageSize.getHeight();

				html2canvas(header, { scale: 2 }).then(headerCanvas => {
					const imgData = headerCanvas.toDataURL("image/png");
					const imgWidth = headerCanvas.width * 0.2645;
					const imgHeight = headerCanvas.height * 0.2645;
					const scaleFactor = 0.8;

					const scale = Math.min(pdfWidth / imgWidth, pdfHeight / imgHeight) * scaleFactor;
					const imgScaledWidth = imgWidth * scale;
					const imgScaledHeight = imgHeight * scale;

					const xOffset = (pdfWidth - imgScaledWidth) / 2
					const yOffset = 0.5;

					pdf.addImage(imgData, "PNG", xOffset, yOffset, imgScaledWidth, imgScaledHeight);

					processTables(0, tableCount, pdf, imgScaledHeight + 20, () => {
                        captureRemark(pdf, () => {
							const pdfBase64 = pdf.output("datauristring");
							signHwpFileData = pdfBase64;

	                        //pdf.save("test.pdf");
	                        //$('#loading_spinner').hide();
	                        // 저장 호출
	                        setTimeout(signSave, 600);
						});
					});

					/*processTables(0, tableCount, pdf, imgScaledHeight + 20, () => {
						const nameLabel = document.getElementById("nameLabel");
						captureNameLabel(nameLabel, pdf, () => {
							const pdfBase64 = pdf.output("datauristring");
							signHwpFileData = pdfBase64;

                            pdf.save("test.pdf");
                            $('#loading_spinner').hide();
                            // 저장 호출
                            //setTimeout(signSave, 600);
						});
					});*/

				});
			}
		});
	}


	function processTables(index, tableCount, pdf, offsetY, callback) {
        var lists = document.querySelectorAll(".pdf_page");

        const promises = Array.from(lists).map((list, i) => {
            const isLastIteration = (i === lists.length - 1); //마지막 반복

            return html2canvas(list, { scale: 2 }).then(canvas => {
                const imgData = canvas.toDataURL("image/png");

                const pdfWidth = pdf.internal.pageSize.getWidth();
                const pdfHeight = pdf.internal.pageSize.getHeight();
                const imgWidth = canvas.width * 0.2645;
                const imgHeight = canvas.height * 0.2645;

                //캡쳐된 이미지를 0.8배 키워줌
                const scaleFactor = 0.8;

                let scale;
                let imgScaledWidth;
                let imgScaledHeight;

                //const yOffset = 10;

                scale = Math.min(pdfWidth / imgWidth, pdfHeight / imgHeight) * scaleFactor;
                imgScaledWidth = imgWidth * scale;
                imgScaledHeight = imgHeight * scale;

                const xOffset = (pdfWidth - imgScaledWidth) / 2

                if (i === 0) {
                    offsetY = 32;
                } else {
                    if (i > 0) {
                        pdf.addPage(); // 두 번째 테이블부터는 새 페이지에 추가
                        offsetY = 10;  // 새 페이지는 Y 좌표 초기화
                    }
                }

                pdf.addImage(imgData, "PNG", xOffset, offsetY, imgScaledWidth, imgScaledHeight);

            });
        });

        Promise.all(promises).then(() => {
            callback();
        });

	}

	function captureNameLabel(nameLabel, pdf, callback) {
		html2canvas(nameLabel, { scale: 2 }).then(canvas => {
			const imgData = canvas.toDataURL("image/png");
			const imgWidth = canvas.width * 0.2645;
			const imgHeight = canvas.height * 0.2645;

			const pdfWidth = pdf.internal.pageSize.getWidth();
			const pdfHeight = pdf.internal.pageSize.getHeight();
			const scaleFactor = 0.8;

			const scale = Math.min(pdfWidth / imgWidth, pdfHeight / imgHeight) * scaleFactor;
			const imgScaledWidth = imgWidth * scale;
			const imgScaledHeight = imgHeight * scale;

			const xOffset = (pdfWidth - imgScaledWidth) / 2;
			const yOffset = pdfHeight - imgScaledHeight - 10; // 마지막 페이지의 하단에서 약간 위로 조정

			// 현재 페이지 하단에 추가
			//pdf.addImage(imgData, "PNG", xOffset, yOffset, imgScaledWidth, imgScaledHeight);

			callback();
		});
	}

    function captureRemark(pdf, callback) {
        var lists = document.querySelectorAll(".remark_pdf_page");
        var nameLabel = document.querySelectorAll(".nameLabel")[0];

        let signImgData = null;
        let signImgWidth;
        let signImgHeight;


        html2canvas(nameLabel, {scale: 2}).then(canvas => {
            signImgData = canvas.toDataURL("image/png");

            const imgWidth = canvas.width * 0.2645;
            const imgHeight = canvas.height * 0.2645;

            const pdfWidth = pdf.internal.pageSize.getWidth();
            const pdfHeight = pdf.internal.pageSize.getHeight();
            const scaleFactor = 0.8;

            const scale = Math.min(pdfWidth / imgWidth, pdfHeight / imgHeight) * scaleFactor;
            signImgWidth = imgWidth * scale;
            signImgHeight = imgHeight * scale;
        });

        let yOffset;
        let previousImageHeight = 0;

        const promises = Array.from(lists).map((list, i) => {
            return html2canvas(list, {scale: 2}).then(canvas => {
                const isLastIteration = (i === lists.length - 1); //마지막 반복

                const imgData = canvas.toDataURL("image/png");

                const pdfWidth = pdf.internal.pageSize.getWidth();
                const pdfHeight = pdf.internal.pageSize.getHeight();
                const imgWidth = canvas.width * 0.2645;
                const imgHeight = canvas.height * 0.2645;

                const scaleFactor = 0.8;

                const scale = Math.min(pdfWidth / imgWidth, pdfHeight / imgHeight) * scaleFactor;
                const imgScaledWidth = imgWidth * scale;
                const imgScaledHeight = imgHeight * scale;

                const xOffset = (pdfWidth - imgScaledWidth) / 2;

                if (i === 0) {
                    pdf.addPage();
                    yOffset = 0.5;
                } else {
                    if (i > 0) {
                        //pdf.addPage(); // 두 번째 테이블부터는 새 페이지에 추가
                        yOffset += previousImageHeight;
                    }
                }

                if ((yOffset + 30) + imgScaledHeight > pdfHeight) {
                    if (signImgData) {
                        pdf.addImage(signImgData, "PNG", xOffset, yOffset + 5, signImgWidth, signImgHeight); //서명
                    }

                    pdf.addPage();
                    yOffset = 20;
                }

                pdf.addImage(imgData, "PNG", xOffset, yOffset, imgScaledWidth, imgScaledHeight);

                if (isLastIteration && signImgData) {
                    pdf.addImage(signImgData, "PNG", xOffset, yOffset + imgScaledHeight + 5, signImgWidth, signImgHeight);
                }

                previousImageHeight = imgScaledHeight;
            });
        });

        Promise.all(promises).then(() => {
            callback();
        });
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
                $('#loading_spinner').hide();
				/*if(data.result != "success") {
					alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
					return false ;
				} else {
					location.reload();
				}*/

                location.reload();
			},
			error : function(request, status, error) {
                /*$('#loading_spinner').hide();
				alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
				return false ;*/

                location.reload();
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
		var maxCompaniesPerTable = 10; // 표 당 최대 10개의 제안업체
		var tableCount = Math.ceil(companyCount / maxCompaniesPerTable); // 필요한 표의 개수 계산

        // 정성평가 부분
        var qualityGroupArray = [];
        for (var key in qualitativeGroups) {
            if (qualitativeGroups.hasOwnProperty(key)) {
                for(var item in qualitativeGroups[key]){
                    qualityGroupArray.push(qualitativeGroups[key][item]);
                }
                //qualityGroupArray.push(qualitativeGroups[key]);
            }
        }

        for (var key in quantitativeGroups) {
            if (quantitativeGroups.hasOwnProperty(key)) {
                for(var item in quantitativeGroups[key]) {
                    qualityGroupArray.push(quantitativeGroups[key][item]);
                }
            }
        }

		var html = '';
		html += '<div id="header" style="width:100%; max-width: 100%; padding-bottom: 5px; text-align: center; padding-top: 50px;">';
		html +=	 '<h4 style="font-size: 20px;">위원별 제안서 평가표</h4>';
		html += '<p style="text-align: left;">▣ 사업명 : '+userTitle+'</p>';
		html += '<p style="display: flex; justify-content: space-between;">';
		html += '<span>▣ 평가위원명 : '+userName+'</span>';
		html += '<span>평가일자 : '+userDate+'</span>';
		html +=	'</p>';
		html += '</div>';

        console.log(qualityGroupArray);

        var groupLength = qualityGroupArray.length;
        var groupDivision = Math.trunc(groupLength / 12);
        var startIndex = 0;
        var endIndex = 11;
        var rowSpan = 12;
        var firstFlag = true;

        if(groupDivision == 0){
            groupDivision = 1;
        }

        if(groupLength < 13){
            endIndex = (groupLength - 1);
            rowSpan = groupLength;
        }

        for(var x = 0; x < groupDivision; x++) {
            if(x == (groupDivision - 1)){
                rowSpan--;
            }

            if(!firstFlag){
                startIndex = 12;
                endIndex = endIndex + startIndex;
            }

            for (var t = 0; t < tableCount; t++) {
                var currentCompanyCount = Math.min(companyCount - t * maxCompaniesPerTable, maxCompaniesPerTable); // 현재 표에 들어갈 제안업체 수

                html += '<div class="pdf_page">'
                html += '<table id="contenttable_'+t+'" style="width: 100%; max-width: 100%; margin : 0; margin-bottom: 50px;">';
                html += '<thead>';
                html += '<tr>';
                html += '<th id="thcell" rowspan="2" colspan="3" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 43%; text-align: center;"><p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">평가항목</span></p></th>';
                html += '<th id="thcell" rowspan="2" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 3.5%; text-align: center;"><p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">배점</span></p></th>';
                html += '<th id="thcell" colspan="' + currentCompanyCount + '" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 50%; text-align: center;"><p class="HStyle0" style="text-align:center;line-height:130%;"><span class="hs">제안업체</span></p></th>';
                html += '<th id="thcell" rowspan="2" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 5%; text-align: center;"><p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">비고</span></p></th>';
                html += '</tr>';

                html += '<tr>';
                /*for (var i = 0; i < currentCompanyCount; i++) {
					html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center; width : ' + (450 / currentCompanyCount) + 'px">' + String.fromCharCode(65 + t * maxCompaniesPerTable + i) + '</td>';
				}*/
                for (var i = 0; i < currentCompanyCount; i++) {
                    html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0" style="text-align:center;line-height:130%;"><span class="hs">' + String.fromCharCode(65 + t * maxCompaniesPerTable + i) + '</span></p></td>';
                }
                html += '</tr>';
                html += '</thead>';

                html += '<tbody>';
                html += '<th rowspan="' + rowSpan + '" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center; width:3% !important;">정성<br>평가</th>';

                for (var i = startIndex; i <= endIndex; i++) {
                    if(i == endIndex && qualityGroupArray[i].eval_type == '정량평가'){
                        html += '<th style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align:center; width:3% !important;">정량<br>평가</th>';
                    }
                    if(qualityGroupArray[i].row_flag) {
                        html += '<td rowspan="' + qualityGroupArray[i].row_span + '" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 135px;  text-align: center;"><p class="HStyle0"><span class="hs">' + qualityGroupArray[i].item_name + '<br>(' + qualityGroupArray[i].sum_score + '점)</span></p></td>';
                    }

                    html += '<td style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 265px;"><p class="HStyle0" style="text-align:left;line-height:150%;"><span class="hs">' + qualityGroupArray[i].item_medium_name + '</span></p></td>';
                    html += '<td style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0" style="line-height:150%;"><span class="hs">' + qualityGroupArray[i].score + '</span></p></td>';
                    for (var h = t * maxCompaniesPerTable; h < t * maxCompaniesPerTable + currentCompanyCount; h++) {

                        var matchingResultScore = '';
                        for (var k = 0; k < list.length; k++) {
                            if (list[k].ITEM_SEQ === qualityGroupArray[i].item_seq &&
                                list[k].EVAL_COMPANY_SEQ === getCompanyTotal[h].EVAL_COMPANY_SEQ) {
                                matchingResultScore = totalToFixed(list[k].RESULT_SCORE);
                                break;
                            }
                        }

                        html += '<td style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center; " name="score" it_seq="' + qualityGroupArray[i].item_seq + '" data-comp-seq="' + getCompanyTotal[h].EVAL_COMPANY_SEQ + '"><p class="HStyle0"><span class="hs">' + matchingResultScore + '</span></p></td>';
                    }
                    html += '<td style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center;text-align:center; "><p class="HStyle0"><span class="hs"></span></p></td>';
                    html += '</tr>';
                    html += '<tr>';
                }

                // 합계 부분
                html += '<th id="thcell" colspan="3" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center;"><p class="HStyle0"><span class="hs">합계</span></p></th>';
                html += '<td id= "cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center;"><p class="HStyle0"><span class="hs">100</span></p></td>';
                for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
                    var totalScoreSum = totalToFixed(getCompanyTotal[i].real_score);
                    html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center;"><p class="HStyle0"><span class="hs">' + totalScoreSum + '</span></p></td>';
                }
                html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center;"><p class="HStyle0"><span class="hs"></span></p></td>';
                html += '</tr>';

                // 제안업체 평가의견
                /*html += '<td  rowspan="' + currentCompanyCount + '" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center; height: 27px; width:5%;"><p class="HStyle0"><span class="hs">평가<br>의견</span></p></td>';
				for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
					html += '<td style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs">' + String.fromCharCode(65 + i) + '</spam></p></td>';
					html += '<td colspan="' + (currentCompanyCount + 3) + '" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; height: 27px; padding: 1px;"><p class="HStyle0"><span class="hs">' + getCompanyRemarkList[i].remark + '</span></p></td>';
					html += '</tr>';
					html += '<tr>';
				}*/

                html += '</tbody>';
                html += '</table>';

                html += '<div style="margin-top: -50px;text-align: right;">'
                html += '<span>'+ (t+1) +' - '+ (x+1) +'</span>'
                html += '</div>'

                html += '<div class="nameLabel" style="width: 100%; max-width: 100%; text-align: right; margin-bottom: 35px;">';
                html += '<span>성명 : '+userName+'</span>';
                /*html += '<span style="margin-right: 20px;"></span>';
				html += '<img id="signatureImage" alt="서명 이미지" style="height:40px;"/>';
				html += '</div>';*/
                html += '<div style="display: inline-block; position: relative;">';
                html += '<img src="'+ userSign +'" alt="서명 이미지" style="height:40px; position: relative; left: -30px;"/>';
                html += '<span style="position: absolute; top: 38%; left: 25%; transform: translate(-50% , -20%); font-size: 14px;">(인)</span>';
                html += '</div>';
                html += '</div>';

                html += '</div>';

            }

            if(groupDivision > 0){
                firstFlag = false;
            }
        }

        // 제안업체 평가의견
        html += '<div>'
	        html += '<div id="remark" class="remark_pdf_page" style="width:100%; max-width: 100%; padding-bottom: 20px; text-align: center; padding-top: 50px;">';
	        html +=	 '<h4 style="font-size: 20px;">평가의견</h4>';
	        html += '</div>';

	        for (var t = 0; t < 2; t++) {
	            var currentCompanyCount = Math.min(companyCount - t * maxCompaniesPerTable, maxCompaniesPerTable); // 현재 표에 들어갈 제안업체 수
                for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
	                    html += '<table class="remark_pdf_page" style="width: 100%; max-width: 100%; margin : 0;">';
	                    html += '<tbody>';

	                    html += '<tr>';
	                    html += '<td style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center; width: 5%"><p class="HStyle0"><span class="hs">' + String.fromCharCode(65 + i) + '</spam></p></td>';
	                    html += '<td colspan="' + (currentCompanyCount + 3) + '" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; height: 27px; padding: 1px;"><p class="HStyle0"><span class="hs">' + getCompanyRemarkList[i].remark + '</span></p></td>';
	                    html += '</tr>';

	                    html += '</tbody>';
	                    html += '</table>';
                }
            }
        html += '</div>';


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
		<input type="button" onclick="evalAvoidPopup()" style="background-color: #dee4ea; border-color: black; font-weight : bold; color: red; border-width: thin;" value="기피신청">
		<input type="button" onclick="signSaveBtn();" style="float:right; background-color: #dee4ea; border-color: black; border-width: thin; margin-left: 5px;" value="평가확정">
		<input type="button" onclick="evalModBtn();" style="float:right; background-color: #dee4ea; border-color: black; border-width: thin;" value="평가 수정">
	</div>
	<%--<div style="width:100%; padding-bottom: 35px; text-align: center; padding-top: 50px;">
		<h4 style="font-size: 30px;">위원별 제안서 평가표</h4>
	</div>--%>
	<div id="contentsTemp">


	</div>
	<%--	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray; display: none;"></div>--%>
</div>



<script>
	_hwpPutData();

	var signatureImage = document.getElementsByClassName("signatureImage");
	if (userSign) {
		signatureImage.src = userSign;
	} else {
		signatureImage.alt = "서명 이미지가 없습니다.";
	}



</script>
<%--<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >--%>
<%--</object>--%>
