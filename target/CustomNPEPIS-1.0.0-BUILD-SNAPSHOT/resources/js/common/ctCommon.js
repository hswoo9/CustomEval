




/** 
 * 파일 다운로드 나만~
 * */
var ctFileDownLoad = function(path, name){
	
	var data = {
			filePath : path,
			fileNm : name,
	}
	
	$.ajax({
		url : '/common/ctFileDownLoad',
		type : 'GET',
		data : data,
	}).success(function(data) {
		var downWin = window.open('','_self');
		downWin.location.href = '/common/ctFileDownLoad?filePath='+encodeURI(path)+'&fileNm='+name;
	});
	
}