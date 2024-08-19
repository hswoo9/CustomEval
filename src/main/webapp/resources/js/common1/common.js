function setKendoTextBox(params){
	for(var i = 0; i < params.length; i++){
		$("#"+params[i]).kendoTextBox();
	}
}
