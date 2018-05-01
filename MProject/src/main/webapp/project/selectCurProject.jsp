<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
    //Map<String,Object> loginUser = (Map<String,Object>)request.getSession().getAttribute("loginUser");
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>选择当前项目</title>
<script type="text/javascript"	src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript"	src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
</head>
<body>
	<div style="margin: 20px 0;"></div>
	<div class="easyui-panel"
		style="width: 100%; max-width: 460px; padding: 30px 60px; border-width:0" >
		<div style="margin-bottom:20px"> 
				<input class="easyui-combobox" id="curProjectId" name="curProjectId" label="当前项目:"  panelHeight="auto" style="width:100%" 
					data-options="valueField:'id',textField:'project_name'">
		</div>
	</div>
	
	<div class="easyui-panel"
		style="width: 100%; max-width: 460px; padding: 30px 60px; border-width:0" >
		<table>
			<tr>
				<td width="100px" height="40">项目名称:</td>
				<td><span id="spanPName"></span></td>
			</tr>
			<tr>
				<td width="100px" height="40">项目编号:</td>
				<td><span id="spanPNumber"></span></td>
			</tr>
			<tr>
				<td width="100px" height="40">项目经理:</td>
				<td><span id="spanPManager"></span></td>
			</tr>
			<tr>
				<td width="100px" height="40">项目应建机箱数:</td>
				<td><span id="spanPAllowBoxNum"></span></td>
			</tr>
			<tr>
				<td width="100px" height="40">项目创建时间:</td>
				<td><span id="spanPCreateDate"></span></td>
			</tr>
		</table>
	</div>
	
	<script>
	
	$(function() {
		var roleType = '${loginUser.role_type}';
		var curProjectId = '${curProjectId}';
		var sqlId = '';
		if('E' == roleType){
			sqlId = 'mproject-project-getEngineerUserProjects';
		}
		if('B' == roleType){
			sqlId = 'mproject-project-getManagerUserProjects';
		}
		
		$('#curProjectId').combobox({onChange: function(newValue,oldValue){
				$.ajax( {
				    url:'<%=path%>/auth/changeCurProject.do',
				    data:{
				    	'projectId':newValue
				    },
				    type:'post',
				    async:false,
				    dataType:'json',
				    success:function(data) {
				    	
				    }
				});
				$.ajax( {
					url:'<%=path%>/comm/queryForList.do',
				    data:{
				    	'sqlId':'mproject-project-queryProjectById',
				    	'projectId':newValue
				    },
				    type:'post',
				    async:false,
				    dataType:'json',
				    success:function(data) {
				    	if(data !=null && data.length >0){
				    		var item = data[0];
					    	$('#spanPName').text(item.project_name);
		    				$('#spanPNumber').text(item.project_number);
		    				$('#spanPManager').text(item.full_name);
		    				$('#spanPAllowBoxNum').text(item.allow_box_num);
		    				$('#spanPCreateDate').text(item.create_date);
				    	}
				    }
				});
			}
		});
		
		$.ajax( {
		    url:'<%=path%>/comm/queryForList.do',
		    data:{
		    	'sqlId':sqlId,
		    	'userId':'${loginUser.id}'
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data.length >0){
		    		//data = [{'id':'1211','project_name':'aaa','selected':'true'},{'id':'1212','project_name':'bbb'}];
		    		var newData = [];
		    		$.each(data,function(i,item){
		    			if(item.id == curProjectId){
		    				item['selected'] = true;
		    				$('#spanPName').text(item.project_name);
		    				$('#spanPNumber').text(item.project_number);
		    				$('#spanPManager').text(item.full_name);
		    				$('#spanPAllowBoxNum').text(item.allow_box_num);
		    				$('#spanPCreateDate').text(item.create_date);
		    			}
		    			newData[i] = item;
		    		});
		    		$('#curProjectId').combobox('loadData', newData);
		    		//$('#curProjectId').combobox('select',curProjectId);
		    	}else{
		    		$.messager.alert('提示','当前还没有关联的项目!');
		    	}
		    }
		});
	});
	</script>
</body>
</html>