var approvalDocument = {
    
    global : {
        hwpCtrl : "",
        params : "",
        data : "",
    },
    
    fn_defaultScript : function(params){
        approvalDocument.global.params = params;
        var ds = customKendo.fn_customAjax("/workPlan/getWorkConditionsOne", approvalDocument.global.params);
        if(ds.flag){
            approvalDocument.global.data = ds.rs;
        }
        approvalDocument.fn_SetHtml();
    },

    fn_getHtml : function(imgUrl){
        var html = "";
        if(approvalDocument.global.data != ""){
            html ='<table role="grid" style="margin-left:auto; margin-right:auto;max-width: none;border-collapse: separate;border-spacing: 0;empty-cells: show;border-width: 0; outline: 0; text-align: center; border: 1px solid #eaeaea; font-size:14px;line-height:25px;width:550px;">'
                + '<tr style="width : 550px; height: 50px;">'
                + '  <th colspan="6" style="padding-bottom: 50px;"><p style="text-decoration-style: double; font-weight: bold; border-width: 0; font-size:30px; text-align: center; text-decoration-thickness:1px; table-layout: fixed;">휴 직 원</p></th>'
                + '</th>'
                + ' <tr>'
                + '  <th style="width:70px; height: 40px;  padding: 5px 0; border: 1px solid #eaeaea; border-width: 1px 0 1px 1px; font-weight: bold; text-align: center;">성 명</th>'
                + '  <td style="width:130px; height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 1px 0 1px 1px;  font-weight: normal; text-align: center;">'+ approvalDocument.global.data.EMP_NAME_KR +'</th>'
                + '  <th style="width:70px; height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 1px 0 1px 1px; font-weight: bold; text-align: center;">직 위</th>'
                + '  <td style="width:110px; height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 1px 0 1px 1px;  font-weight: normal; text-align: center;">'+ approvalDocument.global.data.POSITION_NAME +'</th>'
                + '  <th style="width:70px; height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 1px 0 1px 1px; font-weight: bold; text-align: center;">직 급</th>'
                + '  <td style="width:100px; height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 1px 0 1px 1px;  font-weight: normal; text-align: center;">'+ approvalDocument.global.data.ONE_DUTY_NAME +'</th>'
                + ' </tr>'
                + ' <tr>'
                + '  <td style="width:70px;height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; font-weight: bold; text-align: center;">소 속</td>'
                + '  <td colspan="3" style="width:310px;height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 0 0 1px 1px;  font-weight: normal; text-align: center;">'+ approvalDocument.global.data.DEPT_NAME +'</td>'
                + '  <th style="width:70px;height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; font-weight: bold; text-align: center;">채용일</td>'
                + '  <td style="width:100px;height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 0 0 1px 1px;  font-weight: normal; text-align: center;">'+ approvalDocument.global.data.JOIN_DAY +'</td>'
                + ' </tr>'
                + ' <tr>'
                + '  <th style="width:70px;height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; font-weight: bold; text-align: center;">휴직사유</td>'
                + '  <td colspan="5" style="width:480px;height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 0 0 1px 1px;  font-weight: normal;padding-left: 10px;">'+ approvalDocument.global.data.BMK +'</td>'
                + ' </tr>'
                + ' <tr>'
                + '  <th style="width:70px;height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 0 0 1px 1px; font-weight: bold; text-align: center;">휴직기간</td>'
                + '  <td colspan="5" style="width:480px;height: 40px; padding: 5px 0; border: 1px solid #eaeaea; border-width: 0 0 1px 1px;  font-weight: normal;  word-spacing: 30px;padding-left: 10px;">' + approvalDocument.global.data.START_END_DATE + approvalDocument.global.data.START_END_DIFF + '</td>'
                + ' </tr>'
                + ' </table>'
                + '<table role="grid" style="margin-left:auto; margin-right:auto;max-width: none;border-collapse: separate;border-spacing: 0;empty-cells: show;border-width: 0; outline: 0; text-align: center; border: 1px solid #eaeaea; font-size:14px;line-height:25px;width:550px;">'
                + '  <tr style="width: 550px;">'
                + '     <td colspan="4" style="padding-top: 20px;">'
                + '첨 부: 증빙서류'
                + '     </td>'
                + '  </tr>'
                + '  <tr style="padding-top: 70px;">'
                + '     <td colspan="4">'
                + '         <p style="text-align: center; caption-side: bottom; font-weight: normal; padding: 15px 0; font-size:18px;">위와 같이 휴직을 신청합니다.</p>'
                + '     </td>'
                + '  </tr>'
                + '  <tr style="padding-top: 70px;">'
                + '     <td colspan="4">'
                + '         <p style="text-align: center; caption-side: bottom; font-weight: normal; padding: 15px 0; font-size:18px;">'+ approvalDocument.global.data.NOW_DATE +'</p>'
                + '     </td>'
                + '  </tr>'
                + '  <tr style="padding-top: 30px;">'
                + '     <td colspan="3" style="width: 450px;">'
                + '         <p style="text-align: right; caption-side: bottom; font-weight: normal; padding: 15px 0; font-size:18px; width: 400px;">신청인 : '+approvalDocument.global.data.EMP_NAME_KR + '</p>'
                + '     </td>'
                + '     <td style="width: 100px;">';
                if(imgUrl != ""){
                    html += imgUrl;
                }else{
                    html += '         <p style="text-align: right; padding: 10px 0;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(인)<span id="signVal"></span></p>';
                }
                html += '      </td>'
                + '  </tr>'
                + '  <tr>'
                + '     <td colspan="4" style="padding-top: 70px;">'
                + '         <span style="text-align : center;font-weight: bold;font-size:19px; font-weight: bold; ">농림수산식품교육문화정보원장 </span><span style="font-weight: bold;font-size:17px; font-weight: bold; ">귀하</span>'
                + '     </td>'
                + '  </tr>'
                + '</table>';
        }

        return html;
    },

    fn_SetHtml : function(){
        approvalDocument.fn_setEditor(approvalDocument.fn_getHtml(""));
    },

    fn_setEditor : function(html) {
        approvalDocument.global.hwpCtrl = BuildWebHwpCtrl("docEditor", approvalDocument.global.params.hwpUrl, function () {
            approvalDocument.editorComplete(html);

            approvalDocument.global.hwpCtrl.PrintDocument();
        });
    },

    editorComplete : function(html){
        var g_hostName = window.location.hostname;
        var filePath = "";

        if(g_hostName == 'localhost' || g_hostName == '127.0.0.1' || g_hostName == '121.186.165.80'){
            filePath = "http://121.186.165.80:8010/upload/test/test.hwp";
        }else{
            filePath = "http://10.10.10.114/upload/test/test.hwp";
        }

        approvalDocument.global.hwpCtrl.Open(filePath, "HWPML2X", "", function () {
        }, {"userData" : "success"});

        approvalDocument.global.hwpCtrl.SetTextFile(html, "HTML", "", function (){
        }, {"userData" : "success"});

        approvalDocument.global.hwpCtrl.EditMode = 0;
        approvalDocument.global.hwpCtrl.SetToolBar(1, "TOOLBAR_MENU");
        approvalDocument.global.hwpCtrl.SetToolBar(1, "TOOLBAR_STANDARD");
        approvalDocument.global.hwpCtrl.ShowRibbon(false);
        approvalDocument.global.hwpCtrl.ShowCaret(false);
        approvalDocument.global.hwpCtrl.ShowStatusBar(false);
        approvalDocument.global.hwpCtrl.SetFieldViewOption(1);


        approvalDocument.resize();
        
        
    },

    resize : function() {
        if (document.getElementById("hwpctrl_frame") != null && typeof(document.getElementById("hwpctrl_frame")) != "undefined") {
            var pHeight = (window.innerHeight - 20) + "px";
            document.getElementById("hwpctrl_frame").style.width = "100%";
            document.getElementById("hwpctrl_frame").style.height = pHeight;
        }
    },

    fn_onSubmit : function(){
        var url = "/pop/sign/popDrawSignView.do?";
        url += "workPlan=true";
        url += "&callBack=fn_checkCallBack";
        url += "&jsName=opener.approvalDocument";
        var name = "popup test";
        var option = "width = 340, height = 390, top = 100, left = 200, location = no"
        var popup = window.open(url, name, option);
    },


}

function fn_checkCallBack(imgUrl){
    //한글에 이미지 어떻게 넣지?
    approvalDocument.fn_setEditor(approvalDocument.fn_getHtml(imgUrl));
}