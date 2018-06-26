<%@ page pageEncoding="UTF-8"%>
<%
	// no use 
	String path = request.getContextPath();
	String pageSize = request.getParameter("pageSize");
	String pageNum = request.getParameter("pageNum");
	String boxId = request.getParameter("boxId");
	String entrance = request.getParameter("entrance");
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
html{-webkit-text-size-adjust: none;}
.fontTitle{
	font-size:18px;
}

.font14{
	font-size:13px;
}

.font2{
	font-size:0.5px;
}
.pos-text{
    transform:scale(0.1);
}
.small-font{
            font-size: 12px;
            -webkit-transform-origin-x: 0;
            -webkit-transform: scale(0.001);
}
</style>
</head>
<body>
	<div id= "tbDiv" data-options="region:'north',border:false" style="height:36px">
		<a href="#" class="easyui-linkbutton" onclick="doPrint()" iconCls="icon-print">&nbsp;打印&nbsp;</a>
	</div>
	<div  id="printDiv" data-options="border:false,fit:true">
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
	    	'boxId':'<%=boxId%>',
	    	'entrance':'<%=entrance%>',
	    	'reportName':'探测器验收安装表',
	    	'userName':'${loginUser.user_name}'
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

	var emptyData = {build_manager:'', project_manager:'', create_date:'', org_name:'',install_engineer:'', install_space:'', box_number:'', nfc_number:'', longitude:'', latitude:'', pos_desc:'', ip:'', moxa_number:'', detectors:[]};
	var emptyDetector = {detector_seq:'', nfc_number:'', longitude:'', latitude:'', gcj_longitude:'', gcj_latitude:'', start_pos:'', end_pos:'', pos_desc:'' };
	
	if(deviceDatas.length < 1){
		//没有数据时显示一个空行
		deviceDatas[deviceDatas.length] = emptyData;
	}
	
	for(var i=0; i<deviceDatas.length; i++){
		var processorObj = deviceDatas[i];
		var detectors = processorObj.detectors;
		var modNum = detectors.length % 20;
		var clqSeq = i + 1;
		var page = 1;
		if(detectors.length > 0){
			//if(modNum == 0){
			//	page = detectors.length / 20;
			//}else{
			//	page = detectors.length / 20 + 1;
			//}
			page = Math.ceil(detectors.length / 20);
			//分页输出内容
			//<br><span class="font2">年2/行业3/序列号5</span>
			
			//for(var j=0; j<24; j++){
			for(var j=0; j<page; j++){
				var pageHtml = '';
				var curPage = j + 1;
				pageHtml = '<div style="margin: 10px 10px 10px 10px;"><table border="1" cellspacing="0" cellpadding="0">';
				pageHtml = pageHtml + '<tr height="40px"><td colspan="10" align="center"><span class="fontTitle">智能融合处理器单元和探测器安装记录表 (' + curPage + ')</span></td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2"  align="center">安装人员</td><td  colspan="4"><span class="font14">'+ processorObj.build_manager +'</span></td><td colspan="2" align="center">施工单位</td><td  colspan="2"><span class="font14">' + '天津航峰希萨科技有限公司' + '</span></td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2"  align="center">项目经理</td><td  colspan="4"><span class="font14">'+ processorObj.project_manager +'</span></td><td colspan="2" align="center">安装时间</td><td  colspan="2"><span class="font14">' + processorObj.create_date + '</span></td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2"  align="center">工程师</td><td  colspan="4"><span class="font14">'+ processorObj.install_engineer +'</span></td><td colspan="2" align="center">安装间距</td><td  colspan="2"><span class="font14">' + processorObj.install_space + '</span></td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2" align="center">机箱编号</td><td  colspan="2"><span class="font14">' + processorObj.box_number + '</span></td><td  colspan="2"  align="left"><span class="font14">CLQ序号:</span>&nbsp;'+clqSeq+'</td><td  colspan="2"  align="right"><span class="font14">CLQNFC序列号</span>&nbsp;</td><td  colspan="2"><span class="font14">'+ processorObj.nfc_number + '</span></td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2" align="center">机箱位置</td><td colspan="2"><span class="font14">经度:'+ processorObj.longitude +'</span><br><span class="font14">纬度:'+ processorObj.latitude + '</span></td><td  colspan="4"><span class="font14">' + processorObj.pos_desc+'</span></td><td  colspan="2"><span class="font14">MOXA序列号:</span><br><span class="font14">' + processorObj.moxa_number + '</span></td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td colspan="2" align="center">IP</td><td colspan="4">&nbsp;<span class="font14">' + processorObj.ip + '</span></td><td  colspan="2" width="120px" align="center">软件工程师确认</td><td  colspan="2"></td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td rowspan="2" align="center">TCQ-NFC<br>序列号(14位)</td><td rowspan="2" align="center">起止</td><td rowspan="2" align="center">TCQ<br>编号</td><td colspan="4" align="center">TCQ位置信息</td><td rowspan="2" width="60px" style="border-right-style:none">&nbsp;</td><td rowspan="2"  width="100px" style="border-left-style:none;border-right-style:none" align="center">位置描述</td><td rowspan="2"  width="60px" style="border-left-style:none;" width="60px">&nbsp;</td></tr>';
				pageHtml = pageHtml + '<tr height="30px"><td align="center"><span class="font14">经度</span></td><td align="center"><span class="font14">纬度</span></td><td align="center"><span class="font14">北斗经度</span></td><td align="center"><span class="font14">北斗纬度</span></td></tr>';
				
				var startIndex = (curPage - 1) * 20;
				for(var m=0; m<20; m++){
					var index = startIndex + m;
					var detectorObj = emptyDetector;
					if(detectors.length > index){
						detectorObj = detectors[index];
					}
					var startPos = detectorObj.start_point;
					var endPos = detectorObj.end_point;
					var startOrEndPos = '';
					if(startPos == 'Y'){
						startOrEndPos = '起点';
					}else if (endPos == 'Y'){
						startOrEndPos = '终点';
					}else{
						//
					}
					
					var detectorPos = detectorObj.pos_desc;
					if(detectorPos != null && detectorPos.length > 18){
						var hzLen = 0;
						for(var n = 0; n<detectorPos.length; n++){
							if(detectorPos.charCodeAt(n) > 255){
								hzLen = hzLen + 2;
							}else{
								hzLen = hzLen + 1;
							}
							if(hzLen >= 36){
								detectorPos = detectorPos.substring(0,n) + "<br>" + detectorPos.substring(n);
								break;
							}
						}
					}
					
					//输出探测器信息行
					var detectorLineHtml = '<tr height="36px">';
					detectorLineHtml = detectorLineHtml + '<td width="100px" class="font14"><span>'+ detectorObj.nfc_number + '</span></td>';
					detectorLineHtml = detectorLineHtml + '<td width="50px" class="font14" align="center">'+ startOrEndPos + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="50px" class="font14" align="center">'+ detectorObj.detector_seq + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.longitude + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.latitude + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.gcj_longitude + '</td>';
					detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.gcj_latitude + '</td>';
					detectorLineHtml = detectorLineHtml + '<td class="font14" colspan="3">&nbsp;'+ '<span class="small-font">' + detectorPos + '</td>';
					detectorLineHtml = detectorLineHtml + '</tr>';
					
					pageHtml = pageHtml + detectorLineHtml;
				}
				pageHtml = pageHtml + '</table><div style="height:2px">&nbsp;</div></div>';
				$('#printDiv').append(pageHtml);
			}
		}else{
			var detectorObj = emptyDetector;
			var pageHtml = '';
			var curPage = 1;
			pageHtml = '<div style="margin: 10px 10px 10px 10px;"><table border="1" cellspacing="0" cellpadding="0">';
			pageHtml = pageHtml + '<tr height="40px"><td colspan="10" align="center"><span class="fontTitle">智能融合处理器单元和探测器安装记录表 (' + curPage + ')</span></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2"  align="center">安装人员</td><td  colspan="4"><span class="font14">'+ processorObj.build_manager +'</span></td><td colspan="2" align="center">施工单位</td><td  colspan="2"><span class="font14">' + '天津航峰希萨科技有限公司' + '</span></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2"  align="center">项目经理</td><td  colspan="4"><span class="font14">'+ processorObj.project_manager +'</span></td><td colspan="2" align="center">安装时间</td><td  colspan="2"><span class="font14">' + processorObj.create_date + '</span></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2"  align="center">工程师</td><td  colspan="4"><span class="font14">'+ processorObj.install_engineer +'</span></td><td colspan="2" align="center">安装间距</td><td  colspan="2"><span class="font14">' + processorObj.install_space + '</span></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2" align="center">机箱编号</td><td  colspan="2"><span class="font14">' + processorObj.box_number + '</span></td><td  colspan="2"  align="left"><span class="font14">CLQ序号:</span>&nbsp;'+clqSeq+'</td><td  colspan="2"  align="right"><span class="font14">CLQNFC序列号</span>&nbsp;</td><td  colspan="2"><span class="font14">'+ processorObj.nfc_number + '</span></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2" align="center">机箱位置</td><td colspan="2"><span class="font14">经度:'+ processorObj.longitude +'</span><br><span class="font14">纬度:'+ processorObj.latitude + '</span></td><td  colspan="4"></td><td  colspan="2"><span class="font14">MOXA序列号:</span><br><span class="font14">' + processorObj.moxa_number + '</span></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td colspan="2" align="center">IP</td><td colspan="4">&nbsp;<span class="font14">' + processorObj.ip + '</span></td><td  colspan="2" width="120px" align="center">软件工程师确认</td><td  colspan="2"></td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td rowspan="2" align="center">TCQ-NFC<br>序列号(14位)</td><td rowspan="2" align="center">起止</td><td rowspan="2" align="center">TCQ<br>编号</td><td colspan="4" align="center">TCQ位置信息</td><td rowspan="2" width="60px" style="border-right-style:none">&nbsp;</td><td rowspan="2"  width="100px" style="border-left-style:none;border-right-style:none" align="center">位置描述</td><td rowspan="2"  width="60px" style="border-left-style:none;" width="60px">&nbsp;</td></tr>';
			pageHtml = pageHtml + '<tr height="30px"><td align="center"><span class="font14">经度</span></td><td align="center"><span class="font14">纬度</span></td><td align="center"><span class="font14">北斗经度</span></td><td align="center"><span class="font14">北斗纬度</span></td></tr>';
			
		    var startIndex = (page - 1) * 20;
			for(var m=0; m<20; m++){
				var detectorObj = emptyDetector;
				var startPos = detectorObj.start_point;
				var endPos = detectorObj.end_point;
				var startOrEndPos = '';
				if(startPos == 'Y'){
					startOrEndPos = '起点';
				}else if (endPos == 'Y'){
					startOrEndPos = '终点';
				}else{
					//
				}
				var detectorLineHtml = '<tr height="36px">';
				detectorLineHtml = detectorLineHtml + '<td width="100px" class="font14"><span>'+ detectorObj.nfc_number + '</span></td>';
				detectorLineHtml = detectorLineHtml + '<td width="50px" class="font14" align="center">'+ startOrEndPos + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="50px" class="font14" align="center">'+ detectorObj.detector_seq + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.longitude + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.latitude + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.gcj_longitude + '</td>';
				detectorLineHtml = detectorLineHtml + '<td width="60px" class="font14">'+ detectorObj.gcj_latitude + '</td>';
				detectorLineHtml = detectorLineHtml + '<td class="font14" colspan="3">&nbsp;'+ '<span class="small-font">' +'' + '</td>';
				detectorLineHtml = detectorLineHtml + '</tr>';
				
				pageHtml = pageHtml + detectorLineHtml;
			}
			pageHtml = pageHtml + '</table><div style="height:2px">&nbsp;</div></div>';
			$('#printDiv').append(pageHtml);
		}
	}
});

</script>
</body>
</html>