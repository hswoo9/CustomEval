$(function(){

	$(document).ready(function(){

		/*게시판버튼on/off*/
		$(".st_btn a").click(function(){
			if (!$(this).hasClass("on")){
				$(this).addClass("on");
				$(this).siblings().removeClass("on");
			}else if ($(this).hasClass("on")){
				$(this).removeClass("on");
			}
		});

		/* 서브상단 신규버튼 시 table 영역 보이기 */
		$( ".layer_show button" ).click(function() {							  
			$( ".com_ta" ).show();
		});
		$( ".layer_hide input" ).click(function() {							  
			  $( ".com_ta" ).hide();
		});


		// 서브페이지 상세검색 slideToggle
		$(".SearchDetail").hide();
		$(".btn_Detail").click(function(){
		  $(".SearchDetail").slideToggle("slow");
		  
			 if($('#all_menu_btn').attr('src')=='../../../Images/ico/ico_btn_arr_down01.png'){
				$('#all_menu_btn').attr('src','../../../Images/ico/ico_btn_arr_up01.png');
			}else{
				$('#all_menu_btn').attr('src','../../../Images/ico/ico_btn_arr_down01.png');
			}
	   });	

	   // 팝업창 닫기	  
	   $('.clo').click(function() {
			$('.pop_wrap').hide();
		  });

		// 서브 tab 이동시 상세검색영역 닫기
		$("#tabstrip ul li").click(function(){
			$(".SearchDetail").hide();								
		});

	});

/*테이블넓이정하기*/
$(document).ready(function() {
	iframeWid();
	Mcalendar_size();
	note_size();//일정_노트
	subConWid();
	ta_size();
	rec_size();
	bdListH();// 게시판 좌측 리스트 높이
	
	
	$(window).resize(function() {
		note_size();//일정_노트
		ta_size();
		iframeWid();
		bdListH();// 게시판 좌측 리스트 높이
		//subConWid();
	});
});

// 게시판 좌측 리스트 높이
function bdListH(){
     var sl_hei=$(".sub_left").height();
     $(".bd_list_box.workcate").height(sl_hei-167);// 업무카테고리 좌측 리스트 높이
     $(".bd_list_box.bdlist").height(sl_hei-57);// 게시판관리 좌측 리스트 높이
}


// 기록물철별문서
function ta_size(){
	 var scw_wid=$(".sub_contents_wrap").width();
	 var scw_hei=$(".sub_contents_wrap").height();
	 var record_wid=$(".sub_left").width();
	var sub_cont_wid = $(".sub_con").width(scw_wid - record_wid - 30 - 3 ); //10 => 레프트조절영역
	//$(".sub_left").height(scw_hei);
}

function rec_size(){	 
	var scw_hei=$(".sub_contents_wrap").height();
//	var tree_hei=$(".treeTop").height();	 

	var treetitle_hei=$(".tree_title").height();
	var recordTab_hei=$(".record_tab").height() + 10;
	var recordSea_hei=$(".record_tabSearch").height() + 30;
	var etc_folder_hei=$(".etc_folder").height();
		
	$(".sub_left").height(scw_hei);	

	if ($(".record_tab").length > 0 && $(".record_tabSearch").length)
	{
		$(".tree_auto").height(scw_hei - recordTab_hei - recordSea_hei - treetitle_hei - etc_folder_hei -11);
	} else if($(".record_tab").length > 0 )
	{
		$(".tree_auto").height(scw_hei - recordTab_hei - treetitle_hei - etc_folder_hei -11);
	} else if($(".record_tabSearch").length > 0 )
	{
		$(".tree_auto").height(scw_hei - recordSea_hei - treetitle_hei - etc_folder_hei -11);
	} else {
		$(".tree_auto").height(scw_hei - treetitle_hei - etc_folder_hei -11);
	}

}

/*아이프레임width값*/
function iframeWid(){
		var hori_wid=$("#horizontal ").width();
		var sw_wid=$(".side_wrap ").width();
	 $(".sub_contents iframe").width( hori_wid - sw_wid -8 );

}


// 메인 달력 > 오늘일정
function Mcalendar_size(){	 
	var Mcalendar_hei=$(".calendar").height();
	var Mcalendartitle_hei=$(".calendar h2").height();	 
	var schedule_hei=$(".schedule_cal").height();
	var today_schtitle_hei=$(".today_sch h3").height();		

	$(".today_sch ul").height(Mcalendar_hei - Mcalendartitle_hei - schedule_hei - today_schtitle_hei -32);
}

// 일정_노트
function note_size(){
	var conWrapHei =$(".contents_wrap").height();
	var headWrapHei =$(".header_wrap").height();
	var footWrapHei =$(".footer").height();
	var sc_hei=$(".sub_contents").height(conWrapHei-headWrapHei-footWrapHei);
					
    var sc_wid=$(".sub_contents").width();
    var sct_hei=$(".sub_title_wrap").height();
	//alert(sc_hei);
   //$(".note_con").width(sc_wid-42);
    $(".note_con").height(sc_hei-sct_hei-150);
    var nt_con_hei=$(".note_con").height();
    //$(".note_right").width(sc_wid-314);
    $(".note_d_con").height(nt_con_hei-211);
	$("iframe").height();
}

/*

function rec_size(){
	 var scw_hei=$(".sub_contents").height();
	 var loc_hei=$(".location_info").height();
	 var tit_hei=$(".title_div").height();
	 var tb_hei=$(".top_box").height();
	$(".sub_left").height(scw_hei -loc_hei -tit_hei -tb_hei-30);
}

*/


/********************************************************************************************************************
레프트 리사이징
********************************************************************************************************************/

$(document).ready(function() {
		horResize();
	$(window).resize(function() { 
			horResize();
	});

function horResize(){
		var conWrapHei =$(".contents_wrap").height();
		var headWrapHei =$(".header_wrap").height();
		var footWrapHei =$(".footer").height();
		$("#horizontal").height(conWrapHei-headWrapHei-footWrapHei);
	}	

	$("#horizontal").kendoSplitter({
		panes: [ 
			{ collapsible: false, min:"248px", max:"400px", size:"248px" }, 
			{ collapsible: false, resizable: true } 
		]

	});
});

/* sub_contents넓이 */
function subConWid(){
	 
	var k_wid=$(".k-splitbar").width();
	 if ($(".side_wrap").length > 0) 
	 {
		 $(".sub_contents").width($(".sub_wrap").width()-8);
	 }else {
		$(".sub_contents").width($(".sub_wrap").width()-0);
	 }
}

/********************************************************************************************************************
sub_nav 커스텀
********************************************************************************************************************/

//2dep 구분 클래스 추가
$("#sub_nav > li.k-item").addClass("2dep-item");

//2dep 선택. 형제요소 닫기
$('.2dep-item').on('click',function(){
    var AllClose = $(this).siblings();
    var treeview = $("#sub_nav").data("kendoTreeView");//트리데이터 가져오기
    treeview.collapse(AllClose);
});

//2dep 선택시 자신만 선언
$('#sub_nav > .k-item > div').on('click',function(){
    $('.k-item > div').removeClass('on');//2dep 선언취소
    $('.k-item > .k-group > .k-item > div').removeClass('on');//3dep 선언취소
    $('.k-item > .k-group > .k-item > .k-group .k-item > div').removeClass('on');//4dep 선언취소
    
    $(this).addClass('on');
});

//3dep 선택시 자신과 부모 2dep만 선언
$('#sub_nav > .k-item > .k-group > .k-item > div').on('click',function(){
    $('.k-item > div').removeClass('on');//2dep 선언취소
    $('.k-item > .k-group > .k-item > div').removeClass('on');//3dep 선언취소
    $('.k-item > .k-group > .k-item > .k-group .k-item > div').removeClass('on');//4dep 선언취소
    
    $(this).parent().parent().parent().children().addClass('on');//부모 2dep만 선언
    $(this).addClass('on');
});

//4dep 선택시 자신과 부모 2dep,3dep만 선언
$('#sub_nav > .k-item > .k-group > .k-item > .k-group .k-item > div').on('click',function(){
    $('.k-item > div').removeClass('on');//2dep 선언취소
    $('.k-item > .k-group > .k-item > div').removeClass('on');//3dep 선언취소
    $('.k-item > .k-group > .k-item > .k-group .k-item > div').removeClass('on');//4dep 선언취소
    
    $(this).parent().parent().parent().parent().parent().children().addClass('on');//부모 2dep 선언
    $(this).parent().parent().parent().children().addClass('on');//부모 3dep 선언
    $(this).addClass('on');
});    
/********************************************************************************************************************/







})    
     

     
