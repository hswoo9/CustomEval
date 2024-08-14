<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean id="today" class="java.util.Date" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta name="description" content="Crush it Able The most popular Admin Dashboard template and ui kit">
    <meta name="author" content="PuffinTheme the theme designer">
    <!-- 1990년 이후 이 페이지의 캐시를 만료시킴. -->
    <meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT" />

    <link rel="icon" href="/assets/images/logo2.png" type="image/x-icon"/>

    <title>농림수산식품교육문화정보원</title>

    <!--Kendo ui css-->

    <!-- Theme -->
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui1/kendo.silver.min.css' />" />




    <!--Kendo excel js-->
    <script type="text/javascript" src="<c:url value='/resources/js/jszip.min.js'/>"></script>

    <!-- Bootstrap Core and vandor -->
    <link rel="stylesheet" href="/resources/assets/plugins/bootstrap/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/resources/assets/plugins/charts-c3/c3.min.css"/>
    <link rel="stylesheet" href="/resources/assets/plugins/jvectormap/jvectormap-2.0.3.css" />

    <!-- Core css -->
    <link rel="stylesheet" href="<c:url value='/resources/assets/css/main.css'/>"/>
    <link rel="stylesheet" href="/resources/assets/css/theme4.css" />
    <link rel="stylesheet" href="/resources/css/style1.css" />

    <!-- jQuery -->
    <link rel="stylesheet" href="/resources/css/kendoui1/kendo.default-main.min.css"/>
    <link rel="stylesheet" href="/resources/css/kendoui1/kendo.common.min.css"/>
    <link rel="stylesheet" href="/resources/css/kendoui1/kendo.default.min.css"/>

    <!-- ckEditor -->
    <script type="text/javascript" src="<c:url value='/resources/ckEditor/ckeditor.js'/>"></script>

    <script type="text/javascript" src="<c:url value='/resources/js/common1/moment.min.js?ver=${today}'/>"></script>
    <script type="text/javascript" src="<c:url value='/resources/js/common1/linkageProcessUtil.js?ver=${today}'/>"></script>
    <script type="text/javascript" src='<c:url value="/resources/js/common1/common.js?ver=${today}"></c:url>'></script>
    <script type="text/javascript" src="<c:url value='/resources/js/common1/kendoSettings.js?ver=${today}'/>"></script>


    <!--Kendo ui js-->
    <%--<script src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.6.0/slick.js"></script>--%>
    <script type="text/javascript" src="<c:url value='/resources/js/kendoui1/jquery-3.4.1.min.js?ver=${today}'/>"></script>
    <%--<script type="text/javascript" src="<c:url value='/js/kendoui/kendo.all.min.js?ver=${today}'/>"></script>--%>
    <script type="text/javascript" src="<c:url value='/resources/js/kendoui1/kendo.all.min.js'/>"></script>
    <script type="text/javascript" src="<c:url value='/resources/js/kendoui1/cultures/kendo.culture.ko-KR.min.js?ver=${today}'/>"></script>

    <style>
        .k-scheduler-header-wrap .k-scheduler-table tbody tr th:last-child {color: blue;}
        .k-scheduler-header-wrap .k-scheduler-table tbody tr th:first-child {color: red;}
        .k-scheduler-content .k-scheduler-table tbody tr td:last-child {color: blue;}
        .k-scheduler-content .k-scheduler-table tbody tr td:first-child {color: red;}
        .k-scheduler-table td {vertical-align: top !important;}
        .k-event, .k-more-events {border-width: 0px;}
        .k-button-solid-base.k-selected {background-color: #1984c8 !important;}
    </style>
    <script>
        var chk_id = [];
        var companion_id = new Array();

        $(function(){
            $('.title_menu>ul').hide();

            $("body").on("keydown", function(key){
                if(key.altKey && key.ctrlKey && key.shiftKey){
                    window.open("/writeVisitor.do", "writeVisitor", "width=1740,height=780");
                }
            })

        });

        sessionStorage.setItem("contextpath", "${pageContext.request.contextPath}");
        _g_contextPath_ = "${pageContext.request.contextPath}";
        function getContextPath() {
            return sessionStorage.getItem("contextpath");
        }

        /** 메신저 팝업 */
        function messenger(){

            kendo.saveAs({
                dataURI: "/common/fileDownload2.do?filePath=/upload/setupTUC_231023.exe&fileName=" + encodeURIComponent("setupTUC_231023.exe"),
            });

            /*var windowPopUrl = "http://121.186.165.80:3000/";
            var popName = "messenger";
            var popStyle ="width=500, height=500, scrollbars=no, top=100, left=200, resizable=no, toolbars=no, menubar=no";

            window.open(windowPopUrl, popName, popStyle);*/
        }

        /** 휴가 부여(분)받은 분 표기 변환 */
        function vacMinuteToHour(grantDay){
            //1일기준 480분 = 8시간 (기본근무시간)
            //1시간 60분

            //1. 부여일(분)/480 = 일(몫)
            //2. (부여일(분)%480)/60 = 일 수 구한 나머지를 시간으로 변환 - 시간(1의 나머지/60))
            //3. (부여일(분)%480)%60 = 시간 수 구한 나머지는 분으로 표기 - 분(2의 나머지)
            //표기법 일/시간/분
            var hour = parseInt(grantDay/480);
            var remainHour = grantDay/480;

            remainHour = remainHour - hour;
            remainHour = remainHour * 480;
            remainHour = remainHour/60;
            remainHour = remainHour.toFixed(3);

            return hour+"("+remainHour+"h)";
            //return parseInt(grantDay/480)+"("+parseInt((grantDay%480)/60)+"h)";
        }

        function getNumtoCom(str){
            return Number(str).toLocaleString().split(".")[0];
        }

        function getComtoNum(str){
            return Number(str != null ? str.replace(/,/gi, '') : '');
        }

        /** 바이트 변환 */
        function formatBytes(bytes, decimals = 2) {
            if (bytes === 0) return '0 Bytes';

            const k = 1024;
            const dm = decimals < 0 ? 0 : decimals;
            const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

            const i = Math.floor(Math.log(bytes) / Math.log(k));

            return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
        }


        //현재 년 월 주차 반환
        function weekNumOfMonth(date){
            var WEEK_KOR = ["1째주", "2째주", "3째주", "4째주", "5째주"];
            var THURSDAY_NUM = 4;	// 첫째주의 기준은 목요일(4)이다. (https://info.singident.com/60)

            var firstDate = new Date(date.getFullYear(), date.getMonth(), 1);
            var lastDate = new Date(date.getFullYear(), date.getMonth(), 0);
            var firstDayOfWeek = firstDate.getDay();

            var firstThursday = 1 + THURSDAY_NUM - firstDayOfWeek;	// 첫째주 목요일
            if(firstThursday <= 0){
                firstThursday = firstThursday + 7;	// 한주는 7일
            }
            var untilDateOfFirstWeek = firstThursday-7+3;	// 월요일기준으로 계산 (월요일부터 한주의 시작)
            var weekNum = Math.ceil((date.getDate()-untilDateOfFirstWeek) / 7) - 1;

            if(weekNum < 0){	// 첫째주 이하일 경우 전월 마지막주 계산
                var lastDateOfMonth = new Date(date.getFullYear(), date.getMonth(), 0);
                var result = Util.Date.weekNumOfMonth(lastDateOfMonth);
                return result;
            }
            var monthStr = "00"+(date.getMonth()+1);

            return [date.getFullYear() + "년", monthStr.substring(monthStr.length-2, monthStr.length)+'월', lastDate.getDate(),
                WEEK_KOR[weekNum], date.getFullYear() + "-" + monthStr.substring(monthStr.length-2, monthStr.length)];
        }

        function kendoSchedulerSetting(dataSource){
            kendo.culture("ko-KR");

            $("#scheduler").kendoScheduler({
                date: new Date(),
                startTime: new Date(),
                height: 671,
                views: [
                    "month", "day"
                ],
                timezone: "Etc/UTC",
                dataSource: dataSource,
                selectable: false,
                editable: false
            });
        }

        function fileImgTag(ext){
            return "<img src=\'/images/ico/file_ico2/ico_file_" + ext + ".png\' width='20'>";
        }

        function numToKOR(num){
            var minus = '';
            if(num.indexOf('-') != -1){
                minus = '-';
                num = num.replace('-','');
            }
            var hanA = new Array("","일","이","삼","사","오","육","칠","팔","구","십");
            var danA = new Array("","십","백","천","","십","백","천","","십","백","천","","십","백","천");
            var result = "";
            for(i=0; i<num.length; i++) {
                str = ""; han = hanA[num.charAt(num.length-(i+1))];
                if(han != "") str += han+danA[i];
                if(i == 4 && (num[num.length-1-i] !== '0' || num[num.length-1-i-1] !== '0' || num[num.length-1-i-2] !== '0' || num[num.length-1-i-3] !== '0')){
                    str += "만";
                }
                if(i == 8 && (num[num.length-1-i] !== '0' || num[num.length-1-i-1] !== '0' || num[num.length-1-i-2] !== '0' || num[num.length-1-i-3] !== '0')){
                    str += "억";
                }
                if(i == 12 && (num[num.length-1-i] !== '0' || num[num.length-1-i-1] !== '0' || num[num.length-1-i-2] !== '0' || num[num.length-1-i-3] !== '0')){
                    str += "조";
                }
                result = str + result;
            }
            if(num != 0)
                result = result + "";
            return minus + result ;
        }

        /*
        * toStringByFormatting(new Date()) == 2023-01-01
        * toStringByFormatting(new Date(), ".") == 2023.01.01
        * toStringByFormatting(new Date(), "/") == 2023/01/01
        * */
        function toStringByFormatting(source, delimiter = '-'){
            var year = source.getFullYear();
            var month = leftPad(source.getMonth() + 1);
            var day = leftPad(source.getDate());
            return [year, month, day].join(delimiter);
        }

        function leftPad(value){
            if(String(value) >= 10){
                return value;
            }
            return "0" + value;
        }

        $(function(){
            $(document).on("focusin", "input[data-role='datepicker']", function(e){
                $(this).attr("readonly", false);
            });

            $("input[data-role='datepicker']").bind({
                keyup : function(event){
                    var dateNumText = $.trim($(this).val()).replace(/[^0-9]/g,"");
                    var textLength = dateNumText.length;
                    if (textLength < 4) {
                        $(this).val(dateNumText);
                    } else {
                        if (textLength >= 4 && textLength < 6) {
                            $(this).val(dateNumText.substr(0, 4) + "-" + dateNumText.substr(4, dateNumText.length));
                        } else if (textLength >= 6) {
                            $(this).val(dateNumText.substr(0, 4) + "-" + dateNumText.substr(4, 2) + "-" + dateNumText.substr(6, 2));
                        }
                    }
                }
            })

        });
    </script>
</head>
<body>
<spt>

</spt>
<div class="talkNotice" style="display: none">
    <div class="closeNotice">x</div>
    <div class="talkBox"></div>
    <div class="talkName">농정원</div>
    <div class="talkContent">새로운 메시지가 도착했습니다.</div>
</div>
</body>
</html>