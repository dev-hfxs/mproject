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
<title>当前项目管理</title>
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
			data-options="singleSelect:true,rownumbers:true,pageSize:30,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',toolbar:'#tb',multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'box_number',width:110,sortable:true">机箱编号</th>
				<th data-options="field:'box_number',width:130,sortable:true">机箱NFC序列号</th>
				<th data-options="field:'create_date',width:130,sortable:true">创建时间</th>
				<th data-options="field:'longitude',width:100">经度</th>
				<th data-options="field:'latitude',width:100">纬度</th>
				<th data-options="field:'pos_desc',width:200">位置描述</th>
				<th data-options="field:'processor_num',width:120">包含处理器数量</th>
				<th data-options="field:'user_name',width:100">施工经理</th>
				<th data-options="field:'submit_num',width:120">施工经理提交次数</th>
				<th data-options="field:'new_submit_date',width:130,sortable:true">最新提交时间</th>
				<th data-options="field:'job_type',width:120,align:'center',formatter:showCurJob">当前工单</th>
				<th data-options="field:'id',width:300,align:'center',formatter:showButtons">操作</th>
			</tr>
		</thead>
	</table>
</div>
<div id="tb" style="padding:2px 5px;">
		<input id="inpKey" class="easyui-textbox"  prompt="机箱编号" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
</div>
<script>
$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-getCurProjectBoxList4Engineer';
	queryParams.projectId = '${curProjectId}';
	if(pageNum != null && pageNum != 'null' && pageNum != '') {
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
});

function showButtons(val,row){
	var curJobProcessing = false;
	if(row.job_type != null && row.job_status != null && row.job_status =='I'){
		curJobProcessing = true;
	}
	var columnItem = '';
	if(row.pm_confirm_date != null && row.pm_confirm_date.length > 0){
		
		//已验收
	}else{
		if(row.submit_num > 0){
			if(row.enable_edit =='N'){
				//提交过且没有验收,且未设置允许修改
				if(curJobProcessing){
					columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doAccept(1,\''+row.project_id+'\',\''+ row.id + '\')" style="width:80px;">确认验收</a></span>&nbsp;&nbsp;';
				}else{
					columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doEnableEdit(\''+row.project_id+'\',\''+ row.id + '\')" style="width:80px;">允许修改</a></span>&nbsp;&nbsp;';
					columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="publishJob(0,\''+row.project_id+'\',\''+ row.id + '\')" style="width:80px;">发布工单</a></span>&nbsp;&nbsp;';
					columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doAccept(0,\''+row.project_id+'\',\''+ row.id + '\')" style="width:80px;">确认验收</a></span>&nbsp;&nbsp;';
				}
			}else if (row.enable_edit =='Y'){
				// 允许修改 后不显示操作( 限制发布工单、确认验收)
			}else{
				// 提交过且未验收
				if(curJobProcessing){
					columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doAccept(1,\''+row.project_id+'\',\''+ row.id + '\')" style="width:80px;">确认验收</a></span>&nbsp;&nbsp;';
				}else{
					columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doEnableEdit(\''+row.project_id+'\',\''+ row.id + '\')" style="width:80px;">允许修改</a></span>&nbsp;&nbsp;';
					columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="publishJob(0,\''+row.project_id+'\',\''+ row.id + '\')" style="width:80px;">发布工单</a></span>&nbsp;&nbsp;';
					columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doAccept(0,\''+row.project_id+'\',\''+ row.id + '\')" style="width:80px;">确认验收</a></span>&nbsp;&nbsp;';
				}
			}
		}
	}
	columnItem = columnItem + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="printDevice(\''+ row.id + '\')" style="width:80px;">打印安装表</a></span>&nbsp;&nbsp;';
	return columnItem;
}

function showCurJob(val,row){
	var columnItem = '';
	if(row.job_type != null && row.job_status != null){
		if(row.job_type == 'A'){
			columnItem = '安装工单';
		}else if(row.job_type == 'T'){
			columnItem = '调试工单';
		}else if(row.job_type == 'Q'){
			columnItem = '其他工单';
		}
		
		if(row.job_status == 'I'){
			columnItem = columnItem + ' : 处理中';
		}else if(row.job_status == 'F'){
			columnItem = columnItem + ' : 完成';
		}else if(row.job_status == 'Q'){
			columnItem = columnItem + ' : 问题工单';
		}else if(row.job_status == 'N'){
			columnItem = columnItem + ' : 未完成';
		}else if(row.job_status == 'C'){
			columnItem = columnItem + ' : 取消';
		}
	}else{
		columnItem = '无';
	}
	return columnItem;
}

function publishJob(curJobs,projectId,boxId){
	//当前有未处理的工单,则不让发布工单
	if(curJobs == 1){
		$.messager.alert('提示', '当前机箱有工单在处理, 需处理完再发布工单.');
		return;
	}
	parent.loadUrl("<%=path%>/job/publishJob.jsp?projectId=" + projectId + "&boxId=" + boxId);
}


function doEnableEdit(projectId,boxId){
	$.messager.confirm('确认', '确认允许修改?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/box/mgr/reset/status.do',
			    data:{
			    	'projectId':projectId,
			    	'boxId':boxId
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示','操作成功','info',function(){
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

function doAccept(curJobs,projectId,boxId){
	if(curJobs == 1){
		$.messager.alert('提示', '当前机箱有工单在处理, 需处理完再确认验收.');
		return;
	}
	
	var content = '<iframe src="<%=path%>/box/boxAccept.jsp?boxId='+boxId+'" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="机箱确认验收" style="overflow:hidden;"></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '560',
		height : '420',
		modal : true,
		title : '机箱确认验收',
		onClose : function() {
			$(this).dialog('destroy');
		}
	});
	win.dialog('open');
	win.window('center');
}

function okResponse(){
	$("#msgwindow").dialog('destroy');
	$('#dg').datagrid('reload');
}

function doSearch(){
	var charKey = $("#inpKey" ).val();
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-getCurProjectBoxList4Engineer';
	queryParams.projectId = '${curProjectId}';
	queryParams.boxNumber = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}

function printDevice(boxId){
	window.open ('<%=path%>/report/deviceInfo.jsp?boxId=' + boxId, '探测器安装记录表', 'height=900, width=960, top=20, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}

</script>
</body>
</html>