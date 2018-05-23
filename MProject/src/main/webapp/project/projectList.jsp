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
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',toolbar:'#tb',multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'project_number',width:100,sortable:true">项目编号</th>
				<th data-options="field:'project_name',width:200,sortable:true">项目名称</th>
				<th data-options="field:'contract_number',width:100,sortable:true">合同号</th>
				<th data-options="field:'project_manager',width:200,formatter:fmManager">项目经理</th>
				<th data-options="field:'creator',width:100">创建人</th>
				<th data-options="field:'create_date',width:150,sortable:true">创建时间</th>
				<th data-options="field:'status',width:80,formatter:showStatusName,sortable:true">项目状态</th>
				<th data-options="field:'id',width:150,align:'left',formatter:showButtons">操作</th>
			</tr>
		</thead>
	</table>
</div>
<div id="tb" style="padding:2px 5px;">
		<input id="inpKey" class="easyui-textbox"  prompt="项目名" style="width:150px">
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

function fmManager(val,row){
	var columnHtml = '';
	if (row.status =='F'){
		if(val != null && val.length > 1){
			columnHtml = '<span>'+val+'</span>&nbsp;&nbsp;&nbsp;&nbsp;'+'<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteManager(\''+row.id+'\')" style="width:80px;">移除项目经理</a></span>';
		}else{
			columnHtml = val;
		}
	}else{
		columnHtml = val;
	}
	return columnHtml;
}

function showButtons(val,row){
	var columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:doUpdate(\''+val+'\')" style="width:80px;">修 改</a></span>&nbsp;&nbsp;'
                   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doView(\''+val+'\')" style="width:80px;">查看内容</a></span>&nbsp;&nbsp;';
    if(row.status == 'I'){
    	columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="closeProject(\''+val+'\')" style="width:80px;">结束项目</a></span>&nbsp;&nbsp;';
    }
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

function deleteManager(val){
	$.messager.confirm('确认', '确认移除项目经理?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/project/mgr/deleteManager.do',
			    data:{
			    	'projectId':val
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示','操作成功!','info',function(){
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

function closeProject(val){
	$.messager.confirm('确认', '确认结束该项目?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/project/mgr/closeProject.do',
			    data:{
			    	'projectId':val
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示','操作成功!','info',function(){
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

//查看项目内容
function doView(val){
	var content = '<iframe src="<%=path%>/project/view/viewContent.jsp?projectId=' + val + '" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="查看项目内容" style="overflow:hidden;"></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '960',
		height : '560',
		modal : true,
		title : '查看项目内容',
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