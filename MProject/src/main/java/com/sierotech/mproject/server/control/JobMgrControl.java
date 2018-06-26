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
	private static final Logger log = LoggerFactory.getLogger(JobMgrControl.class);
	
	@Autowired
	IJobService jobService;
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addJob(HttpServletRequest request) {
		
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
	
	@RequestMapping(value = "/process/install")
	@ResponseBody
	public Map<String, String> processInstallJob(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		String jobId = request.getParameter("jobId");
		if(null == jobId) {
			result.put("msg", "处理工单错误,缺少工单ID.");
			return result;
		}
		String jobStatus = request.getParameter("jobStatus");
		if(null == jobStatus) {
			result.put("msg", "处理工单错误,缺少工单状态.");
			return result;
		}
		if("N".equals(jobStatus) || "Q".equals(jobStatus)) {
			String jobDesc = request.getParameter("jobDesc");
			if(null == jobDesc) {
				result.put("msg", "处理工单错误,缺少工单描述.");
				return result;
			}
			try {
				jobService.updateJob(jobId, jobStatus, jobDesc);
			}catch(BusinessException be) {
				result.put("msg", be.getMessage());
				return result;
			}
		}else if("F".equalsIgnoreCase(jobStatus)) {
			//工单完成,获取工单填写的机箱信息、处理器信息、探测器信息
			String boxPos = request.getParameter("machineBoxPos");
			String installOption = request.getParameter("installOption");
			String detectorPos = request.getParameter("detectorPos");
			
			if(boxPos == null) {
				result.put("msg", "处理工单错误,机箱位置描述为空.");
				return result;
			}
			if(installOption == null) {
				result.put("msg", "处理工单错误,处理器安装选项为空.");
				return result;
			}
			
			if(detectorPos == null) {
				result.put("msg", "处理工单错误,探测器位置信息为空.");
				return result;
			}
			List<Map> detectorPosList = null;
			Map<String,String> installOptionMap = null;
			try {
				installOptionMap = JsonUtil.jsonToMap(installOption, false);
				detectorPosList = JsonUtil.jsonToList(detectorPos, Map.class);
			}catch(Exception e) {
				result.put("msg", "处理器IP、探测器位置参数格式错误.");
				return result;
			}
			try {
				String curUserId = UserTool.getLoginUser(request).get("id");
				jobService.updateJob(curUserId, jobId, jobStatus, "", boxPos, installOptionMap, detectorPosList);
			}catch(BusinessException be) {
				result.put("msg", be.getMessage());
				return result;
			}
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/process/debug")
	@ResponseBody
	public Map<String, String> processDebugJob(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		String jobId = request.getParameter("jobId");
		if(null == jobId) {
			result.put("msg", "处理工单错误,缺少工单ID.");
			return result;
		}
		String jobStatus = request.getParameter("jobStatus");
		if(null == jobStatus) {
			result.put("msg", "处理工单错误,缺少工单状态.");
			return result;
		}
		if("N".equals(jobStatus) || "Q".equals(jobStatus)) {
			String jobDesc = request.getParameter("jobDesc");
			if(null == jobDesc) {
				result.put("msg", "处理工单错误,缺少工单描述.");
				return result;
			}
			try {
				jobService.updateJob(jobId, jobStatus, jobDesc);
			}catch(BusinessException be) {
				result.put("msg", be.getMessage());
				return result;
			}
		}else if("F".equalsIgnoreCase(jobStatus)) {
			//工单完成,获取工单填写的附件(处理器配置信息、探测器信息)
			String debugOption = request.getParameter("debugOption");
			String processorInfo = request.getParameter("processorInfo");
			String configFile = request.getParameter("configFile");
			String detectorInfo = request.getParameter("detectorInfo");
			if(processorInfo == null) {
				result.put("msg", "处理调试工单错误, 处理器IP信息为空.");
				return result;
			}
			if(configFile == null) {
				result.put("msg", "处理调试工单错误, 处理器配置附件为空.");
				return result;
			}
			if(detectorInfo == null) {
				result.put("msg", "处理调试工单错误, 探测器附件信息为空.");
				return result;
			}
			if(debugOption == null) {
				result.put("msg", "处理调试工单错误, 调试工单选项为空.");
				return result;
			}
			Map<String,String> debugOptionMap = null;
			try {
				debugOptionMap = JsonUtil.jsonToMap(debugOption, false);
			}catch(Exception e) {
				result.put("msg", "调试工单选项参数格式错误.");
				return result;
			}
			
			List<Map> configFileList = null;
			List<Map> detectorInfoList = null;
			List<Map> processorIpList = null;
			try {
				processorIpList = JsonUtil.jsonToList(processorInfo, Map.class);
				configFileList = JsonUtil.jsonToList(configFile, Map.class);
				detectorInfoList = JsonUtil.jsonToList(detectorInfo, Map.class);
			}catch(Exception e) {
				log.info(e.getMessage());
				result.put("msg", "处理器配置、探测器信息参数格式错误.");
				return result;
			}
			try {
				String curUserId = UserTool.getLoginUser(request).get("id");
				jobService.updateJob(curUserId, jobId, jobStatus, "", processorIpList, configFileList, detectorInfoList, debugOptionMap);
			}catch(BusinessException be) {
				result.put("msg", be.getMessage());
				return result;
			}
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/process/other")
	@ResponseBody
	public Map<String, String> processOtherJob(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		String jobId = request.getParameter("jobId");
		if(null == jobId) {
			result.put("msg", "处理工单错误,缺少工单ID.");
			return result;
		}
		String jobStatus = request.getParameter("jobStatus");
		if(null == jobStatus) {
			result.put("msg", "处理工单错误,缺少工单状态.");
			return result;
		}
		String jobDesc = request.getParameter("jobDesc");
		if(null == jobDesc) {
			result.put("msg", "处理工单错误,缺少工单描述.");
			return result;
		}
		try {
			jobService.updateJob(jobId, jobStatus, jobDesc);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/revokeJob")
	@ResponseBody
	public Map<String, String> revokeJob(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		String jobId = request.getParameter("jobId");
		if(null == jobId) {
			result.put("msg", "取消工单错误, 缺少工单ID.");
			return result;
		}
		String curUserId = UserTool.getLoginUser(request).get("id");
		try {
			jobService.updateJob4Revoke(curUserId, jobId);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}

}
