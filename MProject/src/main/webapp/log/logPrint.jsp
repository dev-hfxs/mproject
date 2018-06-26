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
<title>打印日志查询</title>
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
<div id="dgPanel" class="easyui-panel" data-options="fit:true">
	<table id="dg" class="easyui-datagrid"  
			data-options="singleSelect:true,rownumbers:true,pageSize:30,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,toolbar:'#tb',method:'post',multiSort:true">
		<thead>
			<tr>
			    <th data-options="field:'box_number',width:160">机箱编号</th>
				<th data-options="field:'report_name',width:180">报表名称</th>
				<th data-options="field:'user_name',width:200,sortable:true">操作用户名</th>
				<th data-options="field:'operation_date',width:140,sortable:true">打印时间</th>
				<th data-options="field:'print_entrance',width:100,formatter:fmEntrance">打印入口</th>
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
	queryParams.sqlId = 'mproject-log-getPrintLog';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
	//$('#dg').datagrid('hideColumn', 'status'); 
});

function fmEntrance(val,row){
	if (val == 'boxWrite'){
		return '<span>机箱填写</span>';
	} else if (val =='projectMgr'){
		return '<span>当前项目管理</span>';
	} else if (val =='jobProcess'){
		return '<span>工单处理</span>';
	}else{
		return '';
	}
}

function doSearch(){
	var charKey = $("#inpKey" ).val();
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-log-getPrintLog';
	queryParams.boxNumber = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}

</script>
</body>
</html>