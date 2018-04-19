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
var userMenus;
var currentModule;
var currentModuleText;

	$(function() {
		$("#main-header").resize();
		var isInitPwd = "${loginUser.init_password}";
		if(isInitPwd != null && isInitPwd=='Y'){
			//弹出修改密码窗口,强制修改
			var content = '<iframe src="<%=path%>/user/passwordReset.jsp?forceFlag=1" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
			var boarddiv = '<div id="msgwindow" title="首次登录需修改密码" ></div>'
			$(document.body).append(boarddiv);
			var win = $('#msgwindow').dialog({
				closable: false,
				content : content,
				width : '480',
				height : '320',
				modal : true,
				title : '首次登录需修改密码',
				onClose : function() {
				}
			});
			win.dialog('open');
			win.window('center');
		}
		//
		$("#userName").text("${loginUser.user_name}");
		$("#roleName").text("${loginUser.role_name}");
		$("#orgName").text("${loginUser.org_name}");
		var userHomePage = "${loginUser.home_page}";
		var defaultModule = "";
		var defaultMenu = "";
		if(userHomePage != null && userHomePage.split("#").length > 1){
			defaultModule = userHomePage.split("#")[0];
			defaultMenu = userHomePage.split("#")[1];
		}
		
		//获取用户的菜单
		$.ajax( {
		    url:'<%=path%>/comm/queryForList.do',
		    data:{
		    	'sqlId':'mproject-user-getUserProjects',
		    	'roleId':'${loginUser.role_id}'
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data != null){
		    		userMenus = data;
		    		var navTipInfo = "当前访问:";
		    		//展示用户的功能模块
		    		$.each(data,function(i,item){
						//item['isParent']='Y' !== item.endFlag;
						//item.name=item.name || item.menuName;
						if(item.parent_id == 'ROOT'){
							if(defaultModule == item.menu_code){
								currentModule = item.id;
								navTipInfo = navTipInfo + item.menu_name;
								currentModuleText = item.menu_name;
								$("#header-tab").append('<div class="tab-item tab-item-selected" '+'" itemId="'+item.id +'"><div class="tab-item-text">'+item.menu_name+'</div></div>');
							}else{
								$("#header-tab").append('<div class="tab-item" '+'" itemId="'+item.id +'"><div class="tab-item-text">'+item.menu_name+'</div></div>');
							}
							
						}
					});
		    		//展示用户当前功能模块下的菜单
		    		$("#subMenu").empty();
		    		var isFirstMenu = true;
		    		$.each(data,function(i,item){
		    			if(item.parent_id == currentModule){
							//if(defaultMenu == item.menu_code){
							if(isFirstMenu == true){
								isFirstMenu = false;
								navTipInfo = navTipInfo + " > " + item.menu_name;
								$("#subMenu").append('<div class="panel-header accordion-header accordion-header-selected" itemUrl="'+item.menu_url+'"><div class="panel-title"><img src="<%=path%>/style/default/image/icon-func.png" /><a>&nbsp;&nbsp;'+item.menu_name+'</a></div></div>');
								var curUrl = '<%=path%>' + item.menu_url;
								$('#frmMain').attr('src',curUrl);
							}else{
								$("#subMenu").append('<div class="panel-header accordion-header" itemUrl="'+item.menu_url+ '"><div class="panel-title"><img src="<%=path%>/style/default/image/icon-func.png" /><a>&nbsp;&nbsp;'+item.menu_name+'</a></div></div>');
							}
						}
					});
		    		$("#main-right").panel({
	    				title : navTipInfo
	    			});
		    	}
		    },
		    error : function(data) {
		    	$.messager.alert('异常',data.responseText);
	        }
		});
		
		setSubMenuAction();
		$('.tab-item').bind(
				"click",function() {
					$(this).siblings().removeClass('tab-item-selected').end().addClass('tab-item-selected');
					var itemId = $(this).attr('itemId');
					var navTipInfo = "当前访问：" + $(this).text();
					currentModuleText = $(this).text();
					//展示用户当前功能模块下的菜单
					$("#subMenu").empty();
					var isFirstMenu = true;
					$.each(userMenus,function(i,item){
		    			if(item.parent_id == itemId){
							if(isFirstMenu == true){
								isFirstMenu = false;
								navTipInfo = navTipInfo + " > " + item.menu_name;
								$("#subMenu").append('<div class="panel-header accordion-header accordion-header-selected" itemUrl="'+item.menu_url+'"><div class="panel-title"><img src="<%=path%>/style/default/image/icon-func.png" /><a>&nbsp;&nbsp;'+item.menu_name+'</a></div></div>');
								//$('#frmMain').attr('src', $(this).attr('<%=path%>' + item.menu_url));
								var curUrl = '<%=path%>' + item.menu_url; 
								$('#frmMain').attr('src',curUrl);
							}else{
								$("#subMenu").append('<div class="panel-header accordion-header" itemUrl="'+item.menu_url+'"><div class="panel-title"><img src="<%=path%>/style/default/image/icon-func.png" /><a>&nbsp;&nbsp;'+item.menu_name+'</a></div></div>');
							}
						}
					});
					setSubMenuAction();
					$("#main-right").panel({
	    				title : navTipInfo
	    			});
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
		
		$('.bt-logout').bind("click", function() {
			$.post("<%=path%>/auth/logout.do", function(result){window.location="<%=path%>/system/login/login.jsp";},"json");
		});

		$('.bt-reset-pwd').bind("click", function() {
			var content = '<iframe src="<%=path%>/user/passwordReset.jsp" width="100%" height="80%" frameborder="0" scrolling="no"></iframe>';
			var boarddiv = '<div id="msgwindow" title="用户修改密码" ></div>'// style="overflow:hidden;"可以去掉滚动条
			$(document.body).append(boarddiv);
			var win = $('#msgwindow').dialog({
				content : content,
				width : '480',
				height : '320',
				modal : true,
				title : '用户修改密码',
				onClose : function() {
					$(this).dialog('destroy');// 后面可以关闭后的事件
				}
			});
			win.dialog('open');
			win.window('center');
		});
	});
	
	function setSubMenuAction(){
		$('.panel-header.accordion-header').bind(
				"click",
				function() {
					$(this).siblings().removeClass('accordion-header-selected')
							.end().addClass('accordion-header-selected');
					var menuUrl = $(this).attr('itemUrl');
					var curUrl = '<%=path%>' + menuUrl;
					var itemText = $(this).text();
					var navTipInfo = "当前访问：" + currentModuleText + " > " + itemText;
					$("#main-right").panel({
	    				title : navTipInfo
	    			});
					$('#frmMain').attr('src', curUrl);
				});
	
		$('.panel-header.accordion-header').bind("mouseover", function() {
			$(this).addClass('accordion-header-mouseover');
		});
	
		$('.panel-header.accordion-header').bind("mouseout", function() {
			$(this).removeClass('accordion-header-mouseover');
		});
	}
	
	function loadUrl(url){
		$('#frmMain').attr('src',url);
	}
	
	function closeDialog() {
		$("#msgwindow").dialog('destroy');
	}

	function closeDialogAndTip(msg) {
		$("#msgwindow").dialog('destroy');
		$.messager.alert('提示',msg);
	}
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
					用户:&nbsp;<span id="userName"></span>&nbsp;&nbsp;单位:&nbsp;<span id="orgName"></span><br><span id="roleName"></span>
				</div>
				<div class="header-button">
					<div class="bt-reset-pwd">重置密码</div>
					<div class="bt-logout">注销</div>
				</div>
			</div>
			<div class="div-clean"></div>
			<div class="header-tab" id="header-tab">
				<!-- 
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
				-->
			</div>
		</div>
	</div>

	<div id="main-left"
		data-options="region:'west',split:true,title:'功能列表'"
		style="width: 200px; padding: 0px;">
		<div id="subMenu" style="overflow: hidden;">
			<!-- 
			<div class="panel-header accordion-header" itemUrl="<%=path%>/user/userAdd.jsp">
				<div class="panel-title">
					<img src="<%=path%>/style/default/image/icon-func.png" /><a>&nbsp;&nbsp;添加用户</a>
				</div>
			</div>
			<div class="panel-header accordion-header" itemUrl="<%=path%>/user/userList.jsp">
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
			-->
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
