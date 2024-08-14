
function fnComboBoxInit(id, table_name, c_text, c_val, allYn, where, order){

    if($('#'+id)){
        var comboList = fnGetComboList(table_name, where, order);
        var jsonOp = {};
        jsonOp[c_text] = "전체"
        jsonOp[c_val] = ""

        if ( allYn == 'Y' ) {

            comboList.unshift(jsonOp);

        }
        var itemType = $("#" + id).kendoComboBox({
            dataSource : comboList,
            dataTextField: c_text,
            dataValueField: c_val,
            index: 0,
            change:function(){
                fnComboChange(id);
            }
        });
    }

    $(".k-input").attr("readonly", "readonly");
}

function fnGetComboList(table_name, wV, oV){

    var result = {};
    var params = {
        table :table_name
        ,where : wV
        ,order : oV

    };
    var opt = {
        url     : _g_contextPath_ + "/common/getComboList",
        async   : false,
        data    : params,
        successFn : function(data){
            result = data.comboList;
        }
    };
    acUtil.ajax.call(opt);
    return result;
}