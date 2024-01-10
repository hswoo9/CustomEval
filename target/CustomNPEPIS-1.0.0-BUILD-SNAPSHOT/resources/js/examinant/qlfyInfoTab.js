/*자격사항*/


function tab_nor_Fn(num){
					$(".tab"+num).show();
					$(".tab"+num).siblings().hide();
					
					var inx = num -1

					$(".tab_nor li").eq(inx).addClass("on");
					$(".tab_nor li").eq(inx).siblings().removeClass("on");
				}
				function qlfyResetBtn(){
					$('#OBTN_DT').val('');
					$('#QLFY_NM').val('');
					$('#QLFY_ORG').val('');
					$('#fileID3').val('');
					$('#PRNS_QLFY_ID').val('0');
					
					
				}
				
				function getQlfyNm(e){
					var index = $(e).val().lastIndexOf('\\') +1;
					var valLength = $(e).val().length;
					$('#fileID3').val($(e).val().substr(index, valLength));
					
				}	
				function qlfySaveBtn(){
					var formData = new FormData($("#fileForm3")[0]);
					
					$.ajax({
						url: "/examinant/qlfySave",
						
						data : formData,
						type : 'post',
						processData : false,
						contentType : false,
						success: function(result){
							alert('업로드성공');
							$('#OBTN_DT').val('');
							$('#QLFY_NM').val('');
							$('#QLFY_ORG').val('');
							$('#fileID3').val('');
							$('#PRNS_QLFY_ID').val('0');
							$("#qlfyInfo").load(window.location + " #qlfyInfo");
						},
						error : function(error) {
							alert('업로드 실패');
							console.log(error);
							console.log(error.status);
						}
					});							
				}
				function qlfyDelBtn(e){
					var row = $(e).closest("tr");
					var data = {
							login_id : $('#login_id').val(),
							qlfyID : row.find('#qlfyID').val()
							
					}
					$.ajax({
						url: "/examinant/qlfyDel",
						dataType : 'text',
						data : data,
						type : 'POST',
						success: function(result){
							$("#qlfyInfo").load(window.location + " #qlfyInfo");
						}
					});							
				}
				
				function qlfyModify(e){
					var row = $(e).closest('tr');
					var modObtnDt = row.find('#modObtnDt').val();
					var modQlfyNm = row.find('#modQlfyNm').val();
					var modQlfyOrg = row.find('#modQlfyOrg').val();
					var PRNS_QLFY_ID = row.find('#qlfyID').val();
					
					$('#OBTN_DT').val(modObtnDt);
					$('#QLFY_NM').val(modQlfyNm);
					$('#QLFY_ORG').val(modQlfyOrg);
					$('#PRNS_QLFY_ID').val(PRNS_QLFY_ID);
					
				}
				function qlfyFileDown(v){
					var row = $(v).closest("tr");
					var PRNS_QLFY_ID = row.find('#qlfyID').val();
					var data = {
							fileNm : row.find('#qlfyFile').val(),
							PRNS_QLFY_ID : row.find('#qlfyID').val()
					}
					
					$.ajax({
						url : '/examinant/qlfyFileDown',
						type : 'GET',
						data : data,
					}).success(function(data) {
						var downWin = window.open('','_self');
						downWin.location.href = '/examinant/qlfyFileDown?PRNS_QLFY_ID='+PRNS_QLFY_ID;
					});
					
				}
				