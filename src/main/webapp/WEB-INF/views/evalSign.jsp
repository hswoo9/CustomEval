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
            width: 1180px;
            height: 240px;
            border: 1px solid black;
        }

        @media (pointer:coarse) {
            /* custom css for "touch targets" */
            .container, #subTitle {text-align: center;}

        }
    </style>
</head>
<body>
<!-- 서명 공간 -->

<div class="container">
    <h3>전자서명 작성</h3>
    <canvas id="canvas" width="1920" height="1080"></canvas>
</div>
<div id="subTitle">
    <span type="text" style="font-size: 10px;">위의 전자서명은 성명을 정자로 표기해주시고,<br>이번 평가에서만 사용됨을 알려드립니다.</span>
</div>
<div style="text-align: right">
    <button id="remove" style="margin-top: 15px;">지우기</button>
    <button id="save" style="margin-top: 15px;">저장</button>
</div>

<script>
    var thickness = 7;

    (function(obj){
        obj.init();
        $(obj.onLoad);
    })((function(){
        const canvas = $("#canvas");
        const div = canvas.parent("div");
        const ctx = canvas[0].getContext("2d");
        let drawble = false;
        let drawing = []; // 그림 저장 배열

        ctx.lineWidth = thickness;

        // 공통 위치 계산 함수
        function getPosition(e) {
            const rect = canvas[0].getBoundingClientRect();
            if (e.type.includes("touch")) {
                return {
                    X: e.changedTouches[0].pageX - rect.left,
                    Y: e.changedTouches[0].pageY - rect.top
                };
            } else {
                return {
                    X: e.pageX - rect.left,
                    Y: e.pageY - rect.top
                };
            }
        }

        // 지우기 버튼 클릭 시
        $("#remove").on("click", function() {
            ctx.clearRect(0, 0, canvas[0].width, canvas[0].height);
            drawing = []; // 그림 저장 배열 초기화

            drawDottedGuide();  // 점선 가이드 추가
        });

        // 캔버스 사이즈 조정 함수
        function canvasResize() {
            canvas[0].height = div.height();
            canvas[0].width = div.width();

            ctx.clearRect(0, 0, canvas[0].width, canvas[0].height);

            drawDottedGuide();  // 점선 가이드 추가
            redraw(); // 사이즈 조정 시 그림 다시 그리기
        }

        // 그림 다시 그리기 함수
        function redraw() {
            ctx.clearRect(0, 0, canvas[0].width, canvas[0].height);
            drawDottedGuide();  // 점선 가이드 추가

            drawing.forEach((pos, index) => {
                if (index === 0) {
                    ctx.beginPath();
                    ctx.moveTo(pos.X, pos.Y);
                    ctx.lineWidth = thickness;
                } else {
                    ctx.lineTo(pos.X, pos.Y);
                    ctx.lineWidth = thickness;
                    ctx.stroke();
                }
            });
            ctx.closePath();
        }

        // 그림 그리기 이벤트 핸들러
        function draw(e) {
            const pos = getPosition(e);
            switch (e.type) {
                case "mousedown":
                case "touchstart":
                    drawble = true;
                    ctx.beginPath();
                    ctx.moveTo(pos.X, pos.Y);
                    ctx.lineWidth = thickness;
                    drawing.push(pos);
                    break;
                case "mousemove":
                case "touchmove":
                    if (drawble) {
                        e.preventDefault(); // 터치 이동 시 스크롤 방지
                        ctx.lineTo(pos.X, pos.Y);
                        ctx.lineWidth = thickness;
                        ctx.stroke();
                        drawing.push(pos);
                    }
                    break;
                case "mouseup":
                case "mouseout":
                case "touchend":
                case "touchcancel":
                    drawble = false;
                    ctx.closePath();
                    break;
            }
        }

        function drawDottedGuide() {
            ctx.strokeStyle = "rgba(0, 0, 0, 0.5)"; // 점선 색 (연한 회색)
            ctx.lineWidth = 2;
            ctx.setLineDash([10, 5]); // 점선 스타일 (10px 선, 5px 공백)

            let padding = 20; // 점선과 경계 사이 여백
            let guideWidth = canvas[0].width / 2.2;  // 🛠 기존의 반만큼 너비 조정
            let guideHeight = canvas[0].height * 0.7; // 🛠 기존보다 0.5배 더 높게
            let guideX = (canvas[0].width - guideWidth) / 2; // 중앙 정렬
            let guideY = (canvas[0].height - guideHeight) / 2; // 세로 중앙 정렬

            // 🛠 점선 사각형 그리기 (서명 크기 유도)
            ctx.beginPath();
            ctx.rect(guideX, guideY, guideWidth, guideHeight);
            ctx.stroke();
            ctx.setLineDash([]); // 원래 스타일로 복귀

            // 🛠 가이드 문구 추가 (점선 안에 가득 차게)
            ctx.font = "20px Arial";
            ctx.fillStyle = "rgba(0, 0, 0, 0.5)"; // 흐린 회색
            ctx.textAlign = "center";
            ctx.fillText("여기에 서명하세요", canvas[0].width / 2, guideY + guideHeight / 2 +5);
        }



        return {
            init: function() {
                // 캔버스 사이즈 조절 이벤트
                $(window).on("resize", canvasResize);

                // PC 및 모바일 이벤트 등록
                canvas.on("mousedown mousemove mouseup mouseout", draw);
                canvas.on("touchstart touchmove touchend touchcancel", draw);

                // 저장 버튼 클릭 시
                $("#save").on("click", function() {
                    const tempCanvas = document.createElement("canvas");
                    const tempCtx = tempCanvas.getContext("2d");

                    tempCanvas.width = canvas[0].width;
                    tempCanvas.height = canvas[0].height;

                    tempCtx.drawImage(canvas[0], 0, 0);

                    tempCtx.setLineDash([]); // 점선 스타일 제거
                    tempCtx.clearRect(0, 0, canvas[0].width, canvas[0].height); // 전체 초기화
                    drawing.forEach((pos, index) => {  // 서명만 다시 그리기
                        if (index === 0) {
                            tempCtx.beginPath();
                            tempCtx.moveTo(pos.X, pos.Y);
                            tempCtx.lineWidth = thickness;
                        } else {
                            tempCtx.lineTo(pos.X, pos.Y);
                            tempCtx.lineWidth = thickness;
                            tempCtx.stroke();
                        }
                    });
                    tempCtx.closePath();

                    let imgDataUrl = tempCanvas.toDataURL('image/png').replace('data:image/png;base64,', '');

                    const formdata = new FormData();
                    formdata.append("sign", imgDataUrl);
                    formdata.append("commissioner_seq", "${params.commissioner_seq}");

                    $.ajax({
                        type: 'post',
                        url: "<c:url value='/eval/setSign'/>",
                        data: formdata,
                        dataType: "json",
                        processData: false,
                        contentType: false,
                        success: function(data) {
                            opener.parent.signFlag = true;
                            opener.parent.nextPageBtn();
                            window.close();
                        }
                    });
                });
            },
            onLoad: function() {
                // 페이지 로드 시 캔버스 사이즈 조절
                canvasResize();
            }
        };
    })());

</script>
</body>
</html>
