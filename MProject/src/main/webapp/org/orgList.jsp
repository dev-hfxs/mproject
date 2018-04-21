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
<title>单位列表</title>
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
				<th data-options="field:'org_code',width:100,sortable:true">单位编码</th>
				<th data-options="field:'org_name',width:200,sortable:true">单位名称</th>
				<th data-options="field:'tax_number',width:200,sortable:true">单位税号</th>
				<th data-options="field:'address',width:250">地址</th>
				<th data-options="field:'telephone',width:100">电话</th>
				<th data-options="field:'contacts',width:100,formatter:showStatusName">联系人</th>
				<th data-options="field:'id',width:150,align:'center',formatter:showButtons">操作</th>
			</tr>
		</thead>
	</table>
</div>
<div id="tb" style="padding:2px 5px;">
		<input id="inpKey" class="easyui-textbox"  prompt="单位名" style="width:150px">
		<a href="#" class="easyui-linkbutton" onclick="doSearch()" iconCls="icon-search">查询&nbsp;&nbsp;</a>
</div>
<script>
	$(function() {
		var pageNum = "<%=pageNum%>";
		var pageSize = "<%=pageSize%>";
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams.sqlId = 'mproject-org-queryValidOrgs';
		if(pageNum != null && pageNum != 'null' && pageNum != ''){
			//var pageList = $('#dg').datagrid('options').pageList;
			//$('#dg').datagrid('options').pageSize = pageSize;
			$('#dg').datagrid('options').pageNumber = pageNum;
		}
		$('#dg').datagrid('reload');
		$('.pagination-page-list').hide();
	});

	function showStatusName(val,row){
		if (val == 'N'){
			return '<span>新建</span>';
		} else if (val =='R'){
			return '<span>恢复</span>';
		}else if(val =='D'){
			return '<span>删除</span>';
		}else{
			return val;
		}
	}
	
	function showButtons(val,row){
		var columnItem = '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:doUpdate(\''+val+'\')" style="width:80px;">修 改</a></span>&nbsp;&nbsp;'
                       + '<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="doDelete(\''+val+'\')" style="width:80px;">删 除</a></span>&nbsp;&nbsp;';
		return columnItem;
	}
	
	function doDelete(val){
		$.messager.confirm('确认', '确认删除该单位?', function(r){
			if(r){
				$.ajax( {
				    url:'<%=path%>/org/mgr/delete.do',
				    data:{
				    	'id':val
				    },
				    type:'post',
				    async:false,
				    dataType:'json',
				    success:function(data) {
				    	if(data.returnCode == "success"){
				    		parent.loadUrl("<%=path%>/org/orgList.jsp");
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
	
	function doUpdate(val){
		var queryParams = $('#dg').datagrid('options').queryParams;
		var options = $("#dg" ).datagrid("getPager" ).data("pagination" ).options;
	    var pageNum = options.pageNumber;
	    var pageSize = options.pageSize;
		var curUrl = "<%=path%>/org/orgEdit.jsp?id="+val+"&pageNum="+pageNum + "&pageSize="+pageSize;
		parent.loadUrl(curUrl);
	}
	
	function doSearch(){
		var charKey = $("#inpKey" ).val();
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams.sqlId = 'mproject-org-queryValidOrgs';
		queryParams.orgName = charKey;
		$('#dg').datagrid('reload');
	}
</script>
</body>
</html>