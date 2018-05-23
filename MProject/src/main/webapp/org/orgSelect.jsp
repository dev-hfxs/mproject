<%@ page pageEncoding="UTF-8"%>
<% 
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>选择单位</title>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache" content="no-cache">
<script type="text/javascript" src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript" src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<style>

</style>
</head>
<body>
<div style="text-align:left;padding:5px 0">
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doConfim()" style="width:80px;">确 定</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doCancel()" style="width:80px;">取 消</a>
</div>
	<table id="dg" class="easyui-datagrid"  style="width:100%;height:400px"
			data-options="singleSelect:true,rownumbers:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'get'">
		<thead>
			<tr>
				<th data-options="field:'ck',checkbox:true"></th>
				<th data-options="field:'org_id',width:80">单位编码</th>
				<th data-options="field:'org_name',width:100">单位名称</th>
				<th data-options="field:'create_date',width:80,align:'right'">创建时间</th>
			</tr>
		</thead>
	</table>
	
	<script>
	$(function() {
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams.sqlId = 'mproject-org-getValidOrgs';
		//queryParams.orgName = 'org2';
		$('#dg').datagrid('reload');
	});

	function doConfim(){
		var row = $('#dg').datagrid('getSelected');
		if (row){
			//$.messager.alert('提示', row.org_name);
			// 返回选择的数据信息
			var params = {id:row.id,org_name:row.org_name};
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