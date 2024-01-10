/*******************************************************************
    
    이벤트
    
********************************************************************/

$(function(){
    
    //개인별주간
    if ($(".share_cal table .head_tr.on").hasClass("on")){
        $(".share_cal table .head_tr.on").children().addClass("minus");
        $(".share_cal table .head_tr.on").children().removeClass("plus");
        $(".share_cal table .head_tr.on").next().children().show();
    };
    $(".share_cal table .head_tr").click(function(){
        if ($(this).hasClass("on")){
            $(this).children().addClass("plus");
            $(this).children().removeClass("minus");
            $(this).removeClass("on");
            $(this).next().children().hide();
        }else if(!$(this).hasClass("on")){
            $(this).children().addClass("minus");
            $(this).children().removeClass("plus");
            $(this).addClass("on");
            $(this).next().children().show();
        }
    });
      
});// end function

/*******************************************************************
    
    이벤트 (함수)
    
********************************************************************/

// 스케쥴 탭
function schedulerTab(num){
    var t = num;
    
    $(".d-scheduler-tab li a").removeClass('on');
    
    switch(t) {
        
        //사용자주간
        case 0:
            $(".d-scheduler-tab li:nth-child(1) a").addClass('on');
            $(".tabItem").hide();
            $(".d-scheduler-userweekview").show();
            $(".date_format span").text("2017.01.01 ~ 2017.01.07"); // 이부분은 개발할때 빼주세요
        break;
        
        //일간
        case 1:
            $(".d-scheduler-tab li:nth-child(3) a").addClass('on');
            $(".tabItem").hide();
            $(".d-scheduler-dayview").show();
            $(".date_format span").text("2017.01.03"); // 이부분은 개발할때 빼주세요
        break;
        
        //주간
        case 2:
            $(".d-scheduler-tab li:nth-child(5) a").addClass('on');
            $(".tabItem").hide();
            $(".d-scheduler-weekview").show();
            $(".date_format span").text("2017.01.01 ~ 2017.01.07"); // 이부분은 개발할때 빼주세요
        break;
        
        //월간
        case 3:
            $(".d-scheduler-tab li:nth-child(7) a").addClass('on');
            $(".tabItem").hide();
            $(".d-scheduler-monthview").show();
            $(".date_format span").text("2017.01"); // 이부분은 개발할때 빼주세요
        break;
        
        //목록
        case 4:
            $(".d-scheduler-tab li:nth-child(9) a").addClass('on');
            $(".tabItem").hide();
            $(".d-scheduler-agenda").show();
            $(".date_format span").text("2017.01"); // 이부분은 개발할때 빼주세요
        break;
    }    
}