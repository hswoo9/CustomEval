/*최종학력*/


function eduResetBtn(){
					$('#schFm').val('');
					$('#schTo').val('');
					$('#EDU_FR').val('');
					$('#EDU_TO').val('');
					$('#schDn').val('');
					$('#SCH_NM').val('');
					$('#MJR_DN').val('');
					$('#MJR_NM').val('');
					$('#MJR_NO').val('');
					$('#fileID').val('');
					$('#PRNS_EDU_ID').val('0');
				}
				
				
				function getFileNm(e){
					var index = $(e).val().lastIndexOf('\\') +1;
					var valLength = $(e).val().length;
					$('#fileID').val($(e).val().substr(index, valLength));
					
				}		
				
				function updateBtn(){
					var data = {
							
							PRSN_DN : $(":input:radio[name=PRSN_DN]:checked").val(),
							INS_UNTPRC : $('#INS_UNTPRC').val(),
							EMPL_FR : $('#EMPL_FR').val(),
							EMPL_TO : $('#EMPL_TO').val(),
							LOGIN_ID : $('#LOGIN_ID').val(),
							
							EMP_SEQ : $('#EMP_SEQ').val()
					}
					$.ajax({
						url: "/examinant/insPrsnUpdate",
						dataType : 'text',
						data : data,
						type : 'POST',
						success: function(result){
							
							/* $(":input:radio[name=PRSN_DN]:checked").val('');
							$('#INS_UNTPRC').val('');
							$('#EMPL_FR').val('');
							$('#EMPL_TO').val(''); */
							location.reload();
						}
					});
				}
				
				
				function eduDelBtn(e){
					var row = $(e).closest("tr");
					
					var data = {
							login_id : $('#login_id').val(),
							eduID : row.find('#eduID').val()
							
					}
					$.ajax({
						url: "/examinant/eduDel",
						dataType : 'text',
						data : data,
						type : 'POST',
						success: function(result){
							 $("#eduInfo").load(window.location + " #eduInfo");
						}
					});							
				}
				
				
				
				
				
				function subCode(id, e){
					var data = {
						code : $(e).val()
					}
					var html = '<option value="all"></option>';
				
					$.ajax({
						url: "/common/standardCd",
						dataType : 'json',
						data : data,
						async : false,
						type : 'POST',
						success: function(result){
						
							$.each(result.standardCd, function(i, v){
								

								html += '<option value="'+v.CODE_CD+'">'+v.CODE_CD+' (' +v.CODE_NM+' )</option>';


								
							})
				
							$('#'+id).empty().append(html);
						
						}
					});
					
				}
				function tab_nor_Fn(num){
					$(".tab"+num).show();
					$(".tab"+num).siblings().hide();
					
					var inx = num -1

					$(".tab_nor li").eq(inx).addClass("on");
					$(".tab_nor li").eq(inx).siblings().removeClass("on");
				}
				function eduFileDown(e){
					var row = $(e).closest("tr");
					var PRNS_EDU_ID = row.find('#eduID').val();
					var data = {
							fileNm : row.find('#mjrFile').val(),
							PRNS_EDU_ID : row.find('#eduID').val(),
							INS_PRSN_ID : row.find('#prsnID').val()
					}
					
					$.ajax({
						url : '/examinant/eduFileDown',
						type : 'GET',
						data : data,
					}).success(function(data) {
						var downWin = window.open('','_self');
						downWin.location.href = '/examinant/eduFileDown?PRNS_EDU_ID='+PRNS_EDU_ID;
					});
					
				}
				
				