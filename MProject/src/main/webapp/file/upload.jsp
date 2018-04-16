<%@ page pageEncoding="UTF-8"%>
<% 
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>项目管理系统</title>
<script type="text/javascript" src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/json2.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript" src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/style/default/main.css">
<script>
var fileIsValid = true;
$(function(){
	//文件上传
	$('#bt-upload').bind("click",function(){
		if(fileIsValid == true){
		   //文件验证通过后上传
			$.ajax({
		        url: "<%=path%>/file/upload.do",
		        type: 'POST',
		        cache: false,
		        data: new FormData($('#formFile')[0]),
		        processData: false,
		        contentType: false,
		        dataType:"json",
		        error: function(data){
		            alert(data.responseText);
		        	//alert(JSON.stringify(data));
		        },
		        success: function(data) {
		           alert("success");
		        }
		    });
			fileIsValid = false;
		}
	});
	
	$('#bt-import').bind("click",function(){
		$("[type=file][name=file2]").eq(0).click();
	});
	
	
	//文件选择后的处理
	$('#file2').filebox({prompt:'txt',onChange:function(){
		//alert($(this).filebox('getValue'));
		//console.log($(this).filebox());
		var fileObjId = $("[type=file][name=file2]").eq(0).attr("id");
		
			var filePath = $(this).filebox('getValue');
			
			var dotPos=filePath.lastIndexOf(".");
			var nameLength=filePath.length;
			var suffix=filePath.substring(dotPos+1,nameLength);
			if(suffix ==="txt"){
				
			}else{
				return;
			}
			
			var dom = document.getElementById(fileObjId);
			var fileSize =  dom.files[0].size;
			
			if(fileSize > 0 && fileSize < 1024*1024){
				fileIsValid = true;
			}
			
			// todo close 选择后直接上传
			if(fileIsValid == true){
				//文件验证通过后上传
				$.ajax({
				     url: "<%=path%>/file/upload.do",
				     type: 'POST',
				     cache: false,
				     data: new FormData($('#formFile')[0]),
				     processData: false,
				     contentType: false,
				     dataType:"json",
				     beforeSend: function(){
				         uploading = true;
				     },
				     success : function(data) {
				         alert(data);
				     }
				 });
				 fileIsValid = false;
			}
		}});
});

</script>
 </head>
 <body>
 <div style="margin:20px 0;"></div>
 	<form id="formFile">
	<div class="easyui-panel" title="Upload File" style="width:100%;max-width:400px;padding:30px 60px;">
		<div style="margin-bottom:20px">
			<input class="easyui-filebox" label="配置文件:" name="file1" labelPosition="top" data-options="prompt:'txt',accept:'text/plain'" style="width:100%">
		</div>
		<div style="margin-bottom:40px">
			<input id="file2" class="easyui-filebox" label="探测器信息:" name="file2" labelPosition="top" style="width:100%">
		</div>
		
		<div style="margin-bottom:40px">
			<input class="easyui-filebox" label="Excel文件导入处理器:" name="file3" labelPosition="top" data-options="prompt:'excel',accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'" style="width:100%">
		</div>
		
		<div>
			<a href="#" id="bt-upload" class="easyui-linkbutton" style="width:100%">Upload</a>
			<a href="#" id="bt-import" class="easyui-linkbutton" style="width:100%">Import</a>
		</div>
		</form>
	</div>
 </body>
 </html>