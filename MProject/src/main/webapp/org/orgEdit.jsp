<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
	String orgId = "";
	if(null != request.getParameter("id")){
		orgId = request.getParameter("id");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改单位</title>
<script type="text/javascript"	src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript"	src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
</head>
<body>
	<div style="margin: 20px 0;"></div>
	<div class="easyui-panel" data-options="fit:true"
		style="width: 100%; max-width: 800px; padding: 10px 60px; border-width:0" >
		<div class="easyui-layout" data-options="fit:true">
			<form id="ff">
			<div data-options="region:'west',split:false" style="width:42%;height:60%;border-width:0">
					<div style="margin-bottom: 20px;width: 100%">
						<input type="hidden" id="orgId" name="orgId">
						<input class="easyui-textbox" id="orgName" name="orgName" style="width: 100%"
							data-options="label:'单位名称 :',required:true,validType:'length[2,60]'">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="address" name="address" style="width: 100%"
							data-options="label:'地  址 :',validType:'length[0,60]'">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="telephone" name="telephone" style="width: 100%"
							data-options="label:'单位电话 :',validType:'telNum'">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-numberbox" id="account" name="account" style="width: 100%"
							data-options="label:'银行账号 :',validType:'length[0,20]'">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="contactPosition" name="contactPosition" style="width: 100%"
							data-options="label:'联系人职务 :',validType:'length[0,20]'">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="contactPhone" name="contactPhone" style="width: 100%"
							data-options="label:'联系人电话 :',validType:'telNum'">
					</div>
			</div>
			<div data-options="region:'east'" style="width:42%;height:60%;margin: 0 0 0 0px;border-width:0;left:20px">
					<div style="margin-bottom: 20px;width: 100%">
						<input class="easyui-textbox" id="orgCode" name="orgCode" style="width: 100%"
							data-options="label:'单位编码 :',required:true,validType:['charCheck','length[2,30]']">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="taxNumber" name="taxNumber" style="width: 100%"
							data-options="label:'税  号 :',required:true,validType:'length[8,25]'">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="areaCode" name="areaCode" style="width: 100%"
							data-options="label:'电话区号 :',validType:['numberCheck','length[0,4]']">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="openBank" name="openBank" style="width: 100%"
							data-options="label:'开户银行 :',validType:'length[0,20]'">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="contacts" name="contacts" style="width: 100%"
							data-options="label:'联系人 :',validType:'length[0,15]'" ">
					</div>
					<div style="margin-bottom: 20px">
						<input class="easyui-textbox" id="email" name="email" style="width: 100%"
							data-options="label:'联系邮箱 :',validType:['email','length[10,50]']">
					</div>
					<div style="text-align: left; padding: 5px 0"><br>
						&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
						<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
					</div>
			</div>
			</form>
		</div>
	</div>
	
	<script>
		function submitForm() {
			if($("#ff").form('validate') == false){
				$.messager.alert('输入错误','请检查输入项!');
				return false;
			}
			
			//检查单位名是否已存在
			var orgNameExist = false;
			var orgName = $("#orgName").val();
			
			$.ajax( {
			    url:'<%=path%>/org/mgr/checkOrg.do',
			    data:{
			    	'id':'<%=orgId%>',
			    	'orgName':orgName
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.orgExist != null && data.orgExist !='true'){
			    		orgNameExist = false;
			    	}else{
			    		orgNameExist = true;
			    		$.messager.alert('输入错误','单位名已存在，请修改单位名!');
			    		return;
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
			if(orgNameExist == true){
				return;
			}
			
			// 提交保存
			$.ajax( {
			    url:'<%=path%>/org/mgr/update.do',
			    data:{
			    	'orgId':'<%=orgId%>',
			    	'orgName':$("#orgName").val(),
			    	'orgCode':$("#orgCode").val(),
			    	'address':$("#address").val(),
			    	'taxNumber':$("#taxNumber").val(),
			    	'telephone':$("#telephone").val(),
			    	'areaCode':$("#areaCode").val(),
			    	'account':$("#account").val(),
			    	'openBank':$("#openBank").val(),
			    	'contactPosition':$("#contactPosition").val(),
			    	'contacts':$("#contacts").val(),
			    	'contactPhone':$("#contactPhone").val(),
			    	'email':$("#email").val()					
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

		function doCancel() {
			parent.loadUrl("<%=path%>/org/orgList.jsp?pageNum=<%=pageNum%>&pageSize=<%=pageSize%>");
		}
		
		
		$(function() {
			//
			//获取单位信息
			$.ajax( {
			    url:'<%=path%>/comm/queryForList.do',
			    data:{
			    	'sqlId':'mproject-org-queryOrgById',
			    	'orgId':'<%=orgId%>'
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data!=null && data.length > 0){
			    		var orgObj = data[0];
			    		$("#orgId").val('<%=orgId%>');
			    		$("#orgName").textbox('setValue',orgObj.org_name);
			    		$("#orgCode").textbox('setValue',orgObj.org_code);
			    		$("#address").textbox('setValue',orgObj.address);
			    		$("#taxNumber").textbox('setValue',orgObj.tax_number);
			    		$("#telephone").textbox('setValue',orgObj.telephone);
			    		$("#areaCode").textbox('setValue',orgObj.area_code);
			    		$("#account").textbox('setValue',orgObj.account);
			    		$("#openBank").textbox('setValue',orgObj.open_bank);
			    		$("#contactPosition").textbox('setValue',orgObj.contact_position);
			    		$("#contacts").textbox('setValue',orgObj.contacts);
			    		$("#contactPhone").textbox('setValue',orgObj.contact_phone);
			    		$("#email").textbox('setValue',orgObj.email);	
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
		});
		
		$.extend($.fn.validatebox.defaults.rules, {
		    phoneNum: { //验证手机号   
		        validator: function(value, param){
		         return /^1[3-8]+\d{9}$/.test(value);
		        },
		        message: '请输入正确的手机号码.'
		    },
		    telNum:{ //既验证手机号，又验证座机号
		      validator: function(value, param){ 
		          return /((0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$)|(^((\d3)|(\d{3}\-))?(1[358]\d{9})$)/.test(value);
		         },
		         message: '请输入正确的电话号码.' 
		    },
		    charCheck:{
		        validator : function(value) {
		        	return /^[a-zA-Z0-9]+$/.test(value);
		        },
		        message: "只能包括英文字母、数字"
		    },
		    numberCheck: {
		        validator : function(value) {
		        	return /^[0-9]+$/.test(value);
		        },
		        message : "只能输入数字"
		    }
		});		
	</script>
</body>
</html>