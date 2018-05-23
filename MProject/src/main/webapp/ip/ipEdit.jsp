<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
    String id = request.getParameter("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改IP</title>
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
	<div style="margin: 10px 20px;"></div>
	<div class="easyui-panel"
	style="width: 100%; max-width: 500px; padding: 30px 60px; border-width:0" >
		<form id="ff">
		<div data-options="region:'west',split:false" style="width:100%;height:60%;border-width:0">
				<div style="margin-bottom: 20px;width: 100%">
					<input type="text" id="projectId" name="projectId"></input>
				</div>
				<div style="margin-bottom: 20px">
					<input class="easyui-textbox" id="netName" name="netName" style="width: 100%"
						data-options="label:'网段名称:',required:true">
				</div>
				<div style="margin-bottom: 20px">
					<input class="easyui-textbox" id="ip" name="ip" style="width: 100%"
						data-options="label:'IP :',required:true, validType:'checkIp'">
				</div>
				<div style="margin-bottom: 20px">
					<input class="easyui-textbox" id="gateway" name="gateway" style="width: 100%"
						data-options="label:'网关 :',required:true, validType:'checkIp'">
				</div>
				<div style="margin-bottom: 20px">
					<input class="easyui-textbox" id="netMask" name="netMask" style="width: 100%"
						data-options="label:'子网掩码 :',required:true">
				</div>
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
			
			//检查是否选择项目
			var projectId = $("#projectId").val();
			if(projectId == null || projectId.length < 1){
				$.messager.alert('提示','请选择所属项目!');
				return false;
			}
			// 提交保存
			$.ajax( {
			    url:'<%=path%>/ip/mgr/update.do',
			    data:{
			    	'id':'<%=id%>',
			    	'projectId':projectId,
			    	'netName':$("#netName").val(),
			    	'ip':$("#ip").val(),
			    	'gateway':$("#gateway").val(),
			    	'netMask':$("#netMask").val()			
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示','修改成功','info',function(){
			    			parent.refreshDataGrid();
			    		});
			    		
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
			//获取所有的项目
			$.ajax( {
			    url:'<%=path%>/comm/queryForList.do',
			    data:{
			    	'sqlId':'mproject-project-queryProjects'
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	var arrProjects = [];
			    	if(data!=null && data.length > 0){
			    		arrProjects = data;
			    	}
			    	$('#projectId').combobox({
					    data: arrProjects,
					    valueField:'id',
					    textField:'project_name',
					    label:'所属项目',
					    panelHeight:'auto',
					    width:'100%'
					});
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
			
			$.ajax( {
			    url:'<%=path%>/comm/queryForList.do',
			    data:{
			    	'sqlId':'mproject-ip-getIPById',
			    	'id':'<%=id%>'
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data!=null && data.length > 0){
			    		var ipObj = data[0];				    	
			    		$('#projectId').combobox('select', ipObj.project_id);
			    		$("#netName").textbox('setValue', ipObj.net_name);
			    		$("#ip").textbox('setValue',ipObj.ip);
			    		$("#gateway").textbox('setValue',ipObj.gateway);
			    		$("#netMask").textbox('setValue',ipObj.net_mask);			    		
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
		});
		
		$.extend($.fn.validatebox.defaults.rules, {
		    checkIp:{ //验证IP
		      validator: function(value, param){ 
		          return /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/.test(value);
		         },
		         message: '请输入正确的IP.' 
		    }
		});
	</script>
</body>
</html>