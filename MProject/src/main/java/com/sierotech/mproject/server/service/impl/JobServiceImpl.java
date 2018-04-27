/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月24日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service.impl;

import java.io.File;
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
import com.sierotech.mproject.context.AppContext;
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

	/*
	 * 未完成，问题工单处理
	 * 
	 * */
	@Override
	public void updateJob(String jobId, String jobStatus, String jobDesc) {
		if(null == jobId) {
			throw new BusinessException("工单处理错误,缺少工单ID.");
		}
		if(null == jobStatus) {
			throw new BusinessException("工单处理错误,缺少工单状态.");			
		}
		if(null == jobDesc) {
			throw new BusinessException("工单处理错误,缺少工单描述.");			
		}
		
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("jobId", jobId);
		paramsMap.put("status", jobStatus);
		paramsMap.put("jobDesc", jobDesc);
		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-job-updateJobStatus");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramsMap);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("工单处理错误,访问数据库异常.");
		}
	}


	/*
	 *安装工单完成处理
	 * 
	 * */
	@Override
	public void updateJob(String jobId, String jobStatus, String jobDesc, String boxPos, Map<String, String> installOptionMap, List<Map> processIpList, List<Map> detectorPosList) {
		if(null == jobId) {
			throw new BusinessException("处理安装工单错误,缺少工单ID.");
		}
		if(null == jobStatus) {
			throw new BusinessException("处理安装工单错误,缺少工单状态.");			
		}
		
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("jobId", jobId);
		paramsMap.put("status", jobStatus);
		paramsMap.put("jobDesc", "");		
		String preSql = ConfigSQLUtil.getCacheSql("mproject-job-updateJobStatus");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramsMap);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("处理安装工单错误,访问数据库异常.");
		}
		//更新处理器IP
		if(processIpList != null && processIpList.size() > 0) {
			String updateProcessIpPreSql = ConfigSQLUtil.getCacheSql("mproject-job-updateProcessorIpById");
			StringBuffer batchSql = new StringBuffer();
			for(Map processIpMap : processIpList) {
				paramsMap.clear();
				paramsMap.put("processorId", processIpMap.get("id"));
				paramsMap.put("ip", processIpMap.get("id"));
				String updateProcessIpSql = ConfigSQLUtil.preProcessSQL(updateProcessIpPreSql, paramsMap);
				batchSql.append(updateProcessIpSql).append(";\n");
			}
			if(batchSql.length() > 0 ) {
				try {
					// springJdbcDao.update(batchSql.toString());
					springJdbcDao.batchUpdate(batchSql.toString().split("\n"));
				} catch (DataAccessException dae) {
					log.info(dae.toString());
					throw new BusinessException("处理安装工单错误,更新处理器IP错误.");
				}
			}
		}
		//更新探测器位置描述
		if(detectorPosList != null && detectorPosList.size() > 0) {
			String updateDetectorPreSql = ConfigSQLUtil.getCacheSql("mproject-job-updateDetectorPosById");
			StringBuffer batchSql = new StringBuffer();
			for(Map detectorPosMap : detectorPosList) {
				paramsMap.clear();
				paramsMap.put("detectorId", detectorPosMap.get("id"));
				paramsMap.put("posDesc", detectorPosMap.get("posDesc"));
				String updateDetectorSql = ConfigSQLUtil.preProcessSQL(updateDetectorPreSql, paramsMap);
				batchSql.append(updateDetectorSql).append(";\n");
			}
			if(batchSql.length() > 0 ) {
				try {
					springJdbcDao.batchUpdate(batchSql.toString().split("\n"));
				} catch (DataAccessException dae) {
					log.info(dae.toString());
					throw new BusinessException("处理安装工单错误,更新探测器位置错误.");
				}
			}
		}
		//更新安装选项
		if(installOptionMap != null && installOptionMap.size() > 0) {
			String deleteInstallOptionPreSql = ConfigSQLUtil.getCacheSql("mproject-job-deleteInstallOptionByJobId");
			String updateInstallOptionPreSql = ConfigSQLUtil.getCacheSql("mproject-job-addInstallOption");
			paramsMap.clear();
			paramsMap.put("jobId", jobId);
			String deleteInstallOptionSql =  ConfigSQLUtil.preProcessSQL(deleteInstallOptionPreSql, paramsMap);
			StringBuffer batchSql = new StringBuffer();
			batchSql.append(deleteInstallOptionSql).append(";\n");
			
			for(String key : installOptionMap.keySet()) {
				paramsMap.clear();
				paramsMap.put("id", UUIDGenerator.getUUID());
				paramsMap.put("jobId", jobId);
				paramsMap.put("optionName", key);
				paramsMap.put("optionValue", installOptionMap.get(key));
				String updateInstallOptionSql = ConfigSQLUtil.preProcessSQL(updateInstallOptionPreSql, paramsMap);
				batchSql.append(updateInstallOptionSql).append(";\n");
			}
			if(batchSql.length() > 0 ) {
				try {
					springJdbcDao.batchUpdate(batchSql.toString().split("\n"));
				} catch (DataAccessException dae) {
					log.info(dae.toString());
					throw new BusinessException("处理安装工单错误,更新探测器位置错误.");
				}
			}
		}		
	}

	/*
	 * 调试工单完成处理
	 * 
	 * */
	@Override
	public void updateJob(String jobId, String jobStatus, String jobDesc,  List<Map> configInfoList,  List<Map> detectorInfoList) {
		
		if(null == jobId) {
			throw new BusinessException("处理调试工单错误,缺少工单ID.");
		}
		if(null == jobStatus) {
			throw new BusinessException("处理调试工单错误,缺少工单状态.");			
		}
		
		Map<String, Object> paramsMap = new HashMap<String, Object>();
		paramsMap.put("jobId", jobId);
		paramsMap.put("status", jobStatus);
		paramsMap.put("jobDesc", "");
		String preSql = ConfigSQLUtil.getCacheSql("mproject-job-updateJobStatus");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, paramsMap);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("处理调试工单错误,访问数据库异常.");
		}
		
		StringBuffer batchSql = new StringBuffer();
		String tempUploadDir = AppContext.getUploadTempDir();
		String uploadDir = AppContext.getUploadDir();
		String curDate = DateUtils.getNow(DateUtils.FORMAT_SHORT);
		
		// 更新处理器配置文件、探测器信息
		if(configInfoList!=null && configInfoList.size() > 0) {
			String updateConfigPreSql = ConfigSQLUtil.getCacheSql("mproject-job-updateProcessConfigById");
			for(Map configInfoMap : configInfoList) {
				String id = configInfoMap.get("id").toString();
				String fileName = configInfoMap.get("fileName").toString();
				
				//移动文件
				String tempFileName = tempUploadDir + File.separator + "configfile_" + id + "_" +  fileName;
				String newFileName = uploadDir + File.separator + curDate + File.separator + "configfile_" + id + "_" +  fileName;
				String configFilePath = File.separator + curDate + File.separator + "configfile_" + id + "_" +  fileName;
				File tempFile = new File(tempFileName);
				File newFile = new File(newFileName);
				// 判断目标路径是否存在，如果不存在就创建一个
				if (!newFile.getParentFile().exists()) {
					newFile.getParentFile().mkdirs();
					
				}
				if(tempFile.exists()) {
					tempFile.renameTo(newFile);
				}
				// 生成修改的 sql
				paramsMap.clear();
				paramsMap.put("processorId", id);
				paramsMap.put("configFile", configFilePath);
				String updateConfigSql = ConfigSQLUtil.preProcessSQL(updateConfigPreSql, paramsMap);
				batchSql.append(updateConfigSql).append(";\n");				
			}
		}
		if(detectorInfoList!=null && detectorInfoList.size() > 0) {
			String updateDetectorPreSql = ConfigSQLUtil.getCacheSql("mproject-job-updateProcessDetectorFileById");
			for(Map detectorInfoMap : detectorInfoList) {
				String id = detectorInfoMap.get("id").toString();
				String fileName = detectorInfoMap.get("fileName").toString();				
				//移动文件
				String tempFileName = tempUploadDir + File.separator + "detectorfile_" + id + "_" +  fileName;
				String newFileName = uploadDir + File.separator + curDate + File.separator + "configfile_" + id + "_" +  fileName;
				String configFilePath = File.separator + curDate + File.separator + "detectorfile_" + id + "_" +  fileName;
				File tempFile = new File(tempFileName);
				File newFile = new File(newFileName);
				// 判断目标路径是否存在，如果不存在就创建一个
				if (!newFile.getParentFile().exists()) {
					newFile.getParentFile().mkdirs();
				}
				if(tempFile.exists()) {
					tempFile.renameTo(newFile);
				}
				// 生成修改的 sql
				paramsMap.clear();
				paramsMap.put("processorId", id);
				paramsMap.put("detectorFile", configFilePath);
				String updateDetectorSql = ConfigSQLUtil.preProcessSQL(updateDetectorPreSql, paramsMap);
				batchSql.append(updateDetectorSql).append(";\n");
			}
		}
		if(batchSql.length() > 0 ) {
			try {
				springJdbcDao.batchUpdate(batchSql.toString().split("\n"));
			} catch (DataAccessException dae) {
				log.info(dae.toString());
				throw new BusinessException("处理调试工单错误,更新处理器配置、探测器信息附件错误.");
			}
		}		
	}
}
