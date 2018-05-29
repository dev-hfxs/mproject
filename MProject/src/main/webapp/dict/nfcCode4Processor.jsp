<%@ page pageEncoding="UTF-8"%>
<%
	// no use 
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>处理器编码库</title>
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
			data-options="singleSelect:true,rownumbers:true,pageSize:30,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true,toolbar:'#tb'">
		<thead>
			<tr>
				<th data-options="field:'nfc_code',width:200,sortable:true">NFC序列号</th>
				<th data-options="field:'number',width:200,sortable:true">编号</th>
				<th data-options="field:'box_nfc_code',width:200,sortable:true">机箱NFC序列号</th>
				<th data-options="field:'create_date',width:150,sortable:true">创建日期</th>
			</tr>
		</thead>
	</table>
	<div id="tb" style="padding:2px 5px;">
		<input id="inpKey" class="easyui-textbox"  prompt="NFC序列号" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>&nbsp;&nbsp;
		<a href="#" class="easyui-linkbutton" onclick="importCode()" iconCls="icon-filter">导入</a>
	</div>
</div>
<script>
$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-dict-queryProcessorNfcsAll';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
	//$('#dg').datagrid('hideColumn', 'status'); 
});

function doSearch(){
	var charKey = $("#inpKey" ).val();
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-dict-queryProcessorNfcsAll';
	queryParams.nfcCode = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}

function refreshDataGrid(){
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}

function importCode(){
	var content = '<iframe src="<%=path%>/dict/codeImport.jsp?codeName=processor" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="导入处理器NFC序列号" ></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '480',
		height : '240',
		modal : true,
		title : '导入处理器NFC序列号',
		onClose : function() {
			$(this).dialog('destroy');
		}
	});
	win.dialog('open');
	win.window('center');
}

</script>
</body>
</html>