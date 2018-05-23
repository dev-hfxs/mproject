<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String jobId = request.getParameter("jobId");
	String jobType = request.getParameter("jobType");
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>处理工单</title>
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
<script type="text/javascript"	src="<%=path%>/js/Map.js"></script>
<script type="text/javascript"	src="<%=path%>/js/json2.js"></script>
<style>
.warning-text{
	color:red;
}

.warning-input{
	border-width: thin;
	border-style: solid;
	border-color: #F11111;
}
</style>
</head>
<body>
<div class="easyui-panel" style="width: 100%; height:520px; padding: 0px 0px; border-width:0" >
	<!-- -->
	<div style="width:auto;height:460px;text-align: left; padding: 5px 0">
		<div style="margin-bottom:10px"> 
			<input type="radio" id="jobStatusF" name="jobStatus" value="F" checked="true"><span id="jobStatusSpanF">完成&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<input type="radio" id="jobStatusN" name="jobStatus" value="N"><span id="jobStatusSpanN">未完成&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<input type="radio" id="jobStatusQ" name="jobStatus" value="Q"><span id="jobStatusSpanQ">问题工单</span>
		</div>
		<div id="installOptionPanel" style="margin-bottom: 5px;width:auto;height:360px;display:none">
			<table>
				<tr>
					<td><input type="checkbox" name="installOption" value="GangSiLaJin"><span>钢丝拉紧程度合适</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="installOption" value="TanCeQiShunXu"><span>所有探测器按顺序安装</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="installOption" value="JinWeiDu"><span>所有经纬度正确</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="installOption" value="JieXian"><span>所有接线完好</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="installOption" value="RuoDianGuDing"><span>弱电箱安装固定</span></td>
				</tr>
				<tr>
					<td><input type="checkbox" name="installOption" value="BangZha"><span>所有绑扎完好</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="installOption" value="LuoSiJinGu"><span>螺丝紧固程度良好</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="installOption" value="TanCeQiShangXian"><span>所有探测器上线</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="installOption" value="FangLeiJieDi"><span>金属管防雷接地</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="installOption" value="JiLuBiaoQueRen"><span>设备安装记录表确认</span></td>
				</tr>
				
			</table>
			<table id="boxAndDetectorOptionTb" class="datagrid-btable">
					<!-- 
					<tr>
						<td style="width:120ppx">输入项描述</td>
						<td style="width:250ppx">值</td>
						<td style="width:100ppx">是否分配IP</td>
					</tr>
					<tr>
						<td style="width:120ppx">机箱位置描述:</td>
						<td style="width:220ppx"><input type="text" style="width:320px" name="inp2"></td>
						<td style="width:220ppx"><input type="checkbox" value="1" name="c1">是否分配IP</td>
					</tr>
					-->
			</table>
		</div>
		<div id="debugOptionPanel" class="datagrid-body" style="margin-bottom: 5px;height:250px;overflow-x:auto;overflow-y: auto;display:none">
			<table>
				<tr>
					<td><input type="checkbox" name="debugOption" value="TanCeQiShangXian"><span>所有探测器在线</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="debugOption" value="TanCeQiShunXu"><span>所有探测器按顺序安装</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="debugOption" value="BoXingZhengChang"><span>波形软件运行正常</span></td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="debugOption" value="ShenGuangZhengChang"><span>声光报警联动正常</span></td>
				</tr>
			</table><br>
			<table id="debugOptionTb" class="datagrid-btable">
				<tr>
					<td style="width:140px">处理器NFC序列号&nbsp;</td>
					<td style="width:140px">处理器IP&nbsp;</td>
					<td style="width:200px">&nbsp配置文件</td>
					<td style="width:200px">探测器信息</td>
				</tr>
				<!--
				<tr>
					<td></td>
					<td><input class="easyui-filebox" label="" name="file1" labelPosition="top" data-options="prompt:'txt',accept:'text/plain',buttonText:'选&nbsp;择'" style="width:100%"></td>
					<td><input class="easyui-filebox" label="" name="file2" labelPosition="top" data-options="prompt:'txt',accept:'text/plain',buttonText:'选&nbsp;择'" style="width:100%"></td>
				</tr>
				 -->
			</table>
		</div>
		<div id="jobDescPanel" style="margin-bottom: 5px;">
			<input class="easyui-textbox" id="jobDesc" name="jobDesc" multiline="true" style="width: 100%;height:80px;"
				data-options="label:'情况描述 :',validType:'length[0,200]'">
		</div>
	</div>
	<div style="text-align: center; padding: 5px 0">
			<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确定</a> &nbsp;&nbsp;
			<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
	</div>
</div>
	
<script>
	var checkErrorMsgMap = new Map();
	var jobId = '<%=jobId%>';
	var jobType = '<%=jobType%>';
	
	$(function() {
		if(jobType == 'A'){
			$("#debugOptionPanel").hide();
			$("#jobDescPanel").hide();
			$("#installOptionPanel").show();
			
			var tableHtml = tableHtml + '<tr><td style="width:330px;">机箱位置描述:</td><td style="width:300px"><input style="width:300px" type="text" class="textbox-text" intype="boxPos"></td><td style="width:10px"></td></tr>';
			$('#boxAndDetectorOptionTb').append(tableHtml);
			tableHtml = '';
			// 获取工单对应机箱下的处理器、探测器,用于设置处理器IP、探测器位置
			$.ajax({
				url:'<%=path%>/comm/queryForList.do',
			    data:{
			    	'sqlId':'mproject-job-getInstallJob4Device',
			    	'jobId':jobId
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	//设置处理器,探测器输入信息
			    	if(data != null){
			    		$.each(data,function(i,item){
			    			if(item.device_type == 'P'){
			    				//tableHtml = '<tr><td style="width:250px">' + item.device_desc + '</td><td style="width:250px"><input style="width:320px" type="text" class="textbox-text" intype="ip" id="input_'+item.id+'" name="'+item.device_type+'#' + item.id + '" value="0.0.0.0" readonly="readonly" onchange="maskIp(this)"></td><td style="width:100px"><input type="checkbox" linkId="'+item.id+'" name="chkHadIP">是否分配IP</td></tr>';
			    			}else{
			    				tableHtml = '<tr><td style="width:330px">' + item.device_desc + '</td><td style="width:300px"><input style="width:300px" type="text" class="textbox-text" intype="detectorPos" id="input_'+item.id+'" name="'+item.device_type+'#' + item.id + '"></td><td style="width:10px"></td></tr>';
			    			}
			    			$('#boxAndDetectorOptionTb').append(tableHtml);
			    		});
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('异常',data.responseText);
		        }
			});
		}
		
		if(jobType == 'T'){
			$("#installOptionPanel").hide();
			$("#jobDescPanel").hide();
			$("#debugOptionPanel").show();
			
			//加载调试工单完成需要设置的项目
			var tableHtml = '';
			$.ajax({
				url:'<%=path%>/comm/queryForList.do',
			    data:{
			    	'sqlId':'mproject-job-getDebugJob4Device',
			    	'jobId':jobId
			    },
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
					if(data != null){
			    		$.each(data,function(i,item){
			    			tableHtml = '';
			    			tableHtml = '<tr><td>' + item.nfc_number + '</td><td><input style="width:80%" type="text" class="textbox-text" intype="ip" id="input_'+item.id+'" value="0.0.0.0" readonly="readonly" onchange="maskIp(this)"><input type="checkbox" linkId="'+item.id+'" name="chkHadIP" title="是否分配IP"></td>';
			    			tableHtml = tableHtml + '<td><form id="f_configFile_'+item.id+'"><input type="hidden" name="file-id" value="configfile_'+item.id+'"><input intype="file" type="text" name="configFile_' + item.id + '" style="width:100%"></form></td><td><form id="f_detectorFile_'+item.id+'"><input type="hidden" name="file-id" value="detectorfile_'+item.id+'"><input intype="file" type="text" name="detectorFile_'+item.id+'" style="width:100%"></form></td></tr>';
							$('#debugOptionTb').append(tableHtml);
			    		});
					}
			    }
			});
			$("[intype='file']").filebox({prompt:'txt',
				accept:'text/plain',
				buttonText:'选择',
				onChange:function(){
					//console.log($(this).parent('form').attr('id'));
					var frmId = $(this).parent('form').attr('id');
					var fileObjName = frmId.substring(2);
					var fileObjId = $("[type=file][name="+fileObjName+"]").eq(0).attr("id");
					
					//验证文件类型
					var filePath = $(this).filebox('getValue');
					var dotPos=filePath.lastIndexOf(".");
					var nameLength=filePath.length;
					var suffix=filePath.substring(dotPos+1,nameLength);
					if(suffix ==="txt"){
						
					}else{
						$.messager.alert('提示','文件类型有误.');
						$("#"+fileObjId).prev("input").addClass("warning-text");
						return;
					}
					//验证文件大小
					var dom = document.getElementById(fileObjId);
					var fileSize =  dom.files[0].size;
					
					if(fileSize < 1){
						$.messager.alert('提示','文件内容为空.');
						checkErrorMsgMap.put(fileObjId,'1');
						$("#"+fileObjId).prev("input").addClass("warning-text");
						return;
					}
					if(fileSize > 1024*1024){
						$.messager.alert('提示','文件超出限制的大小.');
						checkErrorMsgMap.put(fileObjId,'1');
						$("#"+fileObjId).prev("input").addClass("warning-text");
						return false;
					}
					checkErrorMsgMap.remove(fileObjId,'1');
					$("#"+fileObjId).prev("input").removeClass("warning-text");
					$.ajax({
					     url: "<%=path%>/file/upload/configFile.do",
					     type: 'POST',
					     cache: false,
					     data: new FormData($('#'+frmId)[0]),
					     dataType:"json",
					     processData: false,
					     contentType: false,
					     beforeSend: function(){
					     },
					     success : function(data) {
					     }
					 });
				}
			});
		}

		if(jobType == 'Q'){
			$("#debugOptionPanel").hide();
			$("#installOptionPanel").hide();
			$("#jobDescPanel").show();
		}
		
		$("[type='radio'][name='jobStatus']").next("span").click(function(){
			$(this).prev().trigger("click");
		});
		
		$("[type='checkbox'][name='installOption']").next("span").click(function(){
			$(this).prev().trigger("click");
		});
		
		$("[type='checkbox'][name='debugOption']").next("span").click(function(){
			$(this).prev().trigger("click");
		});
		
		$("[type='checkbox'][name='chkHadIP']").click(function(){
			var linkId = $(this).attr('linkId');
			if($(this).is(':checked')){
				$("#input_"+linkId).removeAttr("readonly");
				$("#input_"+linkId).attr("value","");
			}else{
				$("#input_"+linkId).attr("value","0.0.0.0");
				$("#input_"+linkId).attr("readonly","readonly");
			}
		});
		
		$("[type='radio']").click(function(){
			var v = $(this).val();
			if( v == 'N' || v == 'Q'){
				//$("#jobDesc").next("span").children("textarea").attr("disabled","disabled");
				$("#jobDescPanel").show();
				$("#installOptionPanel").hide();
				$("#debugOptionPanel").hide();
			}
			if(v == 'F'){
				//$("#jobDesc").next("span").children("textarea").removeAttr("disabled");
				$("#jobDescPanel").hide();
				if(jobType == 'A'){
					$("#installOptionPanel").show();
					$("#jobDescPanel").hide();
					$("#debugOptionPanel").hide();
				}else if(jobType == 'T'){
					$("#installOptionPanel").hide();
					$("#jobDescPanel").hide();
					$("#debugOptionPanel").show();
				}else if(jobType == 'Q'){
					$("#installOptionPanel").hide();
					$("#debugOptionPanel").hide();
					$("#jobDescPanel").show();
				}
			}
		});
	});
	
	function submitForm() {
		var jobStatus = $("input[name='jobStatus']:checked").val();
		if(jobStatus == null || jobStatus ==''){
			$.messager.alert('提示','请选择工单完成状态.');
			return;
		}
		
		var jobDesc=$("#jobDesc").val();
		var submitUrl = '';
		var submitData = {};
		submitData['jobId'] = jobId;
		submitData['jobStatus'] = jobStatus;
		submitData['jobType'] = jobType;
		
		var checkInputOk = true;
		if(jobType == 'A'){
			if(jobStatus == 'F'){
				//获取安装选项
				var installOptionObj = {};
				var optionOk = true;
				$("[type='checkbox'][name='installOption']").each(function(i,item){
					if($(this).is(":checked") == false){
						optionOk = false;
						return false;
					}
					installOptionObj[item.value] = $(this).is(":checked");
				});
				if(optionOk == false){
					$.messager.alert('提示','安装工单完成, 安装选项需要确认且勾选为是.');
					return;
				}
				var boxPos = $("[intype='boxPos']").val();
				if(boxPos == null || boxPos == ""){
					$.messager.alert('提示','请填写机箱位置描述.');
					return;
				}
				//获取探测器位置输入项
				var detectorPosArr = [];
				var detectorOk = true;
				$("input[intype='detectorPos']").each(function(i,item){
					if(item.value == null || item.value == ''){
						detectorOk = false;
						return false;
					}
					var detectorPos = {};
					var itemId = item.id;
					detectorPos['id'] = itemId.split("_")[1];
					detectorPos['posDesc'] = item.value;
				});
				if(detectorOk ==  false){
					$.messager.alert('提示','有探测器位置描述为空,请填写完整.');
					return;
				}
				submitData['installOption'] = JSON.stringify(installOptionObj);
				submitData['machineBoxPos'] = boxPos;
				//submitData['processorInfo'] = JSON.stringify(processorInfoArr);
				submitData['detectorPos'] = JSON.stringify(detectorPosArr);
			}else{
				if(jobDesc !=null && jobDesc.length > 0){
					submitData['jobDesc']=jobDesc;
				}else{
					checkInputOk = false;
				}	
			}
			submitUrl = '<%=path%>/job/mgr/process/install.do';
		}else if(jobType == 'T'){
			if(jobStatus == 'F'){
				//获取调试选项
				var debugOptionObj = {};
				var debugOptionOk = true;
				$("[type='checkbox'][name='debugOption']").each(function(i,item){
					if($(this).is(":checked") == false){
						debugOptionOk = false;
						return false;
					}
					debugOptionObj[item.value] = $(this).is(":checked");
				});
				if(debugOptionOk == false){
					$.messager.alert('提示','调试工单完成,调试选项需要确认且勾选为是.');
					return;
				}
				//检查IP输入输入是否正确
				if(checkErrorMsgMap.size() > 0){
					$.messager.alert('提示','IP输入有误,请检查.');
					return;
				}
				//获取处理器ip输入项
				var ipHasNull = false;
				var processorInfoArr = [];
				$("input[intype='ip']").each(function(i,item){
					if(item.value== null || item.value.length < 1){
						ipHasNull = true;
						return false;
					}else{
						var processorInfo = {};
						var itemId = item.id;
						processorInfo['id'] = itemId.split("_")[1];
						processorInfo['ip'] = item.value;
						processorInfoArr[processorInfoArr.length] = processorInfo;
					}
				});
				if(ipHasNull == true){
					$.messager.alert('提示','有处理器IP项未填写.');
					return;
				}
				//处理器配置文件
				var processorConfigs = [];
				//探测器信息文件
				var detectorInfos = [];				
				//检查是否选择文件
				var fileHasNull = false;
				$("[type='file'][class='textbox-value']").each(function(i,item){
					var fValue = $(this).val();
					if(fValue == null || fValue.length < 1){
						fileHasNull = true;
						return false;
					}else{
						var objName = item.name;
						var objClass = objName.split("_")[0];
						var deviceId = objName.split("_")[1];
						var originalName = fValue.substring(fValue.lastIndexOf("\\") + 1);
						if("configFile" == objClass){
							var processorConfig = {};
							processorConfig['id'] = deviceId;
							processorConfig['fileName'] = originalName;
							processorConfigs[processorConfigs.length] = processorConfig;
						}else if("detectorFile" == objClass){
							var detectorInfo = {};
							detectorInfo['id'] = deviceId;
							detectorInfo['fileName'] = originalName;
							detectorInfos[detectorInfos.length] = detectorInfo;
						}
					}
				});
				if(fileHasNull == true){
					$.messager.alert('提示','未选择文件.');
					return;
				}
				submitData['debugOption'] = JSON.stringify(debugOptionObj);
				submitData['processorInfo'] = JSON.stringify(processorInfoArr);
				submitData['configFile'] = JSON.stringify(processorConfigs);
				submitData['detectorInfo'] = JSON.stringify(detectorInfos);
			}else{
				if(jobDesc !=null && jobDesc.length > 0){
					submitData['jobDesc']=jobDesc;
				}else{
					checkInputOk = false;
				}
			}
			submitUrl = '<%=path%>/job/mgr/process/debug.do';
		}else if(jobType == 'Q'){
			if(jobDesc !=null && jobDesc.length > 0){
				submitData['jobDesc']=jobDesc;
			}else{
				checkInputOk = false;
			}
			submitUrl = '<%=path%>/job/mgr/proces/other.do';
		}
		
		if(checkInputOk == true){
			// 提交保存
			$.ajax({
			    url:submitUrl,
			    data:submitData,
			    type:'post',
			    async:false,
			    dataType:'json',
			    success:function(data) {
			    	if(data.returnCode == "success"){
			    		$.messager.alert('提示','处理成功!','info',function(){
			    			parent.okResponse();
			    		});			    		
			    	}else{
			    		$.messager.alert('提示',data.msg);
			    	}
			    },
			    error : function(data) {
			    	$.messager.alert('提示',data.responseText);
		        }
			});
		}
	}
	
	function okResponse(params){
		if(params == null || params.id == null || params.user_name == null){
			return;
		}
		$("#userId").val(params.id);
		$("#processPerson").val(params.user_name);
		$("#processPerson").next("span").children('input').eq(0).val(params.user_name);
		closeDialog();
	}
	
	function doCancel(){
		parent.closeDialog();
	}
	
	function maskIp(obj){
		var reg =  /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/     
		if(reg.test(obj.value)){
			checkErrorMsgMap.remove(obj.id);
			$("#"+obj.id).removeClass("warning-input");
		}else{
			$.messager.alert('提示','IP地址输入错误.');
			checkErrorMsgMap.put(obj.id,'1');
			$("#"+obj.id).addClass("warning-input");
			obj.value='';
			obj.focus();
		}
	}
</script>
</body>
</html>