/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月24日
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
import com.sierotech.mproject.server.service.IJobService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月24日
* @功能描述: 工单管理控制层处理
 */
@Controller
@RequestMapping("/job/mgr/")
@Scope("request")

public class JobMgrControl {
	
	@Autowired
	IJobService jobService;
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addUser(HttpServletRequest request) {
		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map jobObj = ControllerUtils.toMap(request);
		if(null == jobObj.get("projectId")) {
			result.put("msg", "发布工单错误,缺少项目ID.");
			return result;
		}
		if(null == jobObj.get("machineBoxId")) {
			result.put("msg", "发布工单错误,缺少机箱ID.");
			return result;
		}
		if(null == jobObj.get("jobType")) {
			result.put("msg", "发布工单错误,缺少工单类型.");
			return result;
		}
		
		if(null == jobObj.get("processPerson")) {
			result.put("msg", "发布工单错误,缺少工单处理人.");
			return result;
		}
		if(null == jobObj.get("workContent")) {
			result.put("msg", "发布工单错误,缺少工单工作内容.");
			return result;
		}
		try {
			jobService.addJob(UserTool.getLoginUser(request).get("user_name"), jobObj);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
}
