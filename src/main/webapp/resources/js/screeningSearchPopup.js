/**심사원 검색*/

var vacation1, vacation2, ptype, teamId, teamCd;
var screeningSearchPopupGridDataSource = new kendo.data.DataSource({
	serverPaging: true,
	pageSize: 10,
    transport: { 
        read:  {
            url: '/kpc/common/screeningSearchPopupGridSearch',
            dataType: "json",
            type: 'post'
        },
      	parameterMap: function(data, operation) {
      		data.vacation1 = vacation1;
      		data.vacation2 = vacation2;
      		data.ISP_RQT_ID = $('#ISP_RQT_ID').val(); 
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

$(function(){
	
	$('#screeningSearchPopup').kendoWindow({
	    width: "1000px",
	    title: '심사원 검색',
	    visible: false,
	    modal : true,
	    actions: [
	        "Close"
	    ],
	}).data("kendoWindow").center();

});

function screeningSearchPopup(type, vac1, vac2, teamId, teamCd){
	vacation1 = vac1;
	vacation2 = vac2;
	ptype = type;
	teamCd = teamCd;
	teamId = teamId;
	
	$('#screeningSearchPopup').data("kendoWindow").open();
	
	if($("#screeningSearchPopupGrid").data("kendoGrid") == null){
		screeningSearchPopupGrid();
	}else{
		$("#screeningSearchPopupGrid").data("kendoGrid").destroy();
		screeningSearchPopupGrid();
	}
	
	
	
}

function screeningSearchPopupGrid(){
	
	$('#screeningSearchPopupGrid').kendoGrid({
        dataSource: screeningSearchPopupGridDataSource,
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
        	template : vacUser,
        	title: "이름",
        }, {
            field: "DEPT_NAME",
            title: "부서",
        },{
            field: "DP_NAME",
            title: "직위",
        },{
        	field: "JT",
        	title: "적격성",
        },{
        	field: "PRSN_DN_NM",
        	title: "구분",
        },{
        	field: "ATHR_CD",
        	title: "심사코드",
        },{
        	field: "SPEC_CD",
        	title: "심사규격",
        },{
        	field: "MD",
        	title: "MD",
        },{
            title: "선택",
            template: screeningSearchHtml
        }]
    }).data("kendoGrid");
	
}

var vacUser = function(row){
	return row.VAC == 'Y' ? row.EMP_NAME + '<span class="text_red">(휴무)</span>' : row.TM_MGR_YN != null && row.TM_MGR_YN == 'Y' ? row.EMP_NAME+ '(팀장)' : row.TM_MGR_YN != null && row.TM_MGR_YN == 'N' ? row.EMP_NAME+'(팀원)' : row.EMP_NAME  ; 
}


var screeningSearchHtml = function(row){
	if(row.VAC == 'N' && row.TM_MGR_YN == null){
		return '<div class="controll_btn cen p0"><button type="button" onclick="screeningSearchChoice(this);">선택</button></div>';
	}else{
		return '<div class="controll_btn cen p0"><button type="button">선택</button></div>';
	}
	
	
}

function screeningSearchPopupCancel(){
	$('#screeningSearchPopup').data("kendoWindow").close();
	
}

function screeningSearchChoice(e){
	var rowData = $('#screeningSearchPopupGrid').data("kendoGrid").dataItem($(e).closest("tr"));

	var data = {
		INS_PRSN_ID : rowData.INS_PRSN_ID, //심사원id
		TM_MGR_YN : ptype == 'a' ? 'Y' : 'N', //심장여부 'a'팀장
		RQST_RVW_ID : $('#RQST_RVW_ID').val() //신청검토서 번호
	}
	
	$.ajax({
		url: "/kpc/requestAdmin/stRqstTmSave",
		data : data,
		type : 'POST',
		success: function(result){
			tab3Grid();
			$('#screeningSearchPopup').data("kendoWindow").close();
		}
	});
	
	
}