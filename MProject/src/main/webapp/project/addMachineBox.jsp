<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>新建机箱</title>
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
<style>
.text-noborder{
  border-left:none;
  border-right:none;
  border-top:none;
  border-bottom:1px solid #95B8E7;
  outline-style: none;
  text-align:right;
}
</style>
</head>
<body>
	<div style="margin: 20px 0;"></div>
	<div class="easyui-panel"
		style="width: 100%; max-width: 460px; padding: 30px 60px; border-width:0" >
		<form id="ff" method="post" >
			<div style="margin-bottom: 20px;width: 100%">
						<input class="easyui-textbox" id="boxNumber" name="boxNumber" style="width: 100%"
							data-options="label:'机箱编号 :',required:true,validType:'checkBoxCode'">
			</div>
			<div style="margin-bottom: 20px;width: 100%">
						<input class="easyui-textbox" id="nfcNumber" name="nfcNumber" style="width: 100%"
							data-options="label:'NFC序列号 :',required:true,validType:'length[14,14]'">
			</div>
			<!-- 
			<div style="margin-bottom: 20px">
				<table>
					<tr>
						<td width="80px">经度 :</td>
						<td><input type="text" class="text-noborder" id="lng-part1" name="longitude" style="width: 40px;">&nbsp;°(度)
                            <input type="text" class="text-noborder" id="lng-part2" name="longitude" style="width: 40px;">&nbsp;′(分)
                            <input type="text" class="text-noborder" id="lng-part3" name="longitude" style="width: 50px;">&nbsp;″(秒)
					    </td>
					</tr>
				</table>				
			</div>
			-->
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="longitude" name="longitude" style="width: 100%"
					data-options="label:'经度 :',required:true,validType:'checkLng'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-textbox" id="latitude" name="latitude" style="width: 100%"
					data-options="label:'纬度 :', required:true,validType:'checkLat'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="processorNum" name="processorNum" style="width: 100%"
					data-options="label:'处理器数量 :',required:true,validType:'checkPNum'">
			</div>
			<div style="margin-bottom: 20px">
				<input class="easyui-numberbox" id="installSpace" name="installSpace" style="width: 100%"
					data-options="label:'安装间距 (m):',precision:2,validType:'length[0,7]'">
			</div>
		</form>
		<!-- -->
		<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="clearForm()" style="width: 80px">取消</a>
		</div>
	</div>
	
	<script>
	var nfcCodeValid = false;
	
		function submitForm() {
			if($("#ff").form('validate') == false){
				$.messager.alert('输入错误','请检查输入项!');
				return false;
			}
						
			//检查机箱编号是否存在
			var boxNumberExist = false;
			var boxNumber = $("#boxNumber").val();
			
			$.ajax( {
			    url:'<%=path%>/box/mgr/checkBoxNumber.do',
			    data:{
			    	'boxId':'',
			    	'boxNumber':boxNumber
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.exist != null && data.exist !='true'){
			    		boxNumberExist = false;
			    		$("#boxNumber").next("span").removeClass("textbox-invalid");
			    	}else{
			    		boxNumberExist = true;
			    		//$.messager.alert('提示','机箱编号已存在,请检查!');
			    		return;
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
			if(boxNumberExist == true){
				$("#boxNumber").next("span").addClass("textbox-invalid");
				$.messager.alert('提示','机箱编号已存在,不能重复录入!');
				return;
			}
			
			if(nfcCodeValid == false){
				$("#nfcNumber").next("span").addClass("textbox-invalid");
				$.messager.alert('提示','机箱NFC序列号未通过验证,不能提交!');
				return false;
			}
			
			// 提交保存
			$.ajax( {
			    url:'<%=path%>/box/mgr/add.do',
			    data:{
			    	'boxId':'',
			    	'userId':'${loginUser.id}',
			    	'orgId':'${loginUser.org_id}',
			    	'projectId':'${curProjectId}',
			    	'boxNumber':$("#boxNumber").val(),
			    	'nfcNumber':$("#nfcNumber").val(),
			    	'allowBoxNum':$("#allowBoxNum").val(),
			    	'longitude':$("#longitude").val(),
			    	'latitude':$("#latitude").val(),
			    	'processorNum':$("#processorNum").val(),
			    	'installSpace':$("#installSpace").val()	
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示','添加成功!','info',
			    			function(){
								//
								parent.loadUrl('<%=path%>/project/machineBoxWrite.jsp');
			    			}
			    		);
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
		
		$.extend($.fn.validatebox.defaults.rules, {
		    checkLng: { //验证经度
		        validator: function(value, param){
		         return  /^-?(((\d|[1-9]\d|1[1-7]\d|0)\.\d{6})|0|180)$/.test(value);
		        },
		        message: '经度整数部分为0-180,小数位保留6位!'
		    },
		    checkLat: { //验证纬度
		        validator: function(value, param){
		         return  /^-?([0-8]?\d{1}\.\d{6}|0|([0-8]?\d{1})\.\d{6}|90)$/.test(value);
		        },
		        message: '纬度整数部分为0-90,小数位保留6位!'
		    },
		    checkBoxCode: { //验证机箱编号
		        validator: function(value, param){
		         return  /^[a-zA-Z0-9\-]{12}$/.test(value);
		        },
		        message: '机箱编号只能是字母、数字和符号 - , 长度为12位!'
		    },
		    checkPNum: { //验证处理器数量
		        validator: function(value, param){
		         return  /^[1-2]{1}$/.test(value);
		        },
		        message: '一个机箱可设置1-2个处理器!'
		    }
		});
		
		
		$(function() {
			$("#nfcNumber").textbox({  
			    onChange: function(value) {
			    	var objValue = $(this).val();
			    	if(objValue.length == 14){
			    		$.ajax( {
						    url:'<%=path%>/dict/mgr/checkNfcNum.do',
						    data:{codeName:'box',codeValue:objValue,id:''},
				    		type:'post',
						    async:false,
						    dataType:'json',
						    success:function(data) {
						    	if(data.returnCode == "success"){
						    		nfcCodeValid =  true;
						    		$("#nfcNumber").next("span").removeClass("textbox-invalid");
						    	}else{
						    		nfcCodeValid =  false;
						    		$("#nfcNumber").next("span").addClass("textbox-invalid");
						    		$.messager.alert('提示',data.msg);
						    	}
						    },
						    error : function(data) {
						    	$.messager.alert('异常',data.responseText);
					        }
						});
			    	}
			    }
			});
			
			$("#nfcNumber").textbox('textbox').bind("keyup", function () { $(this).val($(this).val().toUpperCase());});
			$("#boxNumber").textbox('textbox').bind("keyup", function () { $(this).val($(this).val().toUpperCase());});
			
		});
		
	</script>
</body>
</html>