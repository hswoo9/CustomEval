<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<script>
	window.onload = function () {
		window.scrollTo(0, 0);
	};

	$(function(){
		$("#"+$("#jangBlindChk", opener.parent.document).val()).prop("checked", "checked");
	});

function cancelBtn(){
	var evalBlindYn = $("input[name='evalBlindYn']:checked").val();
	var evalBlindId = $("input[name='evalBlindYn']:checked").attr("id");

	if(confirm("설정하시겠습니까?")){
		var data ={
			evalBlindYn : evalBlindYn,
			committee_seq : '${params.committee_seq}',
		};

		$.ajax({
			url: "<c:url value='/eval/setEvalCommissionerBlindUpd'/>",
			data : data,
			type : 'POST',
			success: function(){
				alert("처리 되었습니다.");
				$("#jangBlindChk", opener.parent.document).val(evalBlindId);
				window.close();
			},
			error : function(){
				alert("처리 중 오류가 발생했습니다. 시스템관리자에게 문의 하세요.");
			}
		});
	}
}

</script>


<div style="padding-top:10px">
	<div id="evalAvoidCancelPopup">
		<div>
			<!-- 컨트롤박스 -->
			<div class="com_ta2">
				<div class="top_box gray_box" id="newDate">
					<dl style="padding-bottom:10px;">
						<dt style="">
							평가집계표 출력방식 설정
						</dt>
						<dd style="line-height: 25px;width: 100%;text-align: center;display: flex;justify-content: space-around;">
							<label for="evalBlindN">
								<input type="radio" id="evalBlindN" name="evalBlindYn" value="N" checked>공개용
							</label>
							<label for="evalBlindY">
								<input type="radio" id="evalBlindY" name="evalBlindYn" value="Y" >블라인드용
							</label>
						</dd>
					</dl>
				</div>

				<div>
					<dl>
						<dd style="text-align: center; margin-top:20px">
							<input type="button" style="margin-bottom: 15px;" id="saveBtn" onclick="cancelBtn();" value="등록하기">
							<input type="button" style="margin-bottom: 15px;" id="closeBtn" onclick="window.close();" value="닫기">
						</dd>
					</dl>
				</div>
			</div>
		</div><!-- //pop_con -->
	</div><!-- //pop_wrap -->
</div>
