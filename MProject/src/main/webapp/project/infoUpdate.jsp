<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>信息修改</title>
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
		style="width: 100%; max-width: 460px; padding: 30px 60px; border-width:0" >
		<form id="ff" method="post" >
			<!-- 
			<div style="margin-bottom: 20px;width: 100%">
					<select class="easyui-combobox" id="operationPart" name="operationPart" label="修改部分 :" style="width:100%;" panelHeight="auto"><option value="box">机箱</option><option value="processor">处理器</option><option value="detector">探测器</option></select>
			</div>
			 -->
			<div style="margin-bottom: 20px">
				<input type="text" id="operationPart" name="operationPart"></input>
			</div>
			<div style="margin-bottom: 20px">
				<input type="text" id="updateField" name="updateField"></input>
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="searchCode" name="searchCode" style="width: 100%"
					data-options="label:'验证码 :',required:true,validType:'length[8,8]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="dataIndexValue" name="dataIndexValue" style="width: 100%"
					data-options="label:'修改索引 :',required:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="oldValue" name="oldValue" style="width: 100%"
					data-options="label:'修改前内容 :',required:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="newValue" name="newValue" style="width: 100%"
					data-options="label:'修改后内容 :',required:true">
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">提 交</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="clearForm()" style="width: 80px">取 消</a>
		</div>
	</div>
	
	<script>
	
	var partOptions = [{'name':'box','text':'机箱','selected':true},{ 'name':'processor', 'text':'处理器'},{ 'name':'detector', 'text':'探测器'}];
	
	var boxFileds = [{'name':'box_number', 'text':'机箱编号','selected':true},{'name':'create_date', 'text':'创建时间'},{'name':'longitude','text':'经度'},{'name':'latitude','text':'纬度'},{'name':'pos_desc', 'text':'位置描述'}];
	
	var processorFileds = [{'name':'nfc_number','text':'NFC序列号','selected':true},{ 'name':'moxa_number', 'text':'MOXA-NFC序列号'},{ 'name':'ip', 'text':'IP地址'}];
	
	var detectorFileds = [{'name':'nfc_number', 'text':'NFC序列号','selected':true},{'name':'longitude','text':'经度'},{'name':'latitude','text':'纬度'},{'name':'start_pos', 'text':'起点'},{'name':'end_pos', 'text':'终点'}];
	
	function submitForm() {
		if($("#ff").form('validate') == false){
			$.messager.alert('输入错误','请检查输入项!');
			return false;
		}
		var searchCode = $("#searchCode" ).val();
		if(searchCode.length != 8){
			$.messager.alert('提示', '请输入8位验证码!','info',function(){
				return;
			});
			return;
		}
		
		var operationPart = $("#operationPart").val();
    	var updateField = $("#updateField").val();
    	if(operationPart == null || operationPart.length < 1){
    		$.messager.alert('提示','请选择修改部分!');
    		return;
    	}
    	if(updateField == null || updateField.length < 1){
    		$.messager.alert('提示','请选择修改字段!');
    		return;
    	}
    	if("longitude" == updateField){
    		//验证经度
    		var lngOldValue = $("#oldValue").val();
    		var lngNewValue = $("#newValue").val();
    		
    		var isOldValid =  /^-?(((\d|[1-9]\d|1[1-7]\d|0)\.\d{6})|0|180)$/.test(lngOldValue);
    		var isNewValid =  /^-?(((\d|[1-9]\d|1[1-7]\d|0)\.\d{6})|0|180)$/.test(lngNewValue);
    		if(isOldValid == false || isNewValid == false){
    			$.messager.alert('提示','经度输入不正确,经度整数部分为0-180,小数位保留6位!');
        		return;
    		}
    	}
    	
    	if("latitude" == updateField){
    		//验证纬度
    		var latOldValue = $("#oldValue").val();
    		var latNewValue = $("#newValue").val();
    		
    		var isOldValid =  /^-?([0-8]?\d{1}\.\d{6}|0|([0-8]?\d{1})\.\d{6}|90)$/.test(latOldValue);
    		var isNewValid =  /^-?([0-8]?\d{1}\.\d{6}|0|([0-8]?\d{1})\.\d{6}|90)$/.test(latNewValue);
    		if(isOldValid == false || isNewValid == false){
    			$.messager.alert('提示','纬度输入不正确,纬度整数部分为0-90,小数位保留6位!');
        		return;
    		}
    	}
		// 提交修改
		$.ajax( {
		    url:'<%=path%>/query/mgr/updateInfo.do',
		    data:{
		    	'operationPart':$("#operationPart").val(),
		    	'updateField':$("#updateField").val(),
		    	'searchCode':$("#searchCode").val(),
		    	'dataIndexValue':$("#dataIndexValue").val(),
		    	'oldValue':$("#oldValue").val(),
		    	'newValue':$("#newValue").val()
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data.returnCode == "success"){
		    		$.messager.alert('提示', '修改成功!');
		    	}else{
		    		$.messager.alert('提示',data.msg);
		    	}
		    },
		    error : function(data) {
		    	$.messager.alert('异常',data.responseText);
	        }
		});
	}

	function clearForm() {
		$("#ff").form('clear');
	}
	
	$(function() {
		$('#operationPart').combobox({
		    data: partOptions,
		    valueField:'name',
		    textField:'text',
		    label:'修改部分',
		    panelHeight:'auto',
		    width:'100%',
		    onChange:function(){
		    	var text = $(this).combobox('getValue');
		    	var datas = [];
		    	if("box" == text){
		    		datas = boxFileds;
		    	}else if("processor" == text){
		    		datas = processorFileds;
		    	}else if("detector" == text){
		    		datas = detectorFileds;
		    	}
		    	$('#updateField').combobox({
				    data: datas,
				    valueField:'name',
				    textField:'text',
				    label:'修改字段',
				    panelHeight:'auto',
				    width:'100%'
				});
		    }
		});
		
		$('#updateField').combobox({
		    data: boxFileds,
		    valueField:'name',
		    textField:'text',
		    label:'修改字段',
		    panelHeight:'auto',
		    width:'100%'
		});
		
	});
	</script>
</body>
</html>