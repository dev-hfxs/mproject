/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月19日
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
import com.sierotech.mproject.server.service.IOrgService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月19日
* @功能描述: 
 */
@Service
public class OrgServiceImpl implements IOrgService {

	static final Logger log = LoggerFactory.getLogger(OrgServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;
	
	/*
	 * 检查单位名称是否重复
	 * */
	public boolean checkOrgExist(String orgId, String orgName) throws BusinessException {
		boolean result = true;
		if (null == orgId) {
			return true;
		}
		if (null == orgName || "".equals(orgName)) {
			throw new BusinessException("单位名验证,单位名参数为空!");
		}
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("orgId", orgId);
		paramsMap.put("orgName", orgName);

		String preSql = ConfigSQLUtil.getCacheSql("mproject-org-checkOrgExistsByOrgName");
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
			log.info("单位名验证，访问数据库异常.");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void addOrg(String adminUser, Map<String, Object> orgObj) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("添加单位错误,当前操作是未知的管理员!");
		}

		if (null == orgObj.get("orgName")) {
			throw new BusinessException("添加单位错误,缺少单位名!");
		}
		if (null == orgObj.get("orgCode")) {
			throw new BusinessException("添加单位参数错误,缺少单位编码.");
		}
		if (null == orgObj.get("taxNumber")) {
			throw new BusinessException("添加单位参数错误,缺少税号.");
		}
		// 检查单位名是否重复
		boolean orgExists = checkOrgExist("", orgObj.get("orgName").toString());
		if (orgExists) {
			throw new BusinessException("单位名已存在!");
		}
		String orgId = UUIDGenerator.getUUID();
		orgObj.put("orgId", orgId);
		orgObj.put("creator", adminUser);
		orgObj.put("createDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		String preSql = ConfigSQLUtil.getCacheSql("mproject-org-addOrg");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, orgObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("添加单位,访问数据库异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "单位管理", "添加单位:[" + orgObj.get("orgName").toString() + "].");
	}


	public void updateOrg(String adminUser, Map<String, Object> orgObj) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("修改单位错误,当前操作是未知的管理员!");
		}

		if (null == orgObj.get("orgName")) {
			throw new BusinessException("修改单位错误,缺少单位名!");
		}
		if (null == orgObj.get("orgCode")) {
			throw new BusinessException("修改单位参数错误,缺少单位编码.");
		}
		if (null == orgObj.get("taxNumber")) {
			throw new BusinessException("修改单位参数错误,缺少税号.");
		}
		// 检查单位名是否重复
		boolean orgExists = checkOrgExist(orgObj.get("orgId").toString(), orgObj.get("orgName").toString());
		if (orgExists) {
			throw new BusinessException("单位名已存在!");
		}

		String preSql = ConfigSQLUtil.getCacheSql("mproject-org-updateOrg");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, orgObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("修改单位,访问数据库异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "单位管理", "修改单位:[" + orgObj.get("orgName").toString() + "].");
	}

	@Override
	public void deleteOrg(String adminUser, String orgId) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("删除单位错误,当前操作是未知的管理员!");
		}
		if (null == orgId) {
			throw new BusinessException("删除单位错误,缺少单位ID!");
		}

		// 先获取单位
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-org-queryOrgById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("orgId", orgId);
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alOrgs;
		try {
			alOrgs = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			throw new BusinessException("删除单位错误,获取单位访问数据库异常.");
		}
		Map<String, Object> orgObj;
		if (alOrgs != null && alOrgs.size() > 0) {
			orgObj = alOrgs.get(0);
		} else {
			throw new BusinessException("删除单位错误,未查询到用户.");
		}

		// todo 1 检查单位下面是否有施工经理,有在建的项目

		String preUpdateSql = ConfigSQLUtil.getCacheSql("mproject-org-deleteOrgById");
		paramsMap.clear();
		paramsMap.put("orgId", orgId);
		String updateSql = ConfigSQLUtil.preProcessSQL(preUpdateSql, paramsMap);
		try {
			springJdbcDao.update(updateSql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("删除单位错误,访问数据库异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "单位管理", "删除单位:[" + orgObj.get("org_name").toString() + "].");
	}

	@Override
	public void recoverOrg(String adminUser, String orgId) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("恢复单位错误,当前操作是未知的管理员!");
		}
		if (null == orgId) {
			throw new BusinessException("恢复单位错误,缺少单位ID!");
		}

		// 先获取单位
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-org-queryOrgById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("orgId", orgId);
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alOrgs;
		try {
			alOrgs = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			throw new BusinessException("恢复单位错误,获取单位访问数据库异常.");
		}
		Map<String, Object> orgObj;
		if (alOrgs != null && alOrgs.size() > 0) {
			orgObj = alOrgs.get(0);
		} else {
			throw new BusinessException("恢复单位错误,未查询到用户.");
		}

		String preUpdateSql = ConfigSQLUtil.getCacheSql("mproject-org-recoverOrgById");
		paramsMap.clear();
		paramsMap.put("orgId", orgId);
		String updateSql = ConfigSQLUtil.preProcessSQL(preUpdateSql, paramsMap);
		try {
			springJdbcDao.update(updateSql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("恢复单位错误,访问数据库异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "单位管理", "恢复单位:[" + orgObj.get("org_name").toString() + "].");
	}

}
