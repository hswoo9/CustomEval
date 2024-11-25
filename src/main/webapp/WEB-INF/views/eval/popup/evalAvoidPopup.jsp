<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<script>
function cancelBtn(){
	if(confirm("기피신청을 확정할 경우, 평가에서 제외되며 다시 참여하실 수 없습니다. 그래도 진행하시겠습니까?")){
		var data ={};

		data.eval_avoid_txt = $('input:radio[name=avoidReason]:checked').val();

		if(data.eval_avoid_txt == 'other'){
			data.eval_avoid_txt = $('#otherTxt').val();
		}

		$.ajax({
			url: "<c:url value='/eval/evalAvoid' />",
			data : data,
			type : 'POST',
			success: function(){
				alert("처리 되었습니다.");
				//opener.parent.location.href = _g_contextPath_ + "/";
				//opener.parent.location.href = "<c:url value='/eval/goEvalAvoid'/>";
				opener.parent.location.href = "<c:url value='/eval/evalView'/>";

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
					<form id="payForm" action="<c:url value='/eval/evalAvoid' />" method="post">
						<dl style="padding-bottom:10px;">
							<dt style="">
								기피사유
							</dt>
							<dd style="line-height: 25px; width: 77%;">
								<input type="radio" id="test1" name="avoidReason" value="평가위원이 당해 평가 대상과 관련 전년도 1월 1일부터 현재까지 하도급을 포함하여 용역, 자문, 연구 등을 수행한 경우" checked>
								<label for="test1">평가위원이 당해 평가 대상과 관련 전년도 1월 1일부터 현재까지 하도급을 포함하여 용역, 자문, 연구 등을 수행한 경우</label><br>
								<input type="radio" id="test2" name="avoidReason" value="평가위원 또는 소속기관이 당해 평가 대상 용역 시행으로 인하여 이해당사자가 되는 경우(대리관계 포함)">
								<label for="test2">평가위원 또는 소속기관이 당해 평가 대상 용역 시행으로 인하여 이해당사자가 되는 경우(대리관계 포함)</label><br>
								<input type="radio" id="test3" name="avoidReason" value="평가위원이 당해 평가대상 업체에 재직한 경우">
								<label for="test3">평가위원이 당해 평가대상 업체에 재직한 경우</label><br>
								<input type="radio" id="test4" name="avoidReason" value="그 밖에 제1호부터 제3호까지에 준하는 경우로서 기타 공정한 평가를 수행할 수 없다고 판단하는 경우">
								<label for="test4">그 밖에 제1호부터 제3호까지에 준하는 경우로서 기타 공정한 평가를 수행할 수 없다고 판단하는 경우</label><br>
								<input type="radio" id="other" name="avoidReason" value="other">
								<label for="other">기타</label>
								<input type="text" id="otherTxt" style="width:85%;">
								<%--<input type="text" id="eval_avoid_txt" style="width: 100%;">--%>
							</dd>
						</dl>
					</form>
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
