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
	public void update4ImportDetector(String curUser,String processorId, boolean enableReplace, List<Map<String, String>> datas)
			throws BusinessException {
		if(datas!= null && datas.size() >0) {
			if(enableReplace) {
				StringBuffer checkSql = new StringBuffer();
				checkSql.append("select detector_id, '1' from t_detector where detector_id in(  ");
				//根据探测器ID覆盖
				for(Map<String, String> data : datas) {
					if(data.get("detector_id") != null) {
						checkSql.append("'").append(data.get("detector_id")).append("',");
					}					 
				}
				checkSql.setLength(checkSql.length() - 1);
				checkSql.append(") ");
				List<Map<String,Object>> existsData;
				try {
					existsData = springJdbcDao.queryForList(checkSql.toString());
				}catch(DataAccessException dae ) {
					throw new BusinessException("导入探测器错误,访问数据库检查数据异常.");
				}
				Map<String,String> existsDetectorIdMap = new HashMap<String,String>();
				if(existsData!=null) {
					for(Map<String,Object> record:existsData) {
						String detectorId = record.get("detector_id")!= null ? record.get("detector_id").toString() : "";
						existsDetectorIdMap.put(detectorId, "1");
					}
				}
				
				//生成插入数据的sql
				StringBuffer importDataSql = new StringBuffer();
				for(Map<String, String> data : datas) {
					String detectorSeq = data.get("detector_seq")!= null ? data.get("detector_seq").toString() : "";
					String nfcNumber = data.get("nfc_number")!= null ? data.get("nfc_number").toString() : "";
					String longitude = data.get("longitude")!= null ? data.get("longitude").toString() : "null";
					String latitude = data.get("latitude")!= null ? data.get("latitude").toString() : "null";
					String start_point = data.get("start_point")!= null ? data.get("start_point").toString() : "null";
					String end_point = data.get("end_point")!= null ? data.get("end_point").toString() : "null";
					String pos_desc = data.get("pos_desc")!= null ? data.get("pos_desc").toString() : "";
					
					if(existsDetectorIdMap.get(detectorSeq) != null) {
						//存在						
						importDataSql.append(" update t_detector set ");
						importDataSql.append(" nfc_number='").append(nfcNumber).append("'");
						importDataSql.append(", longitude=").append(longitude).append("");
						importDataSql.append(", latitude=").append(latitude).append("");
						importDataSql.append(", start_point=").append(start_point).append("");
						importDataSql.append(", end_point=").append(end_point).append("");
						importDataSql.append(" where processor_id='").append(processorId).append("'");
						importDataSql.append(" and detector_seq = '").append(detectorSeq).append("'").append(";\n");						
					}else {
						//不存在
						importDataSql.append(" insert into t_detector(id,detector_seq,processor_id,nfc_number,longitude,latitude,start_point,end_point) values (");
						importDataSql.append(" '").append(UUIDGenerator.getUUID()).append("'");
						importDataSql.append(",'").append(detectorSeq).append("'");
						importDataSql.append(",'").append(processorId).append("'");
						importDataSql.append(",'").append(nfcNumber).append("'");
						importDataSql.append(", ").append(longitude).append("");
						importDataSql.append(", ").append(latitude).append("");
						importDataSql.append(", ").append(start_point).append("");
						importDataSql.append(", ").append(end_point).append("");
						importDataSql.append(" ) ;\n");
					}					
				}
				try {
					springJdbcDao.batchUpdate(importDataSql.toString().split("\n"));
				}catch(DataAccessException dae ) {
					throw new BusinessException("导入探测器错误,数据入库异常.");
				}
			}else {
				//生成插入数据的sql
				StringBuffer importDataSql = new StringBuffer();
				for(Map<String, String> data : datas) {
					String detectorSeq = data.get("detector_seq")!= null ? data.get("detector_seq").toString() : "";
					String nfcNumber = data.get("nfc_number")!= null ? data.get("nfc_number").toString() : "";
					String longitude = data.get("longitude")!= null ? data.get("longitude").toString() : "null";
					String latitude = data.get("latitude")!= null ? data.get("latitude").toString() : "null";
					String start_point = data.get("start_point")!= null ? data.get("start_point").toString() : "null";
					String end_point = data.get("end_point")!= null ? data.get("end_point").toString() : "null";
					String pos_desc = data.get("pos_desc")!= null ? data.get("pos_desc").toString() : "";
					
					importDataSql.append(" insert into t_detector(id,detector_seq,processor_id,nfc_number,longitude,latitude,start_point,end_point) values (");
					importDataSql.append(" '").append(UUIDGenerator.getUUID()).append("'");
					importDataSql.append(",'").append(detectorSeq).append("'");
					importDataSql.append(",'").append(processorId).append("'");
					importDataSql.append(",'").append(nfcNumber).append("'");
					importDataSql.append(", ").append(longitude).append("");
					importDataSql.append(", ").append(latitude).append("");
					importDataSql.append(", '").append(start_point).append("'");
					importDataSql.append(", '").append(end_point).append("'");
					importDataSql.append(" ) ;\n");
				}
				try {
//					log.info(importDataSql.toString());
					springJdbcDao.batchUpdate(importDataSql.toString().split("\n"));
				}catch(DataAccessException dae ) {
					throw new BusinessException("导入探测器错误,数据入库异常.");
				}
			}
		}
	}

}
