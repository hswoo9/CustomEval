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

// var getCompanyList = JSON.parse('${getCompanyList}');
// var itemList = JSON.parse('${itemList}');
// var result = JSON.parse('${result}');

$(function(){
	
	hwpView();
	
// 	OnConnectDevice();
	
});


function signSaveBtn(){
	
	var filePath = "" ;
	var filePathName = _pHwpCtrl.Path() ;
	var point = filePathName.lastIndexOf("\\") ;
	filePath = filePathName.substring(0,point+1);

	var fileName = "evelTemp";
	var fileNameBak = fileName+"_bak";
	fileName = fileName + ".pdf";
	fileNameBak = fileNameBak + ".pdf";
	var filePathName = filePath + fileName;
	var filePathNameBak = filePath + fileNameBak;
	var srcFilePathName = _pHwpCtrl.Path() ;
	
	var isSave = _pHwpCtrl.SaveAs(filePathName,"PDF");
	_pHwpCtrl.SaveAs(filePathNameBak,"PDF");
	
	var uploader = document.getElementById('uploader');	
   	uploader.addFile("docFile", filePathName);		//서버에 올릴 파일 경로+파일명
	uploader.addParam("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");	//눈구
	uploader.addParam("step", "7");	//단계
	var uploadUri = "<c:url value='/eval/setSignSetp' />";
	var result = uploader.sendRequest(_g_serverName, _g_serverPort, uploadUri);
	
	if(result != "FILE_NM") {
		alert("문서저장시 오류가 발생했습니다. 시스템관리자한테 문의 하세요.");
		return false ;
	}else{
		location.reload();
	}
	
}

function setSign(imgData){
// 	$('#signSrc').attr('src', 'data:image/png;base64,' + imgData);
// 	signSaveBtn();
	_hwpPutImage("sign", "C:\\SignData\\Temp.png");

}

//한글뷰어
function hwpView(){
	//로컬 보안 이슈
	_pHwpCtrl.RegisterModule("FilePathCheckDLL", "FilePathCheckerModuleExample");

	var hwpPath = "http://"+_g_serverName+":"+_g_serverPort+_g_contextPath_+"/common/getHwpFile?fileNm=step8";
	_pHwpCtrl.Open(hwpPath,"HWP");
// 	_pHwpCtrl.EditMode = 0;

	//내용
// 	var title1 = "${userInfo.TITLE }";
// 	var date = "${nowDate}";
	
// 	var dept = "${userInfo.ORG_NAME }";
// 	var name = "${userInfo.NAME }";
	
// 	_hwpPutText("date", "평가일자 :" + date);
	
// 	_hwpPutText("dept", dept);
// 	_hwpPutText("name", name);
	
// 	setItem();
	
}

function setItem(){
	
	var itemList = result[0].colList;
	var userList = result[0].list;
	var sumList = result[0].sumList; 
	
	//채우기
	for (var i = 0; i < getCompanyList.length; i++) {
		var cnt = i+1;
		
		//제안업체명
		_hwpPutText("company{{"+i+"}}", getCompanyList[i].display_title);
		
		//항목, 점수, 합계
		for (var j = 0; j < itemList.length; j++) {
			_hwpPutText("table" + cnt + "_item{{"+j+"}}" , itemList[j].item_name);
			_hwpPutText("table" + cnt + "_score{{"+j+"}}" , itemList[j].score);
			_hwpPutText("table" + cnt + "_total{{"+j+"}}" , sumList[i]["ITME_SCORE_" + itemList[j].item_seq]);
			
		}
		
		//각각 점수
		for (var h = 0; h < result[i].list.length; h++) {
			_hwpPutText("table" + cnt + "_eval_name{{"+h+"}}" , result[i].list[h].NAME);
			
			for (var f = 0; f < itemList.length; f++) {
				_hwpPutText("table" + cnt + "_score_" +(h+1)+ "{{"+f+"}}" , result[i].list[h]["ITME_SCORE_" + itemList[f].item_seq]);
				_hwpPutText("table" + cnt + "_avg{{"+f+"}}", result[i].total["ITME_SCORE_" + itemList[f].item_seq]);
			}
			
		}
		
		
		//지우기
		for (var k = itemList.length; k < 30; k++) {
			_pHwpCtrl.MoveToField("table" + cnt + "_item{{"+itemList.length+"}}");
			_pHwpCtrl.Run("TableDeleteRow");
		}
		
		for (var g = userList.length; g < 10; g++) {
			_pHwpCtrl.MoveToField("table" + cnt + "_eval_name{{"+userList.length+"}}");
			_pHwpCtrl.Run("TableDeleteColumn");
		}
		
		//기관 칸 늘리기
		for (var s = 0; s < (10-userList.length) * 2; s++) {
			_pHwpCtrl.MoveToField("table" + cnt + "_size");
			_pHwpCtrl.Run("TableResizeExRight");
		}
		
		
		
	}

	
	//지우기
	for (var i = getCompanyList.length; i < 30; i++) {
		_pHwpCtrl.MoveToField("mainTable{{"+getCompanyList.length+"}}");
		_pHwpCtrl.Run("TableDeleteRow");
	
	}
	
	//페이지 위로 이동
	for (var i = 0; i < 10; i++) {
		_pHwpCtrl.Run("MoveViewUp");
	}
	
}

function htmlToHwp(){
	
	_pHwpCtrl.MoveToField("contents", true, true, true);
	_pHwpCtrl.PutFieldText("contents", " ");
	_pHwpCtrl.SetTextFile($('#contentsTemp').html(), "HTML", "insertfile");
	
}



</script>

<div style="padding-left: 25%;">
	<div id="signSave">
		<%--<input type="button" onclick="OnConnectDevice();" value="서명하기">--%>
		<input type="button" onclick="signSaveBtn();" style="background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
	</div>
	
<div id="contentsTemp">
		
	<TABLE>
	<TR>
		<TD colspan="2" valign="bottom" style='width:103px;height:28px;'>
		<P CLASS=HStyle0 STYLE='line-height:180%;'>▣ 제안업체명 :</P>
		</TD>
		<TD colspan="3" valign="bottom" style='width:107px;height:28px;'>
		<P CLASS=HStyle0 STYLE='text-align:left;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD colspan="10" valign="bottom" style='width:391px;height:28px;'>
		<P CLASS=HStyle0 STYLE='text-align:right;line-height:180%;'>평가일자 :</P>
		</TD>
	</TR>
	<TR>
		<TD rowspan="2" colspan="3" valign="middle" style='width:128px;height:74px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평가항목</SPAN></P>
		</TD>
		<TD colspan="10" valign="middle" style='width:413px;height:28px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평가위원</SPAN></P>
		</TD>
		<TD rowspan="2" valign="middle" style='width:30px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>합계</SPAN></P>
		</TD>
		<TD rowspan="2" valign="middle" style='width:30px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>평균</SPAN></P>
		</TD>
	</TR>
	
	<!-- 평가위원 이름 -->
	<TR>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
	</TR>
	
	<!-- 점수 -->
	<TR>
		<TD valign="middle" style='width:87px;height:30px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD colspan="2" valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:30px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:30px;height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
	</TR>
	
	
	<TR>
		<TD colspan="3" valign="middle" style='width:128px;height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>합&nbsp; 계 (100점)</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:41px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:30px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
		<TD valign="middle" style='width:30px;height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
		<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>&nbsp;</SPAN></P>
		</TD>
	</TR>
	</TABLE>
		
	
</div>	
	
	
	
	
	
	
	
	
	
	
	
	<OBJECT id="HwpCtrl_1" name="_pHwpCtrl" style=" LEFT: 0px; TOP: 100px" height="850px;" width="900px;" align=center classid=CLSID:BD9C32DE-3155-4691-8972-097D53B10052>
	</OBJECT>
</div>

<object classid="CLSID:1DEAD10F-9EBF-4599-8F00-92714483A9C9" codebase="<c:url value='/resources/activex/NEOSLauncher.cab'></c:url>#version=1,0,0,4" id="uploader"  style="display:none;" >
</object>
