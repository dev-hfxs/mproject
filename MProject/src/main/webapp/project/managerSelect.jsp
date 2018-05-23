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
<title>用户列表</title>
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

<div class="easyui-layout" data-options="border:false,fit:true">
		<div data-options="region:'north',border:false" style="height:36px">
			<div id="qtb" class="easyui-panel datagrid-toolbar"  data-options="fit:true">
				<input class="easyui-numberbox" id="allowBoxNum" name="allowBoxNum" style="width: 150px" data-options="label:'应建机箱数 :',required:true,validType:'length[1,8]'">
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doConfim()" style="width:80px;">确 定</a>
				<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doCancel()" style="width:80px;">取 消</a>
			</div>
		</div>
		<div data-options="region:'center',border:false" style="height:400px;">
				<table id="dg" class="easyui-datagrid" style="height:400px;"
						data-options="singleSelect:true,rownumbers:true,pageSize:20,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'get'">
					<thead>
						<tr>
							<th data-options="field:'ck',checkbox:true"></th>
							<th data-options="field:'user_name',width:150">用户名</th>
							<th data-options="field:'full_name',width:80">姓名</th>
							<th data-options="field:'org_name',width:200">所在单位</th>
							<th data-options="field:'role_name',width:80">用户类型</th>
						</tr>
					</thead>
				</table>
		</div>
</div>
<script>
$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-user-getUsersForBuildManager';
	queryParams.projectId = '${curProjectId}';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		//var pageList = $('#dg').datagrid('options').pageList;
		//$('#dg').datagrid('options').pageSize = pageSize;
		$('#dg').datagrid('options').pageNumber = pageNum;
		
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
});

function doConfim(){
	var allowBoxNum = $('#allowBoxNum').val();
	if(allowBoxNum == null || allowBoxNum == ""){
		$.messager.alert('提示', "请分配施工经理应建的机箱数!");
		return;
	}
	var row = $('#dg').datagrid('getSelected');
	if (row){
		// 保存添加的项目人员
		$.ajax( {
		    url:'<%=path%>/project/mgr/addProjectPsn.do',
		    data:{
		    	'projectId':'${curProjectId}',
		    	'userId':row.id,
		    	'allowBoxNum':allowBoxNum
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data.returnCode == "success"){
		    		parent.okResponse('success');
		    	}else{
		    		$.messager.alert('提示',data.msg);
		    	}
		    },
		    error : function(data) {
		    	$.messager.alert('异常',data.responseText);
	        }
		});
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