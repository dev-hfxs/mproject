<%@ page pageEncoding="UTF-8"%>
<% 
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>用户列表</title>
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
<div style="text-align:left;padding:5px 0">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doConfim()" style="width:80px;">确 定</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doCancel()" style="width:80px;">取 消</a>
</div>
<div id="dgPanel" class="easyui-panel" data-options="fit:true">
	<table id="dg" class="easyui-datagrid"  style="height:400px"
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
<div id="tb" style="padding:2px 5px;">
		<input id="inpKey" class="easyui-textbox"  prompt="用户名" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
</div>
<script>
$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-user-getUsersForEngineer';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		//var pageList = $('#dg').datagrid('options').pageList;
		//$('#dg').datagrid('options').pageSize = pageSize;
		$('#dg').datagrid('options').pageNumber = pageNum;
		
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
});

function doConfim(){
	var row = $('#dg').datagrid('getSelected');
	if (row){
		// 返回选择的数据信息
		var userName = row.user_name + "/" + row.full_name;
		var params = {id:row.id,user_name:userName};
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