<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>新建项目</title>
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
						<input class="easyui-textbox" id="projectNumber" name="projectNumber" style="width: 100%"
							data-options="label:'机箱编号 :',required:true,validType:['charCheck','length[8,20]']">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="allowBoxNum" name="allowBoxNum" style="width: 100%"
					data-options="label:'经度 :',required:true,validType:'length[1,8]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="allowBoxNum" name="allowBoxNum" style="width: 100%"
					data-options="label:'纬度 :',required:true,validType:'length[1,8]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="allowBoxNum" name="allowBoxNum" style="width: 100%"
					data-options="label:'处理器数量 :',required:true,validType:'length[1,8]'">
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="clearForm()" style="width: 80px">取消</a>
		</div>
	</div>
	
	<script>
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
			    	'id':'',
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
			    url:'<%=path%>/project/mgr/add.do',
			    data:{
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
		
	</script>
</body>
</html>