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
	.top_box dl dt{font-size: 25px; }
	.top_box dl dd{margin-top: 3px;}
	.top_box dl dd input{height: 45px; font-size: 15px;}
	.com_ta table th, td{text-align: center; font-size: 25px; }
	/*#listTable input {width: 100px; height: 45px; font-size: 20px;}*/
	#listTable #th1, #th2, #th3{width: 200px;}
	#listTable th{background-color: #28b4ea;}
	.controll_btn button{width: 70px; height: 40px; font-size: 20px;}
	.itemRadioTd{
		justify-content: space-around;
		font-size: 20px;
	}
	.score{
		margin-right: 5px;
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
						<input type="text" style="width: 250px;" readonly="readonly" value="${userInfo.TITLE }">
					</dd>
					<dt style="margin-left:100px;">
						평가자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" readonly="readonly" value="${userInfo.NAME }">
					</dd>
					<dt style="margin-left:100px;">
						평가일자
					</dt>
					<dd style="line-height: 25px">
						<input type="text" readonly="readonly" value="${nowDate }">
					</dd>
				</dl>
			</div>
		</div>



	</div><!-- //sub_contents_wrap -->



	<div class="right_div" style="height:70px;">
		<div class="controll_btn p10">

			<button type="button" class="evalButton" onclick="evalAvoidPopup()" style="width: 120px; float:left;">기피신청</button>
			<button type="button" class="evalButton" id="prevButton" style="display: none;" onclick="prevEvalBtn();">이전</button>
			<button type="button" class="evalButton" id="nextButton" onclick="nextEvalBtn();">다음</button>
			<button type="button" class="evalButton" id="saveButton" style="display: none; float: right; margin-left:10px;" onclick="saveBtn();">저장</button>
			<%--<button type="button" class="evalButton" id="saveButton" style="display: none;" onclick="deviationChk();">저장</button>--%>
			<!-- 			<button type="button" class="evalButton" onclick="nextPageBtn();">다음</button> -->
		</div>
	</div>

	<div id="displayTitle" style="margin-top:10px; margin-bottom:10px; height:30px;"></div>

	<div class="sub_contents_wrap" style="min-width:1500px; min-height: 0px;">
		<div class="com_ta">

			<table id="listTable" style="width: 100%;">
				<colgroup>
					<col width="10%"/>
				</colgroup>

				<tbody id="dataTbody"></tbody>
			</table>
		</div>
	</div>

	<div class="left_div" style="padding-top: 50px;">
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
	</div>

</div><!-- iframe wrap -->

<input type="hidden" id="compSeq" value=""/>
<form id="payForm" action="<c:url value='/eval/evalPay' />" method="post">
	<%-- 	<input type="hidden" name="commissioner_seq" id="commissioner_seq" value="${userInfo.COMMISSIONER_SEQ}"> --%>
</form>

<script>
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
				console.log(rs);
				var compResult = rs.companyList;
				var result = rs.itemList;

				$("#compSeq").val(compResult[evalCnt].eval_company_seq);

				var html = "";
				var html2 = "";
				$("#dataTbody").html(html);


				$("#displayTitle").html(html2);
				html2 += '<span style="font-size:25px; margin-bottom:10px;">' + compResult[evalCnt].display_title + '</span>';
				$("#displayTitle").html(html2);

				html += '<tr>';
				html += '	<th colspan="3" id="th1" style="width: 70%;">제안평가 평가항목</th>';
				html += '	<th colspan="5">평가점수</th>';
				html += '</tr>';
				html += '<tr>';
				html += '	<th>대분류</th>';
				html += '	<th>중분류</th>';
				html += '	<th>소분류</th>';
				html += '	<td>A</td>';
				html += '	<td>B</td>';
				html += '	<td>C</td>';
				html += '	<td>D</td>';
				html += '	<td>E</td>';
				html += '</tr>';

				console.log(result)
				for (var i = 0; i < result.length; i++) {
					var item = result[i];
					if (result[i].EVAL_COMPANY_SEQ == compResult[evalCnt].eval_company_seq) {
						html += '<tr class="itemTr">';

						html += '	<td>' + (item.item_name ? item.item_name : "") + '</td>';
						html += '	<td>' + (item.item_medium_name ? item.item_medium_name : "") + '</td>';
						html += '	<td>' + (item.item_small_name ? item.item_small_name : "") + '</td>';

						html += '	<td class="itemRadioTd">';
						if (result[i].score_1 == result[i].COMMISSIONER_SCORE && result[i].COMMISSIONER_SCORE != null) {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_1  + '" checked />' + result[i].score_1 + '</label>';
						} else {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_1 + '" />' + result[i].score_1 + '</label>';
						}
						html += '	</td>';
						html += '	<td class="itemRadioTd">';
						if (result[i].score_2 == result[i].COMMISSIONER_SCORE && result[i].COMMISSIONER_SCORE != null) {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_2  + '" checked>' + result[i].score_2 + '</label>';
						} else {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_2 + '">' + result[i].score_2 + '</label>';
						}
						html += '	</td>';
						html += '	<td class="itemRadioTd">';
						if (result[i].score_3 == result[i].COMMISSIONER_SCORE && result[i].COMMISSIONER_SCORE != null) {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_3  + '" checked>' + result[i].score_3 + '</label>';
						} else {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_3 + '">' + result[i].score_3 + '</label>';
						}
						html += '	</td>';
						html += '	<td class="itemRadioTd">';
						if (result[i].score_4 == result[i].COMMISSIONER_SCORE && result[i].COMMISSIONER_SCORE != null) {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_4  + '" checked>' + result[i].score_4 + '</label>';
						} else {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_4 + '">' + result[i].score_4 + '</label>';
						}
						html += '	</td>';
						html += '	<td class="itemRadioTd">';
						if (result[i].score_5 == result[i].COMMISSIONER_SCORE && result[i].COMMISSIONER_SCORE != null) {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_5  + '" checked>' + result[i].score_5 + '</label>';
						} else {
							html += '		<label><input type="radio" ev_seq="' + result[i].item_seq + '" class="score" name="score' + i + '" onclick="radioClickEvent(' + result.length + ');" value="' + result[i].score_5 + '">' + result[i].score_5 + '</label>';
						}


						html += '	</td>';
						html += '</tr>';
					}
				}
				html += '<tr>';
				html += '	<th colspan="3">합계</th>';
				html += '	<td id="totalScore" value="" colspan="5"></td>';
				html += '</tr>';
				$("#dataTbody").html(html);



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

	function radioClickEvent(){
		var sum = 0;

		$.each($(".score:checked"), function(){
			sum += Number($(this).val());
		})

		if(sum == 100.0){
			sum = 100;
		}else{
			sum = sum.toFixed(1);
		}
		$("#totalScore").text(sum);

	}

	function init(){

		$.each($('.scoreInput'), function(i, v){

			$(v).val($(v).attr('data-result_score'));

		});

		/*scoreSelectChange();*/
		buttonView();
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
					eval_company_seq : $("#compSeq").val(),
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
		else if ($('.evalIndex'+evalCnt+' .comReMarkInput').val().length < 30 || $('.evalIndex'+evalCnt+' .comReMarkInput').val().length > 400){
			alert("평가의견은 30자 이상 400자 이하로 입력해주세요.");
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

	function saveBtn(){
		if(confirm('저장하시겠습니까?')){

			var result = true;
			if("${userInfo.EVAL_JANG}" == "Y"){
				result = getCommissionerChk();
			}

			if(!result){
				alert("평가가 진행 중입니다.\n위원장은 모든 평가위원의 평가가 종료 된 후에 평가 저장이 가능합니다.");
				return;
			}
			else if ($('.evalIndex'+evalCnt+' .comReMarkInput').val().length < 30 || $('.evalIndex'+evalCnt+' .comReMarkInput').val().length > 400){
				alert("평가의견은 30자 이상 400자 이하로 입력해주세요.");
				return;
			}

			var flag = true;

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

		}
	}

	function getCommissionerChk(){
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

		/*$.ajax({
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
		}); */

	}

	function buttonView(){

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

	}

	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}

</script>
