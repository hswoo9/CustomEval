var sTop = document.all;

function FastCalSelClick(SelectType) {
    var y, m, d, yy, mm, dd;

    if ((SelectType == "29") || (SelectType == "30"))
        y = eval('sTop.HidDateType' + SelectType + '.value.substring(0,4)');
    else
        y = sTop.ddl_FaxSendResult_Year.value;

    m = eval('sTop.HidDateType' + SelectType + '.value.substring(4,6)');
    d = eval('sTop.HidDateType' + SelectType + '.value.substring(6,8)');

    if ((SelectType == "29") || (SelectType == "30"))
        yy = eval('sTop.HidDateType' + SelectType + '.value.substring(8,12)');
    else
        yy = sTop.ddl_FaxSendResult_Year.value;

    mm = eval('sTop.HidDateType' + SelectType + '.value.substring(12,14)');
    dd = eval('sTop.HidDateType' + SelectType + '.value.substring(14,16)');

    sTop.tBox_FaxSendResult_Begin_Year.value = y;
    sTop.tBox_FaxSendResult_Begin_Month.value = m;
    sTop.tBox_FaxSendResult_Begin_Day.value = d;

    sTop.tBox_FaxSendResult_End_Year.value = yy;
    sTop.tBox_FaxSendResult_End_Month.value = mm;
    sTop.tBox_FaxSendResult_End_Day.value = dd;

    sTop.HidBeginDate.value = y + m + d;
    sTop.HidEndDate.value = yy + mm + dd;
}

function FaxSendResultViewClick() {
    if (sTop.tBox_FaxSendResult_Begin_Year.value.length != 4) {
        alert("검색일자(년)을 선택해 주세요.");
        return false;
    }
    if (sTop.tBox_FaxSendResult_Begin_Month.value.length != 2) {
        alert("검색일자(월)을 입력해 주세요.\n\n입력 예) 04, 12");
        return false;
    }
    if (!IsNumber(sTop.tBox_FaxSendResult_Begin_Month.value)) {
        alert("검색일자(월)을 잘못 입력 했습니다.");
        return false;
    }
    if (sTop.tBox_FaxSendResult_Begin_Day.value.length != 2) {
        alert("검색일자(일)을 입력해 주세요.\n\n입력 예) 04, 12, 31");
        return false;
    }
    if (!IsNumber(sTop.tBox_FaxSendResult_Begin_Day.value)) {
        alert("검색일자(일)을 잘못 입력 했습니다.");
        return false;
    }
    if (sTop.tBox_FaxSendResult_End_Year.value.length != 4) {
        alert("검색일자(년)을 선택해 주세요.");
        return false;
    }
    if (sTop.tBox_FaxSendResult_End_Month.value.length != 2) {
        alert("검색일자(월)을 입력해 주세요.\n\n입력 예) 04, 12");
        return false;
    }
    if (!IsNumber(sTop.tBox_FaxSendResult_End_Month.value)) {
        alert("검색일자(월)을 잘못 입력 했습니다.");
        return false;
    }
    if (sTop.tBox_FaxSendResult_End_Day.value.length != 2) {
        alert("검색일자(일)을 입력해 주세요.\n\n입력 예) 04, 12, 31");
        return false;
    }
    if (!IsNumber(sTop.tBox_FaxSendResult_End_Day.value)) {
        alert("검색일자(일)을 잘못 입력 했습니다.");
        return false;
    }
    if (parseInt(sTop.tBox_FaxSendResult_Begin_Year.value + sTop.tBox_FaxSendResult_Begin_Month.value + sTop.tBox_FaxSendResult_Begin_Day.value) > parseInt(sTop.tBox_FaxSendResult_End_Year.value + sTop.tBox_FaxSendResult_End_Month.value + sTop.tBox_FaxSendResult_End_Day.value)) {
        alert("검색시작일자가 검색종료일자 보다 클 수 없습니다.");
        return false;
    }

    var StartDate;
    var EndDate;

    StartDate = sTop.tBox_FaxSendResult_Begin_Year.value + sTop.tBox_FaxSendResult_Begin_Month.value;
    EndDate = sTop.tBox_FaxSendResult_End_Year.value + sTop.tBox_FaxSendResult_End_Month.value;

    if (parseInt(sTop.HidBindStartDate.value) > parseInt(StartDate)) {
        alert("최근 1년 이내만 조회 할 수 있습니다. 검색시작일자를 1년 이내로 수정해 주세요.");
        return false;
    }

    if (parseInt(sTop.HidBindEndDate.value) < parseInt(EndDate)) {
        alert("검색종료일자가 이번달을 초과 할 수 없습니다.");
        return false;
    }

    return true;

}

function FaxSendResultFaxView(FaxFile, ServiceType) {
   
    document.FilePreviewFrame.location.href = "FaxFilePreview.aspx?PathName=&FileName=" + FaxFile + "&ServiceType=" + ServiceType + "&IsFaxSaveBox=true";
}

function FaxSendResultExcel() {
    var sUrl;
    var BeginDate, EndDate, SearchType, SearchValue, SearchType;

    if (sTop.tBox_FaxSendResult_Begin_Year.value.length != 4) {
        alert("검색일자(년)을 4자리로 입력해 주세요.");
        sTop.tBox_FaxSendResult_Begin_Year.focus();
        return false;
    }
    if (sTop.tBox_FaxSendResult_Begin_Month.value.length != 2) {
        alert("검색일자(월)을 입력해 주세요.\n\n입력 예) 04, 12");
        sTop.tBox_FaxSendResult_Begin_Month.focus();
        return false;
    }
    if (sTop.tBox_FaxSendResult_Begin_Day.value.length != 2) {
        alert("검색일자(일)을 입력해 주세요.\n\n입력 예) 04, 12, 31");
        sTop.tBox_FaxSendResult_Begin_Day.focus();
        return false;
    }
    if (sTop.tBox_FaxSendResult_End_Year.value.length != 4) {
        alert("검색일자(년)을 4자리로 입력해 주세요.");
        sTop.tBox_FaxSendResult_End_Year.focus();
        return false;
    }
    if (sTop.tBox_FaxSendResult_End_Month.value.length != 2) {
        alert("검색일자(월)을 입력해 주세요.\n\n입력 예) 04, 12");
        sTop.tBox_FaxSendResult_End_Month.focus();
        return false;
    }
    if (sTop.tBox_FaxSendResult_End_Day.value.length != 2) {
        alert("검색일자(일)을 입력해 주세요.\n\n입력 예) 04, 12, 31");
        sTop.tBox_FaxSendResult_End_Day.focus();
        return false;
    }

    BeginDate = sTop.tBox_FaxSendResult_Begin_Year.value + sTop.tBox_FaxSendResult_Begin_Month.value + sTop.tBox_FaxSendResult_Begin_Day.value;
    EndDate = sTop.tBox_FaxSendResult_End_Year.value + sTop.tBox_FaxSendResult_End_Month.value + sTop.tBox_FaxSendResult_End_Day.value;
    SearchType = sTop.ddl_FaxSendResult_SearchType.value;
    SearchValue = sTop.tBox_FaxSendResult_SearchValue.value;

    if ((BeginDate.length != 8) && (EndDate.length != 8)) {
        alert("팩스전송결과를 먼저 조회해 주세요.");
        return false;
    }

    sUrl = "FaxSendResultExcel.aspx?BeginDate=" + BeginDate + "&EndDate=" + EndDate + "&SearchType=" + SearchType + "&SearchValue=" + escape(SearchValue);
    FaxSendResultExcelFrame.location.href = sUrl;

    return false;
}

function FaxSendResultSelectDataRemove() {
    var conf;
    var sUrl;
    var strFaxKey = "";


    var BeginDate, EndDate, SearchType, SearchValue, ListCount;

    BeginDate = sTop.HidBeginDate.value;
    EndDate = sTop.HidEndDate.value;
    SearchType = sTop.ddl_FaxSendResult_SearchType.value;
    SearchValue = sTop.tBox_FaxSendResult_SearchValue.value;
    ListCount = sTop.ddl_FaxSendResult_ListCount.value;

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if (sTop.item(i).checked) {
                if (sTop.item(i).id != "cBox_FaxSendResultAllCheck") {
                    if (strFaxKey.length > 0)
                        strFaxKey += ";" + sTop.item(i).id;
                    else
                        strFaxKey = sTop.item(i).id;
                }
            }
        }
    }

    strFaxKey = Replace(strFaxKey, "FaxSendResult_", "");

    if (strFaxKey == "") {
        alert("삭제할 팩스문서를 선택해 주세요.");
        return false;
    }

    conf = confirm("삭제된 팩스는 복구가 불가하오니 꼭 \"엑셀파일저장\"으로 백업 후 삭제하시기 바랍니다.\n\n선택한 팩스문서를 삭제 하시겠습니까?");
    if (conf) {
        document.form1.pst_HidRemoveType.value = "SelectData";
        document.form1.pst_HidSelectFaxKeys.value = strFaxKey;
        document.form1.pst_HidBeginDate.value = BeginDate;
        document.form1.pst_HidEndDate.value = EndDate;
        document.form1.pst_HidSearchType.value = SearchType;
        document.form1.pst_HidSearchValue.value = SearchValue;
        document.form1.pst_HidListCount.value = ListCount;
        document.form1.target = "FaxSendResultDataRemoveFrame";
        document.form1.action = "FaxSendResultRemove.aspx";
        document.form1.method = "post";
        document.form1.submit();
    }
}

function FaxSendResultDataRemove() {
    var conf;
    var sUrl;
    var BeginDate, EndDate, SearchType, SearchValue;

    BeginDate = sTop.HidBeginDate.value;
    EndDate = sTop.HidEndDate.value;
    SearchType = sTop.ddl_FaxSendResult_SearchType.value;
    SearchValue = sTop.tBox_FaxSendResult_SearchValue.value;

    if ((BeginDate.length != 8) && (EndDate.length != 8)) {
        alert("팩스전송결과를 먼저 조회해 주세요.");
        return false;
    }

    conf = confirm("삭제된 팩스는 복구가 불가하오니 꼭 \"엑셀파일저장\"으로 백업 후 삭제하시기 바랍니다.\n\n조회된 전체 팩스문서를 삭제 하시겠습니까?");
    if (conf) {
        document.form1.pst_HidRemoveType.value = "AllData";
        document.form1.pst_HidBeginDate.value = BeginDate;
        document.form1.pst_HidEndDate.value = EndDate;
        document.form1.pst_HidSearchType.value = SearchType;
        document.form1.pst_HidSearchValue.value = SearchValue;
        document.form1.target = "FaxSendResultDataRemoveFrame";
        document.form1.action = "FaxSendResultRemove.aspx";
        document.form1.method = "post";
        document.form1.submit();
    }

    return false;
}

function FaxSendStatusHelpMsgOpen() {
    var DivFaxSendStatusHelpMsg = document.getElementById("Div_FaxSendStatusHelpMsg");

    if (DivFaxSendStatusHelpMsg.style.visibility == "hidden") {
        var tBoxPos = getBounds(document.getElementById("faxsendresult_list06"));

        DivFaxSendStatusHelpMsg.style.top = (tBoxPos.top + 20) + "px";
        DivFaxSendStatusHelpMsg.style.left = (tBoxPos.left - 180) + "px";
        DivFaxSendStatusHelpMsg.style.zIndex = "1";

        DivFaxSendStatusHelpMsg.style.visibility = "";
    } else {
        DivFaxSendStatusHelpMsg.style.visibility = "hidden";
    }
}

function FaxSendStatusHelpMsgClose() {
    var DivFaxSendStatusHelpMsg = document.getElementById("Div_FaxSendStatusHelpMsg");
    DivFaxSendStatusHelpMsg.style.visibility = "hidden";
}

function FaxSendResultAllCheck() {
    var chkvalue;

    if (sTop.cBox_FaxSendResultAllCheck.checked) {
        chkvalue = true;
    } else {
        chkvalue = false;
    }

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if (!sTop.item(i).disabled) {
                sTop.item(i).checked = chkvalue;
            }
        }
    }
}

function FaxReSendClick() {
    var SendCount = 0;
    var FaxResendKey = "";
    var AryFaxResendKey, AryFaxResendKey2;
    var totFaxResendCount;
    var totFaxResendPageCount = 0;
    var totFaxResendPrice = 0;
    var recvFaxNo, recvFaxPage;
    var qFaxPrice;
    var conf;

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if ((sTop.item(i).name != "cBox_FaxSendResultAllCheck") && (sTop.item(i).checked)) {
                SendCount += 1;

                if (FaxResendKey.length > 0)
                    FaxResendKey += "†" + Replace(sTop.item(i).name, "FaxSendResult_", "");
                else
                    FaxResendKey = Replace(sTop.item(i).name, "FaxSendResult_", "");
            }
        }
    }

    if (FaxResendKey.length > 0) {
        AryFaxResendKey = FaxResendKey.split('†');
        totFaxResendCount = AryFaxResendKey.length;
        for (var k = 0; k < AryFaxResendKey.length; k++) {
            AryFaxResendKey2 = AryFaxResendKey[k].split('‡');
            recvFaxPage = AryFaxResendKey2[2];
            if (AryFaxResendKey2[1].indexOf("+") >= 0) {
                recvFaxNo = Replace(AryFaxResendKey2[1], "+", "");
                var AryrecvFaxNo = recvFaxNo.split(',');
                qFaxPrice = GetNationalFaxPrice(AryrecvFaxNo[0]);
                totFaxResendPrice += parseInt(qFaxPrice) * parseInt(recvFaxPage);
            }
            else {
                totFaxResendPrice += 40 * parseInt(recvFaxPage);
            }

            totFaxResendPageCount += parseInt(AryFaxResendKey2[2]);
        }
    }
    else {
        alert("다시보내기할 팩스를 선택해 주세요.");
        return false;
    }

    document.getElementById("Div_HtmlBody").className = "FaxSendSummaryOpacityStyle";
    document.getElementById("Div_FaxSendSummary").style.display = "";

    document.getElementById("Div_FaxReSendSmry_Count").innerHTML = "총 " + totFaxResendCount + "건";
    document.getElementById("Div_FaxReSendSmry_PageCount").innerHTML = "총 " + totFaxResendCount + "장";
    document.getElementById("Div_FaxReSendSmry_SendPrice").innerHTML = totFaxResendPrice;

    return false;
}

function FaxReSendSummaryOK() {
    var FaxResendKey = "";
    var totFaxResendPrice = 0;
    var ActionFile, DatatoSend, ReturnValue;
    var RetValue;

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if ((sTop.item(i).name != "cBox_FaxSendResultAllCheck") && (sTop.item(i).checked)) {
                if (FaxResendKey.length > 0)
                    FaxResendKey += "†" + Replace(sTop.item(i).name, "FaxSendResult_", "");
                else
                    FaxResendKey = Replace(sTop.item(i).name, "FaxSendResult_", "");
            }
        }
    }

    totFaxResendPrice = document.getElementById("Div_FaxReSendSmry_SendPrice").innerHTML;

    ActionFile = "FaxSendResult.aspx";
    DatatoSend = "JobFlag=FaxReSend&FaxKeys=" + escape(Replace(FaxResendKey, "+", "#")) + "&ResendPrice=" + totFaxResendPrice + "&SendPayMethod=" + sTop.HidSendPayMethod.value;
    ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);

    if (typeof ReturnValue != "undefined") {

        RetValue = Replace(ReturnValue.substring(0, 2), " ", "");
        RetValue = parseInt(RetValue);

        FaxReSendSummaryClose();

        if (RetValue.toString() == "1") {
            alert("팩스가 발송 등록 되었습니다.");
        }
        else if (RetValue.toString() == "2") {
            alert("포인트 잔액이 부족합니다.\n포인트를 충전하신 후 사용해 주시기 바랍니다.");
        }
        else if (RetValue.toString() == "-2") {
            alert("팩스가 발송 등록 중 Bill36524 오류가 발생하였습니다.");
        }
        else {
            alert('팩스가 발송 등록 중 오류가 발생하였습니다.');
        }
    }

    location.href = "FaxSendResult.aspx?JobFlag=FaxSendResultViewReload&PageNo=1&BeginYear=" + sTop.tBox_FaxSendResult_Begin_Year.value + "&BeginMonth=" + sTop.tBox_FaxSendResult_Begin_Month.value + "&BeginDay=" + sTop.tBox_FaxSendResult_Begin_Day.value + "&EndYear=" + sTop.tBox_FaxSendResult_End_Year.value + "&EndMonth=" + sTop.tBox_FaxSendResult_End_Month.value + "&EndDay=" + sTop.tBox_FaxSendResult_End_Day.value + "&SearchType=" + sTop.ddl_FaxSendResult_SearchType.value + "&SearchValue=" + sTop.tBox_FaxSendResult_SearchValue.value + "&ListCount=" + sTop.ddl_FaxSendResult_ListCount.value + "&SendPayMethod=" + sTop.HidSendPayMethod.value;

    return false;
}

function FaxReSendSummaryClose() {
    document.getElementById("Div_HtmlBody").className = "";
    document.getElementById("Div_FaxSendSummary").style.display = "none";
    return false;
}

function FaxSendResulFaxNoView() {
    alert("[송신요청]상태인 팩스는 문서 확인이 불가능합니다.\n다시 확인해주세요.");
    return false;
}