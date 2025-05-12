<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년  MM월  dd일" />
<%--<script type="text/javascript" src="http://10.10.10.112:8080/js/hwpctrlapp/utils/util.js"></script>
<script type="text/javascript" src="http://10.10.10.112:8080/js/webhwpctrl.js"></script>--%>

<script type="text/javascript" src="<c:url value='/resources/js/html2canvas.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/resources/js/es6-promise.auto.js' />"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jspdf.min.js' />"></script>
<script type="text/javascript" src="<c:url value='/resources/js/jquery-latest.min.js' />"></script>
<script type="text/javascript" src ="<c:url value='/resources/js/big.js' />"></script>


<style>
    #contentsTemp {
        margin-top : 10px;
        max-width: 100%;
        width: 1155px;
        height: auto;
        overflow: visible;
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

    /*th {
        background-color : #8c8c8c;
        color : white;
    }*/

    #thcell {
        background-color : #8c8c8c;
        color : white;
        padding:1.4pt 1.4pt 1.4pt 1.4pt;
    }

    #cell {
        background-color : #8c8c8c;
        color : white;
        padding:1.4pt 1.4pt 1.4pt 1.4pt;
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

    table {
        font-family:"한양중고딕","한컴돋움",sans-serif;
    }

    span.hs {
        font-family:"한양중고딕","한컴돋움",sans-serif;
    }
</style>
<script type="text/javascript" src="<c:url value='/resources/js/common/sweetalert.min.js'/>"></script>

<script type="text/javascript">
    window.onload = function () {
        window.scrollTo(0, 0);
    };

    var result = JSON.parse('${result}');
    var rates = "${userInfo.RATES}" || "";
    var userTitle = "${userInfo.TITLE}" || "";
    var userDate = "${nowDate}";
    var userName = "${userInfo.NAME}" || "";

    var userSign = "${userInfo.SIGN_DIR}" || "";
    var baseURL = window.location.origin;
    if (baseURL.includes("http://one.epis.or.kr")) {
        userSign = userSign.replace("http://10.10.10.114", "http://one.epis.or.kr");
    }

    var qualitativeGroups = JSON.parse('${qualitativeGroups}');
    var quantitativeGroups = JSON.parse('${quantitativeGroups}');
    var comList = result.list;
    var colListArray = JSON.parse('${list}');
    var list = colListArray.colList;

    console.log("result",result);
    console.log("rates",rates);
    console.log("collist",list);
    console.log("result list",comList);

    window.onload = function() {
        history.pushState(null, null, window.location.href);
        history.pushState(null, null, window.location.href);

        window.addEventListener('popstate', function () {
            history.pushState(null, null, window.location.href);
        });
    };

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

    $(function(){
        // 	OnConnectDevice();
        // customAlert('"제안평가위원장은 \"제안서 평가 총괄표\" 및\n\"업체별 제안서 평가집계표\"에 이상이 없는지\n정확히 확인하여 주시기 바라며,\n저장버튼 클릭후에는 수정이 불가능 합니다"', 'success');
    });

    var signHwpFileData = "";
    function signSaveBtn(){

        var checkFlag = true;
        console.log("초기 checkFlag 값:", checkFlag);

        checkFlag = getCommissionerChk2();
        console.log("getCommissionerChk2() 호출 후 checkFlag 값:", checkFlag);

        if (!checkFlag) {
            customAlert("평가가 진행 중입니다. \n위원장은 모든 평가위원의 평가가 종료 된 후에 저장이 가능합니다.", "warning").then(() => {
                console.log("Alert closed, returning from function.");
            });
            return;
        }


        $('#loading_spinner').show();

        const width = window.innerWidth;

        const header = document.getElementById("header");

        var companyCount = comList.length;
        var maxCompaniesPerTable = 10; // 표 당 최대 10개의 제안업체
        var tableCount = Math.ceil(companyCount / maxCompaniesPerTable);

        const pdf = new jsPDF("l", "mm", "a4");
        const pdfWidth = pdf.internal.pageSize.getWidth();
        const pdfHeight = pdf.internal.pageSize.getHeight();


        if (width >= 1024) {
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

                /*processTables(0, tableCount, pdf, imgScaledHeight + 20, () => {
                    const pdfBase64 = pdf.output("datauristring");
                    signHwpFileData = pdfBase64;

                    // 저장 호출
                    setTimeout(signSave, 600);
                });*/

                processTables(0, tableCount, pdf, imgScaledHeight + 20, () => {
                    const pdfBase64 = pdf.output("datauristring");
                    signHwpFileData = pdfBase64;

                    setTimeout(signSave, 600);
                });

            });

        }else if(width < 1024){

            //pdf
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

                /*processTables(0, tableCount, pdf, imgScaledHeight + 20, () => {
                    const pdfBase64 = pdf.output("datauristring");
                    signHwpFileData = pdfBase64;

                    // 저장 호출
                    setTimeout(signSave, 600);
                });*/

                processTables(0, tableCount, pdf, imgScaledHeight + 20, () => {
                    const pdfBase64 = pdf.output("datauristring");
                    signHwpFileData = pdfBase64;

                    setTimeout(signSave, 600);
                });

            });

        }


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
                    offsetY = 30;
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
            pdf.addImage(imgData, "PNG", xOffset, yOffset, imgScaledWidth, imgScaledHeight);

            callback();
        });
    }

    function signSave(){
        var formData = new FormData();
        formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
        formData.append("committee_seq", "${userInfo.COMMITTEE_SEQ}");
        formData.append("join_select_type", "${userInfo.JOIN_SELECT_TYPE}");
        formData.append("purc_req_id", "${userInfo.PURC_REQ_ID}");
        formData.append("proba", rates);
        formData.append("step", "8");
        formData.append("final_yn", "Y");
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
                    $('#loading_spinner').hide();
                    customAlert("문서저장시 오류가 발생했습니다.\n시스템관리자한테 문의 하세요.", "error").then(() => {


                    });
                    return false ;
                } else {
                    location.reload();
                }
            },
            error : function(request, status, error) {
                $('#loading_spinner').hide();
                customAlert("문서저장시 오류가 발생했습니다.\n시스템관리자한테 문의 하세요.", "error").then(() => {

                });
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
        if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("1.233.95.140") > -1){
            serverPath = "http://1.233.95.140:58090/";
        }else{
            serverPath = "http://one.epis.or.kr/"
        }

        // var hwpPath = serverPath + "/upload/evalForm/step9.hwp";
        // _hwpOpen(hwpPath, "HWP");
        //
        // _pHwpCtrl.EditMode = 0;
        // _pHwpCtrl.SetToolBar(1, "TOOLBAR_MENU");
        // _pHwpCtrl.SetToolBar(1, "TOOLBAR_STANDARD");
        // _pHwpCtrl.ShowRibbon(false);
        // _pHwpCtrl.ShowCaret(false);
        // _pHwpCtrl.ShowStatusBar(false);
        // _pHwpCtrl.SetFieldViewOption(1);

        /*_pHwpCtrl.Run("MoveViewUp");
        _pHwpCtrl.Run("MoveViewUp");
        _pHwpCtrl.Run("MoveViewUp");
        _pHwpCtrl.Run("MoveViewUp");
        _pHwpCtrl.Run("MoveViewUp");*/
    }

    /*function _hwpPutData(){
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
	}*/
    function _hwpPutData() {
        // _pHwpCtrl.MoveToField("contents", true, true, true);
        // _pHwpCtrl.PutFieldText("contents", "\n");

        var companyCount = comList.length;
        var maxCompaniesPerTable = 10; // 표 당 최대 10개의 제안업체
        var tableCount = Math.ceil(companyCount / maxCompaniesPerTable); // 필요한 표의 개수 계산

        //정성평가
        var qualityGroupArray = [];
        for (var key in qualitativeGroups) {
            if (qualitativeGroups.hasOwnProperty(key)) {
                for(var item in qualitativeGroups[key]){
                    qualityGroupArray.push(qualitativeGroups[key][item]);
                }
                //qualityGroupArray.push(qualitativeGroups[key]);
            }
        }

        //정량평가
        for (var key in quantitativeGroups) {
            if (quantitativeGroups.hasOwnProperty(key)) {
                for(var item in quantitativeGroups[key]) {
                    qualityGroupArray.push(quantitativeGroups[key][item]);
                }
            }
        }

        var html = '';
        /*html += '<div id="header" style="width:100%; max-width: 100%; padding-bottom: 20px; text-align: center; padding-top: 50px;">';
        html +=	 '<h4 style="font-size: 20px;">제안서 평가 총괄표</h4>';
        html += '<span style="float: left;">▣ 사업명 : '+userTitle+'</span>';
        html += '<span style="float: right;">평가일자 : '+userDate+'</span>';
        html += '<span style="float: right;"></span>';
        html +=  '</div>';*/

        html += '<div id="header" class="header" style="width: 1155px; max-width: 100%; padding-bottom: 5px; text-align: center; padding-top: 50px;">';
        html +=   '<h4 style="font-size: 20px;padding-bottom: 15px;">제안서 평가 총괄표</h4>';
        html +=   '<div style="display: flex; justify-content: space-between; width: 100%;">';
        html +=     '<span>▣ 사업명 : '+userTitle+'</span>';
        html +=     '<span>평가일자 : '+userDate+'</span>';
        html +=   '</div>';
        html += '</div>';

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
                var currentCompanyCount = Math.min(companyCount - t * maxCompaniesPerTable, maxCompaniesPerTable);

                html += '<div class="pdf_page">'
                html += '<table id="contenttable_' + t + '" style="width: 100%; max-width: 100%; margin : 0; margin-bottom: 50px;">';
                html += '<thead>';
                html += '<tr>';
                html += '<th id="thcell" rowspan="2" colspan="3" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 43%; text-align: center;"><p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">평가항목</span></p></th>';
                html += '<th id="thcell" rowspan="2" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 3.5%; text-align: center;"><p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">배점</span></p></th>';
                html += '<th id="thcell" colspan="' + currentCompanyCount + '" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width: 50%; text-align: center; padding-top: 5px; padding-bottom: 5px"><p class="HStyle0" style="text-align:center;line-height:130%;"><span class="hs">제안업체</span></p></th>';
                html += '<th id="thcell" rowspan="2" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; width:5%; text-align: center;"><p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">비고</span></p></th>';
                html += '</tr>';

                html += '<tr>';
                /*for (var i = 0; i < currentCompanyCount; i++) {
                    html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center; width : ' + (510 / currentCompanyCount) + 'px">' + String.fromCharCode(65 + t * maxCompaniesPerTable + i) + '</td>';
                }*/
                for (var i = 0; i < currentCompanyCount; i++) {
                    html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center; "><p class="HStyle0" style="text-align:center;line-height:130%;"><span class="hs">' + String.fromCharCode(65 + t * maxCompaniesPerTable + i) + '</span></p></td>';
                }
                html += '</tr>';
                html += '</thead>';


                html += '<tbody>';
                html += '<th rowspan="' + rowSpan + '" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center; width:3% !important;">정성<br>평가</th>';

                var totalSumMap = {};
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
                            if (list[k].item_seq === qualityGroupArray[i].item_seq) {

                                var itemScoreKey = 'ITME_SCORE_' + qualityGroupArray[i].item_seq;

                                //matchingResultScore = list[k].RESULT_SCORE;
                                for (var key in comList[h]) {
                                    if (key === itemScoreKey) {
                                        matchingResultScore = qksdhffla(comList[h][key]);
                                        break;
                                    }
                                }


                                break;
                            }
                        }

                        if (!totalSumMap['company' + h]) {
                            totalSumMap['company' + h] = new Big(0);
                        }

                        totalSumMap['company' + h] = totalSumMap['company' + h].plus(new Big(Number(matchingResultScore)));

                        html += '<td style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;" name="score" it_seq="' + qualityGroupArray[i].item_seq + '" data-comp-seq="' + comList[h].EVAL_COMPANY_SEQ + '"><p class="HStyle0"><span class="hs">' + matchingResultScore + '</span></p></td>';
                    }
                    html += '<td style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center;text-align:center; "><p class="HStyle0"><span class="hs"></span></p></td>';
                    html += '</tr>';
                    html += '<tr>';
                }

                //합계
                //html += '<tr>';
                html += '<th id="thcell" colspan="3" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs"></span></p>합 계</span></p></th>';
                html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs">100</span></p></td>';

                for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
                    //var totalScore = qksdhffla(comList[i].TOTAL_SUM);
                    var totalScore = totalSumMap['company'+i];
                    html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs">' + totalScore + '</span></p></td>';
                }

                html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs"></span></p></td>';
                html += '</tr>';

                //환산점수
                html += '<tr>';
                html += '<th id="thcell" colspan="4" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center; padding-top: 5px; padding-bottom: 5px"><p class="HStyle0"><span class="hs">환산점수(' + rates + '%)</span></p></th>';
                for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
                    var convertedScore = qksdhffla(comList[i].TOTAL_SUM * (rates / 100));
                    html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs">' + convertedScore + '</span></p></td>';
                }

                html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"></td>';
                html += '</tr>';

                //적격판정
                html += '<tr>';
                html += '<th id="thcell" colspan="4" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center; padding-top: 5px; padding-bottom: 5px"><p class="HStyle0"><span class="hs">적 격 판 정</span></p></th>';
                for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
                    var eligibility = comList[i].TOTAL_SUM >= 85 ? '적격' : '부적격';
                    html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs">' + eligibility + '</span></p></td>';
                }

                html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs"></span></p></td>';
                html += '</tr>';

                //순위
                html += '<tr>';
                html += '<th id="thcell" colspan="4" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center; padding-top: 5px; padding-bottom: 5px"><p class="HStyle0"><span class="hs">순 위</span></p></th>';
                for (var i = t * maxCompaniesPerTable; i < t * maxCompaniesPerTable + currentCompanyCount; i++) {
                    html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"><p class="HStyle0"><span class="hs">' + comList[i].RANK + '</span></p></td>';
                }

                html += '<td id="cell" style="border-left:solid #000000 0.1pt;border-right:solid #000000 0.1pt;border-top:solid #000000 0.1pt;border-bottom:solid #000000 0.1pt;padding:1.4pt 1.4pt 1.4pt 1.4pt; text-align: center;"></td>';
                html += '</tr>';
                html += '<tr>';
                html += '</tbody>';
                html += '</table>';

                /*html += '<div style="margin-top: -50px;text-align: right;">'
                html += '<span>'+ (t+1) +' - '+ (x+1) +'</span>'
                html += '</div>'*/

                html += '<div style="width: 100%; max-width: 100%; text-align: right; margin-bottom: 35px;">';
                html += '<span>성명 : ' + userName + '</span>';
                /*html += '<span style="margin-right: 20px;"></span>';
                html += '<img id="signatureImage" alt="서명 이미지" style="height:40px;"/>';
                html += '</div>';*/
                html += '<div style="display: inline-block; position: relative;">';
                html += '<img src="' + userSign + '" alt="서명 이미지" style="height:40px; position: relative; left: -30px;"/>';
                html += '<span style="position: absolute; top: 38%; left: 25%; transform: translate(-50% , -20%); font-size: 14px;">(인)</span>';
                html += '</div>';
                html += '</div>';

                html += '</div>';
            }

            if(groupDivision > 0){
                firstFlag = false;
            }
        }

        $("#contentsTemp").append(html);


        //한글문서에 채워넣기
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

        <%--	$("#signSave").show();--%>
        <%--	$("#contentsTemp").hide();--%>
        // })
    }
    /*function setItem(){
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
            _hwpPutText("rank{{"+i+"}}", list[i].RANK);
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
    }*/

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
</script>
<div style="width: 80%;margin: 0 auto;">
    <%--<div id="signSave" style="float:right">--%>
    <div id="signSave" >
        <%--		<input type="button" onclick="OnConnectDevice();" value="서명하기">--%>
        <input type="hidden" onclick="evalAvoidPopup()" style="background-color: #dee4ea; border-color: black; font-weight : bold; color: red; border-width: thin;" value="기피신청">
        <input type="button" onclick="signSaveBtn();" style="float:right; margin-left:10px; background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
        <input type="hidden" onclick="reloadBtn();" style="float:right; background-color: #dee4ea; border-color: black; border-width: thin;" value="새로고침">
    </div>


    <%--<p class=a style='margin-top:30px;margin-bottom:3.0pt;margin-left:21pt;text-indent:-15.6pt'><b><span style='font-size:12.0pt;line-height:103%;font-family:"Arial Unicode MS",sans-serif'>□</span></b><b><span style='font-size:12.0pt;line-height:103%'> 제안서 평가 총괄표</span></b></p>
--%>
    <div id="contentsTemp" style=""></div>
    <%--	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;"></div>--%>

</div>

<script>
    _hwpPutData();

    /*var signatureImage = document.getElementById("signatureImage");
    if (userSign) {
        signatureImage.src = userSign;
    } else {
        signatureImage.alt = "서명 이미지가 없습니다.";
    }*/
</script>

