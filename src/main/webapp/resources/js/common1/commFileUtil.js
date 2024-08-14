function fnCommonFileInit(id){
	var _input_btn = $('<input>', {type : 'button', id : id + '_input_btn', value : '파일 선택', style : ''});
	$('#' + id).append(_input_btn);
	
	_input_btn.on({
		click: function(){
			fnCommonFileBtnClick(id);
		}
	});
}

function fnCommonFileBtnClick(id){
	var _input_file = $('<input>', {type : 'file', class : id + '_input_file', name : 'file_name', style : 'display: none;'});
	_input_file.click();
	_input_file.on({
		change: function(){
			var _form = $('<form>', {class : id + '_form', enctype : 'multipart/form-data', style : 'display: block;'});
			_form.append(_input_file);
			var _span_text = $('<span>', {class : id + '_span_text', style : 'width: 90%; overflow : hidden; text-overflow : ellipsis; white-space : nowrap; display: inline-block; padding-top: 2px;', title : _input_file[0].files[0].name});
			_span_text.append('<img alt="" src="' + _g_contextPath_ + '/Images/ico/ico_clip02.png"> ');
			_span_text.append(_input_file[0].files[0].name);
			_form.append(_span_text);
			_form.append(' <a onclick="fnCommonFileFormDelete(this);" href="#n"><img alt="" src="' + _g_contextPath_ + '/Images/btn/btn_del_reply.gif" style="position:relative;top:-6px;"></a>');
			$('#' + id).append(_form);
		}
	});
}

function fnCommonFileFormDelete(obj){
	obj.closest('form').remove();
}

function fnCommonFileFormSave(id, targetTableName, targetId, path){
	var file_form = $('.' + id + '_form');
	$.each(file_form, function(){
		fnCommonFileUpload(targetTableName, targetId, path, this);
	});
}

/**
 * 첨부파일 업로드
 * parmas :	targetTableName = 타켓테이블명
 * 				targetId = 타겟아이디
 * 				path = 저장경로
 * 				fileFormId = 파일폼아이디
 * return :		returnData
 */
function fnCommonFileUpload(/*targetTableName,*/ targetId,/* path,*/ fileForm){
	var returnData;
	var data = {
			// targetTableName : targetTableName,
			// targetId : targetId,
			// path : path
		menuCd : $("#menuCd").val(),
		empSeq : $('#empSeq').val(),
		purcId : targetId,
		/** Update Table Name*/
		targetTableName : "V_PURC_INFO_TEMP"
	}
	$(fileForm).ajaxSubmit({
		url : getContextPath() + "/purc/setPurcInfoFileUpload.do",
		data : data,
		dataType : 'json',
		type : 'post',
		processData : false,
		contentType : false,
		async: false,
		success : function(result) {
			returnData = result.commFileList;
		},
		error : function(error) {
			console.log(error);
			console.log(error.status);
		}
	});
	return returnData;
}

function fnCommonFileDelete(attach_file_id){

	// var saveObj = {};
	// saveObj.attach_file_id = attach_file_id;
	// var opt = {
    // 		url : _g_contextPath_ + "/common/fileDelete",
    //         async: false,
    //         data : saveObj,
    //         successFn : function(data){
    //
    //         }
    //         ,
    //         failFn : function (request,status,error) {
    // 	    	alert("오류가 발생하였습니다. 관리자에게 문의하세요.\n errorCode :"+request.responseText+"\n");
    //     	}
    // };
	// acUtil.ajax.call(opt);
}