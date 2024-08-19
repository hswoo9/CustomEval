function linkageProcessOn(params, self){
	var form = $('#linkageProcessFormData');
	var url = "";
	if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1 || location.host.indexOf("heco") > -1){
		url  = "/approval/approvalDraftingPop.do";
	}else{
		url  = "/approval/approvalDraftingPop.do";
	}

	if(params.linkageType){
		if(params.linkageType == 2){
			form.prop("action", "/linkageProcessOn.do");
			setLinkageProcessDocInterlock(params);
		}
	}else{
		form.prop("action", "/linkageProcessOn.do");
		setLinkageProcessDocInterlock(params);
	}

	url = makeParams(params, form, url);
	url = url.replace("&", "?");

	if(self){
		location.href = url;
	}else{
		var pop = window.open(url, "viewer", "width=965, height=900, resizable=yes, scrollbars = yes, status=no, top=50, left=50", "newWindow");
		try {
			pop.focus();
		} catch(e){
			alert("팝업차단을 확인해주세요.");
		}
	}

}

function linkageProcessOnCustom(params, self){
	var form = $('#linkageProcessFormData');
	var url = "";
	if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1 || location.host.indexOf("heco") > -1){
		url  = "/approvalManagement/documentModifyPop.do";
	}else{
		url  = "/approvalManagement/documentModifyPop.do";
	}

	url = makeParams(params, form, url);
	url = url.replace("&", "?");

	if(self){
		location.href = url;
	}else{
		window.open(url, "viewer", "width=965, height=900, resizable=yes, scrollbars = yes, status=no, top=50, left=50", "newWindow");
	}

}

function makeParams(params, form, url){
	if(params.linkageProcessCode){
		var linkageProcessCode = $('<input type="hidden" name="linkageProcessCode"/>');
		linkageProcessCode.val(params.linkageProcessCode);
		form.append(linkageProcessCode);
		url += "&linkageProcessCode="+params.linkageProcessCode;
	}
	if(params.popType){
		var popType = $('<input type="hidden" name="popType"/>');
		popType.val(params.popType);
		form.append(popType);
		url += "&popType="+params.popType;
	}
	if(params.docType){
		var docType = $('<input type="hidden" name="docType"/>');
		docType.val(params.docType);
		form.append(docType);
		url += "&docType="+params.docType;
	}
	if(params.approKey){
		var approKey = $('<input type="hidden" name="approKey"/>');
		approKey.val(params.approKey);
		form.append(approKey);
		url += "&approKey="+params.approKey;
	}
	if(params.mod){
		var mod = $('<input type="hidden" name="mod"/>');
		mod.val(params.mod);
		form.append(mod);
		url += "&mod="+params.mod;
	}
	if(params.formId){
		var formId = $('<input type="hidden" name="formId"/>');
		formId.val(params.formId);
		form.append(formId);
		url += "&formId="+params.formId;
	}
	if(params.compSeq){
		var compSeq = $('<input type="hidden" name="compSeq"/>');
		compSeq.val(params.compSeq);
		form.append(compSeq);
		url += "&compSeq="+params.compSeq;
	}
	if(params.empSeq){
		var empSeq = $('<input type="hidden" name="empSeq"/>');
		empSeq.val(params.empSeq);
		form.append(empSeq);
		url += "&empSeq="+params.empSeq;
	}
	if(params.type){
		var type = $('<input type="hidden" name="type"/>');
		type.val(params.type);
		form.append(type);
		url += "&type="+params.type;
	}
	if(params.menuCd){
		var menuCd = $('<input type="hidden" name="menuCd"/>');
		menuCd.val(params.menuCd);
		form.append(menuCd);
		url += "&menuCd="+params.menuCd;
	}
	if(params.docId){
		var docId = $('<input type="hidden" name="docId"/>');
		docId.val(params.docId);
		form.append(docId);
		url += "&docId="+params.docId;
	}
	if(params.purcFormCode){
		var purcFormCode = $('<input type="hidden" name="purcFormCode"/>');
		purcFormCode.val(params.purcFormCode);
		form.append(purcFormCode);
		url += "&purcFormCode="+params.purcFormCode;
	}
	if(params.purcChangeFormCode){
		var purcChangeFormCode = $('<input type="hidden" name="purcChangeFormCode"/>');
		purcChangeFormCode.val(params.purcChangeFormCode);
		form.append(purcChangeFormCode);
		url += "&purcChangeFormCode="+params.purcChangeFormCode;
	}
	if(params.purcInspFormCode){
		var purcInspFormCode = $('<input type="hidden" name="purcInspFormCode"/>');
		purcInspFormCode.val(params.purcInspFormCode);
		form.append(purcInspFormCode);
		url += "&purcInspFormCode="+params.purcInspFormCode;
	}
	if(params.purcPayFormCode){
		var purcPayFormCode = $('<input type="hidden" name="purcPayFormCode"/>');
		purcPayFormCode.val(params.purcPayFormCode);
		form.append(purcPayFormCode);
		url += "&purcPayFormCode="+params.purcPayFormCode;
	}
	if(params.contentGroup){
		var contentGroup = $('<input type="hidden" name="contentGroup"/>');
		contentGroup.val(params.contentGroup);
		form.append(contentGroup);
		url += "&contentGroup="+params.contentGroup;
	}
	if(params.purcId){
		var purcId = $('<input type="hidden" name="purcId"/>');
		purcId.val(params.purcId);
		form.append(purcId);
		url += "&purcId="+params.purcId;
	}
	if(params.purcInspId){
		var purcInspId = $('<input type="hidden" name="purcInspId"/>');
		purcInspId.val(params.purcInspId);
		form.append(purcInspId);
		url += "&purcInspId="+params.purcInspId;
	}
	if(params.contentPlanId){
		var contentPlanId = $('<input type="hidden" name="contentPlanId"/>');
		contentPlanId.val(params.contentPlanId);
		form.append(contentPlanId);
		url += "&contentPlanId="+params.contentPlanId;
	}
	if(params.contentId){
		var contentId = $('<input type="hidden" name="contentId"/>');
		contentId.val(params.contentId);
		form.append(contentId);
		url += "&contentId="+params.contentId;
	}
	if(params.contentFileNo){
		var contentFileNo = $('<input type="hidden" name="contentFileNo"/>');
		contentFileNo.val(params.contentFileNo);
		form.append(contentFileNo);
		url += "&contentFileNo="+params.contentFileNo;
	}
	if(params.contentPrevValue){
		var contentPrevValue = $('<input type="hidden" name="contentPrevValue"/>');
		contentPrevValue.val(params.contentPrevValue);
		form.append(contentPrevValue);
		url += "&contentPrevValue="+params.contentPrevValue;
	}
	if(params.contentValue){
		var contentValue = $('<input type="hidden" name="contentValue"/>');
		contentValue.val(params.contentValue);
		form.append(contentValue);
		url += "&contentValue="+params.contentValue;
	}
	if(params.contentKey){
		var contentKey = $('<input type="hidden" name="contentKey"/>');
		contentKey.val(params.contentKey);
		form.append(contentKey);
		url += "&contentKey="+params.contentKey;
	}
	if(params.companionKey){
		var companionKey = $('<input type="hidden" name="companionKey"/>');
		companionKey.val(params.companionKey);
		form.append(companionKey);
		url += "&companionKey="+params.companionKey;
	}
	if(params.befUrl){
		var befUrl = $('<input type="hidden" name="befUrl"/>');
		befUrl.val(params.befUrl.replace(/&/gi, "shift6"));
		form.append(befUrl);
		url += "&befUrl="+params.befUrl.replace(/&/gi, "shift6");
	}
	if(params.linkageType){
		var linkageType = $('<input type="hidden" name="linkageType"/>');
		linkageType.val(params.linkageType.replace(/&/gi, "shift6"));
		form.append(linkageType);
		url += "&linkageType="+params.linkageType;
	}
    if(params.processId){
        var processId = $('<input type="hidden" name="processId"/>');
        processId.val(params.processId);
        form.append(processId);
        url += "&processId="+params.processId;
    }
    if(params.exnpType){
        var exnpType = $('<input type="hidden" name="exnpType"/>');
        exnpType.val(params.exnpType);
        form.append(exnpType);
        url += "&exnpType="+params.exnpType;
    }

	if(params.outProcessInterfaceId){
        var outProcessInterfaceId = $('<input type="hidden" name="outProcessInterfaceId"/>');
		outProcessInterfaceId.val(params.outProcessInterfaceId);
        form.append(outProcessInterfaceId);
        url += "&outProcessInterfaceId="+params.outProcessInterfaceId;
    }

	if(params.devKey){
		var devKey = $('<input type="hidden" name="devKey"/>');
		devKey.val(params.devKey);
		form.append(devKey);
		url += "&devKey="+params.devKey;
	}

	if(params.receiveTmplate){
		var receiveTmplate = $('<input type="hidden" name="receiveTmplate"/>');
		receiveTmplate.val(params.receiveTmplate);
		form.append(receiveTmplate);
		url += "&receiveTmplate="+params.receiveTmplate;
	}

	if(params.riFlag){
		var riFlag = $('<input type="hidden" name="riFlag"/>');
		riFlag.val(params.riFlag);
		form.append(riFlag);
		url += "&riFlag="+params.riFlag;
	}

	if(params.publicType){
		var publicType = $('<input type="hidden" name="publicType"/>');
		publicType.val(params.publicType);
		form.append(publicType);
		url += "&publicType="+params.publicType;
	}

	if(params.publicReason){
		var publicReason = $('<input type="hidden" name="publicReason"/>');
		publicReason.val(params.publicReason);
		form.append(publicReason);
		url += "&publicReason="+params.publicReason;
	}

	if(params.privateReason){
		var privateReason = $('<input type="hidden" name="privateReason"/>');
		privateReason.val(params.privateReason);
		form.append(privateReason);
		url += "&privateReason="+params.privateReason;
	}

	if(params.docMode){
		var docMode = $('<input type="hidden" name="docMode"/>');
		docMode.val(params.docMode);
		form.append(docMode);
		url += "&docMode="+params.docMode;
	}

	if(params.oneSystem){
		var oneSystem = $('<input type="hidden" name="oneSystem"/>');
		oneSystem.val(params.oneSystem);
		form.append(oneSystem);
		url += "&oneSystem="+params.oneSystem;
	}

	if(params.docTitleAuto){
		var docTitleAuto = $('<input type="hidden" name="docTitleAuto"/>');
		docTitleAuto.val(params.docTitleAuto);
		form.append(docTitleAuto);
		url += "&docTitleAuto="+params.docTitleAuto;
	}

	if(params.reApproval){
		var reApproval = $('<input type="hidden" name="reApproval"/>');
		reApproval.val(params.reApproval);
		form.append(reApproval);
		url += "&reApproval="+params.reApproval;
	}

	if(params.btnType){
		var btnType = $('<input type="hidden" name="btnType"/>');
		btnType.val(params.btnType);
		form.append(btnType);
		url += "&btnType="+params.btnType;
	}

	if(params.reApprovalFileNo){
		var reApprovalFileNo = $('<input type="hidden" name="reApprovalFileNo"/>');
		reApprovalFileNo.val(params.reApprovalFileNo);
		form.append(reApprovalFileNo);
		url += "&reApprovalFileNo="+params.reApprovalFileNo;
	}

	if(params.customField != null){
		var result = customKendo.fn_customAjax("/approval/getDocFormReqOpt.do", {formId : params.formId});
		var customField = "";
		if(result.flag){
			for(var i = 0; i < result.formRdRcCfList.formCustomFieldList.length; i++){
				customField = $('<input type="hidden" name="' + result.formRdRcCfList.formCustomFieldList[i].FIELD_NAME + '"/>');
				customField.val(params.customField[result.formRdRcCfList.formCustomFieldList[i].FIELD_NAME]);
				form.append(customField);
				url += "&" + result.formRdRcCfList.formCustomFieldList[i].FIELD_NAME + "=" +
					params.customField[result.formRdRcCfList.formCustomFieldList[i].FIELD_NAME];
			}
		}
	}

	if(params.referrerDocs != null){
		var saveData = {
			approKey : params.approKey,
			referrerDocs : JSON.stringify(params.referrerDocs)
		}

		customKendo.fn_customAjax("/linkageProcess/setReferencesDocTemp.do", saveData);
	}

	return url;
}

function setLinkageProcessDocInterlock(params){
	if(params.mod == "W" || params.mod == "RW"){
		var data = {};
		data.docId = params.docId;
		data.docTitle = params.docTitle;
		data.empSeq = params.empSeq;
		data.approKey = params.approKey;
		data.docContents = params.content;
        data.processId = params.processId;

		$.ajax({
			type : 'POST',
			async: false,
			url : '/linkageProcess/setLinkageProcessDocInterlock.do',
			data: data,
			dataType : 'json',
			success : function(data) {
				if(data.resultCode == "SUCCESS"){
					console.log("SUCCESS");
				}
			}
		});
	}
}

function approveDocView(docId, approKey, menuCd, deleteFlag, groupType){
	if(deleteFlag != null && deleteFlag == "Y"){
		alert("삭제된 문서는 열 수 없습니다.");
		return
	}

	if(menuCd == null){
		menuCd = $("#menuCd").val()
	}

	var mod = "V";
	var pop = "" ;
	var url = "";
	var width = "1000";
	var height = "950";
	if(groupType == null || groupType == "epis"){
		url = _g_contextPath_ + '/approval/approvalDocView.do?docId='+docId+'&menuCd=' + menuCd + '&mod=' + mod + '&approKey='+approKey;
	}else{
		url = _g_contextPath_ + '/approval/approvalOnnaraDocView.do?fileNo='+docId+ '&docId=' + $("#docId").val() + '&mod=' + mod;
		width = "1000";
		height = "950";
	}

	windowX = Math.ceil( (window.screen.width  - width) / 2 );
	windowY = Math.ceil( (window.screen.height - height) / 2 );
	console.log(url)
	pop = window.open(url, '결재 문서_' + docId, "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", resizable=NO, scrollbars=NO");
	//pop.focus();
}

function docApproveLineView(docId){
	var pop = "" ;
	var url = _g_contextPath_ + '/approval/approvalLineViewPop.do?docId='+docId+'&view=lineView';
	var width = "1200";
	var height = "355";
	windowX = Math.ceil( (window.screen.width  - width) / 2 );
	windowY = Math.ceil( (window.screen.height - height) / 2 );
	pop = window.open(url, '결재선 보기', "width=" + width + ", height=" + height + ", top="+ windowY +", left="+ windowX +", resizable=NO, scrollbars=NO");
}

function tempOrReDraftingPop(docId, menuCd, approKey, linkageType, type, self){
	console.log(docId);
	var rs = getDocInfo(docId);

	var approvalParams = {};
	approvalParams.linkageType = linkageType;

	approvalParams.mod = "RW";
	approvalParams.formId = rs.FORM_ID;
	approvalParams.compSeq = "1000";
	approvalParams.empSeq = rs.DRAFT_EMP_SEQ;
	approvalParams.content = rs.DOC_CONTENT;
	approvalParams.type = type;
	approvalParams.menuCd = menuCd;
	approvalParams.docType = "A";
	approvalParams.docId = rs.DOC_ID;

	if(linkageType == 2){
		approvalParams.linkageProcessCode = approKey.split("_")[0];
		approvalParams.approKey = approKey;
	}

	linkageProcessOn(approvalParams, self);
}

function getDocInfo(docId){
	var result;

	$.ajax({
		url : getContextPath()+"/approval/getDocInfo.do",
		data : {
			docId : docId
		},
		type : 'POST',
		dataType : "json",
		async : false,
		success : function (rs) {
			result           = rs.rs;

		}
	})

	return result;
}

function docApprovalRetrieve(docId, approKey, linkageType, type, callBack){
	if(approKey.indexOf("_") < 0 && linkageType == "2"){
		alert("시스템 연동키가 올바르지 않습니다.");
		return;
	}

	if(confirm("문서를 회수하시겠습니까?")){
		var flag = true;

		$.ajax({
			url : getContextPath()+"/approval/getDocInfo.do",
			data : {
				docId : docId
			},
			type : 'POST',
			dataType : "json",
			async : false,
			success : function (rs) {
				if(rs.rs.APPROVE_STAT_CODE == "100" || rs.rs.APPROVE_STAT_CODE == "101"){
					flag = false;
				}
			}
		})

		if(!flag){
			alert("이미 결재가 완료된 문서입니다.");
			return;
		}

		$.ajax({
			url : getContextPath()+"/approval/setApproveRetrieve.do",
			data : {
				linkageType : linkageType,
				linkageProcessCode : approKey.split("_")[0],
				docId : docId,
				approKey : approKey,
				empSeq : $("#empSeq").val(),
				approveEmpSeq : $("#empSeq").val(),
				cmCodeNm : type,
				type : type
			},
			type : 'POST',
			dataType : "json",
			async : false,
			success : function (){
				alert("문서가 회수되었습니다.");
				if(callBack != null){
					return callBack();
				}
			},
			error : function(){
				alert("문서가 회수 중 에러가 발생했습니다.");
				if(callBack != null){
					return callBack();
				}
			}
		})
	}
}
