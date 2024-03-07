<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년  MM월  dd일" />

<title>업체별 제안서 평가집계표</title>

<script type="text/javascript">
	$(function(){
		alert('"제안평가위원장은 \"제안서 평가 총괄표\" 및\n\"업체별 제안서 평가집계표\"에 이상이 없는지\n정확히 확인하여 주시기 바라며,\n저장버튼 클릭후에는 수정이 불가능 합니다"');
	});

	var signHwpFileData = "";
	function signSaveBtn(){
		_pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
			signHwpFileData = data;
		})

		setTimeout(signSave, 600);
	}

	function signSave(){
		var formData = new FormData();
		formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
		formData.append("step", "7");
		formData.append("signHwpFileData", signHwpFileData);

		$.ajax({
			url : "<c:url value='/eval/setSignSetp'/>",
			type : "POST",
			data : formData,
			dataType : "json",
			contentType: false,
			processData: false,
			async : false,
			success : function(data) {
				if(data.result != "success") {
					alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
					return false ;
				} else {
					location.reload();
				}
			},
			error : function(request, status, error) {
				alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
				return false ;
			}
		})
	}

	function setSign(imgData){
		_hwpPutImage("sign", "C:\\SignData\\Temp.png");
	}

	/** TODO. 한글뷰어 수정중 */
	function hwpView(){
		//로컬 보안 이슈
		// _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
		// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step8";
		// _pHwpCtrl.Open(hwpPath,"HWP");
		// _pHwpCtrl.EditMode = 0;

		var serverPath = "";
		var hostname = window.location.hostname;
		if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("121.186.165.80") > -1){
			serverPath = "http://121.186.165.80:8010";
		}else{
			serverPath = "http://one.epis.or.kr/"
		}

		var hwpPath = serverPath + "/upload/evalForm/step8.hwp";
		_hwpOpen(hwpPath, "HWP");

		_pHwpCtrl.EditMode = 0;
		_pHwpCtrl.SetToolBar(1, "TOOLBAR_MENU");
		_pHwpCtrl.SetToolBar(1, "TOOLBAR_STANDARD");
		_pHwpCtrl.ShowRibbon(false);
		_pHwpCtrl.ShowCaret(false);
		_pHwpCtrl.ShowStatusBar(false);
		_pHwpCtrl.SetFieldViewOption(1);
	}

	function _hwpPutData(){
		_pHwpCtrl.MoveToField("contents", true, true, true);
		_pHwpCtrl.PutFieldText("contents", " ");
		_pHwpCtrl.SetTextFile($('#contentsTemp').html(), "HTML", "insertfile");

		var name = "";

		if("${userInfo.EVAL_BLIND_YN}" == "N"){
			name = "${userInfo.NAME }";
		}else{
			name = "${fn:substring(userInfo.NAME, 0, 1)}**";
		}
		if(_pHwpCtrl.FieldExist("name" )) {
			_pHwpCtrl.PutFieldText("name", name);
		}

		_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

		$("#signSave").show();
	}

	function reloadBtn(){
		location.reload();
	}

	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}
</script>

<div style="width: 50%;margin: 0 auto;">
	<div id="signSave" style="display: none;">
		<input type="button" onclick="evalAvoidPopup()" value="기피신청">
		<input type="button" onclick="reloadBtn();" value="새로고침">
		<input type="button" onclick="signSaveBtn();" value="저장">
	</div>
	<div style="width:100%; padding-bottom: 35px; text-align: center;">
		<h4 style="font-size: 30px;">업체별 제안서 평가집계표</h4>
	</div>
	<div id="contentsTemp" >
		<c:forEach items="${getCompanyList }" var="companyList" varStatus="mainSt">
			<TABLE style="margin:0 auto">
				<TR>
					<TD colspan="2" valign="bottom" style='width:103px;height:28px;'>
						<P CLASS=HStyle0 STYLE='line-height:180%;'>▣ 제안업체명 :
							<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${companyList.display_title}</SPAN>
						</P>
					</TD>
					<TD colspan="${result[0].list.size()+2}" valign="bottom" style='width:80px;height:28px;'>
						<P CLASS=HStyle0 STYLE='text-align:right;line-height:180%;'>평가일자 :${nowDate} </P>
					</TD>
				</TR>
				<TR>
					<TD rowspan="2" colspan="2" valign="middle" style='width:270px;height:74px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평가항목</SPAN></P>
					</TD>
					<TD colspan="${result[0].list.size() }" valign="middle" style='width:300px;height:28px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평가위원</SPAN></P>
					</TD>
<%--					<TD rowspan="2" valign="middle" style='width:40px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>--%>
<%--						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>합계</SPAN></P>--%>
<%--					</TD>--%>
					<TD rowspan="2" valign="middle" style='width:40px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평균</SPAN></P>
					</TD>
				</TR>
				<!-- 평가위원 이름 -->
				<TR>
					<c:forEach items="${result[0].list }" var="userList">
						<TD valign="middle" style='width: ${300/result[0].list.size()}px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'>
								<c:choose>
									<c:when test="${userInfo.EVAL_BLIND_YN eq 'Y'}">
										<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${fn:substring(userList.NAME, 0, 1)}**</SPAN>
									</c:when>
									<c:otherwise>
										<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${userList.NAME }</SPAN>
									</c:otherwise>
								</c:choose>
							</P>
						</TD>
					</c:forEach>
				</TR>
				<!-- 점수 (아이템)-->
				<c:forEach items="${result[0].colList }" var="itemList" varStatus="colst">
					<c:set var="sss" value="ITME_SCORE_${itemList.item_seq }"  />
					<TR>
						<TD valign="middle" style='width:229px;height:30px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:left;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${itemList.item_name }</SPAN></P>
						</TD>
						<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${itemList.score }</SPAN></P>
						</TD>

						<c:forEach items="${result[mainSt.index].list }" var="userList" varStatus="st">
							<TD valign="middle" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
								<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${userList[sss]}</SPAN></P>
							</TD>
						</c:forEach>

<%--						<TD valign="middle" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>--%>
<%--							<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'><fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index][sss]}" pattern=".####"/></SPAN></P>--%>
<%--						</TD>--%>
						<TD valign="middle" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'><fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index][sss]}" pattern=".####"/></SPAN></P>
						</TD>
					</TR>
				</c:forEach>
				<!-- 합계 -->
				<TR>
					<TD colspan="2" valign="middle" style='width:128px;height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>합&nbsp; 계 (100점)</SPAN></P>
					</TD>
					<c:forEach items="${result[mainSt.index].list }" var="userList">
						<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'><fmt:formatNumber value="${userList.scoreSum}" pattern=".####"/></SPAN></P>
						</TD>
					</c:forEach>
<%--					<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>--%>
<%--						<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>--%>
<%--					</TD>--%>
					<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'><fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index].TOTAL_SUM}" pattern=".####"/></SPAN></P>
					</TD>
				</TR>
			</TABLE>
			<br>
		</c:forEach>
	</div>

	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;display: none"></div>
</div>