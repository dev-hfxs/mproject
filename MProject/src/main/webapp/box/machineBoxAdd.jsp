<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>添加机箱</title>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache" content="no-cache">
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
			<div style="margin-bottom: 20px;width: 100%">
						<input class="easyui-textbox" id="boxNumber" name="boxNumber" style="width: 100%"
							data-options="label:'机箱编号 :',required:true,validType:'length[12,12]'">
			</div>
			<div style="margin-bottom: 20px;width: 100%">
						<input class="easyui-textbox" id="nfcNumber" name="nfcNumber" style="width: 100%"
							data-options="label:'NFC编号 :',required:true,validType:'length[14,14]'">
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
				<input class="easyui-numberbox" id="gcjLongitude" name="gcjLongitude" style="width: 100%"
					data-options="label:'国测经度 :',required:true,precision:6,validType:'length[8,10]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="gcjLatitude" name="gcjLatitude" style="width: 100%"
					data-options="label:'国测纬度 :',required:true,precision:6,validType:'length[8,10]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="processorNum" name="processorNum" style="width: 100%"
					data-options="label:'处理器数量 :',required:true,validType:'length[1,1]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="installSpace" name="installSpace" style="width: 100%"
					data-options="label:'安装间距 (m):',precision:2,validType:'length[0,7]'">
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="clearForm()" style="width: 80px">取消</a>
		</div>
	</div>
	
	<script>
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
			    	'boxId':'',
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
			    		$.messager.alert('提示','机箱编号已存在,请检查!');
			    		return;
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
			if(boxNumberExist == true){
				return;
			}
			
			// 提交保存
			$.ajax( {
			    url:'<%=path%>/box/mgr/add.do',
			    data:{
			    	'boxId':'',
			    	'userId':'${loginUser.id}',
			    	'orgId':'${loginUser.orgId}',
			    	'projectId':'${curProjectId}',
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
			    		$.messager.alert('提示','添加成功!','info',
			    			function(){
								//
								parent.loadUrl('<%=path%>/project/machineBoxWrite.jsp');
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

		function clearForm() {
			$("#ff").form('clear');
		}
		
	</script>
</body>
</html>