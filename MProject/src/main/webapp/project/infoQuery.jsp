<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>项目管理系统</title>
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
				<select class="easyui-combobox" id="sex" name="sex" label="查询方式 :" style="width:200px;" panelHeight="auto"><option value="project">项目</option><option value="box">机箱</option><option value="processor">处理器</option><option value="detector">探测器</option></select>
				<input class="easyui-textbox" id="fullName" name="searchKey" style="width: 200px;left:5px;"	data-options="label:'查询内容 :'">
				<input class="easyui-textbox" id="fullName" name="searchCode" style="width: 200px"	data-options="label:'查询验证码 :'">
				<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
			</div>
		</div>
		<div data-options="region:'center',title:'查询结果',border:false">
			<div id="dgProject" style="height:100%;width:100%;">
				<table class="easyui-datagrid"
						data-options="url:'',method:'post',border:false,singleSelect:true,fit:true,fitColumns:true">
					<thead>
						<tr>
							<th data-options="field:'project_number',width:100,sortable:true">项目编号</th>
							<th data-options="field:'project_name',width:200,sortable:true">项目名称</th>
							<th data-options="field:'contract_number',width:100,sortable:true">合同号</th>
							<th data-options="field:'project_manager',width:200">项目经理</th>
							<th data-options="field:'creator',width:100">创建人</th>
							<th data-options="field:'create_date',width:150,sortable:true">创建时间</th>
							<th data-options="field:'status',width:60,formatter:showStatusName,sortable:true">项目状态</th>
						</tr>
					</thead>
				</table>
			</div>
			<!-- -->
			<div id="dgProcessor" style="height:100%;width:100%;">
				<table class="easyui-datagrid"
						data-options="url:'',method:'post',border:false,singleSelect:true,fit:true,fitColumns:true">
					<thead>
						<tr>
							<th data-options="field:'itemid'" width="100">NFC序列号</th>
							<th data-options="field:'productid'" width="150">所属机箱</th>
							<th data-options="field:'listprice',align:'right'" width="100">处理器ID</th>
							<th data-options="field:'unitcost',align:'right'" width="100">MOXA序列号</th>
							<th data-options="field:'attr1'" width="150">IP地址</th>
							<th data-options="field:'status',align:'center'" width="100">下属探测器数量</th>
						</tr>
					</thead>
				</table>
			</div>
			 
		</div>
	</div>
	
<script type="text/javascript">
	$(function() {
		$(".textbox-label.textbox-label-before").css('text-align','right').css('width','auto');
		$("#dgProject").hide();
		$("#dgProcessor").hide();
		//$("#dgProcessor").show();
		//$("#dgProject").show();
		
	});

	function showStatusName(){
		
	}
</script>

	</script>
</body>

</html>