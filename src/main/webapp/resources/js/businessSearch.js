/**업체 찾기 - yh - 17.9.26
 * 버튼 businessSearchBtn class 로 호출 
 * return input tag class businessNmKor, businessNmEng 반환
 **/

$(function(){
	
	$('.iframe_wrap').append(businessHtml);
	
	$('#businessSearchPopup').kendoWindow({
	    width: "538px",
	    title: '업체 찾기',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$('.businessSearchBtn').on('click', function(){
		
		businessSearchPopup();
	});
	
	$('#businessSearchButton').on('click', function(){
		businessReloadFn();

	});
	
	$('#businessSearchPopupGrid').kendoGrid({
        dataSource: businessSearchPopupGridDataSource,
        height: 350,
        sortable: true,
        pageable: {
            refresh: true,
            pageSizes: true,
            buttonCount: 5
        },
        persistSelection: true,
        columns: [
        {
            field: "CMPY_NM",
            title: "업체명",
            width: 170,
        }, {
            field: "BSNS_NO",
            title: "사업자번호",
            width: 90,
        },{
            field: "RPST_NM",
            title: "대표자",
            width: 70,
        },{
            field: "CMPY_TEL",
            title: "전화",
            width: 90,
        },{
            title: "선택",
            template: businessSearchHtml
        }]
    }).data("kendoGrid");
	
	
});

function businessReloadFn(){
	$('#businessSearchPopupGrid').data('kendoGrid').dataSource.read();
}

function businessSearchPopup(){
	$('#businessSearchPopup').data("kendoWindow").open();
	
};

var businessSearchPopupGridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/common/businessSearch',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
			data.keyword = $('#businessSearchKeyword').val()
    	  	return data;
     	}
    },
    schema: {
      data: function(response) {
        return response.list;
      },
      total: function(response) {
	        return response.totalCount;
	      }
    }
    
});

function businessChoice(e){
	var row = $("#businessSearchPopupGrid").data("kendoGrid").dataItem($(e).closest("tr"));
	
	if($('#sub_1')[0] != null){
		$('#sub_1').val(row.MTRP_MST_UQ_ID);
		subCode('sub_2', $('#sub_1'));
		$('#sub_2').val(row.CTY_MST_UQ_ID);
		$('#ISP_TP').val(row.ISP_TP);
		$('#select1Ch').val(row.SPEC_CD);
		select1Ch($('#select1Ch'));
		$('#select2Ch').val(row.KAB_CD);
		select2Ch($('#select2Ch'));
		$('#select3Ch').val(row.KPC_QA_CD);
	}
	$('.businessNmKor').val(row.CMPY_NM);
	$('.businessNmEng').val(row.CMPY_NM_ENG);
	$('.CMPY_MST_ID').val(row.CMPY_MST_ID);
	$('#businessSearchPopup').data("kendoWindow").close();
	$('#businessSearchKeyword').val('');
}

function businessClose(){
	$('#businessSearchPopup').data("kendoWindow").close();
	$('#businessSearchKeyword').val('');
	
}



var businessHtml = 	'<div class="pop_wrap_dir" id="businessSearchPopup" style="width:538px; display: none;">'
	+'	<div class="pop_con">'
	+'	    <div class="top_box">'
	+'	        <dl>'
	+'	            <dt>업체명</dt>'
	+'	            <dd><input type="text" id="businessSearchKeyword" style="width:200px;" placeholder="" onkeydown="javascript:if(event.keyCode==13){businessReloadFn();}" /></dd>'
	+'	            <dd><input type="button" id="businessSearchButton" value="검색" /></dd>'
	+'	        </dl>'
	+'	    </div>'
	+'	    <div class="com_ta2 mt14" id="businessSearchPopupGrid">'
	+'	    </div>'
	+'	 </div>'
	+'	    <div class="pop_foot">'
	+'	        <div class="btn_cen pt12">'
	+'	            <input type="button" onclick="businessClose();" value="닫기" />'
	+'	        </div>'
	+'	    </div>'
	+'	</div>';

var businessSearchHtml = function(row){
	
	return '<div class="controll_btn cen p0"><button id="" onclick="businessChoice(this);">선택</button></div>';
}
	





