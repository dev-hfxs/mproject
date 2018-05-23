<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String processorId = request.getParameter("processorId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>添加探测器</title>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache" content="no-cache">
<script type="text/javascript"	src="<%=path%>/js/jquery/jquery.min.js"></script>
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript"	src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
<style>
.textbox-label{
	width:120px;
}
</style>
</head>
<body>
<div style="margin: 20px 0;"></div>
<div class="easyui-panel"
	style="width: 100%; max-width: 480px; padding: 30px 30px; border-width:0" >
	<form id="ff" method="post" >
		<div style="margin-bottom: 20px;width: 100%">
			<input class="easyui-textbox" id="detectorSeq" name="detectorSeq" style="width: 90%"
				data-options="label:'探测器编号:',required:true,validType:'checkDCode'">
		</div>
		<div style="margin-bottom: 20px;width: 100%">
			<input class="easyui-textbox" id="nfcNumber" name="nfcNumber" style="width: 90%"
				data-options="label:'探测器NFC序列号:',required:true,validType:'length[14,14]'">
		</div>
		<!-- 
		<div style="margin-bottom: 20px">
			<input class="easyui-textbox" id="detectorId" name="detectorId" style="width: 90%"
				data-options="label:'探测器ID:',validType:'length[1,3]'">
		</div>
		-->
		<div style="margin-bottom: 20px">
			<input class="easyui-textbox" id="longitude" name="longitude" style="width: 90%"
				data-options="label:'经度 :',required:true,validType:'checkLng'">
		</div>
		<div style="margin-bottom: 20px">
			<input class="easyui-textbox" id="latitude" name="latitude" style="width: 90%"
				data-options="label:'纬度 :',required:true,validType:'checkLat'">
		</div>
		<div style="margin-bottom: 20px">
			<div>一个处理器下的探测器只能有一个起点和终点.</div>
			<div>
				<input id="chkStartPoint" type="checkbox" name="startPoint"><span id="spanStart">起点</span>&nbsp;&nbsp;&nbsp;&nbsp;<span id="spanStartPointTip"></span>
			</div>
			<div>
				<input id="chkEndPoint" type="checkbox" name="endPoint" ><span id="spanEnd">终点</span>&nbsp;&nbsp;&nbsp;&nbsp;<span  id="spanEndPointTip"></span>
			</div>
		</div>
	</form>
	<!-- -->
	<div style="text-align: center; padding: 5px 0">
		<br>
		<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">确认</a> &nbsp;&nbsp;
		<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
	</div>
</div>
	
<script>
var hadStartPoint = false;
var hadEndPoint = false;
var nfcCodeValid = false;
var dictNfcCodeSeq = '';

function submitForm() {
	
	if($("#ff").form('validate') == false){
		$.messager.alert('输入错误','请检查输入项!');
		return false;
	}
	if(nfcCodeValid == false){
		$("#nfcNumber").next("span").addClass("textbox-invalid");
		$.messager.alert('提示','机箱NFC序列号未通过验证,不能提交!');
		return false;
	}
	var inDetectorSeq = $("#detectorSeq").val();
	if(inDetectorSeq != dictNfcCodeSeq){
		$.messager.alert('提示','探测器NFC序列号['+$("#nfcNumber").val()+']在系统中的探测器编号与输入的探测器编号不一致,不能提交!');
		return;
	}
	var isStart = 'N';
	var isEnd = 'N';
	if($("#chkStartPoint").is(":checked")){
		isStart = 'Y';
	};
	if($("#chkEndPoint").is(":checked")){
		isEnd = 'Y';
	};
	
	// 提交保存
	$.ajax( {
	    url:'<%=path%>/detector/mgr/add.do',
	    data:{
	    	'detectorId':'',
	    	'processorId':'<%=processorId%>',
	    	'detectorSeq':$("#detectorSeq").val(),
	    	'nfcNumber':$("#nfcNumber").val(),
	    	'longitude':$("#longitude").val(),
	    	'latitude':$("#latitude").val(),
	    	'startPoint':isStart,
	    	'endPoint':isEnd
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
	    success:function(data) {
	    	if(data.returnCode == "success"){
	    		parent.refreshDetector();
	    		parent.closeDialog();
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
	
	$("#spanStart").click(function(){
		$("#chkStartPoint").trigger("click");
	});
	$("#spanEnd").click(function(){
		$("#chkEndPoint").trigger("click");
	});
	$("#chkStartPoint").change(function(){
		if($(this).is(":checked")){
			$("#chkEndPoint").removeAttr("checked");
		}
	});
	$("#chkEndPoint").change(function(){
		if($(this).is(":checked")){
			$("#chkStartPoint").removeAttr("checked");
		}
	});
	
	//if(hadStartPoint){
	//	$("#chkStartPoint").attr("disabled",true);
	//	$("#spanStartPointTip").text("已有探测器设置为起点");
	//}
	
	//if(hadEndPoint){
	//	$("#chkEndPoint").attr("disabled",true);
	//	$("#spanEndPointTip").text("已有探测器设置为终点");
	//}
	
	//获取已分配的起点终点
	$.ajax( {
	    url:'<%=path%>/comm/queryForList.do',
	    data:{
	    	'sqlId':'mproject-detector-getStartAndPointByProcessorId',
	    	'processorId':'<%=processorId%>'
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
	    success:function(data) {
	    	if(data!=null && data.length > 0){
	    		var item = data[0];
	    		if(item.start_point_id != null && item.start_point_id !=''){
	    			//启点探测器已分配
	    			$("#chkStartPoint").attr("disabled",true);
	    			$("#spanStartPointTip").text("已有探测器设置为起点.");
	    		}
	    		if(item.end_point_id != null && item.end_point_id !=''){
	    			//终点探测器已分配
	    			$("#chkEndPoint").attr("disabled",true);
	    			$("#spanEndPointTip").text("已有探测器设置为终点.");
	    		}
	    	}
	    },
	    error : function(data) {
	    	$.messager.alert('异常',data.responseText);
        }
	});
	
	$("#nfcNumber").textbox({  
	    onChange: function(value) {
	    	var objValue = $(this).val();
	    	if(objValue.length == 14){
	    		$.ajax( {
				    url:'<%=path%>/dict/mgr/checkNfcNum.do',
				    data:{codeName:'detector',codeValue:objValue,id:''},
		    		type:'post',
				    async:false,
				    dataType:'json',
				    success:function(data) {
				    	if(data.returnCode == "success"){
				    		dictNfcCodeSeq = data.number;
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
	
	$("#nfcNumber").textbox('textbox').bind("keyup", function () { $(this).val($(this).val().toUpperCase());})
	
	$("#detectorSeq").textbox({
		 onChange: function(value) {
			if(dictNfcCodeSeq!= null && dictNfcCodeSeq.length > 0){
				var inDetectorSeq = $("#detectorSeq").val();
				if(inDetectorSeq != dictNfcCodeSeq){
					nfcCodeValid =  false;
					$.messager.alert('提示','探测器NFC序列号['+$("#nfcNumber").val()+']在系统中的探测器编号与输入的探测器编号不一致,不能提交!');
					return;
				}else{
					nfcCodeValid =  true;
		    		$("#nfcNumber").next("span").removeClass("textbox-invalid");
				}
			}
		 }
	});
	
});

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
    checkDCode: { //验证探测器编号
        validator: function(value, param){
         return  /^((00[1-9])|(0[1-9][0-9])|(1[0-9][0-9])|(2[0-3][0-9])|240){1}$/.test(value);
        },
        message: '探测器编号为001-240的数字组成!'
    }
});
</script>
</body>
</html>