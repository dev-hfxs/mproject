<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String projectId = "";
	if(null != request.getParameter("id")){
		projectId = request.getParameter("id");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>查看项目</title>
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
						<input type="hidden" id="projectId" name="projectId">
						<input class="easyui-textbox" id="projectNumber" name="projectNumber" style="width: 100%"
							data-options="label:'项目编号 :',required:true,validType:['charCheck','length[8,20]'],readonly:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="projectName" name="projectName" style="width: 100%"
					data-options="label:'项目名称 :',required:true,validType:'length[2,30]',readonly:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="contractNumber" name="contractNumber" style="width: 100%"
					data-options="label:'合同号 :',required:true,validType:'length[2,30]',readonly:true">
			</div>
			<div style="margin-bottom: 20px">
				<input type="hidden" id="userId" name="userId">
				<input class="easyui-textbox" id="projectManager" name="projectManager" style="width: 100%" prompt="请选择"
					data-options="label:'项目经理 :',readonly:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="allowBoxNum" name="allowBoxNum" style="width: 100%"
					data-options="label:'应建机箱数 :',required:true,readonly:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="projectDesc" name="projectDesc" multiline="true" style="width: 100%;height:60px;"
					data-options="label:'项目描述 :',readonly:true">
			</div>
		</form>
	</div>
	
	<script>
	$(function() {
		//获取项目信息
		$.ajax( {
		    url:'<%=path%>/comm/queryForList.do',
		    data:{
		    	'sqlId':'mproject-project-queryProjectById',
		    	'projectId':'<%=projectId%>'
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data!=null && data.length > 0){
		    		var projectObj = data[0];
		    		$("#projectId").val('<%=projectId%>');
		    		$("#projectName").textbox('setValue',projectObj.project_name);
		    		$("#projectNumber").textbox('setValue',projectObj.project_number);
		    		$("#contractNumber").textbox('setValue',projectObj.contract_number);
		    		$("#projectManager").textbox('setValue',projectObj.project_manager);
		    		$("#allowBoxNum").textbox('setValue',projectObj.allow_box_num);
		    		$("#userId").val(projectObj.user_id);
		    		$("#projectDesc").textbox('setValue',projectObj.project_desc);
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