var sTop = document.all;

function FaxSendInit() {
    var parm = Request("parm");
    var agent;

    if (parm == null) {
        sTop.tBox_RecvMobileNo.style.background = "url(../Images/exmobileno.gif) no-repeat 3px 2px #ffffff";
        sTop.tBox_RecvFaxNo.style.background = (sTop.cBox_NationalFax.checked == false) ? "url(../Images/exfaxno.gif) no-repeat 3px 2px #ffffff" : "url(../Images/exnationalfaxno.gif) no-repeat 3px 2px #ffffff";
        document.getElementById("ddl_NationalFaxInfo").disabled = true;
    }
    else {
        sTop.tBox_RecvMobileNo.style.background = "url(../Images/exmobileno.gif) no-repeat 3px 2px #ffffff";
        sTop.tBox_RecvFaxNo.style.background = (sTop.cBox_NationalFax.checked == false) ? "url(../Images/exfaxno.gif) no-repeat 3px 2px #ffffff" : "url(../Images/exnationalfaxno.gif) no-repeat 3px 2px #ffffff";
        document.getElementById("ddl_NationalFaxInfo").disabled = true;

        fileUploadResend(parm);
    }

    agent = navigator.userAgent.toLowerCase();
    if (agent.indexOf('msie 7') > -1 && agent.indexOf('trident') > -1) {
        if ((navigator.appVersion.indexOf('Trident/7.0') > -1) || (navigator.appVersion.indexOf('Trident/6.0') > -1)) {
            sTop.Div_FileInfo.className = "FileInfoBoxScroll_ie11 RecvBoxLeftBorder RecvBoxRighttBorder RecvBoxTopBorder RecvBoxBottomtBorder";
        }
    }
}


function Request(valuename) {
    var rtnval;
    var nowAddress = unescape(location.href);
    var parameters = new Array();
    parameters = (nowAddress.slice(nowAddress.indexOf("?") + 1, nowAddress.length)).split("&");
    for (var i = 0; i < parameters.length; i++) {
        if (parameters[i].indexOf(valuename) != -1) {
            rtnval = parameters[i].split("=")[1];
            if (rtnval == undefined || rtnval == null) {
                rtnval = "";
            }
            return rtnval;
        }
    }
}


function tBoxFocusIn(Item) {
    if (Item == "MobileNo") {
        if (sTop.tBox_RecvMobileNo.value == "") {
            sTop.tBox_RecvMobileNo.style.background = "url(../Images/exmobileno.gif) no-repeat 3px 2px #ffffff";
        }
        sTop.tBox_RecvMobileNo.style.background = "url() #ffffff";
    }
    if (Item == "FaxNo") {
        if (sTop.tBox_RecvFaxNo.value == "") {
            sTop.tBox_RecvFaxNo.style.background = "url(../Images/exfaxno.gif) no-repeat 3px 2px #ffffff";
        }
        sTop.tBox_RecvFaxNo.style.background = "url() #ffffff";
    }
}

function tBoxFocusOut(Item) {
    var sTop = document.all;

    if (Item == "MobileNo") {
        if (sTop.tBox_RecvMobileNo.value == "") {
            sTop.tBox_RecvMobileNo.style.background = "url(../Images/exmobileno.gif) no-repeat 3px 2px #ffffff";
        }
        else {
            sTop.tBox_RecvMobileNo.style.background = "#ffffff";
        }
    }
    if (Item == "FaxNo") {
        if (sTop.tBox_RecvFaxNo.value == "") {
            if (sTop.cBox_NationalFax.checked == false)
                sTop.tBox_RecvFaxNo.style.background = "url(../Images/exfaxno.gif) no-repeat 3px 2px #ffffff";
            else
                sTop.tBox_RecvFaxNo.style.background = "url(../Images/exnationalfaxno.gif) no-repeat 3px 2px #ffffff";
        }
        else {
            sTop.tBox_RecvFaxNo.style.background = "#ffffff";
        }
    }
}

function ddl_SendTimeChange() {
    if (sTop.rb_SendTime_Now.checked) {
        sTop.ddl_SendTime_Reserv_Year.disabled = "false";
        sTop.ddl_SendTime_Reserv_Month.disabled = "false";
        sTop.ddl_SendTime_Reserv_Day.disabled = "false";
        sTop.ddl_SendTime_Reserv_Hour.disabled = "false";
        sTop.ddl_SendTime_Reserv_Minute.disabled = "false";
    }
    else {
        sTop.ddl_SendTime_Reserv_Year.disabled = "";
        sTop.ddl_SendTime_Reserv_Month.disabled = "";
        sTop.ddl_SendTime_Reserv_Day.disabled = "";
        sTop.ddl_SendTime_Reserv_Hour.disabled = "";
        sTop.ddl_SendTime_Reserv_Minute.disabled = "";
    }
}

function checkFileExtension() {
    var filePath = sTop.fu_AddFile.value;

    if (filePath.indexOf('.') == -1)
        return false;

    var validExtensions = new Array();
    var ext = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase();

    validExtensions[0] = 'jpg';
    validExtensions[1] = 'jpeg';
    validExtensions[2] = 'bmp';
    validExtensions[3] = 'png';
    validExtensions[4] = 'gif';
    validExtensions[5] = 'tif';
    validExtensions[6] = 'tiff';
    validExtensions[7] = 'txt';
    validExtensions[8] = 'pdf';
    validExtensions[9] = 'hwp';
    validExtensions[10] = 'doc';
    validExtensions[11] = 'docx';
    validExtensions[12] = 'xls';
    validExtensions[13] = 'xlsx';
    validExtensions[14] = 'ppt';
    validExtensions[15] = 'pptx';
    validExtensions[16] = 'htm';
    validExtensions[17] = 'html';
    validExtensions[18] = 'web';


    for (var i = 0; i < validExtensions.length; i++) {
        if (ext == validExtensions[i])
            return true;
    }

    alert('' + ext.toUpperCase() + ' 파일은 추가할 수 없습니다.');
    resetfile();
    return false;
}

function fileUpload(form) {

    var strHTML, UniqKey, DivName, strInnerHTML;
    var AryContent, OrgFileName, OrgFileNameLn;
    var flag = "send";

    try {
        if (sTop.fu_AddFile.value == "") {
            alert("전송할 파일을 선택해 주세요.");
            return false;
        }

        // Create the iframe...
        var iframe = document.createElement("iframe");
        iframe.setAttribute("id", "upload_iframe");
        iframe.setAttribute("name", "upload_iframe");
        iframe.setAttribute("width", "0");
        iframe.setAttribute("height", "0");
        iframe.setAttribute("border", "0");
        iframe.setAttribute("style", "width: 0; height: 0; border: none;");

        // Add to document...
        form.parentNode.appendChild(iframe);
        window.frames['upload_iframe'].name = "upload_iframe";
        iframeId = document.getElementById("upload_iframe");

        // Add event...
        var eventHandler = function() {
            if (iframeId.detachEvent)
                iframeId.detachEvent("onload", eventHandler);
            else
                iframeId.removeEventListener("load", eventHandler, false);

            // Message from server...
            if (iframeId.contentDocument) {
                content = iframeId.contentDocument.body.innerHTML;
            } else if (iframeId.contentWindow) {
                content = iframeId.contentWindow.document.body.innerHTML;
            } else if (iframeId.document) {
                content = iframeId.document.body.innerHTML;
            }

            if (content != "TCF") {

                AryContent = content.split('|');
                strHTML = document.getElementById("Div_FileInfo").innerHTML;

                UniqKey = parseInt(document.getElementById("Div_FileInfo").children.length) + 1;
                DivName = "Div_FileInfoItem" + UniqKey.toString();
                UniqKey = "FileInfoItem" + UniqKey.toString();

                OrgFileName = AryContent[0];
                OrgFileNameLn = GetCharByte(OrgFileName);
                if (OrgFileNameLn > 18) {
                    OrgFileName = OrgFileName.substring(0, 16) + "...";
                }

                strInnerHTML = '<div id="' + DivName + '" uniqkey="' + UniqKey.toString() + '" class="RecvBoxBottomtBorder HandCursor">';
                strInnerHTML = strInnerHTML + '<span class="css_fu_TableKey">' + AryContent[4] + '</span>';
                strInnerHTML = strInnerHTML + '<span class="css_fu_CheckBox"></span>';
                strInnerHTML = strInnerHTML + '<span class="css_fu_OrgFileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')" title="' + AryContent[0] + '">' + OrgFileName + '</span>';
                strInnerHTML = strInnerHTML + '<span class="css_fu_FileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + AryContent[1] + '</span>';
                strInnerHTML = strInnerHTML + '<span class="css_fu_Pages" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + AryContent[2] + '</span>';
                strInnerHTML = strInnerHTML + '<span class="css_fu_FileSize" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + AryContent[3] + 'KB</span>';
                strInnerHTML = strInnerHTML + '<span class="css_fu_PreviewBtn"><img src="../Images/btn_add_preview.gif" align="absmiddle" OnClick="FileInfoItemPreview(\'' + flag + '\', \'' + UniqKey.toString() + '\', \'' + AryContent[4] + '\', \'' + AryContent[1] + '\', 3, false)" border="0"></span>';
               //strInnerHTML = strInnerHTML + '<span class="css_fu_SaveBoxBtn"><img src="../Images/btn_add_savebox.gif" align="absmiddle" OnClick="FileInfoItemSaveBox(\'' + UniqKey.toString() + '\', \'' + AryContent[4] + '\', \'' + AryContent[0] + '\', \'' + AryContent[1] + '\', \'' + AryContent[2] + '\', \'' + AryContent[3] + '\')" border="0"></span>';
                strInnerHTML = strInnerHTML + '<span class="css_fu_RemoveBtn"><img src="../Images/sms_btn_del.gif" OnClick="FileInfoItemRemove(\'' + UniqKey.toString() + '\')" border="0"></span>';
                strInnerHTML = strInnerHTML + '</div>';

                document.getElementById("Div_FileInfo").innerHTML = strHTML + strInnerHTML;

                document.getElementById("Div_AddFileMessage").style.display = "none";
                resetfile();

                FilePageCount(AryContent[2]);
            }
            else {
                alert("파일변환을 하지 못했습니다.\n\n파일변환을 하지 못하는 경우 확인사항을 참고해 주시기 바랍니다.");
                document.getElementById("Div_AddFileMessage").style.display = "none";
                resetfile();
            }

            // Del the iframe...
            setTimeout('iframeId.parentNode.removeChild(iframeId)', 250);
        }

        if (iframeId.addEventListener) iframeId.addEventListener("load", eventHandler, true);
        if (iframeId.attachEvent) iframeId.attachEvent("onload", eventHandler);

        // Set properties of form...
        form.setAttribute("target", "upload_iframe");
        form.setAttribute("action", "FaxSendFileUpload.aspx?ProgressID=0");
        form.setAttribute("method", "post");
        form.setAttribute("enctype", "multipart/form-data");
        form.setAttribute("encoding", "multipart/form-data");

        // Submit the form...
        form.submit();
        document.getElementById("Div_AddFileMessage").style.display = "";
    } catch (e) {
        alert("파일등록 작업 중 오류가 발생하였습니다.\n화면을 닫으신 후, 다시 접속하셔서 사용해 주시기 바랍니다.");
    }
}



function fileUploadResend(parm) {
    var strHTML, UniqKey, DivName, OrgFileName, OrgFileNameLn;
    var strInnerHTML, intPages;
    var SelectCount = 0;
    var FileList;
    var flag = "recv";

    FileList = parm.split('†');

    for (var k = 0; k < FileList.length; k++) {

        var content = FileList[k];
        SelectCount += 1;

        if (content.length > 0) {
            var AryContent = content.split('‡');
            var TifFileName = Replace(AryContent[1], "FaxRecvResult_", "");

            var DocuName = unescape(AryContent[1]);
            var PageNo = AryContent[2];
            var FileSize = AryContent[4];

            strHTML = document.getElementById("Div_FileInfo").innerHTML;
            UniqKey = parseInt(document.getElementById("Div_FileInfo").children.length) + 1;
            DivName = "Div_FileInfoItem" + UniqKey.toString();
            UniqKey = "FileInfoItem" + UniqKey.toString();

            OrgFileName = "";
            OrgFileNameLn = GetCharByte(DocuName);
            if (OrgFileNameLn > 18) {
                OrgFileName = DocuName.substring(0, 16) + "...";
            }

            strInnerHTML = '<div id="' + DivName + '" uniqkey="' + UniqKey.toString() + '" class="RecvBoxBottomtBorder HandCursor">';
            strInnerHTML = strInnerHTML + '<span class="css_fu_TableKey">' + TifFileName + '</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_CheckBox"></span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_OrgFileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')" title="' + DocuName + '">' + OrgFileName + '</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_FileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">받은문서</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_Pages" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + PageNo + '</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_FileSize" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + FileSize + 'KB</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_PreviewBtn"><img src="../Images/btn_add_preview.gif" align="absmiddle" OnClick="FileInfoItemPreview(\'' + flag + '\', \'' + UniqKey.toString() + '\', \'' + TifFileName + '\', \'' + TifFileName + '\', 3, false)" border="0"></span>';
           // strInnerHTML = strInnerHTML + '<span class="css_fu_SaveBoxBtn"></span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_RemoveBtn"><img src="../Images/sms_btn_del.gif" OnClick="FileInfoItemRemove(\'' + UniqKey.toString() + '\')" border="0"></span>';
            strInnerHTML = strInnerHTML + '</div>';

            document.getElementById("Div_FileInfo").innerHTML = strHTML + strInnerHTML;

            document.getElementById("Div_AddFileMessage").style.display = "none";
            document.getElementById("ied").innerHTML = document.getElementById("ied").innerHTML;

            var intPages = parseInt(document.getElementById("FilePageCountText").innerHTML);
            intPages = intPages + parseInt(PageNo);

            document.getElementById("FilePageCountText").innerHTML = intPages.toString();

        }
    }

    if (SelectCount == 0) {
        alert("첨부할 문서가 잘못되었습니다. 다시 확인바랍니다.");
        return false;
    }

    return false;
}


function FilePageCount(PageCount) {
    var intPages = parseInt(document.getElementById("FilePageCountText").innerHTML);
    intPages = intPages + parseInt(PageCount);

    document.getElementById("FilePageCountText").innerHTML = intPages.toString();
}

function resetfile() {
    document.getElementById("ied").innerHTML = document.getElementById("ied").innerHTML;
}

function FileInfoItemClick(uKey) {
    var strHTML;

    if (uKey.length > 0) {
        sTop.HidFileSelectItem.value = uKey;

        strHTML = document.getElementById("Div_FileInfo").innerHTML;
        for (var i = 0; i < document.getElementById("Div_FileInfo").children.length; i++) {
            var s = document.getElementById("Div_FileInfo").children[i].id;
            s = Replace(s, "Div_FileInfoItem", "FileInfoItem");
            if (s != uKey) {
                document.getElementById("Div_FileInfo").children[i].style.backgroundColor = "#ffffff";
            }
            else {
                document.getElementById("Div_FileInfo").children[i].style.backgroundColor = "#f8f8f8";
            }
        }
    }
}

function FileInfoItemPreview(flag, uniqKey, PathName, FileName, ServiceType, IsFaxSaveBox) {
   
    document.FilePreviewFrame.location.href = "FaxFilePreview.aspx?PathName=" + PathName + "&FileName=" + FileName + "&IsFaxSaveBox=" + IsFaxSaveBox + "&ServiceType=" + ServiceType + "&flag=" + flag;
}

function FileInfoItemSaveBox(uniqKey, PathName, OrgFileName, FileName, PageNo, FileSize) {
    var ActionFile, DatatoSend;

    ActionFile = "AjaxFaxSend.aspx";
    DatatoSend = "JobFlag=AddSaveBox&PathName=" + PathName + "&OrgFileName=" + escape(OrgFileName) + "&FileName=" + FileName + "&PageNo=" + PageNo + "&FileSize=" + FileSize;
    ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
    if (typeof ReturnValue != "undefined") {
        if (ReturnValue == "1") {
            alert("문서보관함에 저장 되었습니다.");
        }
        else if (ReturnValue == "2") {
            alert("최대 저장개수 20개를 초과 하여, 저장할 수 없습니다.");
        }
        else {
            alert("문서보관함에 저장 중 오류가 발생하였습니다.");
        }
    }
}

function FileInfoItemRemove(uKey) {
    var strHTML;
    var strFileHTML = "";
    var PageCount;

    if (uKey.length > 0) {
        strHTML = document.getElementById("Div_FileInfo").innerHTML;
        for (var i = 0; i < document.getElementById("Div_FileInfo").children.length; i++) {
            var s = document.getElementById("Div_FileInfo").children[i].id;
            s = Replace(s, "Div_FileInfoItem", "FileInfoItem");

            if (s == uKey) {
                PageCount = document.getElementById("Div_FileInfo").children[i].children[4].innerHTML;
                PageCount = parseInt(PageCount) * -1;
            }
            else {
                strFileHTML = strFileHTML + document.getElementById("Div_FileInfo").children[i].outerHTML;
            }
        }

        document.getElementById("Div_FileInfo").innerHTML = strFileHTML;

        FilePageCount(PageCount);
    }
}

function RecvInfoAdd() {
    var strHTML, strInnerHTML;
    var DivName, UniqKey;

    var AddrMode = sTop.HidAddrMode.value;
    var UserName = sTop.tBox_RecvUserName.value;
    var ComName = sTop.tBox_RecvComName.value;
    var MobileNo = sTop.tBox_RecvMobileNo.value;
    var FaxNo;

    if (MobileNo != "") {
        if (MobileNo.length < 10) {
            alert("잘못된 휴대폰 번호 입니다. [" + MobileNo + "]\n확인 후 다시 입력해 주세요.");
            return false;
        }
        else if (MobileNo.substring(0, 3) != "010" && MobileNo.substring(0, 3) != "011" && MobileNo.substring(0, 3) != "016" && MobileNo.substring(0, 3) != "017" && MobileNo.substring(0, 3) != "018" && MobileNo.substring(0, 3) != "019") {
            alert("잘못된 휴대폰 번호 입니다. [" + MobileNo + "]\n확인 후 다시 입력해 주세요.");
            return false;
        }
        else if (!IsMobileNo(MobileNo)) {
            alert("잘못된 휴대폰 번호 입니다. [" + MobileNo + "]\n휴대폰 번호는 숫자, - 만 입력할 수 있습니다.\n\n확인 후 다시 입력해 주세요.");
            return false;
        }
    }

    if (sTop.tBox_RecvFaxNo.value == "") {
        alert("받을팩스 번호를 입력해 주세요.");
        return false;
    }
    else if (sTop.tBox_RecvFaxNo.value.length < 8) {
        alert("잘못된 팩스번호 입니다. [" + sTop.tBox_RecvFaxNo.value + "]\n확인 후 다시 입력해 주세요.");
        sTop.tBox_RecvFaxNo.value = "";
        return false;
    }
    else if ((sTop.cBox_NationalFax.checked) && (sTop.ddl_NationalFaxInfo.selectedIndex == 0)) {
        alert("국제팩스를 보낼 국가를 선택해 주세요.");
        return false;
    }

    if (sTop.cBox_NationalFax.checked == false) {
        FaxNo = sTop.tBox_RecvFaxNo.value;

        if (!IsFaxNo(FaxNo)) {
            alert("잘못된 팩스번호 입니다. [" + FaxNo + "]\n확인 후 다시 입력해 주세요.");
            return false;
        }
    }
    else {
        FaxNo = "+" + sTop.ddl_NationalFaxInfo[sTop.ddl_NationalFaxInfo.selectedIndex].value.split('|')[0] + "," + sTop.tBox_RecvFaxNo.value;

        if (!IsInterFaxNo(FaxNo)) {
            alert("잘못된 팩스번호 입니다. [" + FaxNo + "]\n확인 후 다시 입력해 주세요.");
            return false;
        }
    }

    if ((AddrMode == "") || (AddrMode == "Add")) {
        strHTML = document.getElementById("Div_RecvInfo").innerHTML;

        UniqKey = parseInt(document.getElementById("Div_RecvInfo").children.length) + 1;
        DivName = "Div_RecvInfoItem" + UniqKey.toString();
        UniqKey = "RecvInfoItem" + UniqKey.toString();

        strInnerHTML = '<div id="' + DivName + '" uniqkey="' + UniqKey.toString() + '" class="RecvBoxBottomtBorder HandCursor">';
        strInnerHTML = strInnerHTML + '<span class="css_CheckBox"><input type="checkbox" name="cBox' + UniqKey.toString() + '"></span>';
        strInnerHTML = strInnerHTML + '<span class="css_UserName" OnClick="RecvInfoItemClick(\'' + UniqKey.toString() + '\')">' + UserName + '</span>';
        strInnerHTML = strInnerHTML + '<span class="css_ComName" OnClick="RecvInfoItemClick(\'' + UniqKey.toString() + '\')">' + ComName + '</span>';
        strInnerHTML = strInnerHTML + '<span class="css_MobileNo" OnClick="RecvInfoItemClick(\'' + UniqKey.toString() + '\')">' + MobileNo + '</span>';
        strInnerHTML = strInnerHTML + '<span class="css_FaxNo" OnClick="RecvInfoItemClick(\'' + UniqKey.toString() + '\')">' + FaxNo + '</span>';
        strInnerHTML = strInnerHTML + '<span class="css_RemoveBtn"><img src="../Images/sms_btn_del.gif" OnClick="RecvInfoItemRemove(\'' + UniqKey.toString() + '\')" border="0"></span>';
        strInnerHTML = strInnerHTML + '</div>';

        document.getElementById("Div_RecvInfo").innerHTML = strInnerHTML + strHTML;
    }
    else if (AddrMode == "Modify") {
        var AddrSelectItem = sTop.HidAddrSelectItem.value;
        for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
            var s = document.getElementById("Div_RecvInfo").children[i].id;
            s = Replace(s, "Div_RecvInfoItem", "RecvInfoItem");

            if (s == AddrSelectItem) {
                document.getElementById("Div_RecvInfo").children[i].style.backgroundColor = "#ffffff";
                document.getElementById("Div_RecvInfo").children[i].children[1].innerHTML = UserName;
                document.getElementById("Div_RecvInfo").children[i].children[2].innerHTML = ComName;
                document.getElementById("Div_RecvInfo").children[i].children[3].innerHTML = MobileNo;
                document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML = FaxNo;
            }
        }

        document.getElementById("ib_RecvInfoAdd").src = "../Images/btnaddradd.gif";

        sTop.HidAddrMode.value = "";
        sTop.HidAddrSelectItem.value = "";
    }

    RecvInfoCount();

    sTop.tBox_RecvUserName.value = "";
    sTop.tBox_RecvComName.value = "";
    sTop.tBox_RecvMobileNo.value = "";
    sTop.tBox_RecvFaxNo.value = "";

    //국제팩스 초기화
    sTop.cBox_NationalFax.checked = false;
    document.getElementById("ddl_NationalFaxInfo").disabled = true;
    sTop.ddl_NationalFaxInfo.selectedIndex = 0;
    document.getElementById("Div_NationalFAX_NationalName").innerText = "";
    document.getElementById("Div_NationalFAX_SendMoney").innerText = "";
    document.getElementById("Div_NationalFax").style.display = "none";

    //FaxSendInit();
    sTop.tBox_RecvMobileNo.style.background = "url(../Images/exmobileno.gif) no-repeat 3px 2px #ffffff";
    sTop.tBox_RecvFaxNo.style.background = (sTop.cBox_NationalFax.checked == false) ? "url(../Images/exfaxno.gif) no-repeat 3px 2px #ffffff" : "url(../Images/exnationalfaxno.gif) no-repeat 3px 2px #ffffff";
    document.getElementById("ddl_NationalFaxInfo").disabled = true;

    sTop.tBox_RecvUserName.focus();


    return false;
}

function RecvInfoCount() {
    document.getElementById("RecvInfoCountText").innerHTML = document.getElementById("Div_RecvInfo").children.length;
}

function RecvInfoItemClick(uKey) {
    var strHTML;

    if (uKey.length > 0) {
        sTop.HidAddrMode.value = "Modify";
        sTop.HidAddrSelectItem.value = uKey;

        strHTML = document.getElementById("Div_RecvInfo").innerHTML;
        for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
            var s = document.getElementById("Div_RecvInfo").children[i].id;
            s = Replace(s, "Div_RecvInfoItem", "RecvInfoItem");

            if (s != uKey) {
                document.getElementById("Div_RecvInfo").children[i].style.backgroundColor = "#ffffff";
            }
            else {
                document.getElementById("Div_RecvInfo").children[i].style.backgroundColor = "#f8f8f8";
                sTop.tBox_RecvUserName.value = document.getElementById("Div_RecvInfo").children[i].children[1].innerHTML;
                sTop.tBox_RecvComName.value = document.getElementById("Div_RecvInfo").children[i].children[2].innerHTML;
                sTop.tBox_RecvMobileNo.value = document.getElementById("Div_RecvInfo").children[i].children[3].innerHTML;

                if (document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML.lastIndexOf("+") >= 0) {
                    var AryRecvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML.split(',');
                    FindNationalFax(Replace(AryRecvFaxNo[0], "+", ""));
                    sTop.tBox_RecvFaxNo.value = AryRecvFaxNo[1];
                }
                else {
                    sTop.tBox_RecvFaxNo.value = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML;
                }

                document.getElementById("ib_RecvInfoAdd").src = "../Images/btnaddrmodify.gif";

                tBoxFocusIn("MobileNo");
                tBoxFocusIn("FaxNo");
            }
        }
    }
}

function FindNationalFax(NationalCode) {
    for (var i = 0; i < sTop.ddl_NationalFaxInfo.length; i++) {
        if (sTop.ddl_NationalFaxInfo[i].value.split('|')[0] == NationalCode) {
            sTop.ddl_NationalFaxInfo.selectedIndex = i;

            sTop.cBox_NationalFax.checked = true;
            document.getElementById("ddl_NationalFaxInfo").disabled = false;
            if (sTop.tBox_RecvFaxNo.value == "") sTop.tBox_RecvFaxNo.style.background = "url(../Images/exnationalfaxno.gif) no-repeat 3px 2px #ffffff";
            document.getElementById("Div_NationalFax").style.display = "";
            document.getElementById("Div_NationalFAX_NationalName").innerText = sTop.ddl_NationalFaxInfo[i].text + "[" + NationalCode + "]";
            document.getElementById("Div_NationalFAX_SendMoney").innerText = sTop.ddl_NationalFaxInfo[i].value.split('|')[1];

            break;
        }
    }
}

function RecvUserNameKeyDown() {
    if (event.keyCode == 13) {
        sTop.tBox_RecvComName.focus();
    }
}

function RecvComNameKeyDown() {
    if (event.keyCode == 13) {
        sTop.tBox_RecvMobileNo.focus();
    }
}

function RecvMobileNoKeyDown() {
    if (event.keyCode == 13) {
        sTop.tBox_RecvFaxNo.focus();
    }
}

function FaxNoKeyDown() {
    if (event.keyCode == 13) {
        RecvInfoAdd();
    }
}

function RecvInfoItemRemove(uKey) {
    var strHTML;
    var strRecvNoHTML = "";

    if (uKey.length > 0) {
        strHTML = document.getElementById("Div_RecvInfo").innerHTML;
        for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
            var s = document.getElementById("Div_RecvInfo").children[i].id;
            s = Replace(s, "Div_RecvInfoItem", "RecvInfoItem");

            if (s == uKey) {
            }
            else {
                strRecvNoHTML = strRecvNoHTML + document.getElementById("Div_RecvInfo").children[i].outerHTML;
            }
        }

        document.getElementById("Div_RecvInfo").innerHTML = strRecvNoHTML;

        sTop.HidAddrMode.value = "Add";
        document.getElementById("ib_RecvInfoAdd").src = "../Images/btnaddradd.gif";

        sTop.tBox_RecvUserName.value = "";
        sTop.tBox_RecvComName.value = "";
        sTop.tBox_RecvMobileNo.value = "";
        sTop.tBox_RecvFaxNo.value = "";

        //국제팩스 초기화
        sTop.cBox_NationalFax.checked = false;
        document.getElementById("ddl_NationalFaxInfo").disabled = true;
        sTop.ddl_NationalFaxInfo.selectedIndex = 0;
        document.getElementById("Div_NationalFAX_NationalName").innerText = "";
        document.getElementById("Div_NationalFAX_SendMoney").innerText = "";
        document.getElementById("Div_NationalFax").style.display = "none";

        //FaxSendInit();
        sTop.tBox_RecvMobileNo.style.background = "url(../Images/exmobileno.gif) no-repeat 3px 2px #ffffff";
        sTop.tBox_RecvFaxNo.style.background = (sTop.cBox_NationalFax.checked == false) ? "url(../Images/exfaxno.gif) no-repeat 3px 2px #ffffff" : "url(../Images/exnationalfaxno.gif) no-repeat 3px 2px #ffffff";
        document.getElementById("ddl_NationalFaxInfo").disabled = true;

        RecvInfoCount();
    }
}

function AddrAllSelectClick() {
    AddrAllSelect();
    return false;
}

function AddrAllSelect() {
    var chkvalue;

    if ((sTop.HidAddrAllSelect.value == "") || (sTop.HidAddrAllSelect.value == "F")) {
        sTop.HidAddrAllSelect.value = "T";
        chkvalue = true;
    }
    else {
        sTop.HidAddrAllSelect.value = "F";
        chkvalue = false;
    }

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if ((!sTop.item(i).disabled) && (sTop.item(i).name.substring(0, 16) == "cBoxRecvInfoItem")) {
                sTop.item(i).checked = chkvalue;
            }
        }
    }

    return false;
}

function AddrCheckRemove() {
    var uniqValue;

    for (var i = sTop.length - 1; i > 0; i--) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if ((sTop.item(i).name.substring(0, 16) == "cBoxRecvInfoItem") && (sTop.item(i).checked)) {
                uniqValue = Replace(sTop.item(i).name, "cBox", "");
                RecvInfoItemRemove(uniqValue);
            }
        }
    }

    sTop.HidAddrAllSelect.value = "";
    sTop.cBox_RecvInfoAllCheck.checked = false;

    return false;
}

function NationalFax() {
    if (sTop.cBox_NationalFax.checked) {
        document.getElementById("ddl_NationalFaxInfo").disabled = false;
        if (sTop.tBox_RecvFaxNo.value == "") sTop.tBox_RecvFaxNo.style.background = "url(../Images/exnationalfaxno.gif) no-repeat 3px 2px #ffffff";
        document.getElementById("Div_NationalFax").style.display = "";
    } else {
        document.getElementById("ddl_NationalFaxInfo").disabled = true;
        sTop.ddl_NationalFaxInfo.selectedIndex = 0;
        sTop.tBox_RecvFaxNo.value = "";
        sTop.tBox_RecvFaxNo.style.background = "url(../Images/exfaxno.gif) no-repeat 3px 2px #ffffff";
        document.getElementById("Div_NationalFAX_NationalName").innerText = "";
        document.getElementById("Div_NationalFAX_SendMoney").innerText = "";
        document.getElementById("Div_NationalFax").style.display = "none";
    }
}

function SelectNationFax() {
    var AryNationalInfo = sTop.ddl_NationalFaxInfo[sTop.ddl_NationalFaxInfo.selectedIndex].value.split('|');

    document.getElementById("Div_NationalFAX_NationalName").innerText = sTop.ddl_NationalFaxInfo[sTop.ddl_NationalFaxInfo.selectedIndex].text + "[" + AryNationalInfo[0] + "]";
    document.getElementById("Div_NationalFAX_SendMoney").innerText = AryNationalInfo[1];
}

function CoverInfo() {
    var winTop = "";
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var sUrl, wincover;
    var CVSendComName, CVSendUserName, CVSendFaxNo, CVSubject, CVMemo;
    var UniqKey, strInnerHTML, DivName;

    if (sTop.cBox_CoverUse.checked) {

        //표지 전송문서 추가
        strHTML = document.getElementById("Div_FileInfo").innerHTML;

        var sm_filePathName = "";
        for (var i = 0; i < document.getElementById("Div_FileInfo").children.length; i++) {
            sm_filePathName = document.getElementById("Div_FileInfo").children[i].children[0].innerHTML;
            if (sm_filePathName == "FaxCover") {
                break;
            }
        }

        if (sm_filePathName != "FaxCover") {
            UniqKey = 0;
            DivName = "Div_FileInfoItem" + UniqKey.toString();
            UniqKey = "FileInfoItem" + UniqKey.toString();

            strInnerHTML = '<div id="' + DivName + '" uniqkey="' + UniqKey.toString() + '" class="RecvBoxBottomtBorder HandCursor">';
            strInnerHTML = strInnerHTML + '<span class="css_fu_TableKey">FaxCover</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_CheckBox"></span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_OrgFileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')" title="팩스표지">팩스표지</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_FileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">팩스표지</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_Pages" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">1</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_FileSize" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">&nbsp;</span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_PreviewBtn"><img src="../Images/btn_add_preview.gif" align="absmiddle" OnClick="FileInfoCoverPreview()" border="0"></span>';
            //strInnerHTML = strInnerHTML + '<span class="css_fu_SaveBoxBtn"></span>';
            strInnerHTML = strInnerHTML + '<span class="css_fu_RemoveBtn"><img src="../Images/sms_btn_del.gif" OnClick="FileInfoFaxCoverRemove(\'' + UniqKey.toString() + '\')" border="0"></span>';
            strInnerHTML = strInnerHTML + '</div>';

            document.getElementById("Div_FileInfo").innerHTML = strInnerHTML + strHTML;
            FilePageCount(1);
        }

        //표지편집창 Open
        iWidth = 500;
        iHeight = 700;

        thisX = screen.availWidth;
        thisY = screen.availHeight;

        xx = (thisX - iWidth) / 2;
        yy = (thisY - iHeight) / 2;

        sUrl = "FaxCover.aspx";
        wincover = window.open(sUrl, "FaxCover", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
        wincover.focus();
    }
    else {
        FileInfoFaxCoverRemove('FileInfoItem0');
        sTop.HidCVSendComName.value = sTop.HidDFCVSendComName.value;
        sTop.HidCVSendUserName.value = sTop.HidDFCVSendUserName.value;
        sTop.HidCVSendFaxNo.value = sTop.HidDFCVSendFaxNo.value;
        sTop.HidCVSubject.value = "";
        sTop.HidCVMemo.value = "";
    }
}

function FileInfoCoverPreview() {
    var winTop = "";
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var sUrl, wincover;

    //표지편집창 Open
    iWidth = 500;
    iHeight = 700;

    thisX = screen.availWidth;
    thisY = screen.availHeight;

    xx = (thisX - iWidth) / 2;
    yy = (thisY - iHeight) / 2;

    sUrl = "FaxCover.aspx";
    wincover = window.open(sUrl, "FaxCover", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    wincover.focus();
}

function CoverInfoClick() {
    if (sTop.cBox_CoverUse.checked) {
        CoverInfo();
    }
    else {
        alert("표지를 사용하려면 사용에 체크해 주세요.");
    }

    return false;
}

function FileInfoFaxCoverRemove(uKey) {
    var strHTML;
    var strFileHTML = "";
    var PageCount;

    if (uKey.length > 0) {
        strHTML = document.getElementById("Div_FileInfo").innerHTML;
        for (var i = 0; i < document.getElementById("Div_FileInfo").children.length; i++) {
            var s = document.getElementById("Div_FileInfo").children[i].id;
            s = Replace(s, "Div_FileInfoItem", "FileInfoItem");

            if (s == uKey) {
                PageCount = document.getElementById("Div_FileInfo").children[i].children[4].innerHTML;
                PageCount = parseInt(PageCount) * -1;
            }
            else {
                strFileHTML = strFileHTML + document.getElementById("Div_FileInfo").children[i].outerHTML;
            }
        }

        document.getElementById("Div_FileInfo").innerHTML = strFileHTML;

        FilePageCount(PageCount);
    }

    sTop.cBox_CoverUse.checked = false;

    sTop.HidCVSendComName.value = sTop.HidDFCVSendComName.value;
    sTop.HidCVSendUserName.value = sTop.HidDFCVSendUserName.value;
    sTop.HidCVSendFaxNo.value = sTop.HidDFCVSendFaxNo.value;
    sTop.HidCVSubject.value = "";
    sTop.HidCVMemo.value = "";
}

function GetCoverInfo() {
    sTop.tBox_SendComName.value = unescape(opener.document.all.HidCVSendComName.value);
    sTop.tBox_SendUserName.value = unescape(opener.document.all.HidCVSendUserName.value);
    sTop.tBox_SendFaxNo.value = unescape(opener.document.all.HidCVSendFaxNo.value);
    sTop.tBox_Subject.value = unescape(opener.document.all.HidCVSubject.value);
    sTop.tBox_Memo.value = unescape(opener.document.all.HidCVMemo.value);
}

function FaxCoverModify(SendComName, SendUserName, SendFaxNo, Subject, Memo) {
    opener.document.all.HidCVSendComName.value = escape(sTop.tBox_SendComName.value);
    opener.document.all.HidCVSendUserName.value = escape(sTop.tBox_SendUserName.value);
    opener.document.all.HidCVSendFaxNo.value = escape(sTop.tBox_SendFaxNo.value);
    opener.document.all.HidCVSubject.value = escape(sTop.tBox_Subject.value);
    opener.document.all.HidCVMemo.value = escape(sTop.tBox_Memo.value);

    self.window.close();
}

function CoverMemoKeyup() {
    var str;
    var str_count = 0;
    var cut_count = 0;
    var smslen = 300;
    var IsPass = 0;
    var tmp_str = "";
    var str_length = sTop.tBox_Memo.value.length;

    for (k = 0; k < str_length; k++) {
        str = sTop.tBox_Memo.value.charAt(k);

        if (escape(str).length > 4) {
            str_count += 2;
        }
        else {
            if (navigator.appVersion.indexOf("MSIE 9") > -1) {
                if (escape(str) != '%0D') {
                    str_count++;
                }
            }
            else {
                if (escape(str) == '%0A') {
                    str_count++;
                }
                else if (escape(str) == '%0D') {
                }
                else {
                    str_count++;
                }
            }
        }
        if (str_count > smslen) {
            alert("300바이트 이내에서 작성할 수 있습니다."); 4
            if (escape(str).length > 4) str_count -= 2;
            else str_count--;
            sTop.tBox_Memo.value = sTop.tBox_Memo.value.substring(0, k);
            break;
        }
    }

    document.getElementById("MsgLength").innerHTML = str_count;
}

function FaxSendSummary() {
    try {
        var sUserNameSmry = "";
        var sComNameSmry = "";
        var sFaxNoSmry = "";
        var IsInterFaxUse = false;

        var sUserNameSmryLn, sComNameSmryLn, sFaxNoSmryLn;
        var FaxPrice, SMSPrice, LMSPrice;

        var FaxSendTotalPrice = 0;

        var agent;

        if (document.getElementById("Div_RecvInfo").children.length == 0) {
            alert("받을사람을 입력해 주세요.");
            return false;
        }

        if (document.getElementById("Div_FileInfo").children.length == 0) {
            alert("보낼파일을 입력해 주세요.");
            return false;
        }
        else {
            if (sTop.cBox_CoverUse.checked) {
                if (document.getElementById("Div_FileInfo").children.length == 1) {
                    alert("보낼파일을 입력해 주세요.");
                    return false;
                }
            }
        }

        if (sTop.rb_SendTime_Reserv.checked) {
            alert("예약보내기시, 발송요청 건의 예약취소는 불가합니다.");
        }

        agent = navigator.userAgent.toLowerCase();
        if (agent.indexOf('msie 7') > -1 && agent.indexOf('trident') > -1) {
            if (navigator.appVersion.indexOf('Trident/7.0') == -1) {
                sTop.td_FaxSendSmry_FaxNo.height = 20;
                sTop.td_FaxSendSmry_FaxPageCount.height = 21;
            }
        }
        else {
            if (navigator.appVersion.indexOf('Trident/4.0') >= -1) {
                sTop.td_FaxSendSmry_FaxNo.height = 20;
                sTop.td_FaxSendSmry_FaxPageCount.height = 21;
            }
        }

        var FaxPrice = parseInt(sTop.HidFaxPrice.value);
        var SMSPrice = parseInt(sTop.HidSMSPrice.value);
        var LMSPrice = parseInt(sTop.HidLMSPrice.value);
        var RecvNoCount = parseInt(document.getElementById("RecvInfoCountText").innerHTML);
        var FilePageCount = parseInt(document.getElementById("FilePageCountText").innerHTML);

        sTop.HidFaxSendFilePageCount.value = FilePageCount.toString();

        if (RecvNoCount > 1) {
            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvUser = document.getElementById("Div_RecvInfo").children[i].children[1].innerHTML;
                if (recvUser.length > 0) {
                    sUserNameSmry = recvUser;
                    break;
                }
            }

            if (sUserNameSmry.length > 0) {
                sUserNameSmryLn = GetCharByte(sUserNameSmry);
                if (sUserNameSmryLn > 20) {
                    sUserNameSmry = sUserNameSmry.substring(0, 8) + "...";
                }

                sUserNameSmry += " 외 " + (RecvNoCount - 1).toString() + "건";
            }

            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvComName = document.getElementById("Div_RecvInfo").children[i].children[2].innerHTML;
                if (recvComName.length > 0) {
                    sComNameSmry = recvComName;
                    break;
                }
            }

            if (sComNameSmry.length > 0) {
                sComNameSmryLn = GetCharByte(sComNameSmry);
                if (sComNameSmryLn > 20) {
                    sComNameSmry = sComNameSmry.substring(0, 8) + "...";
                }

                sComNameSmry += " 외 " + (RecvNoCount - 1).toString() + "건";
            }

            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML;
                if (recvFaxNo.length > 0) {
                    sFaxNoSmry = recvFaxNo;
                    break;
                }
            }

            if (sFaxNoSmry.length > 0) {
                sFaxNoSmry += " 외 " + (RecvNoCount - 1).toString() + "건";
            }

            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML;
                if (recvFaxNo.indexOf("+") >= 0) {
                    IsInterFaxUse = true;
                }
            }
        }
        else {
            sUserNameSmry = document.getElementById("Div_RecvInfo").children[0].children[1].innerHTML;
            sComNameSmry = document.getElementById("Div_RecvInfo").children[0].children[2].innerHTML;
            sFaxNoSmry = document.getElementById("Div_RecvInfo").children[0].children[4].innerHTML;
            if (sFaxNoSmry.indexOf("+") >= 0) {
                IsInterFaxUse = true;
            }
        }

        sUserNameSmry = (sUserNameSmry.length == 0) ? "&nbsp;" : sUserNameSmry;
        sComNameSmry = (sComNameSmry.length == 0) ? "&nbsp;" : sComNameSmry;

        document.getElementById("Div_FaxSendSmry_ComName").innerHTML = sComNameSmry;
        document.getElementById("Div_FaxSendSmry_UserName").innerHTML = sUserNameSmry;
        document.getElementById("Div_FaxSendSmry_FaxNo").innerHTML = sFaxNoSmry;
        document.getElementById("Div_FaxSendSmry_FaxPageCount").innerHTML = FilePageCount.toString() + "장";
        if (sTop.cBox_CoverUse.checked) {
            if (IsInterFaxUse == false) {
                document.getElementById("Div_FaxSendSmry_FaxPageCount").innerHTML += " (표지 1장 포함 / 추가 40포인트)";
            }
            else {
                document.getElementById("Div_FaxSendSmry_FaxPageCount").innerHTML += " (표지 1장 포함)";
            }
        }

        if (IsInterFaxUse == false) {
            FaxSendTotalPrice = FaxPrice * FilePageCount * RecvNoCount;
        } else {
            var qFaxPrice = 0;
            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML
                if (recvFaxNo.indexOf("+") >= 0) {
                    recvFaxNo = Replace(recvFaxNo, "+", "");
                    var AryrecvFaxNo = recvFaxNo.split(',');
                    qFaxPrice += GetNationalFaxPrice(AryrecvFaxNo[0]);
                } else {
                    qFaxPrice += FaxPrice;
                }
            }

            FaxSendTotalPrice = qFaxPrice * FilePageCount;
        }

        document.getElementById("Div_FaxSendSmry_SendPrice").innerHTML = FaxSendTotalPrice.toString();

        document.getElementById("Div_RecvBox").className = "DivRecvInfoBoxArea RecvBoxOpacityStyle";
        document.getElementById("Div_HtmlBody").className = "FaxSendSummaryOpacityStyle";
        document.getElementById("Div_FaxSendSummary").style.display = "";

        //수신처 정보
        var sm_recvInfo = "";
        var sm_recvUserName, sm_recvComName, sm_recvMobileNo, sm_recvFaxNo;
        for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
            sm_recvUserName = document.getElementById("Div_RecvInfo").children[i].children[1].innerHTML;
            sm_recvComName = document.getElementById("Div_RecvInfo").children[i].children[2].innerHTML;
            sm_recvMobileNo = document.getElementById("Div_RecvInfo").children[i].children[3].innerHTML;
            sm_recvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML;

            if (sm_recvInfo.length > 0)
                sm_recvInfo += "‡" + sm_recvUserName + "¶" + sm_recvComName + "¶" + sm_recvMobileNo + "¶" + sm_recvFaxNo;
            else
                sm_recvInfo = sm_recvUserName + "¶" + sm_recvComName + "¶" + sm_recvMobileNo + "¶" + sm_recvFaxNo;
        }

        sTop.HidFaxSendRecvNoInfo.value = sm_recvInfo;

        //발송파일 정보
        var sm_fileInfo = "";
        var sm_filePathName, sm_fileName;
        var intLoop = 0;
        if (sTop.cBox_CoverUse.checked) intLoop = 1;
        for (var i = intLoop; i < document.getElementById("Div_FileInfo").children.length; i++) {
            sm_filePathName = document.getElementById("Div_FileInfo").children[i].children[0].innerHTML;
            sm_fileName = document.getElementById("Div_FileInfo").children[i].children[3].innerHTML;

            if (sm_fileInfo.length > 0)
                sm_fileInfo += "‡" + sm_filePathName + "¶" + sm_fileName;
            else
                sm_fileInfo = sm_filePathName + "¶" + sm_fileName;
        }

        sTop.HidFaxSendFileInfo.value = sm_fileInfo;

        return false;
    }
    catch (e) {
        return false;
    }
}

function FaxSendSummaryCancel() {

    document.getElementById("Div_FaxSendSmry_ComName").innerHTML = "";
    document.getElementById("Div_FaxSendSmry_UserName").innerHTML = "";
    document.getElementById("Div_FaxSendSmry_FaxNo").innerHTML = "";
    document.getElementById("Div_FaxSendSmry_FaxPageCount").innerHTML = "";
    document.getElementById("Div_FaxSendSmry_SendPrice").innerHTML = "";

    document.getElementById("Div_HtmlBody").className = "";
    document.getElementById("Div_RecvBox").className = "DivRecvInfoBoxArea";
    document.getElementById("Div_FaxSendSummary").style.display = "none";
    return false;
}

function FaxSendSubmit() {

    document.form1.setAttribute("target", "");
    document.form1.setAttribute("action", "FaxSend.aspx");
    document.form1.setAttribute("method", "post");
    document.form1.setAttribute("enctype", "");

    return true;
}

function FaxConvertGuidOpen() {
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var sUrl, winguide;

    iWidth = 449;
    iHeight = 338;

    thisX = screen.availWidth;
    thisY = screen.availHeight;

    xx = (thisX - iWidth) / 2;
    yy = (thisY - iHeight) / 2;

    sUrl = "FileConvertGuide.html";
    winguide = window.open(sUrl, "FileConvertGuide", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    winguide.focus();
}

function FaxConvertGuidClose() {
    self.window.close();
}

function FaxSendSummary2() {
    try {
        var UserName = "";
        var sUserNameSmry = "";
        var sComNameSmry = "";
        var sFaxNoSmry = "";
        var sFaxNoSingleSmry = "";
        var sFaxNoSmryCount = 0;
        var sMobileNoSmry = "";
        var sMobileNoSmryCount = 0;
        var sSMSMsg;
        var IsInterFaxUse = false;
        var SendDetailPrice = "";
        var agent;

        var sUserNameSmryLn, sComNameSmryLn, sFaxNoSmryLn, sMobileNoSmryLn;
        var FaxPrice, SMSPrice, LMSPrice;

        var FaxSendTotalPrice = 0;

        if (document.getElementById("Div_RecvInfo").children.length == 0) {
            alert("받을사람을 입력해 주세요.");
            return false;
        }

        if (document.getElementById("Div_FileInfo").children.length == 0) {
            alert("보낼파일을 입력해 주세요.");
            return false;
        }
        else {
            if (sTop.cBox_CoverUse.checked) {
                if (document.getElementById("Div_FileInfo").children.length == 1) {
                    alert("보낼파일을 입력해 주세요.");
                    return false;
                }
            }
        }

        if (sTop.rb_SendTime_Reserv.checked) {
            alert("예약보내기시, 발송요청 건의 예약취소는 불가합니다.");
        }

        agent = navigator.userAgent.toLowerCase();
        if (agent.indexOf('msie 7') > -1 && agent.indexOf('trident') > -1) {
            if (navigator.appVersion.indexOf('Trident/7.0') == -1) {
                sTop.td_FaxSendSmry2_FaxNo.height = 20;
                sTop.td_FaxSendSmry2_MobileNo.height = 20;
                sTop.td_FaxSendSmry2_CallbackNo.height = 12;
                sTop.td_FaxSendSmry2_FaxCoverPrice.height = 20;
            }
        }
        else {
            if (navigator.appVersion.indexOf('Trident/4.0') >= -1) {
                sTop.td_FaxSendSmry2_FaxNo.height = 20;
                sTop.td_FaxSendSmry2_MobileNo.height = 20;
                sTop.td_FaxSendSmry2_CallbackNo.height = 12;
                sTop.td_FaxSendSmry2_FaxCoverPrice.height = 20;
            }
        }

        UserName = sTop.HidUserName.value;
        var FaxPrice = parseInt(sTop.HidFaxPrice.value);
        var SMSPrice = parseInt(sTop.HidSMSPrice.value);
        var LMSPrice = parseInt(sTop.HidLMSPrice.value);
        var RecvNoCount = parseInt(document.getElementById("RecvInfoCountText").innerHTML);
        var FilePageCount = parseInt(document.getElementById("FilePageCountText").innerHTML);

        sTop.HidFaxSendFilePageCount.value = FilePageCount.toString();

        if (RecvNoCount > 1) {
            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvUser = document.getElementById("Div_RecvInfo").children[i].children[1].innerHTML;
                if (recvUser.length > 0) {
                    sUserNameSmry = recvUser;
                    break;
                }
            }

            if (sUserNameSmry.length > 0) {
                sUserNameSmryLn = GetCharByte(sUserNameSmry);
                if (sUserNameSmryLn > 20) {
                    sUserNameSmry = sUserNameSmry.substring(0, 8) + "...";
                }

                sUserNameSmry += " 외 " + (RecvNoCount - 1).toString() + "건";
            }

            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvComName = document.getElementById("Div_RecvInfo").children[i].children[2].innerHTML;
                if (recvComName.length > 0) {
                    sComNameSmry = recvComName;
                    break;
                }
            }

            if (sComNameSmry.length > 0) {
                sComNameSmryLn = GetCharByte(sComNameSmry);
                if (sComNameSmryLn > 20) {
                    sComNameSmry = sComNameSmry.substring(0, 8) + "...";
                }

                sComNameSmry += " 외 " + (RecvNoCount - 1).toString() + "건";
            }

            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvMobileNo = document.getElementById("Div_RecvInfo").children[i].children[3].innerHTML;
                if (recvMobileNo.length > 0) {
                    if (sMobileNoSmry.length == 0) {
                        sMobileNoSmry = recvMobileNo;
                    }

                    sMobileNoSmryCount += 1;
                }
            }

            if (sMobileNoSmryCount > 0) {
                sMobileNoSmry = sMobileNoSmry + " 외 " + (sMobileNoSmryCount - 1).toString() + "건";
            }

            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML;
                if (recvFaxNo.length > 0) {
                    sFaxNoSingleSmry = recvFaxNo;
                    sFaxNoSmry = recvFaxNo;
                    break;
                }
            }

            if (sFaxNoSmry.length > 0) {
                sFaxNoSmry += " 외 " + (RecvNoCount - 1).toString() + "건";
            }

            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML;
                if (recvFaxNo.indexOf("+") >= 0) {
                    IsInterFaxUse = true;
                }
            }
        }
        else {
            sUserNameSmry = document.getElementById("Div_RecvInfo").children[0].children[1].innerHTML;
            sComNameSmry = document.getElementById("Div_RecvInfo").children[0].children[2].innerHTML;
            sMobileNoSmry = document.getElementById("Div_RecvInfo").children[0].children[3].innerHTML;
            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvMobileNo = document.getElementById("Div_RecvInfo").children[i].children[3].innerHTML;
                if (recvMobileNo.length > 0) {
                    if (sMobileNoSmry.length == 0) {
                        sMobileNoSmry = recvMobileNo;
                    }

                    sMobileNoSmryCount += 1;
                }
            }
            sFaxNoSmry = document.getElementById("Div_RecvInfo").children[0].children[4].innerHTML;
            if (sFaxNoSmry.indexOf("+") >= 0) {
                IsInterFaxUse = true;
            }
            sFaxNoSingleSmry = sFaxNoSmry;
        }

        sSMSMsg = sFaxNoSingleSmry + "로 " + UserName + "님께서 팩스를 보내셨습니다."
        sUserNameSmry = (sUserNameSmry.length == 0) ? "&nbsp;" : sUserNameSmry;
        sComNameSmry = (sComNameSmry.length == 0) ? "&nbsp;" : sComNameSmry;
        sMobileNoSmry = (sMobileNoSmry.length == 0) ? "&nbsp;" : sMobileNoSmry;

        document.getElementById("Div_FaxSendSmry2_SMSMsg").innerHTML = sSMSMsg;
        document.getElementById("Div_FaxSendSmry2_ComName").innerHTML = sComNameSmry;
        document.getElementById("Div_FaxSendSmry2_UserName").innerHTML = sUserNameSmry;
        document.getElementById("Div_FaxSendSmry2_FaxNo").innerHTML = sFaxNoSmry;
        document.getElementById("Div_FaxSendSmry2_MobileNo").innerHTML = sMobileNoSmry;
        document.getElementById("Div_FaxSendSmry2_MobileCount").innerHTML = (sMobileNoSmryCount > 0) ? sMobileNoSmryCount.toString() + "건" : "";
        document.getElementById("Div_FaxSendSmry2_FaxPageCount").innerHTML = FilePageCount.toString() + "장";

        if (IsInterFaxUse == false) {
            FaxSendTotalPrice = (FaxPrice * FilePageCount * RecvNoCount) + (sMobileNoSmryCount * SMSPrice);
            if (sTop.cBox_CoverUse.checked) {
                document.getElementById("Div_FaxSendSmry2_FaxSendPrice").innerHTML = (FaxPrice * (FilePageCount - 1)).toString() + "포인트";
                document.getElementById("Div_FaxSendSmry2_FaxCoverPrice").innerHTML = "40포인트";
            }
            else {
                document.getElementById("Div_FaxSendSmry2_FaxSendPrice").innerHTML = (FaxPrice * FilePageCount).toString() + "포인트";
                document.getElementById("Div_FaxSendSmry2_FaxCoverPrice").innerHTML = "&nbsp;";
            }

            document.getElementById("Div_FaxSendSmry2_SMSPrice").innerHTML = (sMobileNoSmryCount * SMSPrice).toString() + "포인트";
        } else {
            var qFaxPrice = 0;
            for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
                var recvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML
                if (recvFaxNo.indexOf("+") >= 0) {
                    recvFaxNo = Replace(recvFaxNo, "+", "");
                    var AryrecvFaxNo = recvFaxNo.split(',');
                    qFaxPrice += GetNationalFaxPrice(AryrecvFaxNo[0]);
                } else {
                    qFaxPrice += FaxPrice;
                }
            }

            FaxSendTotalPrice = (qFaxPrice * FilePageCount) + (sMobileNoSmryCount * SMSPrice);
            if (sTop.cBox_CoverUse.checked) {
                document.getElementById("Div_FaxSendSmry2_FaxSendPrice").innerHTML = (qFaxPrice * (FilePageCount - 1)).toString() + "포인트";
                document.getElementById("Div_FaxSendSmry2_FaxCoverPrice").innerHTML = qFaxPrice.toString() + "포인트";
            }
            else {
                document.getElementById("Div_FaxSendSmry2_FaxSendPrice").innerHTML = (qFaxPrice * FilePageCount).toString() + "포인트";
                document.getElementById("Div_FaxSendSmry2_FaxCoverPrice").innerHTML = "&nbsp;";
            }

            document.getElementById("Div_FaxSendSmry2_SMSPrice").innerHTML = (sMobileNoSmryCount * SMSPrice).toString() + "포인트";
        }

        document.getElementById("Div_FaxSendSmry2_SendPrice").innerHTML = FaxSendTotalPrice.toString() + "포인트";

        sTop.tBox_CallbackNo.value = sTop.HidUserMobileNo.value;

        sTop.HidUseSMSAlarm.value = "1";

        document.getElementById("Div_RecvBox").className = "DivRecvInfoBoxArea RecvBoxOpacityStyle";
        document.getElementById("Div_HtmlBody").className = "FaxSendSummaryOpacityStyle";
        document.getElementById("Div_FaxSendSummary2").style.display = "";

        //수신처 정보
        var sm_recvInfo = "";
        var sm_recvUserName, sm_recvComName, sm_recvMobileNo, sm_recvFaxNo;
        for (var i = 0; i < document.getElementById("Div_RecvInfo").children.length; i++) {
            sm_recvUserName = document.getElementById("Div_RecvInfo").children[i].children[1].innerHTML;
            sm_recvComName = document.getElementById("Div_RecvInfo").children[i].children[2].innerHTML;
            sm_recvMobileNo = document.getElementById("Div_RecvInfo").children[i].children[3].innerHTML;
            sm_recvFaxNo = document.getElementById("Div_RecvInfo").children[i].children[4].innerHTML;

            if (sm_recvInfo.length > 0)
                sm_recvInfo += "‡" + sm_recvUserName + "¶" + sm_recvComName + "¶" + sm_recvMobileNo + "¶" + sm_recvFaxNo;
            else
                sm_recvInfo = sm_recvUserName + "¶" + sm_recvComName + "¶" + sm_recvMobileNo + "¶" + sm_recvFaxNo;
        }

        sTop.HidFaxSendRecvNoInfo.value = sm_recvInfo;

        //발송파일 정보
        var sm_fileInfo = "";
        var sm_filePathName, sm_fileName;
        var intLoop = 0;
        if (sTop.cBox_CoverUse.checked) intLoop = 1;
        for (var i = intLoop; i < document.getElementById("Div_FileInfo").children.length; i++) {
            sm_filePathName = document.getElementById("Div_FileInfo").children[i].children[0].innerHTML;
            sm_fileName = document.getElementById("Div_FileInfo").children[i].children[3].innerHTML;

            if (sm_fileInfo.length > 0)
                sm_fileInfo += "‡" + sm_filePathName + "¶" + sm_fileName;
            else
                sm_fileInfo = sm_filePathName + "¶" + sm_fileName;
        }

        sTop.HidFaxSendFileInfo.value = sm_fileInfo;

        return false;
    }
    catch (e) {
        return false;
    }
}

function FaxSendSubmit2() {
    if (sTop.tBox_CallbackNo.value == "") {
        alert("회신번호가 없습니다.\n\n회신번호가 없으면 팩스송신 알림 문자메시지를 보낼 수 없습니다.");
        return false;
    }
    if (!IsFaxNo(sTop.tBox_CallbackNo.value)) {
        alert("회신번호가 잘못 되었습니다.");
        return false;
    }

    document.form1.setAttribute("target", "");
    document.form1.setAttribute("action", "FaxSend.aspx");
    document.form1.setAttribute("method", "post");
    document.form1.setAttribute("enctype", "");

    return true;
}

function FaxSendSummaryCancel2() {

    sTop.HidUseSMSAlarm.value = "";

    document.getElementById("Div_FaxSendSmry_ComName").innerHTML = "";
    document.getElementById("Div_FaxSendSmry_UserName").innerHTML = "";
    document.getElementById("Div_FaxSendSmry_FaxNo").innerHTML = "";
    document.getElementById("Div_FaxSendSmry_FaxPageCount").innerHTML = "";
    document.getElementById("Div_FaxSendSmry_SendPrice").innerHTML = "";

    document.getElementById("Div_HtmlBody").className = "";
    document.getElementById("Div_RecvBox").className = "DivRecvInfoBoxArea";
    document.getElementById("Div_FaxSendSummary2").style.display = "none";
    return false;
}

function FaxSendReset() {
    var conf = confirm("팩스보내기 화면을 초기화 하시겠습니까?");
    if (conf) {
        location.href = "FaxSend.aspx";
        return false;
    } else {
        return false;
    }
}

function FaxSaveBoxView() {
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var sUrl, winguide;

    iWidth = 590;
    iHeight = 700;

    thisX = screen.availWidth;
    thisY = screen.availHeight;

    xx = (thisX - iWidth) / 2;
    yy = (thisY - iHeight) / 2;

    sUrl = "FaxSaveBox.aspx";
    winfaxsavebox = window.open(sUrl, "FaxSaveBox", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    winfaxsavebox.focus();

    return false;
}

function FaxSendBoxView() {
    var iWidth, iHeight, thisX, thisY, xx, yy;
    var sUrl, winguide;

    iWidth = 590;
    iHeight = 700;

    thisX = screen.availWidth;
    thisY = screen.availHeight;

    xx = (thisX - iWidth) / 2;
    yy = (thisY - iHeight) / 2;

    sUrl = "FaxSendBox.aspx";
    winfaxsendbox = window.open(sUrl, "FaxSendBox", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    winfaxsendbox.focus();

    return false;
}

function FaxSaveBoxAllCheck() {
    var chkvalue;

    if (sTop.cBox_tblKey.checked) {
        chkvalue = true;
    } else {
        chkvalue = false;
    }

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            sTop.item(i).checked = chkvalue;
        }
    }
}

function FaxSaveBoxListClick(RowID) {
    if (sTop.HidSelectRow.value == "") {
        eval("sTop." + RowID + ".style.backgroundColor = '#dae1ea'");
    }
    else {
        eval("sTop." + sTop.HidSelectRow.value + ".style.backgroundColor = '#ffffff'");
        eval("sTop." + RowID + ".style.backgroundColor = '#dae1ea'");
    }

    sTop.HidSelectRow.value = RowID;
}

function AddFaxSaveBox() {
    var strHTML, UniqKey, DivName, OrgFileName, OrgFileNameLn;
    var strInnerHTML, intPages;
    var SelectCount = 0;
    var flag = "send";

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if (sTop.item(i).checked) {
                SelectCount += 1;
                var content = Replace(sTop.item(i).id, "cBox_", "");
                if (content.length > 0) {
                    var AryContent = content.split('|');
                    var TifFileName = AryContent[0];
                    var DocuName = unescape(AryContent[1]);
                    var PageNo = AryContent[2];
                    var FileSize = AryContent[3];

                    strHTML = opener.document.getElementById("Div_FileInfo").innerHTML;
                    UniqKey = parseInt(opener.document.getElementById("Div_FileInfo").children.length) + 1;
                    DivName = "Div_FileInfoItem" + UniqKey.toString();
                    UniqKey = "FileInfoItem" + UniqKey.toString();

                    OrgFileNameLn = GetCharByte(DocuName);
                    if (OrgFileNameLn > 18) {
                        OrgFileName = DocuName.substring(0, 16) + "...";
                    }
                    else {
                        OrgFileName = DocuName;
                    }

                    strInnerHTML = '<div id="' + DivName + '" uniqkey="' + UniqKey.toString() + '" class="RecvBoxBottomtBorder HandCursor">';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_TableKey">' + TifFileName + '</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_CheckBox"></span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_OrgFileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')" title="' + DocuName + '">' + OrgFileName + '</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_FileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">보관함문서</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_Pages" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + PageNo + '</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_FileSize" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + FileSize + 'KB</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_PreviewBtn"><img src="../Images/btn_add_preview.gif" align="absmiddle" OnClick="FileInfoItemPreview(\'' + flag + '\', \'' + UniqKey.toString() + '\', \'' + TifFileName + '\', \'' + TifFileName + '\', true)" border="0"></span>';
                 //   strInnerHTML = strInnerHTML + '<span class="css_fu_SaveBoxBtn"></span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_RemoveBtn"><img src="../Images/sms_btn_del.gif" OnClick="FileInfoItemRemove(\'' + UniqKey.toString() + '\')" border="0"></span>';
                    strInnerHTML = strInnerHTML + '</div>';

                    opener.document.getElementById("Div_FileInfo").innerHTML = strHTML + strInnerHTML;

                    opener.document.getElementById("Div_AddFileMessage").style.display = "none";
                    opener.document.getElementById("ied").innerHTML = opener.document.getElementById("ied").innerHTML;

                    var intPages = parseInt(opener.document.getElementById("FilePageCountText").innerHTML);
                    intPages = intPages + parseInt(PageNo);

                    opener.document.getElementById("FilePageCountText").innerHTML = intPages.toString();
                }
            }
        }
    }

    if (SelectCount == 0) {
        alert("첨부할 문서를 선택해 주세요.\n첨부할 문서의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    self.window.close();
    return false;
}

function FaxSendBoxAllCheck() {
    var chkvalue;

    if (sTop.cBox_tblKey.checked) {
        chkvalue = true;
    } else {
        chkvalue = false;
    }

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            sTop.item(i).checked = chkvalue;
        }
    }
}

function FaxSendBoxListClick(RowID) {
    if (sTop.HidSelectRow.value == "") {
        eval("sTop." + RowID + ".style.backgroundColor = '#dae1ea'");
    }
    else {
        eval("sTop." + sTop.HidSelectRow.value + ".style.backgroundColor = '#ffffff'");
        eval("sTop." + RowID + ".style.backgroundColor = '#dae1ea'");
    }

    sTop.HidSelectRow.value = RowID;
}

function AddFaxSendBox() {
    var strHTML, UniqKey, DivName, OrgFileName, OrgFileNameLn;
    var strInnerHTML, intPages;
    var SelectCount = 0;
    var flag = "send";

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if (sTop.item(i).checked) {
                SelectCount += 1;
                var content = Replace(sTop.item(i).id, "cBox_", "");
                if (content.length > 0) {
                    var AryContent = content.split('|');
                    var TifFileName = AryContent[0];
                    var DocuName = unescape(AryContent[1]);
                    var PageNo = AryContent[2];
                    var FileSize = AryContent[3];
                    var ServiceType = AryContent[4];

                    strHTML = opener.document.getElementById("Div_FileInfo").innerHTML;
                    UniqKey = parseInt(opener.document.getElementById("Div_FileInfo").children.length) + 1;
                    DivName = "Div_FileInfoItem" + UniqKey.toString();
                    UniqKey = "FileInfoItem" + UniqKey.toString();

                    OrgFileName = "";
                    OrgFileNameLn = GetCharByte(DocuName);
                    if (OrgFileNameLn > 18) {
                        OrgFileName = DocuName.substring(0, 16) + "...";
                    }
                    else {
                        OrgFileName = DocuName;
                    }

                    strInnerHTML = '<div id="' + DivName + '" uniqkey="' + UniqKey.toString() + '" class="RecvBoxBottomtBorder HandCursor">';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_TableKey">' + TifFileName + '</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_CheckBox"></span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_OrgFileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')" title="' + DocuName + '">' + OrgFileName + '</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_FileName" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">보낸문서</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_Pages" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + PageNo + '</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_FileSize" OnClick="FileInfoItemClick(\'' + UniqKey.toString() + '\')">' + FileSize + 'KB</span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_PreviewBtn"><img src="../Images/btn_add_preview.gif" align="absmiddle" OnClick="FileInfoItemPreview(\'' + flag + '\', \'' + UniqKey.toString() + '\', \'' + TifFileName + '\', \'' + TifFileName + '\', \'' + ServiceType + '\', true)" border="0"></span>';
                    //  strInnerHTML = strInnerHTML + '<span class="css_fu_PreviewBtn"><img src="../Images/btn_add_preview.gif" align="absmiddle" OnClick="FileInfoItemPreview(\'' + flag + '\', \'' + UniqKey.toString() + '\', \'' + TifFileName + '\', \'' + TifFileName + '\', true)" border="0"></span>';
                    //strInnerHTML = strInnerHTML + '<span class="css_fu_SaveBoxBtn"></span>';
                    strInnerHTML = strInnerHTML + '<span class="css_fu_RemoveBtn"><img src="../Images/sms_btn_del.gif" OnClick="FileInfoItemRemove(\'' + UniqKey.toString() + '\')" border="0"></span>';
                    strInnerHTML = strInnerHTML + '</div>';

                    opener.document.getElementById("Div_FileInfo").innerHTML = strHTML + strInnerHTML;

                    opener.document.getElementById("Div_AddFileMessage").style.display = "none";
                    opener.document.getElementById("ied").innerHTML = opener.document.getElementById("ied").innerHTML;

                    var intPages = parseInt(opener.document.getElementById("FilePageCountText").innerHTML);
                    intPages = intPages + parseInt(PageNo);

                    opener.document.getElementById("FilePageCountText").innerHTML = intPages.toString();
                }
            }
        }
    }

    if (SelectCount == 0) {
        alert("첨부할 문서를 선택해 주세요.\n첨부할 문서의 맨 앞 체크박스에 체크를 해주세요.");
        return false;
    }

    self.window.close();
    return false;
}

function AddrOpen() {
    iWidth = 696;
    iHeight = 800;

    thisX = screen.availWidth;
    thisY = screen.availHeight;

    xx = (thisX - iWidth) / 2;
    yy = (thisY - iHeight) / 2;

    sUrl = "Addr.aspx?AddrType=FAX";
    winaddr = window.open(sUrl, "Addr", "left=" + xx + ",top=" + yy + ",width=" + iWidth + ",height=" + iHeight + ", scrollbars=no,menubar=no,resizable=no");
    winaddr.focus();

    return false;
}

function AddRecvInfo(UserName, ComName, MobileNo, FaxNo) {
    var strHTML, UniqKey, DivName, strInnerHTML;

    strHTML = document.getElementById("Div_RecvInfo").innerHTML;

    UniqKey = parseInt(document.getElementById("Div_RecvInfo").children.length) + 1;
    DivName = "Div_RecvInfoItem" + UniqKey.toString();
    UniqKey = "RecvInfoItem" + UniqKey.toString();

    strInnerHTML = '<div id="' + DivName + '" uniqkey="' + UniqKey.toString() + '" class="RecvBoxBottomtBorder HandCursor">';
    strInnerHTML = strInnerHTML + '<span class="css_CheckBox"><input type="checkbox" name="cBox' + UniqKey.toString() + '"></span>';
    strInnerHTML = strInnerHTML + '<span class="css_UserName" OnClick="RecvInfoItemClick(\'' + UniqKey.toString() + '\')">' + UserName + '</span>';
    strInnerHTML = strInnerHTML + '<span class="css_ComName" OnClick="RecvInfoItemClick(\'' + UniqKey.toString() + '\')">' + ComName + '</span>';
    strInnerHTML = strInnerHTML + '<span class="css_MobileNo" OnClick="RecvInfoItemClick(\'' + UniqKey.toString() + '\')">' + MobileNo + '</span>';
    strInnerHTML = strInnerHTML + '<span class="css_FaxNo" OnClick="RecvInfoItemClick(\'' + UniqKey.toString() + '\')">' + FaxNo + '</span>';
    strInnerHTML = strInnerHTML + '<span class="css_RemoveBtn"><img src="../Images/sms_btn_del.gif" OnClick="RecvInfoItemRemove(\'' + UniqKey.toString() + '\')" border="0"></span>';
    strInnerHTML = strInnerHTML + '</div>';

    document.getElementById("Div_RecvInfo").innerHTML = strInnerHTML + strHTML;

    RecvInfoCount();
}

function AddrSelect(arr) {
    var k = 0, i;
    var iCnt = arr.length / 4;
    while (k < iCnt) {
        i = k * 2;
        var v_UserName = arr[(i * 2) + 0].value;
        var v_FaxNo = arr[(i * 2) + 1].value;
        var v_MobileNo = arr[(i * 2) + 2].value;
        var v_ComName = arr[(i * 2) + 3].value;

        AddRecvInfo(v_UserName, v_ComName, v_MobileNo, v_FaxNo);
        k++;
    }
}

function GoFaxSend() {

    location.href = "FaxSend.aspx";
}

function GoFaxSendResult() {

    location.href = "FaxSendResult.aspx?SendPayMethod=" + sTop.HidSendPayMethod.value;
}

function GoFaxRecvResult() {

    location.href = "FaxRecvResult.aspx?SendPayMethod=" + sTop.HidSendPayMethod.value;
}

function FaxSendBoxPreview(TifFileName, ServiceType) {
    document.FilePreviewFrame.location.href = "FaxFilePreview.aspx?PathName=&FileName=" + TifFileName + "&ServiceType=" + ServiceType + "&IsFaxSaveBox=true";
}

function RemoveFaxSendBox() {
    var SendBoxKeys = "";

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if (sTop.item(i).checked) {
                if (sTop.item(i).name != "cBox_tblKey") {
                    if (SendBoxKeys.length > 0) {
                        SendBoxKeys += ";" + Replace(sTop.item(i).id, "cBox_", "");
                    }
                    else {
                        SendBoxKeys = Replace(sTop.item(i).id, "cBox_", "");
                    }
                }
            }
        }
    }

    if (SendBoxKeys.length > 0) {
        var conf = confirm("선택한 팩스를 삭제 하시겠습니까?");
        if (conf) {
            sTop.HidRemoveData.value = SendBoxKeys;
            document.form1.method = "post";
            document.form1.target = "SendFaxRemoveFrame";
            document.form1.action = "FaxSendBoxRemove.aspx";
            document.form1.submit();
        }
    }
    else {
        alert("삭제할 팩스를 선택해 주세요.");
    }

    return false;
}

function RemoveFaxSaveBox() {
    var SendBoxKeys = "";

    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if (sTop.item(i).checked) {
                if (sTop.item(i).name != "cBox_tblKey") {
                    if (SendBoxKeys.length > 0) {
                        SendBoxKeys += ";" + Replace(sTop.item(i).id, "cBox_", "");
                    }
                    else {
                        SendBoxKeys = Replace(sTop.item(i).id, "cBox_", "");
                    }
                }
            }
        }
    }

    if (SendBoxKeys.length > 0) {
        var conf = confirm("선택한 팩스를 삭제 하시겠습니까?");
        if (conf) {
            sTop.HidRemoveData.value = SendBoxKeys;
            document.form1.method = "post";
            document.form1.target = "SaveFaxRemoveFrame";
            document.form1.action = "FaxSendBoxRemove.aspx";
            document.form1.submit();
        }
    }
    else {
        alert("삭제할 팩스를 선택해 주세요.");
    }

    return false;
}

