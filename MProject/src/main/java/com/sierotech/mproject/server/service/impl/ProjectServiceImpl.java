/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月20日
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
import com.sierotech.mproject.server.service.IProjectService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月20日
* @功能描述: 项目维护服务实现
 */
@Service
public class ProjectServiceImpl implements IProjectService {

	static final Logger log = LoggerFactory.getLogger(ProjectServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;
	
	@Override
	public boolean checkProjectName(String projectId, String projectName) throws BusinessException {
		boolean result = true;
		if (null == projectId) {
			return true;
		}
		if (null == projectName || "".equals(projectName)) {
			throw new BusinessException("项目名验证,项目名参数为空!");
		}
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("projectId", projectId);
		paramsMap.put("projectName", projectName);

		String preSql = ConfigSQLUtil.getCacheSql("mproject-project-checkProjectExistsByName");
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
			log.info("项目名验证，访问数据库异常.");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@Override
	public void addProject(String adminUser, Map<String, Object> projectObj) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("新建项目错误,当前操作是未知的管理员!");
		}

		if (null == projectObj.get("projectName")) {
			throw new BusinessException("新建项目错误,缺少项目名!");
		}
		if (null == projectObj.get("projectNumber")) {
			throw new BusinessException("新建项目错误,缺少项目编码.");
		}
		if (null == projectObj.get("contractNumber")) {
			throw new BusinessException("新建项目错误,缺少合同号.");
		}
		// 检查项目名是否重复
		boolean projectExists = checkProjectName("", projectObj.get("projectName").toString());
		if (projectExists) {
			throw new BusinessException("项目名已存在!");
		}
		String projectId = UUIDGenerator.getUUID();
		projectObj.put("projectId", projectId);
		projectObj.put("creator", adminUser);
		projectObj.put("createDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		String preSql = ConfigSQLUtil.getCacheSql("mproject-project-addProject");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, projectObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("新建项目,数据存储异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "项目管理", "新建项目:[" + projectObj.get("projectName").toString() + "].");
	}

	@Override
	public void updateProject(String adminUser, Map<String, Object> projectObj) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("修改项目错误,当前操作是未知的管理员!");
		}

		if (null == projectObj.get("projectId")) {
			throw new BusinessException("修改项目错误,缺少项目ID!");
		}
		if (null == projectObj.get("projectName")) {
			throw new BusinessException("修改项目错误,缺少项目名!");
		}
		if (null == projectObj.get("projectNumber")) {
			throw new BusinessException("修改项目错误,缺少项目编码.");
		}
		if (null == projectObj.get("contractNumber")) {
			throw new BusinessException("修改项目错误,缺少合同号.");
		}
		// 检查项目名是否重复
		boolean projectExists = checkProjectName(projectObj.get("projectId").toString(), projectObj.get("projectName").toString());
		if (projectExists) {
			throw new BusinessException("项目名已存在!");
		}
		
		// 先获取项目
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-project-queryProjectById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("projectId", projectObj.get("projectId").toString());
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alProjects;
		try {
			alProjects = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			throw new BusinessException("恢复单位错误,获取单位访问数据库异常.");
		}
		Map<String, Object> oldProjectObj;
		if (alProjects != null && alProjects.size() > 0) {
			oldProjectObj = alProjects.get(0);
		} else {
			throw new BusinessException("恢复单位错误,未查询到单位.");
		}
				
		String preSql = ConfigSQLUtil.getCacheSql("mproject-project-updateProject");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, projectObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("修改项目,数据存储异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "项目管理", "修改项目:[" + projectObj.get("projectName").toString() + "].");
	}


	@Override
	public void updateStatus(String adminUser, String projectId, String oldStatus, String newStatus)
			throws BusinessException {
		
		
	}

}
