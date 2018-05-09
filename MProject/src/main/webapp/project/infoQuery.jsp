<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>信息查询</title>
<script type="text/javascript"	src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript"	src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" type="text/css" 	href="<%=path%>/style/default/main.css">
<style>
.qtb{
	text-align:right;
}
</style>
</head>
<body>
	<div class="easyui-layout" data-options="fit:true,border:false">
		<div data-options="region:'north',border:false" style="height:36px">
			<div id="qtb" class="easyui-panel datagrid-toolbar"  data-options="fit:true">
				<select class="easyui-combobox" id="queryType" name="queryType" label="查询方式 :" style="width:200px;" panelHeight="auto"><option value="P">项目</option><option value="M">机箱</option><option value="C">处理器</option><option value="D">探测器</option></select>
				<input class="easyui-textbox" id="searchKey" name="searchKey" style="width: 200px;left:5px;"	data-options="label:'查询内容 :'">
				<input class="easyui-textbox" id="searchCode" name="searchCode" style="width: 200px"	data-options="label:'查询验证码 :'">
				<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
			</div>
		</div>
		<div data-options="region:'center',title:'查询结果',border:false">
			<div id="dgPanelProject" style="height:100%;width:100%;">
				<table id="dg" class="easyui-datagrid"
						data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true">
					<thead>
						<tr>
							<th data-options="field:'project_number',width:100,formatter:fmPojectNum">项目编号</th>
							<th data-options="field:'project_name',width:200">项目名称</th>
							<th data-options="field:'contract_number',width:100">合同号</th>
							<th data-options="field:'project_manager',width:200">项目经理</th>
							<th data-options="field:'creator',width:100">创建人</th>
							<th data-options="field:'create_date',width:150">创建时间</th>
							<th data-options="field:'status',width:60,formatter:fmStatusName">项目状态</th>
						</tr>
					</thead>
				</table>
			</div>
			<!-- 机箱查询结果 -->
			<div id="dgPanelBox" style="height:100%;width:100%;">
				<table id="dg1" class="easyui-datagrid"
						data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true">
					<thead>
						<tr>
							<th data-options="field:'box_number',width:110,formatter:fmBoxNum">机箱编号</th>
							<th data-options="field:'nfc_number',width:130">机箱NFC序列号</th>
							<th data-options="field:'project_number',width:130,formatter:fmBoxProjectNum">所属项目编号</th>
							<th data-options="field:'create_date',width:130">创建时间</th>
							<th data-options="field:'longitude',width:100">经度</th>
							<th data-options="field:'latitude',width:100">纬度</th>
							<th data-options="field:'pos_desc',width:150">位置描述</th>
							<th data-options="field:'install_space',width:80">安装间距</th>
							<th data-options="field:'org_name',width:160">施工单位</th>
							<th data-options="field:'build_manager',width:100">施工经理</th>
							<th data-options="field:'submit_num',width:120">施工经理提交次数</th>
							<th data-options="field:'new_submit_date',width:130">最新提交时间</th>
							<!-- 
							<th data-options="field:'install_engineer',width:130">安装工程师</th>
							<th data-options="field:'confirm_install_date',width:130">安装确认时间</th>
							<th data-options="field:'debug_engineer',width:130">调试工程师</th>
							<th data-options="field:'confirm_debug_date',width:130">调试确认时间</th>
							<th data-options="field:'pm_confirm_date',width:130">项目经理确认时间</th>
							 -->
						</tr>
					</thead>
				</table>
			</div>
			<!-- 处理器查询结果 -->
			<div id="dgPanelProcessor" style="height:100%;width:100%;">
				<table id="dg2" class="easyui-datagrid"
						data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true">
					<thead>
						<tr>
							<th data-options="field:'nfc_number', width:160, formatter:fmPNFCNum">处理器NFC序列号</th>
							<th data-options="field:'box_nfc_number', width:150, formatter:fmBoxNFCNum">所属机箱NFC序列号</th>
							<th data-options="field:'moxa_nfc_number',align:'right', width:100">MOXA序列号</th>
							<th data-options="field:'ip', width:150">IP地址</th>
							<th data-options="field:'detector_num',align:'center'" width="100">下属探测器数量</th>
						</tr>
					</thead>
				</table>
			</div>
			<!-- 显示探测器 -->
			<div id="dgPanelDetector" style="height:100%;width:100%;">
				<table id="dg3" class="easyui-datagrid"
						data-options="singleSelect:true,rownumbers:true,pageSize:20,fit:true,url:'<%=path%>/comm/queryForPage.do',pagination:true,method:'post',multiSort:true">
					<thead>
						<tr>
							<th data-options="field:'processor_nfc_number',width:130,sortable:true,formatter:fmProcessorNFCNum">所属处理器NFC序列号</th>
							<th data-options="field:'nfc_number',width:130,sortable:true">探测器NFC序列号</th>
							<th data-options="field:'longitude',width:100">经度</th>
							<th data-options="field:'latitude',width:100">纬度</th>
							<th data-options="field:'start_point',width:100,formatter:fmPoint">起点</th>
							<th data-options="field:'end_point',width:100,formatter:fmPoint">终点</th>
							<th data-options="field:'pos_desc',width:100">位置描述</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
	</div>
<script type="text/javascript">

var queryProject = '';
var gotoProject = false;
var gotoBox = false;
var gotoProcessor = false;
var gotoDetector = true;

	$(function() {
		$(".textbox-label.textbox-label-before").css('text-align','right').css('width','auto');
		$("#dgPanelProject").hide();
		$("#dgPanelBox").hide();
		$("#dgPanelProcessor").hide();
		$("#dgPanelDetector").hide();
		$('.pagination-page-list').hide();
	});

	function fmPojectNum(val,row){
		var columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showBox(\''+row.id+'\');" title="查看项目下的机箱"><span>'+val +'</span></a>';
		return columnHtml;
	}

	function fmBoxNum(val,row){
		var columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showProcessor(\''+row.id+'\');" title="查看处理器"><span>'+val +'</span></a>';
		return columnHtml;
	}
	
	function fmBoxProjectNum(val,row){
		var columnHtml = '';
		if(gotoProject){
			columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showProject(\'\');" title="查看所属项目"><span>'+val +'</span></a>';
		}else{
			columnHtml = '<span>'+val +'</span>';
		}
		return columnHtml;
	}
	
	function fmPNFCNum(val,row){
		var columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showDetector(\''+row.id+'\');" title="查看探测器"><span>'+val +'</span></a>';
		return columnHtml;
	}

	function fmBoxNFCNum(val,row){
		var columnHtml = '';
		if(gotoBox){
			columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showBox(\'\');" title="查看所属机箱"><span>'+val +'</span></a>';
		}else{
			columnHtml = '<span>'+val +'</span>';
		}
		return columnHtml;
	}

	function fmProcessorNFCNum(val,row){
		var columnHtml = '';
		if(gotoProcessor){
		    columnHtml = '<a style="color:blue;text-decoration:underline;cursor:pointer" onclick="javascript:showProcessor(\'\');" title="查看所属处理器"><span>'+val +'</span></a>';
		}else{
			columnHtml = '<span>'+val +'</span>';
		}
		return columnHtml;
	}

	function fmStatusName(val,row){
		if (val == 'I'){
			return '<span>在建</span>';
		} else if (val =='F'){
			return '<span>完成</span>';
		}else{
			return val;
		}
	}
	
	function fmPoint(val,row){
		if (val == 'Y'){
			return '<span>是</span>';
		} else if (val =='N'){
			return '<span>否</span>';
		}else{
			return val;
		}
	}
	
	function showProject(projectId){
		if(gotoProject == false){
			return;
		}
		$('#dgPanelProject').show();
		$('#dgPanelBox').hide();
		$('#dgPanelDetector').hide();
		$('#dgPanelProcessor').hide();
	}
	
	function showBox(projectId){
		if(gotoBox == false){
			return;
		}
		$('#dgPanelProject').hide();
		$('#dgPanelBox').show();
		$('#dgPanelDetector').hide();
		$('#dgPanelProcessor').hide();
		//重新加载项目下的机箱
		if(projectId.length > 0){
			var queryParams = $('#dg1').datagrid('options').queryParams;
			queryParams.sqlId = 'mproject-query-getBoxByBoxNumber';
			queryParams.projectId = projectId;
			$('#dg1').datagrid('reload');
		}
	}

	function showProcessor(boxId){
		if(gotoProcessor == false){
			return;
		}
		$('#dgPanelProject').hide();
		$('#dgPanelBox').hide();
		$('#dgPanelProcessor').show();
		$('#dgPanelDetector').hide();
		//重新加载机箱的处理器
		if(boxId.length > 0){
			var queryParams = $('#dg2').datagrid('options').queryParams;
			queryParams.sqlId = 'mproject-project-getProcessorList4ViewByBoxId';
			queryParams.boxId = boxId;
			$('#dg2').datagrid('reload');
		}
	}

	function showDetector(processorId){
		$('#dgPanelProject').hide();
		$('#dgPanelBox').hide();
		$('#dgPanelProcessor').hide();
		$('#dgPanelDetector').show();
		
		//重新加载处理器下的探测器
		if(processorId.length > 0){
			var queryParams = $('#dg3').datagrid('options').queryParams;
			queryParams.sqlId = 'mproject-project-getDetectorList4ViewByProcessorId';
			queryParams.processorId = processorId;
			$('#dg3').datagrid('reload');
		}
	}
	
	function doSearch(){
		var queryType = $("#queryType" ).val();
		var charKey = $("#searchKey" ).val();
		var searchCode = $("#searchCode" ).val();
		//发起查询请求
		$.ajax( {
		    url:'<%=path%>/query/mgr/queryInfo.do',
		    data:{
		    	'queryType':queryType,
		    	'searchValue':charKey,
		    	'searchCode':searchCode
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data.returnCode != null && data.returnCode =='success'){
		    		//成功查询到数据
		    		queryProject = data.queryProject;
		    		if(data.codeType =='P'){
		    			gotoProject = true;
		    			gotoBox = true;
		    			gotoProcessor = true;
		    			$("#dgPanelProject").show();
		    			$("#dgPanelBox").hide();
		    			$("#dgPanelProcessor").hide();
		    			$("#dgPanelDetector").hide();
		    			var queryParams = $('#dg').datagrid('options').queryParams;
		    			queryParams.sqlId = 'mproject-query-getProjectByNumber';
		    			queryParams.projectId = queryProject;
		    			queryParams.projectNumber = charKey;
		    			$('#dg').datagrid('reload');
		    		}else if(data.codeType == 'M'){
		    			gotoProject = false;
		    			gotoBox = true;
		    			gotoProcessor = true;
		    			$("#dgPanelProject").hide();
		    			$("#dgPanelBox").show();
		    			$("#dgPanelProcessor").hide();
		    			$("#dgPanelDetector").hide();
		    			var queryParams = $('#dg1').datagrid('options').queryParams;
		    			queryParams.sqlId = 'mproject-query-getBoxByBoxNumber';
		    			queryParams.projectId = queryProject;
		    			queryParams.boxNumber = charKey;
		    			$('#dg1').datagrid('reload');
		    		}else if(data.codeType == 'C'){
		    			gotoProject = false;
		    			gotoBox = false;
		    			gotoProcessor = true;
		    			$("#dgPanelProject").hide();
		    			$("#dgPanelBox").hide();
		    			$("#dgPanelProcessor").show();
		    			$("#dgPanelDetector").hide();
		    			var queryParams = $('#dg2').datagrid('options').queryParams;
		    			queryParams.sqlId = 'mproject-query-getProcessorByNfcNumber';
		    			queryParams.projectId = queryProject;
		    			queryParams.nfcNumber = charKey;
		    			$('#dg2').datagrid('reload');
		    		}else if(data.codeType == 'D'){
		    			gotoProject = false;
		    			gotoBox = false;
		    			gotoProcessor = false;
		    			$("#dgPanelProject").hide();
		    			$("#dgPanelBox").hide();
		    			$("#dgPanelProcessor").hide();
		    			$("#dgPanelDetector").show();
		    			var queryParams = $('#dg3').datagrid('options').queryParams;
		    			queryParams.sqlId = 'mproject-query-getDetectorByNfcNumber';
		    			queryParams.projectId = queryProject;
		    			queryParams.nfcNumber = charKey;
		    			$('#dg3').datagrid('reload');
		    			
		    		}
		    	}else{
		    		$.messager.alert('提示', data.msg);
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