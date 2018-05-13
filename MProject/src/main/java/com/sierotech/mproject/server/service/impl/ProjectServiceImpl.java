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
			log.info(ex.getMessage());
		} catch (Exception e) {
			log.info(e.getMessage());
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
			log.info(dae.getMessage());
			throw new BusinessException("修改项目错误,获取项目访问数据库异常.");
		}
		Map<String, Object> oldProjectObj;
		if (alProjects != null && alProjects.size() > 0) {
			oldProjectObj = alProjects.get(0);
		} else {
			throw new BusinessException("修改项目错误,未查询到项目.");
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

	@Override
	public void addProjectPsn(String adminUser, String projectId, String userId, int allowBoxNum, String duty)
			throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("设置项目施工经理错误,当前操作是未知的用户!");
		}

		if (null == projectId) {
			throw new BusinessException("设置项目施工经理错误,缺少项目ID!");
		}
		if (null == userId) {
			throw new BusinessException("设置项目施工经理错误,缺少用户ID!");
		}
		// 先获取项目
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-project-queryProjectById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("projectId", projectId);
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alProjects;
		try {
			alProjects = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			throw new BusinessException("设置项目施工经理错误,查找对应的项目错误.");
		}
		Map<String, Object> projectObj;
		if (alProjects != null && alProjects.size() > 0) {
			projectObj = alProjects.get(0);
		} else {
			throw new BusinessException("设置项目施工经理错误,未找到对应的项目.");
		}
		
		// 获取项目的应建机箱数
		int projectBoxNum = 0;
		try {
			projectBoxNum = Integer.parseInt(projectObj.get("allow_box_num").toString());			
		}catch(NumberFormatException ne) {
			throw new BusinessException("设置项目施工经理错误,项目应建机箱数未设置正确.");
		}
		//获取项目已分配(其他施工经理)的机箱数
		String allotBoxNumPreSql = ConfigSQLUtil.getCacheSql("mproject-project-getProjectHadAllotBoxNum");
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("projectId", projectId);
		String allotBoxNumSql = ConfigSQLUtil.preProcessSQL(allotBoxNumPreSql, paramMap);
		List<Map<String, Object>> alProjectAllotBoxs;
		try {
			alProjectAllotBoxs = springJdbcDao.queryForList(allotBoxNumSql);
		}
		catch (DataAccessException dae) {
			throw new BusinessException("设置项目施工经理错误,获取项目已分配的机箱数错误.");
		}
		int allotBoxNum = 0;
		if(alProjectAllotBoxs != null && alProjectAllotBoxs.size() > 0 && alProjectAllotBoxs.get(0).get("allot_box_num") !=null) {
			String strAllotBoxNum = alProjectAllotBoxs.get(0).get("allot_box_num").toString();
			try {
				allotBoxNum = Integer.parseInt(strAllotBoxNum);	
			}catch(NumberFormatException ne) {
				//
			}
		}
		int oddBoxNum  =  projectBoxNum - allotBoxNum;
		// 验证设置的机箱数是否超出该项目机箱数的范围
		if(allowBoxNum > oddBoxNum) {
			throw new BusinessException("设置项目施工经理错误,分配的机箱数已超出项目应建的机箱数.");
		}
		
		paramMap.clear();
		paramMap.put("id",UUIDGenerator.getUUID());
		paramMap.put("projectId", projectId);
		paramMap.put("userId", userId);
		paramMap.put("allowBoxNum", allowBoxNum);
		paramMap.put("duty", duty);		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-project-addProjectPsn");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramMap);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("设置项目施工经理错误,数据存储异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "在建项目管理", "设置项目施工经理:[" + projectObj.get("project_name").toString() + "].");
	}


	@Override
	public void deleteProjectPsn(String adminUser, String projectId, String userId) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("删除项目施工经理错误,当前操作是未知的用户!");
		}

		if (null == projectId) {
			throw new BusinessException("删除项目施工经理错误,缺少项目ID!");
		}
		if (null == userId) {
			throw new BusinessException("删除项目施工经理错误,缺少用户ID!");
		}
		// 先获取项目
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-project-queryProjectById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("projectId", projectId);
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alProjects;
		try {
			alProjects = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			throw new BusinessException("删除项目施工经理错误,查找对应的项目错误.");
		}
		Map<String, Object> projectObj;
		if (alProjects != null && alProjects.size() > 0) {
			projectObj = alProjects.get(0);
		} else {
			throw new BusinessException("删除项目施工经理错误,未找到对应的项目.");
		}
		
		//判断用户是否提交机箱,已提交机箱则不让删除
		String checkPreSql = ConfigSQLUtil.getCacheSql("mproject-project-getBuildManagerAcceptNum");
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("projectId", projectId);
		paramMap.put("userId", userId);
		String checkSql = ConfigSQLUtil.preProcessSQL(checkPreSql, paramMap);
		boolean existsAcceptBox = false;
		try {
			Map<String, Object> recordMap = springJdbcDao.queryForMap(checkSql);
			if (recordMap != null) {
				int num = Integer.valueOf(recordMap.get("countNum").toString());
				if (num > 1) {
					existsAcceptBox = true;
				}
			}
		} catch (DataAccessException ex) {
			log.info(ex.getMessage());
			throw new BusinessException("删除项目施工经理错误,获取用户提交的机箱数错误.");
		}
		if(existsAcceptBox == true) {
			throw new BusinessException("删除项目施工经理错误,用户已有验收的机箱不能删除.");
		}
		//删除项目经理创建的机箱,相应的提交记录
		String delBoxRecordPreSql = ConfigSQLUtil.getCacheSql("mproject-project-delBoxSubmitRecord");
		String delBoxRecordSql = ConfigSQLUtil.preProcessSQL(delBoxRecordPreSql, paramMap);
		//删除项目经理创建的机箱数
		String delBoxPreSql = ConfigSQLUtil.getCacheSql("mproject-project-delBuildManagerBoxs");
		String delBoxSql = ConfigSQLUtil.preProcessSQL(delBoxPreSql, paramMap);
		//删除项目的施工经理
		String delProjectUserPreSql = ConfigSQLUtil.getCacheSql("mproject-project-deleteProjectPsn");
		String delProjectUserSql = ConfigSQLUtil.preProcessSQL(delProjectUserPreSql, paramMap);
		try {
			springJdbcDao.update(delBoxRecordSql);
			springJdbcDao.update(delBoxSql);
			springJdbcDao.update(delProjectUserSql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("删除项目施工经理错误,数据存储异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "在建项目管理", "删除项目施工经理:[" + projectObj.get("project_name").toString() + "].");
	}

	@Override
	public void updateProjectPsnBoxNum(String curUser, String projectId, String userId,int oldAllowBoxNum,int allowBoxNum) throws BusinessException {
		if (null == curUser) {
			throw new BusinessException("修改施工经理应建机箱数错误,当前操作是未知的用户!");
		}

		if (null == projectId) {
			throw new BusinessException("修改施工经理应建机箱数错误,缺少项目ID!");
		}
		if (null == userId) {
			throw new BusinessException("修改施工经理应建机箱数错误,缺少用户ID!");
		}
		// 先获取项目
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-project-queryProjectById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("projectId", projectId);
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alProjects;
		try {
			alProjects = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			log.info(dae.getMessage());
			throw new BusinessException("修改施工经理应建机箱数错误,查找对应的项目错误.");
		}
		Map<String, Object> projectObj;
		if (alProjects != null && alProjects.size() > 0) {
			projectObj = alProjects.get(0);
		} else {
			throw new BusinessException("修改施工经理应建机箱数错误,未找到对应的项目.");
		}
		
		// 获取项目的应建机箱数
		int projectBoxNum = 0;
		try {
			projectBoxNum = Integer.parseInt(projectObj.get("allow_box_num").toString());			
		}catch(NumberFormatException ne) {
			throw new BusinessException("修改施工经理应建机箱数错误,项目应建机箱数未设置正确.");
		}
		//获取项目已分配(其他施工经理)的机箱数
		String allotBoxNumPreSql = ConfigSQLUtil.getCacheSql("mproject-project-getProjectHadAllotBoxNum");
		Map<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("projectId", projectId);
		String allotBoxNumSql = ConfigSQLUtil.preProcessSQL(allotBoxNumPreSql, paramMap);
		List<Map<String, Object>> alProjectAllotBoxs;
		try {
			alProjectAllotBoxs = springJdbcDao.queryForList(allotBoxNumSql);
		}
		catch (DataAccessException dae) {
			throw new BusinessException("修改施工经理应建机箱数错误,获取项目已分配的机箱数错误.");
		}
		int allotBoxNum = 0;
		if(alProjectAllotBoxs != null && alProjectAllotBoxs.size() > 0 && alProjectAllotBoxs.get(0).get("allot_box_num") !=null) {
			String strAllotBoxNum = alProjectAllotBoxs.get(0).get("allot_box_num").toString();
			try {
				allotBoxNum = Integer.parseInt(strAllotBoxNum);	
			}catch(NumberFormatException ne) {
				log.info(ne.getMessage());
			}
		}
		int oddBoxNum  =  projectBoxNum - allotBoxNum - oldAllowBoxNum;
		// 验证设置的机箱数是否超出该项目机箱数的范围
		if(allowBoxNum > oddBoxNum) {
			throw new BusinessException("修改施工经理应建机箱数错误,分配的机箱数已超出项目应建的机箱数.");
		}
		
		paramMap.clear();
		paramMap.put("projectId", projectId);
		paramMap.put("userId", userId);
		paramMap.put("allowBoxNum", allowBoxNum);
	
		String preSql = ConfigSQLUtil.getCacheSql("mproject-project-updateProjectPsnAllowBoxNum");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramMap);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("修改施工经理应建机箱数错误,数据存储异常.");
		}
	}
	
	@Override
	public void updateProject4Close(String adminUser, String projectId) throws BusinessException {
		//获取项目
		String preSelectSql = ConfigSQLUtil.getCacheSql("mproject-project-queryProjectById");
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("projectId", projectId);
		String selectSql = ConfigSQLUtil.preProcessSQL(preSelectSql, paramsMap);
		List<Map<String, Object>> alProjects;
		try {
			alProjects = springJdbcDao.queryForList(selectSql);
		} catch (DataAccessException dae) {
			log.info(dae.getMessage());
			throw new BusinessException("结束项目,查找对应的项目错误.");
		}
		Map<String, Object> projectObj;
		if (alProjects != null && alProjects.size() > 0) {
			projectObj = alProjects.get(0);
		} else {
			throw new BusinessException("结束项目错误,未找到对应的项目.");
		}
		
		//未处理工单变更为未完成
		String preUpdateJobSql = ConfigSQLUtil.getCacheSql("mproject-project-updateWaitJob4CloseProject");
		paramsMap.clear();
		paramsMap.put("projectId", projectId);
		paramsMap.put("jobDesc", "项目结束-"+adminUser);
		String updateJobSql = ConfigSQLUtil.preProcessSQL(preUpdateJobSql, paramsMap);
		try {
			springJdbcDao.update(updateJobSql);
		} catch (DataAccessException dae) {
			throw new BusinessException("结束项目,关闭项目未处理工单错误.");
		}
		//解除与项目关联的施工经理
		String preDeletePsnSql = ConfigSQLUtil.getCacheSql("mproject-project-deleteProjectPsn4CloseProject");
		paramsMap.clear();
		paramsMap.put("projectId", projectId);
		String deletePsnSql = ConfigSQLUtil.preProcessSQL(preDeletePsnSql, paramsMap);
		try {
			springJdbcDao.update(deletePsnSql);
		} catch (DataAccessException dae) {
			log.info(dae.getMessage());
			throw new BusinessException("结束项目, 解除与项目关联的施工经理数据库访问错误.");
		}
		// 删除施工经理创建的且未提交的机箱信息
		String preDeleteDetectorSql = ConfigSQLUtil.getCacheSql("mproject-project-deleteDetector4CloseProject");
		paramsMap.clear();
		paramsMap.put("projectId", projectId);
		String deleteDetectorSql = ConfigSQLUtil.preProcessSQL(preDeleteDetectorSql, paramsMap);
		
		String preDeleteProcessorSql = ConfigSQLUtil.getCacheSql("mproject-project-deleteProcessor4CloseProject");
		String deleteProcessorSql = ConfigSQLUtil.preProcessSQL(preDeleteProcessorSql, paramsMap);
		
		String preDeleteBoxSql = ConfigSQLUtil.getCacheSql("mproject-project-deleteBox4CloseProject");
		String deleteBoxSql = ConfigSQLUtil.preProcessSQL(preDeleteBoxSql, paramsMap);
		// 变更项目状态
		String preUpdateProjectSql = ConfigSQLUtil.getCacheSql("mproject-project-updateProject4CloseProject");
		String updateProjectSql = ConfigSQLUtil.preProcessSQL(preUpdateProjectSql, paramsMap);
		
		try {		
			springJdbcDao.update(deleteDetectorSql);
			springJdbcDao.update(deleteProcessorSql);
			springJdbcDao.update(deleteBoxSql);
			springJdbcDao.update(updateProjectSql);
		} catch (DataAccessException dae) {
			log.info(dae.getMessage());
			throw new BusinessException("结束项目, 删除项目下未提交的机箱信息,访问数据库错误.");
		}
	}
}
