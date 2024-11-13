<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"
		 import="java.lang.Math" import="java.util.ArrayList" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:useBean id="nowDate" class="java.util.Date" />
<fmt:formatDate value="${nowDate}" var="nowDate" pattern="yyyy년  MM월  dd일" />
<%--<script type="text/javascript" src="http://10.10.10.112:8080/js/hwpctrlapp/utils/util.js"></script>
<script type="text/javascript" src="http://10.10.10.112:8080/js/webhwpctrl.js"></script>--%>

<title>업체별 제안서 평가집계표</title>


<style>
    @media (pointer:coarse) {
        .th {
            background-color : #8c8c8c !important;
            color : white !important;
        }
    }
</style>

<script type="text/javascript">
	$(function(){
		$('.infoTbody').rowspan2(1); //rowspan2 - rowspan 순으로 실행시켜야 원하는 모양으로 나타남.
		alert('"제안평가위원장은 \"제안서 평가 총괄표\" 및\n\"업체별 제안서 평가집계표\"에 이상이 없는지\n정확히 확인하여 주시기 바라며,\n저장버튼 클릭후에는 수정이 불가능 합니다"');
  		$('.infoTbody').rowspan(0);
  		// $("#contentsTemp").hide();
	});

	window.onload = function() {
		history.pushState(null, null, window.location.href);
		history.pushState(null, null, window.location.href);

		window.addEventListener('popstate', function () {
			history.pushState(null, null, window.location.href);
		});
	};

	var signHwpFileData = "";
	
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
	
	function signSaveBtn(){
		// _pHwpCtrl.GetTextFile("HWPML2X", "", function(data) {
		// 	signHwpFileData = data;
		// })

		setTimeout(signSave, 600);
	}

	function signSave(){
		var formData = new FormData();
		formData.append("commissioner_seq", "${userInfo.COMMISSIONER_SEQ}");
		formData.append("step", "7");

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
		if(hostname.indexOf("localhost") > -1 || hostname.indexOf("127.0.0.1") > -1 || hostname.indexOf("1.233.95.140") > -1){
			serverPath = "http://1.233.95.140:58090/";
		}else{
			serverPath = "http://one.epis.or.kr/"
		}

		// var hwpPath = serverPath + "/upload/evalForm/step8.hwp";
		// _hwpOpen(hwpPath, "HWP");
        //
		// _pHwpCtrl.EditMode = 0;
		// _pHwpCtrl.SetToolBar(1, "TOOLBAR_MENU");
		// _pHwpCtrl.SetToolBar(1, "TOOLBAR_STANDARD");
		// _pHwpCtrl.ShowRibbon(false);
		// _pHwpCtrl.ShowCaret(false);
		// _pHwpCtrl.ShowStatusBar(false);
		// _pHwpCtrl.SetFieldViewOption(1);
	}

	function _hwpPutData(){
		_pHwpCtrl.MoveToField("contents", true, true, true);
		_pHwpCtrl.PutFieldText("contents", "\n");
		
		_pHwpCtrl.SetTextFile($('#contentsTemp').html(), "HTML", "insertfile", function(){

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
	})
	};

	function reloadBtn(){
		location.reload();
	}

	function evalAvoidPopup(){
		window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
	}
</script>

<div style="width: 75%;margin: 0 auto;">
	<div id="signSave" style="">
		<input type="hidden" onclick="evalAvoidPopup()" style="background-color: #dee4ea; border-color: black; border-width: thin;" value="기피신청">
		<input type="button" onclick="signSaveBtn();" style="float:right; margin-left : 10px; background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
		<input type="button" onclick="reloadBtn();" style="float:right; background-color: #dee4ea; border-color: black; border-width: thin;"  value="새로고침">
	</div>
 	<div style="width:100%; padding-bottom: 35px; text-align: center; padding-top: 50px;">
		<h4 style="font-size: 30px;">업체별 제안서 평가집계표</h4>
	</div>
	<div id="contentsTemp" >

		<c:set var="userCount" value="${result[0].list.size()}" />
		<c:set var="colListCount" value="${result[0].colList.size()}"/>

		<%
			int userCount = (Integer) pageContext.getAttribute("userCount");
			int maxUserCount = 9;
			int tableCount = (int) Math.ceil((double) userCount / maxUserCount);
			int endTableCount = (tableCount-1);

			pageContext.setAttribute("tableCount", tableCount);
			pageContext.setAttribute("endTableCount", endTableCount);

			int colListCount = (Integer) pageContext.getAttribute("colListCount");

			ArrayList<Integer> colIndics = new ArrayList<Integer>();
			for(int j = 0; j<colListCount; j++){
				colIndics.add(j);
			}
			pageContext.setAttribute("colIndics",colIndics);
		%>


		<c:forEach items="${getCompanyList }" var="companyList" varStatus="mainSt">

		<div style="page-break-after: always;">

			<c:forEach var="t" begin="0" end="${endTableCount}">

				<%
					int currentIndex = Integer.parseInt(pageContext.getAttribute("t").toString());

					int startIndex = currentIndex * maxUserCount;
					int currentUserCount = Math.min(userCount - startIndex, maxUserCount);
					int adjustedUserCount = currentUserCount + 4;


					pageContext.setAttribute("currentUserCount", currentUserCount);
					pageContext.setAttribute("adjustedUserCount", adjustedUserCount);

					ArrayList<Integer> indices = new ArrayList<Integer>();
					for (int i = 0; i < currentUserCount; i++) {
						indices.add(startIndex + i);
					}
					pageContext.setAttribute("indices", indices);
				%>

				<%--<ul>
					<c:forEach var="index" items="${indices}">
						<SPAN STYLE='font-family:"한양중고딕,한컴돋움";'>${index}</SPAN>
					</c:forEach>
				</ul>--%>


			<%--</c:forEach>--%>

			<TABLE class="infoTbody" style="margin:0;">
				<TR>
					<TD colspan="3" valign="bottom" style='width:250px; height:28px;'>
						<P CLASS=HStyle0 STYLE='line-height:180%;'>▣ 제안업체명 :
							<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${companyList.display_title}</SPAN>
						</P>
					</TD>
					<TD colspan="<%= adjustedUserCount %>" valign="bottom" style='height:28px;'>
						<P CLASS=HStyle0 STYLE='text-align:right;line-height:180%;'>평가일자 :${nowDate} </P>
					</TD>
				</TR>
				<TR>
					<TD class="th" rowspan="2" colspan="3" valign="middle" style='width:350px;height:74px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"; font-size:11px;'>평가항목</SPAN></P>
					</TD>
					<TD class="th" rowspan="2" valign="middle" style='width:40px;height:74px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";'>배점</SPAN></P>
					</TD>
					<TD class="th" colspan="<%= currentUserCount %>" valign="middle" style='width : 450px; height:28px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";'>평가위원</SPAN></P>
					</TD>
					<TD class="th" rowspan="2" valign="middle" style='width:60px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";'>합계</SPAN></P>
					</TD>
					<TD class="th" rowspan="2" valign="middle" style='width:60px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";'>평균</SPAN></P>
					</TD>
					<TD class="th" rowspan="2" valign="middle" style='width:40px;height:74px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움";'>비고</SPAN></P>
					</TD>
				</TR>
				<!-- 평가위원 이름 -->
				<TR>
					<%--<c:forEach items="${result[0].list }" var="userList">--%>
					<c:forEach var="index" items="${indices}">
						<TD valign="middle" style='width:<%= 450 / currentUserCount %>px;height:46px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:130%;'>
								<c:choose>
									<c:when test="${userInfo.EVAL_BLIND_YN eq 'Y'}">
										<SPAN STYLE='font-family:"한양중고딕,한컴돋움";'>${fn:substring(result[0].list[index].NAME, 0, 1)}**</SPAN>
									</c:when>
									<c:otherwise>
										<SPAN STYLE='font-family:"한양중고딕,한컴돋움";'>${result[0].list[index].NAME }</SPAN>
									</c:otherwise>
								</c:choose>
							</P>
						</TD>
					</c:forEach>
				</TR>
				<!-- 점수 (아이템)-->
				<%--<c:forEach items="${result[0].colList }" var="itemList" varStatus="colst">--%>
				<c:forEach var="colIndex" items="${colIndics}">
					<%--<c:set var="sss" value="ITME_SCORE_${itemList.item_seq }" />
					<c:set var="sss2" value="ITME_SUM_SCORE_${itemList.item_seq }" />
					<c:set var="sss3" value="${itemList.score}" />
					<c:set var="sss4" value="${itemList.item_name }" />--%>
					<c:set var="sss" value="ITME_SCORE_${result[0].colList[colIndex].item_seq }" />
					<c:set var="sss2" value="ITME_SUM_SCORE_${result[0].colList[colIndex].item_seq }" />
					<c:set var="sss3" value="${result[0].colList[colIndex].score}" />
					<c:set var="sss4" value="${result[0].colList[colIndex].item_name }" />
					<TR>
						<TD class="th ${result[0].colList[colIndex].eval_type}"  valign="middle" style='width:25px;height:30px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center;'>

							${result[0].colList[colIndex].eval_type }<!-- 평가타입 -->

						</TD>
						<TD class=${result[0].colList[colIndex].eval_type } valign="middle" name="item_name" style='width:100px;height:30px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt;text-align:center;'>

							<c:choose>
								<c:when test="${result[0].colList[colIndex].item_name == '상생기업'}">
									${result[0].colList[colIndex].item_name }<br>(5점) <!-- 대분류 -->
								</c:when>
								<c:otherwise>
									${result[0].colList[colIndex].item_name }<br>(${result[0].colList[colIndex].big_item_sum_score }점) <!-- 대분류 -->
								</c:otherwise>
							</c:choose>


						</TD>
						<TD valign="middle"  style='width:225px;height:30px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:left;line-height:150%;'>
								<c:choose>
									<c:when test="${result[0].colList[colIndex].item_name == '상생기업'}">
									<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
									상생기업 단독 또는 상생기업</br>
										컨소시엄 상생기업이 아닌 중소기업을 포함한 컨소시엄</br>
										상생기업이 아닌 일반 기업 단독
									</SPAN>
									</c:when>
									<c:otherwise>
										<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>${result[0].colList[colIndex].item_medium_name }</SPAN>
									</c:otherwise>
								</c:choose>
							</P>
						</TD>
						<TD valign="middle" name="item_score" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
									<c:choose>
										<c:when test="${result[0].colList[colIndex].score == null || result[0].colList[colIndex].score == 0}">
											-
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${result[0].colList[colIndex].score}" pattern=".####"/>
										</c:otherwise>
									</c:choose>
								</SPAN>
							</P>
						</TD>
						<%--<c:set var="scoreIndex" value="${result[mainSt.index].list.size() }"/>--%>
						<%
							int begin = currentIndex * maxUserCount;
							int end = begin + currentUserCount -1;

							pageContext.setAttribute("begin", begin);
							pageContext.setAttribute("end", end);
						%>



						<c:set var="maxValue" value="0" />
						<c:set var="minValue" value="999" />
						<c:set var="maxValueStruck" value="false" />
						<c:set var="minValueStruck" value="false" />

						<c:if test="${userCount > 5}">

						<c:forEach items="${result[mainSt.index].list }" var="userScoreList">

								<fmt:parseNumber var="scoreAsNumber" value="${userScoreList.get(sss)}" type="number" />
								<c:if test="${scoreAsNumber > maxValue}">
									<c:set var="maxValue" value="${scoreAsNumber}" />
								</c:if>
								<c:if test="${scoreAsNumber < minValue}">
									<c:set var="minValue" value="${scoreAsNumber}" />
								</c:if>

						</c:forEach>

						</c:if>

						<c:forEach items="${result[mainSt.index].list }" var="userList" varStatus="st" begin="${begin}" end="${end}">

							<TD valign="middle" name="user_score" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
								<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'>
									<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
										<c:choose>
											<c:when test="${userList[sss] == null || userList[sss] == 0}">
												-
											</c:when>

											<c:otherwise>
												<c:choose>
													<c:when test="${userList.get(sss) == maxValue && maxValueStruck == 'false' && userCount > 5}">
														<!-- 최대값에 취소선 적용 -->
														<strike><fmt:formatNumber value="${userList.get(sss)}" pattern=".####"/></strike>
														<c:set var="maxValueStruck" value="true" />
													</c:when>
													<c:when test="${userList.get(sss) == minValue && minValueStruck == 'false' && userCount > 5}">
														<!-- 최소값에 취소선 적용 -->
														<strike><fmt:formatNumber value="${userList.get(sss)}" pattern=".####"/></strike>
														<c:set var="minValueStruck" value="true" />
													</c:when>

													<c:otherwise>
														<fmt:formatNumber value="${userList.get(sss)}" pattern=".####"/>
													</c:otherwise>

												</c:choose>
											</c:otherwise>


										</c:choose>
									</SPAN>
								</P>
							</TD>
						</c:forEach>

						<TD valign="middle" name="item_sum_score" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
									<c:choose>
										<c:when test="${result[mainSt.index].sumList[mainSt.index][sss2] == null || result[mainSt.index].sumList[mainSt.index][sss2] == 0}">
											-
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index][sss2]}" pattern=".####"/>
										</c:otherwise>
									</c:choose>
								</SPAN>
							</P>
						</TD>

						<TD valign="middle" name="item_average" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
									<c:choose>
										<c:when test="${result[mainSt.index].sumList[mainSt.index][sss] == null || result[mainSt.index].sumList[mainSt.index][sss] == 0}">
											-
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index][sss]}" pattern=".####"/>
										</c:otherwise>
									</c:choose>
								</SPAN>
							</P>
						</TD>

						<TD valign="middle" name="item_average" style='height:30px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.4pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'> - </SPAN>
							</P>
						</TD>
					</TR>
				</c:forEach>
				<!-- 합계 -->
				<%
					int begin = currentIndex * maxUserCount;
					int end = begin + currentUserCount -1;

					pageContext.setAttribute("begin", begin);
					pageContext.setAttribute("end", end);
				%>
				<TR>
					<TD class="th" colspan="3" valign="middle" style='height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS="HStyle0" STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>합&nbsp; 계</SPAN></P>
					</TD>
					<TD colspan="1" valign="middle" style='height:33px;border-left:solid #000000 0.9pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>100점</SPAN></P>
					</TD>
					<c:forEach items="${result[mainSt.index].list}" var="userList" begin="${begin}" end="${end}"  >
						<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.4pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
							<P CLASS=HStyle0 STYLE='text-align:center;line-height:150%;'>
								<SPAN STYLE='font-family:"한양중고딕,한컴돋움"'>
									<c:choose>
										<c:when test="${userList.scoreSum == null}">
											-
										</c:when>
										<c:when test="${userList.scoreSum == 0}">
											-
										</c:when>
										<c:otherwise>
											<fmt:formatNumber value="${userList.scoreSum}" pattern=".####"/>
										</c:otherwise>
									</c:choose>
								</SPAN>
							</P>
						</TD>
					</c:forEach>
					<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'><fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index].TOTAL_ITEM_SUM}" pattern=".####"/></SPAN></P>
					</TD>
					<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'><fmt:formatNumber value="${result[mainSt.index].sumList[mainSt.index].TOTAL_SUM}" pattern=".####"/></SPAN></P>
					</TD>
					<TD valign="middle" style='height:33px;border-left:solid #000000 0.4pt;border-right:solid #000000 0.9pt;border-top:solid #000000 0.4pt;border-bottom:solid #000000 0.9pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
						<P CLASS=HStyle0 STYLE='text-align:center;'><SPAN STYLE='font-family:"한양중고딕,한컴돋움"'> - </SPAN></P>
					</TD>
				</TR>
				<TR>
					<TD colspan="7" valign="bottom" style='height:28px;'>
						<P CLASS=HStyle0 STYLE='line-height:180%;'>* 평가위원이 5인을 초과하는 경우 <b>세부</b>평가항목별 점수의 최고‧최저 점수를 제외</P>
					</TD>
				</TR>
				<TR>
					<TD colspan="4" valign="bottom" style='height:28px;'>
						<P CLASS=HStyle0 STYLE='text-align:left;line-height:180%;'>** 소수점 다섯째 자리에서 반올림</P>
					</TD>
				</TR>
			</TABLE>

			</c:forEach>
		<hr style="width : 100%; text-align:center;"/>
		</div>
		</c:forEach>

	</div>

<%--	<div id="_pHwpCtrl" style="height: 100%;border: 1px solid lightgray;/* display : none; */"></div>--%>
</div>