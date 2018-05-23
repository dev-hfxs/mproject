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
<title>IP地址列表</title>
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
<!--  -->
<div id="dgPanel" class="easyui-panel" data-options="fit:true">
	<table id="dg" class="easyui-datagrid"  
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',toolbar:'#tb', multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'net_name',width:250">网段名称</th>
				<th data-options="field:'ip',width:100,sortable:true">IP地址</th>
				<th data-options="field:'gateway',width:200,sortable:true">网关</th>
				<th data-options="field:'net_mask',width:200,sortable:true">子网掩码</th>
				<th data-options="field:'create_date',width:130">创建时间</th>
				<th data-options="field:'status',width:100,formatter:fmStatusName">状态</th>
				<th data-options="field:'project_name',width:100">所属项目</th>
				<th data-options="field:'id',width:150,align:'center',formatter:fmButtons">操作</th>
			</tr>
		</thead>
	</table>
	<div id="tb" style="text-align: left; padding: 1px 0">
		&nbsp;<input id="inpKey" class="easyui-textbox"  prompt="ip" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
		&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="doAdd()"  iconCls="icon-edit"  style="width: 80px">添加</a> &nbsp;
		<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="doImport()" iconCls="icon-filter" style="width: 80px">导入</a> &nbsp;
	</div>
</div>
<script>
	$(function() {
		var pageNum = "<%=pageNum%>";
		var pageSize = "<%=pageSize%>";
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams.sqlId = 'mproject-ip-getAllIPList';
		if(pageNum != null && pageNum != 'null' && pageNum != ''){
			//var pageList = $('#dg').datagrid('options').pageList;
			//$('#dg').datagrid('options').pageSize = pageSize;
			$('#dg').datagrid('options').pageNumber = pageNum;
		}
		$('#dg').datagrid('reload');
		$('.pagination-page-list').hide();
	});

	function fmStatusName(val,row){
		if (val == 'N'){
			return '<span>未使用</span>';
		} else if (val =='Y'){
			return '<span>已使用</span>';
		}else if(val =='L'){
			return '<span>锁定使用</span>';
		}else if(val =='Q'){
			return '<span>不可用</span>';
		}else{
			return val;
		}
	}
	
	function fmButtons(val,row){
		var columnItem = '';
		if(row.status == 'N'){
			columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:doUpdate(\''+val+'\')" style="width:80px;">修 改</a></span>&nbsp;&nbsp;'
			+ '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doDelete(\''+val+'\')" style="width:80px;">删 除</a></span>&nbsp;&nbsp;';
		}else{
			
		}
		return columnItem;
	}
	
	function doAdd(){
		var content = '<iframe src="<%=path%>/ip/ipAdd.jsp" width="100%" height="90%" frameborder="0" scrolling="no"></iframe>';
		var boarddiv = '<div id="msgwindow" title="添加IP" ></div>'// style="overflow:hidden;"可以去掉滚动条
		$(document.body).append(boarddiv);
		var win = $('#msgwindow').dialog({
			content : content,
			width : '640',
			height : '480',
			modal : true,
			title : '添加IP',
			onClose : function() {
				$(this).dialog('destroy');
			}
		});
		win.dialog('open');
		win.window('center');
	}
	
	function doDelete(val){
		$.messager.confirm('确认', '确认删除该IP?', function(r){
			if(r){
				$.ajax( {
				    url:'<%=path%>/ip/mgr/delete.do',
				    data:{
				    	'id':val
				    },
				    type:'post',
				    async:false,
				    dataType:'json',
				    success:function(data) {
				    	if(data.returnCode == "success"){
				    		$.messager.alert('提示','删除成功!','info',function(){
				    			$('#dg').datagrid('reload');
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
		});
	}
	
	function doUpdate(val){
		var content = '<iframe src="<%=path%>/ip/ipEdit.jsp?id='+ val +'" width="100%" height="90%" frameborder="0" scrolling="no"></iframe>';
		var boarddiv = '<div id="msgwindow" title="修改IP" ></div>'// style="overflow:hidden;"可以去掉滚动条
		$(document.body).append(boarddiv);
		var win = $('#msgwindow').dialog({
			content : content,
			width : '640',
			height : '480',
			modal : true,
			title : '修改IP',
			onClose : function() {
				$(this).dialog('destroy');
			}
		});
		win.dialog('open');
		win.window('center');
	}
	
	function doImport(){
		var content = '<iframe src="<%=path%>/ip/ipImport.jsp" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
		var boarddiv = '<div id="msgwindow" title="导入IP地址" ></div>'// style="overflow:hidden;"可以去掉滚动条
		$(document.body).append(boarddiv);
		var win = $('#msgwindow').dialog({
			content : content,
			width : '480',
			height : '240',
			modal : true,
			title : '导入IP地址',
			onClose : function() {
				$(this).dialog('destroy');
			}
		});
		win.dialog('open');
		win.window('center');
	}
	
	function doSearch(){
		var charKey = $("#inpKey" ).val();
		var isValidIp = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/.test(charKey);
		if(isValidIp == false){
			$.messager.alert('提示','输入的ip格式不正确.');
			return;
		}
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams.sqlId = 'mproject-ip-getAllIPList';
		queryParams.ip = charKey;
		$('#dg').datagrid('loadData',{total:0,rows:[]});
		$('#dg').datagrid('reload');
	}
	
	function refreshDataGrid(){
		$("#msgwindow").dialog('destroy');
		$('#dg').datagrid('reload');
	}
	
	function closeDialog() {
		$("#msgwindow").dialog('destroy');
	}

</script>
</body>
</html>