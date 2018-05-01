<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String processorId = request.getParameter("processorId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>导入探测器</title>
<script type="text/javascript"	src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript"	src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
</head>
<body>
<div style="margin: 20px 0;"></div>
<div class="easyui-panel"
	style="width: 100%; max-width: 500px; padding: 30px 30px; border-width:0" >
	<form id="ff" method="post" >
		<div style="margin-bottom: 20px;width: 100%">
			<input type="hidden" name="processorId" value="<%=processorId %>">
			<input type="checkbox"  name="importOption" value="enableReplace" ><span>导入时是否覆盖(根据探测器ID)</span>
		</div>
		<div style="margin-bottom: 20px">
			<input type="text" name="dataFile" style="width:100%">
		</div>
	</form>
	<!-- -->
	<div style="text-align: center; padding: 5px 0">
		<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
		<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
	</div>
</div>
	
<script>
var fileIsOk = false;

function submitForm() {
	if(fileIsOk){
		// 提交保存
		$.ajax( {
			url: "<%=path%>/detector/mgr/dataImport.do",
		    type: 'POST',
		    cache: false,
		    data: new FormData($('#ff')[0]),
		    dataType:"json",
		    processData: false,
		    contentType: false,
		    success:function(data) {
		    	if(data.returnCode == "success"){
		    		parent.refreshDetector();
		    		parent.closeDialog();
		    	}else{
		    		$.messager.alert('提示',data.msg);
		    	}
		    },
		    error : function(data) {
		    	$.messager.alert('异常',data.responseText);
	        }
		});
	}	
}

function doCancel(){
	parent.closeDialog();
}

$(function() {
	$("[type='checkbox'][name='importOption']").next("span").click(function(){
		$(this).prev().trigger("click");
	});
	
	$("[type=text][name=dataFile]").filebox({
		label:'导入文件：',
		prompt:'excel',
		accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		buttonText:'选择',
		onChange:function(){
			var fileObjId = $("[type=file][name=dataFile]").eq(0).attr("id");
			//验证文件类型
			var filePath = $(this).filebox('getValue');
			var dotPos=filePath.lastIndexOf(".");
			var nameLength=filePath.length;
			var suffix=filePath.substring(dotPos+1,nameLength);
			if(suffix ==="xls" || suffix ==="xlsx"){
				
			}else{
				$.messager.alert('提示','文件类型有误.');
				return;
			}
			//验证文件大小
			var dom = document.getElementById(fileObjId);
			var fileSize =  dom.files[0].size;
			
			if(fileSize < 1){
				$.messager.alert('提示','文件内容为空.');
				return;
			}
			if(fileSize > 1024*1024*2){
				$.messager.alert('提示','文件大小不能超出2M.');
				return false;
			}
			fileIsOk = true;
		}
	});
});

</script>
</body>
</html>