/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月29日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service.impl;

import java.util.HashMap;
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
import com.sierotech.mproject.common.utils.UUIDGenerator;
import com.sierotech.mproject.server.service.IProcessorService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月29日
* @功能描述: 
 */
@Service
public class ProcessorServiceImpl implements IProcessorService {
	static final Logger log = LoggerFactory.getLogger(ProcessorServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;
	
	
	@Override
	public void addProcessor(String curUser, Map<String, Object> processorObj) throws BusinessException {
		if (null == processorObj.get("boxId")) {
			throw new BusinessException("添加处理器错误,缺少机箱ID!");
		}
		if (null == processorObj.get("nfcNumber")) {
			throw new BusinessException("添加处理器错误,缺少NFC序列号!");
		}
		if (null == processorObj.get("moxaNumber")) {
			throw new BusinessException("添加处理器错误,缺少MOXA-NFC序列号!");
		}
		if (null == processorObj.get("detectorNum")) {
			throw new BusinessException("添加处理器错误,缺少探测器数量!");
		}
		// TODO检查 NFC序列号、处理器ID、MOXA序列号是否重复
		// TODO检查探测器数量是否超出范围
		
		String primarykey = UUIDGenerator.getUUID();
		processorObj.put("id", primarykey);
		processorObj.put("creator", curUser);
		processorObj.put("createDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		String preSql = ConfigSQLUtil.getCacheSql("mproject-processor-add");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, processorObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("添加处理器错误,访问数据库异常.");
		}
	}

	@Override
	public void updateProcessor(String curUser, Map<String, Object> processorObj) throws BusinessException {
		if (null == processorObj.get("id")) {
			throw new BusinessException("修改处理器错误,缺少处理器ID!");
		}
		if (null == processorObj.get("nfcNumber")) {
			throw new BusinessException("修改处理器错误,缺少NFC序列号!");
		}
		if (null == processorObj.get("moxaNumber")) {
			throw new BusinessException("修改处理器错误,缺少MOXA-NFC序列号!");
		}
		if (null == processorObj.get("detectorNum")) {
			throw new BusinessException("修改处理器错误,探测器数量!");
		}
		// TODO检查 NFC序列号、MOXA序列号是否重复
		String preSql = ConfigSQLUtil.getCacheSql("mproject-processor-updateProcessorById");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, processorObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("修改处理器错误,访问数据库异常.");
		}
	}

	@Override
	public void deleteProcessor(String curUser, String id) throws BusinessException {
		Map<String,Object> paramsMap = new HashMap<String,Object>();
		paramsMap.clear();
		paramsMap.put("processorId", id);
		String deleteDetectorPreSql = ConfigSQLUtil.getCacheSql("mproject-processor-deleteDetectorByProcessorId");
		String deleteDetectorSql = ConfigSQLUtil.preProcessSQL(deleteDetectorPreSql, paramsMap);
		paramsMap.clear();
		paramsMap.put("id", id);		
		String deleteProcessorPreSql = ConfigSQLUtil.getCacheSql("mproject-processor-deleteProcessorById");
		String deleteProcessorSql = ConfigSQLUtil.preProcessSQL(deleteProcessorPreSql, paramsMap);
		
		StringBuffer sb = new StringBuffer();
		sb.append(deleteDetectorSql).append(";\n");
		sb.append(deleteProcessorSql);
		
		try {
			springJdbcDao.batchUpdate(sb.toString().split(";\n"));			
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("删除处理器错误,访问数据库异常.");
		}
	}
}
