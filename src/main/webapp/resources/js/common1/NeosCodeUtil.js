/**
 *
 * @author Administrator
 *
 *
 *
 * @  수정일                 수정자            수정내용
 * @ ----------   --------    ---------------------------
 * @ 2012.12.18    김석환                    공통코드 Child 속성 추가함에 따라 child 코드만 별도로 불러오는 메서드 추가
 *
 *
 *
 */

NeosCodeUtil = {

	/**
	 * 코드 초기화
	 *
	 *
	 *
	 */
	codeReBuild : function( ) {


		try {
            $.ajax({
                type: "POST",
                url: getContextPath()+"/cmm/system/commonCodeReBuild.do",
                async: false,
                datatype: "text",
                success: function (data) {
                	if(data.errorCode == 0) {
                		alert(NeosUtil.getMessage("TX000011102","초기화 성공입니다"));
                	}else {
                		alert(NeosUtil.getMessage("TX000011101","초기화 실패입니다"));
                	}
                },
                error: function (XMLHttpRequest, textStatus) {alert(NeosUtil.getMessage("TX000011100","초기화 오류입니다"));}
            });
        }
        catch (e) {
        	alert(NeosUtil.getMessage("TX000011100","초기화 오류입니다"));
        }
	},
	/**
	 * 코드 이름 조회
	 * @param codeID 그룹코드ID
	 * @param code 코드ID
	 * @returns {String}
	 */
	getCodeName : function( codeID, code ) {
		var codeName = "" ;

		try {
            $.ajax({
                type: "POST",
                url: getContextPath()+"/cmm/system/commonCodeName.do",
                async: false,
                datatype: "text",
                data: ({ codeId: codeID, code: code }),
                success: function (data) {
                	codeName =  data.codeName;
                },
                error: function (XMLHttpRequest, textStatus) {

                }
            });
        }
        catch (e) {

        }
        return codeName ;
	},

	/**
	 * 코드 이름 조회(Child)
	 * @param codeID 그룹코드ID
	 * @param code 코드ID
	 * @returns {String}
	 */
	getChildCodeName : function( codeID, code ) {
		var codeName = "" ;

		try {
            $.ajax({
                type: "POST",
                url: getContextPath()+"/cmm/system/commonChildCodeName.do",
                async: false,
                datatype: "text",
                data: ({ codeId: codeID, code: code }),
                success: function (data) {
                	codeName =  data.codeName;
                },
                error: function (XMLHttpRequest, textStatus) {

                }
            });
        }
        catch (e) {

        }
        return codeName ;
	},

	/**
	 * 코드리스트 조회
	 * @param codeID 그룹코드ID
	 * @returns {String}
	 */
	getCodeList : function( codeID ) {
		var list = "" ;
		try {
	        $.ajax({
	            type: "POST",
	            url: "/cmm/system/commonCodeList.do",
	            async: false,
	            datatype: "json",
	            data: { codeID: codeID },
	            success: function (data) {
					console.log(data);
	            	list =  data.list;
	            },
	            error: function (XMLHttpRequest, textStatus) {
	            }
	        });
	    }
	    catch (e) {

	    }
    	return list ;
	},

	/**
	 * 코드리스트 조회(Child)
	 * @param codeID 그룹코드ID
	 * @returns {String}
	 */
	getChildCodeList : function( codeID ) {
		var list = "" ;
		try {
	        $.ajax({
	            type: "POST",
	            url: getContextPath()+"/cmm/system/commonChildCodeList.do",
	            async: false,
	            datatype: "text",
	            data: ({ codeID: codeID }),
	            success: function (data) {
	            	list =  data.list;
	            },
	            error: function (XMLHttpRequest, textStatus) {
	            }
	        });
	    }
	    catch (e) {

	    }
    	return list ;
	},


	/**
	 * 코드리스트 조회(Child) - 모든 리스트 불러오기
	 * @param codeID 그룹코드ID
	 * @returns {String}
	 */
	getChildCodeListAll : function(  ) {
		var list = "" ;
		try {
	        $.ajax({
	            type: "POST",
	            url: getContextPath()+"/cmm/system/commonChildCodeListAll.do",
	            async: false,
	            datatype: "text",
	            data: {},
	            success: function (data) {
	            	list =  data.list;
	            },
	            error: function (XMLHttpRequest, textStatus) {
	            }
	        });
	    }
	    catch (e) {

	    }
    	return list ;
	},

	/**
	 * 코드리스트를 조회했어 HTML 라디오 버튼을 생성
	 * @param codeID  그룹코드ID
	 * @param name  라디오버튼 이름,
	 * @param valueChecked checked할 codeID, FIRST 일경우 처음 라디오 버튼을 checked, 값이 없을경우는 chekced 안함.
	 * @param fncEvent 이벤트 이름
	 * @returns {String}
	 */
	getCodeRadio: function(codeID, name, checkedValue , fncEvent  ) {
		var list = this.getCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var checked = false ;
		var event = "" ;
		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onClick= '"+fncEvent+"'";
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		for(var inx = 0 ; inx < rowNum; inx++) {
			if(checkedValue == 'FIRST') {
				if(inx == 0 )  {
					checked = "checked" ;
				}
			}else {
				if( checkedValue == list[inx].CODE) {
					checked = "checked" ;
				}
			}
			html += "<input type= 'radio' class='k-radio'  name = '"+name+"' id = '"+name+(inx+1)+"' value = '"+list[inx].CODE+"' " + event+ " "  +checked+ " > <label for='"+name+(inx+1)+"' style='margin:0 0 0 10px; padding:0.2em 0 0 1.5em;' class='k-radio-label' >" + list[inx].CODE_NM +"</label>&nbsp;";
			checked = "" ;
		}
		return html ;
	},


	/**
	 * 코드리스트를 조회했어 HTML 라디오 버튼을 생성( Child)
	 * @param codeID  그룹코드ID
	 * @param name  라디오버튼 이름,
	 * @param valueChecked checked할 codeID, FIRST 일경우 처음 라디오 버튼을 checked, 값이 없을경우는 chekced 안함.
	 * @param fncEvent 이벤트 이름
	 * @returns {String}
	 */
	getChildCodeRadio: function(codeID, name, checkedValue , fncEvent  ) {
		var list = this.getChildCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var checked = false ;
		var event = "" ;
		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onClick= '"+fncEvent+"'";
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		for(var inx = 0 ; inx < rowNum; inx++) {
			if(checkedValue == 'FIRST') {
				if(inx == 0 )  {
					checked = "checked" ;
				}
			}else {
				if( checkedValue == list[inx].CODE) {
					checked = "checked" ;
				}
			}
			html += "<input type= 'radio' name = '"+name+"' id = '"+name+(inx+1)+"' value = '"+list[inx].CODE+"' " + event+ " "  +checked+ "> <label for='"+name+(inx+1)+"' >" + list[inx].CODE_NM +"</label>&nbsp;";
			checked = "" ;
		}
		return html ;
	},

	/**
	 *
	 * @param codeID
	 * @param name
	 * @param selectedValue
	 * @param style
	 * @param fncEvent
	 * @param firstName
	 * @param firstValue
	 * @returns" {String}
	 */
	getCodeSelectFirstName: function(codeID, name, selectedValue ,  style, fncEvent, firstName, firstValue, classValue ) {
		var list = this.getCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var selected = "" ;
		var event = "" ;
		var className = "" ;

		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onChange= \""+fncEvent+"\"";
		}

		if (style != "" && style != undefined ) {
			style = "style= '"+style+"'";
		}else {
			style = "" ;
		}

		if (classValue != "" && classValue != undefined ) {
			className = "class= '"+classValue+"'";
		}else {
			className = "" ;
		}

		if( firstValue == undefined ) {
			firstValue = "" ;
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		html += "<select name = '" + name + "' id = '"+name+"'  " + className + "  " +style + " "+ event+ " >";

		if(firstName != "" && firstName != undefined ) {
			html += "<option  value = '"+firstValue+"' >"+firstName+"</option>";
		}

		for(var inx = 0 ; inx < rowNum; inx++) {

			if( selectedValue == list[inx].CODE) {
				selected = "selected" ;
			}
			html += "<option  value = '"+list[inx].CODE+"' "+selected+" >" + list[inx].CODE_NM +"</option>";
			selected = "" ;
		}
		html += "</select>" ;
		return html ;
	},

	/**
	 *
	 * @param codeID
	 * @param name
	 * @param selectedValue
	 * @param style
	 * @param fncEvent
	 * @param firstName
	 * @param firstValue
	 * @returns {String}
	 */
	getChildCodeSelectFirstName: function(codeID, name, selectedValue ,  style, fncEvent, firstName, firstValue  ) {
		var list = this.getChildCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var selected = false ;
		var event = "" ;
		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onChange= \""+fncEvent+"\"";
		}

		if (style != "" && style != undefined ) {
			style = "style= '"+style+"'";
		}else {
			style = "" ;
		}

		if( firstValue == undefined ) {
			firstValue = "" ;
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		html += "<select name = '" + name + "' id = '"+name+"'  " +style + " "+ event+ " >";

		if(firstName != "" && firstName != undefined ) {
			html += "<option  value = '"+firstValue+"' >"+firstName+"</option>";
		}

		for(var inx = 0 ; inx < rowNum; inx++) {

			if( selectedValue == list[inx].CODE) {
				selected = "selected" ;
			}
			html += "<option  value = '"+list[inx].CODE+"' "+selected+" >" + list[inx].CODE_NM +"</option>";
			selected = "" ;
		}
		html += "</select>" ;
		return html ;
	},

	/**
	 *
	 * @param codeID
	 * @param name
	 * @param selectedValue
	 * @param style
	 * @param fncEvent
	 * @returns {String}
	 */
	getCodeSelect: function(codeID, name, selectedValue ,  style, fncEvent  ) {

		return this.getCodeSelectFirstName(codeID, name, selectedValue, style, fncEvent, "전:::체", "") ;
	},

	/**
	 *
	 * @param codeID
	 * @param name
	 * @param selectedValue
	 * @param style
	 * @param fncEvent
	 * @returns {String}
	 */
	getChildCodeSelect: function(codeID, name, selectedValue ,  style, fncEvent  ) {

		return this.getChildCodeSelectFirstName(codeID, name, selectedValue, style, fncEvent, "전:::체", "") ;
	},

	/**
	 * checkbox 를 생성
	 * @param codeID
	 * @param name
	 * @param valueChecked
	 * @param fncEvent
	 * @returns {String}
	 */
	getCodeCheck: function(codeID, name, valueChecked , fncEvent  ) {
		var list = this.getCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var checked = "" ;
		var event = "" ;

		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onChange= '"+fncEvent+"'";
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		for(var inx = 0 ; inx < rowNum; inx++) {
			if(valueChecked == 'FIRST') {
				if(inx == 0 )  {
					checked = "checked" ;
				}
			}else {
				if( valueChecked == list[inx].CODE) {
					checked = "checked" ;
				}
			}
			html += "<input type= 'checkbox' name = '"+name+"' id = '"+name+(inx+1)+"' value = '"+list[inx].CODE+"' " + event+ " "  +checked+ "> <label for='"+name+(inx+1)+"' >" + list[inx].CODE_NM +"</label>&nbsp;";
			checked = "" ;
		}
		return html ;
	},

	/**
	 * checkbox 를 생성(Child)
	 * @param codeID
	 * @param name
	 * @param valueChecked
	 * @param fncEvent
	 * @returns {String}
	 */
	getChildCodeCheck: function(codeID, name, valueChecked , fncEvent  ) {
		var list = this.getChildCodeList(codeID);
		var html = "" ;
		var rowNum = 0 ;
		var checked = "" ;
		var event = "" ;

		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onChange= '"+fncEvent+"'";
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		for(var inx = 0 ; inx < rowNum; inx++) {
			if(valueChecked == 'FIRST') {
				if(inx == 0 )  {
					checked = "checked" ;
				}
			}else {
				if( valueChecked == list[inx].CODE) {
					checked = "checked" ;
				}
			}
			html += "<input type= 'checkbox' name = '"+name+"' id = '"+name+(inx+1)+"' value = '"+list[inx].CODE+"' " + event+ " "  +checked+ "> <label for='"+name+(inx+1)+"' >" + list[inx].CODE_NM +"</label>&nbsp;";
			checked = "" ;
		}
		return html ;
	},

	/**
	 *  Add edward   공통 상세코드 등록시 코드ID 선택 박스 처리
	 * @see getCodeSelectFirstName()
	 * @param list  코드목록
	 * @param selectClCode 선택된 clCode
	 * @param name  select form name,id
	 * @param fncEvent  onclilk event name
	 *
	 */
	getCodeSelectList: function(list, name, selectClCode, fncEvent  ) {

		var html = "" ;
		var rowNum = 0 ;
		var event = "" ;
		if (fncEvent != "" && fncEvent != undefined ) {
			event = "onChange= '"+fncEvent+"'";
		}

		if( list != "" && list != undefined) {
			rowNum = list.length ;
		}

		html += "<select name = '" + name + "' id = '"+name+"' "+ event+ " >";

		//codeDetailObj.clCodeObj = [{"rnum":2,"clCode":"APP","clCodeNm":"전자결재_공통코드","useAt":"Y"}]
		//codeDetailObj.codeIdObj = [{"rnum":1,"clCodeNm":"전자정부 프레임워크 공통서비스","codeId":"COM001","codeIdNm":"등록구분","useAt":"Y","clCode":"EFC"}]

		for(var inx = 0 ; inx < rowNum; inx++) {

			if(name=="clCode"){  // 공통 상세코드
				html += "<option  value = '"+list[inx].clCode+"'>" + list[inx].clCodeNm +"</option>";
			}else if(name=="codeId"){  //   공통 상세 코드
				if( selectClCode == list[inx].clCode) {// 선택된 clCode 만 보인다.
					html += "<option  value = '"+list[inx].codeId+"'>" + list[inx].codeIdNm+"</option>";
				}
			}else if(name=="restdeSeCode"){  // 휴일일자
				html += "<option  value = '"+list[inx].code+"'>" + list[inx].codeNm +"</option>";
			}
		}
		html += "</select>" ;

		return html ;
	},


	/**
	 *  Add 김석환
	 * @see getCodeSelectFirstName()
	 * @param list  코드목록
	 * @param id selectbox id
	 * @param text  selectbox text  항목
	 * @param val  selectbox value  항목
	 *
	 */
	getCodeSelectListCommon: function(list, id, val, text , all ) {

		var html = "" ;




		html += "<select name = '" + id + "' id = '"+id+"' >";
		if(all){
			html += "<option value='"+""+"'>"+NeosUtil.getMessage("TX000000862","전체")+"</option>";
		}

		for(var inx = 0 , max = list.length; inx < max; inx++) {

			html += "<option value='"+(list[inx][val] || "")+"'>"+(list[inx][text] || "")+"</option>";
		}
		html += "</select>" ;

		return html ;
	},
	
	/**
	 * 연차에서 적용가능한 날짜 조회
	 * @param codeID code
	 * @returns {String}
	 */
	getRequestCalNum : function(code_id,code ) {
		var result = "" ;
		try {
	        $.ajax({
	            type: "POST",
	            url: getContextPath()+"/neos/pims/workmanage/selectVacationCalcByOne.do",
	            async: false,
	            datatype: "json",
	            data :({ code_id: code_id, code:code}),
	           success: function (data) {
	            	result =  data.result;
	            },
	            error: function (XMLHttpRequest, textStatus) {
	            }
	        });
	    }
	    catch (e) {

	    }
	    if(result){
	    	return result.calcnum ;
	    }else return 0;
   	}
};