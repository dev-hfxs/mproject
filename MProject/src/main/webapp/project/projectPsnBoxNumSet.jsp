<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String projectId = request.getParameter("projectId");
	String userId = request.getParameter("userId");
	String oldAllowBoxNum = request.getParameter("allowBoxNum");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改施工经理应建机箱数</title>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache" content="no-cache">
<script type="text/javascript"	src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript"	src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
</head>
<body>
	<div style="margin: 20px 20px;"></div>
	<div class="easyui-panel"
		style="width: 100%; max-width: 460px; padding: 0px 10px; border-width:0" >
		<form id="ff" method="post" >
			<div style="margin-bottom:20px">
				<input class="easyui-numberbox" id="allowBoxNum" name="allowBoxNum" iconWidth="28" style="width:200px;height:28px;" data-options="label:'应建机箱数:',required:true,validType:'length[1,8]'">
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="doSubmit()" style="width: 80px">确认</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
		</div>
	</div>
	
	<script>
	function doSubmit() {
			if($("#ff").form('validate') == false){
				$.messager.alert('输入错误','请检查输入项!');
				return false;
			}
			
			// 提交保存			
			$.ajax( {
			    url:'<%=path%>/project/mgr/projectPsnBoxnumReset.do',
			    data:{
			    	'projectId':'<%=projectId%>',
			    	'userId':'<%=userId%>',
			    	'oldAllowBoxNum':'<%=oldAllowBoxNum%>',
			    	'allowBoxNum':$("#allowBoxNum").val()
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示', '操作成功！', 'info', function () {
			    			parent.refreshDataGrid();
			    			parent.closeDialog();
			        	});
			    	}else{
			    		$.messager.alert('提示',data.msg);
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
		}
		
		function doCancel(){
			parent.closeDialog();
		}
	</script>
</body>
</html>