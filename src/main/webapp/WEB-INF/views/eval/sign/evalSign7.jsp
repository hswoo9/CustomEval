<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"
		 import="java.lang.Math" import="java.util.ArrayList" %>
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

<title>업체별 제안서 평가집계표</title>


<style>
    /*@media (pointer:coarse) {
        .th {
            background-color : #8c8c8c !important;
            color : white !important;
        }
    }*/
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
    }

    th {
        font-weight: normal !important;
    }

    span.hs {
        font-family:"한양중고딕","한컴돋움",sans-serif;
    }
</style>
<script type="text/javascript" src="<c:url value='/resources/js/common/sweetalert.min.js'/>"></script>

<script>
    window.onload = function () {
        window.scrollTo(0, 0);
    };

    $(function(){
        //$('.infoTbody').rowspan2(1); //rowspan2 - rowspan 순으로 실행시켜야 원하는 모양으로 나타남.
        /*customAlert('"제안평가위원장은 \"제안서 평가 총괄표\" 및\n\"업체별 제안서 평가집계표\"에 이상이 없는지\n정확히 확인하여 주시기 바라며,\n저장버튼 클릭후에는 수정이 불가능 합니다"', 'success').then(() => {

		});*/
        //$('.infoTbody').rowspan(0);
        //$("#contentsTemp").hide();
    });

    window.onload = function() {
        history.pushState(null, null, window.location.href);
        history.pushState(null, null, window.location.href);

        window.addEventListener('popstate', function () {
            history.pushState(null, null, window.location.href);
        });
    };



    $.fn.rowspan = function(colIdx, isStats) {
        return this.each(function(){
            var that;
            $('tr', this).each(function(row) {
                $('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {

                    if ($(this).html() == $(that).html()
                        && (!isStats
                            || isStats && $(this).prev().html() == $(that).prev().html()
                        )
                    ) {
                        rowspan = $(that).attr("rowspan") || 1;
                        rowspan = Number(rowspan)+1;

                        $(that).attr("rowspan",rowspan);

                        // do your action for the colspan cell here
                        //$(this).hide();

                        $(this).remove();
                        // do your action for the old cell here

                    } else {
                        that = this;
                    }

                    // set the that if not already set
                    that = (that == null) ? this : that;
                });
            });
        });
    };

    $.fn.rowspan2 = function(colIdx, isStats) {
        return this.each(function(){
            var that;
            $('tr', this).each(function(row) {
                $('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {

                    if ($(this).html() == $(that).html()
                        && (!isStats
                            || isStats && $(this).prev().html() == $(that).prev().html()
                        )
                    ) {
                        rowspan = $(that).attr("rowspan") || 1;
                        rowspan = Number(rowspan)+1;

                        $(that).attr("rowspan",rowspan);

                        // do your action for the colspan cell here
                        //$(this).hide();

                        $(this).remove();
                        // do your action for the old cell here

                    } else {
                        that = this;
                    }

                    // set the that if not already set
                    that = (that == null) ? this : that;
                });
            });
        });
    };
</script>


<div style="width: 100%;">
	<div id="signSave" style="">
		<input type="hidden" onclick="evalAvoidPopup()" style="background-color: #dee4ea; border-color: black; font-weight : bold; color: red; border-width: thin;" value="기피신청">
		<input type="button" onclick="signSaveBtn();" style="float:right; margin-left : 10px; background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
		<input type="hidden" onclick="reloadBtn();" style="float:right; background-color: #dee4ea; border-color: black; border-width: thin;"  value="새로고침">
	</div>
	<!--
 	<div style="width:100%; padding-bottom: 35px; text-align: center; padding-top: 50px;">
		<h4 style="font-size: 30px;">업체별 제안서 평가집계표</h4>
	</div>
	-->
	<div id="contentsTemp" >
		
	</div>

<%--	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;/* display : none; */"></div>--%>
</div>

<script type="text/javascript">

    var signHwpFileData = "";
    var signHwpFileDataList = [];
    var getCompanyList = ${getCompanyList};
    var userDate = "${nowDate}";
    var userSign = "${userInfo.SIGN_DIR}" || "";

    const totalDivs = getCompanyList.length;
    let processedDivs = 0;

    var result = JSON.parse('${result}');
    var getCompanyList = JSON.parse('${getCompanyList}');

    var userCount = result[0].list.length;
    var maxUserCount = 11;
    var tableCount = Math.ceil(userCount / maxUserCount);
    var endTableCount = tableCount - 1;

    var colListCount = result[0].colList.length;

    var colIndics = [];
    for (var j = 0; j < colListCount; j++) {
        colIndics.push(j);
    }

    var colListLength = colIndics.length;
    var colListDivision = Math.floor(colListLength / 12);

    function signSaveBtn() {
        $('#loading_spinner').show();

        const divPrefix = "temp_";
        signHwpFileDataList = [];
        processedDivs = 0; // Reset processedDivs

        for (let i = 1; i <= totalDivs; i++) {
            const divId = divPrefix + i;
            const element = document.getElementById(divId);
            console.log("divId : ", divId);

            if (element) {
                const scaleFactor = 2;

                // 각 temp_i에 대해 header와 contenttable_j 처리
                const contentTables = [];
                const contentTableCount = element.getElementsByClassName("infoTbody").length; // temp_i 내의 contenttable 개수

                // header 추가
                const headerId = "header_"+i;
                const header = document.getElementById(headerId); // temp_i의 header

                const pdf = new jsPDF("l", "mm", "a4");

                // header를 첫 페이지에 추가
                if (header) {
                    html2canvas(header, { scale: scaleFactor }).then(canvas => {
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
                        //const xOffset = 10;
                        const yOffset = 0.5;

                        // 첫 번째 페이지에 header 추가
                        pdf.addImage(imgData, "PNG", xOffset, yOffset, imgScaledWidth, imgScaledHeight);
                    });
                }

                // 각 contenttable_j 처리

                for (let j = 1; j <= contentTableCount; j++) {
                    for(let k = 0; k <= colListDivision; k++) {
                        const contentTableId = "contenttable_" + i + "_" + j + "_" + k;
                        const contentTable = document.getElementById(contentTableId); // 예: contenttable_1_1
                        if (contentTable) {
                            contentTables.push(contentTable);
                        }
                    }
                }

                // contentTable을 페이지마다 추가
                contentTables.forEach((contentTable, index) => {
                    html2canvas(contentTable, { scale: scaleFactor }).then(canvas => {
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
                        var yOffset = 10;

                        if (index === 0) {
                            yOffset = 24;
                        } else {
                            if (index > 0) {
                                pdf.addPage(); // 두 번째 테이블부터는 새 페이지에 추가
                                yOffset = 10;  // 새 페이지는 Y 좌표 초기화
                            }
                        }

                        pdf.addImage(imgData, "PNG", xOffset, yOffset, imgScaledWidth, imgScaledHeight);

                        if (index === contentTables.length - 1) {
                            signHwpFileDataList.push(pdf.output("datauristring").split(",")[1]);
                            processedDivs++;

                            if (processedDivs === totalDivs) {
                                /*pdf.save("test.pdf");
								$('#loading_spinner').hide();
	                            return;*/
                                setTimeout(signSave, 600);
                            }
                        }
                    });
                });
            } else {
                processedDivs++;
            }
        }
    }

    function signSave(){
        var formData = new FormData();
        formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
        formData.append("step", "7");

        //console.log("signHwpFileDataList 확인:", signHwpFileDataList);

        for (let j = 0; j < signHwpFileDataList.length; j++) {

            const data = signHwpFileDataList[j];  // 현재 index에 해당하는 데이터

            formData.append("signHwpFileData_"+(j + 1), data);
        }

        //console.log("FormData 내용 확인:");
        /*for (let pair of formData.entries()) {
			console.log(pair[0], ":", pair[1]); // 키와 값 확인
		}*/

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
                    alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
                    return false ;
                } else {
                    location.reload();
                }
            },
            error : function(request, status, error) {
                $('#loading_spinner').hide();
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
        // var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step8";
        // _pHwpCtrl.Open(hwpPath,"HWP");
        // _pHwpCtrl.EditMode = 0;

        var serverPath = "";
        var hostname = window.location.hostname;
        if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("1.233.95.140") > -1){
            serverPath = "http://1.233.95.140:58090/";
        }else{
            serverPath = "http://one.epis.or.kr/"
        }

        // var hwpPath = serverPath + "/upload/evalForm/step8.hwp";
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
        _pHwpCtrl.MoveToField("contents", true, true, true);
        _pHwpCtrl.PutFieldText("contents", "\n");

        _pHwpCtrl.SetTextFile($('#contentsTemp').html(), "HTML", "insertfile", function(){

            var name = "";

            if("${userInfo.EVAL_BLIND_YN}" == "N"){
                name = "${userInfo.NAME }";
            }else{
                name = "${fn:substring(userInfo.NAME, 0, 1)}**";
            }
            if(_pHwpCtrl.FieldExist("name" )) {
                _pHwpCtrl.PutFieldText("name", name);
            }

            _hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

            $("#signSave").show();
        })
    };*/

    function _hwpPutData(){

        var html = '';
        for (var x = 0; x < getCompanyList.length; x++) {
            var companyList = getCompanyList[x];

            html += '<div id="temp_' + (x + 1) + '" style="page-break-after: always;">';



            // 평가자(사용자) 페이지별 테이블 생성
            for (var t = 0; t <= endTableCount; t++) {
                var currentIndex = t;

				var userStartIndex = currentIndex * maxUserCount;
                var currentUserCount = Math.min(userCount - userStartIndex, maxUserCount);
                var adjustedUserCount = currentUserCount + 4;

                // 평가위원 점수 셀들 – 현재 페이지의 평가위원(인덱스: begin ~ end)
                var begin = userStartIndex;
                var end = begin + currentUserCount - 1;

                // 현재 페이지의 평가위원 인덱스 배열 생성
                var indices = [];
                for (var i = 0; i < currentUserCount; i++) {
                    indices.push(begin + i);
                }

                //var colIndicsLength = colIndics.length;

                var startIndex = 0;
                var endIndex = 11;
                var rowSpan = 12;
                var firstFlag = true;

                for (var y = 0; y < colListDivision; y++) {
                    if(y == (colListDivision - 1)){
                        rowSpan--;
                    }

                    if (!firstFlag) {
                        startIndex = 12;
                        endIndex = endIndex + startIndex;
                    }

                    if (firstFlag) {
                        // html += '<tr>';
                        // // html +=   '<td colspan="3" valign="bottom" style="">';
                        // // html +=     '<p class="HStyle0" style="line-height:180%;">▣ 제안업체명 : <span class="hs">' + companyList.display_title + '</span></p>';
                        // // html +=   '</td>';
                        // html +=   '<td colspan="' + (3 + adjustedUserCount) + '" valign="bottom" style="">';
                        // html += '<p style="text-align: left;">▣ 제안업체명 : ' + companyList.display_title + '</p>';
                        // html += '<p style="display: flex; justify-content: space-between;">';
                        // html += '<span>평가일자 : '+userDate+'</span>';
                        // html +=	'</p>';
                        // html +=   '</td>';
                        // html += '</tr>';

                        html += '<div id="header_' + (x + 1) + '" class="header" style="width: 1155px; max-width: 100%; padding-bottom: 5px; text-align: center; padding-top: 50px;">';
                        html +=   '<h4 style="font-size: 20px;padding-bottom: 15px;">업체별 제안서 평가집계표_' + companyList.display_title + '</h4>';
                        html +=   '<div style="display: flex; justify-content: space-between; width: 100%;">';
                        html +=     '<span>▣ 제안업체명 : ' + companyList.display_title + '</span>';
                        html +=     '<span>평가일자 : ' + userDate + '</span>';
                        html +=   '</div>';
                        html += '</div>';


                    }

                    html += '<table id="contenttable_' + (x + 1) + '_' + (t + 1) + '_' + y + '" class="infoTbody" style="margin:0;width:1155px;">';



                    // 평가항목, 배점, 평가위원, 합계, 평균, 비고 헤더 행
                    html += '<tr>';
                    html +=   '<td id="thcell" rowspan="2" colspan="3" valign="middle" style="width:34.5%;border:solid 0.4pt #000000;padding:1.4pt;background-color:#8c8c8c;color:white;">';
                    html +=     '<p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">평가항목</span></p>';
                    html +=   '</td>';
                    html +=   '<td id="thcell" rowspan="2" valign="middle" style="width: 3.5%;border:solid 0.4pt #000000;padding:1.4pt;background-color:#8c8c8c;color:white;">';
                    html +=     '<p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">배점</span></p>';
                    html +=   '</td>';
                    html +=   '<td id="thcell" colspan="' + currentUserCount + '" valign="middle" style="width:51%;border:solid 0.4pt #000000;padding:1.4pt;background-color:#8c8c8c;color:white;">';
                    html +=     '<p class="HStyle0" style="text-align:center;line-height:130%;"><span class="hs">평가위원</span></p>';
                    html +=   '</td>';
                    html +=   '<td id="thcell" rowspan="2" valign="middle" style="width: 3%;border:solid 0.4pt #000000;padding:1.4pt;background-color:#8c8c8c;color:white;">';
                    html +=     '<p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">합계</span></p>';
                    html +=   '</td>';
                    html +=   '<td id="thcell" rowspan="2" valign="middle" style="width: 3%;border:solid 0.4pt #000000;padding:1.4pt;background-color:#8c8c8c;color:white;">';
                    html +=     '<p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">평균</span></p>';
                    html +=   '</td>';
                    html +=   '<td id="thcell" rowspan="2" valign="middle" style="width: 2%;border:solid 0.4pt #000000;padding:1.4pt;background-color:#8c8c8c;color:white;">';
                    html +=     '<p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">비고</span></p>';
                    html +=   '</td>';
                    html += '</tr>';

                    // 평가위원 이름 행
                    html += '<tr>';
                    for (var k = 0; k < indices.length; k++) {
                        var evaluatorName = result[0].list[indices[k]].NAME;
                        if ('${userInfo.EVAL_BLIND_YN}' == 'Y') {
                            evaluatorName = evaluatorName.charAt(0) + '**';
                        }
                        html += '<td valign="middle" style="width:' + (450 / currentUserCount) + 'px;border:solid 0.4pt #000000;padding:1.4pt;background-color:#8c8c8c;color:white;">';
                        html +=   '<p class="HStyle0" style="text-align:center;line-height:130%;">' + evaluatorName + '</p>';
                        html += '</td>';
                    }
                    html += '</tr>';


                    html += '<tr>';
                    // 평가타입
                    html += '<td rowspan="' + rowSpan + '" class="th 정성평가" valign="middle" style="width:3%;border:solid 0.4pt #000000;padding:1.4pt;text-align:center;">정성<br>평가</td>';

                    // 평가항목별 점수 행
                    for (var col = startIndex; col <= endIndex; col++) {
                        var colItem = result[0].colList[col];

                        var sss = 'ITME_SCORE_' + colItem.item_seq;
                        var sss2 = 'ITME_SUM_SCORE_' + colItem.item_seq;
                        var sss3 = colItem.score;
                        var sss3 = colItem.item_name;

                        // 평가항목(대분류)
                        if (colItem.item_name === '상생기업') {
                            html += '<th class="th 정량평가" valign="middle" style="width:3%;border:solid 0.4pt #000000;padding:1.4pt;text-align:center;">정량<br>평가</th>';
                            html += '<td class="' + colItem.eval_type + '" valign="middle" name="item_name" style="border:solid 0.4pt #000000;padding:1.4pt;text-align:center;"><span class="hs">';
                            html +=   colItem.item_name + '<br>(5점)';
                            html += '</span></td>';
                        } else {
                            if(colItem.row_span != 1 && colItem.row_flag == 1) {
                                html += '<td rowspan="' + colItem.row_span + '" class="' + colItem.eval_type + '" valign="middle" name="item_name" style="width:161px;border:solid 0.4pt #000000;padding:1.4pt;text-align:center;"><span class="hs">';
                                html +=   colItem.item_name + '<br>(' + colItem.sum_score + '점)';
                                html += '</span></td>';
                            }else if(colItem.row_span == 1 && colItem.row_flag == 1){
                                html += '<td class="' + colItem.eval_type + '" valign="middle" name="item_name" style="width:161px;border:solid 0.4pt #000000;padding:1.4pt;text-align:center;"><span class="hs">';
                                html +=   colItem.item_name + '<br>(' + colItem.sum_score + '점)';
                                html += '</span></td>';
                            }
                        }

                        // 평가항목 세부 설명 셀
                        html += '<td valign="middle" style="width:265px;border:solid 0.4pt #000000;padding:1.4pt;">';
                        if (colItem.item_name === '상생기업') {
                            html += '<p class="HStyle0" style="text-align:left;line-height:150%;"><span class="hs">상생기업/중소기업/일반기업</span></p>';
                        } else {
                            html += '<p class="HStyle0" style="text-align:left;line-height:150%;"><span class="hs">' + colItem.item_medium_name + '</span></p>';
                        }
                        html += '</td>';

                        // 배점 셀
                        html += '<td valign="middle" name="item_score" style="border:solid 0.4pt #000000;padding:1.4pt;">';
                        html +=   '<p class="HStyle0" style="text-align:center;line-height:150%;">';
                        if (!colItem.score || colItem.score === 0) {
                            html += '<span class="hs">-</span>';
                        } else {
                            html += '<span class="hs">' + totalToFixed(colItem.score) + '</span>';
                        }
                        html +=   '</p>';
                        html += '</td>';

                        // 최대/최소 값 산출 (평가위원이 5명 초과인 경우)
                        var maxValue = 0, minValue = 999;
                        var maxValueStruck = false, minValueStruck = false;
                        if (userCount > 5) {
                            for (var u = 0; u < result[x].list.length; u++) {
                                var scoreAsNumber = Number(result[x].list[u][sss]);
                                if (scoreAsNumber > maxValue) { maxValue = scoreAsNumber; }
                                if (scoreAsNumber < minValue) { minValue = scoreAsNumber; }
                            }
                        }
                        for (var u = begin; u <= end; u++) {
                            html += '<td valign="middle" name="user_score" style="border:solid 0.4pt #000000;padding:1.4pt;">';
                            html +=   '<p class="HStyle0" style="text-align:center;line-height:150%;">';
                            var scoreVal = result[x].list[u][sss];
                            if (!scoreVal || scoreVal == 0) {
                                html += '<span class="hs">-</span>';
                            } else {
                                scoreVal = Number(scoreVal);
                                if (userCount > 5) {
                                    if (scoreVal === maxValue && !maxValueStruck) {
                                        html += '<strike>' + totalToFixed(scoreVal) + '</strike>';
                                        maxValueStruck = true;
                                    } else if (scoreVal === minValue && !minValueStruck) {
                                        html += '<strike>' + totalToFixed(scoreVal) + '</strike>';
                                        minValueStruck = true;
                                    } else {
                                        html += totalToFixed(scoreVal);
                                    }
                                } else {
                                    html += totalToFixed(scoreVal);
                                }
                            }
                            html +=   '</p>';
                            html += '</td>';
                        }

                        // 합계 셀 (개별 항목 합계)
                        html += '<td valign="middle" name="item_sum_score" style="border:solid 0.4pt #000000;padding:1.4pt;">';
                        html +=   '<p class="HStyle0" style="text-align:center;">';
                        var itemSumScore = result[x].sumList[x][sss2];
                        if (!itemSumScore || itemSumScore == 0) {
                            html += '<span class="hs">-</span>';
                        } else {
                            html += totalToFixed(itemSumScore);
                        }
                        html +=   '</p>';
                        html += '</td>';

                        // 평균 셀
                        html += '<td valign="middle" name="item_average" style="border:solid 0.4pt #000000;padding:1.4pt;">';
                        html +=   '<p class="HStyle0" style="text-align:center;">';
                        var itemAverage = result[x].sumList[x][sss];
                        if (!itemAverage || itemAverage == 0) {
                            html += '<span class="hs">-</span>';
                        } else {
                            html += totalToFixed(itemAverage);
                        }
                        html +=   '</p>';
                        html += '</td>';

                        // 비고 셀 (항상 '-' 출력)
                        html += '<td valign="middle" name="item_average" style="border:solid 0.4pt #000000;padding:1.4pt;">';
                        html +=   '<p class="HStyle0" style="text-align:center;">';
                        html +=     '<span class="hs"> - </span>';
                        html +=   '</p>';
                        html += '</td>';

                        html += '</tr>';
                    } // end for (컬럼 반복)

                    // 합계 행 (마지막 행)
                    html += '<tr>';
                    html +=   '<td id="thcell" colspan="3" valign="middle" style="border:solid 0.4pt #000000;padding:1.4pt;background-color:#8c8c8c;color:white;">';
                    html +=     '<p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">합&nbsp; 계</span></p>';
                    html +=   '</td>';
                    html +=   '<td colspan="1" valign="middle" style="border:solid 0.4pt #000000;background-color:#8c8c8c;color:white;padding:1.4pt;">';
                    html +=     '<p class="HStyle0" style="text-align:center;line-height:150%;"><span class="hs">100</span></p>';
                    html +=   '</td>';

                    for (var u = begin; u <= end; u++) {
                        html += '<td valign="middle" style="border:solid 0.4pt #000000;background-color:#8c8c8c;color:white;padding:1.4pt;">';
                        html +=   '<p id="cell" class="HStyle0" style="text-align:center;line-height:150%;">';
                        var scoreSum = result[x].list[u].scoreSum;
                        if (scoreSum == null || scoreSum == 0) {
                            html += '<span class="hs">-</span>';
                        } else {
                            html += totalToFixed(scoreSum);
                        }
                        html +=   '</p>';
                        html += '</td>';
                    }
                    html += '<td valign="middle" style="border:solid 0.4pt #000000;background-color:#8c8c8c;color:white;padding:1.4pt;">';
                    html +=   '<p class="HStyle0" style="text-align:center;"><span class="hs">' + totalToFixed(result[x].sumList[x].TOTAL_ITEM_SUM) + '</span></p>';
                    html += '</td>';
                    html += '<td valign="middle" style="border:solid 0.4pt #000000;background-color:#8c8c8c;color:white;padding:1.4pt;">';
                    html +=   '<p class="HStyle0" style="text-align:center;"><span class="hs">' + totalToFixed(result[x].sumList[x].TOTAL_SUM) + '</span></p>';
                    html += '</td>';
                    html += '<td valign="middle" style="border:solid 0.4pt #000000;background-color:#8c8c8c;color:white;padding:1.4pt;">';
                    html +=   '<p class="HStyle0" style="text-align:center;"><span class="hs"> - </span></p>';
                    html += '</td>';
                    html += '</tr>';

                    // 하단 주석/서명 영역
                    html += '<tr>';
                    html +=   '<td colspan="8" valign="bottom" style="height:28px;">';
                    html +=     '<p class="HStyle0" style="width:105%;max-width:1155px;display:inline-block;margin:0;line-height:180%;">';
                    html +=       '<span>* 평가위원이 5인을 초과하는 경우 세부평가항목별 점수의 최고‧최저 점수를 제외</span>';
                    html +=       '<span style="float:right">'+ (x+1) +' - '+ (y+1) +'</span>';
                    html +=     '</p>';
                    html +=     '<p class="HStyle0" style="line-height:180%;">** 소수점 다섯째 자리에서 반올림</p>';
                    html +=     '<div style="float:right;display:inline-block;position:relative;text-align:right;margin-bottom: 35px;">';
                    html +=       '<img src="'+ userSign +'" = alt="서명 이미지" style="height:40px;position:relative;left:-30px;"/>';
                    html +=       '<span style="position:absolute;top:38%;left:25%;transform:translate(-50%,-20%);font-size:14px;">(인)</span>';
                    html +=     '</div>';
                    html +=   '</td>';
                    html += '</tr>';

                    html += '</table>';

                    firstFlag = false;
                } // end for (col 그룹 반복)
            } // end for (평가위원 반복)

            html += '<hr style="width:100%;text-align:center;"/>';
            html += '</div>';
        } // end for (업체별 반복)

        $("#contentsTemp").append(html);
        $("#signSave").show();


    }

    function reloadBtn(){
        location.reload();
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


<script>
    _hwpPutData()

	/*var signatureImage = document.getElementById("signatureImage");
	if (userSign) {
		signatureImage.src = userSign;
	} else {
		signatureImage.alt = "서명 이미지가 없습니다.";
	}*/


</script>