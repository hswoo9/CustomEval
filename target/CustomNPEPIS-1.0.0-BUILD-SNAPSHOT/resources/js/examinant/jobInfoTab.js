/*실무경험*/


function tab_nor_Fn(num){
					$(".tab"+num).show();
					$(".tab"+num).siblings().hide();
					
					var inx = num -1

					$(".tab_nor li").eq(inx).addClass("on");
					$(".tab_nor li").eq(inx).siblings().removeClass("on");
				}
				function jobResetBtn(){
					$('#EXPR_FR').val('');
					$('#EXPR_TO').val('');
					$('#CMPY_NM').val('');
					$('#DIV_NM').val('');
					$('#PSN_NM').val('');
					$('#JOB_NM').val('');
					$('#fileID2').val('');
					$('#PRNS_EXPR_ID').val('0');
				}
				
				function getJobNm(e){
					var index = $(e).val().lastIndexOf('\\') +1;
					var valLength = $(e).val().length;
					$('#fileID2').val($(e).val().substr(index, valLength));
					
				}	
				function jobSaveBtn(){
					var formData = new FormData($("#fileForm2")[0]);
					
					$.ajax({
						url: "/examinant/jobExSave",
						
						data : formData,
						type : 'post',
						processData : false,
						contentType : false,
						success: function(result){
							alert('업로드성공');
							$('#PRNS_EXPR_ID').val('0');
							$('#EXPR_FR').val('');
							$('#EXPR_TO').val('');
							$('#CMPY_NM').val('');
							$('#DIV_NM').val('');
							$('#PSN_NM').val('');
							$('#JOB_NM').val('');
							$('#fileID2').val('');
							
							 $("#jobInfo").load(window.location + " #jobInfo");
						},
						error : function(error) {
							alert('업로드 실패');
							console.log(error);
							console.log(error.status);
						}
					});							
				}
				function jobDelBtn(e){
					var row = $(e).closest("tr");
					var data = {
							login_id : $('#login_id').val(),
							jobID : row.find('#jobID').val()
							
					}
					$.ajax({
						url: "/examinant/jobDel",
						dataType : 'text',
						data : data,
						type : 'POST',
						success: function(result){
							 $("#jobInfo").load(window.location + " #jobInfo");
						}
					});							
				}
				
				