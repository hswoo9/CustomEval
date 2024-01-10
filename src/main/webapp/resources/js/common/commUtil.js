/**
 * 공통코드 리스트
 * 
 * function	:	getCommCodeList(group_code);
 * group_code :	그룹코드
 * return commCodeList : 콩통코드 리스트		
 */
function getCommCodeList(group_code){
	var commCodeList = new Array();
	var data = {};
	data.group_code = group_code;
	$.ajax({
		type : 'POST',
		async: false,
		url : _g_contextPath_  + '/commcode/getCommCodeList',
		data:data,
		dataType : 'json',
		success : function(data) {
			commCodeList = data;
		}
	});
	return commCodeList;
}

/**
 * 콤보박스 init
 * 
 * function	:	comboBoxInit(option);
 * option :	id			태그아이디
 * 			list		리스트
 * 			text		텍스트
 * 			value		값
 * return comboBoxInit : 콩통코드 리스트		
 */
function comboBoxInit(option){
	var id = option.id;
	var list = option.list;
	var text = option.text;
	var value = option.value;
	
	if(!text){
		text = "text";
	}
	if(!value){
		value = "value";
	}
	var itemType = $("#" + id).kendoComboBox({
		dataSource : list,
		dataTextField: text,
		dataValueField: value,
		index: 0
    });
	$('.' + id).attr('readonly', true);
}

/**
 * 드롭다운 리스트 init
 * 
 * function	:	dropDownListInit(option);
 * option :	id			태그아이디
 * 			list		리스트
 * 			text		텍스트
 * 			value		값
 * return commCodeList : 콩통코드 리스트		
 */
function dropDownListInit(option){
	var id = option.id;
	var list = option.list;
	var text = option.text;
	var value = option.value;
	
	if(!text){
		text = "text";
	}
	if(!value){
		value = "value";
	}
	var itemType = $("#" + id).kendoDropDownList({
		dataSource : list,
		dataTextField: text,
		dataValueField: value,
		index: 0
    });
	$('.' + id).attr('readonly', true);
}

/**
 * 데이트픽커 init
 * 
 * function	:	datePickerInit(option);
 * option : id			태그아이디(1개)
 *			frDt		시작일 태그아이디(범위)
 * 			toDt		종료일 태그아이디(범위)
 * 			format		날짜포멧 (ex: 년 : y | 년월 : m | 년월일 : d)
 * return
 */
function datePickerInit(option){
	var toDay = new Date();
	var year = toDay.getFullYear();
	var month = toDay.getMonth() + 1;
	var date = toDay.getDate();
	var datePickerOpt = {};
	datePickerOpt.culture = "ko-KR";
	if(option.format == "y"){
		datePickerOpt.format = "yyyy";
		datePickerOpt.depth = "decade";
		datePickerOpt.start = "decade";
	}else if(option.format == "m"){
		datePickerOpt.format = "yyyy-MM";
		datePickerOpt.depth = "year";
		datePickerOpt.start = "year";
	}else if(option.format == "d" || !option.format){
		datePickerOpt.format = "yyyy-MM-dd";
	}
	
	if(option.className){
		var className = option.className;
		$("." + className).kendoDatePicker(datePickerOpt).attr("readonly", true);
	}
	if(option.id){
		var id = option.id;
		if(!$("#" + id).val()){
			$("#" + id).val(year + '-' + month + '-' + date);
		}
		$("#" + id).kendoDatePicker(datePickerOpt).attr("readonly", true);
	}
	//시작날짜
	if(option.frDt){
		var frDt = option.frDt;
		if(!$("#" + frDt).val()){
			$("#" + frDt).val(year + '-' + '01-01');
		}
		if(option.toDt){
			datePickerOpt.change = function(){
				startChange(frDt, toDt);
			}
		}
		$("#" + frDt).kendoDatePicker(datePickerOpt).attr("readonly", true);
	}
	//종료날짜
	if(option.toDt){
		var toDt = option.toDt;
		if(!$("#" + toDt).val()){
			$("#" + toDt).val(year + '-' + '12-31');
		}
		if(option.frDt){
			datePickerOpt.change = function(){
				endChange(frDt, toDt);
			}
		}
		$("#" + toDt).kendoDatePicker(datePickerOpt).attr("readonly", true);
	}
	
//	startChange(option.frDt, option.toDt);
//	endChange(option.frDt, option.toDt);
}

function startChange(frDt, toDt) {
	var start = $("#" + frDt).data("kendoDatePicker");
	var end = $("#" + toDt).data("kendoDatePicker");
	var startDate = start.value(),
	endDate = end.value();

	if (startDate) {
		startDate = new Date(startDate);
		startDate.setDate(startDate.getDate());
		end.min(startDate);
	} else if (endDate) {
		start.max(new Date(endDate));
	} else {
//		endDate = new Date();
//		start.max(endDate);
//		end.min(endDate);
	}
}
	
function endChange(frDt, toDt) {
	var start = $("#" + frDt).data("kendoDatePicker");
	var end = $("#" + toDt).data("kendoDatePicker");
	var endDate = end.value(),
	startDate = start.value();
	
	if (endDate) {
		endDate = new Date(endDate);
		endDate.setDate(endDate.getDate());
		start.max(endDate);
	} else if (startDate) {
		end.min(new Date(startDate));
	} else {
//		endDate = new Date();
//		start.max(endDate);
//		end.min(endDate);
	}
}

String.prototype.toMoney  = function(){
	
	var val = (this.valueOf());
	var zero = val.charAt(0);

	var money = val.replace(/\D/g,"");
	var index = money.length - 3;
	while(index >0){
		money = money.substr(0,index) + "," + money.substr(index);
		index -=3;
	}
	if(zero == "-"){
		return "-" + money;
	}else{
		return money; 
	}
};

String.prototype.toMoney2  = function(){
	
	var val = (this.valueOf());
	var zero = val.charAt(0);

	var money = val.replace(/\D/g,"");
	
	if(zero == "-"){
		return "-" + money;
	}else{
		return money; 
	}
};

String.prototype.toDate = function(){
	if(this.length == 8){
		var val = (this.valueOf() || "00000000");
		var date = val.substring(0,4) + "-" + val.substring(4,6) + "-" + val.substring(6,8);
		return date;
	}else if(this.length == 6){
		var val = (this.valueOf() || "000000");
		var date = val.substring(0,4) + "-" + val.substring(4,6);
		return date;
	}
}

String.prototype.toTime = function(){
	if(this.length == 6){
		var val = (this.valueOf() || "000000");
		var date = val.substring(0,2) + ":" + val.substring(2,4) + ":" + val.substring(4,6);
		return date;
	}
}

jQuery.fn.serializeObject = function() {
	var obj = null;
	try {
		var arr = this.serializeArray();
		if(arr){
			obj = {};
			jQuery.each(arr, function() {
				obj[this.name] = this.value;
			});
		}
	}catch(e) {
		alert(e.message);
	}finally {
		
	}
	return obj;
}

function numToKOR(num){
	var hanA = new Array("","일","이","삼","사","오","육","칠","팔","구","십");
	var danA = new Array("","십","백","천","","십","백","천","","십","백","천","","십","백","천");
	var result = "";
	for(i=0; i<num.length; i++) {
		str = ""; han = hanA[num.charAt(num.length-(i+1))];
		if(han != "") str += han+danA[i];
		if(i == 4) str += "만";
		if(i == 8) str += "억";
		if(i == 12) str += "조";
		result = str + result;
	} 
	if(num != 0) 
		result = result + "";
	return result ;
}

/**
 * 브라우저 종류
 * 
 * function	:	checkBroswer();
 * return browser : 브라우저 종류	
 */
function checkBroswer(){

    var agent = navigator.userAgent.toLowerCase(),
        name = navigator.appName,
        browser = '';
 
    // MS 계열 브라우저를 구분
    if(name === 'Microsoft Internet Explorer' || agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1) {
        browser = 'ie';
        if(name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
            agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
            browser += parseInt(agent[1]);
        } else { // IE 11+
            if(agent.indexOf('trident') > -1) { // IE 11
                browser += 11;
            } else if(agent.indexOf('edge/') > -1) { // Edge
                browser = 'edge';
            }
        }
    } else if(agent.indexOf('safari') > -1) { // Chrome or Safari
        if(agent.indexOf('opr') > -1) { // Opera
            browser = 'opera';
        } else if(agent.indexOf('chrome') > -1) { // Chrome
            browser = 'chrome';
        } else { // Safari
            browser = 'safari';
        }
    } else if(agent.indexOf('firefox') > -1) { // Firefox
        browser = 'firefox';
    }

    return browser;
}