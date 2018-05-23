<%@ page pageEncoding="UTF-8"%>
<% 
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache" content="no-cache">
<script type="text/javascript" src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript" src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
<style>

</style>
</head>
<body>

<div style="margin: 20px 0;"></div>
	<div class="easyui-panel"
		style="width: 100%; max-width: 460px; padding: 30px 60px; border-width:0" >
		<form id="ff" method="post" >
			
			<div style="margin-bottom: 20px">
				<input type="hidden" id="projectId" name="projectId">
				<input class="easyui-textbox" id="projectName" name="projectName" style="width: 100%" prompt="请选择"
					data-options="label:'有效项目 :',readonly:true">
			</div>
			<div style="margin-bottom: 20px">
				<input type="hidden" id="userId" name="userId">
				<input class="easyui-textbox" id="targetUser" name="targetUser" style="width: 100%" prompt="请选择"
					data-options="label:'使用用户:',readonly:true">
			</div>
			<div style="margin-bottom:20px">
				<select class="easyui-combobox" id="codeType" name="codeType" label="验证码功能:" style="width:100%;" panelHeight="auto"><option value="P">项目查询</option><option value="M">机箱查询</option><option value="C">处理器查询</option><option value="D">探测器查询</option><option value="U">信息修改</option></select>
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="validTime" name="validTime" style="width: 100%"
					data-options="label:'有效时长 :'">
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="clearForm()" style="width: 80px">取消</a>
		</div>
	</div>
</body>
<script>
$(function() {
	$("#projectName").next("span").click(function(){
		showMessageDialog("<%=path%>/query/projectSelect.jsp","选择验证码对应的项目",640,480,true);
	});
	
	$("#targetUser").next("span").click(function(){
		showMessageDialog("<%=path%>/query/userSelect.jsp","选择使用验证码的用户",640,480,true);
	});
	
});

function okResponse(params){
	if(params == null || params.id == null){
		return;
	}
	if(params.type == 'user'){
		$("#userId").val(params.id);
		$("#targetUser").val(params.user_name);
		$("#targetUser").next("span").children('input').eq(0).val(params.user_name);
	}
	if(params.type == 'project'){
		$("#projectId").val(params.id);
		$("#projectName").val(params.project_name);
		$("#projectName").next("span").children('input').eq(0).val(params.project_name);
	}	
	closeDialog();
}

function submitForm() {	
	var projectName = $("#projectName").val();
	if(projectName == null || '' == projectName){
		$.messager.alert('提示','请选择有效项目.');
		return false;
	}
	var targetUser = $("#targetUser").val();
	if(targetUser == null || '' == targetUser){
		$.messager.alert('提示','请选择使用的用户.');
		return false;
	}
	var validTime = $("#validTime").val();
	if(validTime == null || '' == validTime){
		$.messager.alert('提示','请输入有效时长.');
		return false;
	}
	// 提交保存	
	$.ajax( {
	    url:'<%=path%>/query/mgr/code/produce.do',
	    data:{
	    	'projectId':$("#projectId").val(),
	    	'targetUser':$("#userId").val(),
	    	'codeType':$("#codeType").val(),
	    	'validTime':$("#validTime").val()
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
	    success:function(data) {
	    	if(data.returnCode == "success"){
	    		$.messager.alert('提示','验证码已生成且发送到用户邮箱!','info',function(){
	    			$("#ff").form('clear');
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

function clearForm() {
	$("#ff").form('clear');
}
</script>
</html>