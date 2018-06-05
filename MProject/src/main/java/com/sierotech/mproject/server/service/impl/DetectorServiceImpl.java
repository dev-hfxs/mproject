/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月30日
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
import com.sierotech.mproject.common.utils.UUIDGenerator;
import com.sierotech.mproject.server.service.IDetectorService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月30日
* @功能描述: 
 */
@Service
public class DetectorServiceImpl implements IDetectorService{
	static final Logger log = LoggerFactory.getLogger(DetectorServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;
	
	@Override
	public void addDetector(String curUser, Map<String, Object> detectorObj) throws BusinessException {
//		if (null == detectorObj.get("detectorId")) {
//			throw new BusinessException("添加探测器错误,缺少探测器ID!");
//		}
		if (null == detectorObj.get("processorId")) {
			throw new BusinessException("添加探测器错误,缺少处理器ID!");
		}
		if (null == detectorObj.get("nfcNumber")) {
			throw new BusinessException("添加探测器错误,缺少探测器序列号!");
		}
		if (null == detectorObj.get("longitude")) {
			throw new BusinessException("添加探测器错误,缺少探测器经度!");
		}
		if (null == detectorObj.get("latitude")) {
			throw new BusinessException("添加探测器错误,缺少探测器纬度!");
		}
		//获取当前处理器下维护的探测器数		
		String getCountPreSql = ConfigSQLUtil.getCacheSql("mproject-detector-getDetectorNumByProcessorId");
		Map<String, Object> paramMap = new HashMap<String, Object>();
	    paramMap.clear();
	    paramMap.put("processorId", detectorObj.get("processorId"));
		String getCountSql = ConfigSQLUtil.preProcessSQL(getCountPreSql, paramMap);
		Map<String,Object> recordMap = null;
		try {
			recordMap = springJdbcDao.queryForMap(getCountSql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("添加探测器错误,未获取到当前处理器下的探测器数.");
		}
		if(recordMap!= null) {
			int count = 0;
			try{
				count = Integer.parseInt(recordMap.get("countNum").toString());	
			}catch(NumberFormatException ne) {
				log.info(ne.getMessage());
			}
			if(count > 240) {
				throw new BusinessException("添加探测器错误, 当前处理器探测器数已到上限.");
			}
		}
		// 保存数据到库
		String primarykey = UUIDGenerator.getUUID();
		detectorObj.put("id", primarykey);
		detectorObj.put("creator", curUser);
		detectorObj.put("createDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		String preSql = ConfigSQLUtil.getCacheSql("mproject-detector-add");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, detectorObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("添加探测器错误,访问数据库异常.");
		}
	}

	@Override
	public void updateDetector(String curUser, Map<String, Object> detectorObj) throws BusinessException {
//		if (null == detectorObj.get("detectorId")) {
//			throw new BusinessException("修改探测器错误,缺少探测器ID!");
//		}
		if (null == detectorObj.get("detectorSeq")) {
			throw new BusinessException("修改探测器错误,缺少探测器编号!");
		}
		if (null == detectorObj.get("id")) {
			throw new BusinessException("修改探测器错误,缺少ID!");
		}
		if (null == detectorObj.get("nfcNumber")) {
			throw new BusinessException("修改探测器错误,缺少探测器序列号!");
		}
		if (null == detectorObj.get("longitude")) {
			throw new BusinessException("修改探测器错误,缺少探测器经度!");
		}
		if (null == detectorObj.get("latitude")) {
			throw new BusinessException("修改探测器错误,缺少探测器纬度!");
		}
		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-detector-updateById");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, detectorObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("修改探测器错误,访问数据库异常.");
		}
	}


	@Override
	public void deleteDetector(String curUser, String id) throws BusinessException {
		if (null == id) {
			throw new BusinessException("删除探测器错误,缺少ID!");
		}
		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-detector-deleteById");
		Map<String,Object> paramsMap = new HashMap<String,Object>();
		paramsMap.clear();
		paramsMap.put("id", id);		
		
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramsMap);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("删除探测器错误,访问数据库异常.");
		}
		
	}

	@Override
	public void deleteDetectorByProcessorId(String curUser, String processorId) throws BusinessException {
		
		
	}

	@Override
	public void update4ImportDetector(String curUser,String processorId,boolean ignoreExistsData, boolean enableReplace, List<Map<String, String>> datas)
			throws BusinessException {
		if(datas!= null && datas.size() >0) {
			if(datas.size() > 240) {
				throw new BusinessException("导入探测器错误, 文件中的数据行超出240，单个处理器下的探测器不能超过240个.");
			}
			
			//获取当前处理器下已维护的探测器数
			String getCountPreSql = ConfigSQLUtil.getCacheSql("mproject-detector-getDetectorNumByProcessorId");
			Map<String, Object> paramMap = new HashMap<String, Object>();
		    paramMap.clear();
		    paramMap.put("processorId", processorId);
			String getCountSql = ConfigSQLUtil.preProcessSQL(getCountPreSql, paramMap);
			Map<String,Object> recordMap = null;
			try {
				recordMap = springJdbcDao.queryForMap(getCountSql);
			} catch (DataAccessException dae) {
				log.info(dae.toString());
				throw new BusinessException("导入探测器错误, 未获取到当前处理器下的探测器数!");
			}
			if(recordMap!= null) {
				int count = 0;
				try{
					count = Integer.parseInt(recordMap.get("countNum").toString());	
				}catch(NumberFormatException ne) {
					log.info(ne.getMessage());
				}
				int afterSize = datas.size() + count;
				if(afterSize > 240) {
					throw new BusinessException("导入探测器错误, 当前处理器下探测器数导入后将超过240!");
				}
			}
			
			//检查文件中的探测器nfc序列号、编号是否存在
			StringBuffer checkSql = new StringBuffer();
			StringBuffer checkUseSql = new StringBuffer();
			StringBuffer importDataSql = new StringBuffer();
			for(Map<String, String> data : datas) {
				checkSql.setLength(0);
				String longitude = data.get("longitude");
				if(longitude == null || longitude.indexOf(".") < 1 || longitude.substring(longitude.lastIndexOf(".")).length() < 7) {
					throw new BusinessException("导入探测器错误, 文件中的经度" + longitude + "精度不正确.");
				}
				String latitude = data.get("latitude");
				if(latitude == null || latitude.indexOf(".") < 1 || latitude.substring(latitude.lastIndexOf(".")).length() < 7) {
					throw new BusinessException("导入探测器错误, 文件中的纬度" + longitude + "精度不正确.");
				}
				
				if(data.get("nfc_number") != null) {
					checkSql.append("select nfc_code, number from t_nfc_code_detector where nfc_code ='").append(data.get("nfc_number")).append("'");
				}else {
					throw new BusinessException("导入探测器错误, 文件中的探测器NFC序列号不完整.");
				}				
				if(data.get("detector_seq") != null) {
					//checkSql.append(" and number ='").append(data.get("detector_seq")).append("'");
				}else {
					throw new BusinessException("导入探测器错误, 文件中的探测器编号不完整.");
				}
				
				List<Map<String,Object>> alSysNfcCode;
				try {					
					alSysNfcCode = springJdbcDao.queryForList(checkSql.toString());
				}catch(DataAccessException dae ) {
					throw new BusinessException("导入探测器错误, 检查序列号操作数据库异常.");
				}
				if(alSysNfcCode == null || alSysNfcCode.size() < 1) {
					throw new BusinessException("导入探测器错误, 序列号["+data.get("nfc_number")+"]在探测器NFC编码库中不存在.");
				}else {
					if(alSysNfcCode.get(0).get("number")!=null) {
						String recordNumber = alSysNfcCode.get(0).get("number").toString();
						if(!recordNumber.equals(data.get("detector_seq"))) {
							throw new BusinessException("导入探测器错误, 序列号["+data.get("nfc_number")+"]在探测器NFC编码库中对应的编号与文件中的编号["+data.get("detector_seq")+"]不一致.");
						}
					}
				}
				
				//检查nfc号是否已录入
				checkUseSql.setLength(0);
				checkUseSql.append("select nfc_number from t_detector where nfc_number='").append(data.get("nfc_number")).append("'");
				List usedNfcCode = springJdbcDao.queryForList(checkUseSql.toString());
				if(usedNfcCode!=null && usedNfcCode.size() > 0) {
					throw new BusinessException("导入探测器错误, 探测器NFC序列号["+data.get("nfc_number")+"]已录入.");
				}
				
				String detectorSeq = data.get("detector_seq")!= null ? data.get("detector_seq").toString() : "";
				String start_point = data.get("start_point")!= null ? data.get("start_point").toString() : "N";
				if("是".equals(start_point)) {
					start_point = "Y";
				}
				if("否".equals(start_point)) {
					start_point = "N";
				}
				
				String end_point = data.get("end_point")!= null ? data.get("end_point").toString() : "N";
				if("是".equals(end_point)) {
					end_point = "Y";
				}
				if("否".equals(end_point)) {
					end_point = "N";
				}
				importDataSql.append(" insert into t_detector(id,detector_id, detector_seq,processor_id,nfc_number,longitude,latitude,start_point,end_point) values (");
				importDataSql.append(" '").append(UUIDGenerator.getUUID()).append("'");
				// importDataSql.append(",'").append(data.get("detector_id")).append("'");
				importDataSql.append(",'").append("").append("'");
				importDataSql.append(",'").append(detectorSeq).append("'");
				importDataSql.append(",'").append(processorId).append("'");
				importDataSql.append(",'").append(data.get("nfc_number")).append("'");
				importDataSql.append(", ").append(longitude).append("");
				importDataSql.append(", ").append(latitude).append("");
				importDataSql.append(", '").append(start_point).append("'");
				importDataSql.append(", '").append(end_point).append("'");
				importDataSql.append(" ) ;\n");
			}
			if(importDataSql.length()> 0) {
				try {
					springJdbcDao.batchUpdate(importDataSql.toString().split("\n"));
				}catch(DataAccessException dae ) {
					log.info(dae.getMessage());
					throw new BusinessException("导入探测器错误,数据入库异常.");
				}
			}
		}
	}

}
