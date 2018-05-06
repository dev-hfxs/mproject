<%@ page pageEncoding="UTF-8"%>
<% 
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
	String boxId = request.getParameter("boxId");
	String boxNumber = request.getParameter("boxNumber");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>处理器列表</title>
<script type="text/javascript" src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript" src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
<script type="text/javascript"	src="<%=path%>/js/json2.js"></script>
<style>
.icon-import{
	background:url('<%=path%>/js/easyui/themes/icons/table_import.png') no-repeat center center;
}
</style>
</head>
<body>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'north',border:false" style="height:240px">
		<table id="dg" class="easyui-datagrid"  
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true,toolbar:'#tb'">
			<thead>
				<tr>
					<th data-options="field:'nfc_number',width:200,sortable:true">处理器NFC序列号</th>
					<th data-options="field:'box_number',width:200,sortable:true">所属机箱编号</th>
					<th data-options="field:'moxa_number',width:200">MOXA-NFC序列号</th>
					<th data-options="field:'detector_num',width:100">下属探测器数量</th>
					<th data-options="field:'id',width:150,align:'center',formatter:showProcessorButtons">操作</th>
				</tr>
			</thead>
		</table>
		<div id="tb" style="padding:2px 5px;">
			<a href="#" class="easyui-linkbutton" onclick="addProcessor()" iconCls="icon-edit">添加处理器</a>
			<a href="#" class="easyui-linkbutton" onclick="doBack()" iconCls="icon-back">返回</a>
		</div>
	</div>
	<div data-options="region:'center',border:false">
		<table id="dg2" class="easyui-datagrid"  
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true,toolbar:'#tb2'">
			<thead>
				<tr>
					<th data-options="field:'nfc_number',width:200,sortable:true">探测器NFC序列号</th>
					<th data-options="field:'detector_seq',width:200,sortable:true">探测器编号</th>
					<th data-options="field:'longitude',width:100,sortable:true">经度</th>
					<th data-options="field:'latitude',width:200">纬度</th>
					<th data-options="field:'start_point',width:100,formatter:showStatus">起点</th>
					<th data-options="field:'end_point',width:100,formatter:showStatus">终点</th>
					<th data-options="field:'id',width:150,align:'center',formatter:showDetectorButtons">操作</th>
				</tr>
			</thead>
		</table>
		<div id="tb2" style="padding:2px 5px;">
			<a href="#" class="easyui-linkbutton" onclick="addDetector()" iconCls="icon-edit">添加探测器</a>
			<a href="#" class="easyui-linkbutton" onclick="importDetector()" iconCls="icon-filter">导入</a>
		</div>
	</div>
</div>

<script>
var curProcessorId;
$(function() {
	
	$('#dg').datagrid({
		onClickRow:function(rowIndex,rowData){
			curProcessorId = rowData.id;
			refreshDetector();
		}
	});
	
	$('#dg').datagrid({
		onLoadSuccess:function(data){
			if(data!=null && data.rows !=null && data.rows.length >0){
				curProcessorId = data.rows[0].id;
				refreshDetector();
			}
		}
	});
	
	
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-processor-getProcessorListByBoxId';
	queryParams.boxId = '<%=boxId%>';
	
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
});

function showProcessorButtons(val,row){
	var columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:updateProcesor(\''+val+'\')" style="width:80px;">修 改</a></span>&nbsp;&nbsp;'
				   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteProcessor(\''+val+'\')" style="width:80px;">删除</a></span>&nbsp;&nbsp;';
	              // + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="configDetector(\''+val+'\')" style="width:80px;">维护探测器</a></span>&nbsp;&nbsp;';
	return columnItem;
}

function showDetectorButtons(val,row){
	var columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:updateDetector(\''+val+'\')" style="width:80px;">修 改</a></span>&nbsp;&nbsp;'
				   + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteDetector(\''+val+'\')" style="width:80px;">删除</a></span>&nbsp;&nbsp;';
	              // + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="configDetector(\''+val+'\')" style="width:80px;">维护探测器</a></span>&nbsp;&nbsp;';
	return columnItem;
}

function addProcessor(){
	var content = '<iframe src="<%=path%>/processor/processorAdd.jsp?boxId=<%=boxId%>&boxNumber=<%=boxNumber%>" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="添加处理器" ></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '640',
		height : '480',
		modal : true,
		title : '添加处理器',
		onClose : function() {
			$(this).dialog('destroy');
		}
	});
	win.dialog('open');
	win.window('center');
}

function addDetector(){
	if(curProcessorId == null){
		$.messager.alert('提示','没有选择处理器,请先选择!');
		return;
	}
	var content = '<iframe src="<%=path%>/detector/detectorAdd.jsp?processorId='+curProcessorId+'" width="100%" height="90%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="添加探测器" ></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '640',
		height : '480',
		modal : true,
		title : '添加探测器',
		onClose : function() {
			$(this).dialog('destroy');
		}
	});
	win.dialog('open');
	win.window('center');
}


function updateProcesor(id){
	var content = '<iframe src="<%=path%>/processor/processorEdit.jsp?id=' + id + '" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="修改处理器" ></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '640',
		height : '480',
		modal : true,
		title : '修改处理器',
		onClose : function() {
			$(this).dialog('destroy');
		}
	});
	win.dialog('open');
	win.window('center');
}

function updateDetector(id){
	var content = '<iframe src="<%=path%>/detector/detectorEdit.jsp?id=' + id + '&processorId=' + curProcessorId + '" width="100%" height="90%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="修改探测器" ></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '640',
		height : '480',
		modal : true,
		title : '修改探测器',
		onClose : function() {
			$(this).dialog('destroy');
		}
	});
	win.dialog('open');
	win.window('center');
}

function importDetector(){
	if(curProcessorId == null){
		$.messager.alert('提示','没有选择处理器,请先选择!');
		return;
	}
	var content = '<iframe src="<%=path%>/detector/detectorImport.jsp?processorId='+curProcessorId+'" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
	var boarddiv = '<div id="msgwindow" title="导入探测器" ></div>'// style="overflow:hidden;"可以去掉滚动条
	$(document.body).append(boarddiv);
	var win = $('#msgwindow').dialog({
		content : content,
		width : '480',
		height : '320',
		modal : true,
		title : '导入探测器',
		onClose : function() {
			$(this).dialog('destroy');
		}
	});
	win.dialog('open');
	win.window('center');
}

function deleteProcessor(id){
	$.messager.confirm('确认', '确认删除该处理器?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/processor/mgr/delete.do',
			    data:{
			    	'id':id
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

function deleteDetector(id){
	$.messager.confirm('确认', '确认删除该探测器?', function(r){
		if(r){
			$.ajax( {
			    url:'<%=path%>/detector/mgr/delete.do',
			    data:{
			    	'id':id
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$('#dg2').datagrid('loadData',{total:0,rows:[]});
			    		$('#dg2').datagrid('reload');
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

function doBack(){
	parent.loadUrl("<%=path%>/project/machineBoxWrite.jsp");
}


function closeDialog() {
	$("#msgwindow").dialog('destroy');
}

function refreshProcessor(){
	$('#dg').datagrid('reload');
	//$("#msgwindow").dialog('destroy');
}

function refreshDetector(){
	var queryParams = $('#dg2').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-detector-getListByProcessorId';
	queryParams.processorId = curProcessorId;
	$('#dg2').datagrid('loadData',{total:0,rows:[]});
	$('#dg2').datagrid('reload');
	
}


function showStatus(val,row){
	if (val == 'Y'){
		return '<span>是</span>';
	} else if (val =='N'){
		return '<span>否</span>';
	}else{
		return val;
	}
}
</script>
</body>
</html>