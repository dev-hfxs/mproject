/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月19日
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
import com.sierotech.mproject.server.service.IOrgService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月19日
* @功能描述: 单位管理控制层处理
 */
@Controller
@RequestMapping("/org/mgr/")
@Scope("request")
public class OrgMgrControl {
	
	@Autowired
	IOrgService orgService;
	
	
	@RequestMapping(value = "/checkOrg")
	@ResponseBody
	public Map<String, String> checkUser(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String msg = "";
		String orgId = request.getParameter("id");
		if(orgId == null) {
			result.put("msg", "单位名验证参数错误,缺少单位ID.");
			return result;
		}
		String orgName = request.getParameter("orgName");
		if(orgName == null) {
			result.put("msg", "单位名验证参数错误,缺少单位名.");
			return result;
		}
		boolean orgExist = true;
		try {
			orgExist = orgService.checkOrgExist(orgId, orgName);
		}catch(BusinessException be) {
			msg = be.getMessage();
		}
		if (orgExist) {
			result.put("orgExist", "true");
		}else {
			result.put("orgExist", "false");
		}
		result.put("returnCode", "success");
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addOrg(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map orgObj = ControllerUtils.toMap(request);
		if(null == orgObj.get("orgName")) {
			result.put("msg", "添加单位参数错误,缺少单位名.");
			return result;
		}
		if(null == orgObj.get("orgCode")) {
			result.put("msg", "添加单位参数错误,缺少单位编码.");
			return result;
		}
		if(null == orgObj.get("taxNumber")) {
			result.put("msg", "添加单位参数错误,缺少单位税号.");
			return result;
		}
		
		try {
			orgService.addOrg(UserTool.getLoginUser(request).get("user_name"), orgObj);
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
	public Map<String, String> updateOrg(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map orgObj = ControllerUtils.toMap(request);
		if(null == orgObj.get("orgName")) {
			result.put("msg", "修改单位参数错误,缺少单位名.");
			return result;
		}
		if(null == orgObj.get("orgCode")) {
			result.put("msg", "修改单位参数错误,缺少单位编码.");
			return result;
		}
		if(null == orgObj.get("taxNumber")) {
			result.put("msg", "修改单位参数错误,缺少单位税号.");
			return result;
		}
		
		try {
			orgService.updateOrg(UserTool.getLoginUser(request).get("user_name"), orgObj);
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
	public Map<String, String> deleteOrg(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map orgObj = ControllerUtils.toMap(request);
		
		if(null == orgObj.get("id")) {
			result.put("msg", "删除单位错误,缺少单位ID.");
			return result;
		}
		try {
			orgService.deleteOrg(UserTool.getLoginUser(request).get("user_name"), orgObj.get("id").toString());
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/recover")
	@ResponseBody
	public Map<String, String> recoverUser(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map orgObj = ControllerUtils.toMap(request);
		
		if(null == orgObj.get("id")) {
			result.put("msg", "恢复单位错误,缺少单位ID.");
			return result;
		}
		try {
			orgService.recoverOrg(UserTool.getLoginUser(request).get("user_name"), orgObj.get("id").toString());
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
}
