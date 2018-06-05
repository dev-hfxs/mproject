<%@ page pageEncoding="UTF-8"%>
<%
	// no use 
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
	String boxId = request.getParameter("boxId");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>探测器安装表</title>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-control" content="no-cache">
<meta http-equiv="Cache" content="no-cache">
<script type="text/javascript" src="<%=path%>/js/jquery/jquery-3.3.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path%>/js/easyui/themes/icon.css">
<script type="text/javascript" src="<%=path%>/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=path%>/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"	src="<%=path%>/js/common.js"></script>
<style>
.fontTitle{
	font-size:18px;
}

.font14{
	font-size:13px;
}

.font2{
	font-size:0.5px;
}
</style>
</head>
<body>
	<div id= "tbDiv" data-options="region:'north',border:false" style="height:36px">
		<a href="#" class="easyui-linkbutton" onclick="doPrint()" iconCls="icon-print">&nbsp;打印&nbsp;</a>
	</div>
	<div  id="printDiv" data-options="border:false,fit:true">
	<!--
	<div style="margin: 70px 50px 60px 50px;">
	<table border="1" cellspacing="0" cellpadding="0">
		<tr height="40px">
			<td colspan="8" align="center">智能融合处理器单元和探测器安装记录表 ()</td>
		</tr>
		<tr height="40px">
			<td colspan="2"  align="center">安装人员</td><td  colspan="3"></td>
			<td align="center">施工单位</td><td  colspan="2"></td>
		</tr>
		<tr height="40px">
			<td colspan="2"  align="center">项目经理</td><td  colspan="3"></td>
			<td align="center">安装时间</td><td  colspan="2"></td>
		</tr>
		<tr height="40px">
			<td colspan="2"  align="center">工程师</td><td  colspan="3"></td>
			<td align="center">安装间距</td><td  colspan="2"></td>
		</tr>
		<tr height="30px">
			<td colspan="2" align="center">机箱编号:<br><font>(年2/行业3/序列号5)</font></td><td  colspan="2"></td>
			<td  colspan="2"  align="center">CLQNFC序列号</td><td  colspan="2"></td>
		</tr>
		<tr height="30px">
			<td colspan="2">CLQ位置:</td><td colspan="2">经度:</td>
			<td  colspan="2">纬度:</td><td  colspan="2">MOXA序列号:</td>
		</tr>
		<tr height="30px">
			<td colspan="2">IP</td><td colspan="3">&nbsp;</td>
			<td  colspan="1">软件工程师确认</td><td  colspan="2"></td>
		</tr>
		<tr height="30px">
			<td rowspan="2" align="center">CLQ序号</td>
			<td rowspan="2" align="center">起止</td>
			<td rowspan="2" align="center">TCQ编号</td>
			<td rowspan="2" align="center">NFC序列号<br>(11位)</td>
			<td colspan="2" align="center">TCQ位置信息</td> 
			<td rowspan="2" align="center">施工方</td>
			<td rowspan="2" align="center">HFXS</td>
		</tr>
		<tr height="30px">
			<td align="center">经度</td>
			<td align="center">纬度</td>
		</tr>
		<tr height="30px">
			<td width="60px">&nbsp;1</td>
			<td width="30px"></td>
			<td width="60px"></td>
			<td width="90px"></td>
			<td width="90px"></td>
			<td width="90px"></td>
			<td width="100px"></td>
			<td width="100px"></td>
		</tr>
	</table>
	<div style="height:92px">&nbsp;</div>
	</div>
	-->
	</div>


<script>
function doPrint(){
	$("#tbDiv").hide();
	window.print();
	$("#tbDiv").show();
	return false;
	
}

$(function() {
	var deviceDatas = [];
	
	//获取数据
	$.ajax( {
	    url:'<%=path%>/box/mgr/getDeviceLog.do',
	    data:{
	    	'boxId':'<%=boxId%>'
	    },
	    type:'post',
	    async:false,
	    dataType:'json',
	    success:function(result) {
	    	if(result!=null && result.datas != null){
	    		deviceDatas = result.datas;
	    	}
	    },
	    error : function(data) {
	    	$.messager.alert('异常', data.responseText);
        }
	});

	var emptyData = {build_manager:'', project_manager:'', create_date:'', org_name:'',install_engineer:'', install_space:'', box_number:'', nfc_number:'', longitude:'', latitude:'', ip:'', moxa_number:'', detectors:[]};
	var emptyDetector = {detector_seq:'', nfc_number:'', longitude:'', latitude:'', start_pos:'', end_pos:'' };

	if(deviceDatas.length < 1){
		//没有数据时显示一个空行
		deviceDatas[deviceDatas.length] = emptyData;
	}
	for(var i=0; i<deviceDatas.length; i++){
		var processorObj = deviceDatas[i];
		var detectors = processorObj.detectors;
		var modNum = detectors.length % 20;
		
		var page = 1;
		if(detectors.length > 0){
			//if(modNum == 0){
			//	page = detectors.length / 20;
			//}else{
			//	page = detectors.length / 20 + 1;
			//}
			page = Math.ceil(detectors.length / 20);
			//分页输出内容
			for(var j=0; j<page; j++){
				var pageHtml = '';
				var strPage = j + 1;
				pageHtml = '<div style="margin: 60px 50px 60px 50px;"><table border="1" cellspacing="0" cellpadding="0">';
				pageHtml = pageHtml + '<tr height="40px"><td colspan="8" align="center"><span class="fontTitle">智能融合处理器单元和探测器安装记录表 (' + strPage + ')</span></td></tr>';
				pageHtml = pageHtml + '<tr height="40px"><td colspan="2"  align="center">安装人员</td><td  colspan="3">'+ processorObj.build_manager +'</td><td align="center">施工单位</td><td  colspan="2">' + processorObj.org_name + '</td></tr>';
				pageHtml = pageHtml + '<tr height="40px"><td colspan="2"  align="center">项目经理</td><td  colspan="3">'+ processorObj.project_manager +'</td><td align="center">安装时间</td><td  colspan="2">' + processorObj.create_date + '</td></tr>';
				pageHtml = pageHtml + '<tr height="40px"><td colspan="2"  align="center">工程师</td><td  colspan="3">'+ processorObj.install_engineer +'</td><td align="center">安装间距</td><td  colspan="2">' + processorObj.install_space + '</td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2" align="center">机箱编号:<br><span class="font2">年2/行业3/序列号5</span></td><td  colspan="2">' + processorObj.box_number + '</td><td  colspan="2"  align="center">CLQNFC序列号</td><td  colspan="2">'+ processorObj.nfc_number + '</td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2">CLQ位置</td><td colspan="2">经度:'+ processorObj.longitude +'</td><td  colspan="2">纬度:'+ processorObj.latitude + '</td><td  colspan="2">MOXA序列号:<br>' + processorObj.moxa_number + '</td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2">IP</td><td colspan="3">&nbsp;' + processorObj.ip + '</td><td  colspan="1"><font size="1">软件工程师</font><br>确认</td><td  colspan="2"></td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td rowspan="2" align="center">CLQ<br>序号</td><td rowspan="2" align="center">起止</td><td rowspan="2" align="center">TCQ编号</td><td rowspan="2" align="center">NFC序列号<br>(11位)</td><td colspan="2" align="center">TCQ位置信息</td><td rowspan="2" align="center">施工方</td><td rowspan="2" align="center">HFXS</td>	</tr>';
				pageHtml = pageHtml + '<tr height="30px"><td align="center">经度</td><td align="center">纬度</td></tr>';
				
				var startIndex = (page - 1) * 20;
				for(var m=0; m<20; m++){
					var index = startIndex + m;
					var detectorObj = emptyDetector;
					if(detectors.length > index){
						detectorObj = detectors[index];
					}
					//输出探测器信息行
					var detectorLineHtml = '<tr height="30px">';
					detectorLineHtml = detectorLineHtml + '<td width="50px" class="font14">'+ '' + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="70px" class="font14">'+ '' + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.detector_seq + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="100px" class="font14">'+ detectorObj.nfc_number + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="80px" class="font14">'+ detectorObj.longitude + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="80px" class="font14">'+ detectorObj.latitude + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="90px" class="font14">'+ '' + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="90px" class="font14">'+ '' + '</td>';
					detectorLineHtml = detectorLineHtml + '</tr>';
					
					pageHtml = pageHtml + detectorLineHtml;
				}
				pageHtml = pageHtml + '</table><div style="height:47px">&nbsp;</div></div>';				
				$('#printDiv').append(pageHtml);
			}
		}else{
			var detectorObj = emptyDetector;
			var pageHtml = '';
			pageHtml = '<div style="margin: 60px 50px 60px 50px;"><table border="1" cellspacing="0" cellpadding="0">';
			pageHtml = pageHtml + '<tr height="40px"><td colspan="8" align="center"><span class="fontTitle">智能融合处理器单元和探测器安装记录表 ()</span></td></tr>';
			pageHtml = pageHtml + '<tr height="40px"><td colspan="2"  align="center">安装人员</td><td  colspan="3"></td><td align="center">施工单位</td><td  colspan="2"></td></tr>';
			pageHtml = pageHtml + '<tr height="40px"><td colspan="2"  align="center">项目经理</td><td  colspan="3"></td><td align="center">安装时间</td><td  colspan="2"></td></tr>';
			pageHtml = pageHtml + '<tr height="40px"><td colspan="2"  align="center">工程师</td><td  colspan="3"></td><td align="center">安装间距</td><td  colspan="2"></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2" align="center">机箱编号:<br><span class="font2">年2/行业3/序列号5</span></td><td  colspan="2"></td><td  colspan="2"  align="center">CLQNFC序列号</td><td  colspan="2">'+ processorObj.nfc_number + '</td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2">CLQ位置</td><td colspan="2">经度:</td><td  colspan="2">纬度:</td><td  colspan="2">MOXA序列号:<br></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2">IP</td><td colspan="3">&nbsp;</td><td  colspan="1"><font size="1">软件工程师</font><br>确认</td><td  colspan="2"></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td rowspan="2" align="center">CLQ<br>序号</td><td rowspan="2" align="center">起止</td><td rowspan="2" align="center">TCQ编号</td><td rowspan="2" align="center">NFC序列号<br>(11位)</td><td colspan="2" align="center">TCQ位置信息</td><td rowspan="2" align="center">施工方</td><td rowspan="2" align="center">HFXS</td>	</tr>';
			pageHtml = pageHtml + '<tr height="30px"><td align="center">经度</td><td align="center">纬度</td></tr>';
			
		    var startIndex = (page - 1) * 20;
			for(var m=0; m<20; m++){
				var detectorObj = emptyDetector;
				//输出探测器信息行
				var detectorLineHtml = '<tr height="30px">';
				detectorLineHtml = detectorLineHtml + '<td width="50px" class="font14">'+ '' + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="70px" class="font14">'+ '' + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.detector_seq + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="100px" class="font14">'+ detectorObj.nfc_number + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="80px" class="font14">'+ detectorObj.longitude + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="80px" class="font14">'+ detectorObj.latitude + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="90px" class="font14">'+ '' + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="90px" class="font14">'+ '' + '</td>';
				detectorLineHtml = detectorLineHtml + '</tr>';
				pageHtml = pageHtml + detectorLineHtml;
			}
			pageHtml = pageHtml + '</table><div style="height:47px">&nbsp;</div></div>';
			$('#printDiv').append(pageHtml);			
		}
	}
});

</script>
</body>
</html>