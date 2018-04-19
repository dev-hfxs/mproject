<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String userId = request.getParameter("id");
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>修改用户</title>
<script type="text/javascript"	src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript"	src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
</head>
<body>
	<div class="easyui-panel"
		style="width: 100%; max-width: 460px; padding: 30px 60px; border-width:0" >
		<form id="ff" method="post" >
			<div style="margin-bottom: 20px;width: 100%">
				<input type="hidden" id="id" name="id" />
				<input class="easyui-textbox" id="userName" name="userName" style="width: 100%"
					data-options="label:'用户名 :',required:true,validType:['email','length[10,50]']">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="fullName" name="fullName" style="width: 100%"
					data-options="label:'姓 名 :',required:true,validType:'length[2,15]'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="idNumber" name="idNumber" style="width: 100%"
					data-options="label:'身份证号 :',required:true">
			</div>
			<div style="margin-bottom:20px">
				<select class="easyui-combobox" id="sex" name="sex" label="性 别 :" style="width:100%;" panelHeight="auto"><option value="M">男</option><option value="F">女</option></select>
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-datebox" id="birthday" name="birthday" label="出生日期 :" labelPosition="left" style="width:100%;">
			</div>
			<div style="margin-bottom: 20px">
				<input type="hidden" id="orgId" name="orgId">
				<input class="easyui-textbox" id="orgName" name="orgName" style="width: 100%" prompt="请选择"
					data-options="label:'所在单位 :',readonly:true">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="contactNumber" name="contactNumber" style="width: 100%"
					data-options="label:'联系电话 :',required:true" validtype='telNum'">
			</div>
			<div style="margin-bottom:20px"> 
				<input class="easyui-combobox" id="roleId" name="roleId" label="用户类型:"  panelHeight="auto" style="width:100%" 
					data-options="url:'<%=path%>/comm/queryForList.do?sqlId=mproject-user-getUserTypes&userId=<%=userId%>',method:'get',valueField:'id',textField:'text'">				
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
		</div>


	</div>
	
<script>
var curUserRoleId = "${loginUser.role_id}";
	
		function submitForm() {
			
			if($("#ff").form('validate') == false){
				$.messager.alert('输入错误','请检查输入项!');
				return false;
			}
			var idCard = $("input[name='idNumber']").val();
			// 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X 
			var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/; 
			if(reg.test(idCard) === false) 
			{
				$.messager.alert('输入错误','身份证输入不合法!');
			    return false;
			}
			var orgId = $("#orgId").val();
			if(orgId == null){
				$.messager.alert('输入错误','请选择用户单位');
				return false;
			}
			
			//检查用户名是否已存在
			var userNameExist = false;
			var userName = $("#userName").val();
			
			$.ajax( {
			    url:'<%=path%>/user/mgr/checkUser.do',
			    data:{
			    	'id':'<%=userId%>',
			    	'userName':userName
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.userExist != null && data.userExist !='true'){
			    		userNameExist = false;
			    	}else{
			    		userNameExist = true;
			    		$.messager.alert('输入错误','用户名已存在，请修改用户名!');
			    		return;
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
			if(userNameExist == true){
				return;
			}
			// 提交保存
			$.ajax( {
			    url:'<%=path%>/user/mgr/update.do',
			    data:{
			    	'id':$("#id").val(),
			    	'userName':$("#userName").val(),
			    	'fullName':$("#fullName").val(),
			    	'idNumber':$("#idNumber").val(),
			    	'sex':$("#sex").val(),
			    	'birthday':$("#birthday").val(),
			    	'contactNumber':$("#contactNumber").val(),
			    	'orgId':$("#orgId").val(),
			    	'roleId':$("#roleId").val()
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		//$.messager.alert('提示','用户修改成功!');
			    		parent.loadUrl("<%=path%>/user/userList.jsp");
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
			//获取用户
			$.ajax( {
			    url:'<%=path%>/comm/queryForList.do',
			    data:{
			    	'sqlId':'mproject-user-getUserById',
			    	'userId':'<%=userId%>'
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data!=null && data.length > 0){
			    		var userObj = data[0];
			    		//$("#userName").val(userObj.user_name);
			    		$("#id").val(userObj.id);
			    		$("#userName").textbox('setValue',userObj.user_name);
			    		$("#fullName").textbox('setValue',userObj.full_name);
			    		$("#idNumber").textbox('setValue',userObj.id_number);
			    		//$("#sex").val(userObj.sex);
			    		$('#sex').combobox('select',userObj.sex);
			    		$("#birthday").textbox('setValue',userObj.birthday);
			    		$("#contactNumber").textbox('setValue',userObj.contact_number);
			    		$("#orgId").val(userObj.org_id);
			    		//$("#roleId").val(userObj.role_id);
			    		$("#roleId").textbox('setValue',userObj.role_id);
			    		$("#orgName").textbox('setValue',userObj.org_name);
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
			
			$("#orgName").next("span").click(function(){  
                // todo弹出单位列表页面
				//$("#orgName").val('abcd');
                //$(this).children('input').eq(0).val('abcd');
                
				showMessageDialog("<%=path%>/org/orgSelect.jsp","选择用户所属单位",640,480,true);
            });
		});
		
		$.extend($.fn.validatebox.defaults.rules, {
		    phoneNum: { //验证手机号   
		        validator: function(value, param){
		         return /^1[3-8]+\d{9}$/.test(value);
		        },
		        message: '请输入正确的手机号码。'
		    },
		    telNum:{ //既验证手机号，又验证座机号
		      validator: function(value, param){ 
		          return /((0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$)|(^((\d3)|(\d{3}\-))?(1[358]\d{9})$)/.test(value);
		         },
		         message: '请输入正确的电话号码。' 
		    }
		});
		
		function okResponse(params){
			if(params == null || params.id == null || params.org_name == null){
				return;
			}
			$("#orgId").val(params.id);
			$("#orgName").val(params.org_name);	
			$("#orgName").next("span").children('input').eq(0).val(params.org_name);
			closeDialog();
		}
		
		function doCancel(){
			parent.loadUrl("<%=path%>/user/userList.jsp?pageNum=<%=pageNum%>&pageSize=<%=pageSize%>");
		}
		
	</script>
</body>
</html>