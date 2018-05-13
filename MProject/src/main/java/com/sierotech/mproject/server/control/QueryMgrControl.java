/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月4日
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
import com.sierotech.mproject.server.service.IQueryService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月4日
* @功能描述: 查询管理控制层
 */
@Controller
@RequestMapping("/query/mgr/")
@Scope("request")
public class QueryMgrControl {
	
	@Autowired
	IQueryService querySerive;
	
	@RequestMapping(value = "/code/produce")
	@ResponseBody
	public Map<String, String> produceCode(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map codeObj = ControllerUtils.toMap(request);
		if (null == codeObj.get("projectId")) {
			result.put("msg", "生成验证码错误, 缺少有效项目ID!");
			return result;
		}
		if (null == codeObj.get("targetUser")) {
			result.put("msg", "生成验证码错误, 缺少验证码使用用户!");
			return result;
		}
		if (null == codeObj.get("codeType")) {
			result.put("msg", "生成验证码错误, 缺少验证码类型!");
			return result;
		}		
		if (null == codeObj.get("validTime")) {
			result.put("msg", "生成验证码错误, 缺少有效时长!");
			return result;
		}
		
		try {
			querySerive.createCode(UserTool.getLoginUser(request).get("user_name"), codeObj);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/queryInfo")
	@ResponseBody
	public Map<String, String> queryInfo(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		
		if (null == request.getParameter("queryType")) {
			result.put("msg", "信息查询错误, 缺少查询方式!");
			return result;
		}
		String queryType = request.getParameter("queryType");
		
		if (null == request.getParameter("searchValue")) {
			result.put("msg", "信息查询错误, 缺少查询的值!");
			return result;
		}
		String searchValue = request.getParameter("searchValue");
		
		if (null == request.getParameter("searchCode")) {
			result.put("msg", "信息查询错误, 缺少查询验证码!");
			return result;
		}
		String searchCode = request.getParameter("searchCode").toUpperCase();
		Map<String,Object> verCodeMap = null;
		try {
			String targetUser = UserTool.getLoginUser(request).get("id").toString();
			verCodeMap = querySerive.queryInfo(targetUser, queryType, searchValue, searchCode);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		if(verCodeMap != null) {
			result.put("returnCode", "success");
			result.put("queryProject", verCodeMap.get("project_id") == null ? "" : verCodeMap.get("project_id").toString());
			result.put("codeType", queryType);
		}
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/updateInfo")
	@ResponseBody
	public Map<String, String> updateInfo(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		
		if (null == request.getParameter("operationPart")) {
			result.put("msg", "信息修改错误, 未指定修改部分!");
			return result;
		}
		String operationPart = request.getParameter("operationPart");
		
		if (null == request.getParameter("updateField")) {
			result.put("msg", "信息修改错误, 未指定修改字段!");
			return result;
		}
		String updateField = request.getParameter("updateField");
		
		if (null == request.getParameter("dataIndexValue")) {
			result.put("msg", "信息修改错误, 未指定修改索引值!");
			return result;
		}
		String dataIndexValue = request.getParameter("dataIndexValue");
		
		if (null == request.getParameter("oldValue")) {
			result.put("msg", "信息修改错误, 未指定修改前的值!");
			return result;
		}
		String oldValue = request.getParameter("oldValue");
		
		if (null == request.getParameter("newValue")) {
			result.put("msg", "信息修改错误, 未指定修改后的值!");
			return result;
		}
		String newValue = request.getParameter("newValue");
		if (null == request.getParameter("searchCode")) {
			result.put("msg", "信息修改错误, 缺少修改验证码!");
			return result;
		}
		String searchCode = request.getParameter("searchCode");
		
		String dataIndex = "";
	    if("box".equals(operationPart)){
	    	dataIndex = "box_number";
	    }
	    if("processor".equals(operationPart)){
	    	dataIndex = "nfc_number";
	    }
	    if("detector".equals(operationPart)){
	    	dataIndex = "nfc_number";
	    }
	    
		Map<String,Object> verCodeMap = null;
		try {
			String targetUser = UserTool.getLoginUser(request).get("id").toString();
			querySerive.updateInfo(targetUser, operationPart, updateField, dataIndex, dataIndexValue, oldValue, newValue, searchCode);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
}
