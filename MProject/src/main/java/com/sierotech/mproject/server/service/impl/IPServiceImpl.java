/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月11日
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
import com.sierotech.mproject.server.service.IPService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月11日
* @功能描述: 
 */
@Service
public class IPServiceImpl implements IPService {

	static final Logger log = LoggerFactory.getLogger(IPServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;

	@Override
	public void addIP(String adminUser, Map<String, Object> ipObj) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("添加IP错误,当前操作是未知的管理员!");
		}

		if (null == ipObj.get("projectId")) {
			throw new BusinessException("添加IP错误, 缺少项目名称!");
		}
		if (null == ipObj.get("netName")) {
			throw new BusinessException("添加IP错误, 缺少网段名称!");
		}
		if (null == ipObj.get("ip")) {
			throw new BusinessException("添加IP错误, 缺少ip!");
		}
		if (null == ipObj.get("gateway")) {
			throw new BusinessException("添加IP错误, 缺少网关!");
		}
		if (null == ipObj.get("netMask")) {
			throw new BusinessException("添加IP错误, 缺少子网掩码!");
		}
		String ipID = UUIDGenerator.getUUID();
		ipObj.put("id", ipID);
		ipObj.put("status", 'N');
		ipObj.put("createDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		String preSql = ConfigSQLUtil.getCacheSql("mproject-ip-addIP");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, ipObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("添加IP错误,访问数据库异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "IP管理", "添加IP:[" + ipObj.get("ip").toString() + "].");
	}

	@Override
	public void updateIP(String adminUser, Map<String, Object> ipObj) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("修改IP错误,当前操作是未知的管理员!");
		}

		if (null == ipObj.get("projectId")) {
			throw new BusinessException("修改IP错误, 缺少项目名称!");
		}
		if (null == ipObj.get("netName")) {
			throw new BusinessException("修改IP错误, 缺少网段名称!");
		}
		if (null == ipObj.get("ip")) {
			throw new BusinessException("修改IP错误, 缺少ip!");
		}
		if (null == ipObj.get("gateway")) {
			throw new BusinessException("修改IP错误, 缺少网关!");
		}
		if (null == ipObj.get("netMask")) {
			throw new BusinessException("修改IP错误, 缺少子网掩码!");
		}
		//获取修改前的IP
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-ip-getIPById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("id", ipObj.get("id").toString());
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alIps;
		try {
			alIps = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			throw new BusinessException("修改IP错误, 未查询到IP!");
		}
		Map<String, Object> oldIpObj;
		if (alIps != null && alIps.size() > 0) {
			oldIpObj = alIps.get(0);
		} else {
			throw new BusinessException("修改IP错误, 未查询到IP!");
		}
		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-ip-updateIP");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, ipObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("修改IP错误,访问数据库异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "IP管理", "修改前IP:[" + oldIpObj.get("ip").toString() + "],修改后的IP:[" + ipObj.get("ip").toString()+"]");
	}

	@Override
	public void deleteIP(String adminUser, String ipID) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("删除IP错误,当前操作是未知的管理员!");
		}

		if (null == ipID) {
			throw new BusinessException("删除IP错误, 未指定删除IP的ID!");
		}
		
		String preUpdateSql = ConfigSQLUtil.getCacheSql("mproject-ip-deleteIP");
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.clear();
		paramMap.put("id", ipID);
		String updateSql = ConfigSQLUtil.preProcessSQL(preUpdateSql, paramMap);
		try {
			springJdbcDao.update(updateSql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("删除IP错误,访问数据库异常.");
		}
	}

	@Override
	public void updateStatus(String userId, String ipID, String status) throws BusinessException {
		if(ipID == null) {
			throw new BusinessException("标记IP错误, 缺少ipID.");
		}
		String[]  arrStatus = new String[] {"Y","N","L","Q"};
		boolean validStatus = false;
		for(String value : arrStatus) {
			if(value.equals(status)) {
				validStatus = true;
				break;
			}			
		}
		
		if(validStatus == false) {
			throw new BusinessException("标记IP错误, 状态值不正确.");
		}
		
		if("L".equals(status)) {
			//TODO 可以增加用户至多锁定限定个数的IP,比如10个
		}
		
		//获取修改前的IP
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-ip-getIPById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("id", ipID);
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alIps;
		try {
			alIps = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			throw new BusinessException("标记IP错误, 未查询到IP!");
		}
		Map<String, Object> oldIpObj;
		if (alIps != null && alIps.size() > 0) {
			oldIpObj = alIps.get(0);
		} else {
			throw new BusinessException("标记IP错误, 未查询到IP!");
		}
		if("N".equals(status)) {
			paramsMap.put("markUser", "");
		}else {
			paramsMap.put("markUser", userId);
		}
		paramsMap.put("status", status);
		paramsMap.put("id", ipID);
		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-ip-updateIpStatus");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramsMap);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("标记IP错误,访问数据库异常.");
		}
	}

	@Override
	public void update4ImportIp(String projectId, List<Map<String, String>> datas)
			throws BusinessException {
		StringBuffer sbInsert = new StringBuffer();
		StringBuffer sbQuery = new StringBuffer();
		String curDate = DateUtils.getNow(DateUtils.FORMAT_LONG);
		if(datas!= null && datas.size() >0) {			
			for(Map<String, String> data : datas) {
				if(data.get("ip") == null || "".equals(data.get("ip"))) {
					continue;
				}
				if(data.get("gateway") == null || "".equals(data.get("gateway"))) {
					continue;
				}
				if(data.get("net_mask") == null || "".equals(data.get("net_mask"))) {
					continue;
				}
				if(data.get("net_name") == null || "".equals(data.get("net_name"))) {
					continue;
				}
				String id = UUIDGenerator.getUUID();
				String ip = data.get("ip").toString();
				String gateway = data.get("gateway").toString();
				String netMask = data.get("net_mask").toString();
				String netName = data.get("net_name").toString();
				sbQuery.setLength(0);
				sbQuery.append(" SELECT id FROM t_ip_info WHERE ");
				sbQuery.append("     ip='").append(ip).append("'");
				sbQuery.append(" and gateway='").append(gateway).append("'");
				sbQuery.append(" and net_mask='").append(netMask).append("'");
				sbQuery.append(" and net_name='").append(netName).append("'");
				sbQuery.append(" and project_id='").append(projectId).append("'");
				List alIps = null;
				try {
					alIps = springJdbcDao.queryForList(sbQuery.toString());
				}catch(DataAccessException dae ) {
					log.info(dae.getMessage());
				}
				if(alIps != null && alIps.size() > 0) {
					continue;
				}else {
					sbInsert.setLength(0);
					sbInsert.append(" insert into t_ip_info").append(" (id, ip, gateway, net_mask, net_name, project_id, status, create_date) values(");
					sbInsert.append("'").append(id).append("'");
					sbInsert.append(", '").append(ip).append("'");
					sbInsert.append(", '").append(gateway).append("'");
					sbInsert.append(", '").append(netMask).append("'");
					sbInsert.append(", '").append(netName).append("'");
					sbInsert.append(", '").append(projectId).append("'");
					sbInsert.append(", '").append('N').append("'");
					sbInsert.append(", '").append(curDate).append("' )");
					try {
						springJdbcDao.update(sbInsert.toString());
					}catch(DataAccessException dae ) {
						log.info(dae.getMessage());
					}
				}
								
			}	
		}
	}
}
