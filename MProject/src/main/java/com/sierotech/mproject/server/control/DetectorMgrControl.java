/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月30日
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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ControllerUtils;
import com.sierotech.mproject.common.utils.UserTool;
import com.sierotech.mproject.common.utils.excel.ParseExcelData;
import com.sierotech.mproject.context.AppContext;
import com.sierotech.mproject.server.service.IDetectorService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月30日
* @功能描述: 
 */

@Controller
@RequestMapping("/detector/mgr/")
@Scope("request")
public class DetectorMgrControl {
	@Autowired
	IDetectorService detectorService;
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addProcessor(HttpServletRequest request) {	
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map detectorObj = ControllerUtils.toMap(request);
		if (null == detectorObj.get("processorId")) {
			result.put("msg", "添加探测器错误,缺少处理器ID!");
			return result;
		}
//		if (null == detectorObj.get("detectorId")) {
//			result.put("msg", "添加探测器错误,缺少探测器ID!");
//			return result;
//		}
		if (null == detectorObj.get("nfcNumber")) {
			result.put("msg", "添加探测器错误,缺少探测器序列号!");
			return result;
		}
		if (null == detectorObj.get("longitude")) {
			result.put("msg", "添加探测器错误,缺少探测器经度!");
			return result;
		}
		if (null == detectorObj.get("latitude")) {
			result.put("msg", "添加探测器错误,缺少探测器纬度!");
			return result;
		}
		if (null == detectorObj.get("startPoint") || "".equals(detectorObj.get("startPoint"))) {
			detectorObj.put("startPoint", "null");
		}
		if (null == detectorObj.get("endPoint") || "".equals(detectorObj.get("endPoint"))) {
			detectorObj.put("endPoint", "null");
		}
		
		try {
			detectorService.addDetector(UserTool.getLoginUser(request).get("user_name"), detectorObj);
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
		Map detectorObj = ControllerUtils.toMap(request);
		if (null == detectorObj.get("id")) {
			result.put("msg", "修改探测器错误,缺少ID!");
			return result;
		}
//		if (null == detectorObj.get("detectorId")) {
//			result.put("msg", "修改探测器错误,缺少探测器ID!");
//			return result;
//		}
		if (null == detectorObj.get("detectorSeq")) {
			result.put("msg", "修改探测器错误,缺少探测器编号!");
			return result;
		}
		if (null == detectorObj.get("nfcNumber")) {
			result.put("msg", "修改探测器错误,缺少探测器序列号!");
			return result;
		}
		if (null == detectorObj.get("longitude")) {
			result.put("msg", "修改探测器错误,缺少探测器经度!");
			return result;
		}
		if (null == detectorObj.get("latitude")) {
			result.put("msg", "修改探测器错误,缺少探测器纬度!");
			return result;
		}
		
		if (null == detectorObj.get("startPoint") || "".equals(detectorObj.get("startPoint"))) {
			detectorObj.put("startPoint", "null");
		}
		if (null == detectorObj.get("endPoint") || "".equals(detectorObj.get("endPoint"))) {
			detectorObj.put("endPoint", "null");
		}
		
		try {
			detectorService.updateDetector(UserTool.getLoginUser(request).get("user_name"), detectorObj);
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
			result.put("msg", "删除探测器错误,缺少ID.");
			return result;
		}
		try {
			detectorService.deleteDetector(UserTool.getLoginUser(request).get("user_name"), request.getParameter("id"));
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/dataImport")
	@ResponseBody
	public Map<String, String> importData(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String processorId = request.getParameter("processorId");
		if(processorId == null) {
			result.put("msg", "探测器导入错误,没有选择所属处理器.");
			return result;
		}
		String[] arrImportOption = request.getParameterValues("importOption");
		boolean enableReplace = false;
		boolean ignoreExistsData = true;
		
		if(arrImportOption != null) {
			for(String option : arrImportOption) {
				if("enableReplace".equals(option)) {
					enableReplace = true;
				}
			}
		}
		
		MultipartHttpServletRequest mreq = (MultipartHttpServletRequest ) request;
		if(mreq.getFileMap() == null) {
			result.put("msg", "探测器导入错误,未提交文件.");
			return result;
		}

		MultipartFile fileT = mreq.getFileMap().get("dataFile");
		if(fileT == null) {
			result.put("msg", "探测器导入错误,未提交文件.");
			return result;
		}
		String filename = fileT.getOriginalFilename();
		int index = filename.lastIndexOf(".");
		String postfix = filename.substring(index + 1);
		if ("xls".equals(postfix) || "xlsx".equals(postfix)) {
			
		}else {
			result.put("msg", "探测器导入错误,文件类型错误.");
			return result;
		}
		Map<String, Object> dataMap;
		try {
			dataMap = ParseExcelData.getInstance().readFile(fileT.getInputStream(), filename,AppContext.getExcelTemplateMeta("detector"));
		}catch(IOException ioe) {
			result.put("msg", "探测器导入错误, 获取文件错误.");
			return result;
		}
		if(dataMap == null) {
			result.put("msg", "探测器导入错误, 解析数据文件错误.");
			return result;
		}
		String dataRows = dataMap.get("allRows").toString();
		int iDataRows = 0;
		try {
			iDataRows = Integer.parseInt(dataRows);
		}catch(NumberFormatException ne) {
			result.put("msg", "探测器导入错误, 文件没有有效的数据.");
			return result;
		}
		List<Map<String, String>> alDatas = (List<Map<String, String>>)dataMap.get("validData");
		if(iDataRows == 0) {
			result.put("msg", "探测器导入错误, 文件没有有效的数据.");
			return result;
		}
		if(iDataRows > alDatas.size()) {
			result.put("msg", "探测器导入错误, 文件中的行数据,列输入不完整.");
			return result;
		}
		try {
			detectorService.update4ImportDetector(UserTool.getLoginUser(request).get("user_name"), processorId,ignoreExistsData, enableReplace, alDatas);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
}
