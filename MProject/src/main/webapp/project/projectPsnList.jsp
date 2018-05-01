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
<title>人员管理</title>
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
				<th data-options="field:'full_name',width:100,sortable:true">姓名</th>
				<th data-options="field:'org_name',width:200,sortable:true">所在单位</th>
				<th data-options="field:'contract_number',width:100,sortable:true">联系电话</th>
				<th data-options="field:'allow_box_num',width:200">应建机箱数量</th>
				<th data-options="field:'submit_box_num',width:100,formatter:formatNumber">提交机箱数量</th>
				<th data-options="field:'accept_box_num',width:150,formatter:formatNumber,sortable:true">验收机箱数量</th>
				<th data-options="field:'id',width:150,align:'center',formatter:showButtons">操作</th>
			</tr>
		</thead>
	</table>
</div>
<div id="tb" style="padding:2px 5px;">
	<!-- 
	<input id="inpKey" class="easyui-textbox"  prompt="姓名" style="width:150px">
	<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
	 -->
	<a href="#" class="easyui-linkbutton" onclick="doAdd()" iconCls="icon-add">添加施工经理&nbsp;&nbsp;</a>
</div>
<script>
$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-getProjectPsnList';
	queryParams.projectId = '${curProjectId}';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
});

function formatNumber(val,row){
	if (val == null || val == 'null'){
		return '<span>0</span>';
	}else{
		return val;
	}
}

function showButtons(val,row){
	var columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doDelete(\''+row.project_id+'\',\'' + row.user_id+'\')" style="width:80px;">删 除</a></span>&nbsp;&nbsp;';
	columnItem =  columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="resetNum(\''+row.project_id+'\',\'' + row.user_id+'\','+row.allow_box_num+')" style="width:80px;">应建机箱数量调整</a></span>&nbsp;&nbsp;';
	return columnItem;
}

function resetNum(projectId,userId,allowBoxNum){
	var content = '<iframe src="<%=path%>/project/projectPsnBoxNumSet.jsp?projectId='+projectId+'&userId='+userId +'&allowBoxNum='+ allowBoxNum + '"width="100%" height="100%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="修改应建机箱数量" style="overflow:hidden;"></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '320',
		height : '180',
		modal : true,
		title : '修改应建机箱数量',
		onClose : function() {
			$(this).dialog('destroy');// 后面可以关闭后的事件
		}
	});
	win.dialog('open');
	win.window('center');
}

function doAdd(){
	var content = '<iframe src="<%=path%>/project/managerSelect.jsp" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="选择项目施工经理" style="overflow:hidden;"></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '640',
		height : '480',
		modal : true,
		title : '选择项目施工经理',
		onClose : function() {
			$(this).dialog('destroy');// 后面可以关闭后的事件
		}
	});
	win.dialog('open');
	win.window('center');
}

function doDelete(projectId,userId){
	$.messager.confirm('确认', '确认删除该施工经理?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/project/mgr/deleteProjectPsn.do',
			    data:{
			    	'projectId':projectId,
			    	'userId':userId
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		refreshDataGrid();
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


function refreshDataGrid(){
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}

function okResponse(result){
	if(result == 'success'){
		$("#msgwindow").dialog('destroy');
		//刷新列表
		$('#dg').datagrid('reload');
		$.messager.alert('提示','添加成功!');
	}
}

function doSearch(){
	var charKey = $("#inpKey" ).val();
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-getProjectPsnList';
	queryParams.projectName = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}
</script>
</body>
</html>