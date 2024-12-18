<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>

<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy-MM-dd" />

<style>
	.small-text {
		font-size: 14px;
	}
	input[type="radio"]:disabled {
		pointer-events: none;
		opacity: 1;
	}

	.radio-label {
		color: inherit;
		opacity: 1;
	}

	input[type="radio"]:disabled + .radio-label {
		color: inherit;
		opacity: 1;
	}
	.top_box dl dt{font-size: 18px; }
	.top_box dl dd{margin-top: 3px;}
	.top_box dl dd input{height: 45px; font-size: 15px;}
	.com_ta table th, td{text-align: center; font-size: 18px; }
	/*#listTable input {width: 100px; height: 45px; font-size: 20px;}*/
	#listTable #th1, #th2, #th3{width: 200px;}
	#listTable th{background-color: #28b4ea;}
	.controll_btn button{width: 70px; height: 40px; font-size: 20px;}
	.itemRadioTd{
		justify-content: space-around;
		font-size: 15px;
	}
	.score{
		margin-right: 5px;
	}


    @media (pointer:coarse) {
        /* custom css for "touch targets" */
        .sub_contents_wrap {width: 1100px !important; min-width: 1100px !important;}
        dt {margin-left : 25px !important;}
        .hkInput {width: 220px !important;}
        .hkBtnCont {width : 1100px !important;}
        .sub_contents_wrap {width: 1100px !important;}
        .hkFootCont {width: 1100px !important;}
        .comReMarkInput {width: 1050px !important;}
        .hkFootSubCont {width: 1100px !important; min-width: 1100px !important;}
    }
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

<div class="iframe_wrap" style="min-width:1400px">

	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">

		<div class="title_div">
			<h4>제안평가</h4>
		</div>
	</div>

	<div class="sub_contents_wrap" style="min-width:1500px; min-height: 0px;">
		<div class="com_ta">
			<div class="top_box gray_box">
				<dl>
					<dt style="">
						사업명
					</dt>
					<dd style="line-height: 25px">
						<input type="text" class="hkInput" style="width: 250px;" readonly="readonly" value="${userInfo.TITLE }">
					</dd>
					<dt style="margin-left:100px;">
						평가자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" class="hkInput" readonly="readonly" value="${userInfo.NAME }">
					</dd>
					<dt style="margin-left:100px;">
						평가일자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" class="hkInput" readonly="readonly" value="${nowDate }">
					</dd>
				</dl>
			</div>
		</div>



	</div><!-- //sub_contents_wrap -->



	<div class="right_div hkBtnCont" style="height:70px;">
		<div class="controll_btn p10">

			<button type="button" class="evalButton" onclick="evalAvoidPopup()" style="width: 120px; float:left; font-weight : bold; color: red !important; background-color: #dee4ea; border-color: black; border-width: thin;">기피신청</button>
			<%--<button type="button" class="evalButton" id="prevButton" style="display: none;" onclick="prevEvalBtn();">이전</button>
			<button type="button" class="evalButton" id="nextButton" onclick="nextEvalBtn();">다음</button>--%>
			<button type="button" class="evalButton" id="saveButton" style="width: 120px; float: right; margin-left:10px; background-color: #dee4ea; border-color: black; border-width: thin;" onclick="saveBtn();">다음</button>
			<%--<button type="button" class="evalButton" id="saveButton" style="display: none;" onclick="deviationChk();">저장</button>--%>
			<!-- 			<button type="button" class="evalButton" onclick="nextPageBtn();">다음</button> -->
		</div>
	</div>

	<%--<div id="displayTitle" style="margin-top:10px; margin-bottom:10px; height:30px;"></div>--%>


	<div id ="dataScore" class="sub_contents_wrap" style="min-width:1500px; min-height: 0px;">
		<%--<div class="com_ta">

			<table id="listTable" style="width: 100%;">
				<colgroup>
					<col width="10%"/>
				</colgroup>--%>

				<%--<tbody id="dataTbody"></tbody>--%>
			<%--</table>
		</div>--%>

	</div>

	<%--<div class="left_div" style="padding-top: 50px;">
		<p class="tit_p mt5 mb10" style="font-size: 20px;">평가의견</p>
	</div>
	<div class="sub_contents_wrap" style="min-width:1500px; min-height: 0px;">
		<div class="com_ta">
			<table style="width: 100%;">
				<c:forEach items="${companyRemarkList}" var="list" varStatus="st">
					<tr class="evalIndex${st.index}" style="${st.index > 0 ? 'display:none;' : ''} ">
						<th style="width: 15%;">${list.DISPLAY_TITLE }</th>
						<td style="text-align: left;">
							<input type="hidden" id="chkTxt${st.index}" name="chkTxt">
							<textarea class="comReMarkInput" id="${list.com_remark_seq }" style="font-size: 20px;" rows="4" cols="100" maxlength="400" placeholder="평가의견은 30자 이상 400자 이하로 입력해주세요.">${list.remark}</textarea>
							<span id="txtCnt">0</span>/400
						</td>
					</tr>
				</c:forEach>

			</table>
		</div>
	</div>--%>


</div><!-- iframe wrap -->

<%--<input type="hidden" id="compSeq" value=""/>--%>
<form id="payForm" action="<c:url value='/eval/evalPay' />" method="post">
	<%-- 	<input type="hidden" name="commissioner_seq" id="commissioner_seq" value="${userInfo.COMMISSIONER_SEQ}"> --%>
</form>

<script>
	window.onload = function () {
		window.scrollTo(0, 0);
	};

	window.onload = function() {
		history.pushState(null, null, window.location.href);
		history.pushState(null, null, window.location.href);

		window.addEventListener('popstate', function () {
			history.pushState(null, null, window.location.href);
		});
	};

	var evalCnt = 0;
	var evalEndCnt = ${companyList.size()};
	var evalSize = 1;

	$(function(){
		init();
		evalLst(evalCnt);

		$('.comReMarkInput').on('keydown', function(e){
			txtCnt();
		});

		if(evalEndCnt == evalSize){
			$('#saveButton').show();
		}

	});

	var totalLstLen = ${itemList.size()};

	var companyAr = new Array();
	var itemAr = new Array();


	//상단 버튼 고정
	window.addEventListener('scroll', function() {
		var rightDiv = document.querySelector('.right_div');
		var subTitleWrap = document.querySelector('.sub_title_wrap');
		var subContentsWrap = document.querySelector('.sub_contents_wrap');

		var offset = subTitleWrap.offsetHeight + subContentsWrap.offsetHeight;

		if (window.pageYOffset > offset) {
			rightDiv.style.position = 'fixed';
			rightDiv.style.top = '0';
			rightDiv.style.left = '0';
			rightDiv.style.right = '0';
			rightDiv.style.zIndex = '1000';
			rightDiv.style.backgroundColor = '#f8f8f8';
			rightDiv.style.boxShadow = '0 2px 5px rgba(0,0,0,0.2)';
		} else {
			rightDiv.style.position = 'static';
			rightDiv.style.boxShadow = 'none';
			rightDiv.style.backgroundColor = '#ffffff';
		}
	});

	$.fn.rowspan = function(colIdx, isStats) {       
		return this.each(function(){      
			var that;     
			$('tr', this).each(function(row) {      
				$('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
					
					if ($(this).html() == $(that).html()
						&& (!isStats 
								|| isStats && $(this).prev().html() == $(that).prev().html()
								)
						) {            
						rowspan = $(that).attr("rowspan") || 1;
						rowspan = Number(rowspan)+1;

						$(that).attr("rowspan",rowspan);
						
						// do your action for the colspan cell here            
						//$(this).hide();
						
						$(this).remove(); 
						// do your action for the old cell here
						
					} else {            
						that = this;         
					}          
					
					// set the that if not already set
					that = (that == null) ? this : that;      
				});     
			});    
		});  
	};
	
	$.fn.rowspan2 = function(colIdx, isStats) {       
		return this.each(function(){      
			var that;     
			$('tr', this).each(function(row) {      
				$('td:eq('+colIdx+')', this).filter(':visible').each(function(col) {
					
					if ($(this).html() == $(that).html()
						&& (!isStats 
								|| isStats && $(this).prev().html() == $(that).prev().html()
								)
						) {            
						rowspan = $(that).attr("rowspan") || 1;
						rowspan = Number(rowspan)+1;

						$(that).attr("rowspan",rowspan);
						
						// do your action for the colspan cell here            
						//$(this).hide();
						
						$(this).remove(); 
						// do your action for the old cell here
						
					} else {            
						that = this;         
					}          
					
					// set the that if not already set
					that = (that == null) ? this : that;      
				});     
			});    
		});  
	}; 

	// 평가 리스트
	function evalLst(evalCnt){

		var comtSeq = '${userInfo.COMMITTEE_SEQ}';
		var comsSeq = '${userInfo.COMMISSIONER_SEQ}';

		var data = {
			COMMITTEE_SEQ : comtSeq,
			COMMISSIONER_SEQ : comsSeq
		};

		$.ajax({
			url : "<c:url value='/eval/getEvalData' />",
			data : data,
			type : "post",
			dataType : "json",
			success : function(rs) {
				console.log("rs : " ,rs);
				var compResult = rs.companyList;
				var result = rs.itemList;
				var companyRemarkList = rs.companyRemarkList;
				var list = rs.list;
				console.log("company : ",compResult);
				console.log("companyRemarkList : ",companyRemarkList);
				console.log("list : ",list);

				//$("#compSeq").val(compResult[evalCnt].eval_company_seq);

				var html = "";
				var html2 = "";

				//$("#dataTbody").html(html);
				//$("#displayTitle").html(html2);

				console.log("result : ",result);

				for (var j = 0; j < compResult.length; j++) {
					//$("#compSeq").val(compResult[j].eval_company_seq);

					//if (result[j].EVAL_COMPANY_SEQ == compResult[j].eval_company_seq) {

						/*html2 += '<span style="font-size:25px; margin-bottom:10px;">'  + compResult[j].display_title + '</span>';

						$("#displayTitle").html(html2);*/
						html += '<div><span style="font-size:18px; margin-bottom:10px; padding-bottom: 15px">'  + compResult[j].display_title + '</span>';
						html += '<span id="successMessage'+compResult[j].eval_company_seq+'" style="font-size:25px; margin-left:10px; margin-bottom:10px; padding-bottom: 15px; display: none;"> 저장완료</span></div>';

						html += '<div class="com_ta">';
						html += '<table id="listTable" class="listTable" style="width: 100%; margin-bottom:25px">' +
								'<colgroup>' +
								'<col width="10%"/>' +
								'</colgroup>';
						//html += '<input type="hidden" id="compSeq" value="' + compResult[j].eval_company_seq + '"/>'
						html += '<tbody id="dataTbody">';
						html += '<tr class="itemTr">';

						html += '<tr>';
						html += '	<th colspan="3" id="th1" style="width: 65%; padding: 15px">제안평가 평가항목</th>';
						html += '	<th colspan="5" style="width: 35%;">평가점수</th>';
						html += '</tr>';
						html += '<tr>';
						html += '	<th style="width:10%;">평가</th>';
						html += '	<th style="width:15%;">대분류</th>';
						html += '	<th>중분류</th>';
						html += '	<td style="font-size:11px;">매우우수(A)</td>';
						html += '	<td style="font-size:11px;">우수(B)</td>';
						html += '	<td style="font-size:11px;">보통(C)</td>';
						html += '	<td style="font-size:11px;">미흡(D)</td>';
						html += '	<td style="font-size:11px;">매우미흡(E)</td>';
						html += '</tr>';

						//$("#dataScore").html(html2);


						for (var i = 0; i < result.length; i++) {
							var item = result[i];
							if (result[i].EVAL_COMPANY_SEQ == compResult[j].eval_company_seq) {


								html += '<input type="hidden" id="compSeq_' + j + '" value="' + compResult[j].eval_company_seq + '"/>';
								html += '	<td>' + (item.eval_type ? item.eval_type : "") + '</td>';
								html += '	<td>' + (item.item_name ? item.item_name : "") + '</td>';
								/*html += '	<td>' + (item.item_medium_name ? item.item_medium_name : "") + '</td>';*/
								if (item.item_name === "상생기업") {
									html += '    <td>';
									html += '        <div>상생기업 단독 또는 상생기업 컨소시엄</div>';
									html += '        <div>상생기업이 아닌 중소기업을 포함함 컨소시엄</div>';
									html += '        <div>상생기업이 아닌 일반 기업 단독</div>';
									html += '    </td>';
								} else {
									html += '    <td>' + (item.item_medium_name ? item.item_medium_name : "") + '</td>';
								}

								var disabledAttr = item.item_name === "상생기업" ? "disabled" : "";

								html += '    <td class="itemRadioTd">';
								html += '        <label class="radio-label small-text" style="display: inline-block; text-align: center;">';
								html += '            <span style="display: block;">' + result[i].score_1 + '</span>';  <!-- 숫자를 위로 -->
								html += '            <input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" data-comp-seq="' + compResult[j].eval_company_seq + '" onclick="radioClickEvent(' + compResult[j].eval_company_seq + ');" value="' + result[i].score_1 + '" ' + (result[i].COMMISSIONER_SCORE == result[i].score_1 ? "checked" : "") + ' ' + disabledAttr + ' />';
								html += '        </label>';
								html += '    </td>';
								html += '    <td class="itemRadioTd">';
								html += '        <label class="radio-label small-text" style="display: inline-block; text-align: center;">';
								html += '            <span style="display: block;">' + result[i].score_2 + '</span>';  <!-- 숫자를 위로 -->
								html += '            <input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" data-comp-seq="' + compResult[j].eval_company_seq + '" onclick="radioClickEvent(' + compResult[j].eval_company_seq + ');" value="' + result[i].score_2 + '" ' + (result[i].COMMISSIONER_SCORE == result[i].score_2 ? "checked" : "") + ' ' + disabledAttr + ' />';
								html += '        </label>';
								html += '    </td>';
								html += '    <td class="itemRadioTd">';
								html += '        <label class="radio-label small-text" style="display: inline-block; text-align: center;">';
								html += '            <span style="display: block;">' + result[i].score_3 + '</span>';  <!-- 숫자를 위로 -->
								html += '            <input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" data-comp-seq="' + compResult[j].eval_company_seq + '" onclick="radioClickEvent(' + compResult[j].eval_company_seq + ');" value="' + result[i].score_3 + '" ' + (result[i].COMMISSIONER_SCORE == result[i].score_3 ? "checked" : "") + ' ' + disabledAttr + ' />';
								html += '        </label>';
								html += '    </td>';
								html += '    <td class="itemRadioTd">';
								var score_4_display = result[i].score_4 != null ? result[i].score_4 : '-';
								html += '        <label class="radio-label small-text" style="display: inline-block; text-align: center;">';
								html += '            <span style="display: block;">' + score_4_display + '</span>';  <!-- 숫자를 위로 -->
								html += '            <input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" data-comp-seq="' + compResult[j].eval_company_seq + '" onclick="radioClickEvent(' + compResult[j].eval_company_seq + ');" value="' + result[i].score_4 + '" ' + (result[i].COMMISSIONER_SCORE == result[i].score_4 ? "checked" : "") + ' ' + disabledAttr + ' />';
								html += '        </label>';
								html += '    </td>';
								html += '    <td class="itemRadioTd">';
								var score_5_display = result[i].score_5 != null ? result[i].score_5 : '-';
								html += '        <label class="radio-label small-text" style="display: inline-block; text-align: center;">';
								html += '            <span style="display: block;">' + score_5_display + '</span>';  <!-- 숫자를 위로 -->
								html += '            <input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" data-comp-seq="' + compResult[j].eval_company_seq + '" onclick="radioClickEvent(' + compResult[j].eval_company_seq + ');" value="' + result[i].score_5 + '" ' + (result[i].COMMISSIONER_SCORE == result[i].score_5 ? "checked" : "") + ' ' + disabledAttr + ' />';
								html += '        </label>';
								html += '    </td>';
								html += '</tr>';
							}
						}

							html += '<tr>';
							html += '	<th colspan="3">합계</th>';
							html += '	<td id="totalScore_'+compResult[j].eval_company_seq+'" value="" colspan="5"></td>';
							html += '</tr>';

							html += '</tbody>';
							html += '</table>'+
									'</div>';

					//평가의견
					var list = companyRemarkList[j];
					var remark = list.remark ? list.remark : '';

						html += '<div class="left_div hkFootCont" style="padding-top: 15px;">' +
								'<p class="tit_p mt5 mb10" style="font-size: 20px;">평가의견</p>' +
								'</div>' +
								'<div class="sub_contents_wrap hkFootSubCont" style="min-width:1500px; min-height: 0px; padding-bottom: 5px">' +
								'<div class="com_ta">' +
								'<table style="width: 100%;">' +
								'<tr class="evalIndex' + j + '" style="' + (j > companyRemarkList.length ? 'display:none;' : '') + '">' +
								'<th style="width: 15%;">' + companyRemarkList[j].DISPLAY_TITLE + '</th>' +
								'<td style="text-align: left;">' +
								'<input type="hidden" id="chkTxt' + j + '" name="chkTxt">' +
								'<textarea class="comReMarkInput" id="' + companyRemarkList[j].com_remark_seq + '" data-comp-seq="' + compResult[j].eval_company_seq + '" style="font-size: 20px;" rows="4" cols="100" maxlength="400" placeholder="400자 이하로 입력해주세요.">' + remark + '</textarea>' +
								'<span id="txtCnt_' + j +'">0</span>/400' +
								'</td>' +
								'</tr>' +
								'</table>' +
								'</div>' +
								'</div>';

						html += '<div class="right_div" style="height:70px; padding-bottom: 100px">'+
								'<div class="controll_btn p10">';
						//html += '<button type="button" class="evalButton" id="eachSaveButton" style = "width : 170px;" onclick="eachSaveButton(' + compResult[j].eval_company_seq + ');">'+companyRemarkList[j].DISPLAY_TITLE+' 저장</button>';
						html += '<button type="button" class="evalButton" id="eachSaveButton" style="width: 170px;" onclick="eachSaveButton(' + compResult[j].eval_company_seq + ', \'' + companyRemarkList[j].DISPLAY_TITLE + '\');">' + companyRemarkList[j].DISPLAY_TITLE + ' 저장</button>';

						html += '</div></div>';



					}


				$("#dataScore").html(html);
				$('.listTable').rowspan2(1); //rowspan2 - rowspan 순으로 실행시켜야 원하는 모양으로 나타남.
		  		$('.listTable').rowspan(0);
				//$("#dataTbody").html(html);

				document.querySelectorAll('.comReMarkInput').forEach(function(textarea, index) {
					textarea.addEventListener('input', function() {
						var textLength = this.value.length;
						document.getElementById('txtCnt_' + index).innerText = textLength;
					});
				});


			}

		});

	}



	function prevEvalBtn(){
		var data = {
			itemScoreList : JSON.stringify(eachRadio())
		}

		$.ajax({
			url : "/eval/setScoreData",
			type : "post",
			dataType : "json",
			data : data,
			success:function(rs){

			}
		});


		/*$('input[type="radio"]').removeAttr('checked');
		$("#totalScore").text(0);*/

		$('.evalIndex'+evalCnt).hide();
		evalCnt--;
		$('.evalIndex'+evalCnt).show();

		evalSize--;
		buttonView();

		evalLst(evalCnt);

	}

	function radioClickEvent(compSeq){
		/*var sum = 0;

		$.each($(".score:checked"), function(){
			sum += Number($(this).val());
		})

		if(sum == 100.0){
			sum = 100;
		}else{
			sum = sum.toFixed(1);
		}
		$("#totalScore").text(sum);*/

		var sum = 0;

		// compSeq와 일치하는 라디오 버튼들의 값을 합산
		$.each($(".score:checked[data-comp-seq='" + compSeq + "']"), function() {
			sum += Number($(this).val());
		});

		if (sum === 100.0) {
			sum = 100;
		} else {
			sum = sum.toFixed(1);
		}

		// 해당 compSeq에 해당하는 합계 점수를 표시

		$("#totalScore_" + compSeq).text(sum);

	}

	function init(){

		$.each($('.scoreInput'), function(i, v){

			$(v).val($(v).attr('data-result_score'));

		});

		/*scoreSelectChange();*/
		//buttonView();
	}

	/*function scoreSelectChange(){

		$.each($('.companyTr'), function(i, v){

			var total = 0;

			$.each($(v).find('.scoreInput'), function(ii, vv){

				total += Number($(vv).val());

			});

			$(v).find('.totalInput').val(total);

		});

	} */

	function txtCnt(){
		$.each($('.comReMarkInput'), function(i, v){
			$(v).prev().val($(v).val().length);
			$(v).next().text($(v).val().length)
		});
	}

	function autoSave(){

		var data = getData();

		var saveData = {
			list : JSON.stringify(data.data),
			remark : JSON.stringify(data.remark),
			load : 'N',
			jang : '${userInfo.EVAL_JANG}',


		}

		dataSave(saveData);

	}

	function getData(){

		var array = new Array();
		var remark = new Array();
		var flag = false;

		$.each($('#dataTbody .scoreInput'), function(i, v){

			var data = {
				item_result_seq : $(v).attr('id'),
				score : $(v).val(),
			}

			array.push(data);

		});

		$.each($('.comReMarkInput'), function(i, v){
			var data = {
				com_remark_seq : $(v).attr('id'),
				remark : $(v).val().replaceAll("\n", ""),
			}
			remark.push(data);
		});

		return {data : array, flag : flag, remark : remark};
	}

	function dataSave(saveData){

		var message = saveData.message;
		var flag = saveData.flag;
		var load = saveData.load;

		saveData.commissioner_seq = '${userInfo.COMMISSIONER_SEQ}';
		saveData.committee_seq = '${userInfo.COMMITTEE_SEQ}';

		$.ajax({
			url: "<c:url value='/eval/evalViewSave' />",
			data : saveData,
			type : 'POST',
			success: function(result){
				if(flag != null && flag == 'Y'){
					alert(message);
					if(load == 'Y'){
						location.reload();
					}
				}
			}
		});

	}

	function commitBtn(){

		if(confirm('확정 하시겠습니까?')){

			var data = getData();

			if(data.flag){
				alert('입력되지 않은 항목이 있습니다.');
				return
			}

			var saveData = {
				list : JSON.stringify(data.data),
				remark : JSON.stringify(data.remark),
				flag : 'Y',
				message : '확정되었습니다.',
				load : 'Y',
			}

			dataSave(saveData);

		}

	}

	function eachRadio(){
		var itemScoreList = new Array();

		$('input[type="radio"]').each(function(e){
			if($(this).is(":checked")){
				var data = {
					commissioner_seq : '${userInfo.COMMISSIONER_SEQ}',
					eval_company_seq: $(this).data('comp-seq'),
					item_seq : $(this).attr("ev_seq"),
					score : $(this).val()
				}
				itemScoreList.push(data);
			}
		});

		return itemScoreList;
	}

	function nextEvalBtn(){


		var flag = true;
		var focusTarget;

		$.each($(".itemTr"), function(){
			if($(this).find(".score:checked").length == 0){
				flag = false;
				focusTarget = $($(this).find(".score")[0]);
			}
		})

		if(!flag){
			alert("체크되지 않은 부분이 있습니다. 모두 체크해주세요.");
			$(focusTarget).focus();
			return;
		}
		else if ($('.evalIndex'+evalCnt+' .comReMarkInput').val().length < 0 || $('.evalIndex'+evalCnt+' .comReMarkInput').val().length > 400){
			alert("평가의견은 400자 이하로 입력해주세요.");
			return;
		}

		var data = {
			itemScoreList : JSON.stringify(eachRadio())
		}

		$.ajax({
			url : '<c:url value="/eval/setScoreData" />',
			type : "post",
			dataType : "json",
			data : data,
			success:function(rs){

			},
			error : function(e){

			}
		});

		/*$('input[type="radio"]').removeAttr('checked');
		$("#totalScore").text(0);*/

		$('.evalIndex' + evalCnt).hide();
		evalCnt++;
		$('.evalIndex' + evalCnt).show();

		evalSize++;
		buttonView();

		flag = false;

		evalLst(evalCnt);
	}

	function showSuccessMessage(companySeq) {
		var successMessage = document.getElementById('successMessage' + companySeq);
		if (successMessage) {
			successMessage.style.display = 'inline';
			successMessage.style.color = 'blue';
		}
	}

	function eachSaveButton(companySeq, displayTitle){
		var radioData = eachRadio();
		var filteredData = radioData.filter(function(item) {
			return item.eval_company_seq === companySeq;
		});

		var data = {
			itemScoreList : JSON.stringify(filteredData),
			displayTitle : displayTitle
		}

		//var totalButtons = $('input[data-comp-seq="' + companySeq + '"]').length;
		var totalButtons = $('input[data-comp-seq="' + companySeq + '"]').not(':disabled').length;

		var groupsCount = Math.ceil(totalButtons / 5);

		//var checkedButtons = $('input[data-comp-seq="' + companySeq + '"]:checked').length;
		var checkedButtons = $('input[data-comp-seq="' + companySeq + '"]:checked').not(':disabled').length;

		var textareas = document.querySelectorAll('textarea[data-comp-seq="' + companySeq + '"]');

		if (groupsCount != checkedButtons) {
			alert('체크되지 않은 부분이 있습니다. 모두 체크해주세요.');
			return;
		}

		var isValid = true;

		textareas.forEach(function(textarea) {
			var value = textarea.value;

			if (value.length < 0 || value.length > 400) {
				alert('평가의견은 400자 이하로 입력해주세요.');
				isValid = false;
				return;
			}

		});

		if(!isValid){
			return;
		}

		$.ajax({
			url : '<c:url value="/eval/setScoreData" />',
			type : "post",
			dataType : "json",
			data : data,
			success:function(response){
				if (response.status === 'success') {
					alert(data.displayTitle + ' 저장되었습니다.');
					showSuccessMessage(companySeq);
				} else {
					alert('저장에 실패했습니다.');
				}
			},
			error : function(e){
				alert('오류가 발생하였습니다. 관리자에게 문의해주세요.');
				return;
			}
		});

		//alert('저장되었습니다.');
	}

	function saveBtn(){
		//if(confirm('평가를 확정하시겠습니까?')){
			/*var result = true;
			if("${userInfo.EVAL_JANG}" == "Y"){
				result = getCommissionerChk();
			}

			if(!result){
				alert("평가가 진행 중입니다.\n위원장은 모든 평가위원의 평가가 종료 된 후에 평가 저장이 가능합니다.");
				return;
			}*/

			/*else if ($('.evalIndex'+evalCnt+' .comReMarkInput').val().length < 30 || $('.evalIndex'+evalCnt+' .comReMarkInput').val().length > 400){
				alert("평가의견은 30자 이상 400자 이하로 입력해주세요.");
				return;
			}*/

			//유효성 검사 시에 모든 radio버튼이 체크되어있음에도 검사에서 걸림. 다음주에 확인해 볼 것
			/*var flag = true;

			$.each($(".itemTr"), function(){
				if($(this).find(".score:checked").length == 0){
					flag = false;
					focusTarget = $($(this).find(".score")[0]);
				}
			})

			if(!flag){
				alert("체크되지 않은 부분이 있습니다. 모두 체크해주세요.");
				$(focusTarget).focus();
				return;
			}*/

			//전체 저장 평가항목 유효성 체크
			if (!validateScores()) {
				return;
			}

			//전체 저장 평가의견 유효성 체크
			if (!validateRemarks()) {
				return;
			}


			var data = getData();

			var itemScoreList = eachRadio();

			var saveData = {
				list : JSON.stringify(data.data),
				remark : JSON.stringify(data.remark),
				flag : 'Y',
				message : '저장되었습니다.',
				load : 'Y',
				jang : '${userInfo.EVAL_JANG}',

				itemScoreList : JSON.stringify(itemScoreList)
			}

			dataSave(saveData);

		//}
	}

	//전체 저장 시 유효성체크 함수
	function validateScores() {
		var scoreRadios = document.querySelectorAll('input.score');

		var checkedGroups = {};

		scoreRadios.forEach(function(radio) {
			var evSeq = radio.getAttribute('ev_seq');
			var compSeq = radio.getAttribute('data-comp-seq');
			var groupKey = compSeq + '_' + evSeq;

			/*if (!radio.disabled) {
				if (!checkedGroups[compSeq] && !checkedGroups[evSeq]) {
					checkedGroups[compSeq] = false;
				}

				if (radio.checked) {
					checkedGroups[compSeq] = true;
				}
			}*/
			if (!radio.disabled) {
				if (!checkedGroups[groupKey]) {
					checkedGroups[groupKey] = false;
				}

				if (radio.checked) {
					checkedGroups[groupKey] = true;
				}
			}

		});

		for (var group in checkedGroups) {
			if (!checkedGroups[group]) {
				alert("평가되지 않은 항목이 있습니다.");
				return false;
			}
		}

		return true;
	}

	//전체 저장 시 평가의견 유효성 체크
	function validateRemarks() {
		var remarks = document.querySelectorAll('.comReMarkInput');

		for (var i = 0; i < remarks.length; i++) {
			var remark = remarks[i].value.trim();

			if (remark.length < 0 || remark.length > 400) {
				alert("평가의견은 400자 이하로 입력해주세요.");
				return false;
			}
		}

		return true;
	}

	/*function getCommissionerChk(){
		var commissionerChk = true;

		$.ajax({
			url: "<c:url value='/eval/getCommissionerChk' />",
			data : {
				committee_seq : '${userInfo.COMMITTEE_SEQ}',
				commissioner_seq : '${userInfo.COMMISSIONER_SEQ}',
			},
			type : 'POST',
			dataType : "json",
			async : false,
			success: function(result){
				console.log(result);
				commissionerChk = result.commissionerChk;
			}
		});

		return commissionerChk;

		/!*$.ajax({
			url: "<c:url value='/eval/evalJangConfirmChk' />",
			data : {evalId : '${userInfo.EVAL_USER_ID}'},
			type : 'POST',
			success: function(result){

				if('${userInfo.EVAL_JANG}' == 'Y'){
					location.reload();
				}else if(result.JANG_CONFIRM_YN == 'Y'){
					location.reload();
				}else{
					alert('평가가 진행 중입니다.');
				}

			}
		}); *!/

	}*/

	/*function buttonView(){

		//업체 1개
		if(evalEndCnt == 1){
			//업체가 1개면
			$('#saveButton').show();
			$('#prevButton').hide();
			$('#nextButton').hide();

		}else if(evalEndCnt > 1 && evalSize < evalEndCnt && evalSize != 1){
			$('#saveButton').hide();
			$('#prevButton').show();
			$('#nextButton').show();

		}else if(evalEndCnt != 1 && evalSize == 1){
			$('#saveButton').hide();
			$('#prevButton').hide();
			$('#nextButton').show();
		}else {
			$('#saveButton').show();
			$('#prevButton').show();
			$('#nextButton').hide();
		}

// 	if(evalEndCnt == 1){
// 	//업체가 1개면
// 		$('#saveButton').show();
// 		$('#prevButton').hide();
// 		$('#nextButton').hide();

// 	}else if(evalEndCnt != 1 && evalEndCnt != evalSize){
// 		$('#prevButton').show();
// 		$('#nextButton').show();
// 	}else if(evalEndCnt != 1 && evalEndCnt == evalSize){
// 	//업체가 1개는 아니고 마지막이면
// 		$('#saveButton').show();
// 		$('#prevButton').show();
// 		$('#nextButton').hide();
// 	}else if(evalEndCnt == 1 && evalEndCnt != evalSize){
// 		$('#saveButton').hide();
// 		$('#prevButton').hide();
// 		$('#nextButton').show();
// 	}else if(evalSize == 1){
// 		$('#nextButton').show();
// 		$('#prevButton').hide();
// 	}

	}*/

	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}

</script>
