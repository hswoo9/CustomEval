function getTemplate(code){
	/*
	ST_FRM_MST 양식테이블	9:방문보고서
	*/
	var url = "<c:url value='/kpc/report/getTemplateInfo' />";
	var data = {};
	data.frm_mst_id = code;
	$.ajax({                
        url: url,
        type:"post",
        datatype:"json",
        data: data,
        async : true,
        success:function(data){                     
            if(data){  
            	
            }
        },
        error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        }
    });
}