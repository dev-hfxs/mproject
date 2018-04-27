<%@ page pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String projectId = request.getParameter("projectId");
	String boxId = request.getParameter("boxId");
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>发布工单</title>
<script type="text/javascript"	src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"	href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript"	src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"	src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
</head>
<body>
<div style="margin: 20px 0;"></div>
<div class="easyui-panel"
	style="width: 100%; max-width: 460px; padding: 0px 20px; border-width:0" >
	<!-- -->
	<div style="text-align: left; padding: 5px 0">
		<div style="margin-bottom:20px"> 
			<input type="radio" id="jobTypeA" name="jobType" value="A" checked="true"><span id="jobTypeSpanA">安装验收工单&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<input type="radio" id="jobTypeT" name="jobType" value="T"><span id="jobTypeSpanT">调试工单&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
			<input type="radio" id="jobTypeQ" name="jobType" value="Q"><span id="jobTypeSpanQ">其他工单</span>
		</div>
		<div style="margin-bottom:20px">
			<input type="hidden" id="userId" name="userId">
			<input class="easyui-textbox" id="processPerson" name="processPerson" style="width: 100%" prompt="请选择"
				data-options="label:'工程师 :',readonly:true">
		</div>
		<div style="margin-bottom: 20px;">
			<input class="easyui-textbox" id="workContent" name="workContent" multiline="true" style="width: 100%;height:80px;"
				data-options="label:'具体任务 :',validType:'length[0,200]'">
		</div>
	</div>
	<div style="text-align: center; padding: 5px 0">
		<a href="javascript:void(0)" class="easyui-linkbutton"	onclick="submitForm()" style="width: 80px">发布</a> &nbsp;&nbsp;
		<a href="javascript:void(0)" class="easyui-linkbutton" 	onclick="doCancel()" style="width: 80px">取消</a>
	</div>

</div>
	
<script>
	function submitForm() {
		var jobType = $("input[name='jobType']:checked").val();
		if(jobType == null || jobType ==''){
			$.messager.alert('提示','请选择工单类型.');
			return;
		}
		
		// 提交保存
		$.ajax({
		    url:'<%=path%>/job/mgr/add.do',
		    data:{
		    	'projectId':'<%=projectId%>',
		    	'machineBoxId':'<%=boxId%>',
		    	'jobType':jobType,
		    	'processPerson':$("#userId").val(),
		    	'workContent':$("#workContent").val()
		    },
		    type:'post',
		    async:false,
		    dataType:'json',
		    success:function(data) {
		    	if(data.returnCode == "success"){
		    		parent.loadUrl("<%=path%>/project/currentProjectMgr.jsp?pageNum=<%=pageNum%>&pageSize=<%=pageSize%>");
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
		
		$("#jobTypeSpanQ").click(function(){
			$("#jobTypeQ").trigger("click");
		});
		
		$("#jobTypeSpanA").click(function(){
			$("#jobTypeA").trigger("click");
		});
		$("#jobTypeSpanT").click(function(){
			$("#jobTypeT").trigger("click");
		});
		
		$("#workContent").next("span").children("textarea").attr("disabled","disabled");
		
		$("[type='radio']").change(function(){
			$("#userId").val('');
			$("#processPerson").val('');
			$("#processPerson").next("span").children('input').eq(0).val('');
		});
		
		$("[type='radio']").click(function(){
			var v = $(this).val();
			//var s = $(this).next('span').text();
			if( v == 'A' || v == 'T'){
				$("#workContent").next("span").children("textarea").attr("disabled","disabled");
			}
			if(v == 'Q'){
				$("#workContent").next("span").children("textarea").removeAttr("disabled");
			}
		});
		
		$("#processPerson").next("span").click(function(){
			var jobType = $("input[name='jobType']:checked").val();
			if(jobType == null || jobType =='' ){
				$.messager.alert('提示','请先选择工单类型.');
				return;
			}
               
			showMessageDialog("<%=path%>/job/engineerSelect.jsp?jobType="+jobType+"&boxId=<%=boxId%>" ,"选择工程师",640,480,true);
           });
	});
	
	
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
		parent.loadUrl("<%=path%>/project/currentProjectMgr.jsp?pageNum=<%=pageNum%>&pageSize=<%=pageSize%>");
	}
</script>
</body>
</html>