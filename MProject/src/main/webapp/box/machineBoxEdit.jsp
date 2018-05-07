<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String boxId = request.getParameter("boxId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改机箱</title>
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
		style="width: 100%; max-width: 480px; padding: 30px 60px; border-width:0" >
		<form id="ff" method="post" >
			<div style="margin-bottom: 20px;width: 100%">
						<input class="easyui-textbox" id="boxNumber" name="boxNumber" style="width: 90%"
							data-options="label:'机箱编号 :',required:true,validType:'checkBoxCode'">
			</div>
			<div style="margin-bottom: 20px;width: 100%">
						<input class="easyui-textbox" id="nfcNumber" name="nfcNumber" style="width: 90%"
							data-options="label:'NFC编号 :',required:true,validType:'length[14,14]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="longitude" name="longitude" style="width: 90%"
					data-options="label:'经度 :',required:true,precision:6,validType:'checkLng'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="latitude" name="latitude" style="width: 90%"
					data-options="label:'纬度 :',required:true,precision:6,validType:'checkLat'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="processorNum" name="processorNum" style="width: 90%"
					data-options="label:'处理器数量 :',required:true,validType:'checkPNum'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="installSpace" name="installSpace" style="width: 90%"
					data-options="label:'安装间距 (m):',precision:2,validType:'length[0,7]'">
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
		</div>
	</div>
	
	<script>
	var nfcCodeValid = true;
	
		function submitForm() {
			if($("#ff").form('validate') == false){
				$.messager.alert('输入错误','请检查输入项!');
				return false;
			}
						
			//检查机箱编号是否存在
			var boxNumberExist = false;
			var boxNumber = $("#boxNumber").val();
			
			$.ajax( {
			    url:'<%=path%>/box/mgr/checkBoxNumber.do',
			    data:{
			    	'boxId':'<%=boxId%>',
			    	'boxNumber':boxNumber
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.exist != null && data.exist !='true'){
			    		boxNumberExist = false;
			    	}else{
			    		boxNumberExist = true;
			    		//$.messager.alert('提示','机箱编号已存在,请检查!');
			    		return;
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
			if(boxNumberExist == true){
				$("#boxNumber").next("span").addClass("textbox-invalid");
				$.messager.alert('提示','机箱编号已存在,不能重复录入!');
				return;
			}
			
			if(nfcCodeValid == false){
				$("#nfcNumber").next("span").addClass("textbox-invalid");
				$.messager.alert('提示','机箱NFC序列号未通过验证,不能提交!');
				return false;
			}
			// 提交保存
			$.ajax( {
			    url:'<%=path%>/box/mgr/update.do',
			    data:{
			    	'boxId':'<%=boxId%>',
			    	'boxNumber':$("#boxNumber").val(),
			    	'nfcNumber':$("#nfcNumber").val(),
			    	'longitude':$("#longitude").val(),
			    	'latitude':$("#latitude").val(),
			    	'processorNum':$("#processorNum").val(),
			    	'installSpace':$("#installSpace").val()	
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示','修改成功!','info',
			    			function(){
								//
								parent.refreshDataGrid();
								parent.closeDialog();
			    			}
			    		);
			    	}else{
			    		$.messager.alert('提示',data.msg);
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
		}

		function doCancel() {
			parent.closeDialog();
		}
		
		$(function() {
			//
			//获取机箱信息
			$.ajax( {
			    url:'<%=path%>/comm/queryForList.do',
			    data:{
			    	'sqlId':'mproject-box-queryBoxById',
			    	'boxId':'<%=boxId%>'
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data!=null && data.length > 0){
			    		var boxObj = data[0];
			    		$("#boxNumber").textbox('setValue', boxObj.box_number);
			    		$("#nfcNumber").textbox('setValue', boxObj.nfc_number);
			    		$("#longitude").textbox('setValue', boxObj.longitude);
			    		$("#latitude").textbox('setValue', boxObj.latitude);
			    		$("#processorNum").textbox('setValue', boxObj.processor_num);
			    		$("#installSpace").textbox('setValue', boxObj.install_space);	
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
		});
		
		$("#nfcNumber").textbox({  
		    onChange: function(value) {
		    	var objValue = $(this).val();
		    	if(objValue.length == 14){
		    		$.ajax( {
					    url:'<%=path%>/dict/mgr/checkNfcNum.do',
					    data:{codeName:'box',codeValue:objValue,id:'<%=boxId%>'},
			    		type:'post',
					    async:false,
					    dataType:'json',
					    success:function(data) {
					    	if(data.returnCode == "success"){
					    		nfcCodeValid =  true;
					    		$("#nfcNumber").next("span").removeClass("textbox-invalid");
					    	}else{
					    		nfcCodeValid =  false;
					    		$("#nfcNumber").next("span").addClass("textbox-invalid");
					    		$.messager.alert('提示',data.msg);
					    	}
					    },
					    error : function(data) {
					    	nfcCodeValid =  false;
					    	$.messager.alert('异常',data.responseText);
				        }
					});
		    	}
		    }
		});
			
		$.extend($.fn.validatebox.defaults.rules, {
		    checkLng: { //验证经度
		        validator: function(value, param){
		         return  /^-?(((\d|[1-9]\d|1[1-7]\d|0)\.\d{7})|0|180)$/.test(value);
		        },
		        message: '经度整数部分为0-180,小数位保留6位!'
		    },
		    checkLat: { //验证纬度
		        validator: function(value, param){
		         return  /^-?([0-8]?\d{1}\.\d{6}|0|([0-8]?\d{1})\.\d{6}|90)$/.test(value);
		        },
		        message: '纬度整数部分为0-90,小数位保留6位!'
		    },
		    checkBoxCode: { //验证机箱编号
		        validator: function(value, param){
		         return  /^[a-zA-Z0-9\-]{12}$/.test(value);
		        },
		        message: '机箱编号只能是字母、数字和符号 - , 长度为12位!'
		    },
		    checkPNum: { //验证处理器数量
		        validator: function(value, param){
		         return  /^[1-2]{1}$/.test(value);
		        },
		        message: '一个机箱可设置1-2个处理器!'
		    }
		});
		
	</script>
</body>
</html>