function KeyDownNoAction() {
    if (event.keyCode == 13) {
        if (event.srcElement.tagName != "TEXTAREA")
            return false;
    }
}

function Replace(str, original, replacement) {
    var result;
    result = "";
    while (str.indexOf(original) != -1) {
        if (str.indexOf(original) > 0)
            result = result + str.substring(0, str.indexOf(original)) + replacement;
        else
            result = result + replacement;
        str = str.substring(str.indexOf(original) + original.length, str.length);
    }
    return result + str;
}

function IsMobileNo(s) {
    var isMobile = /^(010|011|016|017|018|019)\-?\d{3,4}\-?\d{4}$/;
    if (s.search(isMobile)) return false;
    return true;
}

function IsFaxNo(s) {
    var isFaxNo = /^[0-9-+]+$/;
    if (s.search(isFaxNo)) return false;
    return true;
}

function IsInterFaxNo(s) {
    var isFaxNo = /^[0-9-+-,]+$/;
    if (s.search(isFaxNo)) return false;
    return true;
}

function GetCharByte(strValue) {
    var str;
    var str_count = 0;
    var cut_count = 0;
    var smslen = 80;
    var lmslen = 2000;
    var IsPass = 0;
    var tmp_str = "";
    var str_length = strValue.length;

    for (k = 0; k < str_length; k++) {
        str = strValue.charAt(k);

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
    }

    return str_count;
}

//Ajax 공통함수
function GetXmlHTTP(ActionFile, DatatoSend) {
    var xmlhttp = new ActiveXObject("msxml2.XMLHTTP");
    xmlhttp.Open("POST", ActionFile, false);
    xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    xmlhttp.send(DatatoSend);
    return xmlhttp.responseText;
}

//숫자인지 확인
function IsNumber(s) {
    var isNum = /^[\d]+$/;
    if (s.search(isNum)) return false;
    return true;
}

//숫자,문자(영어소문자)인지 확인
function IsNumberEnglish(s) {
    var isID = /[^a-z0-9]/;
    if (isID.test(s)) return false;
    return true;
}

//숫자,문자(영어소문자 또는 대문자)인지 확인
function IsNumberEnglish2(s) {
    var isID = /[^a-zA-Z0-9]/;
    if (isID.test(s)) return false;
    return true;
}

//한글인지 확인
function IsHangul(s) {
    var len;
    len = s.length;
    for (var i = 0; i < len; i++) {
        if (s.charCodeAt(i) != 32 && (s.charCodeAt(i) < 44032 || s.charCodeAt(i) > 55203))
            return false;
    }
    return true;
}

//공백이 있는지 확인
function checkSpace(str) {
    if (str.search(/\s/) != -1) {
        return false;
    }
    else {
        return true;
    }
}

function strip_comma(data)
{
	var flag = 1;
	var valid = "1234567890";
	var output = '';
	if (data.charAt(0) == '-')
	{
		flag = 0;
		data = data.substring(1);
	}
	
	for (var i=0; i<data.length; i++)
	{
		if (valid.indexOf(data.charAt(i)) != -1)
			output += data.charAt(i)
	}
	
	if (flag == 1)
		return output;
	else if (flag == 0)
		return ('-' + output);
}

//3자리마다 컴마
function add_comma(what)
{
	var flag = 1;
	var data = what;
	var len = data.length;

	if (data.charAt(0) == '-')
	{
		flag = 0;
		data = data.substring(1);
	}
	if (data.charAt(0) == '0' && data.charAt(1) == '-')
	{
		flag = 0;
		data = data.substring(2);
	}

	var number = strip_comma(data);

	number = '' + number;
		
	if (number.length > 3)
	{
		var mod = number.length % 3;
		var output = (mod > 0 ? (number.substring(0,mod)) : '');
		for (i=0; i<Math.floor(number.length/3); i++)
		{
			if ((mod == 0) && (i == 0))
				output += number.substring(mod+3*i, mod+3*i+3);
			else
				output += ',' + number.substring(mod+3*i, mod+3*i+3);
		}
		if (flag == 0)
		{
			return ('-' + output);
		}
		else
		{
			return (output);
		}
	}
	else
	{
		if (flag == 0)
		{
			return ('-' + number);
		}
		else
		{
			return (number);
		}
	}
}

function getBounds(obj) {
    var ret = new Object();

    if (document.all) {
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


function payInfo() {
    var sTop = document.all;
    sTop.Div_PayInfo.style.display = "inline";
}

function PayInfoHide() {
    var sTop = document.all;
    sTop.Div_PayInfo.style.display = "none";
}



function CheckInputChar() {
    var char_ASCII = event.keyCode;

    //숫자
    if (char_ASCII >= 48 && char_ASCII <= 57)
        return 1;
    //영어
    else if ((char_ASCII >= 65 && char_ASCII <= 90) || (char_ASCII >= 97 && char_ASCII <= 122))
        return 2;
    //특수기호 (-)
    else if (char_ASCII == 45)
        return 5;
    //특수기호 (전체)
    else if (((char_ASCII >= 33 && char_ASCII <= 47)) || (char_ASCII >= 58 && char_ASCII <= 64) || (char_ASCII >= 91 && char_ASCII <= 96) || (char_ASCII >= 123 && char_ASCII <= 126) || (char_ASCII >= 123 && char_ASCII <= 126))
        return 4;
    //한글
    else if ((char_ASCII >= 12592) || (char_ASCII <= 12687))
        return 3;
    else
        return 0;
}

// 전화(팩스)번호 체크 (숫자와 (-)만 허용) 
function ValidateTextBoxNumber(obj) {

    if (CheckInputChar() != 1 && CheckInputChar() != 5) {
        event.returnValue = false;
        alert("숫자나 (-)기호만 입력해 주세요.");
        obj.focus();

        return;
    }
}

// 전화(팩스)번호 체크 (숫자만 허용) 
function ValidateTextBoxNumberByBulk(obj) {

    if (CheckInputChar() != 1) {
        event.returnValue = false;
        alert("숫자만 입력해 주세요.");
        obj.focus();

        return;
    }
}
