/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月27日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ConfigSQLUtil;
import com.sierotech.mproject.common.utils.DateUtils;
import com.sierotech.mproject.common.utils.LogOperationUtil;
import com.sierotech.mproject.common.utils.UUIDGenerator;
import com.sierotech.mproject.context.AppContext;
import com.sierotech.mproject.server.service.IBoxService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月27日
* @功能描述: 
 */

@Service
public class BoxServiceImpl implements IBoxService{

	static final Logger log = LoggerFactory.getLogger(BoxServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;
	
	@Override
	public boolean checkBoxNumber(String boxId, String boxNumber) throws BusinessException {
		boolean result = true;
		if (null == boxId) {
			return true;
		}
		if (null == boxNumber || "".equals(boxNumber)) {
			throw new BusinessException("机箱编号验证,机箱编号为空!");
		}
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("boxId", boxId);
		paramsMap.put("boxNumber", boxNumber);

		String preSql = ConfigSQLUtil.getCacheSql("mproject-box-checkBoxNumberExist");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramsMap);
		try {
			Map<String, Object> recordMap = springJdbcDao.queryForMap(sql);
			if (recordMap != null) {
				int num = Integer.valueOf(recordMap.get("countNum").toString());
				if (num < 1) {
					result = false;
				}
			}
		} catch (DataAccessException ex) {
			log.info(ex.getMessage());
		} catch (Exception e) {
			log.info(e.getMessage());
		}
		return result;
	}

	
	@Override
	public void addBox(String adminUser, Map<String, Object> boxObj) throws BusinessException {
		if (null == boxObj.get("userId")) {
			throw new BusinessException("添加机箱错误,缺少施工经理参数!");
		}
		if (null == boxObj.get("orgId")) {
			throw new BusinessException("添加机箱错误,缺少组织单位!");
		}
		if (null == boxObj.get("projectId")) {
			throw new BusinessException("添加机箱错误,缺少项目ID!");
		}		
		if (null == boxObj.get("boxNumber")) {
			throw new BusinessException("添加机箱错误,缺少机箱编号!");
		}
		if (null == boxObj.get("longitude")) {
			throw new BusinessException("添加机箱错误,缺少经度!");
		}
		if (null == boxObj.get("latitude")) {
			throw new BusinessException("添加机箱错误,缺少纬度!");
		}
		if (null == boxObj.get("processorNum")) {
			throw new BusinessException("添加机箱错误,处理器数量!");
		}
		// 检查机箱编号是否重复
		boolean boxExists = checkBoxNumber("", boxObj.get("boxNumber").toString());
		if (boxExists) {
			throw new BusinessException("机箱编号已存在!");
		}
		
		//获取用户应建机箱数、已建机箱数, 检查机箱数量是否到达用户应建的数量
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("userId", boxObj.get("userId"));
		paramsMap.put("projectId", boxObj.get("projectId"));
				
		String getUserAllowBoxNumPreSql = ConfigSQLUtil.getCacheSql("mproject-box-getUserAllowBoxNumByUserId");
		String getUserAllowBoxNumSql = ConfigSQLUtil.preProcessSQL(getUserAllowBoxNumPreSql, paramsMap);
		List<Map<String, Object>> alDatas = null; 
		try {
			alDatas = springJdbcDao.queryForList(getUserAllowBoxNumSql);
		} catch (DataAccessException ex) {
			throw new BusinessException("获取用户应建机箱数异常.");
		} catch (Exception e) {
			log.info(e.getMessage());
		}
		int iAllowBoxNUm = 0;
		if(alDatas !=null && alDatas.size() >0) {
			String allowBoxNum = alDatas.get(0).get("allow_box_num").toString();
			try {
				iAllowBoxNUm = Integer.parseInt(allowBoxNum);
			}catch (NumberFormatException e) {
				log.info(e.getMessage());
			}
		}else {
			throw new BusinessException("没有分配用户应建机箱数.");
		}
		String getUserFactBoxNumPreSql = ConfigSQLUtil.getCacheSql("mproject-box-getUserFactBoxNumByUserId");
		String getUserFactBoxNumSql = ConfigSQLUtil.preProcessSQL(getUserFactBoxNumPreSql, paramsMap);
		List<Map<String, Object>> alFactDatas = null; 
		try {
			alFactDatas = springJdbcDao.queryForList(getUserFactBoxNumSql);
		} catch (DataAccessException ex) {
			throw new BusinessException("获取用户已建机箱数异常.");
		} catch (Exception e) {
			log.info(e.getMessage());
		}
		int iFactBoxNUm = 0;
		if(alFactDatas !=null && alFactDatas.size() >0) {
			iFactBoxNUm = alFactDatas.size();
		}
		if(iFactBoxNUm >= iAllowBoxNUm) {
			throw new BusinessException("用户应建机箱数已到上限, 不能继续添加.");
		}
		
		//
		String boxId = UUIDGenerator.getUUID();
		boxObj.put("boxId", boxId);
		boxObj.put("createDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		String preSql = ConfigSQLUtil.getCacheSql("mproject-box-add");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, boxObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("添加机箱错误,访问数据库异常.");
		}
	}


	@Override
	public void deleteBox(String curUser, String boxId) throws BusinessException {
		if (null == boxId || "".equals(boxId)) {
			throw new BusinessException("删除机箱错误,缺少ID!");
		}
		
		String deleteDetectorPreSql = ConfigSQLUtil.getCacheSql("mproject-box-deleteBoxDetectorById");
		String deleteProcessorPreSql = ConfigSQLUtil.getCacheSql("mproject-box-deleteBoxProcessorById");
		String deleteBoxPreSql = ConfigSQLUtil.getCacheSql("mproject-box-deleteBoxById");
		
		Map<String,Object> paramsMap = new HashMap<String,Object>();
		paramsMap.clear();
		paramsMap.put("boxId", boxId);	
		
		String deleteDetectorSql = ConfigSQLUtil.preProcessSQL(deleteDetectorPreSql, paramsMap);
		String deleteProcessorSql = ConfigSQLUtil.preProcessSQL(deleteProcessorPreSql, paramsMap);
		String deleteBoxSql = ConfigSQLUtil.preProcessSQL(deleteBoxPreSql, paramsMap);
		
		StringBuffer sb = new StringBuffer();
		sb.append(deleteDetectorSql).append(";\n");
		sb.append(deleteProcessorSql).append(";\n");
		sb.append(deleteBoxSql).append("");
		
		try {
			springJdbcDao.batchUpdate(sb.toString().split("\n"));
		} catch (DataAccessException dae) {
			log.info(dae.getMessage());
			throw new BusinessException("删除机箱错误,访问数据库异常.");
		}
	}


	@Override
	public void updateBox4Submit(String curUser, String boxId) throws BusinessException {
		if (null == boxId || "".equals(boxId)) {
			throw new BusinessException("提交机箱错误,缺少ID!");
		}
		//获取机箱
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("boxId", boxId);
		String selectBoxPreSql = ConfigSQLUtil.getCacheSql("mproject-box-getBoxById");
		String selectBoxSql = ConfigSQLUtil.preProcessSQL(selectBoxPreSql, paramsMap);
		Map<String, Object> boxMap = null; 
		try {
			List<Map<String, Object>> alBoxs = springJdbcDao.queryForList(selectBoxSql);
			if (alBoxs != null && alBoxs.size() > 0) {
				boxMap = alBoxs.get(0);
			}else {
				throw new BusinessException("提交机箱错误,ID为"+boxId+"的机箱不存在!");
			}
		} catch (DataAccessException ex) {
			log.info("提交机箱错误：{}", ex.getMessage());
			throw new BusinessException("提交机箱错误，操作数据库异常.");
		} catch (Exception e) {
			log.info(e.getMessage());
		}
		if(boxMap == null) {
			throw new BusinessException("提交机箱错误,ID为"+boxId+"的机箱不存在!");
		}
		String processorNum = boxMap.get("processor_num").toString();
		String queryProcessorNum = "";
		//获取机箱下的处理器
		List<Map<String,Object>> alProcessors = null;
		String selectProcessorPreSql = ConfigSQLUtil.getCacheSql("mproject-processor-getProcessorListByBoxId");
		String selectProcessorSql = ConfigSQLUtil.preProcessSQL(selectProcessorPreSql, paramsMap);
		try {
			alProcessors = springJdbcDao.queryForList(selectProcessorSql);
		} catch (DataAccessException ex) {
			throw new BusinessException("提交机箱错误，获取机箱下的处理器数据库访问错误.");
		} catch (Exception e) {
			log.info(e.getMessage());
		}
		if (alProcessors != null && alProcessors.size() > 0) {
			queryProcessorNum = "" + alProcessors.size();
		}else {
			throw new BusinessException("提交机箱错误，机箱下未维护处理器.");
		}
		//检查机箱下是否维护了处理器
		if(!processorNum.equals(queryProcessorNum)) {
			throw new BusinessException("提交机箱错误，机箱中指定的处理器数与机箱下维护的处理器数量不一致,不能提交.");
		}
		//检查机箱下的处理器是否维护了探测器
		String getDetectorsPreSql = ConfigSQLUtil.getCacheSql("mproject-detector-getListByProcessorId");
		for(Map<String,Object> processor: alProcessors) {
			String processorId = processor.get("id").toString();
			String detectorNum = processor.get("detector_num").toString();
			paramsMap.clear();
			paramsMap.put("processorId", processorId);
			String getDetectorsSql =  ConfigSQLUtil.preProcessSQL(getDetectorsPreSql, paramsMap);
			List<Map<String,Object>> alDetectors = null;
			try {
				alDetectors = springJdbcDao.queryForList(getDetectorsSql);
			} catch (DataAccessException ex) {
				log.info(ex.getMessage());
				throw new BusinessException("提交机箱错误，获取机箱下处理器的探测器数据库访问错误.");
			} catch (Exception e) {
				log.info(e.getMessage());
			}
			if(alDetectors == null || alDetectors.size() < 1) {
				throw new BusinessException("提交机箱错误，机箱下处理器["+ processor.get("nfc_number").toString() +"]的探测器未维护.");
			}
			String queryDetectorNum = "" + alDetectors.size();
			if(!detectorNum.equals(queryDetectorNum)) {
				throw new BusinessException("提交机箱错误，机箱下处理器["+ processor.get("nfc_number").toString() +"]维护的探测器与处理器指定的探测器数不一致,不能提交.");
			}
		}
		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-box-getBoxBelowInfo");
		paramsMap.clear();
		paramsMap.put("boxId", boxId);
		
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramsMap);
		try {
			List<Map<String, Object>> list = springJdbcDao.queryForList(sql);
			
			if (list != null && list.size() > 0) {
				for(Map<String, Object> obj : list) {
					if(obj.get("detector_num")!=null ) {
						try{
							int detectorNum = Integer.parseInt(obj.get("detector_num").toString());
							if(detectorNum < 1) {
								throw new BusinessException("提交机箱错误,机箱下处理器未维护探测器.");
							}
						}catch(NumberFormatException ne) {
							throw new BusinessException("提交机箱错误,机箱下处理器未维护探测器.");
						}
					}
				}
			}else {
				throw new BusinessException("提交机箱错误,机箱下未维护处理器.");
			}
		} catch (BusinessException be) {
			throw new BusinessException(be.getMessage());
		} catch (DataAccessException ex) {
			log.info("提交机箱获取机箱下属信息错误:{}",ex.getMessage());
			throw new BusinessException("提交机箱获取机箱下属信息错误.");
		} catch (Exception e) {
			log.info(e.getMessage());
		}
				
		//记录提交信息
		String logSubmitPreSql = ConfigSQLUtil.getCacheSql("mproject-box-logSubmitInfo");
		paramsMap.clear();
		paramsMap.put("boxId", boxId);
		paramsMap.put("id", UUIDGenerator.getUUID());
		paramsMap.put("submitDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		
		String logSubmitSql = ConfigSQLUtil.preProcessSQL(logSubmitPreSql, paramsMap);
		//更改机箱 的提交状态
		String updateStatusPreSql = ConfigSQLUtil.getCacheSql("mproject-box-updateBoxStatus");
		paramsMap.clear();
		paramsMap.put("boxId", boxId);
		paramsMap.put("status", "N");
		
		String updateStatusSql = ConfigSQLUtil.preProcessSQL(updateStatusPreSql, paramsMap);
		try {
			springJdbcDao.update(logSubmitSql);
			springJdbcDao.update(updateStatusSql);
		}catch (DataAccessException ex) {
			log.info("提交机箱记录机箱信息错误:{}",ex.getMessage());
			throw new BusinessException("提交机箱获取机箱下属信息错误.");			
		}
	}

	@Override
	public void updateBox4Edit(String curUser, String boxId) throws BusinessException {
		if (null == boxId) {
			throw new BusinessException("设置机箱允许修改错误,机箱ID为空!");
		}
		
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("boxId", boxId);
		
		//获取机箱		
		String selectBoxPreSql = ConfigSQLUtil.getCacheSql("mproject-box-getBoxById");
		String selectBoxSql = ConfigSQLUtil.preProcessSQL(selectBoxPreSql, paramsMap);
		Map<String, Object> boxMap ; 
		try {
			List<Map<String, Object>> alBoxs = springJdbcDao.queryForList(selectBoxSql);
			if (alBoxs != null && alBoxs.size() > 0) {
				boxMap = alBoxs.get(0);
			}else {
				throw new BusinessException("设置机箱允许修改错误,ID为"+boxId+"的机箱不存在!");
			}
		} catch (DataAccessException ex) {
			log.info("设置机箱允许修改错误：{}", ex.getMessage());
			throw new BusinessException("设置机箱允许修改错误，访问数据库异常.");
		} catch (Exception e) {
			e.printStackTrace();
		}
		//修改机箱状态
		String updateBoxPreSql = ConfigSQLUtil.getCacheSql("mproject-box-updateBoxStatus");
		paramsMap.clear();
		paramsMap.put("boxId", boxId);
		paramsMap.put("status","Y");
		String updateBoxSql = ConfigSQLUtil.preProcessSQL(updateBoxPreSql, paramsMap);
		try {
			springJdbcDao.update(updateBoxSql);
		} catch (DataAccessException ex) {
			log.info("设置机箱允许修改错误：{}", ex.getMessage());
			throw new BusinessException("设置机箱允许修改错误，访问数据库异常.");
		}
	}

	@Override
	public void updateBox4Accept(String curUser, String boxId, List<Map> acceptFileList) throws BusinessException {
		if (null == boxId) {
			throw new BusinessException("确认验收机箱错误,机箱ID为空!");
		}
		
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("boxId", boxId);
		
		//获取机箱		
		String selectBoxPreSql = ConfigSQLUtil.getCacheSql("mproject-box-getBoxById");
		String selectBoxSql = ConfigSQLUtil.preProcessSQL(selectBoxPreSql, paramsMap);
		Map<String, Object> boxMap ; 
		try {
			List<Map<String, Object>> alBoxs = springJdbcDao.queryForList(selectBoxSql);
			if (alBoxs != null && alBoxs.size() > 0) {
				boxMap = alBoxs.get(0);
			}else {
				throw new BusinessException("确认验收机箱错误,ID为"+boxId+"的机箱不存在!");
			}
		} catch (DataAccessException ex) {
			log.info("确认验收机箱错误：{}", ex.getMessage());
			throw new BusinessException("确认验收机箱错误，访问数据库异常.");
		} catch (Exception e) {
			log.info(e.getMessage());
		}
		//检查机箱下是否有完成的安装工单
		String getFinishJobPreSql =  ConfigSQLUtil.getCacheSql("mproject-job-getFinishInstallJobs");
		String getFinishJobSql = ConfigSQLUtil.preProcessSQL(getFinishJobPreSql, paramsMap);
		List<Map<String, Object>> alJobs;
		try {
			alJobs = springJdbcDao.queryForList(getFinishJobSql);
		}catch( DataAccessException ex) {
			throw new BusinessException("确认验收机箱错误,查找机箱下的处理工单异常.");
		}
		if(alJobs == null || alJobs.size()< 1) {
			throw new BusinessException("确认验收机箱错误,该机箱下还没有处理完成的安装工单,不能验收.");
		}
		//检查机箱下的处理器IP是否为空或为0.0.0.0
		String getProcessorPreSql = ConfigSQLUtil.getCacheSql("mproject-box-getBoxProcessor4IpIsEmpty");
		paramsMap.clear();
		paramsMap.put("boxId", boxId);
		String getProcessorSql = ConfigSQLUtil.preProcessSQL(getProcessorPreSql, paramsMap);
		List<Map<String, Object>> alProcessor;
		try {
			alProcessor = springJdbcDao.queryForList(getProcessorSql);
		}catch( DataAccessException ex) {
			throw new BusinessException("确认验收机箱错误,查找机箱下的处理器数据库访问异常.");
		}
		if(alProcessor != null && alProcessor.size() > 0) {
			throw new BusinessException("机箱下存在IP为空的处理器,不能通过确认验收.");
		}
		//检查机箱下的处理器是否上传配置文件
		String getProcessorByConfigPreSql = ConfigSQLUtil.getCacheSql("mproject-box-getBoxProcessorConfigIsEmpty");
		paramsMap.clear();
		paramsMap.put("boxId", boxId);
		String getProcessorByConfigSql = ConfigSQLUtil.preProcessSQL(getProcessorByConfigPreSql, paramsMap);
		List<Map<String, Object>> alDatas;
		try {
			alDatas = springJdbcDao.queryForList(getProcessorByConfigSql);
		}catch( DataAccessException ex) {
			throw new BusinessException("确认验收机箱错误,查找机箱下的处理器数据库访问异常.");
		}
		if(alDatas != null && alDatas.size() > 0) {
			throw new BusinessException("机箱下的处理器配置文件和探测器信息未上传.");
		}
		//保存机箱验收上传的附件
		String tempUploadDir = AppContext.getUploadTempDir();
		String uploadDir = AppContext.getUploadDir();
		StringBuffer batchSql = new StringBuffer();
		if(acceptFileList!=null && acceptFileList.size() > 0) {
			String attachFilePreSql = ConfigSQLUtil.getCacheSql("mproject-attach-addFile");
			for(Map acceptFileMap : acceptFileList) {
				String id = acceptFileMap.get("id").toString();
				String fileName = acceptFileMap.get("fileName").toString();
				
				//移动文件
				// 分隔符 File.separator 采用 / 替换, 减少数据库中及显示时候的转义
				String tempFileName = tempUploadDir + "/" + "boxfile_" + id + "_" +  fileName;
				String newFileName = uploadDir + "/" + "acceptFile" + "/" + id + "/" + fileName;
				String configFilePath = "/" + "acceptFile" + "/" + id + "/" + fileName;
				File tempFile = new File(tempFileName);
				File newFile = new File(newFileName);
				// 判断目标路径是否存在，如果不存在就创建一个
				if (!newFile.getParentFile().exists()) {
					newFile.getParentFile().mkdirs();
					
				}
				if(tempFile.exists()) {
					tempFile.renameTo(newFile);
				}
				
				
				if(configFilePath != null  && configFilePath.indexOf("\\\\") < 1) {
					configFilePath = configFilePath.replace("\\", "\\\\");
				}
				// 生成修改的 sql
				paramsMap.clear();
				paramsMap.put("id", UUIDGenerator.getUUID());
				paramsMap.put("fileOwnerObj", "box");
				paramsMap.put("objId", id);
				paramsMap.put("fileName", fileName);
				paramsMap.put("filePath", configFilePath);
				
				String attachFileSql = ConfigSQLUtil.preProcessSQL(attachFilePreSql, paramsMap);
				batchSql.append(attachFileSql).append(";\n");				
			}
		}
		if(batchSql.length() > 0) {
			try {
				springJdbcDao.batchUpdate(batchSql.toString().split("\n"));
			} catch (DataAccessException ex) {
				log.info(ex.getMessage());
				throw new BusinessException("确认验收机箱错误，存储机箱验收文件操作数据库异常.");
			}
		}
		
		String updateBoxPreSql = ConfigSQLUtil.getCacheSql("mproject-box-updateBox4Accept");
		paramsMap.clear();
		paramsMap.put("boxId", boxId);
		paramsMap.put("curDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		String updateBoxSql = ConfigSQLUtil.preProcessSQL(updateBoxPreSql, paramsMap);
		try {
			springJdbcDao.update(updateBoxSql);
		} catch (DataAccessException ex) {
			log.info("确认验收机箱错误：{}", ex.getMessage());
			throw new BusinessException("确认验收机箱错误，访问数据库异常.");
		}
	}


	@Override
	public void updateBox(String curUser, Map<String, Object> boxObj) throws BusinessException {
		
		if (null == boxObj.get("boxId")) {
			throw new BusinessException("修改机箱错误,缺少机箱ID!");
		}
		if (null == boxObj.get("boxNumber")) {
			throw new BusinessException("修改机箱错误,缺少机箱编号!");
		}
		if (null == boxObj.get("longitude")) {
			throw new BusinessException("修改机箱错误,缺少经度!");
		}
		if (null == boxObj.get("latitude")) {
			throw new BusinessException("修改机箱错误,缺少纬度!");
		}
		if (null == boxObj.get("processorNum")) {
			throw new BusinessException("修改机箱错误,缺少处理器数量!");
		}
		// 检查机箱编号是否重复
		boolean boxExists = checkBoxNumber(boxObj.get("boxId").toString(), boxObj.get("boxNumber").toString());
		if (boxExists) {
			throw new BusinessException("机箱编号已存在!");
		}
		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-box-updateById");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, boxObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("修改机箱错误,访问数据库异常.");
		}
	}

	@Override
	public List<Map<String, Object>> queryDeviceLog(String curUser, String boxId, String entrance, String reportName) throws BusinessException {
//		List<Map<String, Object>>  result = new ArrayList<Map<String, Object>>();
		//获取机箱下的处理器
		String getProcessorPreSql =  ConfigSQLUtil.getCacheSql("mproject-processor-getProcessorList4Report");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("boxId", boxId);
		String getProcessorSql = ConfigSQLUtil.preProcessSQL(getProcessorPreSql, paramsMap);
		List<Map<String, Object>> alProcessors = new ArrayList<Map<String, Object>>();
		try {
			alProcessors = springJdbcDao.queryForList(getProcessorSql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
		}
		if(alProcessors != null && alProcessors.size() > 0) {
			String getDetectorsPreSql = ConfigSQLUtil.getCacheSql("mproject-detector-getListByProcessorId");
			for(Map<String, Object> processor : alProcessors) {
				paramsMap.clear();
				paramsMap.put("processorId", processor.get("id"));
				String getDetectorsSql = ConfigSQLUtil.preProcessSQL(getDetectorsPreSql, paramsMap);
				List<Map<String, Object>> alDetectors = new ArrayList<Map<String, Object>>();
				//获取机箱下的探测器
				try {
					alDetectors = springJdbcDao.queryForList(getDetectorsSql);
				} catch (DataAccessException dae) {
					log.info(dae.toString());
				}
				processor.put("detectors", alDetectors);
			}
			//获取打印数据后记录日志
			String addPrintLogPreSql =  ConfigSQLUtil.getCacheSql("mproject-log-logPrint");
			paramsMap.clear();
			
			paramsMap.put("id", UUIDGenerator.getUUID());
			paramsMap.put("boxId", boxId);
			paramsMap.put("userName", curUser);
			paramsMap.put("curDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
			paramsMap.put("printEntrance", entrance);
			paramsMap.put("reportName", reportName);
			
			String addPrintLogSql =  ConfigSQLUtil.preProcessSQL(addPrintLogPreSql, paramsMap);
			//日志入库
			try {
				springJdbcDao.execute(addPrintLogSql);
			} catch (DataAccessException dae) {
				log.info(dae.toString());
			}			
		}
		return alProcessors;
	}
}
