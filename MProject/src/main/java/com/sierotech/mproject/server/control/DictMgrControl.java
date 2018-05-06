/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月5日
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
import com.sierotech.mproject.common.utils.UserTool;
import com.sierotech.mproject.common.utils.excel.ParseExcelData;
import com.sierotech.mproject.context.AppContext;
import com.sierotech.mproject.server.service.IDictService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月5日
* @功能描述: nfc编码库管理控制层
 */
@Controller
@RequestMapping("/dict/mgr/")
@Scope("request")
public class DictMgrControl {
	@Autowired
	IDictService dictService;
	
	@RequestMapping(value = "/codeImport")
	@ResponseBody
	public Map<String, String> importCode(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String msg = "";
		String codeName = request.getParameter("codeName");
		if(codeName == null) {
			result.put("msg", "NFC序列号导入错误, 缺少编码名称.");
			return result;
		}
		MultipartHttpServletRequest mreq = (MultipartHttpServletRequest ) request;
		if(mreq.getFileMap() == null) {
			result.put("msg", "NFC序列号导入错误,未提交文件.");
			return result;
		}

		MultipartFile fileT = mreq.getFileMap().get("dataFile");
		if(fileT == null) {
			result.put("msg", "NFC序列号导入错误,未提交文件.");
			return result;
		}
		String filename = fileT.getOriginalFilename();
		int index = filename.lastIndexOf(".");
		String postfix = filename.substring(index + 1);
		if ("xls".equals(postfix) || "xlsx".equals(postfix)) {
			
		}else {
			result.put("msg", "NFC序列号导入错误, 文件类型错误.");
			return result;
		}
		Map<String, Object> dataMap;
		String templateName = "nfc-code-" + codeName;
		try {
			dataMap = ParseExcelData.getInstance().readFile(fileT.getInputStream(), filename,AppContext.getExcelTemplateMeta(templateName));
		}catch(IOException ioe) {
			result.put("msg", "NFC序列号导入错误, 解析数据文件错误.");
			return result;
		}
		if(dataMap == null) {
			result.put("msg", "NFC序列号导入错误, 解析数据文件错误.");
			return result;
		}
		String dataRows = dataMap.get("allRows").toString();
		int iDataRows = 0;
		try {
			iDataRows = Integer.parseInt(dataRows);
		}catch(NumberFormatException ne) {
			result.put("msg", "NFC序列号导入错误, 文件没有有效的数据.");
			return result;
		}
		List<Map<String, String>> alDatas = (List<Map<String, String>>)dataMap.get("validData");
		if(iDataRows == 0) {
			result.put("msg", "NFC序列号导入错误, 文件没有有效的数据.");
			return result;
		}
		if(iDataRows > alDatas.size()) {
			result.put("msg", "NFC序列号导入错误, 文件中的数据不完整.");
			return result;
		}
		try {
			dictService.update4ImportCode(UserTool.getLoginUser(request).get("user_name"), codeName, alDatas);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		result.put("returnCode", "success");
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/checkNfcNum")
	@ResponseBody
	public Map<String, String> checkNfcNum(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String dataName = request.getParameter("codeName");
		if(dataName == null) {
			result.put("msg", "NFC序列号验证错误, 缺少NFC序列号对应的类型.");
			return result;
		}
		String codeValue = request.getParameter("codeValue");
		if(codeValue == null) {
			result.put("msg", "NFC序列号验证错误, 缺少NFC序列号值.");
			return result;
		}
		String dataId = request.getParameter("id");
		
		Map<String,Object> codeMap = dictService.queryNfcDataByCode(dataName, codeValue);
		if(codeMap != null) {
			//检查编号是否已录入
			boolean codeUsed = dictService.checkNfcCodeUsed(dataName, codeValue, dataId);
			if(codeUsed) {
				result.put("returnCode", "fail");
				result.put("msg", "此[" + codeValue + "]NFC序列号已录入.");
			}else {
				String codNumber = codeMap.get("number") != null ? codeMap.get("number").toString() : "";
				result.put("returnCode", "success");
				result.put("number", codNumber);
				result.put("msg", "");
			}		
		}else {
			result.put("msg", "NFC序列号库中未找到["+ codeValue +"]对应的序列号.");
		}
		return result;
	}
}
