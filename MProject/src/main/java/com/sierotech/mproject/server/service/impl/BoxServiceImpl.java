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

}
