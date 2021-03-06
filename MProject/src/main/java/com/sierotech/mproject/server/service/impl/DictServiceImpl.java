/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月5日
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
import com.sierotech.mproject.server.service.IDictService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月5日
* @功能描述: 
 */
@Service
public class DictServiceImpl implements IDictService {
	
	static final Logger log = LoggerFactory.getLogger(DictServiceImpl.class);
	
	@Autowired
	private JdbcTemplate springJdbcDao;
	
	@Override
	public void update4ImportCode(String curUser, String dataName, List<Map<String, String>> datas)
			throws BusinessException {
		String tableName ;
		if("box".equals(dataName)) {
			tableName = "t_nfc_code_machinebox";
		}else if("processor".equals(dataName)) {
			tableName = "t_nfc_code_processor";
		}else if("moxa".equals(dataName)) {
			tableName = "t_nfc_code_moxa";
		}else if("detector".equals(dataName)) {
			tableName = "t_nfc_code_detector";
		}else {
			throw new BusinessException("导入NFC序列号错误，未知的数据.");
		}
		
		StringBuffer sbInsert = new StringBuffer();
		StringBuffer sbUpdate = new StringBuffer();
		
		
		String curDate = DateUtils.getNow(DateUtils.FORMAT_LONG);
		if(datas!= null && datas.size() >0) {			
			if("processor".equals(dataName) || "moxa".equals(dataName)) {
				for(Map<String, String> data : datas) {
					if(data.get("nfc_code") == null || "".equals(data.get("nfc_code"))) {
						continue;
					}
					String nfcCode = data.get("nfc_code").toString().toUpperCase();
					String number = data.get("number") == null ? "" : data.get("number").toString();
					String box_nfc_code = data.get("box_nfc_code")==null ? "" : data.get("box_nfc_code").toString();
					sbInsert.setLength(0);
					sbInsert.append(" insert into ").append(tableName).append(" (nfc_code,number,box_nfc_code, create_date) values(");
					sbInsert.append("'").append(nfcCode).append("','").append(number).append("','").append(box_nfc_code).append("','").append(curDate).append("')");
					try {
						springJdbcDao.update(sbInsert.toString());
					}catch(DataAccessException dae ) {
						//
//						sbUpdate.setLength(0);
//						sbUpdate.append(" update ").append(tableName).append(" set number =");
//						sbUpdate.append("'").append(number).append("', box_nfc_code='").append(box_nfc_code).append("' where nfc_code='").append(nfcCode).append("'");
//						try {
//							springJdbcDao.update(sbUpdate.toString());
//						}catch(DataAccessException dae2 ) {
//							log.info(dae2.getMessage());
//						}
						if(dae.getMessage().indexOf("Duplicate") > 0) {
							throw new BusinessException("NFC序列号[" + nfcCode + "]的数据已存在,导入终止!");
						}else {
							log.info(dae.getMessage());
							throw new BusinessException("NFC序列号[" + nfcCode + "]的数据未知错误, 导入终止!");
						}
					}
				}
			}else {
				int pSize =0;
				for(Map<String, String> data : datas) {
					if(data.get("nfc_code") == null || "".equals(data.get("nfc_code"))) {
						continue;
					}
					pSize ++;
					if(pSize % 240 ==0 ) {
						curDate = DateUtils.getNow(DateUtils.FORMAT_LONG);
					}
					String nfcCode = data.get("nfc_code").toString().toUpperCase();
					String number = data.get("number").toString();
					sbInsert.setLength(0);
					sbInsert.append(" insert into ").append(tableName).append(" (nfc_code,number,create_date) values(");
					sbInsert.append("'").append(nfcCode).append("','").append(number).append("','").append(curDate).append("')");
					try {
						springJdbcDao.update(sbInsert.toString());
					}catch(DataAccessException dae ) {
						//
//						sbUpdate.setLength(0);
//						sbUpdate.append(" update ").append(tableName).append(" set number =");
//						sbUpdate.append("'").append(number).append("' where nfc_code='").append(nfcCode).append("'");
//						try {
//							springJdbcDao.update(sbUpdate.toString());
//						}catch(DataAccessException dae2 ) {
//							log.info(dae2.getMessage());
//						}
						
						if(dae.getMessage().indexOf("Duplicate") > 0) {
							throw new BusinessException("NFC序列号[" + nfcCode + "]的数据已存在,导入终止!");
						}else {
							log.info(dae.getMessage());
							throw new BusinessException("NFC序列号[" + nfcCode + "]的数据未知错误, 导入终止!");
						}
					}
				}
			}			
		}
	}

	@Override
	public Map<String, Object> queryNfcDataByCode(String dataName, String codeValue) throws BusinessException {
		String dataPreSql ; 
		if("box".equals(dataName)) {
			dataPreSql = ConfigSQLUtil.getCacheSql("mproject-dict-queryBoxNfcByCode");
		}else if("processor".equals(dataName)) {
			dataPreSql = ConfigSQLUtil.getCacheSql("mproject-dict-queryProcessorNfcByCode");
		}else if("moxa".equals(dataName)) {
			dataPreSql = ConfigSQLUtil.getCacheSql("mproject-dict-queryMoxaNfcByCode");
		}else if("detector".equals(dataName)) {
			dataPreSql = ConfigSQLUtil.getCacheSql("mproject-dict-queryDetectorNfcByCode");
		}else {
			return null;
		}
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("nfcCode", codeValue);
		String dataSql = ConfigSQLUtil.preProcessSQL(dataPreSql, paramsMap);
		Map<String, Object> nfcDataMap = null;
		try {
			nfcDataMap = springJdbcDao.queryForMap(dataSql);
		}catch(DataAccessException dae2 ) {
			log.info(dae2.getMessage());
		}
		return nfcDataMap;
	}

	@Override
	public boolean checkNfcCodeUsed(String dataName, String codeValue, String dataId) throws BusinessException {
		String dataPreSql ; 
		if("box".equals(dataName)) {
			dataPreSql = ConfigSQLUtil.getCacheSql("mproject-dict-boxNfcCodeCheckUse");
		}else if("processor".equals(dataName)) {
			dataPreSql = ConfigSQLUtil.getCacheSql("mproject-dict-processorNfcCheckUse");
		}else if("moxa".equals(dataName)) {
			dataPreSql = ConfigSQLUtil.getCacheSql("mproject-dict-moxaNfcCodeCheckUse");
		}else if("detector".equals(dataName)) {
			dataPreSql = ConfigSQLUtil.getCacheSql("mproject-dict-detectorNfcCodeCheckUse");
		}else {
			return false;
		}
		boolean codeUsed = false;
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("nfcCode", codeValue);
		if(dataId != null && dataId.length() > 0) {
			paramsMap.put("id", dataId);
		}
		String dataSql = ConfigSQLUtil.preProcessSQL(dataPreSql, paramsMap);
		Map<String, Object> nfcDataMap = null;
		try {
			nfcDataMap = springJdbcDao.queryForMap(dataSql);
			if(nfcDataMap != null && nfcDataMap.get("countNum") != null) {
				String countNum = nfcDataMap.get("countNum").toString();
				int num = Integer.parseInt(countNum);
				if(num > 0) {
					codeUsed = true;
				}
			}
		}catch(DataAccessException dae2 ) {
			log.info(dae2.getMessage());
		}catch(NumberFormatException ne) {
			log.info(ne.getMessage());
		}
		
		return codeUsed;
	}

}
