<%@ page pageEncoding="UTF-8"%>
<% 
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
	String projectId = request.getParameter("projectId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>查看机箱列表</title>
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
<div id="dgPanelBox" class="easyui-panel" data-options="fit:true,border:0">
	<table id="dg" class="easyui-datagrid"  
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',toolbar:'#tb',multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'box_number',width:110,sortable:true,formatter:fmBoxNum">机箱编号</th>
				<th data-options="field:'nfc_number',width:130,sortable:true">机箱NFC序列号</th>
				<th data-options="field:'create_date',width:130,sortable:true">创建时间</th>
				<th data-options="field:'longitude',width:100">经度</th>
				<th data-options="field:'latitude',width:100">纬度</th>
				<th data-options="field:'pos_desc',width:150">位置描述</th>
				<th data-options="field:'install_space',width:80">安装间距</th>
				<th data-options="field:'org_name',width:160">施工单位</th>
				<th data-options="field:'build_manager',width:100">施工经理</th>
				<th data-options="field:'submit_num',width:120">施工经理提交次数</th>
				<th data-options="field:'new_submit_date',width:130,sortable:true">最新提交时间</th>
				<th data-options="field:'install_engineer',width:130,sortable:true">安装工程师</th>
				<th data-options="field:'confirm_install_date',width:130,sortable:true">安装确认时间</th>
				<th data-options="field:'debug_engineer',width:130,sortable:true">调试工程师</th>
				<th data-options="field:'confirm_debug_date',width:130,sortable:true">调试确认时间</th>
				<th data-options="field:'pm_confirm_date',width:130,sortable:true">项目经理确认时间</th>
			</tr>
		</thead>
	</table>
	<div id="tb" style="padding:2px 5px;">
		<input id="inpKey" class="easyui-textbox"  prompt="机箱编号" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
	</div>
</div>
<div id="dgPanelProcessor" class="easyui-panel" data-options="fit:true,border:0">
	<table id="dg2" class="easyui-datagrid"  
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',toolbar:'#tb2',multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'nfc_number',width:130,sortable:true,formatter:fmPNFCNum">处理器NFC序列号</th>
				<th data-options="field:'moxa_number',width:100">MOXA序列号</th>
				<th data-options="field:'ip',width:100">IP地址</th>
				<th data-options="field:'detector_num',width:150">下属探测器数量</th>
				<th data-options="field:'box_nfc_number',width:130,sortable:true,formatter:fmBoxNFCNum">所属机箱NFC序列号</th>
			</tr>
		</thead>
	</table>
	<div id="tb2" style="padding:2px 5px;">
		<input id="inpKey2" class="easyui-textbox"  prompt="处理器NFC序列号" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch2()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
	</div>
</div>
<div id="dgPanelDetector" class="easyui-panel" data-options="fit:true,border:0">
	<table id="dg3" class="easyui-datagrid"  
			data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',toolbar:'#tb3',multiSort:true">
		<thead>
			<tr>
				<th data-options="field:'processor_nfc_number',width:130,sortable:true,formatter:fmProcessorNFCNum">所属处理器NFC序列号</th>
				<th data-options="field:'nfc_number',width:130,sortable:true">探测器NFC序列号</th>
				<th data-options="field:'longitude',width:100">经度</th>
				<th data-options="field:'latitude',width:100">纬度</th>
				<th data-options="field:'start_point',width:100">起点</th>
				<th data-options="field:'end_point',width:100">终点</th>
				<th data-options="field:'pos_desc',width:100">位置描述</th>
			</tr>
		</thead>
	</table>
	<div id="tb3" style="padding:2px 5px;">
		<input id="inpKey3" class="easyui-textbox"  prompt="探测器NFC序列号" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch3()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
	</div>
</div>
<script>
$(function() {
	$('#dgPanelProcessor').hide();
	$('#dgPanelDetector').hide();
	
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-getBoxList4ViewByProjectId';
	queryParams.projectId = '<%=projectId%>';
	if(pageNum != null && pageNum != 'null' && pageNum != '') {
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
});

function fmBoxNum(val,row){
	var columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showProcessor(\''+row.id+'\');" title="查看处理器"><span>'+val +'</span></a>';
	return columnHtml;
}

function fmPNFCNum(val,row){
	var columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showDetector(\''+row.id+'\');" title="查看探测器"><span>'+val +'</span></a>';
	return columnHtml;
}

function fmBoxNFCNum(val,row){
	var columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showBox(\'\');" title="查看所属机箱"><span>'+val +'</span></a>';
	return columnHtml;
}

function fmProcessorNFCNum(val,row){
	var columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showProcessor(\'\');" title="查看所属处理器"><span>'+val +'</span></a>';
	return columnHtml;
}

var curBoxId = '';
var curProcessId = '';

function showBox(projectId){
	$('#dgPanelBox').show();
	$('#dgPanelDetector').hide();
	$('#dgPanelProcessor').hide();
}

function showProcessor(boxId){
	$('#dgPanelBox').hide();
	$('#dgPanelDetector').hide();
	$('#dgPanelProcessor').show();
	//重新加载机箱的处理器
	if(boxId.length > 0){
		curBoxId = boxId;
		var queryParams = $('#dg2').datagrid('options').queryParams;
		queryParams.sqlId = 'mproject-project-getProcessorList4ViewByBoxId';
		queryParams.boxId = boxId;
		$('#dg2').datagrid('reload');
	}
	
}

function showDetector(processorId){
	//重新加载处理器下的探测器
	if(processorId.length > 0){
		curProcessId = processorId
		var queryParams = $('#dg3').datagrid('options').queryParams;
		queryParams.sqlId = 'mproject-project-getDetectorList4ViewByProcessorId';
		queryParams.processorId = processorId;
		$('#dg3').datagrid('reload');
	}
	
	$('#dgPanelBox').hide();
	$('#dgPanelProcessor').hide();
	$('#dgPanelDetector').show();
}

function doSearch(){
	var charKey = $("#inpKey" ).val();
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-getBoxList4ViewByProjectId';
	queryParams.projectId = '<%=projectId%>';
	queryParams.boxNumber = charKey;
	$('#dg').datagrid('loadData',{total:0,rows:[]});
	$('#dg').datagrid('reload');
}

function doSearch2(){
	var charKey = $("#inpKey2" ).val();
	var queryParams = $('#dg2').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-getProcessorList4ViewByBoxId';
	queryParams.boxId = curBoxId;
	queryParams.nfcNumber = charKey;
	$('#dg2').datagrid('loadData',{total:0,rows:[]});
	$('#dg2').datagrid('reload');
}

function doSearch3(){
	var charKey = $("#inpKey3" ).val();
	var queryParams = $('#dg3').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-project-getDetectorList4ViewByProcessorId';
	queryParams.processorId = curProcessorId;
	queryParams.nfcNumber = charKey;
	$('#dg3').datagrid('loadData',{total:0,rows:[]});
	$('#dg3').datagrid('reload');
}
</script>
</body>
</html>