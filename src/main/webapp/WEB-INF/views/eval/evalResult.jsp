<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<style>
.sub_contents_wrap .com_ta th, td{text-align: center;}
.sub_contents_wrap .com_ta tfoot td {color: blue;}
.com_ta table th{padding-right: 0px;}
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
</style>


<div class="iframe_wrap" style="min-width:1100px">

	<div class="sub_title_wrap">
		<div class="title_div">
			<h4>평가결과 보기</h4>
		</div>
	</div>

	
	<div class="sub_contents_wrap" style="min-height:0px;">
		<div class="com_ta">
			<div class="top_box gray_box" id="newDate">
				<dl>
					<dt style="">
						제안업체
					</dt>
					<dd style="line-height: 25px">
						<select id="company" style="width: 150px;" onchange="companySelect();">
							<c:forEach items="${company }" var="list">
								<option value="${list.eval_company_seq }">${list.display_title }</option>
							</c:forEach>
						</select>					
					</dd>
					<dt style="">
						사업명
					</dt>
					<dd style="line-height: 25px">
						<input type="text" value="${userInfo.TITLE}" style="width: 350px;" readonly="readonly"> 
					</dd>
					
					<dt style="">
						평가일자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" value="${userInfo.EVAL_S_DATE2}" readonly="readonly"> 
					</dd>

				</dl>
				
			</div>
			
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<div class="left_div">
			<p class="tit_p fl mt20 mb0">업체 평가점수</p>
		</div>
		
		<div class="right_div">
			<div class="controll_btn p20">
				<button type="button" onclick="companySelect();">새로고침</button>
				<button type="button" onclick="sign3Popup();">수당서명</button>
				<button type="button" onclick="sign4Popup();">총괄표</button>
			</div>
		</div>
			
		<div class="com_ta">
			<table style="width: 100%;">
				<thead>
					<tr>
						<th rowspan="2" style="width: 10%;">평가위원</th>				
						<th id="colTr" colspan="3">평가점수</th>				
					</tr>
					<tr id="addCol">
						<th>1</th>				
						<th>2</th>				
						<th>3</th>				
					</tr>
				</thead>
				
				<tbody id="addTbody">
				</tbody>

				<tfoot>
					<tr id="addTfoot">
					</tr>
				</tfoot>	
			</table>
		</div>
	</div>
	
	<div class="sub_contents_wrap">
		<p class="tit_p fl mt10 mb10">총괄점수</p>
		
		<div class="com_ta">
		
			<table style="width: 100%;">
				<thead>
					<tr>
						<th rowspan="2" style="width: 5%;">순위</th>
						<th rowspan="2" style="width: 10%;">제안업체</th>
						<th id="colTr2" colspan="3">평가점수</th>
						<th rowspan="2" style="width: 5%;">합계</th>
						<th rowspan="2" style="width: 5%;">환산점수</th>
						<th rowspan="2" style="width: 5%;">적격판정</th>
					</tr>
					<tr id="addCol2">
						<th>1</th>
						<th>2</th>
						<th>3</th>
					</tr>
				</thead>
				
				<tbody id="addTbody2">
				</tbody>
			
			</table>
					
		
		</div>
	</div>

</div>

<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='/resources/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;평가 점수를 취합중입니다.</span>		
				</td>
			</tr>
		</table>
	</div>
	<!-- //pop_con -->
</div>

<form id="sign4ViewForm" target="sign4ViewForm" action="<c:url value='/eval/sign4ViewForm' />" method="post">
	<input type="hidden" id="evalId" name="evalId" value="${userInfo.EVAL_USER_ID}">
</form>

<form id="sign3ViewForm" target="sign3ViewForm" action="<c:url value='/eval/sign3ViewForm' />" method="post">
	<input type="hidden" id="evalId" name="evalId" value="${userInfo.EVAL_USER_ID}">
</form>

<script>
	window.onload = function () {
		window.scrollTo(0, 0);
	};

var rates = ${userInfo.RATES};
$(function(){
	
	$('#company').kendoDropDownList();
	
	$('#loadingPop').kendoWindow({
	     width: "443px",
	     visible: false,
	     modal: true,
	     actions: [],
	     close: false,
	     title: false,
	 }).data("kendoWindow").center();
	
	companySelect();
	
});

function companySelect(){
	
	var data = {
			COMMITTEE_SEQ : '${userInfo.COMMITTEE_SEQ}',
			EVAL_COMPANY_SEQ : $('#company').val(),
	};
	
	$.ajax({
		url: "<c:url value='/eval/evalResultList' />",
		data : data,
		type : 'POST',
		beforeSend: function () {
        	$('#loadingPop').data("kendoWindow").open();
        },
        complete: function () {
        	$('#loadingPop').data("kendoWindow").close();
        },
		success: function(result){

			$('#colTr').attr('colspan', result.colList.length);
			$('#colTr2').attr('colspan', result.colList.length);
			
			$('#addCol').empty();
			$('#addCol2').empty();
			
			$('#addTbody').empty();
			$('#addTfoot').empty();

			$('#addTbody2').empty();
			
			$('#addTfoot').append('<td>합계</td>');
			
			//th그리기
			var colWidth = 90 / result.colList.length;
			var col2Width = 80 / (result.colList.length + 2);
			
			$.each(result.colList, function(i, v){
				var tos = "ITME_SCORE_"+v.item_seq;
				
				$('#addCol').append('<th style="width: '+colWidth+'%;">'+v.item_name+'</th>');
				$('#addCol2').append('<th style="width: '+col2Width+'%;">'+v.item_name+'</th>');
				$('#addTfoot').append('<td>'+qksdhffla(result.total[tos]) +'</td>');
				
			});

			//td그리기
			$.each(result.list, function(i, v){
				
				var td = '<tr><td>'+v.NAME+'</td>';
						
					$.each(result.colList, function(ii, vv){
						var tem = "ITME_SCORE_"+vv.item_seq;
						var color = v["RANK_CODE_"+vv.item_seq] == 'N' ? 'red' : 'black';
						
						if(v.EVAL_SAVE == 'Y'){
							td += '<td style="color: '+color+';">'+v[tem]+'</td>';
						}else{
							td += '<td style="background-color:skyblue;"></td>';
						}
						
					});		
						
					td += '</tr>';	
						
				$('#addTbody').append(td);
				
			});
			
			$.each(result.sumList, function(i, v){
				
				var pro = rates / 100;
				
				var trTemp = '<tr>'
					+'<td>'+(i+1)+'</td>'
					+'<td>'+v.DISPLAY_TITLE+'</td>';
				
				$.each(result.colList, function(ii, vv){
					var itemSeq = "ITME_SCORE_"+vv.item_seq;
					trTemp += '<td>'+qksdhffla(v[itemSeq])+'</td>';
				});	
				
				var sspro = v.TOTAL_SUM * pro;
				
				trTemp += '<td>'+qksdhffla(v.TOTAL_SUM)+'</td>'
				  +'<td>'+qksdhffla(sspro)+'</td>'
				  +'<td></td>'
				  +'</tr>';
					
				$('#addTbody2').append(trTemp);
				
			});
		}
	});
	
}
function sign3Popup(){
	window.open("<c:url value='/eval/sign3ViewForm?evalId=${userInfo.EVAL_USER_ID}' />", "sign3ViewForm", 'location=no, toolbar=no, scrollbar=yes, width=855px, height=900px, resizable=no, status=no');
}

function sign4Popup(){
	window.open("<c:url value='/eval/sign4ViewForm?evalId=${userInfo.EVAL_USER_ID}' />", "sign4ViewForm", 'location=no, toolbar=no, scrollbar=yes, width=855px, height=900px, resizable=no, status=no');
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


</script>