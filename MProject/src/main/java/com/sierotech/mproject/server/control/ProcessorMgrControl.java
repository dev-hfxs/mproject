/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月29日
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
import com.sierotech.mproject.server.service.IProcessorService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月29日
* @功能描述: 
 */
@Controller
@RequestMapping("/processor/mgr/")
@Scope("request")
public class ProcessorMgrControl {
	
	@Autowired
	IProcessorService processorService;
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addProcessor(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map processorObj = ControllerUtils.toMap(request);
		if (null == processorObj.get("boxId")) {
			result.put("msg", "添加处理器错误,缺少机箱ID!");
			return result;
		}		
		if (null == processorObj.get("nfcNumber")) {
			result.put("msg", "添加处理器错误,缺少NFC序列号!");
			return result;
		}
		if (null == processorObj.get("moxaNumber")) {
			result.put("msg", "添加处理器错误,缺少MOXA-NFC序列号!");
			return result;
		}
		if (null == processorObj.get("detectorNum")) {
			result.put("msg", "添加处理器错误,探测器数量!");
			return result;
		}
		try {			
			processorService.addProcessor(UserTool.getLoginUser(request).get("user_name"), processorObj);
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
	public Map<String, String> updateProcessor(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map processorObj = ControllerUtils.toMap(request);
		if (null == processorObj.get("id")) {
			result.put("msg", "修改处理器错误,缺少ID!");
			return result;
		}		
		if (null == processorObj.get("nfcNumber")) {
			result.put("msg", "修改处理器错误,缺少NFC序列号!");
			return result;
		}
		if (null == processorObj.get("moxaNumber")) {
			result.put("msg", "修改处理器错误,缺少MOXA-NFC序列号!");
			return result;
		}
		if (null == processorObj.get("detectorNum")) {
			result.put("msg", "修改处理器错误,探测器数量!");
			return result;
		}
		
		try {			
			processorService.updateProcessor(UserTool.getLoginUser(request).get("user_name"), processorObj);
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
	public Map<String, String> deleteProcessor(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");	
		if(null == request.getParameter("id")) {
			result.put("msg", "删除处理器错误,缺少ID.");
			return result;
		}
		try {
			processorService.deleteProcessor(UserTool.getLoginUser(request).get("user_name"), request.getParameter("id"));
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
}
