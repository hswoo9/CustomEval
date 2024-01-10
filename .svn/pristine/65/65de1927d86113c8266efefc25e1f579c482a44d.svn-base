var resAlphaG20 = {};

resAlphaG20.openResPop = function(outProcessInterfaceId, outProcessInterfaceMId, outProcessInterfaceDId){
	var data = {
        	outProcessId : "EXNPRESI",
        	type : outProcessInterfaceId || ""
        }
	$.ajax({
        type: "POST"
	    , dataType: "json"
	    , url: getContextPath()+ "/resAlphaG20/getFormInfo"
        , data: data
	    , success: function (obj) {
	    	if(!obj.formInfo){
	    		alert("문서정보를 찾을 수 없습니다.");
	    		return;
	    	}
	    	var formInfo = obj.formInfo;
	    	var intWidth = "1000";
	        var intHeight = screen.height - 100;
	        
	        if (formInfo.c_isurlwidth != "") {
	            intWidth = formInfo.c_isurlwidth;
	        }

	        if (formInfo.c_isurlheight != "") {
	            intHeight = eval(formInfo.c_isurlheight);
	        }
	        
	    	var intLeft = screen.width / 2 - intWidth / 2;
	        var intTop = screen.height / 2 - intHeight / 2 - 40;
	    	var target = "AppForm";
	    	var url = formInfo.apply_api;
    		if(outProcessInterfaceId){
    			url += "?outProcessInterfaceId=" + outProcessInterfaceId;
    			if(outProcessInterfaceMId){
    				url += "&outProcessInterfaceMId=" + outProcessInterfaceMId;
    				if(outProcessInterfaceDId){
    					url += "&outProcessInterfaceDId=" + outProcessInterfaceDId;
    				}
    			}
    		}
	    	var connector = (url.indexOf("?") < 0 ? "?" : "&");
	    	url += connector + "form_id=" + formInfo.c_tikeycode + "&form_tp=" + formInfo.form_d_tp + "&processId=" + formInfo.form_d_tp + "&doc_width=" + formInfo.c_isurlwidth + "&eaType=ea&form_gb="+ formInfo.c_tiformgb+ "&initTitle=";
	    	window.open(url, target, 'menubar=0,resizable=1,scrollbars=1,status=no,toolbar=no,width=' + intWidth + ',height=' + intHeight + ',left=' + intLeft + ',top=' + intTop );
	    }
	    , error: function(obj){
	    	alert("문서정보를 찾을 수 없습니다.");
	    }
    });
};
