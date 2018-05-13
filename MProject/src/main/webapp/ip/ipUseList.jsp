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
<title>IP地址使用</title>
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
				<th data-options="field:'id',width:250,align:'center',formatter:fmButtons">操作</th>
			</tr>
		</thead>
	</table>
	<div id="tb" style="text-align: left; padding: 1px 0">
		&nbsp;<input id="projectId" style="width:200px">
	</div>
</div>
<script>
	$(function() {
		//获取所有的项目
		$.ajax( {
		    url:'<%=path%>/comm/queryForList.do',
		    data:{
		    	'sqlId':'mproject-project-queryProjects'
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	var arrProjects = [];
		    	if(data!=null && data.length > 0){
		    		arrProjects = data;
		    	}
		    	$('#projectId').combobox({
				    data: arrProjects,
				    valueField:'id',
				    textField:'project_name',
				    label:'IP所属项目: ',
				    panelHeight:'auto',
				    width:'300px',
				    onChange:function(){
				    	var queryParams = $('#dg').datagrid('options').queryParams;
						queryParams.sqlId = 'mproject-ip-getCanUseIPList';
						queryParams.projectId = $(this).combobox('getValue');
						queryParams.userId = '${loginUser.id}';
						$('#dg').datagrid('loadData',{total:0,rows:[]});
						$('#dg').datagrid('reload');
				    }
				});
		    },
		    error : function(data) {
		    	$.messager.alert('异常',data.responseText);
	        }
		});
		
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams.sqlId = 'mproject-ip-getCanUseIPList';
		queryParams.userId = '${loginUser.id}';
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
			return '<span>IP不可用</span>';
		}else{
			return val;
		}
	}
	
	function fmButtons(val,row){
		var columnItem = '';
		if(row.status == 'N'){
			columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="lockIp(\''+val+'\')" style="width:80px;">锁 定</a></span>&nbsp;&nbsp;';			
		}else if(row.status == 'L'){
			columnItem =  columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="unLockIp(\''+val+'\')" style="width:80px;">取消锁定</a></span>&nbsp;&nbsp;';
			columnItem =  columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="setIPUsed(\''+val+'\')" style="width:80px;">标记使用</a></span>&nbsp;&nbsp;';
			columnItem =  columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="setIPInValid(\''+val+'\')" style="width:80px;">标记不可用</a></span>&nbsp;&nbsp;';
		}else if(row.status == 'Y' && (row.processor_id == null || row.processor_id.length < 1)){
			columnItem =  columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="setIPUnUsed(\''+val+'\')" style="width:80px;">取消使用</a></span>&nbsp;&nbsp;';
		}else if(row.status == 'Q'){
			columnItem =  columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="setIPValid(\''+val+'\')" style="width:80px;">取消不可用</a></span>&nbsp;&nbsp;';
		}else{
			
		}
		return columnItem;
	}
	
	function lockIp(ipID){
		updateIPStatus(ipID, 'L');
	}
	
	function unLockIp(ipID){
		updateIPStatus(ipID, 'N');
	}
	
	function setIPUsed(ipID){
		updateIPStatus(ipID, 'Y');
	}
	
	function setIPInValid(ipID){
		updateIPStatus(ipID, 'Q');
	}
	
	function setIPUnUsed(ipID){
		updateIPStatus(ipID, 'N');
	}
	
	function setIPValid(ipID){
		updateIPStatus(ipID, 'N');
	}
	
	function updateIPStatus(ipID, status){
		$.ajax( {
		    url:'<%=path%>/ip/mgr/updateStatus.do',
		    data:{
		    	'id' : ipID,
		    	'status': status
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data.returnCode == "success"){
		    		$.messager.alert('提示', '操作成功!', 'info', function(){
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
</script>
</body>
</html>