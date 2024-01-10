/**
 * 첨부파일 업로드
 * parmas :	targetTableName = 타켓테이블명
 * 				targetId = 타겟아이디
 * 				path = 저장경로
 * 				fileFormId = 파일폼아이디
 * return :		returnData
 */
function fnCommonFileUpload(targetTableName, targetId, path, fileForm){
	var returnData;
	var data = {
			targetTableName : targetTableName,
			targetId : targetId,
			path : path
	}
	$(fileForm).ajaxSubmit({
		url : _g_contextPath_ + "/commFile/commFileUpLoad",
		data : data,
		dataType : 'json',
		type : 'post',
		processData : false,
		contentType : false,
		async: false,
		success : function(result) {
			returnData = result.result.commFileList;
		},
		error : function(error) {
			console.log(error);
			console.log(error.status);
		}
	});
	return returnData;
}

function fnCommonFileDelete(attach_file_id){
	var saveObj = {};
	saveObj.attach_file_id = attach_file_id;
	var opt = {
    		url : _g_contextPath_ + "/common/fileDelete",
            async: false,
            data : saveObj,
            successFn : function(data){
            	
            }
            ,
            failFn : function (request,status,error) {
    	    	alert(NeosUtil.getMessage("TX000009901","오류가 발생하였습니다. 관리자에게 문의하세요")+".\n errorCode :"+request.responseText+"\n");
        	}
    };
	acUtil.ajax.call(opt);
}