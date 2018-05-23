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
<title>修改记录查询</title>
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
				<th data-options="field:'user_name',width:180">修改人</th>
				<th data-options="field:'operation_part',width:200, formatter:fmOperationType">修改部分</th>
				<th data-options="field:'update_field',width:200,formatter:fmUpdateField">修改字段</th>
				<th data-options="field:'old_value',width:200">修改前内容</th>
				<th data-options="field:'new_value',width:200">修改后内容</th>
				<th data-options="field:'operation_date',width:200">修改时间</th>
			</tr>
		</thead>
	</table>
</div>
<div id="tb" style="text-align: left; padding: 1px 0">
		&nbsp;<input type="text" id="operationPart" name="operationPart"></input>
</div>
<script>

var partOptions = [{'name':'','text':'所有','selected':true},{'name':'box','text':'机箱'},{ 'name':'processor', 'text':'处理器'},{ 'name':'detector', 'text':'探测器'}];

$(function() {
	$('#operationPart').combobox({
	    data: partOptions,
	    valueField:'name',
	    textField:'text',
	    label:'修改部分:',
	    panelHeight:'auto',
	    width:'250px',
	    onChange:function(){
	    	var curValue =  $(this).combobox('getValue');
	    	var queryParams = $('#dg').datagrid('options').queryParams;
	    	queryParams.sqlId = 'mproject-log-getUpdateInfoLog';
	    	queryParams.operationPart = curValue;
	    	$('#dg').datagrid('loadData',{total:0,rows:[]});
	    	$('#dg').datagrid('reload');
	    }
	});
	
	var pageNum = "<%=pageNum%>";
	var pageSize = "<%=pageSize%>";
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams.sqlId = 'mproject-log-getUpdateInfoLog';
	if(pageNum != null && pageNum != 'null' && pageNum != ''){
		$('#dg').datagrid('options').pageNumber = pageNum;
	}
	$('#dg').datagrid('reload');
	$('.pagination-page-list').hide();
	
	//$('#dg').datagrid('hideColumn', 'status'); 
});

function fmUpdateField(val,row){
	if (val == 'box_number'){
		return '<span>机箱编号</span>';
	} else if (val =='create_date'){
		return '<span>创建时间</span>';
	} else if (val =='longitude'){
		return '<span>经度</span>';
	} else if (val =='latitude'){
		return '<span>纬度</span>';
	} else if (val =='pos_desc'){
		return '<span>位置描述</span>';
	} else if (val =='moxa_number'){
		return '<span>MOXA-NFC序列号</span>';
	} else if (val =='ip'){
		return '<span>IP地址</span>';
	} else if (val =='start_pos'){
		return '<span>起点</span>';
	} else if (val =='edn_pos'){
		return '<span>终点</span>';
	}else{
		return val;
	}
}

function fmOperationType(val,row){
	if (val == 'box'){
		return '<span>机箱</span>';
	} else if (val =='processor'){
		return '<span>处理器</span>';
	} else if (val =='detector'){
		return '<span>探测器</span>';
	}else{
		return val;
	}
}


</script>
</body>
</html>