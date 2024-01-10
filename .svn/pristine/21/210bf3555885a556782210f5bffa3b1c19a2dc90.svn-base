<%--
  Created by IntelliJ IDEA.
  User: user
  Date: 2023-02-06
  Time: 오후 6:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">
    <title>서명</title>
    <script type="text/javascript" src="<c:url value='/resources/js/jquery-3.4.1.min.js'/>"></script>
    <style>
        #canvas {
            width: 300px;
            height: 240px;
            border: 1px solid black;
        }
    </style>
</head>
<body>
<!-- 서명 공간 -->

<div class="container">
    <h3>전자서명 작성</h3>
    <canvas id="canvas" width="1920" height="1080"></canvas>
</div>
<div style="text-align: right">
    <button id="remove" style="margin-top: 15px;">지우기</button>
    <button id="save" style="margin-top: 15px;">저장</button>
</div>

<script>
    (function(obj){
        obj.init();
        $(obj.onLoad);
    })((function(){
        var canvas = $("#canvas");
        var div = canvas.parent("div");
        // 캔버스의 오브젝트를 가져옵니다.
        var ctx = canvas[0].getContext("2d");
        var drawble = false;

        $("#remove").on("click", function(){
            ctx.clearRect(0, 0, canvas[0].width, canvas[0].height);
        });

        // 이제 html 버그인지는 모르겠는데 canvas의 style의 height와 width를 수정하게 되면 그림이 이상하게 그려집니다.
        function canvasResize(){
            canvas[0].height = div.height();
            canvas[0].width = div.width();
        }
        // pc에서 서명을 할 경우 사용되는 이벤트입니다.
        function draw(e){
            function getPosition(){
                return {
                    X: e.pageX - canvas[0].offsetLeft,
                    Y: e.pageY - canvas[0].offsetTop
                }
            }
            switch(e.type){
                case "mousedown":{
                    drawble = true;
                    ctx.beginPath();
                    ctx.moveTo(getPosition().X, getPosition().Y);
                }
                    break;
                case "mousemove":{
                    if(drawble){
                        ctx.lineTo(getPosition().X, getPosition().Y);
                        ctx.stroke();
                    }
                }
                    break;
                case "mouseup":
                case "mouseout":{
                    drawble = false;
                    ctx.closePath();
                }
                    break;
            }
        }
        // 스마트 폰에서 서명을 할 경우 사용되는 이벤트입니다.
        function touchdraw(e){
            function getPosition(){
                return {
                    X: e.changedTouches[0].pageX - canvas[0].offsetLeft,
                    Y: e.changedTouches[0].pageY - canvas[0].offsetTop
                }
            }
            switch(e.type){
                case "touchstart":{
                    drawble = true;
                    ctx.beginPath();
                    ctx.moveTo(getPosition().X, getPosition().Y);
                }
                    break;
                case "touchmove":{
                    if(drawble){
                        // 스크롤 이동등 이벤트 중지..
                        e.preventDefault();
                        ctx.lineTo(getPosition().X, getPosition().Y);
                        ctx.stroke();
                    }
                }
                    break;
                case "touchend":
                case "touchcancel":{
                    drawble = false;
                    ctx.closePath();
                }
                    break;
            }
        }
        // 참고로 mousedown은 touchstart와 mousemove는 touchmove, mouseup은 touchend와 같습니다.
        // mouseout와 touchcancel은 서로 다른 동작인데, mouseout은 canvas 화면을 벗어났을 때이고 touchcancel는 모바일에서 터치가 취소, 즉 에러가 났을 때 입니다.
        return {
            init: function(){
                // 캔버스 사이즈 조절
                $(window).on("resize", canvasResize);

                canvas.on("mousedown", draw);
                canvas.on("mousemove", draw);
                canvas.on("mouseup", draw);
                canvas.on("mouseout", draw);
                // 스마트 폰의 터치 이벤트
                canvas.on("touchstart", touchdraw);
                canvas.on("touchend", touchdraw);
                canvas.on("touchcancel", touchdraw);
                canvas.on("touchmove", touchdraw);

                $("#save").on("click", function(){
                    var $canvas = document.getElementById('canvas');
                    var imgDataUrl = $canvas.toDataURL('image/png');
                    imgDataUrl = imgDataUrl.replaceAll('data:image/png;base64,', '');

                    var formdata = new FormData();	// formData 생성
                    formdata.append("sign", imgDataUrl);	// file data 추가
                    formdata.append("commissioner_seq", "${params.commissioner_seq}");	// user data 추가

                    $.ajax({
                        type : 'post',
                        url : "<c:url value='/eval/setSign'/>",
                        data : formdata,
                        dataType : "json",
                        processData : false,	// data 파라미터 강제 string 변환 방지!!
                        contentType : false,	// application/x-www-form-urlencoded; 방지!!
                        success : function (data) {
                            opener.parent.signFlag = true;
                            opener.parent.nextPageBtn();
                            window.close();
                        }
                    });

                });
            },
            onLoad: function(){
                // 캔버스 사이즈 조절
                canvasResize();
            }
        }
    })());
</script>
</body>
</html>