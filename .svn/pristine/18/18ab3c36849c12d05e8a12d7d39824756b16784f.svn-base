<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy.  MM.  dd." />

<script type="text/javascript">
var timeIn;
var evalData;
var colList;

$(function(){
	
	$('#loadingPop').kendoWindow({
	     width: "443px",
	     visible: false,
	     modal: true,
	     actions: [],
	     close: false,
	     title: false,
	 }).data("kendoWindow").center();
	
	getEvalConfirmChk();
	
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
        		clearInterval(timeIn);

        		colList = result.colList;
        		colGrid(result.colList);
        		
        		evalData = result.list;
        		listGrid(result.list);

        	}
        },

	});
	
}

function colGrid(v){
	
	$('#colTr').attr('colspan', v.length + 2);
	$('#addCol').empty();
	var scoreTotal = 0;
	$.each(v, function(i, v){
		scoreTotal += v.score;
		$('#addCol').append('<th style="height:50px; border: 1px; border-style: solid;">'+v.item_name+'<br>('+v.score+')</th>');
	});
	
	$('#addCol').append('<th style="height:50px; width:50px; border: 1px; border-style: solid;">합계<br>('+scoreTotal+')</th>');
	$('#addCol').append('<th style="height:50px; width:80px; border: 1px; border-style: solid;">환산점수<br>(<span id="probaTxt"></span><input type="text" id="proba" onchange="proBtn();" style="width: 30px;" value="90" maxlength="3">%)</th>');
	
}

function listGrid(v){
	
		$('#addTbody').empty();
		var pro = $('#proba').val() / 100;
		
		$.each(v, function(i, v){
			var rowTotal = 0;
			var trTemp = '<tr>'
						+'<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+(i+1)+'</td>'
						+'<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+v.DISPLAY_TITLE+'</td>';
						
				$.each(colList, function(ii, vv){
					
					var itemSeq = "ITME_SCORE_"+vv.item_seq;
					rowTotal += v[itemSeq];
	
					trTemp += '<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+v[itemSeq]+'</td>';
					
				});	
				
				var spro = rowTotal * pro;
				var sspro = spro;
				
				if(String(spro).indexOf('.') > -1){
					sspro = spro.toFixed(5);
				}
				
				trTemp += '<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+rowTotal+'</td>'
						  +'<td style="height:50px; border: 1px; border-style: solid; text-align: center;">'+sspro+'</td>'
						  +'<td style="height:50px; border: 1px; border-style: solid; text-align: center;"></td>'
						  +'</tr>';
						  
			$('#addTbody').append(trTemp);
			
		});

}

function proBtn(){
	
	listGrid(evalData);
}


function signSaveBtn(){
	
	alert('제출완료~');
	var proba = $('#proba').val();
	
	$('#probaTxt').text($('#proba').val());
	$('#proba').remove();
	
	var data = {
		commissioner_seq : '${userInfo.COMMISSIONER_SEQ}',	
		committee_seq : '${userInfo.COMMITTEE_SEQ}',	
		html : $('#signBody').get(0).outerHTML,
		step : 4,
		proba : proba,
	}
	
	$.ajax({
		url: "<c:url value='/eval/setSignSetp' />",
		data : data,
		type : 'POST',
		success: function(result){
			if(result == 'FILE_NM'){
				location.reload();
			}
		}
   	});

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
	<input type="button" onclick="signSaveBtn();" value="제출하기">
	<input type="button" onclick="getEvalConfirmChk();" value="새로고침">
</div>

<div id="signBody" style="width: 210mm; height: 297mm; border: 1px; border-style: solid;">

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
					<th rowspan="2" style="height:50px; border: 1px; border-style: solid;">순위</th>
					<th rowspan="2" style="height:50px; border: 1px; border-style: solid;">제안업체</th>
					<th id="colTr" colspan="6" style="height:50px; border: 1px; border-style: solid;">평 가 점 수</th>
					<th rowspan="2" style="height:50px; border: 1px; border-style: solid;">적격판성</th>
				</tr>	
				<tr id="addCol">
					<th style="height:50px; border: 1px; border-style: solid;"><br></th>
					<th style="height:50px; border: 1px; border-style: solid;"><br></th>
					<th style="height:50px; border: 1px; border-style: solid;"><br></th>
					<th style="height:50px; border: 1px; border-style: solid;"><br></th>
					<th style="height:50px; border: 1px; border-style: solid;">합계<br>(30)</th>
					<th style="height:50px; border: 1px; border-style: solid;">환산점수<br>(<span id="probaTxt"></span><input type="text" id="proba" style="width: 30px;" value="90" maxlength="3">%)</th>
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
		<span class="bodyTxt" style="font-size: 15px;">평가위원장 : ${userInfo.NAME } (인)</span>
	</div>

</div>

