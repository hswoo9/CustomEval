<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년   MM월   dd일" />

<title>사전접촉여부</title>

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
		$('#orgName').text('평가위원 또는 신고자 소 속 : ${userInfo.ORG_NAME }');
		$('#name').text('성 명 : ${userInfo.NAME }');
	});

	//한글뷰어
	var jsonData = JSON.parse('${getCompanyList}');

	var signHwpFileData = "";
	var flag = 'N';
	function signSaveBtn(){
		//저장
		for (var i = 0; i < jsonData.length; i++) {
			var chk = $('select[name="chkData[]"] option:selected')[i].value;

			if(chk == '있다') {
				flag = 'Y';
			}

			_hwpPutText("contactor{{"+i+"}}", $('input[name="contactor[]"]')[i].value);
			_hwpPutText("inputDate{{"+i+"}}", $('input[name="inputDate[]"]')[i].value.replace(/-/gi, ""));
			_hwpPutText("chk{{"+i+"}}", chk);
			_hwpPutText("contents{{"+i+"}}", $('input[name="contents[]"]')[i].value);
		}

		_pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
			signHwpFileData = data;
		})

		setTimeout(signSave, 600);
	}

	function signSave(){
		var formData = new FormData();
		formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
		formData.append("step", "9");
		formData.append("flag", flag);
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
		$('#sign').attr('src', 'data:image/png;base64,' + imgData);
		_hwpPutImage("sign", "C:\\SignData\\Temp.png");
	}

	/** TODO. 한글뷰어 수정중 */
	function hwpView(){
		//로컬 보안 이슈
		// _pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");
		// var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step4";
		// _pHwpCtrl.Open(hwpPath,"HWP");
		//_pHwpCtrl.EditMode = 1;

		var serverPath = "";
		var hostname = window.location.hostname;
		if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("121.186.165.80") > -1){
			serverPath = "http://121.186.165.80:8010";
		}else{
			serverPath = "http://one.epis.or.kr/"
		}

		var hwpPath = serverPath + "/upload/evalForm/step4.hwp";
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
		var title1 = "본인은 「${userInfo.TITLE } 사업」의 기술제안서 평가와 관련하여 입찰자와의 사전접촉 여부를 아래와 같이 확인(신고)합니다.";
		var date = "${nowDate}";
		var name = "${userInfo.NAME }";
		var dept = "${userInfo.ORG_NAME }";

		_hwpPutText("title1", title1);
		_hwpPutText("dept", dept);
		_hwpPutText("date", date);
		_hwpPutText("name", name);

		_hwpPutSignImg("sign", "${userInfo.SIGN_DIR }");

		setItem(jsonData);
	}

	function setItem(v){
		//채우기
		for (var i = 0; i < v.length; i++) {
			_hwpPutText("company{{"+i+"}}", v[i].company_name);
		}
		//나머지 지우기
		for (var i = v.length; i < 30; i++) {
			_pHwpCtrl.MoveToField("company{{"+i+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}
	}

	function chkData(){
		var flag = 'N';
		for (var i = 0; i < jsonData.length; i++) {
			var txt = _pHwpCtrl.GetFieldText("chk{{"+i+"}}");
			if(txt == '있다'){
				flag = 'Y';
			}
		}

		return flag;
	}

	function chkDataChange(e){
		if($(e).val() == "없다"){
			$(e).closest("tr").find("input[name='contactor[]']").attr("disabled", "disabled");
			$(e).closest("tr").find("input[name='inputDate[]']").data("kendoDatePicker").enable(false);
			$(e).closest("tr").find("input[name='contents[]']").attr("disabled", "disabled");
		}else{
			$(e).closest("tr").find("input[name='contactor[]']").removeAttr("disabled");
			$(e).closest("tr").find("input[name='inputDate[]']").data("kendoDatePicker").enable(true);
			$(e).closest("tr").find("input[name='inputDate[]']").attr("readonly", "readonly")
			$(e).closest("tr").find("input[name='contents[]']").removeAttr("disabled");
		}
	}

	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}

</script>

<style>
	table tr th,td {border: 1px; border-style: solid; text-align: center; height: 40px; }
</style>

<div class=WordSection1 style="width: 900px; height: 1000px;padding-left: 200px;">
	<div id="signSave">
		<input type="button" onclick="evalAvoidPopup()" value="기피신청">
		<input type="button" onclick="signSaveBtn();" value="저장">
	</div>

	<div align=center style="padding-top: 30px; width: 1400px;">
		<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0 style='border-collapse:collapse;border:none'>
			<tr style='height:28.3pt'>
				<td style='width:241.35pt;border:none;border-bottom:double black 3.75pt;  background:white;'>
					<p class=a align=center style='text-align:center;word-break:normal'><b><span  style='font-size:17.0pt;line-height:103%;'>사전접촉여부 확인(신고)서</span></b></p>
				</td>
			</tr>
		</table>
	</div>

	<p class=a align=center style='text-align:center;line-height:130%;word-break:normal'><span style='font-size:13.0pt;line-height:130%;letter-spacing:-.1pt'>&nbsp;</span></p>
	<p class=a style='margin-top:3.0pt;margin-right:0in;margin-bottom:3.0pt;margin-left:0in'>&nbsp;</p>
	<p class=a style='margin-top:3.0pt;margin-right:0in;margin-bottom:3.0pt;margin-left:0in'>본인은 「${userInfo.TITLE } 사업」의 기술제안서 평가와 관련하여 입찰자와의 사전접촉 여부를 아래와 같이 확인(신고)합니다.</p>
	<p class=a style='margin-top:3.0pt;margin-right:0in;margin-bottom:3.0pt;margin-left:0in'>&nbsp;</p>
	<p class=a style='margin-top:30px;margin-right:0in;margin-bottom:3.0pt;margin-left:15.6pt;text-indent:-15.6pt'><b><span style='font-size:12.0pt;line-height:103%;font-family:"Arial Unicode MS",sans-serif'>□</span></b><b><span style='font-size:12.0pt;line-height:103%'> 사전접촉 사실 확인(신고)서</span></b></p>

	<table style="width: 1400px;">
		<colgroup>
			<col width="30%">
			<col width="10%">
			<col width="10%">
			<col width="10%">
			<col width="40%">
		</colgroup>
		<thead>
		<tr>
			<th>업체명</th>
			<th>사전 접촉자</th>
			<th>일시</th>
			<th>확인</th>
			<th>세부내용</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach var="item" items="${companyList}" varStatus="status">
			<tr>
				<td>${item.company_name}</td>
				<td>
					<input type="text" name="contactor[]" id="contactor${status.count}" disabled>
				</td>
				<td>
					<input type="text" name="inputDate[]" id="inputDate${status.count}" style="width: 80%" disabled>
				</td>
				<td>
					<select name="chkData[]" id="chkData${status.count}" style="width: 80px;" onchange="chkDataChange(this)">
						<option value="없다" selected="selected">없다</option>
						<option value="있다">있다</option>
					</select>
				</td>
				<td>
					<input type="text" name="contents[]" id="contents${status.count}" style="width: 95%;" disabled>
				</td>
			</tr>
			<script>
				$("#inputDate${status.count}").kendoDatePicker({
					culture : "ko-KR",
					format : "yyyy-MM-dd",
					value : new Date()
				});
				$("#inputDate${status.count}").attr("readonly", "readonly");
			</script>
		</c:forEach>
		</tbody>
		<tfoot>
		<tr>
			<td colspan="5" style="height: 100px; border: none;">
				${nowDate}
			</td>
		</tr>
		<tr>
			<td colspan="5" id="orgName" style="border: none;">
			</td>
		</tr>
		<tr>
			<td colspan="3" id="name" style="border: none; text-align: right;">
			</td>
			<td colspan="2" style="border: none; text-align: left;padding-left: 35px;">
				(인)
				<span id="signVal">
						<img alt="(인)" id="sign" src="${userInfo.SIGN_DIR}" style="position: absolute; text-align: center; transform: translate(-51px, -27px);width: 76px">
					</span>
			</td>
		</tr>
		<tr>
			<td colspan="5" style="border: none; font-size: 25px;">
				농림수산식품교육문화정보원장 귀하
			</td>
		</tr>
		</tfoot>
	</table>

	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;display: none"></div>

	<%--<OBJECT id="HwpCtrl_1" name="_pHwpCtrl" style="display:none; LEFT: 0px; TOP: 100px" height="1300px;" width="900px;" align=center classid=CLSID:BD9C32DE-3155-4691-8972-097D53B10052>--%>
	<%--</OBJECT>--%>

