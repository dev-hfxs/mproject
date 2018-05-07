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
<title>提交机箱验收进度</title>
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
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'box_number',width:100,sortable:true">机箱编号</th>
				<th data-options="field:'nfc_number',width:100,sortable:true">NFC序列号</th>
				<th data-options="field:'longitude',width:100,sortable:true">经度</th>
				<th data-options="field:'latitude',width:100,sortable:true">纬度</th>
				<th data-options="field:'processor_num',width:150">包含处理器数量</th>
				<th data-options="field:'submit_num',width:100">提交次数</th>
				<th data-options="field:'confirm_install_date',width:150">安装验收时间</th>
				<th data-options="field:'confirm_debug_date',width:150">调试完成时间</th>
				<th data-options="field:'pm_confirm_date',width:220">项目经理验收时间</th>
			</tr>
		</thead>
	</table>
</div>
<script>

$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-box-getUserBoxsProgessList';
	queryParams.userId = '${loginUser.id}';
	queryParams.projectId = '${curProjectId}';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
	//$('#dg').datagrid('hideColumn', 'status'); 
});

var cmenu = null;
function showHeaderMenu(e, field){
	e.preventDefault();
	if (!cmenu){
		cmenu = $('<div/>').appendTo('body');
		cmenu.menu({
			onClick: function(item){
				if (item.iconCls == 'icon-ok'){
					$('#dg').datagrid('hideColumn', item.name);
					cmenu.menu('setIcon', {
						target: item.target,
						iconCls: 'icon-empty'
					});
				} else {
					$('#dg').datagrid('showColumn', item.name);
					cmenu.menu('setIcon', {
						target: item.target,
						iconCls: 'icon-ok'
					});
				}
			}
		});
		var fields = $('#dg').datagrid('getColumnFields');
		for(var i=0; i<fields.length; i++){
			var field = fields[i];
			if(field == 'id'){
				continue;
			}
			var col = $('#dg').datagrid('getColumnOption', field);
			cmenu.menu('appendItem', {
				text: col.title,
				name: field,
				iconCls: 'icon-ok'
			});
		}
	}
	cmenu.menu('show', {
		left:e.pageX,
		top:e.pageY
	});
}

function doSearch(){
	var charKey = $("#inpKey" ).val();
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-box-getUserBoxsProgessList';
	queryParams.projectName = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}
</script>
</body>
</html>