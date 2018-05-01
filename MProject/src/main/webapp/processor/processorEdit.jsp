<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String id = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改处理器</title>
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
			<input class="easyui-textbox" id="boxNumber" name="boxNumber" style="width: 100%" 
				data-options="label:'所属机箱:',readonly:true">
		</div>
		<div style="margin-bottom: 20px;width: 100%">
			<input class="easyui-textbox" id="nfcNumber" name="nfcNumber" style="width: 100%"
				data-options="label:'NFC序列号:',required:true,validType:'length[1,20]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-textbox" id="processorId" name="processorId" style="width: 100%"
				data-options="label:'处理器ID:',required:true,validType:'length[1,20]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-textbox" id="moxaNumber" name="moxaNumber" style="width: 100%"
				data-options="label:'MOXA序列号:',required:true,validType:'length[1,20]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-textbox" id="ip" name="ip" style="width: 100%"
				data-options="label:'IP:',validType:'checkIp'">
		</div>
		<div style="margin-bottom: 20px;width: 100%">
			<input class="easyui-numberbox" id="detectorNum" name="detectorNum" style="width: 100%"
				data-options="label:'探测器数量:',required:true,validType:'length[1,3]'">
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
	    url:'<%=path%>/processor/mgr/update.do',
	    data:{
	    	'id':'<%=id%>',
	    	'nfcNumber':$("#nfcNumber").val(),
	    	'processorId':$("#processorId").val(),
	    	'moxaNumber':$("#moxaNumber").val(),
	    	'detectorNum':$("#detectorNum").val(),
	    	'ip':$("#ip").val()
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
	    success:function(data) {
	    	if(data.returnCode == "success"){
	    		parent.refreshProcessor();
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
	    	'sqlId':'mproject-processor-getProcessorById',
	    	'id':'<%=id%>'
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
	    success:function(data) {
	    	if(data!=null && data.length > 0){
	    		var processorObj = data[0];
	    		$("#boxNumber").textbox('setValue', processorObj.box_number);
	    		$("#nfcNumber").textbox('setValue', processorObj.nfc_number);
	    		$("#processorId").textbox('setValue', processorObj.processor_id);
	    		$("#moxaNumber").textbox('setValue',processorObj.moxa_number);
	    		$("#ip").textbox('setValue', processorObj.ip);
	    		$("#detectorNum").textbox('setValue',processorObj.detector_num);
	    	}
	    },
	    error : function(data) {
	    	$.messager.alert('异常',data.responseText);
        }
	});
	$("#boxNumber").textbox({disabled: true});
	
});

$.extend($.fn.validatebox.defaults.rules, {            
    checkIp : {// 验证IP地址  
        validator : function(value) {  
            var reg = /^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$/ ;  
            return reg.test(value);  
        },  
        message : 'IP地址格式不正确'
	} 
});
</script>
</body>
</html>