/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月24日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service.impl;

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
import com.sierotech.mproject.server.service.IJobService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月24日
* @功能描述: 
 */
@Service
public class JobServiceImpl implements IJobService {
	
	static final Logger log = LoggerFactory.getLogger(JobServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;

	
	@Override
	public void addJob(String adminUser, Map<String, Object> jobObj) throws BusinessException {
		if (null == adminUser) {
			throw new BusinessException("发布工单错误,当前操作是未知的管理员!");
		}

		if(null == jobObj.get("projectId")) {
			throw new BusinessException("发布工单错误,缺少项目ID.");
		}
		if(null == jobObj.get("machineBoxId")) {
			throw new BusinessException("发布工单错误,缺少机箱ID.");			
		}
		if(null == jobObj.get("jobType")) {
			throw new BusinessException("发布工单错误,缺少工单类型.");			
		}
		
		if(null == jobObj.get("processPerson")) {
			throw new BusinessException("发布工单错误,缺少工单处理人.");			
		}
		if(null == jobObj.get("workContent")) {
			throw new BusinessException("发布工单错误,缺少工单工作内容.");			
		}
		
		String jobId = UUIDGenerator.getUUID();
		
		jobObj.put("status", "I");
		jobObj.put("jobId", jobId);
		jobObj.put("creator", adminUser);
		jobObj.put("createDate", DateUtils.getNow(DateUtils.FORMAT_LONG));
		String preSql = ConfigSQLUtil.getCacheSql("mproject-job-addJob");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, jobObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("发布工单错误,访问数据库异常.");
		}
		// 记录日志
		LogOperationUtil.logAdminOperation(adminUser, "工单管理", "发布工单:工单类型" + jobObj.get("jobType").toString() + ";工单处理人:"+jobObj.get("processPerson").toString());
	}

}
