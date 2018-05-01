/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月27日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service.impl;

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
			log.info("机箱编号验证，访问数据库异常.");
		} catch (Exception e) {
			e.printStackTrace();
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
		
		// TODO 检查机箱数量是否到达项目设置的上限
		
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
			log.info(dae.toString());
			throw new BusinessException("删除机箱错误,访问数据库异常.");
		}
	}


	@Override
	public void updateBox4Submit(String curUser, String boxId) throws BusinessException {
		if (null == boxId || "".equals(boxId)) {
			throw new BusinessException("提交机箱错误,缺少ID!");
		}
		
		//检查机箱下是否维护了处理器		
		//检查机箱下的处理器是否维护了探测器
		String preSql = ConfigSQLUtil.getCacheSql("mproject-box-getBoxBelowInfo");
		Map<String,Object> paramsMap = new HashMap<String,Object>();
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
			e.printStackTrace();
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
	public void updateBox4Accept(String curUser, String boxId) throws BusinessException {
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
			e.printStackTrace();
		}
		//检查机箱下的IP是否为空或为0.0.0.0
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
			throw new BusinessException("确认验收机箱错误,机箱下存在IP为空的处理器.");
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
}
