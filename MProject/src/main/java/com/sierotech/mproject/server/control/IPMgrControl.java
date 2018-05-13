/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月11日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.control;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ControllerUtils;
import com.sierotech.mproject.common.utils.UserTool;
import com.sierotech.mproject.common.utils.excel.ParseExcelData;
import com.sierotech.mproject.context.AppContext;
import com.sierotech.mproject.server.service.IPService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月11日
* @功能描述: ip管理控制层
 */
@Controller
@RequestMapping("/ip/mgr/")
@Scope("request")
public class IPMgrControl {
	static final Logger log = LoggerFactory.getLogger(IPMgrControl.class);
	
	@Autowired
	IPService ipService;
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addIp(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map ipObj = ControllerUtils.toMap(request);
		if(null == ipObj.get("netName")) {
			result.put("msg", "添加IP错误, 缺少网段名称.");
			return result;
		}
		if(null == ipObj.get("projectId")) {
			result.put("msg", "添加IP错误, 缺少参数所属项目.");
			return result;
		}
		if(null == ipObj.get("ip")) {
			result.put("msg", "添加IP错误, 缺少参数IP.");
			return result;
		}
		if(null == ipObj.get("gateway")) {
			result.put("msg", "添加IP错误, 缺少参数网关.");
			return result;
		}
		if(null == ipObj.get("netMask")) {
			result.put("msg", "添加IP错误, 缺少子网掩码.");
			return result;
		}
		try {
			ipService.addIP(UserTool.getLoginUser(request).get("user_name"), ipObj);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/update")
	@ResponseBody
	public Map<String, String> updateIp(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map ipObj = ControllerUtils.toMap(request);
		if(null == request.getParameter("id")) {
			result.put("msg", "修改IP错误, 未指定IP的ID.");
			return result;
		}
		
		if(null == ipObj.get("netName")) {
			result.put("msg", "修改IP错误, 缺少网段名称.");
			return result;
		}
		if(null == ipObj.get("projectId")) {
			result.put("msg", "修改IP错误, 缺少参数所属项目.");
			return result;
		}
		if(null == ipObj.get("ip")) {
			result.put("msg", "修改IP错误, 缺少参数IP.");
			return result;
		}
		if(null == ipObj.get("gateway")) {
			result.put("msg", "修改IP错误, 缺少参数网关.");
			return result;
		}
		if(null == ipObj.get("netMask")) {
			result.put("msg", "修改IP错误, 缺少子网掩码.");
			return result;
		}
		try {
			ipService.updateIP(UserTool.getLoginUser(request).get("user_name"), ipObj);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, String> deleteIp(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		if(null == request.getParameter("id")) {
			result.put("msg", "删除IP错误, 未指定删除IP的ID.");
			return result;
		}
		
		try {
			ipService.deleteIP(UserTool.getLoginUser(request).get("user_name"), request.getParameter("id"));
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	

	@RequestMapping(value = "/updateStatus")
	@ResponseBody
	public Map<String, String> updateStatus(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		if(null == request.getParameter("id")) {
			result.put("msg", "标记IP错误, 未指定IP的ID.");
			return result;
		}
		
		if(null == request.getParameter("status")) {
			result.put("msg", "标记IP错误, 未指定IP的状态.");
			return result;
		}
		String userId = UserTool.getLoginUser(request).get("id");
		
		try {
			ipService.updateStatus(userId, request.getParameter("id"), request.getParameter("status"));
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	
	@RequestMapping(value = "/ipImport")
	@ResponseBody
	public Map<String, String> importCode(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String msg = "";
		String projectId = request.getParameter("projectId");
		if(projectId == null) {
			result.put("msg", "IP导入错误, 请指定IP对应的项目.");
			return result;
		}
		MultipartHttpServletRequest mreq = (MultipartHttpServletRequest ) request;
		if(mreq.getFileMap() == null) {
			result.put("msg", "IP导入错误, 未提交文件.");
			return result;
		}

		MultipartFile fileT = mreq.getFileMap().get("dataFile");
		if(fileT == null) {
			result.put("msg", "IP导入错误, 未提交文件.");
			return result;
		}
		String filename = fileT.getOriginalFilename();
		int index = filename.lastIndexOf(".");
		String postfix = filename.substring(index + 1);
		if ("xls".equals(postfix) || "xlsx".equals(postfix)) {
			
		}else {
			result.put("msg", "IP导入错误, 文件类型错误.");
			return result;
		}
		Map<String, Object> dataMap;
		String templateName = "ip-info";
		try {
			dataMap = ParseExcelData.getInstance().readFile(fileT.getInputStream(), filename,AppContext.getExcelTemplateMeta(templateName));
		}catch(IOException ioe) {
			log.info(ioe.getMessage());
			result.put("msg", "IP导入错误, 解析数据文件出错.");
			return result;
		}
		if(dataMap == null) {
			result.put("msg", "IP导入错误, 解析数据文件出错.");
			return result;
		}
		String dataRows = dataMap.get("allRows").toString();
		int iDataRows = 0;
		try {
			iDataRows = Integer.parseInt(dataRows);
		}catch(NumberFormatException ne) {
			result.put("msg", "IP导入错误, 文件没有有效的数据.");
			return result;
		}
		List<Map<String, String>> alDatas = (List<Map<String, String>>)dataMap.get("validData");
		if(iDataRows == 0) {
			result.put("msg", "IP导入错误, 文件没有有效的数据.");
			return result;
		}
		if(iDataRows > alDatas.size()) {
			result.put("msg", "IP导入错误, 文件中的数据不完整.");
			return result;
		}
		try {
			ipService.update4ImportIp(projectId, alDatas);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", msg);
		return result;
	}
	
}
