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
        var ctx = canvas[0].getContext("2d");
        var drawble = false;
        var drawing = []; // 그림 저장 배열

        // 지우기 버튼 클릭 시
        $("#remove").on("click", function(){
            ctx.clearRect(0, 0, canvas[0].width, canvas[0].height);
            drawing = []; // 그림 저장 배열 초기화
        });

        // 캔버스 사이즈 조정 함수
        function canvasResize(){
            canvas[0].height = div.height();
            canvas[0].width = div.width();
            redraw(); // 사이즈 조정 시 그림 다시 그리기
        }

        // 그림 다시 그리기 함수
        function redraw() {
            ctx.clearRect(0, 0, canvas[0].width, canvas[0].height);
            drawing.forEach(function(pos, index) {
                if (index === 0) {
                    ctx.beginPath();
                    ctx.moveTo(pos.X, pos.Y);
                } else {
                    ctx.lineTo(pos.X, pos.Y);
                    ctx.stroke();
                }
            });
            ctx.closePath();
        }

        // PC에서 서명을 그릴 경우 이벤트
        function draw(e){
            function getPosition(){
                return {
                    X: e.pageX - canvas[0].offsetLeft,
                    Y: e.pageY - canvas[0].offsetTop
                }
            }
            switch(e.type){
                case "mousedown":
                    drawble = true;
                    ctx.beginPath();
                    ctx.moveTo(getPosition().X, getPosition().Y);
                    drawing.push(getPosition());
                    break;
                case "mousemove":
                    if(drawble){
                        ctx.lineTo(getPosition().X, getPosition().Y);
                        ctx.stroke();
                        drawing.push(getPosition());
                    }
                    break;
                case "mouseup":
                case "mouseout":
                    drawble = false;
                    ctx.closePath();
                    break;
            }
        }

        // 스마트폰에서 서명을 그릴 경우 이벤트
        function touchdraw(e){
            function getPosition(){
                return {
                    X: e.changedTouches[0].pageX - canvas[0].offsetLeft,
                    Y: e.changedTouches[0].pageY - canvas[0].offsetTop
                }
            }
            switch(e.type){
                case "touchstart":
                    drawble = true;
                    ctx.beginPath();
                    ctx.moveTo(getPosition().X, getPosition().Y);
                    drawing.push(getPosition());
                    break;
                case "touchmove":
                    if(drawble){
                        e.preventDefault();
                        ctx.lineTo(getPosition().X, getPosition().Y);
                        ctx.stroke();
                        drawing.push(getPosition());
                    }
                    break;
                case "touchend":
                case "touchcancel":
                    drawble = false;
                    ctx.closePath();
                    break;
            }
        }

        return {
            init: function(){
                // 캔버스 사이즈 조절 이벤트
                $(window).on("resize", canvasResize);

                // PC 이벤트 등록
                canvas.on("mousedown", draw);
                canvas.on("mousemove", draw);
                canvas.on("mouseup", draw);
                canvas.on("mouseout", draw);

                // 모바일 이벤트 등록
                canvas.on("touchstart", touchdraw);
                canvas.on("touchmove", touchdraw);
                canvas.on("touchend", touchdraw);
                canvas.on("touchcancel", touchdraw);

                // 저장 버튼 클릭 시
                $("#save").on("click", function(){
                    var $canvas = document.getElementById('canvas');
                    var imgDataUrl = $canvas.toDataURL('image/png');
                    imgDataUrl = imgDataUrl.replaceAll('data:image/png;base64,', '');

                    var formdata = new FormData(); // formData 생성
                    formdata.append("sign", imgDataUrl); // file data 추가
                    formdata.append("commissioner_seq", "${params.commissioner_seq}"); // user data 추가

                    $.ajax({
                        type : 'post',
                        url : "<c:url value='/eval/setSign'/>",
                        data : formdata,
                        dataType : "json",
                        processData : false, // data 파라미터 강제 string 변환 방지!!
                        contentType : false, // application/x-www-form-urlencoded; 방지!!
                        success : function (data) {
                            opener.parent.signFlag = true;
                            opener.parent.nextPageBtn();
                            window.close();
                        }
                    });
                });
            },
            onLoad: function(){
                // 페이지 로드 시 캔버스 사이즈 조절
                canvasResize();
            }
        }
    })());
</script>
</body>
</html>
