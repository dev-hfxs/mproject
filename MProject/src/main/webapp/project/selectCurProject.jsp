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