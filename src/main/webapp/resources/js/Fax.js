function ButtonMouseOver(OverName) 
{
    document.getElementById(OverName).src = "../Images/" + OverName + "_over.gif";
    return false;
}

function ButtonMouseOut(OutName)
{
    document.getElementById(OutName).src = "../Images/" + OutName + ".gif";
    return false;
}

function UserModeButtonMouseOver(OverName)
{
    document.getElementById(OverName).src = "../Images/topbar_sub_user_over.gif";
}

function UserModeButtonMouseOut(OverName)
{
    document.getElementById(OverName).src = "../Images/topbar_sub_user.gif";
}

function TopMenuMouseOver(OverName)
{
    document.getElementById(OverName).style.color = "#FFAE00";
    document.getElementById(OverName).style.cursor = "hand";
    return false;
}

function TopMenuMouseOut(OutName)
{
    document.getElementById(OutName).style.color = "white";
    document.getElementById(OutName).style.cursor = "hand";
    return false;
}

function GotoAdminPage()
{
    if ((document.all.HidMode.value == "") || (document.all.HidMode.value == "User"))
    {
        document.all.HidMode.value = "Admin";
        parent.location.href = "FaxAdmin_MainFrame.aspx";
    }
    else
    {
        window.top.location.href = "../Main.aspx";
    }
}

//서비스 로그오프
function ServiceLogOut()
{
    var conf = confirm("클라우드팩스를 종료 하시겠습니까?");
    if (conf)
    {
        window.top.location.href = "../ServiceLogOut.aspx";
        return false;
    }
    else
    {
        return false;
    }
}

//팩스등록정보
function FaxListDblClick(FaxKey, BoxKey) 
{
    var sTop = document.all;
    var sUrl;
    var sPostParamFaxKey;
    var sPostParamFaxBoxKey;
    var sPostParamCalendarDate;
    var sPostParamListPage;
    var sPostParamSearchBox;
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;
    var CalendarDate, ListPage;
    
    if (FaxKey == "") FaxKey = sTop.HidSelectRow.value;
    if (FaxKey == "")
    {
        alert("팩스를 선택해 주세요.");
        return false;
    }
    
    CalendarDate = sTop.HidCalendarDate.value;
    ListPage = sTop.HidListPage.value;
    sUrl = "FaxProperty.aspx";

    if (sTop.HidFaxBoxKey.value != "F0000000000000000000000000000006")
    {
        sPostParamFaxKey = FaxKey;
        sPostParamFaxBoxKey = sTop.HidFaxBoxKey.value;
        sPostParamCalendarDate = CalendarDate;
        sPostParamListPage = ListPage;
        sPostParamSearchBox = "N";
    }
    else
    {
        sPostParamFaxKey = FaxKey;
        sPostParamFaxBoxKey = BoxKey;
        sPostParamCalendarDate = CalendarDate;
        sPostParamListPage = ListPage;
        sPostParamSearchBox = "Y";
    }

    winTop = parent.parent.parent;

    iWidth = 612;
    iHeight = 370;
    
    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;
    
    xx = (thisX/2) - (iWidth/2)
    yy = (thisY/2) - (iHeight/2)

    sUrl = sUrl + "?sPostParamFaxKey="+sPostParamFaxKey+"&sPostParamFaxBoxKey="+sPostParamFaxBoxKey+"&sPostParamCalendarDate="+sPostParamCalendarDate+"&sPostParamListPage="+sPostParamListPage+"&sPostParamSearchBox="+sPostParamSearchBox;
    var win_Property = window.open(sUrl, "FaxProperty", "left="+xx+",top="+yy+",width="+iWidth+",height="+iHeight+", scrollbars=no,menubar=no,resizable=no");
    win_Property.focus();

    FaxSendTypeViewerClose();
}

function FaxListClick(FaxKey, BoxKey)
{
    var sTop = document.all;   
    
    
    if (sTop.HidFaxBoxKey.value == "F0000000000000000000000000000006") {
        //검색팩스함 일 경우 별도의 선택된 항목의 팩스키를 보관한다.
        sTop.HidSelectRowBoxKey.value = BoxKey;
    }   
    
    if (sTop.HidSelectRow.value == "")
    {
        sTop.HidSelectRow.value = FaxKey;
        eval("sTop.FaxList_"+FaxKey+".style.backgroundColor = '#E0E0E0'");
    }
    else
    {
        eval("sTop.FaxList_"+sTop.HidSelectRow.value+".style.backgroundColor = '#FFFFFF'");
        sTop.HidSelectRow.value = FaxKey;
        eval("sTop.FaxList_"+FaxKey+".style.backgroundColor = '#E0E0E0'");
    }
    ViewFax(FaxKey, BoxKey);
    FaxSendTypeViewerClose();
}

//Create : 2013-12-16 guagua 연도Table
function FaxListClick2(FaxKey, BoxKey, RSDateYear) {
    var sTop = document.all;

    if (sTop.HidFaxBoxKey.value == "F0000000000000000000000000000006") {
        //검색팩스함 일 경우 별도의 선택된 항목의 팩스키를 보관한다.
        sTop.HidSelectRowBoxKey.value = BoxKey;
    }

    sTop.HidRSDateYear.value = RSDateYear;

    if (sTop.HidSelectRow.value == "") {
        sTop.HidSelectRow.value = FaxKey;
        eval("sTop.FaxList_" + FaxKey + ".style.backgroundColor = '#E0E0E0'");
    }
    else {
        eval("sTop.FaxList_" + sTop.HidSelectRow.value + ".style.backgroundColor = '#FFFFFF'");
        sTop.HidSelectRow.value = FaxKey;
        eval("sTop.FaxList_" + FaxKey + ".style.backgroundColor = '#E0E0E0'");
    }
    ViewFax2(FaxKey, BoxKey, RSDateYear);
    FaxSendTypeViewerClose();
}

function ViewFax(FaxKey, BoxKey)
{
    parent.parent.FaxViewFrame.FaxView.location.href = 'FaxView.aspx?FaxKey=' + FaxKey + "&BoxKey=" + BoxKey;
}

function ViewFax2(FaxKey, BoxKey, RSDateYear) {
    parent.parent.FaxViewFrame.FaxView.location.href = 'FaxView.aspx?FaxKey=' + FaxKey + "&BoxKey=" + BoxKey + "&RSDateYear=" + RSDateYear;
}

function ViewFaxOnLoad(FileUrl, FaxKey, IsFullView) {
    var strCount;
    var BoxKey;
    var BoxCountName;

    if (IsFullView == "0") {
        BoxKey = parent.parent.FaxListFrame.FaxList.document.all.HidFaxBoxKey.value;
        if ((BoxKey != "F0000000000000000000000000000002") && (BoxKey != "F0000000000000000000000000000003") && (BoxKey != "F0000000000000000000000000000004") && (BoxKey != "F0000000000000000000000000000005") && (BoxKey != "F0000000000000000000000000000006") && (BoxKey != "F0000000000000000000000000000008")) {
            if (parent.parent.FaxListFrame.FaxList.document.getElementById("FaxRead_" + FaxKey).outerHTML.indexOf("/unread.gif") > 0) {
                if (BoxKey == "F0000000000000000000000000000001")
                    BoxCountName = "ReceiveBoxUnReadCount";
                else if (BoxKey == "F0000000000000000000000000000003")
                    BoxCountName = "SendBoxUnReadCount";
                else if (BoxKey == "F0000000000000000000000000000004")
                    BoxCountName = "DeleteBoxUnReadCount";
                else if (BoxKey == "F0000000000000000000000000000005")
                    BoxCountName = "GlobalShareBoxUnReadCount";
                else if ((BoxKey != "F0000000000000000000000000000001") && (BoxKey != "F0000000000000000000000000000003") && (BoxKey != "F0000000000000000000000000000004") && (BoxKey != "F0000000000000000000000000000005"))
                    BoxCountName = "UserBox" + BoxKey + "UnReadCount";

                //팩스리스트의 읽지 않은 조회개수 변경
                if (parent.parent.FaxLeftFrame.FaxLeft.document.getElementById(BoxCountName) != null) {
                    strCount = parent.parent.FaxLeftFrame.FaxLeft.document.getElementById(BoxCountName).outerText;
                    if (strCount.length > 0) {
                        strCount = Replace(strCount, "(", "");
                        strCount = Replace(strCount, ")", "");
                        if (strCount != "1") {
                            strCount = (parseInt(strCount) - 1).toString();
                            parent.parent.FaxLeftFrame.FaxLeft.document.getElementById(BoxCountName).innerHTML = "<b>(" + strCount + ")</b>";
                        }
                        else {
                            parent.parent.FaxLeftFrame.FaxLeft.document.getElementById(BoxCountName).innerHTML = "<b></b>";
                        }
                    }
                }
            }
        }
    }

    //팩스리스트의 읽음표시 아이콘을 변경
    if (IsFullView == "0") parent.parent.FaxListFrame.FaxList.document.getElementById("FaxRead_" + FaxKey).innerHTML = "<img src=\"../Images/read.gif\" alt=\"조회\" border=\"0\">";
    document.getElementById("AX").LoadImage_http(FileUrl);
}

function ViewFaxOnLoadDisconnect() 
{
    try {
        alert("서버와의 접속이 종료 되었습니다.\n\n[원인]\n오랜시간 사용하지 않아 서버와의 접속이 종료 되었을 수 있습니다.");
        top.window.close();
        top.opener.location.href = "/default.aspx";
    }
    catch (e) { }
}

//등록정보 닫기 클릭
function FaxPropertyClose()
{
    self.window.close();
}

function FaxReadClose()
{
    self.window.close();
}

//등록정보 확인,취소버튼 클릭
function FaxPropertySaveClose(BoxKey, CalendarDate, ListPage, SearchBox) {
    if (SearchBox == "Y") {
        BoxKey = "F0000000000000000000000000000006";
    }

    switch (BoxKey) {
        case "F0000000000000000000000000000001":
            opener.location.href = "FaxList_Receive.aspx?ViewDate=" + CalendarDate + "&ListPage=" + ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000002":
            opener.location.href = "FaxList_Reservation.aspx?ListPage=" + ListPage;
            break;
        case "F0000000000000000000000000000003":
            opener.location.href = "FaxList_Send.aspx?ViewDate=" + CalendarDate + "&ListPage=" + ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000004":
            opener.location.href = "FaxList_Delete.aspx?ListPage=" + ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000005":
            opener.location.href = "FaxList_GlobalShared.aspx?ListPage=" + ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000006":
            opener.location.href = opener.location.href
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000007":
            opener.location.href = "FaxList_Bulk.aspx?ListPage=" + ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000008":
            opener.location.href = "FaxList_Reg.aspx?ListPage=" + ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        default:
            opener.location.href = "FaxList_UserBox.aspx?BoxKey=" + BoxKey + "&ListPage=" + ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + opener.document.all.HidTreeID.value;
            break;
    }
    self.window.close();
}

function FaxListAllClick()
{
    var sTop = document.all;
    if ((sTop.IsAllCheck.value == "F") || (sTop.IsAllCheck.value == ""))
        FaxListCheck();
    else
        FaxListNonCheck();
}

function FaxListCheck()
{
    var sTop = document.all;
    for (var i=0;i<sTop.length;i++)
    {
        if (sTop.item(i).getAttribute("type") == "checkbox")
        {
            if (!sTop.item(i).disabled)
            {
                sTop.item(i).checked = true;
            }
        }
    }
    sTop.IsAllCheck.value = "T";
}

function FaxListNonCheck()
{
    var sTop = document.all;
    for (var i=0;i<sTop.length;i++)
    {
        if (sTop.item(i).getAttribute("type") == "checkbox")
            sTop.item(i).checked = false;
    }
    sTop.IsAllCheck.value = "F";
}

function FaxListCheckValue()
{
    var sTop = document.all;
    var ReturnValue = "";
    for (var i=0;i<sTop.length;i++)
    {
        if (sTop.item(i).getAttribute("type") == "checkbox")
        {
            if (sTop.item(i).checked)
            {
                if (typeof sTop.item(i).name != "undefined")
                    ReturnValue += sTop.item(i).name + ";";
            }
        }
    }
    return ReturnValue;
}

function SelectFaxCount(SelectedFax)
{
    var ArySelectedFax = SelectedFax.split(';');
    return ArySelectedFax.length - 1;
}

//팩스 이동, 복사 버튼 클릭
//Modify : 2013-12-16 guagua 연도Table
function BtnMoveCopyClick(Mode)
{
    var sTop = document.all;
    var SelectValue = FaxListCheckValue();
    var sMsg;
    var intCount;
    var conf;
    var AryValue;
    var AryBoxValue = "";
    var winTop;
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var sUrl;
    var CalendarDate, ListPage;
    var sPostParamMode;
    var sPostParamFaxBoxKey;
    var sPostParamCalendarDate;
    var sPostParamListPage;
    var strrYear = "";

    if (Mode == "Move")
        sMsg = "이동";
    else
        sMsg = "복사";
    
    if (SelectValue.length == 0)
    {
        alert(sMsg + "할 팩스를 선택해 주세요.\n\n[알림] " + sMsg + "할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }
    
    sTop.HidSelectedFax.value = SelectValue;

    if (sTop.HidFaxBoxKey.value == "F0000000000000000000000000000006")
    {
        AryValue = sTop.HidSelectedFax.value.split(';');
        for (var i=0;i<AryValue.length-1;i++)
        {
            //보낼팩스함인 경우 이동/복사 안됨.
            if (document.getElementById(Replace(AryValue[i],'FaxKey_','')).outerText == "F0000000000000000000000000000002")
            {
                alert("선택한 팩스가 보낼팩스함 문서가 포함되어 있습니다.\n보낼팩스함에 있는 문서는 " + sMsg + "할 수 없습니다.");
                return false;
            }
            var tempBoxValue = document.getElementById(Replace(AryValue[i], 'FaxKey_', '')).outerText;
            AryBoxValue += tempBoxValue + ";";
           
            //이동, 복사할 팩스가 동보팩스면 이동복사삭제가 안된다.
            if (tempBoxValue == "F0000000000000000000000000000007") {
                alert("선택한 팩스중 동보팩스함 문서가 선택 되었습니다.\n\n※ 검색된 동보팩스함 문서는 이동, 복사가 불가합니다.");
                return false;
            }
        }
        
        sTop.HidSelectedFaxBox.value = AryBoxValue;
    }

    CalendarDate = sTop.HidCalendarDate.value;
    ListPage = sTop.HidListPage.value;

    sUrl = "FaxMoveCopy.aspx";
    sPostParamMode = Mode;
    sPostParamFaxBoxKey = sTop.HidFaxBoxKey.value;
    sPostParamCalendarDate = CalendarDate;
    sPostParamListPage = ListPage;
        
    winTop = parent.parent.parent;

    iWidth = 400;
    iHeight = 400;
    
    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;
    
    xx = (thisX/2) - (iWidth/2)
    yy = (thisY/2) - (iHeight/2)

    sUrl = "FaxMoveCopy.aspx?sPostParamrYear="+strrYear+"&sPostParamMode="+sPostParamMode+"&sPostParamFaxBoxKey="+sPostParamFaxBoxKey+"&sPostParamCalendarDate="+sPostParamCalendarDate+"&sPostParamListPage="+sPostParamListPage;
    var win_movecopy = window.open(sUrl, "FaxMoveCopy", "left="+xx+",top="+yy+",width="+iWidth+",height="+iHeight+", scrollbars=no,menubar=no,resizable=no");
    win_movecopy.focus();
}

//팩스 이동,복사화면에서 닫기버튼 클릭
function FaxMoveCopyClose()
{
    self.window.close();
}

//팩스 이동,복사화면에서 Tree Item 선택
function MoveCopyTreeItemClickHandler(BoxKey)
{
    var sTop = document.all;
    sTop.HidDestFaxBoxKey.value = BoxKey;
}

//팩스 이동,복사화면에서 확인버튼 클릭
function FaxMoveCopySave(Mode)
{
    var conf;
    var sMsg;
    var sTop = document.all;
    if (sTop.HidDestFaxBoxKey.value == "")
    {
        alert("팩스함을 선택해 주세요.");
        return false;
    }
    else
    {
        if (Mode == "Move") sMsg = "이동";
        else sMsg = "복사";

        intCount = SelectFaxCount(opener.document.all.HidSelectedFax.value);
        conf = confirm(intCount.toString() + "개의 팩스를 " + sMsg + " 하시겠습니까?");
        if (conf)
            return true;
        else
            return false;
    }
}

function FaxMoveCopyOnLoad()
{
    document.all.HidSelectedFax.value = opener.document.all.HidSelectedFax.value;
    if (document.all.HidSrcFaxBoxKey.value == "F0000000000000000000000000000006")
        document.all.HidSelectedFaxBox.value = opener.document.all.HidSelectedFaxBox.value;
}

//팩스 이동, 복사 완료후 닫기
function FaxMoveCopySaveClose(BoxKey, CalendarDate, ListPage)
{
    switch(BoxKey)
    {
        case "F0000000000000000000000000000001":
            opener.location.href = "FaxList_Receive.aspx?ViewDate="+CalendarDate+"&ListPage="+ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000002":
            opener.location.href = "FaxList_Reservation.aspx?ListPage="+ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000003":
            opener.location.href = "FaxList_Send.aspx?ViewDate="+CalendarDate+"&ListPage="+ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000004":
            opener.location.href = "FaxList_Delete.aspx?ListPage="+ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000005":
            opener.location.href = "FaxList_GlobalShared.aspx?ListPage=" + ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;
        case "F0000000000000000000000000000006":
            opener.location.href = opener.location.href;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + BoxKey;
            break;            
        default:
            opener.location.href = "FaxList_UserBox.aspx?BoxKey="+BoxKey+"&ListPage="+ListPage;
            opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + opener.document.all.HidTreeID.value;
            break;
    }
    self.window.close();
}

//팩스 이동, 복사 완료후 닫기
function FaxMoveCopySaveClose_YYYY(rYear, BoxKey, CalendarDate, ListPage) {
    switch (BoxKey) {
        case "F0000000000000000000000000000001":
            opener.location.href = "FaxList_Receive_YYYY.aspx?rYear=" + rYear + "&ViewDate=" + CalendarDate + "&ListPage=" + ListPage;
            window.close();
            break;
        case "F0000000000000000000000000000003":
            opener.location.href = "FaxList_Send_YYYY.aspx?rYear=" + rYear + "&ViewDate=" + CalendarDate + "&ListPage=" + ListPage;
            window.close();
            break;
        case "F0000000000000000000000000000006":
            window.close();
            break;
    }
}

//Modify : 2013-12-16 guagua 연도Table
function BtnDeleteClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var conf;
    var FileName;
    var LeftMenu;
    var IsAddrDel;
    var SelectValue = FaxListCheckValue();
    var strrYear = "";
    
    if (SelectValue.length == 0)
    {
        alert("삭제할 팩스를 선택해 주세요.\n\n[알림] 삭제할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }
    
    switch(sTop.HidFaxBoxKey.value)
    {
        case "F0000000000000000000000000000001":
            if (strrYear.length == 4) {
                FileName = "FaxList_Receive_YYYY.aspx?rYear=" + strrYear + "&ViewDate=" + sTop.HidCalendarDate.value + "&ListPage=" + sTop.HidListPage.value;
                LeftMenu = "FaxLeft.aspx";
            }
            else {
                FileName = "FaxList_Receive.aspx?ViewDate=" + sTop.HidCalendarDate.value + "&ListPage=" + sTop.HidListPage.value;
                LeftMenu = "FaxLeft.aspx?SelectNode=" + sTop.HidFaxBoxKey.value;
            }

            break;
        case "F0000000000000000000000000000002":
            FileName = "FaxList_Reservation.aspx?ListPage="+sTop.HidListPage.value;
            LeftMenu = "FaxLeft.aspx?SelectNode="+sTop.HidFaxBoxKey.value;
            break;
        case "F0000000000000000000000000000003":
            if (strrYear.length == 4) {
                FileName = "FaxList_Send_YYYY.aspx?rYear=" + strrYear + "&ViewDate=" + sTop.HidCalendarDate.value + "&ListPage=" + sTop.HidListPage.value;
                LeftMenu = "FaxLeft.aspx";
            }
            else {
                FileName = "FaxList_Send.aspx?ViewDate=" + sTop.HidCalendarDate.value + "&ListPage=" + sTop.HidListPage.value;
                LeftMenu = "FaxLeft.aspx?SelectNode=" + sTop.HidFaxBoxKey.value;
            }
            break;
        case "F0000000000000000000000000000004":
            FileName = "FaxList_Delete.aspx?ListPage="+sTop.HidListPage.value;
            LeftMenu = "FaxLeft.aspx?SelectNode="+sTop.HidFaxBoxKey.value;
            break;
        case "F0000000000000000000000000000005":
            FileName = "FaxList_GlobalShared.aspx?ListPage="+sTop.HidListPage.value;
            LeftMenu = "FaxLeft.aspx?SelectNode="+sTop.HidFaxBoxKey.value;
            break;
        default:
            FileName = "FaxList_UserBox.aspx?BoxKey="+sTop.HidFaxBoxKey.value+"&ListPage="+sTop.HidListPage.value;
            LeftMenu = "FaxLeft.aspx?SelectNode="+sTop.HidTreeID.value;
            break;
    }
    
    sTop.HidSelectedFax.value = SelectValue;

    intCount = SelectFaxCount(sTop.HidSelectedFax.value);

    if (sTop.HidFaxBoxKey.value != "F0000000000000000000000000000004")
    {
        conf = confirm(intCount.toString() + "개의 팩스를 삭제 하시겠습니까?");
        
        if (conf) {
            if (sTop.HidFaxBoxKey.value == "F0000000000000000000000000000002") {
                if (sTop.HidReservationBoxDeleteConfig.value == "1") {
                    var conf2 = confirm("보낼팩스함 삭제시 팩스발송이 되지 않은 팩스번호에 대해 주소록에서 팩스번호를 삭제하도록 관리자가 설정 하였습니다.\n\n(※ 본 기능의 목적 : 잘못된 팩스번호가 주소록 정보에 남아 있어 계속해서 팩스발송 항목에 포함되는 것을 방지하기 위함 입니다.)\n\n주소록의 정보도 함께 삭제 하시겠습니까? (단, 상태가 송신취소, 송신대기, 송신 중 일 경우 제외");
                    if (conf2)
                        IsAddrDel = "1";
                    else
                        IsAddrDel = "";
                }
            }
        }
    } 
    else
        conf = confirm("지운팩스함에서도 삭제하면 복원할 수 없습니다.\n" + intCount.toString() + "개의 팩스를 삭제 하시겠습니까?");
    
    if (conf)
    {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "JobFlag=FaxDel&rYear=" + strrYear + "&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value + "&AddrDel=" + IsAddrDel;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (typeof ReturnValue != "undefined")
        {
            if (ReturnValue == "1")
            {
                alert("팩스가 삭제 되었습니다.");
                parent.parent.FaxViewFrame.FaxView.document.getElementById("AX").LoadImage_http("about:blank");
                location.href = FileName;
                parent.parent.FaxLeftFrame.FaxLeft.location.href = LeftMenu;
            }
            else if (ReturnValue == "-2")
            {
                alert("현재 발송 중인 팩스가 존재하므로, 팩스를 삭제할 수 없습니다.");
                location.href = FileName;
                parent.parent.FaxLeftFrame.FaxLeft.location.href = LeftMenu;
            }
            else
            {
                alert("팩스 삭제 중 오류가 발생하였습니다.");
                parent.parent.FaxLeftFrame.FaxLeft.location.href = LeftMenu;
            }
        }
    }
}

function BtnAllDeleteClick()
{
    var sTop = document.all;
    var conf;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var FileName;
    
    conf = confirm("지운팩스함에서도 삭제하면 복원할 수 없습니다.\n지운팩스함을 비우시겠습니까?");
    if (conf)
    {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "JobFlag=FaxAllDel";
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (typeof ReturnValue != "undefined")
        {
            if (ReturnValue == "1")
            {
                alert("지운팩스함을 모두 비웠습니다.");
                location.href = "FaxList_Delete.aspx?ListPage="+sTop.HidListPage.value;
                parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000004";
            }
            else
            {
                alert("지운팩스함을 비우는 중 오류가 발생하였습니다.");
                parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000004";
            }
        }
    }
}

//Modify : 2013-12-16 guagua 연도Table
function BtnReadClick()
{
    var sTop = document.all;
    var sUrl;
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;
    var sPostParamFaxKey;
    var sPostParamBoxKey;
    var strrYear = "";
    var strRSDateYear = "";
    
    if (sTop.HidSelectRow.value == "")
    {
        alert("팩스를 선택해 주세요.");
        return false;
    }
    
    sUrl = "FaxRead.aspx";
    sPostParamFaxKey = sTop.HidSelectRow.value;
    if (sTop.HidFaxBoxKey.value == "F0000000000000000000000000000006") {
        // 검색팩스함일경우 선택된 팩스함키를 가져온다.
        sPostParamBoxKey = sTop.HidSelectRowBoxKey.value;
    }
    else {
        sPostParamBoxKey = sTop.HidFaxBoxKey.value;
    }

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }

    if (document.getElementById("HidRSDateYear") != null) {
        strRSDateYear = document.all.HidRSDateYear.value;
    }

    if (strRSDateYear.length == 4) {
        strrYear = strRSDateYear;
    }

    winTop = parent.parent.parent;

    iWidth = 700;
    iHeight = 600;
    
    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;
    
    xx = (thisX/2) - (iWidth/2)
    yy = (thisY/2) - (iHeight/2)

    sUrl = sUrl + "?sPostParamrYear=" + strrYear + "&sPostParamFaxKey=" + sPostParamFaxKey + "&sPostParamBoxKey=" + sPostParamBoxKey;
    var win_Read = window.open(sUrl, "FaxRead", "left="+xx+",top="+yy+",width="+iWidth+",height="+iHeight+", scrollbars=no,menubar=no,resizable=no");
    win_Read.focus();
    
}

//Modify : 2013-12-16 guagua 연도Table
function BtnDeleteClickBySearchResult()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();
    var SelectFaxBox;
    var AryValue;
    var IsSuccess = true;
    var IsSending = false;
    var strrYear = "";
    
    if (SelectValue.length == 0)
    {
        alert("삭제할 팩스를 선택해 주세요.");
        return false;
    }

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }
    
    sTop.HidSelectedFax.value = Replace(SelectValue,'FaxKey_','');

    intCount = SelectFaxCount(sTop.HidSelectedFax.value);

    var conf = confirm(intCount.toString() + "개의 팩스를 삭제 하시겠습니까?");
    if (conf)
    {
        ActionFile = "AjaxFax.aspx";

        AryValue = sTop.HidSelectedFax.value.split(';');
        for (var j=0;j<AryValue.length-1;j++)
        {
            for (var i=0;i<sTop.length;i++)
            {
                if (sTop.item(i).getAttribute("type") == "checkbox") 
                {
                    if (typeof sTop.item(i).name != "undefined") 
                    {
                        if (AryValue[j] == Replace(sTop.item(i).name, 'FaxKey_', '')) 
                        {
                            SelectFaxBox = document.getElementById(Replace(sTop.item(i).name, 'FaxKey_', '')).outerText;
                            DatatoSend = "JobFlag=FaxDel&rYear=" + strrYear + "&FaxKey="+AryValue[j]+"&BoxKey="+SelectFaxBox;
                            ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
                            if (typeof ReturnValue != "undefined")
                            {
                                if (ReturnValue == "1")
                                {
                                    IsSuccess = true;
                                }
                                else if (ReturnValue == "-2")
                                {
                                    IsSuccess = false;
                                    IsSending = true;
                                    break;
                                }
                                else
                                {
                                    IsSuccess = false;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
            
            if (!IsSuccess) break;
        }

        if (IsSuccess)
        {
            alert("팩스가 삭제 되었습니다.");
            document.location.reload();
            parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + document.all.HidFaxBoxKey.value;
        }
        else
        {
            if (IsSending)
            {
                alert("발송 중인 팩스를 제외하고, 팩스가 삭제 되었습니다.");
                parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=" + document.all.HidFaxBoxKey.value;
            }
            else
            {
                alert("팩스 삭제 중 오류가 발생하였습니다.");
            }
        }
    }
}

function BtnRestoreClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();
    
    if (SelectValue.length == 0)
    {
        alert("복원할 팩스를 선택해 주세요.\n\n[알림] 복원할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    
    sTop.HidSelectedFax.value = SelectValue;

    intCount = SelectFaxCount(sTop.HidSelectedFax.value);
        
    var conf = confirm(intCount.toString() + "개의 팩스를 복원 하시겠습니까?");
    if (conf)
    {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "JobFlag=FaxRestore&FaxKey="+Replace(sTop.HidSelectedFax.value,'FaxKey_','')+"&BoxKey="+sTop.HidFaxBoxKey.value;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (typeof ReturnValue != "undefined")
        {
            if (ReturnValue == "1")
            {
                alert("팩스가 복원 되었습니다.");
                document.location.reload();
                parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000004";
            }
            else if (ReturnValue == "2")
            {
                alert("복원할 팩스의 팩스함(원래위치)이 존재하지 않아 복원할 수 없습니다.\n원래위치 항목이 비어 있는 팩스는 복원할 수 없습니다.");
                parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000004";
            }
            else
            {
                alert("팩스 복원 중 오류가 발생하였습니다.");
                parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000004";
            }
        }
    }
}

function BtnReSendClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();
    var FaxSendService;
    
    if (SelectValue.length == 0)
    {
        alert("다시 발송할 팩스를 선택해 주세요.\n\n[알림] 발송할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else
    {
        sTop.HidSelectedFax.value = SelectValue;
        FaxSendService = document.getElementById("HidFaxSendService").value;
        
        intCount = SelectFaxCount(sTop.HidSelectedFax.value);
        
        var conf = confirm(intCount.toString() + "개의 팩스를 다시 발송 하시겠습니까?");
        if (conf) {
            var IsReSend = IsOverDailySendFax(intCount);
            
            if(IsReSend)
            {            
                var sAX = parent.parent.frames[4].frames[0];
                var strFaxBoxKey = document.all.HidFaxBoxKey.value;
                var strFaxKey = Replace(document.all.HidSelectedFax.value, "FaxKey_", "");
                var strSessionKey = document.all.HidSessionKey.value;
               
                if (FaxSendService.indexOf('11') > -1) //인터넷으로 보내기
                {
                    strSessionKey = strSessionKey + "_internet";
                }
                else if (FaxSendService.indexOf('12') > -1) //미니로 보내기
                {
                    strSessionKey = strSessionKey + "_mini"
                }
                sAX.document.getElementById("AX").RunProgram("", "", "", strFaxBoxKey, strFaxKey, strSessionKey);
            }
            else
            {
                DailySendFaxOverPopUp();
            }
            
        }
    }
}

//보낸팩스함-다시보내기
function BtnSendBoxReSendClick_GetPoint() {
    BtnSendBoxReSendClick();
}

//Modify : 2013-12-16 guagua 연도Table
function BtnSendBoxReSendClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();
    var reSendType = sTop.HidFaxReSendType.value;
    var strrYear = "";
    
    if (SelectValue.length == 0)
    {
        alert("다시 발송할 팩스를 선택해 주세요.\n\n[알림] 발송할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else 
    {
        if (document.getElementById("HidrYear") != null) {
            strrYear = document.all.HidrYear.value;
        }
        
        sTop.HidSelectedFax.value = SelectValue;
        intCount = SelectFaxCount(sTop.HidSelectedFax.value);
        
        var conf = confirm(intCount.toString() + "개의 팩스를 다시 발송 하시겠습니까?");
        if (conf)
        {
            var IsReSend = IsOverDailySendFax(intCount);
            
            if(IsReSend)
            {
                ActionFile = "AjaxFax.aspx";
                DatatoSend = "JobFlag=FaxReSend&rYear=" + strrYear + "&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value + "&reSendType=" + reSendType + "&Bill36524Point=" + sTop.HidBill36524Point.value;
                ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
                if (typeof ReturnValue != "undefined")
                {
                    if (ReturnValue == "1")
                    {
                        alert("팩스가 발송처리 되었습니다.");
                        location.href = "FaxList_Reservation.aspx";
                        parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000002";
                    }
                    else if (ReturnValue == "-2") {
                        alert("인터넷 팩스 발송 중 잔액부족으로 중단되었습니다.");
                    }
                    else
                    {
                        alert("팩스 발송 중 오류가 발생하였습니다.");
                    }
                }
            }
            else
            {
                DailySendFaxOverPopUp();
            }
        }
    }
}

//보낼팩스함-다시보내기
function BtnReservationBoxReSendClick_GetPoint()
{
    //    var sTop = document.all;
    //    parent.parent.parent.frames[1].FxGetPoint();
    //    setTimeout("document.all.HidBill36524Point.value = parent.parent.parent.frames[1].Get_POINT_VALUE(); BtnReservationBoxReSendClick();", 1000);

    BtnReservationBoxReSendClick();
}

function BtnReservationBoxReSendClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();
    var reSendType = sTop.HidFaxReSendType.value;

    if (SelectValue.length == 0)
    {
        alert("다시 발송할 팩스를 선택해 주세요.\n\n[알림] 발송할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else
    {
        sTop.HidSelectedFax.value = SelectValue;

        intCount = SelectFaxCount(sTop.HidSelectedFax.value);
        
        var conf = confirm(intCount.toString() + "개의 팩스를 다시 발송 하시겠습니까?");
        if (conf)
        {
            var IsReSend = IsOverDailySendFax(intCount);
            
            if(IsReSend)
            {            
                ActionFile = "AjaxFax.aspx";
                DatatoSend = "JobFlag=FaxReSend&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value + "&reSendType=" + reSendType + "&Bill36524Point=" + sTop.HidBill36524Point.value;
                ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
                if (typeof ReturnValue != "undefined")
                {
                    if (ReturnValue == "1") {
                        alert("팩스가 발송처리 되었습니다.");
                        document.location.reload();
                    }
                    else if (ReturnValue == "-2") {
                        alert("인터넷 팩스 보내는 중 잔액부족 으로 중단되었습니다.");
                    }
                    else {
                        alert("팩스 발송 중 오류가 발생하였습니다.");
                    }
                }
            }
            else
            {
                DailySendFaxOverPopUp();
            }
        }
    }
}

function BtnSendCancelClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();

    if (SelectValue.length == 0)
    {
        alert("보내기 취소할 팩스를 선택해 주세요.\n\n[알림] 취소할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else
    {
        sTop.HidSelectedFax.value = SelectValue;

        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + "개의 팩스를 보내기 취소 하시겠습니까?\n\n※ 팩스의 발송상황에 따라 보내기취소가 되지 않을 수 있습니다.");
        {
            if (conf)
            {
                ActionFile = "AjaxFax.aspx";
                DatatoSend = "JobFlag=FaxSendCancel&FaxKey="+Replace(SelectValue,'FaxKey_','')+"&BoxKey="+sTop.HidFaxBoxKey.value;
                ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
                if (typeof ReturnValue != "undefined")
                {
                    if (ReturnValue == "1")
                    {
                        alert("팩스보내기가 취소 되었습니다.");
                        document.location.reload();
                    }
                    else if (ReturnValue == "2")
                    {
                        alert("발송 중이거나 발송처리가 완료되지 않은 팩스를 제외하고, 팩스보내기가 취소 되었습니다.");
                        document.location.reload();
                    }
                    else
                    {
                        alert("팩스 보내기취소 중 오류가 발생하였습니다.");
                    }
                }
            }
        }
    }
}

function BtnFaxSearchClick()
{
    if (document.all.HidMode.value == "Admin")
    {
        var conf = confirm("관리자화면에서 팩스검색을 할 수 없습니다.\n사용자화면으로 이동 하시겠습니까?");
        if (conf)
        {
            window.top.location.href = "../Main.aspx";
            return false;
        }
        else
        {
            return false;
        }
    }

    var sTop = parent.parent.parent;

    var iWidth = 600;
    var iHeight = 660;
    
    var thisX = sTop.document.body.clientWidth;
    var thisY = sTop.document.body.clientHeight;
    
    var xx = (thisX/2) - (iWidth/2)
    var yy = (thisY/2) - (iHeight/2)

    var win_search = window.open("FaxSearch.aspx", "FaxSearch", "left="+xx+",top="+yy+",width="+iWidth+",height="+iHeight+", scrollbars=no,menubar=no,resizable=no");
    win_search.focus();
}

function FastCalSelClick(SelectValue)
{
    var sTop = document.all;
    if (sTop.HidFastCalSel.value == "")
    {
        sTop.HidFastCalSel.value = SelectValue;
    }
    else
    {
        sTop.HidFastCalSel.value = SelectValue;
    }
    FastCalSel(SelectValue);
}

function SetFastCal(dtValue, dtValueBeginLabel, dtValueEndLabel)
{
    var y, m, d, yy, mm, dd;
    y = dtValue.substring(0,4);
    m = dtValue.substring(4,6);
    d = dtValue.substring(6,8);
    yy = dtValue.substring(8,12);
    mm = dtValue.substring(12,14);
    dd = dtValue.substring(14,16);
    cd_FaxDate_Begin.setDate(new Date(y, m-1, 1), new Date(y, m-1, d));
    cd_FaxDate_End.setDate(new Date(yy, mm-1, 1), new Date(yy, mm-1, dd));
    document.getElementById("lbl_FaxDateBegin").innerHTML = dtValueBeginLabel;
    document.getElementById("lbl_FaxDateEnd").innerHTML = dtValueEndLabel;
    document.all.HidFaxSearchDateBegin.value = y+m+d;
    document.all.HidFaxSearchDateEnd.value = yy+mm+dd;
}

function FastCalSel(SelectValue)
{
    var sTop = document.all;
    var dtValue, dtValueBeginLabel, dtValueEndLabel, y, m, d, yy, mm, dd;
    var dtValueSingle, dtValueSingleLabel;
    
    if (SelectValue != "1" && SelectValue != "2")
    {
        dtValue = eval('sTop.HidDateType'+SelectValue+'.value');
        dtValueBeginLabel = dtValue.substring(0,4) + "년 " + dtValue.substring(4,6) + "월 " + dtValue.substring(6,8) + "일";
        dtValueEndLabel = dtValue.substring(8,12) + "년 " + dtValue.substring(12,14) + "월 " + dtValue.substring(14,16) + "일";
    }
    else
    {
        dtValueSingle = eval('sTop.HidDateType'+SelectValue+'.value');
        dtValueSingleLabel = dtValueSingle.substring(0,4) + "년 " + dtValueSingle.substring(4,6) + "월 " + dtValueSingle.substring(6,8) + "일";
    }
    
    switch(SelectValue)
    {
        case "1":             //오늘
            y = sTop.HidDateType1.value.substring(0,4);
            m = sTop.HidDateType1.value.substring(4,6);
            d = sTop.HidDateType1.value.substring(6,8);
            cd_FaxDate_Begin.setDate(new Date(y, m-1, 1), new Date(y, m-1, d));
            cd_FaxDate_End.setDate(new Date(y, m-1, 1), new Date(y, m-1, d));
            document.getElementById("lbl_FaxDateBegin").innerHTML = dtValueSingleLabel;
            document.getElementById("lbl_FaxDateEnd").innerHTML = dtValueSingleLabel;
            document.all.HidFaxSearchDateBegin.value = y+m+d;
            document.all.HidFaxSearchDateEnd.value = y+m+d;
            break;
        case "2":             //전일
            y = sTop.HidDateType2.value.substring(0,4);
            m = sTop.HidDateType2.value.substring(4,6);
            d = sTop.HidDateType2.value.substring(6,8);
            cd_FaxDate_Begin.setDate(new Date(y, m-1, 1), new Date(y, m-1, d));
            cd_FaxDate_End.setDate(new Date(y, m-1, 1), new Date(y, m-1, d));
            document.getElementById("lbl_FaxDateBegin").innerHTML = dtValueSingleLabel;
            document.getElementById("lbl_FaxDateEnd").innerHTML = dtValueSingleLabel;
            document.all.HidFaxSearchDateBegin.value = y+m+d;
            document.all.HidFaxSearchDateEnd.value = y+m+d;
            break;
        default:
            SetFastCal(dtValue, dtValueBeginLabel, dtValueEndLabel);
            break;
    }
}

function onBeginDateChange(sender, selectedDate)
{
    var formattedDate;
    var dtValueBeginLabel;
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    dtValueBeginLabel = formattedDate.substring(0,4) + "년 " + formattedDate.substring(4,6) + "월 " + formattedDate.substring(6,8) + "일";
    document.getElementById("lbl_FaxDateBegin").innerHTML = dtValueBeginLabel;
    document.all.HidFaxSearchDateBegin.value = formattedDate;
}

function onEndDateChange(sender, selectedDate)
{
    var formattedDate;
    var dtValueEndLabel;
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    dtValueEndLabel = formattedDate.substring(0,4) + "년 " + formattedDate.substring(4,6) + "월 " + formattedDate.substring(6,8) + "일";
    document.getElementById("lbl_FaxDateEnd").innerHTML = dtValueEndLabel;
    document.all.HidFaxSearchDateEnd.value = formattedDate;
}

function FaxSearchOKClick()
{
    var sTop = document.all;
    var chkBoxFaxBox = false;
    var chkDateTime = false;
    var chkBoxString = "";
    
    try
    {
        for (var i=0;i<sTop.length;i++)
        {
            if (sTop.item(i).getAttribute("type") == "checkbox")
            {
                if (sTop.item(i).checked)
                {
                    chkBoxFaxBox = true;
                    break;
                }
            }
        }
        
        if (chkBoxFaxBox == false)
        {
            alert("검색하고자 하는 팩스함을 선택해 주세요.");
            return false;
        }
        else
        {
            if ((sTop.HidFaxSearchDateBegin.value != "") && (sTop.HidFaxSearchDateEnd.value != ""))
                chkDateTime = true;
                
            if (!chkDateTime)
            {
                alert("검색항목 및 검색기간을 설정해 주세요.");
                return false;
            }
            else
            {
                for (var i=0;i<sTop.length;i++)
                {
                    if (sTop.item(i).getAttribute("type") == "checkbox")
                    {
                        if (sTop.item(i).checked)
                        {
                            chkBoxString += sTop.item(i).id + ";";
                        }
                    }
                }

                sTop.HidCheckFaxBox.value = chkBoxString;
            }
        
            return true;
        }
    } 
    catch(e) 
    {
        return false;
    }
}

//팩스검색 창에서 취소버튼 Click
function FaxSearchCancelClick()
{
    self.window.close();
}

//팩스검색 창에서 확인버튼 Click
function FaxSearchSubmit()
{
    var sTop = document.all;

    //Cookie방식  
    window.opener.window.top.frames[0].FaxListFrame.frames[0].location.href = "FaxList_Search.aspx";
    opener.window.top.frames[0].FaxLeftFrame.frames[0].location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000006";
    window.close();
}

//팩스검색 창에서 확인버튼 Click
function FaxSearchSubmit_YYYY() {
    var sTop = document.all;

    //Cookie방식  
    window.opener.window.top.frames[0].FaxListFrame.frames[0].location.href = "FaxList_Search_YYYY.aspx";
    opener.window.top.frames[0].FaxLeftFrame.frames[0].location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000006";
    window.close();
}

function AllRemoveCookie() {

     var PermanentlyCookie = "FaxList_Search";
      
     var Semi = ";";
     var arrCookie = document.cookie.split(Semi);
     var arrCookieList = Array(arrCookie.length);

     for (var i = 0; i < arrCookie.length; i++)
     {
     
         var EndIndex = arrCookie[i].indexOf("=");
         if (EndIndex < 0) EndIndex = arrCookie[i].length;

         arrCookieList[i] = Replace(arrCookie[i].substr(0, EndIndex), " ", ""); 
     }

     for (var i = arrCookieList.length - 1; i >= 0; i--) {
         if (PermanentlyCookie == arrCookieList[i]) 
         {      
            deleteCookie(arrCookieList[i]);
            break;
         }
     }
 }

 function deleteCookie(CookieName) {

     var expireDate = new Date();

     //어제 날짜를 쿠키 소멸 날짜로 설정한다.;
     expireDate.setDate(expireDate.getDate() - 1);
     document.cookie = CookieName + "=" + "; expires=" + expireDate.toGMTString() + "; path=/";
 }

function BtnNewFaxSendClick()
{
    if (document.all.HidMode.value == "Admin")
    {
        var conf = confirm("관리자화면에서 팩스보내기를 할 수 없습니다.\n사용자화면으로 이동 하시겠습니까?");
        if (conf)
        {
            window.top.location.href = "../Main.aspx";
            return false;
        }
        else
        {
            return false;
        }
    }
    
    var sTop = parent.frames[4].frames[0];
    var strSessionKey = document.all.HidSessionKey.value;
    
    sTop.document.getElementById("AX").RunProgram("","","","",strSessionKey,"NewFAX");
}

function BtnNewInternetFaxSendClick()
{
    if (document.all.HidMode.value == "Admin")
    {
        var conf = confirm("관리자화면에서 팩스보내기를 할 수 없습니다.\n사용자화면으로 이동 하시겠습니까?");
        if (conf)
        {
            window.top.location.href = "../Main.aspx";
            return false;
        }
        else
        {
            return false;
        }
    }
    
    var sTop = parent.frames[4].frames[0];
    var strSessionKey = document.all.HidSessionKey.value;
    
    sTop.document.getElementById("AX").RunProgram("","","","",strSessionKey,"NewInternetFAX");
}

//FaxTop에서 주소록 Click
function BtnAddrClick()
{
    if (document.all.HidMode.value == "Admin")
    {
        var conf = confirm("관리자화면에서 주소록 조회를 할 수 없습니다.\n사용자화면으로 이동 하시겠습니까?");
        if (conf)
        {
            window.top.location.href = "../Main.aspx";
            return false;
        }
        else
        {
            return false;
        }
    }

    var sTop = parent.parent.parent;

    var iWidth = 970;
    var iHeight = 650;
    
    var thisX = sTop.document.body.clientWidth;
    var thisY = sTop.document.body.clientHeight;
    
    var xx = (thisX/2) - (iWidth/2)
    var yy = (thisY/2) - (iHeight/2)
    
    var FaxAddrWin = window.open("Fax_Personer_Addr.aspx", "FaxAddr", "left="+xx+",top="+yy+",width="+iWidth+",height="+iHeight+", scrollbars=no,menubar=no,resizable=no");
    FaxAddrWin.focus();
}

function BtnGlobalShareSendClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var Param;
    var GlobalShareSendFaxKey;
    var SelectValue = FaxListCheckValue();
    var FaxSendService;

    if (SelectValue.length == 0)
    {
        alert("보낼 팩스를 선택해 주세요.");
        return false;
    }
    else
    {
        sTop.HidSelectedFax.value = SelectValue;
        FaxSendService = document.getElementById("HidFaxSendService").value;
        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + " 개의 공유팩스를 보내시겠습니까?\n\n※ 여러개의 공유팩스를 선택하시면 선택한 개수 만큼 팩스가 발송 됩니다.");
        {
            if (conf) 
            {
                var IsReSend = IsOverDailySendFax(intCount);
                
                if(IsReSend)
                {
                    var sAX = parent.parent.frames[4].frames[0];
                    var strFaxBoxKey = document.all.HidFaxBoxKey.value;
                    var strFaxKey = Replace(sTop.HidSelectedFax.value, "FaxKey_", "");
                    var strSessionKey = document.all.HidSessionKey.value;          
                   
                    if (FaxSendService.indexOf('11') > -1) //인터넷으로 보내기
                    {
                        strSessionKey = strSessionKey + "_internet";
                    }
                    else if (FaxSendService.indexOf('12') > -1) //미니로 보내기
                    {
                        strSessionKey = strSessionKey + "_mini"
                    }
                    sAX.document.getElementById("AX").RunProgram("", "", "", strFaxBoxKey, strFaxKey, strSessionKey);     
                }
                else
                {
                    DailySendFaxOverPopUp();
                }
            }
        }
    }
}


function BtnAddGlobalFax()
{
    var sTop=document.all;
    var strSessionKey = document.all.HidSessionKey.value;        
    var strFaxBoxKey = document.all.HidFaxBoxKey.value;
    var sAX = parent.parent.frames[4].frames[0];
    var FaxSendService;
    
    sAX.document.getElementById("AX").RunProgram("","","","",strSessionKey,"SHARE");
	
    return false;
}


//Modify : 2013-12-16 guagua 연도Table
function BtnReceiveSendClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var Param;
    var ReceiveSendFaxKey;
    var SelectValue = FaxListCheckValue();
    var FaxSendService;

    if (SelectValue.length == 0)
    {
        alert("보낼 팩스를 선택해 주세요.\n\n[알림] 보낼 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else
    {
        sTop.HidSelectedFax.value = SelectValue;
        FaxSendService = document.getElementById("HidFaxSendService").value;
        intCount = SelectFaxCount(sTop.HidSelectedFax.value);
        
        var conf = confirm(intCount.toString() + " 개의 받은팩스를 보내시겠습니까?\n\n※ 여러개의 받은팩스를 선택하시면 선택한 개수 만큼 팩스가 발송 됩니다.");
        {
            if (conf) {
                var IsReSend = IsOverDailySendFax(intCount);
                
                if (IsReSend)
                {
                    var sAX = parent.parent.frames[4].frames[0];
                    var strFaxBoxKey = document.all.HidFaxBoxKey.value;
                    var strFaxKey = Replace(sTop.HidSelectedFax.value, "FaxKey_", "");
                    var strSessionKey = document.all.HidSessionKey.value;
                    var strrYear = "";
                    if (document.getElementById("HidrYear") != null) {
                        strrYear = document.all.HidrYear.value;
                    }
                    
                    if (FaxSendService.indexOf('11') > -1) //인터넷으로 보내기
                    {
                        strSessionKey = strSessionKey + "_internet";
                        if (strrYear.length == 4) {
                            strSessionKey += "_" + strrYear;
                        }
                    }
                    else if (FaxSendService.indexOf('12') > -1) //미니로 보내기
                    {
                        strSessionKey = strSessionKey + "_mini"
                        if (strrYear.length == 4) {
                            strSessionKey += "_" + strrYear;
                        }
                    }
                    sAX.document.getElementById("AX").RunProgram("", "", "", strFaxBoxKey, strFaxKey, strSessionKey);
                }
                else
                {
                    DailySendFaxOverPopUp();
                }
            }
        }
    }
}

function AdminModifyOpen()
{
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var winTop;

    winTop = parent.parent.parent;

    iWidth = 320;
    iHeight = 330;
    
    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;
    
    xx = (thisX/2) - (iWidth/2)
    yy = (thisY/2) - (iHeight/2)

    var win_notice = window.open("../WebFax/AdminModify.aspx", "AdminModify", "left="+xx+",top="+yy+",width="+iWidth+",height="+iHeight+", scrollbars=no,menubar=no,resizable=no");
    win_notice.focus();
}

function UserModifyOpen()
{
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var winTop;

    winTop = parent.parent.parent;

    iWidth = 500;
    iHeight = 380;
    
    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;
    
    xx = (thisX/2) - (iWidth/2)
    yy = (thisY/2) - (iHeight/2)

    var win_notice = window.open("../WebFax/UserModify.aspx", "UserModify", "left="+xx+",top="+yy+",width="+iWidth+",height="+iHeight+", scrollbars=no,menubar=no,resizable=no");
    win_notice.focus();
}

function KTSafeFaxNoticeOpen()
{
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var winTop;

    winTop = parent.parent.parent;

    iWidth = 800;
    iHeight = 600;
    
    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;
    
    xx = (thisX/2) - (iWidth/2)
    yy = (thisY/2) - (iHeight/2)

    var win_notice = window.open("../WebFax/FaxNotice.aspx", "FaxNotice", "left="+xx+",top="+yy+",width="+iWidth+",height="+iHeight+", scrollbars=no,menubar=no,resizable=yes");
    win_notice.focus();
}

function NoticeListClick(NoticeKey)
{
    location.href = "FaxNoticeView.aspx?NoticeKey="+NoticeKey+"&Page="+document.all.HidPage.value;
}

function FaxNoticeFileDownload(FileKey, OrgFileName)
{
    NoticeFileDownloadFrame.location.href = "FaxNoticeFileDownload.aspx?FileKey="+FileKey+"&OrgFileName="+OrgFileName;
}

//Modify : 2013-12-16 guagua 연도Table
function FaxImageLockPassInput(FaxKey, FaxFileKey, BoxKey, rYear) {
    var strUrl = "ModalFrame.aspx?ModalParam=FaxImageLockPass.aspx?FaxKey=" + FaxKey + "_FaxFileKey=" + FaxFileKey + "_BoxKey=" + BoxKey + "_rYear=" + rYear;
    var RetValue = showModalDialog(strUrl, "", "dialogWidth:400px;dialogHeight:200px;toolbar=0;location=0;directories=0;status=0;menuBar=0;scrollBars=0;resizable=0;help=no;");
    var strFileName;

    if ((typeof RetValue != "undefined") && (RetValue != "")) {
        if (RetValue == 1) {
            location.href = "FaxView.aspx?rYear=" + rYear + "&FaxKey=" + FaxKey + "&FaxFileKey=" + FaxFileKey + "&BoxKey=" + BoxKey;
        }
        else if (RetValue == 2) {
            switch (BoxKey) {
                case "F0000000000000000000000000000001":
                    strFileName = "FaxList_Receive.aspx";
                    break;
                case "F0000000000000000000000000000002":
                    strFileName = "FaxList_Reservation.aspx";
                    break;
                case "F0000000000000000000000000000003":
                    strFileName = "FaxList_Send.aspx";
                    break;
                case "F0000000000000000000000000000004":
                    strFileName = "FaxList_Delete.aspx";
                    break;
                case "F0000000000000000000000000000005":
                    strFileName = "FaxList_GlobalShared.aspx";
                    break;
                case "F0000000000000000000000000000006":
                    strFileName = "FaxList_Search.aspx";
                    break;
                case "F0000000000000000000000000000008":
                    strFileName = "FaxList_Reg.aspx";
                    break;
                default:
                    strFileName = "FaxList_UserBox.aspx?BoxKey=" + BoxKey;
                    break;
            }

            parent.parent.frames[3].frames[0].location.href = strFileName;
            location.href = "FaxView.aspx?FaxKey=" + FaxKey + "&FaxFileKey=" + FaxFileKey + "&BoxKey=" + BoxKey;
        }
        else {
            return;
        }
    }
}

function FaxLockPassClose()
{
    window.returnValue = 0;
    self.close();
}

function FaxLockCancel()
{
    if (document.all.tBox_LoginPass.value == "")
    {
        alert("비밀번호를 입력해 주세요.");
        document.all.tBox_LoginPass.focus();
        return false;
    }
    else
    {
        return true;
    }
}

function FaxLockPass()
{
    if (document.all.tBox_LoginPass.value == "")
    {
        alert("비밀번호를 입력해 주세요.");
        document.all.tBox_LoginPass.focus();
        return false;
    }
    else
    {
        return true;
    }
}

function FaxLockPassKeyDown()
{
    if (event.keyCode == 13)
    {
        if (document.all.tBox_LoginPass.value == "")
        {
            alert("비밀번호를 입력해 주세요.");
            document.all.tBox_LoginPass.focus();
            return false;
        }
        else
        {
            __doPostBack("ib_FaxSearchOK");
        }
    }
}
function KTSafeFaxUserConfig() {
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var winTop;

    winTop = parent.parent.parent.parent;

    iWidth = 800;
    iHeight = 685;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = ((thisY / 2) - (iHeight / 2) )

    var win_notice = window.open("../WebFax/FaxUserConfig.aspx", "FaxNotice", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=yes");
    win_notice.focus();
}

function rbtn_Click() {
    var rBtn_pub = document.getElementById("rbtn_Search_pub");
    var rBtn_outlook = document.getElementById("rbtn_Search_outlook");
    var rBtn_total = document.getElementById("rbtn_Search_total");
    var drop_list = document.getElementById("drp_SearchDistance");
    if (rBtn_pub.checked == true) {
        drop_list.disabled = false;
    }
    if (rBtn_outlook.checked == true) {
        drop_list.disabled = true;
    }
    if (rBtn_total.checked == true) {
        drop_list.disabled = true;
    }
}

function ViewReceiveBoxCalendar()
{
    var sTop = document.all;
    if (sTop.FaxCalendar.style.display == "none")
        sTop.FaxCalendar.style.display = "inline";
    else
        sTop.FaxCalendar.style.display = "none";

    var begindate_y = document.all.HidCalendarDate.value.substring(0,4);
    var begindate_m = parseInt(document.all.HidCalendarDate.value.substring(4,6), 10);
    var begindate_d = parseInt(document.all.HidCalendarDate.value.substring(6,8), 10);

    var enddate_y = document.all.HidCalendarDate.value.substring(8,12);
    var enddate_m = parseInt(document.all.HidCalendarDate.value.substring(12,14), 10);
    var enddate_d = parseInt(document.all.HidCalendarDate.value.substring(14,16), 10);

    cd_FaxDate_Begin.setDate(new Date(begindate_y, begindate_m-1, 1), new Date(begindate_y, begindate_m-1, begindate_d));
    cd_FaxDate_End.setDate(new Date(enddate_y, enddate_m-1, 1), new Date(enddate_y, enddate_m-1, enddate_d));
}

function onReceiveBoxBeginDateChange(sender, selectedDate)
{
    var formattedDate;
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    document.all.CalendarSelectBeginDate.value = formattedDate;
}

function onReceiveBoxEndDateChange(sender, selectedDate)
{
    var ViewDate;
    var formattedDate;
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    document.all.CalendarSelectEndDate.value = formattedDate;

    if ((document.all.CalendarSelectBeginDate.value == "") || (document.all.CalendarSelectBeginDate.value == "null"))
    {
        alert("조회시작일을 선택해 주세요.");
        return;
    }
    if ((document.all.CalendarSelectEndDate.value == "") || (document.all.CalendarSelectEndDate.value == "null"))
    {
        alert("조회종료일을 선택해 주세요.");
        return;
    }
    else
    {
        ViewDate = document.all.CalendarSelectBeginDate.value + document.all.CalendarSelectEndDate.value;
        location.href = "FaxList_Receive.aspx?ViewDate="+ViewDate+"&ListPage=1";
    }
}

function onReceiveYYYYBoxBeginDateChange(sender, selectedDate) {
    var formattedDate;
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    document.all.CalendarSelectBeginDate.value = formattedDate;
}

function onReceiveYYYYBoxEndDateChange(sender, selectedDate) {
    var ViewDate;
    var formattedDate;
    var strrYear = "";

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }

    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    document.all.CalendarSelectEndDate.value = formattedDate;

    if ((document.all.CalendarSelectBeginDate.value == "") || (document.all.CalendarSelectBeginDate.value == "null")) {
        alert("조회시작일을 선택해 주세요.");
        return;
    }
    if ((document.all.CalendarSelectEndDate.value == "") || (document.all.CalendarSelectEndDate.value == "null")) {
        alert("조회종료일을 선택해 주세요.");
        return;
    }
    else {
        ViewDate = document.all.CalendarSelectBeginDate.value + document.all.CalendarSelectEndDate.value;
        location.href = "FaxList_Receive_YYYY.aspx?rYear=" + strrYear + "&ViewDate=" + ViewDate + "&ListPage=1";
    }
}

function ViewSendBoxCalendar()
{
    var sTop = document.all;
    if (sTop.FaxCalendar.style.display == "none")
        sTop.FaxCalendar.style.display = "inline";
    else
        sTop.FaxCalendar.style.display = "none";

    var begindate_y = document.all.HidCalendarDate.value.substring(0,4);
    var begindate_m = parseInt(document.all.HidCalendarDate.value.substring(4,6), 10);
    var begindate_d = parseInt(document.all.HidCalendarDate.value.substring(6,8), 10);

    var enddate_y = document.all.HidCalendarDate.value.substring(8,12);
    var enddate_m = parseInt(document.all.HidCalendarDate.value.substring(12,14), 10);
    var enddate_d = parseInt(document.all.HidCalendarDate.value.substring(14,16), 10);

    cd_FaxDate_Begin.setDate(new Date(begindate_y, begindate_m-1, 1), new Date(begindate_y, begindate_m-1, begindate_d));
    cd_FaxDate_End.setDate(new Date(enddate_y, enddate_m-1, 1), new Date(enddate_y, enddate_m-1, enddate_d));
}

function onSendBoxBeginDateChange(sender, selectedDate)
{
    var formattedDate;
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    document.all.CalendarSelectBeginDate.value = formattedDate;
}

function onSendBoxEndDateChange(sender, selectedDate)
{
    var ViewDate;
    var formattedDate;
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    document.all.CalendarSelectEndDate.value = formattedDate;
    
    if ((document.all.CalendarSelectBeginDate.value == "") || (document.all.CalendarSelectBeginDate.value == "null"))
    {
        alert("조회시작일을 선택해 주세요.");
        return;
    }
    if ((document.all.CalendarSelectEndDate.value == "") || (document.all.CalendarSelectEndDate.value == "null"))
    {
        alert("조회종료일을 선택해 주세요.");
        return;
    }
    else
    {
        ViewDate = document.all.CalendarSelectBeginDate.value + document.all.CalendarSelectEndDate.value;
        location.href = "FaxList_Send.aspx?ViewDate="+ViewDate+"&ListPage=1";
    }
}

function onSendBoxYYYYBeginDateChange(sender, selectedDate) {
    var formattedDate;
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    document.all.CalendarSelectBeginDate.value = formattedDate;
}

function onSendBoxYYYYEndDateChange(sender, selectedDate) {
    var ViewDate;
    var formattedDate;
    var strrYear = "";

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }
    
    formattedDate = sender.formatDate(selectedDate, "yyyyMMdd");
    document.all.CalendarSelectEndDate.value = formattedDate;

    if ((document.all.CalendarSelectBeginDate.value == "") || (document.all.CalendarSelectBeginDate.value == "null")) {
        alert("조회시작일을 선택해 주세요.");
        return;
    }
    if ((document.all.CalendarSelectEndDate.value == "") || (document.all.CalendarSelectEndDate.value == "null")) {
        alert("조회종료일을 선택해 주세요.");
        return;
    }
    else {
        ViewDate = document.all.CalendarSelectBeginDate.value + document.all.CalendarSelectEndDate.value;
        location.href = "FaxList_Send_YYYY.aspx?rYear=" + strrYear + "&ViewDate=" + ViewDate + "&ListPage=1";
    }
}

function rbtn_Click() {
    var rBtn_pub = document.getElementById("rbtn_Search_pub");
    var rBtn_outlook = document.getElementById("rbtn_Search_outlook");
    var rBtn_total = document.getElementById("rbtn_Search_total");
 
    var drop_list = document.getElementById("drp_SearchDistance");
    if (rBtn_pub.checked == true) {
        drop_list.disabled = false;
    }
    if (rBtn_outlook.checked == true) {
        drop_list.disabled = true;
    }
    if (rBtn_total.checked == true) {
        drop_list.disabled = true;
    }
}

function User_Config_Close() {
    var result = confirm("취소 하시겠습니까?");

    if (result == true) {
        self.window.close();
    }
    else {
        return false;
    }


}

function User_Config_Submit() {
    return true;
}

function AutoTextMouseOver(id_left, id_bg, id_right)
{
    document.getElementById(id_left).src = "../Images/ib_autotext_over_left.gif";
    document.getElementById(id_right).src = "../Images/ib_autotext_over_right.gif";
    document.getElementById(id_bg).style.backgroundImage = "url('../Images/ib_autotext_over_bg.gif')";
    return false;
}

function AutoTextMouseOut(id_left, id_bg, id_right)
{
    document.getElementById(id_left).src = "../Images/ib_autotext_left.gif";
    document.getElementById(id_right).src = "../Images/ib_autotext_right.gif";
    document.getElementById(id_bg).style.backgroundImage = "url('../Images/ib_autotext_bg.gif')";
    return false;
}

function AutoTextClick(AutoTextKey)
{
    var sTop = document.all;
    sTop.tBox_Subject.value = document.getElementById(AutoTextKey).outerText;
}

function AdminModifySaveClick()
{
    var sTop = document.all;

    if (sTop.tBox_OldAdminPW.value == "")
    {
        alert("이전 비밀번호를 입력해 주세요.");
        sTop.tBox_OldAdminPW.focus();
        return false;
    }
    if (sTop.tBox_AdminPW.value == "")
    {
        alert("변경 비밀번호를 입력해 주세요.");
        sTop.tBox_AdminPW.focus();
        return false;
    }
    if (sTop.tBox_AdminPW.value.length < 4)
    {
        alert("비밀번호는 4자이상 사용해 주세요.");
        sTop.tBox_AdminPW.focus();
        return false;
    }
    if (sTop.tBox_AdminPW_RE.value == "")
    {
        alert("비밀번호 확인을 입력해 주세요.");
        sTop.tBox_AdminPW_RE.focus();
        return false;
    }
    if (sTop.tBox_AdminPW.value != sTop.tBox_AdminPW_RE.value)
    {
        alert("변경 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        sTop.tBox_AdminPW.focus();
        return false;
    }
    else
    {
        return true;
    }
}

function AdminModifyDivClose()
{
    self.window.close();    
}

function GotoAdminServiceInfo()
{
    parent.frames[1].location.href = "FaxAdmin_ServiceInfo.aspx";
}

//Modify : 2013-12-16 guagua 연도Table
function BtnSendBoxSendClick()
{
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var Param;
    var GlobalShareSendFaxKey;
    var SelectValue = FaxListCheckValue();
    var FaxSendService;
    var strrYear = "";

    if (SelectValue.length == 0)
    {
        alert("보낼 팩스를 선택해 주세요.");
        return false;
    }
    else {
        if (document.getElementById("HidrYear") != null) {
            strrYear = document.all.HidrYear.value;
        }

        sTop.HidSelectedFax.value = SelectValue;
        
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "jobflag=IsFaxLock&rYear="+strrYear+"&FaxKey="+sTop.HidSelectedFax.value+"&BoxKey="+document.all.HidFaxBoxKey.value;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (ReturnValue != "1")
        {
            alert("보내고자 하는 팩스 중 잠김상태의 팩스가 있으면 팩스를 발송 할 수 없습니다.");
            return false;
        }
        
        FaxSendService = document.getElementById("HidFaxSendService").value;
        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + " 개의 팩스를 보내시겠습니까?\n\n※ 여러개의 팩스를 선택하시면 선택한 개수 만큼 팩스가 발송 됩니다.");
        {
            if (conf) {
                var IsReSend = IsOverDailySendFax(intCount);
                
                if(IsReSend)
                {
                    var sAX = parent.parent.frames[4].frames[0];
                    var strFaxBoxKey = document.all.HidFaxBoxKey.value;
                    var strFaxKey = Replace(sTop.HidSelectedFax.value, "FaxKey_", "");
                    var strSessionKey = document.all.HidSessionKey.value;
                             
                    if (FaxSendService.indexOf('11') > -1) //인터넷으로 보내기
                    {
                        strSessionKey = strSessionKey + "_internet";
                        if (strrYear.length == 4) {
                            strSessionKey += "_" + strrYear;
                        }
                    }
                    else if (FaxSendService.indexOf('12') > -1) //미니로 보내기
                    {
                        strSessionKey = strSessionKey + "_mini"
                        if (strrYear.length == 4) {
                            strSessionKey += "_" + strrYear;
                        }
                    }
                    sAX.document.getElementById("AX").RunProgram("", "", "", strFaxBoxKey, strFaxKey, strSessionKey);      
                }
                else
                {
                    DailySendFaxOverPopUp();
                }          
            } 
        }
    }
}

function FaxListSort(rType, BoxType, BoxKey) {
    var sType = document.all.HidSortType.value;
    if (sType == "Asc") sType = "Desc";
    else if (sType == "Desc") sType = "Asc";
    else sType = "Desc";

    switch (BoxType) {
        case "ReceiveBox":
            location.href = "FaxList_Receive.aspx?SortValue=" + rType + "&SortType=" + sType + "&ViewDate=" + document.all.HidCalendarDate.value;
            break;
        case "ReservationBox":
            location.href = "FaxList_Reservation.aspx?SortValue=" + rType + "&SortType=" + sType;
            break;
        case "SendBox":
            location.href = "FaxList_Send.aspx?SortValue=" + rType + "&SortType=" + sType + "&ViewDate=" + document.all.HidCalendarDate.value;
            break;
        case "DeleteBox":
            location.href = "FaxList_Delete.aspx?SortValue=" + rType + "&SortType=" + sType;
            break;
        case "GlobalBox":
            location.href = "FaxList_GlobalShared.aspx?SortValue=" + rType + "&SortType=" + sType;
            break;
        case "UserBox":
            location.href = "FaxList_UserBox.aspx?BoxKey=" + BoxKey + "&SortValue=" + rType + "&SortType=" + sType;
            break;
        case "RegBox":
            location.href = "FaxList_Reg.aspx?BoxKey=" + BoxKey + "&SortValue=" + rType + "&SortType=" + sType;
            break;
    }
}

function FaxListSort_YYYY(rType, BoxType, BoxKey) {
    var sType = document.all.HidSortType.value;
    if (sType == "Asc") sType = "Desc";
    else if (sType == "Desc") sType = "Asc";
    else sType = "Desc";

    var strrYear = "";

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }
    
    switch (BoxType) {
        case "ReceiveBox":
            location.href = "FaxList_Receive_YYYY.aspx?rYear=" + strrYear + "&SortValue=" + rType + "&SortType=" + sType + "&ViewDate=" + document.all.HidCalendarDate.value;
            break;
        case "SendBox":
            location.href = "FaxList_Send_YYYY.aspx?rYear=" + strrYear + "&SortValue=" + rType + "&SortType=" + sType + "&ViewDate=" + document.all.HidCalendarDate.value;
            break;
    }
}

var FaxReSendDivTime;
function FaxReSendDivViewer() 
{
    clearTimeout(FaxReSendDivTime);

    var strFaxReSendtrimage;
    var FaxReSendSubTrImage;
    var FaxReSendSubTrSpace;
    var FaxReSendDiv;

    var FaxPayType = document.getElementById("HidFaxPayType").value;
    if (FaxPayType == "beforePay") 
    {
        strFaxReSendtrimage = "TrFaxResendbefore";
    }
    else if (FaxPayType == "afterPay")
    {
        strFaxReSendtrimage = "TrFaxResendafter";
    }
    FaxReSendSubTrImage = document.getElementById(strFaxReSendtrimage);
    FaxReSendSubTrImage.style.display = 'inline';    
    
    FaxReSendDiv = document.getElementById("DivFaxReSendType"); 
    FaxReSendDiv.style.display = 'inline';
    FaxReSendDiv.style.zIndex = '1';
}

function FaxReSendDivViewerClose() 
{
    if(document.getElementById("DivFaxReSendType")) {
        document.getElementById("DivFaxReSendType").style.display = 'none';
    }

}

function FaxReSendDivViewerOut() {
    FaxReSendDivTime = setTimeout('FaxReSendDivViewerClose()', 300);
}


function getBounds( obj ) { 
  var ret = new Object();

  if(document.all) { 
   var rect = obj.getBoundingClientRect(); 
   ret.left = rect.left + (document.documentElement.scrollLeft || document.body.scrollLeft); 
   ret.top = rect.top + (document.documentElement.scrollTop || document.body.scrollTop); 
   ret.width = rect.right - rect.left; 
   ret.height = rect.bottom - rect.top; 
  } 
  else { 
   var box = document.getBoxObjectFor(obj); 
   ret.left = box.x; 
   ret.top = box.y; 
   ret.width = box.width; 
   ret.height = box.height; 
  } 
  
  return ret; 
}


var FaxSendTypeViewerTime;
function FaxSendTypeViewer() {
    clearTimeout(FaxSendTypeViewerTime);
    
    var FaxSendTypeStyle = document.getElementById("DivFaxSendType");
    FaxSendTypeStyle.style.display = 'inline';
    FaxSendTypeStyle.style.zIndex = "1";
}

function FaxSendTypeViewerClose() {
    if (document.getElementById("DivFaxSendType") != null) {
        document.getElementById("DivFaxSendType").style.display = 'none';
    }
}

function FaxSendTypeViewerOut() {
    FaxSendTypeViewerTime = setTimeout("FaxSendTypeViewerClose()", 300);
}

function FaxSendTypeViewerClick(BoxType, clickType) {

    FaxSendTypeViewerClose();

    if (clickType.indexOf('internet') > -1) {
        document.getElementById("HidFaxSendService").value = "11";
    }
    else {
        document.getElementById("HidFaxSendService").value = "12";
    }

    switch (BoxType) {
        case "receiveBox":
            BtnReceiveSendClick();
            break;
        case "reservationBox":
            BtnReservationSendClick();
            break;
        case "sendBox":
            BtnSendBoxSendClick();
            break;
        case "globalSharedBox":
            BtnGlobalShareSendClick();
            break;
        case "userBox":
            BtnReSendClick();
            break;
        case "searchBox":
            BtnSearchSendClick();
            break;
        case "regBox":
            BtnRegBoxSendClick();
            break;
    }
}

function SendResult0Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult0.value;
    var SendResult0Style = document.getElementById("DivSendResult0").style;

    if (status == 'out' || status != "DivSendResult0")
        return;

    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);


    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult0Style.display = 'inline';
    SendResult0Style.top = TopMargin + "px";
    SendResult0Style.left = event.clientX - 285 + "px";
    SendResult0Style.position = "absolute";
    SendResult0Style.zIndex = "1";
    
}

function SendResult0ViewerClose() {
    var status = document.all.HidSendResult0.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult0").style.display = 'none';
}

function SendResult0ViewerOut() {
    viewTime = setTimeout("SendResult0ViewerClose()", 100);
}


function SendResult97Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult97.value;
    var SendResult97Style = document.getElementById("DivSendResult97").style;

    if (status == 'out' || status != "DivSendResult97")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult97Style.display = 'inline';
    SendResult97Style.top = TopMargin + "px";
    SendResult97Style.left = event.clientX - 285 + "px";
    SendResult97Style.position = "absolute";
    SendResult97Style.zIndex = "1";
}

function SendResult97ViewerClose() {
    var status = document.all.HidSendResult97.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult97").style.display = 'none';
}

function SendResult97ViewerOut() {
    viewTime = setTimeout("SendResult97ViewerClose()", 100);
}



function SendResult98Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult98.value;
    var SendResult98Style = document.getElementById("DivSendResult98").style;

    if (status == 'out' || status != "DivSendResult98")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult98Style.display = 'inline';
    SendResult98Style.top = TopMargin + "px";
    SendResult98Style.left = event.clientX - 285 + "px";
    SendResult98Style.position = "absolute";
    SendResult98Style.zIndex = "1";
}

function SendResult98ViewerClose() {
    var status = document.all.HidSendResult98.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult98").style.display = 'none';
}

function SendResult98ViewerOut() {
    viewTime = setTimeout("SendResult98ViewerClose()", 100);
}


function SendResult99Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult99.value;
	var SendResult99Style = document.getElementById("DivSendResult99").style;

	if ( status == 'out' || status != "DivSendResult99" )
		return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;
		
	clearTimeout(viewTime);
	SendResult99Style.display = 'inline';
	SendResult99Style.top = TopMargin + "px";
	SendResult99Style.left = event.clientX - 285 + "px";
	SendResult99Style.position = "absolute";
	SendResult99Style.zIndex = "1";
}

function SendResult99ViewerClose()
{
	var status = document.all.HidSendResult99.value;
	if ( status != 'out' )
		return;
	document.getElementById("DivSendResult99").style.display='none';
}

function SendResult99ViewerOut()
{
	viewTime = setTimeout("SendResult99ViewerClose()",100);
}

function SendResult100Viewer()
{
    var viewTime = null;
    var DivHeight = 115;
    var TopMargin;
    var status = document.all.HidSendResult100.value;
	var SendResult100Style = document.getElementById("DivSendResult100").style;

	if ( status == 'out' || status != "DivSendResult100" )
		return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;
		
	clearTimeout(viewTime);
	SendResult100Style.display = 'inline';
	SendResult100Style.top = TopMargin + "px";
	SendResult100Style.left = event.clientX - 285 + "px";
	SendResult100Style.position = "absolute";
	SendResult100Style.zIndex = "1";
}

function SendResult100ViewerClose()
{
	var status = document.all.HidSendResult100.value;
	if ( status != 'out' )
		return;
	document.getElementById("DivSendResult100").style.display='none';
}

function SendResult100ViewerOut()
{
	viewTime = setTimeout("SendResult100ViewerClose()",100);
}

function SendResult101Viewer() {
    var viewTime = null;
    var DivHeight = 79;
    var TopMargin;
    var status = document.all.HidSendResult101.value;
    var SendResult101Style = document.getElementById("DivSendResult101").style;
    
    if(status == 'out' || status != "DivSendResult101")
        return;
        
    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);
    
    if(parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;
        
    clearTimeout(viewTime);
    SendResult101Style.display = 'inline';
    SendResult101Style.top = TopMargin + "px";
    SendResult101Style.left = event.clientX - 285 + "px";
    SendResult101Style.position = "absolute";
    SendResult101Style.zIndex = "1";
}

function SendResult101ViewerClose() {
    var status = document.all.HidSendResult101.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult101").style.display = 'none';
}

function SendResult101ViewerOut() {
    viewTime = setTimeout("SendResult101ViewerClose()", 100);
}

function SendResult102Viewer() {
    var viewTime = null;
    var DivHeight = 79;
    var TopMargin;
    var status = document.all.HidSendResult102.value;
    var SendResult102Style = document.getElementById("DivSendResult102").style;
    
    if(status == 'out' || status != "DivSendResult102")
        return;
        
    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);
    
    if(parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;
        
    clearTimeout(viewTime);
    SendResult102Style.display = 'inline';
    SendResult102Style.top = TopMargin + "px";
    SendResult102Style.left = event.clientX - 285 + "px";
    SendResult102Style.position = "absolute";
    SendResult102Style.zIndex = "1";
}

function SendResult102ViewerClose() {
    var status = document.all.HidSendResult102.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult102").style.display = 'none';
}

function SendResult102ViewerOut() {
    viewTime = setTimeout("SendResult102ViewerClose()", 100);
}

function SendResult200Viewer() {
    var viewTime = null;
    var DivHeight = 79;
    var TopMargin;
    var status = document.all.HidSendResult200.value;
    var SendResult200Style = document.getElementById("DivSendResult200").style;

    if (status == 'out' || status != "DivSendResult200")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult200Style.display = 'inline';
    SendResult200Style.top = TopMargin + "px";
    SendResult200Style.left = event.clientX - 285 + "px";
    SendResult200Style.position = "absolute";
    SendResult200Style.zIndex = "1";
}

function SendResult200ViewerClose() {
    var status = document.all.HidSendResult200.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult200").style.display = 'none';
}

function SendResult200ViewerOut() {
    viewTime = setTimeout("SendResult200ViewerClose()", 100);
}


function SendResult300Viewer() {
    var viewTime = null;
    var DivHeight = 79;
    var TopMargin;
    var status = document.all.HidSendResult300.value;
    var SendResult300Style = document.getElementById("DivSendResult300").style;

    if (status == 'out' || status != "DivSendResult300")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult300Style.display = 'inline';
    SendResult300Style.top = TopMargin + "px";
    SendResult300Style.left = event.clientX - 285 + "px";
    SendResult300Style.position = "absolute";
    SendResult300Style.zIndex = "1";
}

function SendResult300ViewerClose() {
    var status = document.all.HidSendResult300.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult300").style.display = 'none';
}

function SendResult300ViewerOut() {
    viewTime = setTimeout("SendResult300ViewerClose()", 100);
}


function SendResult2001Viewer() {
    var viewTime = null;
    var DivHeight = 79;
    var TopMargin;
    var status = document.all.HidSendResult2001.value;
    var SendResult2001Style = document.getElementById("DivSendResult2001").style;

    if (status == 'out' || status != "DivSendResult2001")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);
    
    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2001Style.display = 'inline';
    SendResult2001Style.top = TopMargin + "px";
    SendResult2001Style.left = event.clientX - 285 + "px";
    SendResult2001Style.position = "absolute";
    SendResult2001Style.zIndex = "1";
}

function SendResult2001ViewerClose() {
    var status = document.all.HidSendResult2001.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2001").style.display = 'none';
}

function SendResult2001ViewerOut() {
    viewTime = setTimeout("SendResult2001ViewerClose()", 100);
}

function SendResult2016Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2016.value;
    var SendResult2016Style = document.getElementById("DivSendResult2016").style;

    if (status == 'out' || status != "DivSendResult2016")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);
    
    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2016Style.display = 'inline';
    SendResult2016Style.top = TopMargin + "px";
    SendResult2016Style.left = event.clientX - 285 + "px";
    SendResult2016Style.position = "absolute";
    SendResult2016Style.zIndex = "1";
}

function SendResult2016ViewerClose() {
    var status = document.all.HidSendResult2016.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2016").style.display = 'none';
}

function SendResult2016ViewerOut() {
    viewTime = setTimeout("SendResult2016ViewerClose()", 100);
}



function SendResult2017Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2017.value;
    var SendResult2017Style = document.getElementById("DivSendResult2017").style;

    if (status == 'out' || status != "DivSendResult2017")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2017Style.display = 'inline';
    SendResult2017Style.top = TopMargin + "px";
    SendResult2017Style.left = event.clientX - 285 + "px";
    SendResult2017Style.position = "absolute";
    SendResult2017Style.zIndex = "1";
}

function SendResult2017ViewerClose() {
    var status = document.all.HidSendResult2017.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2017").style.display = 'none';
}

function SendResult2017ViewerOut() {
    viewTime = setTimeout("SendResult2017ViewerClose()", 100);
}


function SendResult2018Viewer() {

    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2018.value;
	var SendResult2018Style = document.getElementById("DivSendResult2018").style;

	if ( status == 'out' || status != "DivSendResult2018" )
		return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;
		
	clearTimeout(viewTime);
	SendResult2018Style.display = 'inline';
	SendResult2018Style.top = TopMargin + "px";
	SendResult2018Style.left = event.clientX - 285 + "px";
	SendResult2018Style.position = "absolute";
	SendResult2018Style.zIndex = "1";
}

function SendResult2018ViewerClose()
{
	var status = document.all.HidSendResult2018.value;
	if ( status != 'out' )
		return;
	document.getElementById("DivSendResult2018").style.display='none';
}

function SendResult2018ViewerOut()
{
	viewTime = setTimeout("SendResult2018ViewerClose()",100);
}

function SendResult2019Viewer()
{
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2019.value;
	var SendResult2019Style = document.getElementById("DivSendResult2019").style;

	if ( status == 'out' || status != "DivSendResult2019" )
		return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;
		
	clearTimeout(viewTime);
	SendResult2019Style.display = 'inline';
	SendResult2019Style.top = TopMargin + "px";
	SendResult2019Style.left = event.clientX - 285 + "px";
	SendResult2019Style.position = "absolute";
	SendResult2019Style.zIndex = "1";
}

function SendResult2019ViewerClose()
{
	var status = document.all.HidSendResult2019.value;
	if ( status != 'out' )
		return;
	document.getElementById("DivSendResult2019").style.display='none';
}

function SendResult2019ViewerOut()
{
	viewTime = setTimeout("SendResult2019ViewerClose()",100);
}


function SendResult2021Viewer() {
    var viewTime = null;
    var DivHeight = 79;
    var TopMargin;
    var status = document.all.HidSendResult2021.value;
    var SendResult2021Style = document.getElementById("DivSendResult2021").style;

    if (status == 'out' || status != "DivSendResult2021")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2021Style.display = 'inline';
    SendResult2021Style.top = TopMargin + "px";
    SendResult2021Style.left = event.clientX - 285 + "px";
    SendResult2021Style.position = "absolute";
    SendResult2021Style.zIndex = "1";
}

function SendResult2021ViewerClose() {
    var status = document.all.HidSendResult2021.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2021").style.display = 'none';
}

function SendResult2021ViewerOut() {
    viewTime = setTimeout("SendResult2021ViewerClose()", 100);
}



function SendResult2027Viewer() {
    var viewTime = null;
    var DivHeight = 79;
    var TopMargin;
    var status = document.all.HidSendResult2027.value;
    var SendResult2027Style = document.getElementById("DivSendResult2027").style;

    if (status == 'out' || status != "DivSendResult2027")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2027Style.display = 'inline';
    SendResult2027Style.top = TopMargin + "px";
    SendResult2027Style.left = event.clientX - 285 + "px";
    SendResult2027Style.position = "absolute";
    SendResult2027Style.zIndex = "1";
}

function SendResult2027ViewerClose() {
    var status = document.all.HidSendResult2027.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2027").style.display = 'none';
}

function SendResult2027ViewerOut() {
    viewTime = setTimeout("SendResult2027ViewerClose()", 100);
}




function SendResult2041Viewer() {
    var viewTime = null;
    var DivHeight = 102;
    var TopMargin;
    var status = document.all.HidSendResult2041.value;
    var SendResult2041Style = document.getElementById("DivSendResult2041").style;

    if (status == 'out' || status != "DivSendResult2041")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2041Style.display = 'inline';
    SendResult2041Style.top = TopMargin + "px";
    SendResult2041Style.left = event.clientX - 285 + "px";
    SendResult2041Style.position = "absolute";
    SendResult2041Style.zIndex = "1";
}

function SendResult2041ViewerClose() {
    var status = document.all.HidSendResult2041.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2041").style.display = 'none';
}

function SendResult2041ViewerOut() {
    viewTime = setTimeout("SendResult2041ViewerClose()", 100);
}


function SendResult2104Viewer() {
    var viewTime = null;
    var DivHeight = 79;
    var TopMargin;
    var status = document.all.HidSendResult2104.value;
	var SendResult2104Style = document.getElementById("DivSendResult2104").style;

	if ( status == 'out' || status != "DivSendResult2104" )
		return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

	clearTimeout(viewTime);
	SendResult2104Style.display = 'inline';
	SendResult2104Style.top = TopMargin + "px";
	SendResult2104Style.left = event.clientX - 285 + "px";
	SendResult2104Style.position = "absolute";
	SendResult2104Style.zIndex = "1";
}

function SendResult2104ViewerClose()
{
	var status = document.all.HidSendResult2104.value;
	if ( status != 'out' )
		return;
	document.getElementById("DivSendResult2104").style.display='none';
}

function SendResult2104ViewerOut()
{
	viewTime = setTimeout("SendResult2104ViewerClose()",100);
}

function SendResult2109Viewer()
{
    var viewTime = null;
    var DivHeight = 102;
    var TopMargin;
    var status = document.all.HidSendResult2109.value;
	var SendResult2109Style = document.getElementById("DivSendResult2109").style;

	if ( status == 'out' || status != "DivSendResult2109" )
		return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;
		
	clearTimeout(viewTime);
	SendResult2109Style.display = 'inline';
	SendResult2109Style.top = TopMargin + "px";
	SendResult2109Style.left = event.clientX - 285 + "px";
	SendResult2109Style.position = "absolute";
	SendResult2109Style.zIndex = "1";
}

function SendResult2109ViewerClose()
{
	var status = document.all.HidSendResult2109.value;
	if ( status != 'out' )
		return;
	document.getElementById("DivSendResult2109").style.display='none';
}

function SendResult2109ViewerOut()
{
	viewTime = setTimeout("SendResult2109ViewerClose()",100);
}


function SendResult2110Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2110.value;
    var SendResult2110Style = document.getElementById("DivSendResult2110").style;

    if (status == 'out' || status != "DivSendResult2110")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2110Style.display = 'inline';
    SendResult2110Style.top = TopMargin + "px";
    SendResult2110Style.left = event.clientX - 285 + "px";
    SendResult2110Style.position = "absolute";
    SendResult2110Style.zIndex = "1";
}

function SendResult2110ViewerClose() {
    var status = document.all.HidSendResult2110.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2110").style.display = 'none';
}

function SendResult2110ViewerOut() {
    viewTime = setTimeout("SendResult2110ViewerClose()", 100);
}

function SendResult2112Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2112.value;
	var SendResult2112Style = document.getElementById("DivSendResult2112").style;

	if ( status == 'out' || status != "DivSendResult2112" )
		return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;
		
	clearTimeout(viewTime);
	SendResult2112Style.display = 'inline';
	SendResult2112Style.top = TopMargin + "px";
	SendResult2112Style.left = event.clientX - 285 + "px";
	SendResult2112Style.position = "absolute";
	SendResult2112Style.zIndex = "1";
}

function SendResult2112ViewerClose()
{
	var status = document.all.HidSendResult2112.value;
	if ( status != 'out' )
		return;
	document.getElementById("DivSendResult2112").style.display='none';
}

function SendResult2112ViewerOut()
{
	viewTime = setTimeout("SendResult2112ViewerClose()",100);
}


function SendResult2163Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2163.value;
    var SendResult2163Style = document.getElementById("DivSendResult2163").style;

    if (status == 'out' || status != "DivSendResult2163")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2163Style.display = 'inline';
    SendResult2163Style.top = TopMargin + "px";
    SendResult2163Style.left = event.clientX - 285 + "px";
    SendResult2163Style.position = "absolute";
    SendResult2163Style.zIndex = "1";
}

function SendResult2163ViewerClose() {
    var status = document.all.HidSendResult2163.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2163").style.display = 'none';
}

function SendResult2163ViewerOut() {
    viewTime = setTimeout("SendResult2163ViewerClose()", 100);
}


function SendResult2991Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2991.value;
    var SendResult2991Style = document.getElementById("DivSendResult2991").style;

    if (status == 'out' || status != "DivSendResult2991")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2991Style.display = 'inline';
    SendResult2991Style.top = TopMargin + "px";
    SendResult2991Style.left = event.clientX - 285 + "px";
    SendResult2991Style.position = "absolute";
    SendResult2991Style.zIndex = "1";
}

function SendResult2991ViewerClose() {
    var status = document.all.HidSendResult2991.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2991").style.display = 'none';
}

function SendResult2991ViewerOut() {
    viewTime = setTimeout("SendResult2991ViewerClose()", 100);
}


function SendResult2992Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2992.value;
    var SendResult2992Style = document.getElementById("DivSendResult2992").style;

    if (status == 'out' || status != "DivSendResult2992")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2992Style.display = 'inline';
    SendResult2992Style.top = TopMargin + "px";
    SendResult2992Style.left = event.clientX - 285 + "px";
    SendResult2992Style.position = "absolute";
    SendResult2992Style.zIndex = "1";
}

function SendResult2992ViewerClose() {
    var status = document.all.HidSendResult2992.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2992").style.display = 'none';
}

function SendResult2992ViewerOut() {
    viewTime = setTimeout("SendResult2992ViewerClose()", 100);
}


function SendResult2993Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult2993.value;
    var SendResult2993Style = document.getElementById("DivSendResult2993").style;

    if (status == 'out' || status != "DivSendResult2993")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult2993Style.display = 'inline';
    SendResult2993Style.top = TopMargin + "px";
    SendResult2993Style.left = event.clientX - 285 + "px";
    SendResult2993Style.position = "absolute";
    SendResult2993Style.zIndex = "1";
}

function SendResult2993ViewerClose() {
    var status = document.all.HidSendResult2993.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult2993").style.display = 'none';
}

function SendResult2993ViewerOut() {
    viewTime = setTimeout("SendResult2993ViewerClose()", 100);
}

function SendResult1Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidSendResult1.value;
    var SendResult1Style = document.getElementById("DivSendResult1").style;

    if (status == 'out' || status != "DivSendResult1")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    SendResult1Style.display = 'inline';
    SendResult1Style.top = TopMargin + "px";
    SendResult1Style.left = event.clientX - 285 + "px";
    SendResult1Style.position = "absolute";
    SendResult1Style.zIndex = "1";
}

function SendResult1ViewerClose() {
    var status = document.all.HidSendResult1.value;
    if (status != 'out')
        return;
    document.getElementById("DivSendResult1").style.display = 'none';
}

function SendResult1ViewerOut() {
    viewTime = setTimeout("SendResult1ViewerClose()", 100);
}

//Modify : 2013-12-16 guagua 연도Table
function BtnSelectPrint() {
    var SelectValue = FaxListCheckValue();
    var sTop = document.all;
    var AryValue, AryFaxValue;
    var ActionFile, DatatoSend, ReturnValue;
    var strrYear = "";

    if (SelectValue.length == 0) {
        alert("인쇄 할 팩스를 선택해 주세요.\n\n[알림] 인쇄 할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }

    ActionFile = "AjaxFax.aspx";
    DatatoSend = "jobflag=IsFaxLock&rYear="+strrYear+"&FaxKey="+SelectValue+"&BoxKey="+document.all.HidFaxBoxKey.value;
    ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
    if (ReturnValue != "1")
    {
        alert("인쇄하고자 하는 팩스 중 잠김상태의 팩스가 있으면 선택인쇄를 할 수 없습니다.");
        return false;
    }
    
    AryValue = SelectValue.split(';');
    for (var i=0;i<AryValue.length-1;i++)
    {
        if (i > 0)
            AryFaxValue += ";" + Replace(AryValue[i],'FaxKey_','');
        else            
            AryFaxValue = Replace(AryValue[i],'FaxKey_','');
    }

    parent.parent.FaxViewFrame.FaxView.document.getElementById("AX").PrintImage(sTop.HidComKey.value, sTop.HidSessionKey.value, sTop.HidFaxBoxKey.value, AryFaxValue, sTop.HidServiceUrl.value, strrYear);
}

//인포미 다운로드
function InfomiDownLoad()
{
    location.href = "../public/CloudFAXSetup.exe";
}

function BtnReservationFaxAllDelete()
{
    var ActionFile, DatatoSend, ReturnValue;

    var conf = confirm("보낼팩스함의 모든 항목을 삭제 하시겠습니까?\n\n※ 송신중인 팩스는 삭제 시 제외 됩니다.\n※ 삭제 된 팩스는 지운팩스함으로 이동하게 됩니다.");
    if (conf)
    {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "jobflag=ReservationFaxAllRemove";
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
    }
    else
    {
    }
}

//원격지원서비스
function RemoteCall()
{
    window.open("http://1.244.116.142/DuzonKicom", "RemoteCall", "");
}

//UserConfig.aspx  Onload 시 컨트롤 활성화 여부 함수 호출
function SetControlByModeValue() {
    //사용자 정보 변경 비 활성화 
    var chk_UserModify = document.all.chk_UserModify;  
    chk_UserModify.checked=false;

    UserPWDisableByConfig();  
}






function BulkFaxStatusView(status) {
    var sTop = document.all;

    sTop.HidBulkSearchStatus.value = status;
    BulkFaxDetailListFrame.location.href = "BulkFaxDetailList.aspx?BulkKey=" + sTop.HidBulkKey.value + "&FaxStatus=" + status + " ";
}

//Create : 2013-12-16 guagua 연도Table
function BulkFaxStatusView_YYYY(status) {
    var sTop = document.all;
    var strrYear = sTop.HidrYear.value;
    sTop.HidBulkSearchStatus.value = status;
    BulkFaxDetailListFrame.location.href = "BulkFaxDetailList_YYYY.aspx?rYear=" + strrYear + "&BulkKey=" + sTop.HidBulkKey.value + "&FaxStatus=" + status + " ";
}

function BulkFaxDetailModify(BulkFaxKey, SendFaxNumber) {
    document.getElementById("BulkFaxDetail_SendFaxNumber_" + BulkFaxKey + "").innerHTML = "<input type='text' name='tBox_BulkFaxDetail_SendFaxNumber_" + BulkFaxKey + "' class='ControlStyle' size='15' value='" + SendFaxNumber + "'>";
    document.getElementById("BulkFaxDetail_SendFaxNumerButton_" + BulkFaxKey + "").innerHTML = "<a href=\"javascript:BulkFaxDetailModifySave('" + BulkFaxKey + "')\" class=\"FaxStatusCount\"><img src=\"../images/btn_bulkfaxsave.gif\" border=\"0\"></a>";
}

function BulkFaxDetailNotModify(statusName) {
    alert("[" + statusName + "]이므로 편집이 불가능 합니다.");
}
function BulkFaxDetailModifySave(BulkFaxKey) {
    var ActionFile, DatatoSend, ReturnValue;
    var SendFaxNumber;
    SendFaxNumber = eval("document.all.tBox_BulkFaxDetail_SendFaxNumber_" + BulkFaxKey + ".value");

    ActionFile = "AjaxFax.aspx";
    DatatoSend = "JobFlag=BulkFaxDetailModify&BulkFaxKey=" + BulkFaxKey + "&SendFaxNumber=" + SendFaxNumber;
    ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
    if (typeof ReturnValue != "undefined") {
        if (ReturnValue == "1") {
            document.getElementById("BulkFaxDetail_SendFaxNumber_" + BulkFaxKey + "").innerHTML = SendFaxNumber;
            document.getElementById("BulkFaxDetail_SendFaxNumerButton_" + BulkFaxKey + "").innerHTML = "<a href=\"javascript:BulkFaxDetailModify('" + BulkFaxKey + "', '" + SendFaxNumber + "')\" class=\"FaxStatusCount\"><img src=\"../images/btn_bulkfaxmodify.gif\" border=\"0\"></a>";
        }
        else {
            alert("팩스번호 수정 중 오류가 발생하였습니다.");
            document.getElementById("BulkFaxDetail_SendFaxNumber_" + BulkFaxKey + "").innerHTML = SendFaxNumber;
            document.getElementById("BulkFaxDetail_SendFaxNumerButton_" + BulkFaxKey + "").innerHTML = "<a href=\"javascript:BulkFaxDetailModify('" + BulkFaxKey + "', '" + SendFaxNumber + "')\" class=\"FaxStatusCount\"><img src=\"../images/btn_bulkfaxmodify.gif\" border=\"0\"></a>";
        }
    }
}

function BulkFaxDetailResend_GetPoint(BulkDetailFaxKey, FaxType) {
    //    var sTop = document.all;
    //    parent.opener.parent.parent.parent.frames[1].FxGetPoint();
    //    setTimeout("document.all.HidBill36524Point.value = parent.opener.parent.parent.parent.frames[1].Get_POINT_VALUE(); BulkFaxDetailResend('"+BulkDetailFaxKey+"','"+ FaxType+"');", 1000);
    BulkFaxDetailResend(BulkDetailFaxKey, FaxType);
}

function BulkFaxDetailResend(BulkDetailFaxKey, FaxType) {
    var sTop = document.all;
    var conf;
    var ActionFile, DatatoSend, ReturnValue;
    var strFaxMsg;

    if (FaxType == "2") {
        strFaxMsg = "\r\n\r\n※ [인터넷팩스]일 경우 새로운 항목으로 등록됩니다.";
    }

    conf = confirm("재송신 하시겠습니까?" + strFaxMsg);
    if (conf) {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "JobFlag=BulkFaxDetailResend&BulkDetailFaxKey=" + BulkDetailFaxKey + "&Bill36524Point=" + document.all.HidBill36524Point.value + "&IsLimitFaxCount=" + sTop.HidIsLimitFaxCount.value + "&DailyAvailableFaxCount=" + sTop.HidDailyAvailableFaxCount.value;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (typeof ReturnValue != "undefined") {
            if (ReturnValue == "1") {
                alert("재송신 되었습니다.");
                if (FaxType == "1") {
                    //fbox-mini
                    parent.location.reload();
                }
                else {
                    //인터넷 팩스
                    parent.opener.location.href = "FaxList_Bulk.aspx";
                    parent.opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000007";
                    parent.window.close();
                }
            }
            else if (ReturnValue == "-5") {
                    DailySendFaxOverPopUp();
            }
            else {
                alert("재송신 중 오류가 발생하였습니다.");
            }
        }
    }
}

function BulkFaxAllResend_GetPoint() {
    BulkFaxAllResend();
}

function BulkFaxAllResend() {
    var sTop = document.all;
    var strFaxMsg = "";
    var BulkKey, FaxStatus;
    var ActionFile, DatatoSend, ReturnValue;
    var flag = false;

    if (document.all.HidFaxType.value == "2") {
        strFaxMsg = "\r\n\r\n ※ [인터넷팩스]일 경우 새로운 항목으로 등록됩니다.";
    }
    
    
    BulkKey = BulkFaxDetailListFrame.document.all.HidBulkKey.value;
    FaxStatus = BulkFaxDetailListFrame.document.all.HidFaxStatus.value;

    if (FaxStatus == "0")   //송신완료
    {
        if (confirm("[송신완료]된 팩스를 선택하셨습니다. 재송신 하시겠습니까?" + strFaxMsg))
            flag = true;
        else
            flag = false;
    }
    else if (FaxStatus == "97") //표지생성
    {
        alert("[표지생성] 상태 이므로 재송신이 불가능 합니다.");
    }
    else if (FaxStatus == "98") //표지생성
    {
        alert("[승인대기] 상태 이므로 재송신이 불가능 합니다.");
    }
    else if (FaxStatus == "99") //송신중
    {
        alert("[송신중] 상태 이므로 재송신이 불가능 합니다.");
    }
    else if (FaxStatus == "100") //송신대기
    {
        alert("[송신대기] 상태 이므로 재송신이 불가능 합니다.");
    }
    else {
        if (confirm("상세발송내역에 조회 된 내역 전체를 재송신 하시겠습니까?" + strFaxMsg))
            flag = true;
        else
            flag = false;
    }

    if (flag) {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "JobFlag=BulkFaxAllResend&BulkKey=" + BulkKey + "&FaxStatus=" + FaxStatus + "&Bill36524Point=" + document.all.HidBill36524Point.value + "&IsLimitFaxCount=" + sTop.HidIsLimitFaxCount.value + "&DailyAvailableFaxCount=" + sTop.HidDailyAvailableFaxCount.value;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (typeof ReturnValue != "undefined") {
            if (ReturnValue == "1") {
                alert("재송신 되었습니다.");
                if (document.all.HidFaxType.value == "1") 
                {
                    //fbox-mini
                    location.reload();
                }
                else 
                {
                    //인터넷 팩스
                    opener.location.href = "FaxList_Bulk.aspx";
                    opener.parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000007";                    
                    self.window.close();
                }
            }
            else if (ReturnValue == "-2") {
                alert("재송신 할 팩스가 없습니다.\r\n[송신완료],[표지생성],[승인대기],[송신중],[송신대기]는 재송신 대상이 아닙니다.");
            }
            else if (ReturnValue == "-5") {
                    DailySendFaxOverPopUp();
            }
            else {
                alert("재송신 중 오류가 발생하였습니다.");
            }
        }
    }
}

function BulkFaxNotResend(statusName) {
    alert("[" + statusName + "] 상태 이므로 재송신이 불가능 합니다.");
}

//Modify : 2013-12-16 guagua 연동Table
function BulkFaxExcelExport() {
    var sTop = document.all;
    var strrYear = "";

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }
    
    BulkFaxDetailExcelFrame.location.href = "BulkFaxDetailExcelExport.aspx?rYear=" + strrYear + "&BulkKey=" + sTop.HidBulkKey.value + "&FaxStatus=" + sTop.HidBulkSearchStatus.value + " ";
}

//내용 : 보낼팩스함에서 승인대기중인 팩스를 승인
function BtnApprovalClick() {
    var SelectValue = FaxListCheckValue();
    var sTop = document.all;
    var AryValue, AryFaxValue;
    var ActionFile, DatatoSend, ReturnValue;
    var ListPage, SortType, SortValue;

    ListPage = sTop.HidListPage.value;
    SortType = sTop.HidSortType.value;
    SortValue = sTop.HidSortValue.value;

    if (SelectValue.length == 0) {
        alert("승인 할 팩스를 선택해 주세요.\n\n[알림] 승인 할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    var conf = confirm("선택한 항목을 승인 하시겠습니까?\n\n[알림] 보낼팩스의 상태가 '승인대기' 항목만 승인처리 됩니다.");
    if (conf) {
        AryValue = SelectValue.split(';');
        for (var i = 0; i < AryValue.length - 1; i++) {
            if (i > 0)
                AryFaxValue += ";" + Replace(AryValue[i], 'FaxKey_', '');
            else
                AryFaxValue = Replace(AryValue[i], 'FaxKey_', '');
        }

        ActionFile = "AjaxFax.aspx";
        DatatoSend = "jobflag=ApprovalFax&FaxKey=" + AryFaxValue;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);

        if (ReturnValue == "1") {
            alert("승인 되었습니다.");
            location.href = "FaxList_Reservation.aspx?ListPage=" + ListPage + "&SortValue=" + SortValue + "&SortType=" + SortType;
        }
        else {
            alert("승인 중 오류가 발생하였습니다.");
        }
    }
    else {
        return false;
    }
}



//받은팩스함에서 전달버튼 클릭
function BtnDelivery() {

    var sTop = document.all;
    var SelectValue = FaxListCheckValue();
    var sMsg;
    var intCount;
    var conf;
    var AryValue;
    var AryBoxValue = "";
    var winTop;
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var sUrl;
    var CalendarDate, ListPage;
    var sPostParamMode;
    var sPostParamFaxBoxKey;
    var sPostParamCalendarDate;
    var sPostParamListPage;
    var strrYear = "";

    if (SelectValue.length == 0) {
        alert("전달 할 팩스를 선택해 주세요.\n\n[알림] 전달 할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }

    sTop.HidSelectedFax.value = SelectValue;

    CalendarDate = sTop.HidCalendarDate.value;
    ListPage = sTop.HidListPage.value;

    sUrl = "FaxDelivery.aspx";
    sPostParamFaxBoxKey = sTop.HidFaxBoxKey.value;
    sPostParamCalendarDate = CalendarDate;
    sPostParamListPage = ListPage;

    winTop = parent.parent.parent;

    iWidth = 400;
    iHeight = 165;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)

    sUrl = "FaxDelivery.aspx?sPostParamrYear=" + strrYear + "&sPostParamFaxBoxKey=" + sPostParamFaxBoxKey + "&sPostParamCalendarDate=" + sPostParamCalendarDate + "&sPostParamListPage=" + sPostParamListPage;
    var win_movecopy = window.open(sUrl, "FaxMoveCopy", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    win_movecopy.focus();
}

//팩스 전달에서 닫기버튼 클릭
function FaxDeliveryClose() {
    self.window.close();
}


//팩스 전달에서 확인버튼 클릭
function FaxDeliverySave() {
    var conf;
    var sMsg;
    var sTop = document.all;
    if (sTop.ddl_MiniList.value == "-1") {
        alert("팩스번호를 선택해 주세요.");
        return false;
    }
    else {
        document.all.HidSelectedFax.value = opener.document.all.HidSelectedFax.value;
        intCount = SelectFaxCount(opener.document.all.HidSelectedFax.value);
        conf = confirm(intCount.toString() + "개의 팩스를 전달 하시겠습니까?");
        if (conf)
            return true;
        else
            return false;
    }
}

//동보팩스 상세정보
function FaxList_Bulk_DblClick(FaxKey, BoxKey) {
    var sTop = document.all;
    var sUrl;
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;

    if (FaxKey == "") FaxKey = sTop.HidSelectRow.value;
    if (FaxKey == "") {
        alert("팩스를 선택해 주세요.");
        return false;
    }

    sUrl = "BulkFaxDetail.aspx?BulkKey=" + FaxKey;

    winTop = parent.parent.parent;

    iWidth = 700;
    iHeight = 750;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)

    var win_BulkDetail = window.open(sUrl, "BulkFaxDetail", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    win_BulkDetail.focus();
}



//동보팩스함-다시보내기
function BtnBulkBoxReSendClick_GetPoint() {
    //    var sTop = document.all;
    //    parent.parent.parent.frames[1].FxGetPoint();
    //    setTimeout("document.all.HidBill36524Point.value = parent.parent.parent.frames[1].Get_POINT_VALUE(); BtnBulkBoxReSendClick();", 1000);
    BtnBulkBoxReSendClick();
}

function BtnBulkBoxReSendClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();
    var reSendType = sTop.HidFaxReSendType.value;
    
    if (SelectValue.length == 0) {
        alert("다시 발송할 팩스를 선택해 주세요.\n\n[알림] 발송할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else {
        sTop.HidSelectedFax.value = SelectValue;

        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + "개의 동보팩스를 다시 발송 하시겠습니까?\n\n[알림] 동보팩스의 다시보내기는 동보건수 전체에 대해서 재전송 합니다.");
        if (conf) {
            ActionFile = "AjaxFax.aspx";
            DatatoSend = "JobFlag=BulkFaxReSend&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value + "&reSendType=" + reSendType + "&Bill36524Point=" + sTop.HidBill36524Point.value + "&IsLimitFaxCount=" + sTop.HidIsLimitFaxCount.value + "&DailyAvailableFaxCount=" + sTop.HidDailyAvailableFaxCount.value;
            ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
            if (typeof ReturnValue != "undefined") {
                if (ReturnValue == "1") {
                    alert("팩스가 발송처리 되었습니다.");
                    document.location.reload();
                }
                else if (ReturnValue == "-2") {
                    alert("인터넷 팩스 발송 중 잔액부족으로 중단되었습니다.");                
                }
                else if (ReturnValue == "-5") {
                    DailySendFaxOverPopUp();
                }
                else {
                    alert("팩스 발송 중 오류가 발생하였습니다.");
                }
            }
        }
    }
}


function BtnBulkFaxApprovalClick() {
    var SelectValue = FaxListCheckValue();
    var sTop = document.all;
    var AryValue, AryFaxValue;
    var ActionFile, DatatoSend, ReturnValue;

    if (SelectValue.length == 0) {
        alert("승인 할 팩스를 선택해 주세요.\n\n[알림] 승인 할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    var conf = confirm("선택한 항목을 승인 하시겠습니까?");
    if (conf) {
        AryValue = SelectValue.split(';');
        for (var i = 0; i < AryValue.length - 1; i++) {
            if (i > 0)
                AryFaxValue += ";" + Replace(AryValue[i], 'FaxKey_', '');
            else
                AryFaxValue = Replace(AryValue[i], 'FaxKey_', '');
        }

        ActionFile = "AjaxFax.aspx";
        DatatoSend = "jobflag=ApprovalBulkFax&FaxKey=" + AryFaxValue;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);

        if (ReturnValue == "1") {
            alert("승인 되었습니다.");
            location.href = "FaxList_Bulk.aspx";
        }
        else {
            alert("승인 중 오류가 발생하였습니다.");
        }
    }
    else {
        return false;
    }
}



function BtnBulkSendCancelClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();

    if (SelectValue.length == 0) {
        alert("보내기 취소할 팩스를 선택해 주세요.\n\n[알림] 취소할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else {
        sTop.HidSelectedFax.value = SelectValue;

        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + "개의 팩스를 보내기 취소 하시겠습니까?\n\n※ 송신중인 팩스는 보내기취소가 되지 않습니다.");
        {
            if (conf) {
                ActionFile = "AjaxFax.aspx";
                DatatoSend = "JobFlag=FaxBulkSendCancel&FaxKey=" + Replace(SelectValue, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value;
                ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
                if (typeof ReturnValue != "undefined") {
                    if (ReturnValue == "1") {
                        alert("팩스보내기가 취소 되었습니다.");
                        document.location.reload();
                    }
                    else {
                        alert("팩스 보내기취소 중 오류가 발생하였습니다.");
                    }
                }
            }
        }
    }
}


function BtnBulkDeleteClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var conf;
    var FileName;
    var LeftMenu;
    var IsAddrDel;
    var SelectValue = FaxListCheckValue();
    var strrYear = "";

    if (SelectValue.length == 0) {
        alert("삭제할 팩스를 선택해 주세요.\n\n[알림] 삭제할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }

    sTop.HidSelectedFax.value = SelectValue;

    intCount = SelectFaxCount(sTop.HidSelectedFax.value);

    conf = confirm(intCount.toString() + "개의 팩스를 삭제 하시겠습니까?\n\n[알림] 동보팩스를 삭제하면 지운팩스함으로 이동되지 않고 바로 삭제 되어 복원할 수 없습니다.");
    if (conf) {
        if (sTop.HidReservationBoxDeleteConfig.value == "1") {
            var conf2 = confirm("동보팩스함 삭제시 팩스발송이 되지 않은 팩스번호에 대해 주소록에서 팩스번호를 삭제하도록 관리자가 설정 하였습니다.\n\n(※ 본 기능의 목적 : 잘못된 팩스번호가 주소록 정보에 남아 있어 계속해서 팩스발송 항목에 포함되는 것을 방지하기 위함 입니다.)\n\n주소록의 정보도 함께 삭제 하시겠습니까?");
            if (conf2)
                IsAddrDel = "1";
            else
                IsAddrDel = "";
        }
    }

    if (conf) {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "JobFlag=BulkFaxDel&rYear=" + strrYear + "&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value + "&AddrDel=" + IsAddrDel;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (typeof ReturnValue != "undefined") {
            if (ReturnValue == "1") {
                alert("팩스가 삭제 되었습니다.");
                if (strrYear.length == 4) {
                    location.href = "FaxList_Bulk_YYYY.aspx?rYear=" + strrYear + "&ListPage=" + sTop.HidListPage.value;
                }
                else {
                    location.href = "FaxList_Bulk.aspx?ListPage=" + sTop.HidListPage.value;
                }
            }
            else if (ReturnValue == "-2") {
                alert("현재 승인대기 또는 송신대기, 송신 중인 팩스가 존재하므로, 팩스를 삭제할 수 없습니다.");
                if (strrYear.length == 4) {
                    location.href = "FaxList_Bulk_YYYY.aspx?rYear=" + strrYear + "&ListPage=" + sTop.HidListPage.value;
                }
                else {
                    location.href = "FaxList_Bulk.aspx?ListPage=" + sTop.HidListPage.value;
                }
            }
            else {
                alert("팩스가 삭제 되었습니다.");
            }
        }
    }
}


function FaxDeliveryOnLoad() {
    document.all.HidSelectedFax.value = opener.document.all.HidSelectedFax.value;
}

function BtnReservationAllDeleteClick() {
    var ActionFile = "";
    var DatatoSend = "";
    var ReturnValue;

    var sTop = document.all;
    if (sTop.HidRecordCount.value == "0") {
        alert("보낼팩스함을 비울 팩스문서가 없습니다.");
        return false;
    }

    var conf1 = confirm("보낼팩스함 비우기는 팩스문서의 상태가 [송신중], [송신대기], [승인대기], [표지변환]를 제외하고 모든 팩스문서를 삭제합니다.\n\n팩스함을 비우시겠습니까?");
    if (conf1) {
        if (sTop.HidReservationBoxDeleteConfig.value == "1") {
            var conf2 = confirm("보낼팩스함 삭제시 팩스발송이 되지 않은 팩스번호에 대해 주소록에서 팩스번호를 삭제하도록 관리자가 설정 하였습니다.\n\n(※ 본 기능의 목적 : 잘못된 팩스번호가 주소록 정보에 남아 있어 계속해서 팩스발송 항목에 포함되는 것을 방지하기 위함 입니다.)\n\n주소록의 정보도 함께 삭제 하시겠습니까?");
            if (conf2) {
                DatatoSend = "JobFlag=ReservationFaxAllDelwidthAddr";
            }
            else {
                DatatoSend = "JobFlag=ReservationFaxAllDel";
            }
        }
        else {
            DatatoSend = "JobFlag=ReservationFaxAllDel";
        }
    }

    if (DatatoSend != "") {
        document.getElementById("DivLoading").style.display = "";
        ReservationBoxClearCleareFrame.location.href = "FaxReservationBoxClear.aspx?" + DatatoSend;
    }
}

//Modify : 2013-12-16 guagua 연도Table
function BtnRecvRefusal(BoxType)
{
    var sTop = document.all;
    var conf;
    var ActionFile, DatatoSend, ReturnValue
    var url;
    var SelectValue = FaxListCheckValue();
    var strrYear = "";
    
    sTop.HidSelectedFax.value = SelectValue;

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }
    
    if (SelectValue.length == 0)
    {
        alert("수신거부 등록 할 팩스를 선택해 주세요.\n\n[알림] 수신거부 등록 할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    if (BoxType == "ReceiveBox") 
    {
        if (strrYear.length == 4) {
            url = "FaxList_Receive_YYYY.aspx?rYear=" + strrYear + "&ListPage=" + sTop.HidListPage.value;
            conf = confirm("선택하신 팩스의 발신번호에 대해서 수신거부 등록을 하시겠습니까?\n\n※ 발신번호가 없는 경우에는 등록되지 않습니다.");
        }
        else {
            url = "FaxList_Receive.aspx?ListPage=" + sTop.HidListPage.value;
            conf = confirm("선택하신 팩스의 발신번호에 대해서 수신거부 등록을 하시겠습니까?\n\n※ 발신번호가 없는 경우에는 등록되지 않습니다.");
        }
    }
    else if (BoxType == "DeleteBox")
    {
        url = "FaxList_Delete.aspx?ListPage=" + sTop.HidListPage.value;
        conf = confirm("선택하신 팩스의 발신번호에 대해서 수신거부 등록을 하시겠습니까?\n\n※ 받은팩스함에서 삭제된 팩스에 대해서만 수신거부 등록이 됩니다.\n※ 발신번호가 없는 경우에는 등록되지 않습니다.");
    }

    if (conf)
    {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "JobFlag=AddRecvRefusal&rYear=" + strrYear + "&BoxKey=" + BoxType + "&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '');
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (typeof ReturnValue != "undefined")
        {
            if (ReturnValue == "1")
            {
                alert("수신거부 등록이 되었습니다.");
                location.href = url;
            }
            else
            {
                alert("수신거부 등록 중 오류가 발생하였습니다.");
                location.href = url;
            }
        }
        
        return true;
    }
}

function BtnSMSReplyClick() {
    var sTop = document.all;
    var sUrl;
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;

    var FaxKey = sTop.HidSelectRow.value;
    if (FaxKey == "") {
        alert("팩스를 선택해 주세요.");
        return false;
    }

    sUrl = "FaxSMSReply.aspx?FaxKey=" + FaxKey;

    winTop = parent.parent.parent;

    iWidth = 300;
    iHeight = 430;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)

    var winSMSReply = window.open(sUrl, "SMSReply", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    winSMSReply.focus();
}

function BtnSearchSendClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var Param;
    var ReceiveSendFaxKey;
    var SelectValue = FaxListCheckValue();
    var FaxSendService;
    var ArySelectValue;

    ArySelectValue = SelectValue.split(';');

    if (ArySelectValue.length == 1) {
        alert("보낼 팩스를 선택해 주세요.\n\n[알림] 보낼 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else if (ArySelectValue.length > 2) {
        alert("보낼 팩스를 1개만 선택해 주세요.");
        return false;
    }
    else {
        sTop.HidSelectedFax.value = SelectValue;
        FaxSendService = document.getElementById("HidFaxSendService").value;
        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + " 개의 팩스를 보내시겠습니까?");
        {
            if (conf) {
                var IsReSend = IsOverDailySendFax(intCount);
                
                if(IsReSend)
                {
                    var sAX = parent.parent.frames[4].frames[0];
                    var strFaxKey = Replace(sTop.HidSelectedFax.value, "FaxKey_", "");
                    var strFaxKey = Replace(strFaxKey, ";", "");
                    strFaxBoxKey = eval("document.getElementById('" + strFaxKey + "').innerHTML");
                    var strSessionKey = document.all.HidSessionKey.value;
                    if (FaxSendService.indexOf('11') > -1) //인터넷으로 보내기
                    {
                        strSessionKey = strSessionKey + "_internet";
                    }
                    else if (FaxSendService.indexOf('12') > -1) //미니로 보내기
                    {
                        strSessionKey = strSessionKey + "_mini"
                    }
                    sAX.document.getElementById("AX").RunProgram("", "", "", strFaxBoxKey, strFaxKey, strSessionKey);
                }
                else
                {
                    DailySendFaxOverPopUp();
                }
            }
        }
    }
}

function BtnReservationSendClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var Param;
    var SelectValue = FaxListCheckValue();
    var FaxSendService;

    if (SelectValue.length == 0) {
        alert("보낼 팩스를 선택해 주세요.");
        return false;
    }
    else {
        sTop.HidSelectedFax.value = SelectValue;
        FaxSendService = document.getElementById("HidFaxSendService").value;
        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + " 개의 팩스를 보내시겠습니까?\n\n※ 여러개의 팩스를 선택하시면 선택한 개수 만큼 팩스가 발송 됩니다.");
        {
            if (conf) {
                var IsReSend = IsOverDailySendFax(intCount);
                
                if(IsReSend)
                {
                    var sAX = parent.parent.frames[4].frames[0];
                    var strFaxBoxKey = document.all.HidFaxBoxKey.value;
                    var strFaxKey = Replace(sTop.HidSelectedFax.value, "FaxKey_", "");
                    var strSessionKey = document.all.HidSessionKey.value;

                    if (FaxSendService.indexOf('11') > -1) //인터넷으로 보내기
                    {
                        strSessionKey = strSessionKey + "_internet";
                    }
                    else if (FaxSendService.indexOf('12') > -1) //미니로 보내기
                    {
                        strSessionKey = strSessionKey + "_mini"
                    }
                    sAX.document.getElementById("AX").RunProgram("", "", "", strFaxBoxKey, strFaxKey, strSessionKey);
                }
                else
                {
                    DailySendFaxOverPopUp();
                }
            }
        }
    }
}

// 전자등기팩스함 - 삭제
function BtnRegFaxDeleteClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var conf;
    var FileName;
    var LeftMenu;
    var IsAddrDel;
    var SelectValue = FaxListCheckValue();

    if (SelectValue.length == 0) {
        alert("삭제할 팩스를 선택해 주세요.\n\n[알림] 삭제할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    sTop.HidSelectedFax.value = SelectValue;

    intCount = SelectFaxCount(sTop.HidSelectedFax.value);

    conf = confirm(intCount.toString() + "개의 팩스를 삭제 하시겠습니까?\n\n[알림] 전자등기팩스를 삭제하면 지운팩스함으로 이동되지 않고 바로 삭제 되어 복원할 수 없습니다.");

    if (conf) {
        ActionFile = "AjaxFax.aspx";
        DatatoSend = "JobFlag=RegFaxDel&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value + "&AddrDel=" + IsAddrDel;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);

        if (typeof ReturnValue != "undefined") {
            if (ReturnValue == "1") {
                alert("팩스가 삭제 되었습니다.");
                location.href = "FaxList_Reg.aspx?ListPage=" + sTop.HidListPage.value;
            }
            else if (ReturnValue == "-2") {
                alert("공전소 등록실패, 또는 팩스 송신실패된 전자등기팩스만 삭제할 수 있습니다.");
                location.href = "FaxList_Reg.aspx?ListPage=" + sTop.HidListPage.value;
            }
            else {
                alert("팩스가 삭제 되었습니다.");
            }
        }
    }
}

var RegFaxSendDivTime;
function RegFaxSendDivViewer() {
    clearTimeout(RegFaxSendDivTime);

    var strRegFaxSendtrimage;
    var RegFaxSendSubTrImage;
    var RegFaxSendSubTrSpace;
    var RegFaxSendDiv;

    var FaxPayType = document.getElementById("HidFaxPayType").value;
    if (FaxPayType == "beforePay") {
        strRegFaxSendtrimage = "TrFaxSendbefore";
    }
    else if (FaxPayType == "afterPay") {
        strRegFaxSendtrimage = "TrFaxSendafter";
    }
    RegFaxSendSubTrImage = document.getElementById(strRegFaxSendtrimage);
    RegFaxSendSubTrImage.style.display = 'inline';

    RegFaxSendDiv = document.getElementById("DivRegFaxSendType");
    RegFaxSendDiv.style.display = 'inline';
    RegFaxSendDiv.style.zIndex = '1';
}

function RegFaxSendDivViewerClose() {
    if (document.getElementById("DivRegFaxSendType")) {
        document.getElementById("DivRegFaxSendType").style.display = 'none';
    }

}

function RegFaxSendDivViewerOut() {

    RegFaxSendDivTime = setTimeout('RegFaxSendDivViewerClose()', 300);
}

function BtnRegBoxSendClick_GetPoint() {

    BtnRegBoxFaxSendClick();
}

function BtnRegBoxFaxSendClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();
    var reSendType = sTop.HidFaxSendType.value;

    if (SelectValue.length == 0) {
        alert("발송할 팩스를 선택해 주세요.\n\n[알림] 발송할 팩스항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else {
        sTop.HidSelectedFax.value = SelectValue;

        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + "개의 팩스를 다시 발송 하시겠습니까?");
        if (conf) {
            var IsReSend = IsOverDailySendFax(intCount);
            
            if(IsReSend)
            {
                ActionFile = "AjaxFax.aspx";
                DatatoSend = "JobFlag=RegFaxSend&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value + "&reSendType=" + reSendType;
                ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);

                if (typeof ReturnValue != "undefined") {
                    if (ReturnValue == "1") {
                        alert("팩스가 발송처리 되었습니다.");
                        location.href = "FaxList_Reg.aspx";
                        parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000008";
                    }
                    else if (ReturnValue == "-3") {
                        alert("팩스보내기는 공전소상태가 등록완료인 팩스 중 송신완료 혹은 \r\n송신실패인 팩스만 가능합니다.");
                    }
                    else if (ReturnValue == "-2") {
                        alert("인터넷 팩스 발송 중 잔액부족으로 중단되었습니다.");
                    }
                    else {
                        alert("팩스 발송 중 오류가 발생하였습니다.");
                    }
                }
            }
            else
            {
                DailySendFaxOverPopUp();
            }
        }
    }
}

function BtnADFaxSendClick() {
    if (document.all.HidMode.value == "Admin") {
        var conf = confirm("관리자화면에서 팩스보내기를 할 수 없습니다.\n사용자화면으로 이동 하시겠습니까?");
        if (conf) {
            window.top.location.href = "../Main.aspx";
            return false;
        }
        else {
            return false;
        }
    }

    var sTop = parent.frames[4].frames[0];
    var strSessionKey = document.all.HidSessionKey.value;

    sTop.document.getElementById("AX").RunProgram("", "", "", "", strSessionKey, "NewADFAX");
}

function BtnNewRegFaxSendClick() {
    if (document.all.HidMode.value == "Admin") {
        var conf = confirm("관리자화면에서 팩스보내기를 할 수 없습니다.\n사용자화면으로 이동 하시겠습니까?");
        if (conf) {
            window.top.location.href = "../Main.aspx";
            return false;
        }
        else {
            return false;
        }
    }

    var sTop = parent.frames[4].frames[0];
    var strSessionKey = document.all.HidSessionKey.value;

    sTop.document.getElementById("AX").RunProgram("", "", "", "", strSessionKey, "NewRegFAX");
}

//Modify : 2013-12-16 guagua 연도 Table
function BtnRegBoxSendClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var Param;
    var GlobalShareSendFaxKey;
    var SelectValue = FaxListCheckValue();
    var FaxSendService;
    var strrYear = "";

    if (document.getElementById("HidrYear") != null) {
        strrYear = document.all.HidrYear.value;
    }

    if (SelectValue.length == 0) {
        alert("보낼 팩스를 선택해 주세요.");
        return false;
    }
    else {
        sTop.HidSelectedFax.value = SelectValue;

        ActionFile = "AjaxFax.aspx";
        DatatoSend = "jobflag=IsFaxLock&rYear=" + strrYear + "&FaxKey=" + sTop.HidSelectedFax.value + "&BoxKey=" + document.all.HidFaxBoxKey.value;
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (ReturnValue != "1") {
            alert("보내고자 하는 팩스 중 잠김상태의 팩스가 있으면 팩스를 발송 할 수 없습니다.");
            return false;
        }

        FaxSendService = document.getElementById("HidFaxSendService").value;
        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + " 개의 팩스를 보내시겠습니까?\n\n※ 여러개의 팩스를 선택하시면 선택한 개수 만큼 팩스가 발송 됩니다.");
        {
            if (conf) {
                var IsReSend = IsOverDailySendFax(intCount);
                
                if(IsReSend)
                {                
                    var sAX = parent.parent.frames[4].frames[0];
                    var strFaxBoxKey = document.all.HidFaxBoxKey.value;
                    var strFaxKey = Replace(sTop.HidSelectedFax.value, "FaxKey_", "");
                    var strSessionKey = document.all.HidSessionKey.value;
                    
                    strSessionKey = strSessionKey + "_reg";
                    if (strrYear.length == 4) {
                        strSessionKey += "_" + strrYear;
                    }

                    sAX.document.getElementById("AX").RunProgram("", "", "", strFaxBoxKey, strFaxKey, strSessionKey);
                }
                else
                {
                    DailySendFaxOverPopUp();
                }
            }
        }
    }
}

function RegResult0Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidRegResult0.value;
    var RegResult0Style = document.getElementById("DivRegResult0").style;

    if (status == 'out' || status != "DivRegResult0")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    RegResult0Style.display = 'inline';
    RegResult0Style.top = TopMargin + "px";
    RegResult0Style.left = event.clientX - 285 + "px";
    RegResult0Style.position = "absolute";
    RegResult0Style.zIndex = "1";
}

function RegResult0ViewerClose() {
    var status = document.all.HidRegResult0.value;
    if (status != 'out')
        return;
    document.getElementById("DivRegResult0").style.display = 'none';
}

function RegResult0ViewerOut() {
    viewTime = setTimeout("RegResult0ViewerClose()", 100);
}

function RegResult1Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidRegResult1.value;
    var RegResult1Style = document.getElementById("DivRegResult1").style;

    if (status == 'out' || status != "DivRegResult1")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 5;
    else
        TopMargin = event.clientY - 10;

    clearTimeout(viewTime);
    RegResult1Style.display = 'inline';
    RegResult1Style.top = TopMargin + "px";
    RegResult1Style.left = event.clientX - 285 + "px";
    RegResult1Style.position = "absolute";
    RegResult1Style.zIndex = "1";
}

function RegResult1ViewerClose() {
    var status = document.all.HidRegResult1.value;
    if (status != 'out')
        return;
    document.getElementById("DivRegResult1").style.display = 'none';
}

function RegResult1ViewerOut() {
    viewTime = setTimeout("RegResult1ViewerClose()", 100);
}

function RegResult2Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidRegResult2.value;
    var RegResult2Style = document.getElementById("DivRegResult2").style;

    if (status == 'out' || status != "DivRegResult2")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult3ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 20;
    else
        TopMargin = event.clientY - 25;

    clearTimeout(viewTime);
    RegResult2Style.display = 'inline';
    RegResult2Style.top = TopMargin + "px";
    RegResult2Style.left = event.clientX - 285 + "px";
    RegResult2Style.position = "absolute";
    RegResult2Style.zIndex = "1";
}

function RegResult2ViewerClose() {
    var status = document.all.HidRegResult2.value;
    if (status != 'out')
        return;
    document.getElementById("DivRegResult2").style.display = 'none';
}

function RegResult2ViewerOut() {
    viewTime = setTimeout("RegResult2ViewerClose()", 100);
}

function RegResult3Viewer() {
    var viewTime = null;
    var DivHeight = 97;
    var TopMargin;
    var status = document.all.HidRegResult3.value;
    var RegResult3Style = document.getElementById("DivRegResult3").style;

    if (status == 'out' || status != "DivRegResult3")
        return;

    setTimeout("SendResult0ViewerClose()", 100);
    setTimeout("SendResult97ViewerClose()", 100);
    setTimeout("SendResult98ViewerClose()", 100);
    setTimeout("SendResult99ViewerClose()", 100);
    setTimeout("SendResult100ViewerClose()", 100);
    setTimeout("SendResult101ViewerClose()", 100);
    setTimeout("SendResult102ViewerClose()", 100);
    setTimeout("SendResult200ViewerClose()", 100);
    setTimeout("SendResult300ViewerClose()", 100);
    setTimeout("SendResult2001ViewerClose()", 100);
    setTimeout("SendResult2016ViewerClose()", 100);
    setTimeout("SendResult2017ViewerClose()", 100);
    setTimeout("SendResult2018ViewerClose()", 100);
    setTimeout("SendResult2019ViewerClose()", 100);
    setTimeout("SendResult2021ViewerClose()", 100);
    setTimeout("SendResult2027ViewerClose()", 100);
    setTimeout("SendResult2041ViewerClose()", 100);
    setTimeout("SendResult2104ViewerClose()", 100);
    setTimeout("SendResult2109ViewerClose()", 100);
    setTimeout("SendResult2110ViewerClose()", 100);
    setTimeout("SendResult2112ViewerClose()", 100);
    setTimeout("SendResult2163ViewerClose()", 100);
    setTimeout("SendResult2991ViewerClose()", 100);
    setTimeout("SendResult2992ViewerClose()", 100);
    setTimeout("SendResult2993ViewerClose()", 100);
    setTimeout("SendResult1ViewerClose()", 100);
    setTimeout("RegResult0ViewerClose()", 100);
    setTimeout("RegResult1ViewerClose()", 100);
    setTimeout("RegResult2ViewerClose()", 100);

    if (parseInt(document.body.clientHeight) - ((event.clientY - 10 + DivHeight)) < 0)
        TopMargin = document.body.clientHeight - DivHeight - 20;
    else
        TopMargin = event.clientY - 25;

    clearTimeout(viewTime);
    RegResult3Style.display = 'inline';
    RegResult3Style.top = TopMargin + "px";
    RegResult3Style.left = event.clientX - 285 + "px";
    RegResult3Style.position = "absolute";
    RegResult3Style.zIndex = "1";
}

function RegResult3ViewerClose() {
    var status = document.all.HidRegResult3.value;
    if (status != 'out')
        return;
    document.getElementById("DivRegResult3").style.display = 'none';
}

function RegResult3ViewerOut() {
    viewTime = setTimeout("RegResult3ViewerClose()", 100);
}

var AddFuncViewerTime;
function AddFuncViewer() {
    clearTimeout(AddFuncViewerTime);

    var AddFuncStyle = document.getElementById("DivAddFunc");
    AddFuncStyle.style.display = 'inline';
    AddFuncStyle.style.zIndex = "1";
}

function AddFuncViewerClose() {
    if (document.getElementById("DivAddFunc") != null) {
        document.getElementById("DivAddFunc").style.display = 'none';
    }
}

function AddFuncViewerOut() {
    AddFuncViewerTime = setTimeout("AddFuncViewerClose()", 300);
}

function AddFuncViewerClick() {

    AddFuncViewerClose();
}

function RegFax_DetailInfo() {


    var sTop = document.all;
    var sUrl;
    var sPostParamFaxKey;
    var sPostParamFaxBoxKey;
    var winTop;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;
    var FaxKey = "";


    if (FaxKey == "") FaxKey = sTop.HidSelectRow.value;
    if (FaxKey == "") {
        alert("전자등기팩스를 선택해 주세요.");
        return false;
    }

    sUrl = "RegFax_DetailInfo.aspx";

    sPostParamFaxKey = FaxKey;
    sPostParamFaxBoxKey = sTop.HidFaxBoxKey.value;

    winTop = parent.parent.parent;

    iWidth = 466;
    iHeight = 306;

    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;

    xx = (thisX / 2) - (iWidth / 2)
    yy = (thisY / 2) - (iHeight / 2)

    sUrl = sUrl + "?sPostParamFaxKey=" + sPostParamFaxKey + "&sPostParamFaxBoxKey=" + sPostParamFaxBoxKey;
    var win_Property = window.open(sUrl, "RegFax_DetailInfo", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    win_Property.focus();

    FaxSendTypeViewerClose();
}

function RegFax_DetailInfo_Close() {

    self.window.close();
}

function BtnRegBoxReSendClick_GetPoint() {
    BtnRegBoxReSendClick();
}

function BtnRegBoxReSendClick() {
    var sTop = document.all;
    var ActionFile;
    var DatatoSend;
    var ReturnValue;
    var intCount;
    var SelectValue = FaxListCheckValue();
    var reSendType = sTop.HidFaxReSendType.value;

    if (SelectValue.length == 0) {
        alert("공전소에 다시보낼 전자등기팩스를 선택해 주세요.\n\n[알림] 발송할 전자등기팩스 항목의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }
    else {
        sTop.HidSelectedFax.value = SelectValue;

        intCount = SelectFaxCount(sTop.HidSelectedFax.value);

        var conf = confirm(intCount.toString() + "개의 전자등기팩스를 다시 발송 하시겠습니까?");
        if (conf) {
            ActionFile = "AjaxFax.aspx";
            DatatoSend = "JobFlag=RegFaxReSend&FaxKey=" + Replace(sTop.HidSelectedFax.value, 'FaxKey_', '') + "&BoxKey=" + sTop.HidFaxBoxKey.value + "&reSendType=" + reSendType;
            ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
            if (typeof ReturnValue != "undefined") {
                if (ReturnValue == "1") {
                    alert("전자등기팩스가 발송처리 되었습니다.");
                    location.href = "FaxList_Reg.aspx";
                    parent.parent.FaxLeftFrame.FaxLeft.location.href = "FaxLeft.aspx?SelectNode=F0000000000000000000000000000008";
                }
                else if (ReturnValue == "-3") {
                    alert("공전소 다시보내기는 공전소상태가 등록실패인 팩스만 가능합니다.");
                }
                else if (ReturnValue == "-2") {
                    alert("인터넷 팩스 발송 중 잔액부족으로 중단되었습니다.");
                }
                else {
                    alert("팩스 발송 중 오류가 발생하였습니다.");
                }
            }
        }
    }
}

function IsOverDailySendFax(intCount)
{
    var sTop = document.all;
    var IsLimitFaxCount;
    var DailyFaxCount;
    
    var IsReSend = false;
    if(sTop.HidIsLimitFaxCount.value == "0")
    {
        IsReSend = true;
    }
    else
    {
        if(parseInt(sTop.HidDailyAvailableFaxCount.value) >= intCount)
        {
            IsReSend = true;
        }
    }
   
    return IsReSend;
}

function DailySendFaxOverPopUp()
{
    var sTop = document.all;
    var iWidth, iHeight;
    var thisX, thisY, xx, yy;
    var winTop;
    
    winTop = parent.parent.parent;
    
    thisX = winTop.document.body.clientWidth;
    thisY = winTop.document.body.clientHeight;
    
    iWidth = 420;
    iHeight = 290;  

    xx = (thisX / 2) - (iWidth / 2) + winTop.screenLeft;
    yy = (thisY / 2) - (iHeight / 2);
    
    var paraWin = 'width =' + iWidth + ',height =' + iHeight + ',scrollbars=no,resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,top=' + xx + ',left='+ yy;

    noticeWindow = window.open('DailyFaxSendLimitPopUp.aspx?AvailableFaxCount=' + sTop.HidDailyAvailableFaxCount.value, 'DailySendFaxOverPopUp', paraWin);
    noticeWindow.moveTo(xx,yy);
    noticeWindow.focus();
}

function DailyServiceFileDown()
{
    location.href = "../Public/ADFax_LimitException.hwp";
}

function PopUpDailyServiceFileDown()
{
    opener.DailyServiceFileDown();
    
    self.close();
}

function PaneViewChange(Mode) {
    var ActionFile, DatatoSend, ReturnValue

    if (Mode == "ComID") 
    {
        ActionFile = "../Member/AjaxMember.aspx";
        DatatoSend = "JobFlag=IsBM";
        ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
        if (typeof ReturnValue != "undefined") {
            if (ReturnValue == "1") {
                location.href = "AdminModify.aspx?Mode=ComID";
            }
            else {
                alert("회사ID를 변경할 수 없는 고객사 입니다.");
                return false;
            }
        }
    }
    else {
        location.href = "AdminModify.aspx?Mode=ComPW";
    }
}

function AdminModify_ComIDCheck() {
    var sTop = document.all;

    if (sTop.tBox_NewComID.value == "") {
        alert("회사ID를 입력해 주세요.");
        sTop.tBox_NewComID.focus();
        return false;
    }
    if (sTop.tBox_NewComID.value.length < 4) {
        alert("회사ID는 4~12자까지 입력해 주세요.");
        sTop.tBox_NewComID.focus();
        return false;
    }
    if (!IsNumberEnglish2(sTop.tBox_NewComID.value)) {
        alert("회사ID 형식이 잘못 되었습니다.");
        sTop.tBox_NewComID.focus();
        return false;
    }

    var ActionFile = "../Member/AjaxMember.aspx";
    var DatatoSend = "JobFlag=ComIDCheck&ComID=" + sTop.tBox_NewComID.value;
    var ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
    if (typeof ReturnValue != "undefined") {
        if (ReturnValue == "0") {
            alert("사용할 수 있는 회사ID 입니다.");
            sTop.HidComIDCheck.value = "1";
        }
        else {
            alert("중복된 회사ID가 있습니다.\n다른 회사ID를 입력해 주세요.");
            sTop.HidComIDCheck.value = "0";
            return false;
        }
    }
}

function AdminModify_ComIDChange_SaveClick() {
    var sTop = document.all;

    if (sTop.tBox_NewComID.value == "") {
        alert("변경할 회사ID를 입력해 주세요.");
        sTop.tBox_NewComID.focus();
        return false;
    }
    if (sTop.tBox_NewComID.value.length < 4) {
        alert("회사ID는 4~12자까지 입력해 주세요.");
        sTop.tBox_NewComID.focus();
        return false;
    }
    if (!IsNumberEnglish2(sTop.tBox_NewComID.value)) {
        alert("회사ID 형식이 잘못 되었습니다.");
        sTop.tBox_NewComID.focus();
        return false;
    }
    if (sTop.HidComIDCheck.value != "1") {
        alert("회사ID 중복확인을 해주세요.");
        sTop.tBox_NewComID.focus();
        return false;
    }
    else {
        return true;
    }
}

function BMFirstLoginOK() {
    var sTop = document.all;

    if ((!sTop.rBox_ComIDChange.checked) && (sTop.tBox_NewComID.value != "")) {
        alert("회사ID를 변경하시려면 아이디/비밀번호 변경하기를 체크해 주세요.");
        return false;
    }

    if (sTop.rBox_ComIDChange.checked) {
        if (sTop.tBox_NewComID.value == "") {
            alert("변경할 회사ID를 입력해 주세요.");
            sTop.tBox_NewComID.focus();
            return false;
        }
        if (!IsNumberEnglish2(sTop.tBox_NewComID.value)) {
            alert("회사ID 형식이 잘못 되었습니다.");
            sTop.tBox_NewComID.focus();
            return false;
        }
        if (sTop.tBox_NewComID.value.length < 4) {
            alert("회사ID는 4~12자까지 입력해 주세요.");
            sTop.tBox_NewComID.focus();
            return false;
        }
        if (sTop.HidComIDCheck.value != "1") {
            alert("회사ID 중복확인을 해주세요.");
            sTop.tBox_NewComID.focus();
            return false;
        }
        if (sTop.tBox_ComPW.value == "") {
            alert("비밀번호를 입력해 주세요.");
            sTop.tBox_ComPW.focus();
            return false;
        }
        if (sTop.tBox_ComPW.length < 4) {
            alert("비밀번호는 4~12자까지 입력해 주세요.");
            sTop.tBox_ComPW.focus();
            return false;
        }
        if (sTop.tBox_ComRePW.value == "") {
            alert("비밀번호를 입력해 주세요.");
            sTop.tBox_ComRePW.focus();
            return false;
        }
        if (sTop.tBox_ComPW.value != sTop.tBox_ComRePW.value) {
            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
            sTop.tBox_ComPW.focus();
            return false;
        }
        else {
            return true;
        }
    }
    else {
        return true;
    }
}

function BMFirstLoginCancel() {
    self.window.close();
}

function ob_YearTableOnly(e) {
    var sTop = document.all;

    if (e.id.length == 37) {
        for (var i = 0; i < sTop.length; i++) {
            if (sTop.item(i).getAttribute("type") == "checkbox") {
                if (e.id != sTop.item(i).id) {
                    if (e.checked) {
                        sTop.item(i).checked = false;
                        sTop.item(i).disabled = true;
                    }
                    else {
                        sTop.item(i).checked = false;
                        sTop.item(i).disabled = false;
                    }
                }
            }
        }
    }
}

function FaxPropertyFocus() {
    if (document.all.tBox_Subject.disabled != true)
        document.all.tBox_Subject.focus();
}