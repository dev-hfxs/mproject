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
}
