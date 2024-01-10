
var sTop = document.all;

function FastCalSelClick(SelectType) {
    var y, m, d, yy, mm, dd;

    if ((SelectType == "29") || (SelectType == "30"))
        y = eval('sTop.HidDateType' + SelectType + '.value.substring(0,4)');
    else
        y = sTop.ddl_FaxRecvResult_Year.value;

    m = eval('sTop.HidDateType' + SelectType + '.value.substring(4,6)');
    d = eval('sTop.HidDateType' + SelectType + '.value.substring(6,8)');

    if ((SelectType == "29") || (SelectType == "30"))
        yy = eval('sTop.HidDateType' + SelectType + '.value.substring(8,12)');
    else
        yy = sTop.ddl_FaxRecvResult_Year.value;

    mm = eval('sTop.HidDateType' + SelectType + '.value.substring(12,14)');
    dd = eval('sTop.HidDateType' + SelectType + '.value.substring(14,16)');

    sTop.tBox_FaxRecvResult_Begin_Year.value = y;
    sTop.tBox_FaxRecvResult_Begin_Month.value = m;
    sTop.tBox_FaxRecvResult_Begin_Day.value = d;

    sTop.tBox_FaxRecvResult_End_Year.value = yy;
    sTop.tBox_FaxRecvResult_End_Month.value = mm;
    sTop.tBox_FaxRecvResult_End_Day.value = dd;

    sTop.HidBeginDate.value = y + m + d;
    sTop.HidEndDate.value = yy + mm + dd;
}

function FaxRecvResultViewClick() {
    if (sTop.tBox_FaxRecvResult_Begin_Year.value.length != 4) {
        alert("검색일자(년)을 선택해 주세요.");
        return false;
    }
    if (sTop.tBox_FaxRecvResult_Begin_Month.value.length != 2) {
        alert("검색일자(월)을 입력해 주세요.\n\n입력 예) 04, 12");
        return false;
    }
    if (!IsNumber(sTop.tBox_FaxRecvResult_Begin_Month.value)) {
        alert("검색일자(월)을 잘못 입력 했습니다.");
        return false;
    }
    if (sTop.tBox_FaxRecvResult_Begin_Day.value.length != 2) {
        alert("검색일자(일)을 입력해 주세요.\n\n입력 예) 04, 12, 31");
        return false;
    }
    if (!IsNumber(sTop.tBox_FaxRecvResult_Begin_Day.value)) {
        alert("검색일자(일)을 잘못 입력 했습니다.");
        return false;
    }
    if (sTop.tBox_FaxRecvResult_End_Year.value.length != 4) {
        alert("검색일자(년)을 선택해 주세요.");
        return false;
    }
    if (sTop.tBox_FaxRecvResult_End_Month.value.length != 2) {
        alert("검색일자(월)을 입력해 주세요.\n\n입력 예) 04, 12");
        return false;
    }
    if (!IsNumber(sTop.tBox_FaxRecvResult_End_Month.value)) {
        alert("검색일자(월)을 잘못 입력 했습니다.");
        return false;
    }
    if (sTop.tBox_FaxRecvResult_End_Day.value.length != 2) {
        alert("검색일자(일)을 입력해 주세요.\n\n입력 예) 04, 12, 31");
        return false;
    }
    if (!IsNumber(sTop.tBox_FaxRecvResult_End_Day.value)) {
        alert("검색일자(일)을 잘못 입력 했습니다.");
        return false;
    }
    if (parseInt(sTop.tBox_FaxRecvResult_Begin_Year.value + sTop.tBox_FaxRecvResult_Begin_Month.value + sTop.tBox_FaxRecvResult_Begin_Day.value) > parseInt(sTop.tBox_FaxRecvResult_End_Year.value + sTop.tBox_FaxRecvResult_End_Month.value + sTop.tBox_FaxRecvResult_End_Day.value)) {
        alert("검색시작일자가 검색종료일자 보다 클 수 없습니다.");
        return false;
    }

    var StartDate;
    var EndDate;

    StartDate = sTop.tBox_FaxRecvResult_Begin_Year.value + sTop.tBox_FaxRecvResult_Begin_Month.value;
    EndDate = sTop.tBox_FaxRecvResult_End_Year.value + sTop.tBox_FaxRecvResult_End_Month.value;

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


function FaxRecvResultExcel() {
    var sUrl;
    var conf;
    var BeginDate, EndDate, SearchType, SearchValue, FolerKey;

    conf = confirm("전체데이터를 엑셀로 저장 하시겠습니까?");
    if (conf) {


        if (sTop.tBox_FaxRecvResult_Begin_Year.value.length != 4) {
            alert("검색일자(년)을 4자리로 입력해 주세요.");
            sTop.tBox_FaxRecvResult_Begin_Year.focus();
            return false;
        }
        if (sTop.tBox_FaxRecvResult_Begin_Month.value.length != 2) {
            alert("검색일자(월)을 입력해 주세요.\n\n입력 예) 04, 12");
            sTop.tBox_FaxRecvResult_Begin_Month.focus();
            return false;
        }
        if (sTop.tBox_FaxRecvResult_Begin_Day.value.length != 2) {
            alert("검색일자(일)을 입력해 주세요.\n\n입력 예) 04, 12, 31");
            sTop.tBox_FaxRecvResult_Begin_Day.focus();
            return false;
        }
        if (sTop.tBox_FaxRecvResult_End_Year.value.length != 4) {
            alert("검색일자(년)을 4자리로 입력해 주세요.");
            sTop.tBox_FaxRecvResult_End_Year.focus();
            return false;
        }
        if (sTop.tBox_FaxRecvResult_End_Month.value.length != 2) {
            alert("검색일자(월)을 입력해 주세요.\n\n입력 예) 04, 12");
            sTop.tBox_FaxRecvResult_End_Month.focus();
            return false;
        }
        if (sTop.tBox_FaxRecvResult_End_Day.value.length != 2) {
            alert("검색일자(일)을 입력해 주세요.\n\n입력 예) 04, 12, 31");
            sTop.tBox_FaxRecvResult_End_Day.focus();
            return false;
        }

        BeginDate = sTop.tBox_FaxRecvResult_Begin_Year.value + sTop.tBox_FaxRecvResult_Begin_Month.value + sTop.tBox_FaxRecvResult_Begin_Day.value;
        EndDate = sTop.tBox_FaxRecvResult_End_Year.value + sTop.tBox_FaxRecvResult_End_Month.value + sTop.tBox_FaxRecvResult_End_Day.value;
        SearchType = sTop.ddl_FaxRecvResult_SearchType.value;
        SearchValue = sTop.tBox_FaxRecvResult_SearchValue.value;
        FolderKey = sTop.ddl_Folder.value;

        if ((BeginDate.length != 8) && (EndDate.length != 8)) {
            alert("팩스전송결과를 먼저 조회해 주세요.");
            return false;
        }

        sUrl = "FaxRecvResultExcel.aspx?BeginDate=" + BeginDate + "&EndDate=" + EndDate + "&SearchType=" + SearchType + "&SearchValue=" + escape(SearchValue) + "&FolderKey=" + FolderKey;
        FaxRecvResultExcelFrame.location.href = sUrl;
    }

    return false;
}

function FaxRecvResultSelectDataRemove() {
    var conf;
    var sUrl;
    var strFaxKey = "";

    var BeginDate, EndDate, SearchType, SearchValue, ListCount, FaxNo;

    BeginDate = sTop.HidBeginDate.value;
    EndDate = sTop.HidEndDate.value;
    SearchType = sTop.ddl_FaxRecvResult_SearchType.value;
    SearchValue = sTop.tBox_FaxRecvResult_SearchValue.value;
    ListCount = sTop.ddl_FaxRecvResult_ListCount.value;
    FaxNo = sTop.HidFaxNo.value;

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if (sTop.item(i).checked) {
                if (sTop.item(i).id != "cBox_FaxRecvResultAllCheck") {
                    if (strFaxKey.length > 0)
                        strFaxKey += ";" + sTop.item(i).id;
                    else
                        strFaxKey = sTop.item(i).id;
                }
            }
        }
    }

    strFaxKey = Replace(strFaxKey, "FaxRecvResult_", "");

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
        document.form1.pst_HidFaxNo.value = FaxNo;
        document.form1.target = "FaxRecvResultDataRemoveFrame";
        document.form1.action = "FaxRecvResultRemove.aspx";
        document.form1.method = "post";
        document.form1.submit();

    }
    return false;
}

function FaxRecvResultDataRemove() {
    var conf;
    var sUrl;
    var BeginDate, EndDate, SearchType, SearchValue, SendPayMethod, FolderKey, FaxNo;

    BeginDate = sTop.HidBeginDate.value;
    EndDate = sTop.HidEndDate.value;
    SearchType = sTop.ddl_FaxRecvResult_SearchType.value;
    SearchValue = sTop.tBox_FaxRecvResult_SearchValue.value;
    SendPayMethod = sTop.HidSendPayMethod.value;
    FolderKey = sTop.ddl_Folder.value;
    FaxNo = sTop.HidFaxNo.value;

    if ((BeginDate.length != 8) && (EndDate.length != 8)) {
        alert("팩스수신결과를 먼저 조회해 주세요.");
        return false;
    }

    conf = confirm("삭제된 팩스는 복구가 불가하오니 꼭 \"엑셀파일저장\"으로 백업 후 삭제하시기 바랍니다.\n\n조회된 전체 팩스문서를 삭제 하시겠습니까?");
    if (conf) {
        document.form1.pst_HidRemoveType.value = "AllData";
        document.form1.pst_HidBeginDate.value = BeginDate;
        document.form1.pst_HidEndDate.value = EndDate;
        document.form1.pst_HidSearchType.value = SearchType;
        document.form1.pst_HidSearchValue.value = SearchValue;
        document.form1.pst_HidFolderKey.value = FolderKey;
        document.form1.pst_HidFaxNo.value = FaxNo;

        document.form1.target = "FaxRecvResultDataRemoveFrame";
        document.form1.action = "FaxRecvResultRemove.aspx";
        document.form1.method = "post";
        document.form1.submit();
    }

    return false;
}

function FaxRecvStatusHelpMsgOpen() {
    var DivFaxRecvStatusHelpMsg = document.getElementById("Div_FaxRecvStatusHelpMsg");

    if (DivFaxRecvStatusHelpMsg.style.visibility == "hidden") {
        var tBoxPos = getBounds(document.getElementById("faxRecvresult_list06"));

        DivFaxRecvStatusHelpMsg.style.top = (tBoxPos.top + 20) + "px";
        DivFaxRecvStatusHelpMsg.style.left = (tBoxPos.left - 180) + "px";
        DivFaxRecvStatusHelpMsg.style.zIndex = "1";

        DivFaxRecvStatusHelpMsg.style.visibility = "";
    } else {
        DivFaxRecvStatusHelpMsg.style.visibility = "hidden";
    }
}

function FaxRecvStatusHelpMsgClose() {
    var DivFaxRecvStatusHelpMsg = document.getElementById("Div_FaxRecvStatusHelpMsg");
    DivFaxRecvStatusHelpMsg.style.visibility = "hidden";
}

function FaxRecvResultAllCheck() {
    var chkvalue;

    if (sTop.cBox_FaxRecvResultAllCheck.checked) {
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

function FaxReRecvClick() {
    var RecvCount = 0;
    var FaxRerecvKey = "";
    var AryFaxRerecvKey, AryFaxRerecvKey2;
    var totFaxRerecvCount;
    var totFaxRerecvPageCount = 0;
    var totFaxRerecvPrice = 0;
    var recvFaxNo, recvFaxPage;
    var qFaxPrice;
    var conf;

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if ((sTop.item(i).name != "cBox_FaxRecvResultAllCheck") && (sTop.item(i).checked)) {
                RecvCount += 1;

                if (FaxRerecvKey.length > 0)
                    FaxRerecvKey += "†" + Replace(sTop.item(i).name, "FaxRecvResult_", "");
                else
                    FaxRerecvKey = Replace(sTop.item(i).name, "FaxRecvResult_", "");
            }
        }
    }

    if (FaxRerecvKey.length > 0) {
        AryFaxRerecvKey = FaxRerecvKey.split('†');
        totFaxRerecvCount = AryFaxRerecvKey.length;
        for (var k = 0; k < AryFaxRerecvKey.length; k++) {
            AryFaxRerecvKey2 = AryFaxRerecvKey[k].split('‡');
            recvFaxPage = AryFaxRerecvKey2[2];
            if (AryFaxRerecvKey2[1].indexOf("+") >= 0) {
                recvFaxNo = Replace(AryFaxRerecvKey2[1], "+", "");
                var AryrecvFaxNo = recvFaxNo.split(',');
                qFaxPrice = GetNationalFaxPrice(AryrecvFaxNo[0]);
                totFaxRerecvPrice += parseInt(qFaxPrice) * parseInt(recvFaxPage);
            }
            else {
                totFaxRerecvPrice += 40 * parseInt(recvFaxPage);
            }

            totFaxRerecvPageCount += parseInt(AryFaxRerecvKey2[2]);
        }
    }
    else {
        alert("다시보내기 할 팩스를 선택해 주세요.");
        return false;
    }

    location.href = "FaxSend.aspx?parm=" + FaxRerecvKey;
    return false;
}




function FaxView(FaxFileKey, FaxFile) {
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var winTop;
    winTop = parent.parent.parent;

    iWidth = 1024;
    iHeight = 768;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)
    var _parm1 = Base64.encode(FaxFileKey);
    var _parm2 = Base64.encode(FaxFile);
    var url = "FaxFileKey=" + _parm1 + "&FaxFile=" + _parm2;

    var win_help = window.open("FaxOcxFileView.aspx?" + url, "FaxFullView", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=yes");
    win_help.focus();
}



function ServiceEnd() {
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var winTop;

    winTop = parent.parent.parent;

    iWidth = 500;
    iHeight = 400;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)

    var win = window.open("FaxRecvResult_EndInfo.aspx", "FaxRecvResult_EndInfo", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no,modal=yes");
    win.focus();
}


function ServiceDestroy() {
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var winTop;

    winTop = parent.parent.parent;

    iWidth = 500;
    iHeight = 400;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)

    var win = window.open("FaxRecvResult_DestroyInfo.aspx", "FaxRecvResult_EndInfo", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no,modal=yes");
    win.focus();
}


function RecvFileSizeInfo() {
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var winTop;

    winTop = parent.parent.parent;

    iWidth = 500;
    iHeight = 400;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)

    var win = window.open("FaxRecvResult_FileSizeInfo.aspx", "FaxRecvResult_ExpireInfo", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=yes");
    win.focus();
}



//서비스 Expire
function ServiceExpire() {
    var ServiceExpire = document.getElementById("Div_ServiceExpire");
    ServiceExpire.style.visibility = "";
}

function Recv_Expire() {

    /*
    //alert("수신팩스 연장으로 이동합니다.");
    //live 서버 : https://www.bill36524.com/cloudfax.ReceiveFaxMng.do
    var _nocust = sTop.HidNoCust.value;
    var _nouser = sTop.HidNoUser.value;
    var _id = sTop.HidBill36524ID.value;
    var parm = "https://realtest.bill36524.com:1443/cloudfax.ReceiveFaxMng.do?NO_CUST=" + _nocust + "&NO_USER=" + _nouser + "&ID=" + _id;

    location.href = parm;
    */

    var sTop = document.all;
    var sUrl;
    var strFaxKey = "";
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;

    iWidth = 805;
    iHeight = 753;

    thisX = screen.availWidth;
    thisY = screen.availHeight;

    xx = (thisX - iWidth) / 2 - iWidth;
    yy = (thisY - iHeight) / 2 - iHeight;

    var left = (screen.width / 2) - (iWidth / 2);
    var top = (screen.height / 2) - (iHeight / 2);

    var _nocust = sTop.HidNoCust.value;
    var _nouser = sTop.HidNoUser.value;
    var _id = sTop.HidBill36524ID.value;
    var _ceonocust = sTop.HidCeoNoCust.value;
    var _ceonouser = sTop.HidCeoNoUser.value;
    var _ceoid = sTop.HidCeoBill36524ID.value;

    var parm = "https://www.bill36524.com/cloudfax.ReceiveFaxMng.do?NO_CUST=" + _nocust + "&NO_USER=" + _nouser + "&ID=" + _id + "&CEO_NO_CUST=" + _ceonocust + "&CEO_NO_USER=" + _ceonouser + "&CEO_ID=" + _ceoid;

    var win_Property = window.open(parm, '팩스수신서비스', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + iWidth + ', height=' + iHeight + ', top=' + top + ', left=' + left);
    win_Property.focus();

    return false;

}

function Recv_Expire_Close() {
    var ServiceExpire = document.getElementById("Div_ServiceExpire");
    ServiceExpire.style.visibility = "hidden";
}

function Recv_ExpireTodayclose() {
    closeDay('Expire');

    var ServiceExpire = document.getElementById("Div_ServiceExpire");
    ServiceExpire.style.visibility = "hidden";
}


//서비스 End
function ServiceEnd() {
    var ServiceEnd = document.getElementById("Div_ServiceEnd");
    ServiceEnd.style.visibility = "";
}

function Recv_End() {
    /*
    //alert("수신팩스 재신청으로 이동합니다.");
    //live 서버 : https://www.bill36524.com/cloudfax.ReceiveFaxMng.do
   
    var _nocust = sTop.HidNoCust.value;
    var _nouser = sTop.HidNoUser.value;
    var _id = sTop.HidBill36524ID.value;
    var parm = "https://realtest.bill36524.com:1443/cloudfax.ReceiveFaxMng.do?NO_CUST=" + _nocust + "&NO_USER=" + _nouser + "&ID=" + _id;

    location.href = parm;
    */

    var sTop = document.all;
    var sUrl;
    var strFaxKey = "";
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;

    iWidth = 805;
    iHeight = 753;

    thisX = screen.availWidth;
    thisY = screen.availHeight;

    xx = (thisX - iWidth) / 2 - iWidth;
    yy = (thisY - iHeight) / 2 - iHeight;

    var left = (screen.width / 2) - (iWidth / 2);
    var top = (screen.height / 2) - (iHeight / 2);

    var _nocust = sTop.HidNoCust.value;
    var _nouser = sTop.HidNoUser.value;
    var _id = sTop.HidBill36524ID.value;
    var _ceonocust = sTop.HidCeoNoCust.value;
    var _ceonouser = sTop.HidCeoNoUser.value;
    var _ceoid = sTop.HidCeoBill36524ID.value;


    var parm = "https://www.bill36524.com/cloudfax.ReceiveFaxMng.do?NO_CUST=" + _nocust + "&NO_USER=" + _nouser + "&ID=" + _id + "&CEO_NO_CUST=" + _ceonocust + "&CEO_NO_USER=" + _ceonouser + "&CEO_ID=" + _ceoid;

    var win_Property = window.open(parm, '팩스수신서비스', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + iWidth + ', height=' + iHeight + ', top=' + top + ', left=' + left);
    win_Property.focus();

    return false;
}

function Recv_End_Close() {
    var ServiceExpire = document.getElementById("Div_ServiceEnd");
    ServiceExpire.style.visibility = "hidden";
}

function Recv_EndTodayclose() {
    closeDay('End');

    var ServiceExpire = document.getElementById("Div_ServiceEnd");
    ServiceExpire.style.visibility = "hidden";
}


//서비스 Destroy
function ServiceDestroy() {
    var ServiceDestroy = document.getElementById("Div_ServiceDestroy");
    ServiceDestroy.style.visibility = "";
}

function Recv_Destroy() {
    /*
    //alert("수신팩스 신청으로 이동합니다.");
    //live 서버 : https://www.bill36524.com/cloudfax.ReceiveFaxMng.do
    var _nocust = sTop.HidNoCust.value;
    var _nouser = sTop.HidNoUser.value;
    var _id = sTop.HidBill36524ID.value;
    var parm = "https://realtest.bill36524.com:1443/cloudfax.ReceiveFaxMng.do?NO_CUST=" + _nocust + "&NO_USER=" + _nouser + "&ID=" + _id;

    location.href = parm;
    */

    var sTop = document.all;
    var sUrl;
    var strFaxKey = "";
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;

    iWidth = 805;
    iHeight = 753;

    thisX = screen.availWidth;
    thisY = screen.availHeight;

    xx = (thisX - iWidth) / 2 - iWidth;
    yy = (thisY - iHeight) / 2 - iHeight;

    var left = (screen.width / 2) - (iWidth / 2);
    var top = (screen.height / 2) - (iHeight / 2);

    var _nocust = sTop.HidNoCust.value;
    var _nouser = sTop.HidNoUser.value;
    var _id = sTop.HidBill36524ID.value;
    var _ceonocust = sTop.HidCeoNoCust.value;
    var _ceonouser = sTop.HidCeoNoUser.value;
    var _ceoid = sTop.HidCeoBill36524ID.value;

    var parm = "https://www.bill36524.com/cloudfax.ReceiveFaxMng.do?NO_CUST=" + _nocust + "&NO_USER=" + _nouser + "&ID=" + _id + "&CEO_NO_CUST=" + _ceonocust + "&CEO_NO_USER=" + _ceonouser + "&CEO_ID=" + _ceoid;


    var win_Property = window.open(parm, '팩스수신서비스', 'toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=no, resizable=no, copyhistory=no, width=' + iWidth + ', height=' + iHeight + ', top=' + top + ', left=' + left);
    win_Property.focus();

    return false;
}

function Recv_Destroy_Close() {
    var ServiceDestroy = document.getElementById("Div_ServiceDestroy");
    ServiceDestroy.style.visibility = "hidden";
}

function Recv_DestroyTodayclose() {
    closeDay('Destroy');

    var ServiceDestroy = document.getElementById("Div_ServiceDestroy");
    ServiceDestroy.style.visibility = "hidden";
}


//파일사이즈 알람
function RecvFileSize() {
    var RecvFileSize = document.getElementById("Div_RecvFileSize");
    RecvFileSize.style.visibility = "";
}

function Recv_FileSize_Close() {
    var RecvFileSize = document.getElementById("Div_RecvFileSize");
    RecvFileSize.style.visibility = "hidden";
}

function Recv_FileSizeTodayclose() {
    closeDay('FileSize');

    var RecvFileSize = document.getElementById("Div_RecvFileSize");
    RecvFileSize.style.visibility = "hidden";
}



function closeDay(code) {

    var todayDate = new Date();

    todayDate.setDate(todayDate.getDate() + 1);
    todayDate.setHours(0);
    todayDate.setMinutes(0);
    todayDate.setSeconds(0);

    document.cookie = code + "=" + escape("done") + "; path=/; expires=" + todayDate.toGMTString() + ";"
}


//등록정보 저장..
function recvFaxSubject(tblKey, yearMonth, pBeginDate, pEndDate, pSearchType, pSearchValue, pListCount, pRsComName, pRsUserName) {

    var sTop = document.all;
    var sUrl;
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;

    sUrl = "FaxRecvResult_RecvInfo.aspx";
    winTop = parent.parent.parent;

    iWidth = 445;
    iHeight = 261;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;


    var BeginDate = pBeginDate;
    var EndDate = pEndDate;
    var SearchType = pSearchType;
    var SearchValue = pSearchValue;
    var ListCount = pListCount;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)
    sUrl = sUrl + "?tblKey=" + tblKey + "&yearMonth=" + yearMonth + "&BeginDate=" + BeginDate + "&EndDate=" + EndDate + "&SearchType=" + SearchType + "&SearchValue=" + SearchValue + "&ListCount=" + ListCount + "&ComName=" + pRsComName + "&UserName=" + pRsUserName;

    var win_Property = window.open(sUrl, "FaxProperty", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    win_Property.focus();


}


/**
*
*  Base64 encode / decode
*  http://www.webtoolkit.info/
*
**/

var Base64 = {

    // private property
    _keyStr: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

    // public method for encoding
    encode: function(input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;

        input = Base64._utf8_encode(input);

        while (i < input.length) {

            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);

            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;

            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }

            output = output +
			this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
			this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

        }

        return output;
    },

    // public method for decoding
    decode: function(input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;

        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

        while (i < input.length) {

            enc1 = this._keyStr.indexOf(input.charAt(i++));
            enc2 = this._keyStr.indexOf(input.charAt(i++));
            enc3 = this._keyStr.indexOf(input.charAt(i++));
            enc4 = this._keyStr.indexOf(input.charAt(i++));

            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;

            output = output + String.fromCharCode(chr1);

            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }

        }

        output = Base64._utf8_decode(output);

        return output;

    },

    // private method for UTF-8 encoding
    _utf8_encode: function(string) {
        string = string.replace(/\r\n/g, "\n");
        var utftext = "";

        for (var n = 0; n < string.length; n++) {

            var c = string.charCodeAt(n);

            if (c < 128) {
                utftext += String.fromCharCode(c);
            }
            else if ((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            }
            else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }

        return utftext;
    },

    // private method for UTF-8 decoding
    _utf8_decode: function(utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;

        while (i < utftext.length) {

            c = utftext.charCodeAt(i);

            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            }
            else if ((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i + 1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            }
            else {
                c2 = utftext.charCodeAt(i + 1);
                c3 = utftext.charCodeAt(i + 2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }

        }

        return string;
    }

}