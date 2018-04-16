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
<script>
	$(function() {
		$("#main-header").resize();

		$('.panel-header.accordion-header').bind(
				"click",
				function() {
					$(this).siblings().removeClass('accordion-header-selected')
							.end().addClass('accordion-header-selected');
					$('#frmMain').attr('src', $(this).attr('itemUrl'));
				});

		$('.panel-header.accordion-header').bind("mouseover", function() {
			$(this).addClass('accordion-header-mouseover');
		});

		$('.panel-header.accordion-header').bind("mouseout", function() {
			$(this).removeClass('accordion-header-mouseover');
		});

		$('.tab-item').bind(
				"click",
				function() {
					$(this).siblings().removeClass('tab-item-selected').end()
							.addClass('tab-item-selected');
				});

		$('.tab-item').bind("mouseover", function() {
			$(this).addClass('tab-item-mouseover');
		});

		$('.tab-item').bind("mouseout", function() {
			$(this).removeClass('tab-item-mouseover');
		});

		$('.bt-logout,.bt-reset-pwd').bind("mouseover", function() {
			$(this).addClass('bt-mouseover');
		});

		$('.bt-logout,.bt-reset-pwd').bind("mouseout", function() {
			$(this).removeClass('bt-mouseover');
		});

		$('#main-right').panel({
			title : '当前访问: 人员管理'
		});
	});
</script>
</head>
<body class="easyui-layout">
	<div id="main-header" data-options="region:'north',border:false"
		style="width: 100%; height: 88px;">
		<div class="header-container" style="width: 100%;">
			<div class="system-info">
				<div class="logo-text div-float">
					航峰<font color="#CC0000">希萨</font> &nbsp;<font color="#FFFFFF">项目管理系统</font>
				</div>
				<div class="login-info div-float">
					用户:&nbsp;<span>jianqiang.liu@sierotech.com</span>&nbsp;<span>超级管理员</span>&nbsp;&nbsp;单位:&nbsp;<span>航峰希萨</span>
				</div>
				<div class="header-button">
					<div class="bt-reset-pwd">重置密码</div>
					<div class="bt-logout">注销</div>
				</div>
			</div>
			<div class="div-clean"></div>
			<div class="header-tab">
				<div class="tab-item tab-item-selected">
					<div class="tab-item-text">人员管理</div>
				</div>
				<div class="tab-item">
					<div class="tab-item-text">单位管理</div>
				</div>
				<div class="tab-item">
					<div class="tab-item-text">项目管理</div>
				</div>
				<div class="tab-item">
					<div class="tab-item-text">查询管理</div>
				</div>
				<div class="tab-item">
					<div class="tab-item-text">在建项目管理</div>
				</div>
			</div>
		</div>
	</div>

	<div id="main-left"
		data-options="region:'west',split:true,title:'功能列表'"
		style="width: 200px; padding: 0px;">
		<div style="overflow: hidden;">
			<div class="panel-header accordion-header" itemUrl="">
				<div class="panel-title">
					<img src="<%=path%>/style/default/image/icon-func.png" /><a>&nbsp;&nbsp;添加用户</a>
				</div>
			</div>
			<div class="panel-header accordion-header"
				itemUrl="http://www.baidu.com">
				<div class="panel-title">
					<a><img src="<%=path%>/style/default/image/icon-func.png" />&nbsp;&nbsp;用户修改</a>
				</div>
			</div>
			<div class="panel-header accordion-header"
				itemUrl="http://www.m4.cn/">
				<div class="panel-title">
					<a><img src="<%=path%>/style/default/image/icon-func.png" />&nbsp;&nbsp;恢复用户</a>
				</div>
			</div>
		</div>
	</div>

	<div id="main-right" data-options="region:'center',title:'当前访问:'">
		<div id="main-container"
			style="height: 100%; width: 100%; overflow: hidden;">
			<iframe height="100%" width="100%" frameBorder="0" id="frmMain"	name="frmMain" src="" />
		</div>
	</div>
</body>
</html>
