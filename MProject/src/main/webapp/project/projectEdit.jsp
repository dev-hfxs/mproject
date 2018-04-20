<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
	String projectId = "";
	if(null != request.getParameter("id")){
		projectId = request.getParameter("id");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改项目</title>
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
		<form id="ff" method="post" >
			<div style="margin-bottom: 20px;width: 100%">
						<input type="hidden" id="projectId" name="projectId">
						<input class="easyui-textbox" id="projectNumber" name="projectNumber" style="width: 100%"
							data-options="label:'项目编号 :',required:true,validType:['charCheck','length[8,20]']">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="projectName" name="projectName" style="width: 100%"
					data-options="label:'项目名称 :',required:true,validType:'length[2,30]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="contractNumber" name="contractNumber" style="width: 100%"
					data-options="label:'合同号 :',required:true,validType:'length[2,30]'">
			</div>
			<div style="margin-bottom: 20px">
				<input type="hidden" id="userId" name="userId">
				<input class="easyui-textbox" id="projectManager" name="projectManager" style="width: 100%" prompt="请选择"
					data-options="label:'项目经理 :',readonly:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="allowBoxNum" name="allowBoxNum" style="width: 100%"
					data-options="label:'应建机箱数 :',required:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="projectDesc" name="projectDesc" multiline="true" style="width: 100%;height:60px;"
					data-options="label:'项目描述 :'">
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
		</div>
	</div>
	
	<script>
	$(function() {
		//
		//获取单位信息
		$.ajax( {
		    url:'<%=path%>/comm/queryForList.do',
		    data:{
		    	'sqlId':'mproject-project-queryProjectById',
		    	'projectId':'<%=projectId%>'
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data!=null && data.length > 0){
		    		var projectObj = data[0];
		    		$("#projectId").val('<%=projectId%>');
		    		$("#projectName").textbox('setValue',projectObj.project_name);
		    		$("#projectNumber").textbox('setValue',projectObj.project_number);
		    		$("#contractNumber").textbox('setValue',projectObj.contract_number);
		    		$("#projectManager").textbox('setValue',projectObj.project_manager);
		    		$("#allowBoxNum").textbox('setValue',projectObj.allow_box_num);
		    		$("#userId").val(projectObj.user_id);
		    		$("#projectDesc").textbox('setValue',projectObj.project_desc);
		    	}
		    },
		    error : function(data) {
		    	$.messager.alert('异常',data.responseText);
	        }
		});
	});
	
		function submitForm() {
			if($("#ff").form('validate') == false){
				$.messager.alert('输入错误','请检查输入项!');
				return false;
			}
						
			//检查用户名是否已存在
			var projectNameExist = false;
			var projectName = $("#projectName").val();
			
			$.ajax( {
			    url:'<%=path%>/project/mgr/checkName.do',
			    data:{
			    	'id':'<%=projectId%>',
			    	'projectName':projectName
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.projectExist != null && data.projectExist !='true'){
			    		projectNameExist = false;
			    	}else{
			    		projectNameExist = true;
			    		$.messager.alert('提示','项目名已存在，请修改项目名!');
			    		return;
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
			if(projectNameExist == true){
				return;
			}
			
			// 提交保存
			$.ajax( {
			    url:'<%=path%>/project/mgr/update.do',
			    data:{
			    	'projectId':$("#projectId").val(),
			    	'projectName':$("#projectName").val(),
			    	'projectNumber':$("#projectNumber").val(),
			    	'contractNumber':$("#contractNumber").val(),
			    	'allowBoxNum':$("#allowBoxNum").val(),
			    	'projectManager':$("#userId").val(),
			    	'projectDesc':$("#projectDesc").val()
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		parent.loadUrl("<%=path%>/project/projectList.jsp");
			    	}else{
			    		$.messager.alert('提示',data.msg);
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
		}

		function clearForm() {
			$("#ff").form('clear');
		}
		
		$(function() {
			$("#projectManager").next("span").click(function(){  
            	showMessageDialog("<%=path%>/user/userSelect.jsp","选择项目经理",640,480,true);
            });
		});
		
		
		function okResponse(params){
			if(params == null || params.id == null || params.user_name == null){
				return;
			}
			$("#userId").val(params.id);
			$("#projectManager").val(params.user_name);	
			$("#projectManager").next("span").children('input').eq(0).val(params.user_name);
			closeDialog();
		}
		
		function doCancel() {
			parent.loadUrl("<%=path%>/project/projectList.jsp?pageNum=<%=pageNum%>&pageSize=<%=pageSize%>");
		}
	</script>
</body>
</html>