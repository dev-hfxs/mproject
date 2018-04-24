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
<title>项目列表</title>
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
				<th data-options="field:'project_number',width:100,sortable:true">机箱编号</th>
				<th data-options="field:'project_name',width:100,sortable:true">经度</th>
				<th data-options="field:'contract_number',width:100,sortable:true">纬度</th>
				<th data-options="field:'project_manager',width:150">包含处理器数量</th>
				<th data-options="field:'creator',width:100">提交次数</th>
				<th data-options="field:'creator',width:100">安装验收时间</th>
				<th data-options="field:'creator',width:100">调试完成时间</th>
				<th data-options="field:'creator',width:200">项目经理验收时间</th>
			</tr>
		</thead>
	</table>
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

function showStatusName(val,row){
	if (val == 'I'){
		return '<span>在建</span>';
	} else if (val =='F'){
		return '<span>完成</span>';
	}else{
		return val;
	}
}

function showButtons(val,row){
	var columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:doUpdate(\''+val+'\')" style="width:80px;">修改信息</a></span>&nbsp;&nbsp;'
                   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doView(\''+val+'\')" style="width:80px;">提交信息</a></span>&nbsp;&nbsp;'
                   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doView(\''+val+'\')" style="width:80px;">删除信息</a></span>&nbsp;&nbsp;';
	return columnItem;
}

function doUpdate(val){
	var queryParams = $('#dg').datagrid('options').queryParams;
	var options = $("#dg" ).datagrid("getPager" ).data("pagination" ).options;
    var pageNum = options.pageNumber;
    var pageSize = options.pageSize;
	var curUrl = "<%=path%>/project/projectEdit.jsp?id="+val+"&pageNum="+pageNum + "&pageSize="+pageSize;
	parent.loadUrl(curUrl);
}

function doView(val){
	var content = '<iframe src="<%=path%>/project/projectView.jsp?id=' + val + '" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="查看项目" ></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '640',
		height : '480',
		modal : true,
		title : '查看项目',
		onClose : function() {
			$(this).dialog('destroy');// 后面可以关闭后的事件
		}
	});
	win.dialog('open');
	win.window('center');
	
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