function getObjFromString(gridData, str) {
	var target = str.split(".");
	var resultData = [];
	try {
		var flag = true;
		for (var i=0; i<target.length; i++) {
			if (flag) {
				
				resultData = gridData[target[i]];
					flag = false;
			} else {
				resultData = resultData[target[i]];
			}
		}
	} catch (e) {
		console.error(e);
	}
	finally {
		if (!resultData) {
			console.error("데이터  추출 실패");
			resultData = [];
		}
	}
	return resultData;
}
function getRemoteData(targetDivTagId) {
	var target = "#" + targetDivTagId;
	var gridOption = $(target).data('gridOption');
	var param = {};
	if(typeof gridOption.param == "function"){
		var returnParam = gridOption.param();
		for(var key in returnParam){
			param[key] = returnParam[key];
		}
		if (gridOption['pageable'] && gridOption['serverPaging']) {
			param['pageSize'] = gridOption.pageSize;
			param['pageNum'] = gridOption.pageNum;
		}
	}else{
		param = gridOption.param;
		if (gridOption['pageable'] && gridOption['serverPaging']) {
			param['pageSize'] = gridOption.pageSize;
			param['pageNum'] = gridOption.pageNum;
		}
	}

	$.ajax({
		url : gridOption.url,
		type : gridOption.type,
		dataType : "json",
		data : JSON.stringify(param),
		contentType : gridOption.contentType,
		async : false,
		success : function (e) {},
		complete : function (e) {}
	}).done(function (e) {
		var target = '#' + targetDivTagId;
		$(target).data('gridData', e);
		setGrid(targetDivTagId, e);
	});
}
function getUUID() {
	function makeUUID() {
		return ((1 + Math.random()) * 0x10000 | 0).toString(16).substring(1);
	}
	return makeUUID() + makeUUID() + makeUUID() + makeUUID();
}
function makeGrid(targetDivTagId, gridOption, pageNum, pageSize) {
	var setColgroup = function(){
		var html = '';
		if(gridOption.colgroup){
			var colgroup = gridOption.colgroup;
			html += '<colgroup>';
			for(var key in colgroup){
				html += '<col ' +colgroup[key] + '>';
			}
			html += '</colgroup>';
		}
		return html;
	}
	
	var target = '#' + targetDivTagId;
	if (gridOption['pageable']) {
		if (!pageNum) {
			pageNum = 1;
		}
		if (!pageSize) {
			pageSize = gridOption.pageSize;
		}
		gridOption['pageNum'] = pageNum;
		gridOption['pageSize'] = pageSize;
	}
	
	$(target).data('gridOption', gridOption);
	
	
	var columns = gridOption.columns;
	var htmlTag = '<table>';
	htmlTag += setColgroup();
	htmlTag += '<thead>'
	htmlTag += '<tr>';
	for (var key in columns) {
		columns[key]['data-msgrid-uuid'] = getUUID();
		if (columns[key].visible === false) {
			htmlTag += '<th class="hidden">';
		} else {
			var sortable = columns[key].sortable;
			if (!sortable) {
				sortable = false;
			}
			if (sortable) {
				htmlTag += '<th class="ac" onclick="sortEvent(this)" data-msgrid-uuid="' + columns[key]['data-msgrid-uuid'] + '">';
			} else {
				htmlTag += '<th class="ac">';
			}
		}
		if (columns[key].title === "" && columns[key].field === "msGridCheckBox") {
			
			htmlTag += '<input type="checkbox" id="' + targetDivTagId + '_allCheck" onclick="msGridAllCheck(this)" class="msGridNoneAction">';
			htmlTag += '<label for="'+targetDivTagId + '_allCheck" style="margin-left:-13px !important;"></label>';
//			htmlTag += '<label for="'+targetDivTagId + '_allCheck" ></label>';
		} else {
			if(columns[key].title && columns[key].field){
				htmlTag += columns[key].title !== "" ? columns[key].title : columns[key].field;
			}else if(columns[key].title && columns[key].template){
				htmlTag += columns[key].title;
			}
		}
		htmlTag += '</th>';
	}
	htmlTag += '</tr>';
	htmlTag += '</thead>';
	htmlTag += '<tbody>';
	htmlTag += '</tbody>';
	htmlTag += '</table>';
	if (gridOption['pageable']) {
		htmlTag += '<div class="gt_paging" id="' + targetDivTagId + '_pages" ></ div>';
	}
	$(target).html(htmlTag);
	if (gridOption.getType.toLowerCase() === 'remote') {
		getRemoteData(targetDivTagId);
	} else {
		setGrid(targetDivTagId, "");
	}
};
function pager(targetDivTagId, pageNum) {
	console.log(targetDivTagId);
	var target = '#' + targetDivTagId;
	var targetAllCheckId = "#" + targetDivTagId + "_allCheck";
	if ($(targetAllCheckId).length) {
		$(targetAllCheckId).prop('checked', false);
	}
	if ($(target).data('gridOption')) {
		if (pageNum) {
			$(target).data('gridOption').pageNum = pageNum;
		} else {
			$(target).data('gridOption').pageNum = 1;
		}
		var gridOption = $(target).data('gridOption');
		var gridData = $(target).data('gridData');
		var pageSize = $(target).data('gridOption').pageSize;
		var pageable = $(target).data('gridOption').pageable;
		var serverPaging = $(target).data('gridOption').serverPaging;
		if (pageable && serverPaging) {
			getRemoteData(targetDivTagId);
		} else {
			setGrid(targetDivTagId, gridData);
		}
	}
}
function setGrid(targetDivTagId, gridData) {
	var target = '#' + targetDivTagId;
	var gridOption = $(target).data('gridOption');
	var filter = gridOption['filter'];
	if(gridOption['pageable']) {
		var pageNum = gridOption.pageNum;
		var pageSize = gridOption.pageSize;
	}
	
	var columns = gridOption.columns;
	var data = [];
	var total = 0;
	if (gridOption.getType === "remote") {
		data = getObjFromString(gridData, gridOption.data);
		if (gridOption['serverPaging']) {
			total = getObjFromString(gridData, gridOption.total);
		} else {
			if(filter){
				data = msGridFilter(data, filter);
			}
			total = data.length;
		}
	} else {
		if(gridData){
			data = gridData.data;
		}else{
			data = (function () {
				return eval(gridOption.data);
			})();
		}
		if(filter){
			data = msGridFilter(data, filter);
		}
		total = data.length;
	}
	
	for (var key in data) {
		data[key]['data-msgrid-uuid'] = getUUID();
	}
	$(target).data('gridViewData', data);
	var htmlTag = '';
	var startNum = 0;
	var limitNum = data.length;
	if (gridOption['pageable']) {
		if (!gridOption.serverPaging) {
			startNum = (pageNum - 1) * pageSize;
			limitNum = (pageNum * pageSize) < total ? (pageNum * pageSize) : total;
		}
		var pagesHtml = '<div class="paging">';
		var totalPage = total % pageSize == 0 ? Math.floor(total / pageSize) : Math.floor(total / pageSize) + 1;
		var pageNum = gridOption.pageNum;
		var startPage = 10 * Math.ceil(pageNum / 10) - 9;
		var limitPage = startPage + 9 < totalPage ? startPage + 9 : totalPage;
		if (startPage > 1) {
			pagesHtml += '<span class="pre_pre" onclick=pager("' + targetDivTagId + '",1)><a href="javascript:void(0);">10페이지전</a></span>';
			pagesHtml += '<span class="pre" onclick=pager("' + targetDivTagId + '",' + (startPage - 10) + ')><a href="javascript:void(0);">이전</a></span>';
		}
		pagesHtml += '<ol>';
		for (var i = startPage; i <= limitPage; i++) {
			if (pageNum === i) {
				pagesHtml += '<li class="on">';
			} else {
				pagesHtml += '<li onclick=pager("' + targetDivTagId + '",' + i + ')>';
			}
			pagesHtml += '<a href="javascript:void(0);">'
			pagesHtml += i;
			pagesHtml += '</a>';
			pagesHtml += '</li>';
		}
		pagesHtml += '</ol>';
		if (limitPage < totalPage) {
			pagesHtml += '<span class="nex" onclick=pager("' + targetDivTagId + '",' + (limitPage + 1) + ')><a href="javascript:void(0);">다음</a></span>';
			f += '<span class="nex_nex" onclick=pager("' + targetDivTagId + '",' + totalPage + ')><a href="javascript:void(0);">10페이지다음</a></span>';
		}
		pagesHtml += '</div>';
		var pageSizes = gridOption.pageSizes;
		if (pageSizes) {
			pagesHtml += '<div class="gt_count" ><select id="' + targetDivTagId + '_pageSizesBox" onchange="pageSizeChange(this)">';
			for (var i = 0; i < pageSizes.length; i++) {
				if (pageSize === pageSizes[i]) {
					pagesHtml += '<option value="' + pageSizes[i] + '" selected>' + pageSizes[i] + '</option>';
				} else {
					pagesHtml += '<option value="' + pageSizes[i] + '">' + pageSizes[i] + '</option>';
				}
			}
			pagesHtml += '</select></div>';
			targetDivTagId
		}
		$("#" + targetDivTagId + "_pages").html(pagesHtml);
	}
	if(limitNum-startNum === 0){
		var colNum = 0;
		for(var key in columns){
			if(columns[key].visible !== false){
				colNum ++;
			}
		}
		htmlTag += '<tr><td colspan="'+colNum+'">';
		if(gridOption.emptyMsg){
			htmlTag += gridOption.emptyMsg;
		}else{
			htmlTag += "데이터가 존재하지 않습니다"
		}
		htmlTag += '</td></tr>';
	}
	for (var i = startNum; i < limitNum; i++) {
		htmlTag += "<tr data-msgrid-uuid='" + data[i]['data-msgrid-uuid'] + "'>";
		for (var key2 in columns) {
			if (columns[key2].visible === false) {
				htmlTag += '<td class="hidden">';
			} else {
				htmlTag += '<td>';
			}
			if (columns[key2].field === "msGridCheckBox") {
				var tmpUUID = getUUID();
				htmlTag += '<input type="checkbox" data-msgrid-uuid="' + data[i]['data-msgrid-uuid'] + '" id="'+tmpUUID+'" class="msGridNoneAction">';
				htmlTag += '<label for="'+tmpUUID+'" style="margin-left:-13px !important;"></label>';
			} else {
				if (columns[key2].template) {
					var str = columns[key2].template;
					if (typeof str === "function") {
						
						htmlTag += str(data[i]);
					} else {
						var strList = str.split('#');
						for(var key in strList){
							if(strList[key].indexOf('=')===0){
								var tmpStr = strList[key].substr(1);
								tmpStr = tmpStr.trim();
								var fnName = tmpStr.substring(0, tmpStr.indexOf('('));
								var param = tmpStr.substring(tmpStr.indexOf('(')+1,tmpStr.indexOf(')'));
								var fnParam = param === 'this' ? data[i] : data[i][param];
								
								if(window[fnName]){
									var fn = window[fnName];
									htmlTag += fn.call(null, fnParam);
								}else if(fnName === ""){
									htmlTag += data[i][tmpStr.trim()];
								}
							}else{
								
								htmlTag += strList[key];
							}
						}
						
					}
				} else {
					htmlTag += data[i][columns[key2].field];
				}
			}
			htmlTag += "</td>";
		}
		htmlTag += "</tr>";
	}
	$(target + ">table>tbody").html(htmlTag);
	$(target + " > table > tbody").on("click", function (e) {
		//var targetTag = $(e.target).parent();
		var targetTag = $(e.target).closest('tr');
		if(!$(targetTag).parent()[0]){
			return;
		}
		if ($(targetTag).parent()[0].tagName !== 'THEAD' && $(targetTag)[0].tagName === 'TR') {
			$(this).find('.on').removeClass("on");
			$(targetTag).addClass("on");
			var isMsGridCheckBox = $(e.target).closest('td').children().eq(0).hasClass('msGridNoneAction'); 
			var callbackFunc = $(target).data('gridOption').rowClickCallback;
			var targetUUID = $(targetTag).attr('data-msgrid-uuid');
			var targetData;
			var gridViewData = $(target).data("gridViewData");
			for (var key2 in gridViewData) {
				if (data[key2]['data-msgrid-uuid']) {
					if (gridViewData[key2]['data-msgrid-uuid'] === targetUUID) {
						targetData = gridViewData[key2];
						break;
					}
				}
			}
			if (callbackFunc && !isMsGridCheckBox) {
				(function () {
					callbackFunc(targetData);
					//var fn = window[callbackFunc];
					//fn.call(null, targetData);
				})();
			}
		}
	});
	
	$(target + " > table > tbody").on("dblclick", function (e) {
		//var targetTag = $(e.target).parent();
		var targetTag = $(e.target).closest('tr');
		if(!$(targetTag).parent()[0]){
			return;
		}
		if ($(targetTag).parent()[0].tagName !== 'THEAD' && $(targetTag)[0].tagName === 'TR') {
			$(this).find('.on').removeClass("on");
			$(targetTag).addClass("on");
			var isMsGridCheckBox = $(e.target).closest('td').children().eq(0).hasClass('msGridNoneAction'); 
			var callbackFunc = $(target).data('gridOption').rowDblClickCallback;
			var targetUUID = $(targetTag).attr('data-msgrid-uuid');
			var targetData;
			var gridViewData = $(target).data("gridViewData");
			for (var key2 in gridViewData) {
				if (data[key2]['data-msgrid-uuid']) {
					if (gridViewData[key2]['data-msgrid-uuid'] === targetUUID) {
						targetData = gridViewData[key2];
						break;
					}
				}
			}
			if (callbackFunc && !isMsGridCheckBox) {
				(function () {
					callbackFunc(targetData);
					//var fn = window[callbackFunc];
					//fn.call(null, targetData);
				})();
			}
		}
	});
}
function pageSizeChange(e) {
	var targetDivTagId = e.id.substring(e.id.lastIndexOf('_'), 0);
	var pageSize = $(e).find(":checked").val() * 1;
	var target = "#" + targetDivTagId;
	$(target).data('gridOption').pageSize = pageSize;
	pager(targetDivTagId);
}
function msGridFilter(originData, filter){
	var result = [];
	var len = originData.length;
	for(var i=0; i< len; i++){
		var isAddAble = true;
		for(var key in filter){
			if(filter[key] === ""){continue;}
			
			if(originData[i][key] != filter[key]){
				isAddAble = false;
			}
		}
		if(isAddAble){
			result.push(originData[i]);
		}
	}
	return result;
}
function msGridAllCheck(e) {
	var checked = e.checked;
	var targetDivTagId = e.id.substring(e.id.lastIndexOf("_"), 0);
	var target = "#" + targetDivTagId;
	var targetList = $(target).find("input:checkbox");
	for (var key in targetList) {
		targetList[key].checked = checked;
	}
}
function getSelectedData(targetDivTagId) {
	var targetTagId = "#"+targetDivTagId;
	var data = $(targetTagId).data('gridViewData');
	var targetTag = $(targetTagId).find(":input:checkbox:checked");
	resultData = [];
	for(var key in targetTag){
		if(targetTag[key].dataset){
			var targetUUID = $(targetTag[key]).attr('data-msgrid-uuid');
			for(var key2 in data){
				if(data[key2]['data-msgrid-uuid']){
					if(data[key2]['data-msgrid-uuid'] === targetUUID){
						resultData.push(data[key2]);
						break;
					}
				}
			}	
		}
	}
	return resultData;
}
function sortEvent(e) {
	var targetUUID = $(e).attr('data-msgrid-uuid');
	var target = $(e).closest('div');
	var targetDivTagId = $(target).attr('id');
	var gridOption = '';
	if ($(target).data('gridOption')) {
		gridOption = $(target).data('gridOption');
	} else {
		return false;
	}
	var targetColumnIdx = -1;
	for (var key in gridOption.columns) {
		if (gridOption.columns[key]['data-msgrid-uuid'] === targetUUID) {
			targetColumnIdx = key;
		}
	}
	var text = $(e).text();
	var field = gridOption.columns[targetColumnIdx].field;
	var dir = '';
	if (text.indexOf('↑') == -1 && text.indexOf('↓') == -1) {
		dir = 'asc';
		text += '↑';
	} else if (text.indexOf('↓') == -1) {
		dir = 'desc';
		text = text.substring(text.indexOf('↑'), 0);
		text += '↓';
	} else {
		dir = '';
		text = text.substring(text.indexOf('↓'), 0);
	}
	$(e).text(text);
	if (gridOption.param['sort']) {
		var sortParam = gridOption.param['sort'];
		var isParamExist = false;
		for (var key in sortParam) {
			if (sortParam[key].field === field) {
				sortParam[key].dir = dir;
				isParamExist = true;
				break;
			}
		}
		if (!isParamExist) {
			gridOption.param['sort'].push({
				field : field,
				dir : dir
			});
		}
	} else {
		gridOption.param['sort'] = [{
				field : field,
				dir : dir
			}
		];
	}
	if (!gridOption.serverPaging) {
		var gridData = $(target).data('gridData');
		var sortingTargetData = [];
		if (gridOption.getType === "remote") {
			sortingTargetData = getObjFromString(gridData, gridOption.data);
		} else {
			sortingTargetData = (function () {
				return eval(gridOption.data);
				;
			})();
		}
		sortingTargetData.sort(function (a, b) {
			return a[field] > b[field] ? 1 : -1;
		});
		if (dir === "desc") {
			sortingTargetData.reverse();
		} else if (dir === "") {
			var sortParam = gridOption.param['sort'];
			for (var key in sortParam) {
				if (sortParam[key].dir !== "") {
					sortingTargetData.sort(function (a, b) {
						return a[sortParam[key].field] > b[sortParam[key].field] ? 1 : -1;
					});
					if (sortParam[key].dir === "desc") {
						sortingTargetData.reverse();
					}
				}
			}
		}
	}
	pager(targetDivTagId, gridOption.pageNum);
}
