<%@ page pageEncoding="UTF-8"%>
<% 
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
	String jobType = request.getParameter("jobType");
	String boxId = request.getParameter("boxId");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>选择工单工程师</title>
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
<!--  -->

<div class="easyui-layout" data-options="border:false,fit:true">
		<div data-options="region:'north',border:false" style="height:36px">
			<div id="qtb" class="easyui-panel datagrid-toolbar"  data-options="fit:true">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doConfim()" style="width:80px;">确 定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doCancel()" style="width:80px;">取 消</a>
			</div>
		</div>
		<div data-options="region:'center',border:false" style="height:400px;">
				<table id="dg" class="easyui-datagrid" style="height:400px;"
						data-options="singleSelect:true,rownumbers:true,pageSize:20,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'get'">
					<thead>
						<tr>
							<th data-options="field:'ck',checkbox:true"></th>
							<th data-options="field:'user_name',width:150">用户名</th>
							<th data-options="field:'full_name',width:80">姓名</th>
							<th data-options="field:'org_name',width:200">所在单位</th>
							<th data-options="field:'role_name',width:80">用户类型</th>
						</tr>
					</thead>
				</table>
		</div>
</div>
<script>
$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var jobType = "<%=jobType%>";
	
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-user-getUsersForJobEngineer';
	queryParams.projectId = '${curProjectId}';
	queryParams.machineBoxId =  "<%=boxId%>";
	if("A" == jobType){
		queryParams.roleType2 = 'I';
	}
	if("T" == jobType){
		queryParams.roleType4 = 'D';
	}
	
	if("Q" == jobType){
		queryParams.roleType2 = 'I';
		queryParams.roleType4 = 'D';
	}
	
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
		
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
});

function doConfim(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		// 返回选择的人员
		var params = {id:row.id,user_name:row.user_name};
		parent.okResponse(params);
	}else{
		$.messager.alert('提示', "未选择数据!");
	}
}

function doCancel(){
	parent.closeDialog();
}
</script>
</body>
</html>