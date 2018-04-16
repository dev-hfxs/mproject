<%@ page pageEncoding="UTF-8"%>
<% 
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>项目管理系统登录</title>
<script type="text/javascript" src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript" src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<style>
/*
body{
	background-image:url("<%=path%>/style/default/image/login-bg.jpg");
	background-repeat:no-repeat;
	background-position:200px 120px;
}
*/
.msg-content{ position:relative; top:10px; width:100%; color:red; text-align:left; font-size:14px;}

.panel-title{font-size:14px}

.textbox-label{font-size:14px}
</style>
</head>
<body>
<div style="width:400px;height:360px;margin-left:auto;margin-right:auto;margin-top:200px;">
	<div class="easyui-panel" title=" 用 户 登 录" style="width:400px;max-width:400px;padding:30px 60px;">
		<form id="ff" class="easyui-form" method="post" data-options="novalidate:true">
			<div style="margin-bottom:20px">
				<input class="easyui-textbox" name="name" style="width:100%;height:28px;" data-options="label:'用户名:',required:true,validType:'email'">
			</div>
			<div style="margin-bottom:20px">
				<input class="easyui-textbox" name="email" style="width:100%;height:28px;" data-options="label:'姓 名:',required:true">
			</div>
			<div style="margin-bottom:20px">
				<input class="easyui-passwordbox" prompt="Password" iconWidth="28" style="width:100%;height:28px;" data-options="label:'密 码:',showEye:false,required:true">
			</div>			
		</form>
		<div style="text-align:center;padding:5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doLogin()" style="width:80px;height:32px">登 录</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doClear()" style="width:80px;height:32px">重 置</a>
		</div>
		<div id="msgContent" class="msg-content">&nbsp;</div>
	</div>
<div>
	<script>
		function doLogin(){
			$('#ff').form('submit',{
				onSubmit:function(){
					return $(this).form('enableValidation').form('validate');
				}
			});
		}
		
		function doClear(){
			$('#ff').form('clear');
		}
	</script>
</body>
</html>