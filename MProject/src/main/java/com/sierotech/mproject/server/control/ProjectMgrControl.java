/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月20日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.control;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ControllerUtils;
import com.sierotech.mproject.common.utils.UserTool;
import com.sierotech.mproject.server.service.IProjectService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月20日
* @功能描述: 
 */
@Controller
@RequestMapping("/project/mgr/")
@Scope("request")
public class ProjectMgrControl {

	@Autowired
	IProjectService projectService;
	
	@RequestMapping(value = "/checkName")
	@ResponseBody
	public Map<String, String> checkProjectName(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String msg = "";
		String projectId = request.getParameter("id");
		if(projectId == null) {
			result.put("msg", "项目名验证错误,缺少项目ID.");
			return result;
		}
		String projectName = request.getParameter("projectName");
		if(projectName == null) {
			result.put("msg", "项目名验证错误,缺少项目名.");
			return result;
		}
		boolean projectExist = true;
		try {
			projectExist = projectService.checkProjectName(projectId, projectName);
		}catch(BusinessException be) {
			msg = be.getMessage();
		}
		if (projectExist) {
			result.put("projectExist", "true");
		}else {
			result.put("projectExist", "false");
		}
		result.put("returnCode", "success");
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addProject(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map projectObj = ControllerUtils.toMap(request);
		if(null == projectObj.get("projectName")) {
			result.put("msg", "添加项目错误,缺少项目名.");
			return result;
		}
		if(null == projectObj.get("projectNumber")) {
			result.put("msg", "添加项目错误,缺少项目编码.");
			return result;
		}
		if(null == projectObj.get("contractNumber")) {
			result.put("msg", "添加项目错误,缺少合同号.");
			return result;
		}
		
		try {
			projectService.addProject(UserTool.getLoginUser(request).get("user_name"), projectObj);
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
	public Map<String, String> updateProject(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map projectObj = ControllerUtils.toMap(request);
		if(null == projectObj.get("projectName")) {
			result.put("msg", "修改项目错误,缺少项目名.");
			return result;
		}
		if(null == projectObj.get("projectNumber")) {
			result.put("msg", "修改项目错误,缺少项目编码.");
			return result;
		}
		if(null == projectObj.get("contractNumber")) {
			result.put("msg", "修改项目错误,缺少合同号.");
			return result;
		}
		
		try {
			projectService.updateProject(UserTool.getLoginUser(request).get("user_name"), projectObj);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/addProjectPsn")
	@ResponseBody
	public Map<String, String> addProjectPsn(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String projectId = request.getParameter("projectId").toString();
		String userId = request.getParameter("userId").toString();
		String strAllowBoxNum = request.getParameter("allowBoxNum").toString();
		String duty = "S";
		if(null == projectId) {
			result.put("msg", "设置项目施工经理错误,缺少项目ID.");
			return result;
		}
		if(null == userId) {
			result.put("msg", "设置项目施工经理错误,缺少用户ID.");
			return result;
		}
		if(null == strAllowBoxNum) {
			result.put("msg", "设置项目施工经理错误,缺少用户应建机箱数.");
			return result;
		}
		int allowBoxNum = 0;
		try {
			allowBoxNum = Integer.parseInt(strAllowBoxNum);
			projectService.addProjectPsn(UserTool.getLoginUser(request).get("user_name"), projectId, userId, allowBoxNum, duty);
		}catch( NumberFormatException ne) {
			result.put("msg", "应建机箱数错误!");
			return result;
		}
		catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/deleteProjectPsn")
	@ResponseBody
	public Map<String, String> deleteProjectPsn(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String projectId = request.getParameter("projectId").toString();
		String userId = request.getParameter("userId").toString();
		String duty = "S";
		if(null == projectId) {
			result.put("msg", "删除项目施工经理错误,缺少项目ID.");
			return result;
		}
		if(null == userId) {
			result.put("msg", "删除项目施工经理错误,缺少用户ID.");
			return result;
		}
		
		try {
			projectService.deleteProjectPsn(UserTool.getLoginUser(request).get("user_name"), projectId, userId);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/projectPsnBoxnumReset")
	@ResponseBody
	public Map<String, String> updateProjectPsnBoxNum(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String projectId = request.getParameter("projectId").toString();
		String userId = request.getParameter("userId").toString();
		String oldAllowBoxNum = request.getParameter("oldAllowBoxNum").toString();
		String allowBoxNum = request.getParameter("allowBoxNum").toString();
		if(null == projectId) {
			result.put("msg", "修改施工经理应建机箱数错误,缺少项目ID.");
			return result;
		}
		if(null == userId) {
			result.put("msg", "修改施工经理应建机箱数错误,缺少用户ID.");
			return result;
		}
		if(null == userId) {
			result.put("msg", "修改施工经理应建机箱数错误,缺少用户ID.");
			return result;
		}
		int iOldAllowBoxNum = 0;
		int iAllowBoxNum = 0;
		try {
			iOldAllowBoxNum = Integer.parseInt(oldAllowBoxNum);
			iAllowBoxNum = Integer.parseInt(allowBoxNum);
		}catch(NumberFormatException ne) {
			result.put("msg", "修改施工经理应建机箱数错误,机箱数应为数字.");
			return result;
		}
		try {
			projectService.updateProjectPsnBoxNum(UserTool.getLoginUser(request).get("user_name"), projectId, userId, iOldAllowBoxNum, iAllowBoxNum);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/closeProject")
	@ResponseBody
	public Map<String, String> closeProject(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String projectId = request.getParameter("projectId").toString();
		
		if(null == projectId) {
			result.put("msg", "结束项目错误,缺少项目ID.");
			return result;
		}
		
		try {
			projectService.updateProject4Close(UserTool.getLoginUser(request).get("user_name"), projectId);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/deleteManager")
	@ResponseBody
	public Map<String, String> deleteManager(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String projectId = request.getParameter("projectId").toString();
		
		if(null == projectId) {
			result.put("msg", "移除项目经理,缺少项目ID.");
			return result;
		}
		
		try {
			projectService.deleteProjectManager(UserTool.getLoginUser(request).get("user_name"), projectId);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
}
