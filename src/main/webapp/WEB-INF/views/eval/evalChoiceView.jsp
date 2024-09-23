<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>

<style>
.com_ta table th {text-align: center;}
#applyBtn {
	width: 100px; height: 50px; font-size: 15px;
}
table tr th,td { font-size: 15px; }
</style>

<div class="iframe_wrap" style="min-width:1400px">

	<!-- 컨텐츠타이틀영역 -->
	<div class="sub_title_wrap">
		
		<div class="title_div">
			<h4>평가위원장 선택</h4>
		</div>
	</div>
	
	<div class="left_div" style="padding-top: 50px;">
		<p class="tit_p mt5 mb10" style="font-size: 20px;">평가위원장 선택</p>
	</div>
	<div class="sub_contents_wrap" style="min-width:1500px; min-height: 0px;">
		<div class="com_ta">
			
			<table style="width: 100%;">
				<colgroup>
					<col width="100px;"/>
				</colgroup>
				<tr>
					<th></th>
					<th>이름</th>
				</tr>
				
				<c:forEach items="${commissionerList }" var="list">
					<c:if test="${list.eval_avoid ne 'Y'}">
						<tr>
							<td style="text-align: center;">
								<input type="checkbox" value="${list.commissioner_seq }" class="commChk" style="width: 30px; height: 30px;">
								<input type="hidden" id="comm_nmae" value="${list.NAME }">
								<input type="hidden" id="committee_seq" value="${list.committee_seq }">
							</td>
							<td>${list.NAME }</td>
						</tr>
					</c:if>
				</c:forEach>
			
			</table>		
			
			<div style="padding-top: 20px; text-align: center;">
				<input type="button" style="margin-bottom: 15px;" id="applyBtn" onclick="evalApply();" value="등록하기">
			</div>
			
		</div>
		
	</div>	
	
</div><!-- iframe wrap -->

<div class="pop_wrap_dir" id="loadingPop" style="width: 443px;">
	<div class="pop_con">
		<table class="fwb ac" style="width:100%;">
			<tr>
				<td>
					<span class=""><img src="<c:url value='/resources/Images/ico/loading.gif'/>" alt="" />  &nbsp;&nbsp;&nbsp;평가위원장을 등록 중입니다.</span>		
				</td>
			</tr>
		</table>
	</div>
	<!-- //pop_con -->
</div>

<script>
var evalApplyData;
var timeIn;

$(function(){
	
	$('.commChk').on('click', function(e){
		
		var t = $(this).prop('checked');
		
		$('.commChk').prop('checked', false);
		
		$(this).prop('checked', t);
		
	});
	
	$('#loadingPop').kendoWindow({
	     width: "443px",
	     visible: false,
	     modal: true,
	     actions: [],
	     close: false,
	     title: false,
	 }).data("kendoWindow").center();
	
	if('${userInfo.EVA_JANG_CHK}' == 'Y'){
		evalApplyData = {
				committee_seq : '${userInfo.COMMITTEE_SEQ}'
		}
		$('#loadingPop').data("kendoWindow").open();
		timeIn = setInterval(getEvalJang, 1000);
	}
	
});

function evalApply(){
	
	var data = {};
	
	$.each($('.commChk'), function(i, v){
		
		if($(v).prop('checked')){
			
			data = {
				committee_seq : $(v).parent().find('#committee_seq').val(),
				commissioner_seq : $(v).val(),
				name	: $(v).parent().find('#comm_nmae').val(),
			};
			
		}
		
	});
	
	if(data.commissioner_seq == null){
		alert('평가위원장을 선택해 주세요.');
		return
	}

	if(confirm('등록하시겠습니까?')){
		
		$.ajax({
	        url: "<c:url value='/eval/setCommSave' />",
	        data: data,
	        type: 'POST',
	        dataType : 'text',
	        success: function(result){

	        	if(result == 'Y'){
	        		location.href = "<c:url value='/eval/evalView' />";	
	        	}else if(result == 'O'){
					alert('동점자가 있습니다. 다시 투표해주세요.');
					location.reload();
				}else{
	        		evalApplyData = data;
	        		timeIn = setInterval(getEvalJang, 1000);
	        	}
	        
	        },
	        beforeSend: function () {
	        	$('#loadingPop').data("kendoWindow").open();
	        },
	    });
		
		
	}
	
}

function getEvalJang(){
	
	$.ajax({
        url: "<c:url value='/eval/getEvalJang' />",
        data: evalApplyData,
        type: 'POST',
        dataType : 'text',
        success: function(result){
			
        	if(result == 'Y'){
        		clearInterval(timeIn);
        		location.href = "<c:url value='/eval/evalView' />";	
        	}else if(result == 'O'){
				alert('동점자가 있습니다. 다시 투표해주세요.');
				clearInterval(timeIn);

				$.ajax({
					url:"<c:url value='/eval/setEvalJangReSelected' />",
					data: evalApplyData,
					type: 'POST',
					dataType: 'text',
					success : function (){
						//clearInterval(timeIn);
						location.reload();
					}
				});
				/*clearInterval(timeIn);
				location.reload();*/
			}
        },

	});
	
}

</script>








