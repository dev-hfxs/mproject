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
<title>当前项目管理</title>
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
<div id="dgPanel" class="easyui-panel" data-options="fit:true">
	<table id="dg" class="easyui-datagrid"  
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',toolbar:'#tb',multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'full_name',width:100,sortable:true">机箱编号</th>
				<th data-options="field:'org_name',width:100,sortable:true">机箱状态</th>
				<th data-options="field:'org_name',width:180,sortable:true">创建时间</th>
				<th data-options="field:'contract_number',width:100">经度</th>
				<th data-options="field:'allow_box_num',width:100">纬度</th>
				<th data-options="field:'submit_box_num',width:200">位置描述</th>
				<th data-options="field:'accept_box_num',width:120">包含处理器数量</th>
				<th data-options="field:'accept_box_num',width:100">施工经理</th>
				<th data-options="field:'accept_box_num',width:120">施工经理提交次数</th>
				<th data-options="field:'accept_box_num',width:120,sortable:true">最新提交时间</th>
				<th data-options="field:'id',width:250,align:'center',formatter:showButtons">操作</th>
			</tr>
		</thead>
	</table>
</div>
<div id="tb" style="padding:2px 5px;">
		<input id="inpKey" class="easyui-textbox"  prompt="机箱编号" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
</div>
<script>

$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-queryProjects';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
	//$('#dg').datagrid('hideColumn', 'status'); 
});

function showButtons(val,row){
	var columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doEnableEdit(\''+val+'\')" style="width:80px;">允许修改</a></span>&nbsp;&nbsp;'
	               + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="publishJob(\''+val+'\')" style="width:80px;">发布工单</a></span>&nbsp;&nbsp;'
	               + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doAccept(\''+val+'\')" style="width:80px;">确认验收</a></span>&nbsp;&nbsp;';
	return columnItem;
}

function doDelete(val){
	
}

function doSearch(){
	var charKey = $("#inpKey" ).val();
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-queryProjects';
	queryParams.projectName = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}
</script>
</body>
</html>