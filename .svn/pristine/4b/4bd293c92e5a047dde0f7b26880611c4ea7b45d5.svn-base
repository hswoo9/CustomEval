<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>

<script>
    var signFlag = false;

    function openPop(){
        var name = "popup test";
        var option = "width = 320, height = 360, top = 100, left = 200, location = no"
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
            alert("체크되지 않은 항목이 있습니다. 다시 확인바랍니다.");
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

<input type="hidden" id="hidEvalId" value=""/>
<input type="hidden" id="hidEvalPw" value=""/>


<div style="width: 1400px; padding-left: 25%;" >
    <div id="signSave">
        <input type="button" onclick="evalAvoidPopup();" value="기피신청">
        <a href="#" onclick="nextPageBtn();" target="_self">
            <input type="button" value="다음">
        </a>
    </div>

    <TABLE border="1" cellspacing="0" cellpadding="0" style='width:1000px; border-collapse:collapse;border:none;'>
        <TR>
            <TD valign="middle" bgcolor="#ffffff"  style='width:439px;height:44px;border-left:none;border-right:none;border-top:none;border-bottom:double #000000 2.0pt;padding:1.4pt 5.1pt 1.4pt 5.1pt'>
                <P CLASS=HStyle0 STYLE='margin-bottom:5.0pt;text-align:center;'><SPAN STYLE='font-size:16.0pt;font-weight:bold;line-height:160%'>평가위원 유의사항(제9조의2제1항 관련)</SPAN></P>
            </TD>
        </TR>
    </TABLE>
    <P CLASS=HStyle0 STYLE='margin-bottom:5.0pt;text-align:center;'></P>

    <P CLASS=HStyle0 STYLE='margin-bottom:5.0pt;text-align:center;'><BR></P>

    <P CLASS=HStyle0 STYLE='margin-bottom:5.0pt;text-align:center;'>
    <TABLE border="1" cellspacing="0" cellpadding="0" style='width:1000px; border-collapse:collapse;border:none;'>
        <TR>
            <TD valign="middle" style='width:632px;height:40px;padding:1.4pt 1.4pt 1.4pt 1.4pt; border:none'>
                <P CLASS=HStyle0 STYLE='margin-left:3.0pt;margin-right:3.0pt;line-height:130%;text-align: right;border:none'>
                    <input type="checkbox" id="checkAll" name="checkAll" onclick="checkedAll(this)">
                    전체 동의
                </P>
            </TD>
        </TR>
        <TR>
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
                    <SPAN STYLE='font-size:13.0pt;line-height:130%'>&#9642;</SPAN><SPAN STYLE='font-size:13.0pt;letter-spacing:-5%;line-height:130%'>제안서의 잘못된 부분은 평가로 표현하고 지적하여 고치려 하지 말아야 합니다.</SPAN></P>
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
        </TR>
    </TABLE>

</div>
