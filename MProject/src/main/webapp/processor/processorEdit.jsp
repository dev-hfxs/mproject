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
<style>
.textbox-label{
	width:120px;
}
</style>
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
				data-options="label:'处理器NFC序列号:',required:true,validType:'length[1,20]'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-textbox" id="moxaNumber" name="moxaNumber" style="width: 100%"
				data-options="label:'MOXA-NFC序列号:',required:true,validType:'length[1,20]'">
		</div>
		<div style="margin-bottom: 20px;width: 100%">
			<input class="easyui-textbox" id="detectorNum" name="detectorNum" style="width: 100%"
				data-options="label:'探测器数量:',required:true,validType:'checkDNum'">
		</div>
	</form>
	<!-- -->
	<div style="text-align: center; padding: 5px 0">
		<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
		<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
	</div>


</div>
	
<script>
var pNfcCodeValid = false;
var mNfcCodeValid = false;

function submitForm() {
	if($("#ff").form('validate') == false){
		$.messager.alert('输入错误','请检查输入项!');
		return false;
	}
	if(pNfcCodeValid == false){
		$("#nfcNumber").next("span").addClass("textbox-invalid");
		$.messager.alert('提示','处理器NFC序列号未通过验证,不能提交!');
		return false;
	}
	if(mNfcCodeValid == false){
		$("#moxaNumber").next("span").addClass("textbox-invalid");
		$.messager.alert('提示','MOXA-NFC序列号未通过验证,不能提交!');
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
	
	
	$("#nfcNumber").textbox({  
	    onChange: function(value) {
	    	var objValue = $(this).val();
	    	if(objValue.length == 14){
	    		$.ajax( {
				    url:'<%=path%>/dict/mgr/checkNfcNum.do',
				    data:{codeName:'processor',codeValue:objValue,id:'<%=id%>'},
		    		type:'post',
				    async:false,
				    dataType:'json',
				    success:function(data) {
				    	if(data.returnCode == "success"){
				    		pNfcCodeValid =  true;
				    		$("#nfcNumber").next("span").removeClass("textbox-invalid");
				    	}else{
				    		pNfcCodeValid =  false;
				    		$("#nfcNumber").next("span").addClass("textbox-invalid");
				    		$.messager.alert('提示',data.msg);
				    	}
				    },
				    error : function(data) {
				    	$.messager.alert('异常',data.responseText);
			        }
				});
	    	}
	    }
	});
	
	$("#moxaNumber").textbox({  
	    onChange: function(value) {
	    	var objValue = $(this).val();
	    	if(objValue.length == 14){
	    		$.ajax( {
				    url:'<%=path%>/dict/mgr/checkNfcNum.do',
				    data:{codeName:'moxa',codeValue:objValue,id:'<%=id%>'},
		    		type:'post',
				    async:false,
				    dataType:'json',
				    success:function(data) {
				    	if(data.returnCode == "success"){
				    		mNfcCodeValid =  true;
				    		$("#moxaNumber").next("span").removeClass("textbox-invalid");
				    	}else{
				    		mNfcCodeValid =  false;
				    		$("#moxaNumber").next("span").addClass("textbox-invalid");
				    		$.messager.alert('提示',data.msg);
				    	}
				    },
				    error : function(data) {
				    	$.messager.alert('异常',data.responseText);
			        }
				});
	    	}
	    }
	});
});

$.extend($.fn.validatebox.defaults.rules, {            
    checkIp : {// 验证IP地址  
        validator : function(value) {  
            var reg = /^((1?\d?\d|(2([0-4]\d|5[0-5])))\.){3}(1?\d?\d|(2([0-4]\d|5[0-5])))$/ ;  
            return reg.test(value);  
        },  
        message : 'IP地址格式不正确'
	},
	checkDNum: { //验证探测器数量
        validator: function(value, param){
         return  /^([1-9]|[1-9][0-9]|1[0-1][0-9]|1[2][0-8])$/.test(value);
        },
        message: '一个处理器可设置1-128个探测器!'
    }
});
</script>
</body>
</html>