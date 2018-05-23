<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String boxId = request.getParameter("boxId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>机箱验收</title>
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
<div class="easyui-panel"
	style="width: 100%; max-width: 500px; padding: 5px 30px; border-width:0" >
	<div style="height:330px">
			<table id = "filePanel" width="100%">
				<tr>
					<td width="10%">附件1&nbsp;</td>
					<td width="80%">
						<form id="fm_dataFile1"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile1" name="dataFile1" ></form>
					</td>
				</tr>
				<tr>
					<td>附件2&nbsp;</td>
					<td>
						<form id="fm_dataFile2"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile2" name="dataFile2" ></form>
					</td>
				</tr>
				<tr>
					<td>附件3&nbsp;</td>
					<td>
						<form id="fm_dataFile3"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile3" name="dataFile3" ></form>
					</td>
				</tr>
				<tr>
					<td>附件4&nbsp;</td>
					<td>
						<form id="fm_dataFile4"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile4" name="dataFile4" ></form>
					</td>
				</tr>
				<tr>
					<td>附件5&nbsp;</td>
					<td>
						<form id="fm_dataFile5"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile5" name="dataFile5" ></form>
					</td>
				</tr>
				<tr>
					<td>附件6&nbsp;</td>
					<td>
						<form id="fm_dataFile6"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile6" name="dataFile6" ></form>
					</td>
				</tr>
				<tr>
					<td>附件7&nbsp;</td>
					<td>
						<form id="fm_dataFile7"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile7" name="dataFile7" ></form>
					</td>
				</tr>
				<tr>
					<td>附件8&nbsp;</td>
					<td>
						<form id="fm_dataFile8"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile8" name="dataFile8" ></form>
					</td>
				</tr>
				<tr>
					<td>附件9&nbsp;</td>
					<td>
						<form id="fm_dataFile9"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile9" name="dataFile9" ></form>
					</td>
				</tr>
				<tr>
					<td>附件10&nbsp;</td>
					<td>
						<form id="fm_dataFile10"><input type="hidden" name="file-id" value="boxfile_<%=boxId %>"><input intype="file" id="dataFile10" name="dataFile10" ></form>
					</td>
				</tr>
			</table>
	</div>
	<div style="text-align: center; padding: 5px 0">
		<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
		<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
	</div>
</div>
	
<script>
var checkErrorMsgMap = new Map();

function submitForm() {
	if(checkErrorMsgMap.size() > 0){
		$.messager.alert('提示','待上传的单个文件有超过2M, 请检查红框中文件！');
		return;
	}
	//检查是否存在重名的文件
	var fileNameMap = new Map();
	var fileInfos = [];
	var hasValidFile = false;
	$("[type='file'][class='textbox-value']").each(function(i,item){
		var fValue = $(this).val();
		
		if(fValue == null || fValue.length < 1){
			//return false;
		}else{
			var tFile = fileNameMap.get(fValue);			
			if(tFile != null && tFile.length > 0){
				$.messager.alert('提示','待上传的文件包含重复的文件！');
				hasValidFile = true;
				return false;
			}
			fileNameMap.put(fValue,"1");
			var fileInfo = {};
			fileInfo['id'] = '<%=boxId%>';
			fileInfo['fileName'] = fValue.substring(fValue.lastIndexOf("\\") + 1);
			fileInfos[fileInfos.length] = fileInfo;
		}
	});
	
	if(hasValidFile == true){
		return;
	}
	if(fileInfos.length < 1){
		$.messager.alert('提示','机箱验收确认最少需要上传一个附件!');
		return;
	}
	// 提交保存
	$.ajax( {
	    url:'<%=path%>/box/mgr/accept.do',
	    data:{
	    	'fileInfos':JSON.stringify(fileInfos),
	    	'boxId':'<%=boxId%>'
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
	    success:function(data) {
	    	if(data.returnCode == "success"){
	    		$.messager.alert('提示','操作成功','info',function(){
	    			parent.okResponse();
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

$(function() {
	$("[intype=file]").filebox({
		buttonText:'选择',
		width:'80%',
		onChange:function(){
			var frmId = $(this).parent('form').attr('id');
			var fileObjName = frmId.split("_")[1];
			
			var fileObjId = $("[type=file][name="+fileObjName+"]").eq(0).attr("id");
			
			var filePath = $(this).filebox('getValue');
			if(filePath.length < 1){
				//未选择文件时, 不上传文件
				checkErrorMsgMap.remove(fileObjId,'1');
				$("#"+fileObjId).prev("input").removeClass("warning-text");
				return false;
			}
			//验证文件大小
			var dom = document.getElementById(fileObjId);
			var fileSize =  dom.files[0].size;
			if(fileSize > 1024*1024*2){
				$.messager.alert('提示','文件大小不要超过2M.');
				checkErrorMsgMap.put(fileObjId,'1');
				$("#"+fileObjId).prev("input").addClass("warning-text");
				return false;
			}
			checkErrorMsgMap.remove(fileObjId,'1');
			$("#"+fileObjId).prev("input").removeClass("warning-text");
			$.ajax({
			     url: "<%=path%>/file/upload/acceptFile.do",
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
});

</script>
</body>
</html>