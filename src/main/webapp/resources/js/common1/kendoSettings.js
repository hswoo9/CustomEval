/**
 * Kendo Setting
 * @type {{
 *         global: {},
 *         fn_textBox: customKendo.fn_textBox,
 *         fn_customAjax: (function(*, *): *),
 *         fn_dropDownList: customKendo.fn_dropDownList,
 *         fn_gridDataSource: (function(*, *): *),
 *         fn_gridDataSource2: (function(*, *): *),
 *         fn_datePicker: customKendo.fn_datePicker
 *        }}
 */
var customKendo = {

    global : {

    },

    /**
     * Custom KendoDataSource > Paging totalCount
     * @param url : url
     * @param params : parameters
     * @returns {*}
     */
    fn_gridDataSource : function(url, params){
        var dataSource = new kendo.data.DataSource({
            serverPaging: true,
            pageSize: 20,
            transport: {
                read : {
                    url : getContextPath() + url,
                    dataType : "json",
                    type : "post",
                    async : false
                },
                parameterMap: function(data, operation) {
                    for(var key in params){
                        data[key] = params[key];
                    }

                    return data;
                }
            },
            schema : {
                data: function (data) {
                    return data.list;
                },
                total: function (data) {
                    record = data.totalCount;

                    return record;
                },
            }
        });

        return dataSource;
    },

    /**
     * Custom KendoDataSource2 > Paging Length
     * @param url
     * @param params
     * @returns {*}
     */
    fn_gridDataSource2 : function(url, params, pageSize){
        var dataSource = new kendo.data.DataSource({
            serverPaging: false,
            pageSize: pageSize == null ? 20 : pageSize,
            transport: {
                read : {
                    url : getContextPath() + url,
                    dataType : "json",
                    type : "post",
                    async : false
                },
                parameterMap: function(data, operation) {
                    for(var key in params){
                        data[key] = params[key];
                    }

                    return data;
                }
            },
            schema : {
                data: function (data) {
                    return data.list;
                },
                total: function (data) {
                    return data.list.length;
                },
                error: function (data){
                    console.log(data);
                }
            },
        });

        return dataSource;
    },

    /**
     * Custom KendoDataSource2 > Paging Length
     * @param url
     * @param params
     * @returns {*}
     */
    fn_gridDataSource3 : function(url, params, pageSize){
        var dataSource = new kendo.data.DataSource({
            serverPaging: false,
            pageSize: pageSize == null ? 20 : pageSize,
            transport: {
                read : {
                    url : getContextPath() + url,
                    dataType : "json",
                    type : "post",
                    async : false
                },
                parameterMap: function(data, operation) {
                    for(var key in params){
                        data[key] = params[key];
                    }

                    return data;
                }
            },
            schema : {
                data: function (data) {
                    return data.rs;
                },
                total: function (data) {
                    return data.rs.length;
                },
            },
        });

        return dataSource;
    },

    /**
     * Custom kendoDatePicker
     * culture : ko-KR
     * @param id
     * @param opt
     * @param format
     * @param value
     */
    fn_datePicker : function (id, opt, format, value) {
        $("#" + id).kendoDatePicker({
            depth: opt,
            start: opt,
            culture : "ko-KR",
            format : format,
            value : value
        });
    },

    /**
     * Custom KendoTextBox
     * @param idArray[]
     */
    fn_textBox : function(idArray){
        for(var i = 0; i < idArray.length; i++){
            $("#"+idArray[i]).kendoTextBox();
        }
    },

    /**
     * Custom KendoDropDownList
     * @param id
     * @param dataSource
     * @param textField
     * @param valueField
     */
    fn_dropDownList : function (id, dataSource, textField, valueField){
        dataSource.unshift({[textField] : "선택", [valueField] : ""});

        $("#" + id).kendoDropDownList({
            dataSource : dataSource,
            dataTextField: textField,
            dataValueField: valueField
        });
    },

    /**
     * Custom Ajax
     * type : post
     * dataType : json
     * async : false
     * @param url
     * @param data
     * @returns {*}
     */
    fn_customAjax : function(url, data){
        var result;

        $.ajax({
            url : getContextPath() + url,
            data : data,
            type : "post",
            dataType : "json",
            async : false,
            success : function(rs) {
                result = rs;
                result.flag = true;
            },
            error :function (e) {
                result.flag = false;
                console.log('error : ', e);
            }
        });

        return result;
    },

    fn_customExcelDown : function(excelHeader, excelBody, fileName){
        var excelData = {
            excelHeader : JSON.stringify(excelHeader),
            excelBody : JSON.stringify(excelBody),
            fileName : fileName
        }

        customKendo.commonExcelDownFn(getContextPath() + "/common/excelDown.do", new URLSearchParams(excelData).toString())

    },

    commonExcelDownFn : function(excelUrl, urlParams){
        var maskHeight = $(document).height();
        var maskWidth  = $(document).width();
        var mask       = "<div id='mask' style='position:absolute; z-index:9999999999; background-color:#000000; display:none; left:0; top:0;'></div>";
        var loadingDiv       = "<div id=\"loadingImg\" style=\"display: none;\"></div>";
        var loadingImg = "<img src='/images/ajax-loader.gif' id='imgTag' style='display: block; margin: 0px auto;'/>";
        $('body').append(mask)
        $('body').append(loadingDiv)

        $('#loadingImg').css({
            "position": "absolute",
            "display": "block",
            "margin": "0px auto",
            "top": Math.max(0, (($(window).height() - $("#sub_top_menu_nav").outerHeight()) / 2) + $(window).scrollTop() - 100) + "px",
            "left": "50%",
            "z-index": "10000000000",
        });

        $('#mask').css({
            'width' : maskWidth,
            'height': maskHeight,
            'opacity' : '0.3'
        });
        $('#mask').show();
        $('#loadingImg').append(loadingImg);
        $('#loadingImg').show();

        var request = new XMLHttpRequest();
        request.open('POST', excelUrl, true);
        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');
        request.responseType = 'blob';
        request.onload = function(e) {
            $('#mask').remove();
            $('#loadingImg').remove();

            var filename = "";
            var disposition = request.getResponseHeader('Content-Disposition');
            if (disposition && disposition.indexOf('attachment') !== -1) {
                var filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
                var matches = filenameRegex.exec(disposition);
                if (matches != null && matches[1])
                    filename = decodeURI( matches[1].replace(/['"]/g, '') );
            }

            if (this.status === 200) {
                var blob = this.response;
                if(window.navigator.msSaveOrOpenBlob) {
                    window.navigator.msSaveBlob(blob, filename);
                }
                else{
                    var downloadLink = window.document.createElement('a');
                    var contentTypeHeader = request.getResponseHeader("Content-Type");
                    downloadLink.href = window.URL.createObjectURL(new Blob([blob], { type: contentTypeHeader }));
                    downloadLink.download = filename;
                    document.body.appendChild(downloadLink);
                    downloadLink.click();
                    document.body.removeChild(downloadLink);
                }
            }
        };

        request.send( urlParams);
    },

    /**
     * Custom Form Data Ajax
     * type : post
     * dataType : json
     * async : false
     * @param url
     * @param data
     * @returns {*}
     */
    fn_customFormDataAjax : function(url, data){
        var result;
        $.ajax({
            url : getContextPath() + url,
            data : data,
            type : "post",
            dataType : "json",
            contentType: false,
            processData: false,
            enctype : 'multipart/form-data',
            async : false,
            success : function(rs) {
                result = rs;
                result.flag = true;
            },
            error :function (e) {
                result.flag = false;
                console.log('error : ', e);
            }
        });

        return result;
    },

    /**
     * Custom KendoWindow
     * default :
     *  visible : false
     *  modal : true
     *  actions: ["close"]
     * @param id     : id
     * @param height : 높이
     * @param width  : 넓이
     * @param title  : 제목
     */
    fn_kendoWindow : function(id, height, width, title) {
        $("#" + id).kendoWindow({
            height: height + "px",
            width : width + "px",
            visible: false,
            title: title,
            modal : true,
            actions: ["Close"]
        }).data("kendoWindow").center();
    },

    /**
     * Custom kendoWindowClose function
     * @param id : id
     */
    fn_kendoWindowClose : function(id) {
        var dialog = $("#" + id).data("kendoWindow");
        dialog.close();
    },


    /**
     * custom kendoScheduler
     * @param id : id
     * @param dataSource : DataSource
     * @param editHtml : editorHtml
     * @param resources : resources
     */
    fn_kendoScheduler: function(id, dataSource, editHtml, resources) {
        kendo.culture("ko-KR");

        $("#" + id).kendoScheduler({
            date: new Date(),
            startTime: new Date(),
            height: 671,
            views: [
                "month"
            ],
            timezone: "Etc/UTC",
            dataSource: dataSource,
            selectable: false,
            editable : {
                template : editHtml,    // 에디터 template 설정
                destroy : false         // 에디터 close 시 항목 삭제 방지
            },
            edit : function(e){
                var buttonsContainer = e.container.find(".k-edit-buttons");

                buttonsContainer.remove(); // 에디터 하단 버튼 제거
                $(".k-window-title").html("연차 상세");
            },
            resources: resources
        });
    }


}