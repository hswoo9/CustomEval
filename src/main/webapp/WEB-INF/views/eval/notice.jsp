<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>

<script>
    $(function(){
        if('${message}' != ''){
            customAlert('${message}', 'success').then(() => {

            });

            /*customConfirm('${message}', 'info').then((flag) => {
            if(flag){
                alert("true");
            }
        });*/
        }
    });

    window.onload = function () {
        window.scrollTo(0, 0);
    };

    var signFlag = false;

    function openPop(){
        var name = "popup test";
        var option = "width = 1200, height = 400, top = 100, left = 200, location = no"
        var popup = window.open(_g_contextPath_ + '/eval/popEvalSign?evalId=' + $("#hidEvalId").val() + '&evalPw=' + $("#hidEvalPw").val() + "&commissioner_seq=${userInfo.COMMISSIONER_SEQ}", name, option);
    }

    function nextPageBtn(){
        var flag = true;
        var signDir = "${userInfo.SIGN_DIR}";
        $.each($("input[name=chk]"), function(){
            if(!this.checked){
                flag = false;
            }
        })

        if(flag){
            if(signDir != ""){
                signFlag = true;
            }

            if(signFlag){
                location.href = _g_contextPath_ + "/eval/evalView";
            }else{
                openPop();
            }

        }else{
            customAlert("체크되지 않은 항목이 있습니다. 다시 확인바랍니다.", 'warning')
            /*alert("체크되지 않은 항목이 있습니다. 다시 확인바랍니다.");*/
        }
    }

    function evalAvoidPopup(){
        window.open(_g_contextPath_ + "/eval/evalAvoidPopup", 'evalAvoidPop', 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=1000,height=280,left=650,top=250');
    }

    function checkedAll(e){
        if($(e).is(":checked")) $("input[name=chk]").prop("checked", true);
        else $("input[name=chk]").prop("checked", false);
    };

</script>

<style>
    @media (pointer:coarse) {
        /* custom css for "touch targets" */
        #mainContent {padding-left: 0px !important; width: 100% !important;}

        /*#mainContent {width: 600px !important;}*/
        #notiContent, #subContent {width: 100% !important;}

    }

    html, body {
        overflow-y: scroll !important;
        scrollbar-width: auto !important;
        -ms-overflow-style: scrollbar !important; }

    ::-webkit-scrollbar {
        width: 8px; /* 스크롤바 너비 */
    }

    ::-webkit-scrollbar-thumb {
        background-color: #888; /* 스크롤바 색상 */
        border-radius: 3px; /* 스크롤바 모서리 둥글게 */
    }

    ::-webkit-scrollbar-track {
        background: #f1f1f1; /* 스크롤바 배경 */
    }
</style>

<input type="hidden" id="hidEvalId" value=""/>
<input type="hidden" id="hidEvalPw" value=""/>


<div id="mainContent" style="width: 1000px; padding-left: 25%;" >
    <div id="signSave" style="width:100%;">
        <input type="button" onclick="evalAvoidPopup();" style=" background-color: #dee4ea; border-color: black; font-weight : bold; color: red; border-width: thin;" value="기피신청">
        <a href="#" onclick="nextPageBtn();" target="_self">
            <input type="button" style="float:right; background-color: #dee4ea; border-color: black; border-width: thin;" value="다음">
        </a>
    </div>

    <TABLE id="subContent" border="1" cellspacing="0" cellpadding="0" style='width:1000px; border-collapse:collapse;border:none;'>
        <TR>
            <TD valign="middle" bgcolor="#ffffff"  style='width:439px;height:44px;border-left:none;border-right:none;border-top:none;border-bottom:double #000000 2.0pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
                <P CLASS=HStyle0 STYLE='margin-bottom:5.0pt;text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:bold;line-height:160%'>평가위원 유의사항(제9조의2제1항 관련)</SPAN></P>
            </TD>
        </TR>
    </TABLE>
    <P CLASS=HStyle0 STYLE='margin-bottom:5.0pt;text-align:center;'></P>

    <P CLASS=HStyle0 STYLE='margin-bottom:5.0pt;text-align:center;'><BR></P>

    <P CLASS=HStyle0 STYLE='margin-bottom:5.0pt;text-align:center;'>
    <TABLE id="notiContent" border="1" cellspacing="0" cellpadding="0" style='width:1000px; border-collapse:collapse;border:none;'>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;padding:1.4pt 1.4pt 1.4pt 1.4pt; border:none'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;text-align: right;border:none'>
                    <input type="checkbox" id="checkAll" name="checkAll" onclick="checkedAll(this)">
                    전체 동의
                </P>
            </TD>
        </TR>
    <c:forEach var="notice" items="${noticeList}">
        <c:if test="${notice['NOTICE_ITEM'] == 1}">
            <TR>
                <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                    <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                        <input type="checkbox" id="chk${loop.index}" name="chk" value="Y">
                        <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;${notice['NOTICE_CONTENT']}</SPAN>
                    </P>
                </TD>
            </TR>
        </c:if>
    </c:forEach>
       <%-- <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #000000 1.1pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk01" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;평가장 분위기를 리드하려 하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk02" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;평가 및 심사종료 전에는 개인적 용무를 자제하여야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk03" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;표정으로 찬성ㆍ반대 입장을 나타내지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk04" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;자신의 지식을 전달하려 하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk05" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;자신의 지식을 과시하려 하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk06" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;가르치려 하거나 배우려 하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk07" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;평가위원 상호간 상의나 협의하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk08" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;옳고 그름을 언행으로 가리지 말고 점수로 평가하여야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk09" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;순수한 채점자가 되어야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk10" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;평가대상자에게 면박이나 무안을 주지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk11" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;평가대상자의 의사결정 내용을 언행으로 확인하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk12" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;평가를 말이나 행동으로 하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk13" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;정답이나 오답을 유도하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk14" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;편가르기식 언행은 삼가야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:15.6pt;margin-right:3.0pt;text-indent:-12.6pt;line-height:130%;'>
                    <input type="checkbox" id="chk15" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;제안서의 잘못된 부분은 평가로 표현하고 지적하여 고치려 하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk16" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;미루어 짐작하거나 축소 확대 해석하지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk17" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;평가종료 후 본인의 평가내용을 밝히지 말아야 합니다.</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <input type="checkbox" id="chk18" name="chk" value="Y">
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;정성 필수 제안 사항 평가 시 업체 제안 내용이 수요기관의 제안 요청 사항을 반영하였는지 충분히 검토하여 평가한다.</SPAN></P>
            </TD>
        </TR>--%>
    </TABLE>

    <TABLE id="notiContent" border="1" cellspacing="0" cellpadding="0" style='width:1000px; border-collapse:collapse;border:none; margin-top:20px;'>
        <caption style="text-align: left; font-size:13.0pt; color: red; font-weight: bold;">기피사유</caption>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <SPAN STYLE='font-size:13.0pt;line-height:130% ;color: red;"'>기피사유에 해당하는 평가위원께서는 기피신청을 해주시기 바랍니다.</SPAN></P>
            </TD>
        </TR>
       <%-- <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <SPAN STYLE='font-size:13.0pt;line-height:130% ;color: red;"'>&#9642;평가위원이 당해 평가 대상과 관련 전년도 1월 1일부터 현재까지 하도급을 포함하여 용역, 자문, 연구 등을 수행한 경우</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <SPAN STYLE='font-size:13.0pt;line-height:130%; color: red;'>&#9642;평가위원 또는 소속기관이 당해 평가 대상 용역 시행으로 인하여 이해당사자가 되는 경우(대리관계 포함)</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <SPAN STYLE='font-size:13.0pt;line-height:130%; color: red;'>&#9642;평가위원이 당해 평가대상 업체에 재직한 경우</SPAN></P>
            </TD>
        </TR>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                    <SPAN STYLE='font-size:13.0pt;line-height:130%; color: red;'>&#9642;그 밖에 제1호부터 제3호까지에 준하는 경우로서 기타 공정한 평가를 수행할 수 없다고 판단하는 경우</SPAN></P>
            </TD>
        </TR>--%>
        <c:forEach var="notice" items="${noticeList}">
            <c:if test="${notice['NOTICE_ITEM'] == 2}">
                <TR>
                    <TD valign="middle" style='width:632px;height:40px;border-left:solid #000000 1.1pt;border-right:solid #000000 1.1pt;border-top:solid #aeaeae 0.6pt;border-bottom:solid #aeaeae 0.6pt;padding:1.4pt 1.4pt 1.4pt 1.4pt'>
                        <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;'>
                            <input type="checkbox" id="chk${loop.index}" name="chk" value="Y">
                            <SPAN STYLE='font-size:13.0pt;line-height:130%; color: red;'>&#9642;${notice['NOTICE_CONTENT']}</SPAN>
                        </P>
                    </TD>
                </TR>
            </c:if>
        </c:forEach>
    </TABLE>



</div>
