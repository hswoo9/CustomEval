/*심사자격*/



function specResetBtn(){
							$('#insSpec').val('');
							$('#insGd').val('');
							$('#SPEC_ORG').val('');
							$('#REG_NO').val('');
							$('#EXFR_DT').val('');
							$('#fileID4').val('');
							$('#PRNS_SPEC_ID').val('0');
						}
				function insSpecDelBtn(e){
					var row = $(e).closest("tr");
					var data = {
							login_id : $('#login_id').val(),
							specID : row.find('#specID').val()
							
					}
					$.ajax({
						url: "/examinant/insSpecDel",
						dataType : 'text',
						data : data,
						type : 'POST',
						success: function(result){
							$("#specInfo").load(window.location + " #specInfo");
						}
					});							
				}
				function insSpecSaveBtn(){
					var formData = new FormData($("#fileForm4")[0]);
					
					$.ajax({
						url: "/examinant/insSpecSave",
						
						data : formData,
						type : 'post',
						processData : false,
						contentType : false,
						success: function(result){
							alert('업로드성공');
							$('#insSpec').val('');
							$('#insGd').val('');
							$('#SPEC_ORG').val('');
							$('#REG_NO').val('');
							$('#EXFR_DT').val('');
							$('#fileID4').val('');
							$('#PRNS_SPEC_ID').val('0');
							$("#specInfo").load(window.location + "#specInfo");
							
						},
						error : function(error) {
							alert('업로드 실패');
							console.log(error);
							console.log(error.status);
						}
					});							
				}
				function getSpecNm(e){
					var index = $(e).val().lastIndexOf('\\') +1;
					var valLength = $(e).val().length;
					$('#fileID4').val($(e).val().substr(index, valLength));
					
				}	
				
				
				
				function tab_nor_Fn(num){
					$(".tab"+num).show();
					$(".tab"+num).siblings().hide();
					
					var inx = num -1

					$(".tab_nor li").eq(inx).addClass("on");
					$(".tab_nor li").eq(inx).siblings().removeClass("on");
				}
				
				function specModify(e){
					var row = $(e).closest('tr');
					var modSpecCd = row.find('#modSpecCd').val();
					var modInsGd = row.find('#modInsGd').val();
					var modSpecOrg = row.find('#modSpecOrg').val();
					var modRegNo = row.find('#modRegNo').val();
					var modExfrDt = row.find('#modExfrDt').val();
					var PRNS_SPEC_ID = row.find('#specID').val();
					
					$('#insSpec').val(modSpecCd);
					$('#insGd').val(modInsGd);
					$('#SPEC_ORG').val(modSpecOrg);
					$('#REG_NO').val(modRegNo);
					$('#EXFR_DT').val(modExfrDt);
					$('#PRNS_SPEC_ID').val(PRNS_SPEC_ID);
					
				}
				function specFileDown(e){
					var row = $(e).closest("tr");
					var PRNS_SPEC_ID = row.find('#specID').val();
					var data = {
							fileNm : row.find('#specFile').val(),
							PRNS_SPEC_ID : row.find('#specID').val()
					}
					
					$.ajax({
						url : '/examinant/specFileDown',
						type : 'GET',
						data : data,
					}).success(function(data) {
						var downWin = window.open('','_self');
						downWin.location.href = '/examinant/specFileDown?PRNS_SPEC_ID='+PRNS_SPEC_ID;
					});
					
				}
