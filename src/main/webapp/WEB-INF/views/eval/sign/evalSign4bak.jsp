<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy.  MM.  dd." />
<style>html, body {
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
}</style>
<script type="text/javascript">
$(function(){
	
	window.onbeforeunload = function (event) {
	    if (typeof event == 'undefined') {
	        event = window.event;
	    }
	    if (event) {
	    	OnDisconnectDevice();
	    }
	};
	
	$('#loadingPop').kendoWindow({
	     width: "443px",
	     visible: false,
	     modal: true,
	     actions: [],
	     close: false,
	     title: false,
	 }).data("kendoWindow").center();
	
	getEvalConfirmChk();
	
	//사인패드 시작
// 	OnConnectDevice();

// 	$('#loadingPop').data("kendoWindow").open();
// 	timeIn = setInterval(getEvalConfirmChk, 2000);
	
});

function getEvalConfirmChk(){
	
	$.ajax({
        url: "<c:url value='/eval/getEvalConfirmChk' />",
        data: {COMMITTEE_SEQ : '${userInfo.COMMITTEE_SEQ}'},
        type: 'POST',
        success: function(result){
			
        	if(result.chk == 'Y'){
        		$('#loadingPop').data("kendoWindow").close();
//         		clearInterval(timeIn);

        		colList = result.colList;
        		colGrid(result.colList);
        		
        		evalData = result.list;
        		listGrid(result.list);

        	}
        },

	});
	
}

function colGrid(v){
	
	$('#colTr').attr('colspan', v.length);
	$('#addCol').empty();
	var scoreTotal = 0;
	var colWidth = 55 / v.length;
	
	$.each(v, function(i, v){
		scoreTotal += v.score;
		$('#addCol').append('<th style="width:'+colWidth+'%; height:50px; border: 1px; border-style: solid;">'+v.item_name+'<br>('+v.score+')</th>');
	});
	
// 	$('#addCol').append('<th style="height:50px; width:50px; border: 1px; border-style: solid;">합계<br>('+scoreTotal+')</th>');
// 	$('#addCol').append('<th style="height:50px; width:80px; border: 1px; border-style: solid;">환산점수<br>(${userInfo.RATES}%)</th>');
	
}

function listGrid(v){
	
		$('#addTbody').empty();
		var pro = rates / 100;
		
		$.each(v, function(i, v){
			var rowTotal = 0;
			var userCnt = v.USER_CNT;
			
			var trTemp = '<tr>'
						+'<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+(i+1)+'</td>'
						+'<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+v.DISPLAY_TITLE+'</td>';
						
				$.each(colList, function(ii, vv){
					
					var itemSeq = "ITME_SCORE_"+vv.item_seq;
	
					trTemp += '<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+qksdhffla(v[itemSeq])+'</td>';
					
				});	
				
				var sspro = v.TOTAL_SUM * pro;
				
				trTemp += '<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+qksdhffla(v.TOTAL_SUM)+'</td>'
						  +'<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+qksdhffla(sspro)+'</td>'
						  +'<td style="height:50px; border: 1px; border-style: solid; text-align: center;"></td>'
						  +'</tr>';
						  
			$('#addTbody').append(trTemp);
			
		});

}

function proBtn(){
	
	listGrid(evalData);
}


function signSaveBtn(){

	var data = {
		commissioner_seq : '${userInfo.COMMISSIONER_SEQ}',	
		committee_seq : '${userInfo.COMMITTEE_SEQ}',	
		join_select_type : '${userInfo.JOIN_SELECT_TYPE}',	
		purc_req_id : '${userInfo.PURC_REQ_ID}',	
		html : $('#signBody').get(0).outerHTML,
		step : 4,
		proba : rates,
	}
	
	$.ajax({
		url: "<c:url value='/eval/setSignSetp' />",
		data : data,
		type : 'POST',
		success: function(result){
			if(result == 'FILE_NM'){
				window.close();
			}
		}
   	});

}

//소수점 5자리 반올림
function qksdhffla(v){
	var txt = 0;
	
	if(v % 1 == 0) { 
		txt = v;
	}else{
		txt = v.toFixed(5);
		for (var i = 0; i < 5; i++) {
			txt = txt.replace(/0$/g, '');
		}
	}
	
	return txt;
}

function setSign(imgData){
	$('#signSrc').attr('src', 'data:image/png;base64,' + imgData);
// 	signSaveBtn();
}

</script>

<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='/resources/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;제안평가 중입니다.</span>		
				</td>
			</tr>
		</table>
	</div>
	<!-- //pop_con -->
</div>

<div id="signSave">
	<input type="button" onclick="OnConnectDevice();" value="서명하기">
	<input type="button" onclick="signSaveBtn();" style="background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
	<input type="button" onclick="getEvalConfirmChk();" style="background-color: #dee4ea; border-color: black; border-width: thin;" value="새로고침">
</div>

<div id="signBody" style="width: 205mm; height: 292mm; border: 1px; border-style: solid;"> 

	<div style="height: 50px; text-align: center; padding-top: 40px;">
		<span style="font-size:30px; font-weight: bold; text-decoration: none; border-bottom : 1px double black ; padding-bottom : 2px; ">제안서 평가 총괄표</span>
	</div>
	
	<div class="bodyDiv" style="height: 50px; text-align: left; padding-top: 40px; padding-left: 50px; padding-right: 50px;">
		<span class="bodyTxt" style="font-size:15px;">■ 사 업 명 : ${userInfo.TITLE}</span>
	</div>
	
	<div class="bodyDiv" style="height: 50px; text-align: right; padding-left: 50px; padding-right: 50px;">
		<span class="bodyTxt" style="font-size:15px;">평가일자 : ${nowDate}</span>
	</div>
	
	
	<div class="bodyDiv" style="padding-left: 50px; padding-right: 50px;">

		<table style="width: 100%;">
			<thead>
				<tr>
					<th rowspan="2" style="width:5%; height:50px; border: 1px; border-style: solid;">순위</th>
					<th rowspan="2" style="width:10%; height:50px; border: 1px; border-style: solid;">제안<br>업체</th>
					<th id="colTr" colspan="6" style="height:50px; border: 1px; border-style: solid;">평 가 점 수</th>
					<th rowspan="2" style="width:10%; height:50px; border: 1px; border-style: solid;">합계<br>(100)</th>
					<th rowspan="2" style="width:10%; height:50px; border: 1px; border-style: solid;">환산점수<br>(${userInfo.RATES}%)</th>
					<th rowspan="2" style="width:10%; height:50px; border: 1px; border-style: solid;">적격판정</th>
				</tr>	
				<tr id="addCol">
					<th style="height:50px; border: 1px; border-style: solid;"><br></th>
					<th style="height:50px; border: 1px; border-style: solid;"><br></th>
					<th style="height:50px; border: 1px; border-style: solid;"><br></th>
					<th style="height:50px; border: 1px; border-style: solid;"><br></th>
				</tr>	
			</thead>
			<tbody id="addTbody">
			</tbody>
		</table>

	</div>
	
	
	
	<div class="bodyDiv" style="height: 50px; text-align: center; padding-top: 40px; padding-left: 50px; padding-right: 50px;">
		<span class="bodyTxt" style="font-size: 15px;">상기와 같이 평가결과를 통보합니다.</span>
	</div>

	<div class="bodyDiv" style="height: 50px; text-align: center; padding-top: 40px; padding-left: 400px; padding-right: 50px;">
		<div style="height: 50px; padding-right: 15px; float: left;">
	   		<span class="bodyTxt" style="font-size:15px;">평가위원장 : ${userInfo.NAME }</span>
	    </div>
	    <div style="height: 50px; margin-top: -15px;">
	    	<img alt="" style="width: 80px; height: 50px;" id="signSrc" src="">
	    </div>
	</div>

</div>

