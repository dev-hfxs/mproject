/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月27日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.control;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ControllerUtils;
import com.sierotech.mproject.common.utils.JsonUtil;
import com.sierotech.mproject.common.utils.UserTool;
import com.sierotech.mproject.server.service.IBoxService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月27日
* @功能描述: 机箱管理控制层
 */

@Controller
@RequestMapping("/box/mgr/")
@Scope("request")
public class BoxMgrControl {
	static final Logger log = LoggerFactory.getLogger(BoxMgrControl.class);
	
	@Autowired
	IBoxService boxService;
	
	@RequestMapping(value = "/checkBoxNumber")
	@ResponseBody
	public Map<String, String> checkUser(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String msg = "";
		String boxId = request.getParameter("boxId");
		if(boxId == null) {
			result.put("msg", "机箱编号验证,缺少ID.");
			return result;
		}
		String boxNumber = request.getParameter("boxNumber");
		if(boxNumber == null) {
			result.put("msg", "机箱编号验证,缺少机箱编号.");
			return result;
		}
		boolean boxExist = true;
		try {
			boxExist = boxService.checkBoxNumber(boxId, boxNumber);
		}catch(BusinessException be) {
			msg = be.getMessage();
		}
		if (boxExist) {
			result.put("exist", "true");
		}else {
			result.put("exist", "false");
		}
		result.put("returnCode", "success");
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addBox(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map boxObj = ControllerUtils.toMap(request);
		if (null == boxObj.get("userId")) {
			result.put("msg", "添加机箱错误,缺少施工经理参数!");
			return result;
		}
		if (null == boxObj.get("orgId")) {
			result.put("msg", "添加机箱错误,缺少组织单位!");
			return result;
		}
		if (null == boxObj.get("projectId")) {
			result.put("msg", "添加机箱错误,缺少项目ID!");
			return result;
		}		
		if (null == boxObj.get("boxNumber")) {
			result.put("msg", "添加机箱错误,缺少机箱编号!");
			return result;
		}
		if (null == boxObj.get("nfcNumber")) {
			result.put("msg", "添加机箱错误,缺少机箱NFC序列号!");
			return result;
		}
		if (null == boxObj.get("longitude")) {
			result.put("msg", "添加机箱错误,缺少经度!");
			return result;
		}
		if (null == boxObj.get("latitude")) {
			result.put("msg", "添加机箱错误,缺少纬度!");
			return result;
		}
		if (null == boxObj.get("processorNum")) {
			result.put("msg", "添加机箱错误,处理器数量!");
			return result;
		}
		
		try {
			boxService.addBox(UserTool.getLoginUser(request).get("user_name"), boxObj);
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
	public Map<String, String> updateBox(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map boxObj = ControllerUtils.toMap(request);
				
		if (null == boxObj.get("boxNumber")) {
			result.put("msg", "修改机箱错误,缺少机箱编号!");
			return result;
		}
		if (null == boxObj.get("nfcNumber")) {
			result.put("msg", "修改机箱错误,缺少NFC序列号!");
			return result;
		}
		if (null == boxObj.get("longitude")) {
			result.put("msg", "修改机箱错误,缺少经度!");
			return result;
		}
		if (null == boxObj.get("latitude")) {
			result.put("msg", "修改机箱错误,缺少纬度!");
			return result;
		}
		if (null == boxObj.get("processorNum")) {
			result.put("msg", "修改机箱错误,处理器数量!");
			return result;
		}
		
		try {
			boxService.updateBox(UserTool.getLoginUser(request).get("user_name"), boxObj);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Map<String, String> deleteBox(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");	
		if(null == request.getParameter("id")) {
			result.put("msg", "删除机箱错误,缺少ID.");
			return result;
		}
		try {
			boxService.deleteBox(UserTool.getLoginUser(request).get("user_name"), request.getParameter("id"));
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/submit")
	@ResponseBody
	public Map<String, String> submitBox(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");	
		if(null == request.getParameter("id")) {
			result.put("msg", "提交机箱错误,缺少ID.");
			return result;
		}
		try {
			boxService.updateBox4Submit(UserTool.getLoginUser(request).get("user_name"), request.getParameter("id"));
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/reset/status")
	@ResponseBody
	public Map<String, String> resetBoxStatus(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		if(null == request.getParameter("boxId")) {
			result.put("msg", "设置机箱允许修改错误,缺少机箱ID.");
			return result;
		}
		try {
			boxService.updateBox4Edit(UserTool.getLoginUser(request).get("user_name"), request.getParameter("boxId"));
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/accept")
	@ResponseBody
	public Map<String, String> acceptBox(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		if(null == request.getParameter("boxId")) {
			result.put("msg", "确认验收机箱错误,缺少机箱ID.");
			return result;
		}
		if(null == request.getParameter("fileInfos")) {
			result.put("msg", "机箱验收确认, 未上传确认的附件.");
			return result;
		}
		String fileInfos = request.getParameter("fileInfos");
		List<Map> acceptFileList = null;
		try {
			acceptFileList = JsonUtil.jsonToList(fileInfos, Map.class);
		}catch(Exception e) {
			log.info(e.getMessage());
			result.put("msg", "机箱验收确认、上传验收文件错误.");
			return result;
		}
		
		try {
			boxService.updateBox4Accept(UserTool.getLoginUser(request).get("user_name"), request.getParameter("boxId"), acceptFileList);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	//获取设备安装记录表
	@RequestMapping(value = "/getDeviceLog")
	@ResponseBody
	public Map<String, Object> queryPrintData(HttpServletRequest request) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("returnCode", "fail");
		if(null == request.getParameter("boxId")) {
			result.put("msg", "获取打印数据错误,缺少机箱ID.");
			return result;
		}
		String curUserName = UserTool.getLoginUser(request).get("user_name");
		String boxId = request.getParameter("boxId");		
		String userName = request.getParameter("userName");
		String entrance = request.getParameter("entrance");
		String reportName = request.getParameter("reportName");		
		
		
		List<Map<String, Object>> datas = null;
		//获取数据
		try {
			datas = boxService.queryDeviceLog(curUserName, boxId, entrance, reportName);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("datas", datas);
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
}
