/**
 * 
 *
 * 
 */
var acUtil = {};

call_servlet = function(extendObj){
	console.log("call_servlet");
	console.log(extendObj);
	this.call = function(){ 
		var stateFn = this.stateFn;
		stateFn(true);
		var successFn = this.successFn;
		var failFn = this.failFn;
		$.ajax({
			type:"post",
			url: _g_contextPath_+"/kukgoh/transactionTest",
			datatype: this.datatype,
			data: this.data,
			contentType: "application/x-www-form-urlencoded; charset=UTF-8", 
			async: true,
			timeout : 2000,
			success:function(data){
				console.log("success");
			},
			error:function(e){
				console.log("fail");

			}
		});	
	};
};


function getSendParam(dataSource){
	var dataArray = new Array;
	
	for(var i = 0; i<dataSource.length; i++){
		var data = dataSource[i];
		var param = {
				  CO_CD : $('#CO_CD').val(),
				  GISU_DT : $('#gisuDt').val().replace(/\-/g,''),
				  GISU_SQ : $('#gisuSeq').val(),
				  BG_SQ : $('#BG_SQ').val(),
				  LN_SQ : data.LN_SQ,
				  APPLY_DIV : data.APPLY_DIV,
				  TRNSC_ID_TIME : $('#TRNSC_ID_TIME').val(),
				  TRNSC_ID : $('#TRNSC_ID').val(),
				  FILE_ID : data.FILE_ID,
				  CNTC_CREAT_DT:data.CNTC_CREAT_DT,
				  BSNSYEAR : data.BSNSYEAR,
				  DDTLBZ_ID : data.DDTLBZ_ID,
				  EXC_INSTT_ID : data.EXC_INSTT_ID,
				  EXCUT_TY_SE_CODE : data.EXCUT_TY_SE_CODE,
				  PRUF_SE_CODE : data.PRUF_SE_CODE,
				  PRUF_SE_NO : data.PRUF_SE_NO,			  
				  EXCUT_REQUST_DE : data.EXCUT_REQUST_DE.replace(/\-/g,''),
				  TRANSFR_ACNUT_SE_CODE : data.TRANSFR_ACNUT_SE_CODE,
				  SBSACNT_TRFRSN_CODE : data.SBSACNT_TRFRSN_CODE,
				  SBSACNT_TRFRSN_CN : data.SBSACNT_TRFRSN_CN,

				  BCNC_SE_CODE : data.BCNC_SE_CODE,
				  //BCNC_LSFT_NO : data.BCNC_LSFT_NO,
				  BCNC_LSFT_NO : getComorPin(data),
				  
				  BCNC_CMPNY_NM  : data.BCNC_CMPNY_NM,
				  BCNC_INDUTY_NM : data.BCNC_INDUTY_NM,
				  BCNC_BIZCND_NM : data.BCNC_BIZCND_NM,

				  BCNC_RPRSNTV_NM : data.BCNC_RPRSNTV_NM,
				  BCNC_TELNO : data.BCNC_TELNO,
				  BCNC_ADRES : data.BCNC_ADRES,
				  BCNC_BANK_CODE : data.BCNC_BANK_CODE,
				  BCNC_ACNUT_NO : data.BCNC_ACNUT_NO,
				  EXCUT_SPLPC : data.EXCUT_SPLPC,
				  EXCUT_VAT : data.EXCUT_VAT,
				  EXCUT_SUM_AMOUNT : data.EXCUT_SUM_AMOUNT,
				  EXCUT_PRPOS_CN : data.EXCUT_PRPOS_CN,
				  
				  BCNC_BNKB_INDICT_CN : data.BCNC_BNKB_INDICT_CN,			 
				  SBSIDY_BNKB_INDICT_CN : data.SBSIDY_BNKB_INDICT_CN,
				  PREPAR : data.PREPAR,
				  EXCUT_EXPITM_TAXITM_CNT : data.EXCUT_EXPITM_TAXITM_CNT,
				  ASSTN_TAXITM_CODE : data.ASSTN_TAXITM_CODE,
				  PRDLST_NM : data.PRDLST_NM,
				  EXCUT_TAXITM_CNTC_ID : data.EXCUT_TAXITM_CNTC_ID,
				  TAXITM_FNRSC_CNT : data.TAXITM_FNRSC_CNT,
				  FNRSC_SE_CODE : data.FNRSC_SE_CODE,
				  SUM_AMOUNT : data.SUM_AMOUNT,
				  SPLPC : data.SPLPC,
				  VAT : data.VAT,
				  INSERT_IP : '',
				  INSERT_ID : '',
				  OUT_TRNSC_ID : '',
				  OUT_CNTC_SN : '',
				  OUT_CNTC_CREAT_DT : '',
				  OUT_YN : '',
				  OUT_MSG : '',
				  targetId : "" + $('#gisuDt').val().replace(/\-/g,'') +  pad($('#gisuSeq').val(), 4) + ""+ pad(data.LN_SQ, 2)
		}
		dataArray.push(param);
	}
	return dataArray;
}
function getAttachGisuSeq(){
	return 
}
function getComorPin(data){
	if(data.BCNC_SE_CODE == '003'){
		return data.PIN_NO_1 + "" + data.PIN_NO_2+"000000";
	}else{
		return data.BCNC_LSFT_NO;
	}
}