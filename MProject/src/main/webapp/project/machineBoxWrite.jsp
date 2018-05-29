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
<title>机箱填写</title>
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
			data-options="singleSelect:true,rownumbers:true,pageSize:30,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'box_number',width:150,sortable:true">机箱编号</th>
				<th data-options="field:'nfc_number',width:150,sortable:true">NFC序列号</th>
				<th data-options="field:'longitude',width:200,sortable:true">经度</th>
				<th data-options="field:'latitude',width:100,sortable:true">纬度</th>
				<th data-options="field:'processor_num',width:200">包含处理器数量</th>
				<th data-options="field:'submit_num',width:100">提交次数</th>
				<th data-options="field:'id',width:300,align:'center',formatter:showButtons">操作</th>
			</tr>
		</thead>
	</table>
</div>
<script>

$(function() {
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-box-getUserBoxsList';
	queryParams.userId = '${loginUser.id}';
	queryParams.projectId = '${curProjectId}';
	
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
	//$('#dg').datagrid('hideColumn', 'status'); 
});

function refreshDataGrid(){
	$('#dg').datagrid('reload');
}

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
	var columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="updateBox(\''+val+'\')" style="width:80px;">修改</a></span>&nbsp;&nbsp;'
				   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:configProcessor(\''+row.id+'\',\'' + row.box_number +'\')" style="width:80px;">维护处理器</a></span>&nbsp;&nbsp;'
                   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitBox(\''+val+'\')" style="width:80px;">提交信息</a></span>&nbsp;&nbsp;'
                   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteBox(\''+val+'\')" style="width:80px;">删除信息</a></span>&nbsp;&nbsp;'
                   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="printDevice(\''+val+'\')" style="width:80px;">打印安装表</a></span>&nbsp;&nbsp;';
	return columnItem;
}

function printDevice(boxId){
	window.open ('<%=path%>/report/deviceInfo.jsp?boxId=' + boxId, '探测器安装记录表', 'height=900, width=960, top=20, left=100, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
}

function configProcessor(boxId,boxNumber){
	parent.loadUrl("<%=path%>/processor/processorList.jsp?boxId=" + boxId + "&boxNumber=" + boxNumber);
}

function updateBox(boxId){
	var content = '<iframe src="<%=path%>/box/machineBoxEdit.jsp?boxId='+boxId+'" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="修改机箱" ></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '640',
		height : '480',
		modal : true,
		title : '修改机箱',
		onClose : function() {
			$(this).dialog('destroy');
		}
	});
	win.dialog('open');
	win.window('center');
}

function submitBox(boxId){
	$.messager.confirm('确认', '确认提交该机箱?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/box/mgr/submit.do',
			    data:{
			    	'id':boxId
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示','提交成功!','info',function(){
			    			$('#dg').datagrid('loadData',{total:0,rows:[]});
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

function deleteBox(boxId){
	$.messager.confirm('确认', '确认删除该机箱?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/box/mgr/delete.do',
			    data:{
			    	'id':boxId
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$('#dg').datagrid('loadData',{total:0,rows:[]});
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
	queryParams.sqlId = 'mproject-project-queryProjects';
	queryParams.projectName = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}
</script>
</body>
</html>