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
	public Map<String, String> addOrg(HttpServletRequest request) {	
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
}
