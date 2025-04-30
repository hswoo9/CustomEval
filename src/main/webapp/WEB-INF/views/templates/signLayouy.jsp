<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="tiles"   uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="c"       uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring"  uri="http://www.springframework.org/tags"  %>



<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>${title}</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<!--Kendo ui css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.common-custom.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.dataviz.min.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.mobile.all.min.css' />">
    
    <!-- Theme -->
	<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/kendoui/kendo.silver.min.css' />" />
	
	<!--Kendo UI customize css-->
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/reKendo.css' />">
    

	<link rel="stylesheet" type="text/css" href="<c:url value='/resources/js/Scripts/jqueryui/jquery-ui.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/common.css'/>"/>
	
    <!--js-->
	<script type="text/javascript" src="<c:url value='/resources/js/Scripts/jquery-1.9.1.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/Scripts/jqueryui/jquery-ui.min.js'/>"></script> 

	<!--jsTree js-->
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/jquery.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/kendo.all.min.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/kendoui/cultures/kendo.culture.ko-KR.min.js'/>"></script>

	<script type="text/javascript" src="<c:url value='/resources/js/common/sweetalert.min.js'/>"></script>

	<script type="text/javascript" src="${hwpUrl}js/hwpctrlapp/utils/util.js"></script>
	<script type="text/javascript" src="${hwpUrl}js/webhwpctrl.js"></script>
	<script type="text/javascript" src="<c:url value='/resources/js/hancom/hwpCtrlApp.js'/>"></script>

</head>

<body>
<div class="sub_wrap">
<div class="sub_contents">
	<div class="iframe_wrap">

		<!-- 컨텐츠타이틀영역 -->
<!-- 		<div class="sub_title_wrap"> -->
			<div class="location_info">
				 <ul id="menuHistory"></ul> 
			</div>
			<div class="title_div">
				<h4></h4>
			</div>  
			<script>
			
			_g_serverName = "<%=request.getServerName()%>" ;
			_g_serverPort = "<%=request.getServerPort()%>" ;
			_g_contextPath_ = "${pageContext.request.contextPath}";

			$(document).ready(function() {
                if(location.host.indexOf("127.0.0.1") > -1 || location.host.indexOf("localhost") > -1 ||
	                location.host.indexOf("121.186.165.80") > -1 || location.host.indexOf("1.233.95.140") > -1){
                    _pHwpCtrl = BuildWebHwpCtrl("_pHwpCtrl", "http://218.158.231.42:8080/webhwpctrl/", function () {hwpView();});
                }else {
                    _pHwpCtrl = BuildWebHwpCtrl("_pHwpCtrl", "http://10.10.10.112:8080/webhwpctrl/", function () {hwpView();});
                }
				window.onresize();

                history.pushState(null, null, location.href);
                window.onpopstate = function (event) {
                    history.forward();
                };
			});

			window.onresize = function () {resize()};

            let stopCheckNotified = false;
            let pollCount = 0;

            const MAX_POLL_COUNT = 30;

            const intervalId = setInterval(function() {
                if (stopCheckNotified) return;

                if (pollCount >= MAX_POLL_COUNT) {
                    clearInterval(intervalId);
                    return;
                }

				pollCount++;

                fetch(_g_contextPath_ + '/eval/evalStopCheck', {
                    method: 'GET',
                    credentials: 'same-origin'
                })
                    .then(res => res.json())
                    .then(result => {
                        if (result === true) {
                            stopCheckNotified = true;

                            // 메시지 표시
                            customAlert("관리자에 의해 평가가 중단되었습니다.\n10초 후 로그인 페이지로 이동됩니다.", "warning");

                            // 10초 후 메인으로 이동
                            setTimeout(() => {
                                window.location.href = _g_contextPath_ + '/';
                            }, 10000);
                        }
                    })
                    .catch(err => console.error('중단 체크 오류', err));
            }, 30000);

			</script>
<!-- 		</div> -->
		
		<tiles:insertAttribute name="body" />
		
<script language="javascript">

	// sImageType :	0 - bmp
	//				1 - gif
	//				2 - jpg
	//				3 - png
	//				4 - tif
	var sImageType = 3;
	
	var PinCount = 0;
        /// connect 유무(0:disconnect, 1:connect)
	var conn     = 0;	
    /// sign 중 상태(0:서명중 아님, 1:서명중)
    var SignIng  = 0;

	function resize() {
		if (document.getElementById("hwpctrl_frame") != null && typeof(document.getElementById("hwpctrl_frame")) != "undefined") {
			var pHeight = (window.innerHeight - 20) + "px";
			document.getElementById("hwpctrl_frame").style.width = "100%";
			document.getElementById("hwpctrl_frame").style.height = pHeight;
		}
	}

	function sleep(ms)
	{
		var cur = new Date();
		var tgt = cur.getTime() + (ms)
		while (true)
		{
			cur = new Date();
			if (cur.getTime() > tgt) return;
		}
	}


	/// 연결
	/// 0) 성공 1) 서명기 인식 오류(모델 이상)  2) 서명패드 연결 상태를 확인 요망  3) 서명 패드에 이미 접속 중임
	function OnConnectDevice()
	{
		var nRtn = KM701.SetOpen();

		if ( nRtn == 0 )
		{
	// 		alert('연결 성공');
			conn = 1;

			OnSignStartAutoView1();
		}
		else if ( nRtn == 1 )
		{
			alert('서명기 인식 오류(모델 이상)');
					conn = 0;
		}
		else if ( nRtn == 2 )
		{
			alert('서명패드 연결 상태를 확인 요망');
			conn = 0;
		}
		else if ( nRtn == 3 )
		{
			alert('서명패드에 이미 연결 상태임');
			conn = 1;
		}
	}


	/*/// 연결끊기
	function OnDisconnectDevice()
	{
		KM701.SetClose();

		conn = 0;

	// 	alert('연결을 끊었습니다');
	}*/


	/// 서명 입력(실시간 Auto View)
	function OnSignStartAutoView1()
	{
		var nRtn;

		if	( conn == 1 )	// 연결 상태인 경우
		{
			KM701.SetLcdClean();
			KM701.SetLcdText(22, 2, "서명을 입력");
			KM701.SetLcdText(22, 5, "하여 주세요!");

			KM701.SetSignImagePath("C:\\SignData\\", "Temp", 4);

			//// 서명 시작
			nRtn = KM701.SetStartRealTimeSignAutoView(1, "감사 합니다!!");
			//// 0) 성공 1) 에러 2) 응답 없음 3) 이미 서명 진행 상태 4) 서명 패드와 접속 안된 상태
			if ( nRtn == 0 )
			{
	// 		   alert('요청 성공');
			}
			else if ( nRtn == 1 )
			{
			   alert('에러 발생');
			}
			else if( nRtn == 2 )
			{
			   alert('응답 없음');
			}
			else if( nRtn == 3 )
			{
			   alert('이미 서명 진행 상태임');
			}
			else if( nRtn == 4 )
			{
			   alert('서명 패드와 접속 안된 상태임');
			}
		}
		else      // 연결이 안 되어있는 경우
		{
			alert('연결 후 사용하십시오.');
		}
	}

	/// 이미지 파일을 Base64 인코딩한 문자열 얻기
	function OnGetBase64Image()
	{
		if	( conn == 1 )	// 연결 성공인 경우
		{
			imagebase64.value = "";
			imagebase64.value = KM701.GetBase64Image();	// 얻기 요청.
		}
		else
		{
			alert('연결 후 사용하십시오.');
		}
	}


	// 문자열 자르기
	function getStrCuts(str, max)
	{
		var ns = str.substr(0, max);
		if(ns.length != str.length)
		{
			ns = ns + "";
		}
		return ns;
	}

	<%--hwp 데이터 매핑 s--%>
	function inputAllData(){
		var jsonParam = JSON.parse(allParam);

		for (var key in jsonParam) {
			if(typeof jsonParam[key] == 'string'){
				console.log(key + " : " + jsonParam[key]);
				_hwpPutText(key, jsonParam[key], _pHwpCtrl );
			}
		}
	 }

	function _hwpOpen(url, format, type, name) {
		return _pHwpCtrl.Open(url, format, type,
				function (res) {
					console.log(res);
					_hwpPutData();
				},
				name);
	}

	function _hwpPutText(fieldName, val) {
		if(_pHwpCtrl.FieldExist(fieldName )) {
			_pHwpCtrl.MoveToField(fieldName, true, true, false);
			_pHwpCtrl.InsertBackgroundPicture("SelectedCellDelete", 0, 0, 0, 0, 0, 0, 0);
			_pHwpCtrl.PutFieldText(fieldName, val);
			if(_pHwpCtrl.FieldExist("toptitle" )) {
				_pHwpCtrl.MoveToField("toptitle", true, true, false);
			}
		}
	}

	function _hwpPutSignImg(fieldName, signPath){
		if(_pHwpCtrl.FieldExist(fieldName)){
			_pHwpCtrl.MoveToField(fieldName, true, true, false);
			_pHwpCtrl.InsertBackgroundPicture(
					"SelectedCell",
					signPath,
					1,
					5,
					0,
					0,
					0,
					100
			);
			if(_pHwpCtrl.FieldExist("toptitle" )) {
				_pHwpCtrl.MoveToField("toptitle", true, true, false);
			}
		}
	}

	function _hwpPutImage(fieldName, val) {
		if(_pHwpCtrl.FieldExist(fieldName)) {
			_pHwpCtrl.MoveToField(fieldName, true, true, false);
			_pHwpCtrl.Run("SelectAll");
			_pHwpCtrl.Run("Delete");
			_pHwpCtrl.PutFieldText(fieldName, " ");
			_pHwpCtrl.InsertBackgroundPicture("SelectedCell", val, 1, 6, 0, 0, 0, 0);
		}
	}

	 function ncCom_EmptyToString(argStr,conString){
		if ( conString == undefined )  conString = "" ;
		if(ncCom_Empty(argStr+"") || argStr == "null" || argStr == null ) {

		}else{
			conString = argStr ;
		}
		return conString ;
	 }

     function btnLoadingStart(){
         var $button = $('input[onclick="signSaveBtn();"]');
         var originalText = '처리중';  // 원본 텍스트 ("처리중...") 저장
         var dotCount = 1;  // 점의 초기 개수
         var loadingInterval = setInterval(function() {
             var dots = '.'.repeat(dotCount);  // 점을 dotCount 개수만큼 반복
             $button.val(originalText + dots);  // 버튼 텍스트 업데이트

             dotCount = (dotCount % 3) + 1;  // 점 개수를 1에서 3까지 반복

         }, 500);  // 0.5초 간격으로 점 추가
     }

    /*아이콘 종류
		   * success
		   * warning
		   * error
		   * info
		   * */

    function customAlert(msg, icon) {
        return swal({
            title: '',
            text: msg,
            type: '',
            icon: icon == '' ? 'success' : icon,
            closeOnClickOutside : false,
            button: '확인'
        })
    }

    function customConfirm(msg, icon) {
        return swal({
            title: '',
            text: msg,
            type: '',
            icon: icon == '' ? 'info' : icon,
            buttons: {
                agree: {
                    text : "예",
                    value : true
                },
                cancel: "아니요"
            },
            closeOnClickOutside : false
        })
    }
</script>



<SCRIPT language="JAVASCRIPT" for="KM701" event="EventSignButton(nCh)">   // 서명패드(서명입력) 버튼 이벤트
    // nCh 의 값을 체크하여 서명패드의 입력된 버튼을 확인.
    // nCh : 1(확인) 2(재입력, 정정)

    if	( nCh == 1 )  // 확인 버튼 클릭 시
    {
        //imagebase64.value = KM701.GetBase64Image();
        //서명란에 바로 이미지 등록
		setSign(KM701.GetBase64Image());
        //사인패드 컨넥 끊기
        //안하면 오류생김
    	OnDisconnectDevice();
    }
    else if( nCh == 2 ) 	// 정정 버튼 클릭 시
    {
    	alert('서명 정정');	
    }

</SCRIPT>

<SCRIPT language="JAVASCRIPT" for="KM701" event="EventPinpad(nType, sData)">		// 핀패드 입력시 해당 데이터값이 이벤트로 전달된다.
	// 핀패드 입력시 클릭 정보 이벤트 발생
	// nCh 설명 : 	1 - 숫자, * , # 버튼
	//				2 - 핀패드 확인 버튼
	//				3 - 핀패드 정정 버튼

	
	if ( nType == 1 )	// 숫자, * , # 입력 정보
	{
		readPin.value = readPin.value + sData; 
		PinCount++;	// 입력된 숫자 카운트 증가
	}
	else if( nType == 2 )	// 번호 입력 완료 버튼
	{
		alert('번호 입력을 완료하였습니다');
	}
	else if( nType == 3 ) 	// 번호 입력 정정 버튼
	{
		if ( PinCount > 0 )
		{
			readPin.value = getStrCuts(readPin.value, PinCount - 1);
			PinCount = PinCount - 1;	// 입력된 핀패드 카운트 감소
		}
	}
	
</SCRIPT>

<SCRIPT language="JAVASCRIPT" for="KM701" event="EventPadStatus(nCh)">
	if(nCh == 1)	// 서명패드 USB 연결 해제됨.
	{
		OnDisconnectDevice();	// 연결해제 이벤트 발생시 반드시 실행해야함.
		alert('USB 연결이 해제되었습니다');
		location.reload();
	}
	else if(nCh == 2)	// 서명패드 USB 재연결됨.
	{
		alert('USB 연결이 재연결 되었습니다');
	}
</SCRIPT>

<OBJECT ID="KM701" CLASSID="CLSID:B3EE583E-01F0-422F-8D8C-475D414FADF6" CODEBASE="/resource/activex/KM701OCX.cab#version=1,0,0,1" STYLE="WIDTH:10px; HEIGHT:10px;">
</OBJECT>
	
	</div><!-- //iframe wrap -->
</div>
</div>
<div id="loading_spinner">
	<div class="cv_spinner">
		<span class="spinner"></span>
	</div>
</div>
</body>
</html>