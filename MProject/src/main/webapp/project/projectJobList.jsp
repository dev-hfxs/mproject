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
<title>项目工单查询</title>
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
				<th data-options="field:'status',width:100,formatter:showStatusName">工单状态</th>
				<th data-options="field:'job_type',width:100,formatter:showTypeName">工单类型</th>
				<th data-options="field:'user_name',width:180">工程师</th>
				<th data-options="field:'work_content',width:250,sortable:true">工作内容</th>
				<th data-options="field:'project_number',width:100,sortable:true">项目编号</th>
				<th data-options="field:'project_name',width:180,sortable:true">项目名称</th>
				<th data-options="field:'box_number',width:120,sortable:true">机箱编号</th>
				<th data-options="field:'create_date',width:180">建立时间</th>
				<th data-options="field:'job_desc',width:250,sortable:true">描述</th>
				<th data-options="field:'id',width:80,align:'center',formatter:showButtons">操作</th>
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
	queryParams.sqlId = 'mproject-job-getProjectJobListByUser';
	queryParams.projectId = '${curProjectId}';
	queryParams.userId = '${loginUser.id}';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
	//$('#dg').datagrid('hideColumn', 'status'); 
});

function showStatusName(val,row){
	if (val == 'I'){
		return '<span>待处理</span>';
	} else if (val =='F'){
		return '<span>完成</span>';
	} else if (val =='N'){
		return '<span>未完成</span>';
	} else if (val =='Q'){
		return '<span>问题工单</span>';
	} else if (val =='C'){
		return '<span>工单取消</span>';
	}else{
		return val;
	}
}

function showTypeName(val,row){
	if (val == 'A'){
		return '<span>安装工单</span>';
	} else if (val =='T'){
		return '<span>调试工单</span>';
	} else if (val =='Q'){
		return '<span>其他工单</span>';
	}else{
		return val;
	}
}


function showButtons(val,row){
	var columnItem = "";
	if(row.status == 'I'){
		columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="cancelJob(\''+val+'\')" style="width:80px;">取消工单</a></span>&nbsp;&nbsp;';
	}
	return columnItem;
}

function cancelJob(jobId){
	$.messager.confirm('确认', '确认取消工单?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/job/mgr/revokeJob.do',
			    data:{
			    	'jobId':jobId
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$('#dg').datagrid('reload');
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

function doSearch(){
	var charKey = $("#inpKey" ).val();
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-job-getProjectJobListByUser';
	queryParams.projectId = '${curProjectId}';
	queryParams.userId = '${loginUser.id}';
	queryParams.projectName = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}
</script>
</body>
</html>