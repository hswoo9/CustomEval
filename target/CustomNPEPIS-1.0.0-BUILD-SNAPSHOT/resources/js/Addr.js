var sTop = document.all;

function CheckBoxClear() {
    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            sTop.item(i).checked = false;
        }
    }
}



function GetCharge(listID) {
    try {
        if (sTop.HidSelectDiv.value != "") {
            eval('document.getElementById("' + sTop.HidSelectDiv.value + '").style.display = "none"');
            eval('document.getElementById("spn_' + sTop.HidSelectDiv.value + '").innerHTML = "▼"');
            CheckBoxClear();
        }

        if (sTop.HidSelectDiv.value != listID) {
            eval('document.getElementById("' + listID + '").style.display = ""');
            eval('document.getElementById("spn_' + listID + '").innerHTML = "▲"');
            sTop.HidSelectDiv.value = listID;
        }
        else {
            eval('document.getElementById("' + listID + '").style.display = "none"');
            eval('document.getElementById("spn_' + listID + '").innerHTML = "▼"');
            CheckBoxClear();
            sTop.HidSelectDiv.value = "";
        }
    } catch (e) {
    }
}

function AddrClientAllCheck() {
    if (sTop.cBox_AddrAllCheck.checked) {
        for (var i = 0; i < sTop.length; i++) {
            if (sTop.item(i).getAttribute("type") == "checkbox") {
                if (sTop.item(i).name.substring(0, 11) == "cbox_client") {
                    if (!sTop.item(i).disabled) {
                        sTop.item(i).checked = true;
                    }
                }
            }
        }
    }
    else {
        for (var i = 0; i < sTop.length; i++) {
            if (sTop.item(i).getAttribute("type") == "checkbox") {
                if (sTop.item(i).name.substring(0, 11) == "cbox_client") {
                    if (!sTop.item(i).disabled) {
                        sTop.item(i).checked = false;
                    }
                }
            }
        }
    }
}

function AddrChargeAllCheck(BizNo) {
    var IsChecked = eval('sTop.cbox_charge_AllCheck_' + BizNo + '.checked');
    var cBoxName = "cbox_charge_" + BizNo;
    if (IsChecked) {
        for (var i = 0; i < sTop.length; i++) {
            if (sTop.item(i).getAttribute("type") == "checkbox") {
                if (sTop.item(i).name.substring(0, cBoxName.length) == cBoxName) {
                    if (!sTop.item(i).disabled) {
                        sTop.item(i).checked = true;
                    }
                }
            }
        }
    }
    else {
        for (var i = 0; i < sTop.length; i++) {
            if (sTop.item(i).getAttribute("type") == "checkbox") {
                if (sTop.item(i).name.substring(0, cBoxName.length) == cBoxName) {
                    if (!sTop.item(i).disabled) {
                        sTop.item(i).checked = false;
                    }
                }
            }
        }
    }
}

function chargePageClick(SelectBizNo, ComName, LoopCount, PageNo) {
    var ActionFile, DatatoSend, ReturnValue;

    if (parseInt(PageNo) < 0) {
        alert("이전 페이지가 없습니다.");
        return false;
    }
    
    ActionFile = "AddrChargeList.aspx";
    DatatoSend = "AddrType=" + sTop.HidAddrType.value + "&PageNo=" + PageNo + "&BizNo=" + SelectBizNo + "&SelComName=" + ComName + "&LoopCount=" + LoopCount;
    ReturnValue = GetXmlHTTP(ActionFile, DatatoSend);
    if (typeof ReturnValue != "undefined") {
        if (ReturnValue != "NoPage") {
            var obj = eval('document.getElementById("div_charge_' + LoopCount + '")');
            obj.innerHTML = ReturnValue;
        } else {
            alert("페이지가 존재하지 않습니다.");
            return false;
        }
    }
}

function AddrSearchKeydown() {
    if (event.keyCode == 13) {
        AddrSearchClick();
    }
}

function AddrSearchClick() {
    if (sTop.tBox_SearchValue.value == "") {
        alert("검색단어를 입력해 주세요.");
        sTop.tBox_SearchValue.focus();
        return false;
    }
    else {
        location.href = "Addr.aspx?AddrType=" + sTop.HidAddrType.value + "&SearchType=" + sTop.ddl_AddrSearchType.value + "&SearchValue=" + sTop.tBox_SearchValue.value;
        return false;
    }
}

function AddAddr(key, value) {
    var obj = new Object();
    obj.key = key;
    obj.value = value;
    return obj;
}

function SelectAddrReturn() {
    var arr = new Array();
    var v_UserName, v_FaxNo, v_MobileNo, v_ComName
    
    for (var i = 0; i < sTop.length; i++) {
        if (sTop.item(i).getAttribute("type") == "checkbox") {
            if ((sTop.item(i).name != "cBox_AddrAllCheck") && (sTop.item(i).name.substring(0, 20) != "cbox_charge_AllCheck")) {
                if (sTop.item(i).checked) {
                    if(sTop.item(i).name.substring(0, 12) == "cbox_client_")
                    {
                        var ComName = sTop.item(i+3).innerHTML;
                        var UserName = sTop.item(i+4).innerHTML;
                        var FaxNo = sTop.item(i+6).innerHTML;
                        var MobileNo = "";
                        
                        v_UserName = AddAddr("UserName", UserName);
                        v_FaxNo = AddAddr("FaxNo", FaxNo);
                        v_MobileNo = AddAddr("MobileNo", MobileNo);
                        v_ComName = AddAddr("ComName", ComName);

                        if (FaxNo.length >= 9) {
                            arr.push(v_UserName);
                            arr.push(v_FaxNo);
                            arr.push(v_MobileNo);
                            arr.push(v_ComName);
                        }
                        else {
                            if (Replace(FaxNo, "&nbsp;", "").length == 0) {
                                alert("팩스번호가 없거나 잘못된 번호 입니다.");
                            }
                            else {
                                alert("[" + FaxNo + "] 는 잘못된 팩스번호 입니다.");
                            }
                        }
                    }
                    else
                    {
                        var selDiv = Replace(sTop.item(i).name, "cbox_charge_", "div_chargelist_");

                        var UserName = eval('document.getElementById("' + selDiv + '").children[0].children[0].children[0].children[2].innerHTML');
                        UserName = Replace(UserName, "&nbsp;", "");
                        
                        var FaxNo = eval('document.getElementById("' + selDiv + '").children[0].children[0].children[0].children[3].innerHTML');
                        FaxNo = Replace(FaxNo, "&nbsp;", "");
                        
                        var MobileNo = eval('document.getElementById("' + selDiv + '").children[0].children[0].children[0].children[4].innerHTML');
                        MobileNo = Replace(MobileNo, "&nbsp;", "");

                        var ComName = eval('document.getElementById("' + selDiv + '").children[0].children[0].children[0].children[5].innerHTML');
                        ComName = Replace(ComName, "&nbsp;", "");

                        v_UserName = AddAddr("UserName", UserName);
                        v_FaxNo = AddAddr("FaxNo", FaxNo);
                        v_MobileNo = AddAddr("MobileNo", MobileNo);
                        v_ComName = AddAddr("ComName", ComName);

                        arr.push(v_UserName);
                        arr.push(v_FaxNo);
                        arr.push(v_MobileNo);
                        arr.push(v_ComName);
                    }
                }
            }
        }
    }

    if ((arr.length / 4) == 0) {
        alert("주소록이 선택되지 않았습니다.");
        return false;
    }

    opener.AddrSelect(arr);
    
    self.window.close();
}

function AddrClose() {
    self.window.close();
}

function AddrAllSearch() {
    location.href = "Addr.aspx?AddrType=" + sTop.HidAddrType.value;
    return false;
}

function AddrHelpMsgOpen() {
    var DivAddrHelpMsg = document.getElementById("Div_AddrHelpMsg");

    if (DivAddrHelpMsg.style.visibility == "hidden") {
        var tBoxPos = getBounds(document.getElementById("img_AddrHelpSummary"));

        DivAddrHelpMsg.style.top = (tBoxPos.top - 150) + "px";
        DivAddrHelpMsg.style.left = (tBoxPos.left - 2) + "px";
        DivAddrHelpMsg.style.zIndex = "1";

        DivAddrHelpMsg.style.visibility = "";
    } else {
        DivAddrHelpMsg.style.visibility = "hidden";
    }
}