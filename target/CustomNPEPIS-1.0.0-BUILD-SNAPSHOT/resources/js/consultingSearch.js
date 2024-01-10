/**컨설팅 업체 찾기 - yh - 17.9.26
 * 버튼 consultingSearchBtn class 로 호출 
 * return input tag class consultingNmKor, consultingNmEng 반환
 **/

$(function(){
	
	$('.iframe_wrap').append(consultingHtml);
	
	$('#consultingSearchPopup').kendoWindow({
	    width: "538px",
	    title: '컨설팅 업체선택',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();
	
	$('.consultingSearchBtn').on('click', function(){
		
		consultingSearchPopup();
	});
	
	$('#consultingSearchButton').on('click', function(){
		consultingReloadFn();

	});
	
	$('#consultingSearchPopupGrid').kendoGrid({
        dataSource: consultingSearchPopupGridDataSource,
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
            field: "CHG_NM",
            title: "담당자명",
            width: 90,
        },{
            field: "CHG_EMAIL",
            title: "이메일",
        },{
            title: "선택",
            template: consultingSearchHtml
        }]
    }).data("kendoGrid");
	
	
});

function consultingReloadFn(){
	$('#consultingSearchPopupGrid').data('kendoGrid').dataSource.read();
}

function consultingSearchPopup(){
	$('#consultingSearchPopup').data("kendoWindow").open();
	
};

var consultingSearchPopupGridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/common/consultingSearch',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
			data.keyword1 = $('#consultingSearchKeyword1').val();
			data.keyword2 = $('#consultingSearchKeyword2').val();
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

function consultingChoice(e){
	var data = $('#consultingSearchPopupGrid').data("kendoGrid").dataItem($(e).closest("tr"));
	$('.consultingCmpyNm').val(data.CMPY_NM);
	$('.consultingChgNm').val(data.CHG_NM);
	$('.consultingChgEmail').val(data.CHG_EMAIL);
	$('#CST_CHG_ID').val(data.CST_CHG_ID);
	$('#CST_CMPY_ID').val(data.CST_CMPY_ID);
	$('#consultingSearchPopup').data("kendoWindow").close();
}

function consultingClose(){
	$('#consultingSearchPopup').data("kendoWindow").close();
	$('#consultingSearchKeyword1').val('');
	$('#consultingSearchKeyword2').val('');
	
}



var consultingHtml = 	'<div class="pop_wrap_dir" id="consultingSearchPopup" style="width:538px; display: none;">'
	+'	<div class="pop_con">'
	+'	    <div class="top_box">'
	+'	        <dl>'
	+'	            <dt>업체명</dt>'
	+'	            <dd><input type="text" id="consultingSearchKeyword1" style="width:120px;" placeholder="" onkeydown="javascript:if(event.keyCode==13){consultingReloadFn();}" /></dd>'
	+'	            <dt>담당자명</dt>'
	+'	            <dd><input type="text" id="consultingSearchKeyword2" style="width:120px;" placeholder="" onkeydown="javascript:if(event.keyCode==13){consultingReloadFn();}" /></dd>'
	+'	            <dd><input type="button" id="consultingSearchButton" value="검색" /></dd>'
	+'	        </dl>'
	+'	    </div>'
	+'	    <div class="com_ta2 mt14" id="consultingSearchPopupGrid">'
	+'	    </div>'
	+'	 </div>'
	+'	    <div class="pop_foot">'
	+'	        <div class="btn_cen pt12">'
	+'	            <input type="button" onclick="consultingClose();" value="닫기" />'
	+'	        </div>'
	+'	    </div>'
	+'	</div>';

var consultingSearchHtml = function(){

	return '<div class="controll_btn cen p0"><button id="" onclick="consultingChoice(this);">선택</button></div>';
}
	





