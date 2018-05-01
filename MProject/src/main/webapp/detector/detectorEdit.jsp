<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String id = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改探测器</title>
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
	style="width: 100%; max-width: 500px; padding: 30px 60px; border-width:0" >
	<form id="ff" method="post" >
		<div style="margin-bottom: 20px;width: 100%">
			<input class="easyui-textbox" id="nfcNumber" name="nfcNumber" style="width: 100%"
				data-options="label:'NFC序列号:',required:true,validType:'length[1,20]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-textbox" id="detectorId" name="detectorId" style="width: 100%"
				data-options="label:'探测器ID:',required:true,validType:'length[1,20]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-numberbox" id="longitude" name="longitude" style="width: 100%"
				data-options="label:'经度 :',required:true,precision:6,validType:'length[8,10]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-numberbox" id="latitude" name="latitude" style="width: 100%"
				data-options="label:'纬度 :',required:true,precision:6,validType:'length[8,10]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-numberbox" id="startPoint" name="startPoint" style="width: 100%"
				data-options="label:'起点 :',precision:6,validType:'length[8,10]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-numberbox" id="endPoint" name="endPoint" style="width: 100%"
				data-options="label:'终点 :',precision:6,validType:'length[8,10]'">
		</div>
	</form>
	<!-- -->
	<div style="text-align: center; padding: 5px 0">
		<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
		<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
	</div>


</div>
	
<script>
function submitForm() {
	if($("#ff").form('validate') == false){
		$.messager.alert('输入错误','请检查输入项!');
		return false;
	}
	
	// 提交保存
	$.ajax( {
	    url:'<%=path%>/detector/mgr/update.do',
	    data:{
	    	'id':'<%=id%>',
	    	'detectorId':$("#detectorId").val(),
	    	'nfcNumber':$("#nfcNumber").val(),
	    	'longitude':$("#longitude").val(),
	    	'latitude':$("#latitude").val(),
	    	'startPoint':$("#startPoint").val(),
	    	'endPoint':$("#endPoint").val()
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
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

function doCancel(){
	parent.closeDialog();
}

$(function() {
	
	//获取处理器
	$.ajax( {
	    url:'<%=path%>/comm/queryForList.do',
	    data:{
	    	'sqlId':'mproject-detector-getDetectorById',
	    	'id':'<%=id%>'
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
	    success:function(data) {
	    	if(data!=null && data.length > 0){
	    		var processorObj = data[0];
	    		$("#detectorId").textbox('setValue', processorObj.detector_id);
	    		$("#nfcNumber").textbox('setValue', processorObj.nfc_number);
	    		$("#longitude").textbox('setValue',processorObj.longitude);
	    		$("#latitude").textbox('setValue', processorObj.latitude);
	    		$("#startPoint").textbox('setValue',processorObj.start_point);
	    		$("#endPoint").textbox('setValue',processorObj.end_point);
	    	}
	    },
	    error : function(data) {
	    	$.messager.alert('异常',data.responseText);
        }
	});
});

</script>
</body>
</html>