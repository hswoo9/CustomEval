<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="/WEB-INF/views/templates/common.jsp" flush="true"></jsp:include>
<style>
    .k-clear-value {display: none;}
    .k-dropzone {
        width: 98px;
        margin-left: auto;
    }
    .k-action-buttons {
        display : none !important;
    }
    .k-radio-list-horizontal, .k-radio-list.k-list-horizontal{
        gap: 0;
    }
    .k-input-md .k-input-inner, .k-picker-md .k-input-inner{
        padding : 2px 8px !important;
    }
    #userTable tr:hover{
        background-color: #0a80c5;
        cursor: pointer;
    }
    .dataInputNumber{
        text-align: right;
    }

    .divBackGroup{
        background-color : #0a80c5 !important;
    }

    .loadingDiv{
        display: none;
        position: absolute;
        top: 0%;
        left: 0%;
        width: 100%;
        height: 100%;
        background: #666666 ;
        z-index:1001;
        -moz-opacity: 0.8;
        opacity:.80;
        filter: alpha(opacity=60);
    }

    .loadingImg{
        display: none;
        position: absolute;
        padding: 16px;
        z-index:1002;
        overflow: auto;
    }

    .cardClass{
        background-color: #d3d3d37d !important;
    }

    .file-icon {
        display: inline-block;
        float: left;
        width: 48px;
        height: 48px;
        margin-left: 10px;
    }

    .img-file {
        background-image: url('/resources/images/ico/file_ico/jpg_Icon.png');
        background-size:35px 35px;
        width: 35px;
        height: 35px;
    }
    .doc-file { background-image: url('/resources/images/ico/file_ico/doc_Icon.png');
        background-size:35px 35px;
        width: 35px;
        height: 35px;
    }
    .pdf-file { background-image: url('/resources/images/ico/file_ico/pdf_Icon.png');
        background-size:35px 35px;
        width: 35px;
        height: 35px;
    }
    .xls-file{
        background-image: url('/resources/images/ico/file_ico/xls_Icon.png');
        background-size:35px 35px;
        width: 35px;
        height: 35px;
    }
    .zip-file { background-image: url('/resources/images/ico/file_ico/zip_Icon.png');
        background-size:35px 35px;
        width: 35px;
        height: 35px;
    }
    .default-file { background-image: url('/resources/images/ico/file_ico/default_Icon.png');
        background-size:35px 35px;
        width: 35px;
        height: 35px;
    }

    .file-heading {
        font-family: Arial;
        font-size: 0.9em;
        display: inline-block;
        float: left;
        width: 88%;
        margin: 0 0 0 20px;
        height: 20px;
        -ms-text-overflow: ellipsis;
        -o-text-overflow: ellipsis;
        text-overflow: ellipsis;
        overflow:hidden;
        white-space:nowrap;
    }

    .file-name-heading {
        font-weight: bold;
        margin-top : 7px;
        cursor: pointer;
    }

    .file-size-heading {
        font-weight: normal;
        font-size: 5px;
    }

    li.k-file div.file-wrapper {
        position: relative;
        height: 50px;
        width: 100%;
    }

    .k-dropzone {
        width: 98px;
        margin-left: auto;
    }

    .k-toolbar {
        justify-content: end;
    }
</style>
<body>
<input type="hidden" id="tableKey" name="tableKey" value="${tableKey}">
<div class="card">
    <div class="card-header" id="cardGridResultView" style="padding:20px 0;">
        <div class="col-lg-11" style="margin:0 auto;">
            <div class="card-header">
                <h3 class="card-title" style="font-size:18px;" id="mainView">평가리스트</h3>
            </div>
            <table class="table table-bordered" style="margin-bottom: 5px">
                <tr>
                    <th class="text-center th-color">평가년도</th>
                    <td>
                        <input type="text" id="startDay" style="width: 25%;">
                        ~
                        <input type="text" id="endDay" style="width: 25%;">
                        <button type="button" class="k-button k-button-solid-light" onclick="evalSearchListPopup.fn_gridReload();" style="margin-left: 36%;">
                            <span class="k-icon k-i-search k-button-icon"></span>
                            <span class="k-button-text">조회</span>
                        </button>
                    </td>
                </tr>
            </table>
            <div class="table-responsive">
                <div id="mainGrid"></div>
            </div>
        </div>
    </div>
</div>
    <jsp:useBean id="today" class="java.util.Date" />
        <script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/loginPage/evalSearchListPopup.js?v=${today}"/></script>
    <script>
        var _g_contextPath_ = "${pageContext.request.contextPath}";
        $(document).ready(function() {
            evalSearchListPopup.fn_defaultScript();
        });


        $("#startDay").kendoDatePicker({
            depth: "month",
            start: "month",
            culture : "ko-KR",
            format : "yyyy-MM-dd",
            value : new Date().getFullYear() + "-01-01",
            change : function(){
                var sDt;
                var nDt;
                sDt = new Date($("#startDay").val());
                nDt = new Date($("#endDay").val());
                if(sDt > nDt){
                    $("#endDay").val($("#startDay").val());
                }
            }
        });

        $("#endDay").kendoDatePicker({
            depth: "month",
            start: "month",
            culture : "ko-KR",
            format : "yyyy-MM-dd",
            value : new Date(), // 현재 날짜로 설정
            change : function(){
                var sDt;
                var nDt;
                sDt = new Date($("#startDay").val());
                nDt = new Date($("#endDay").val());
                if(sDt > nDt){
                    $("#startDay").val($("#endDay").val());
                }
            }
        });
    </script>
</body>
