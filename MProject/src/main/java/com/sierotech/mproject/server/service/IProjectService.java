/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月20日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service;

import java.util.Map;

import com.sierotech.mproject.common.BusinessException;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月20日
* @功能描述: 
 */
public interface IProjectService {
	public boolean checkProjectName(String projectId, String projectName) throws BusinessException;
	
	public void addProject(String adminUser,Map<String,Object> projectObj) throws BusinessException;
	
	public void updateProject(String adminUser,Map<String,Object> projectObj) throws BusinessException;
	
	public void updateStatus(String adminUser,String projectId,String oldStatus,String newStatus) throws BusinessException;
	
	public void addProjectPsn(String adminUser,String projectId,String userId,int allowBoxNum,String duty) throws BusinessException;
	
	public void deleteProjectPsn(String adminUser,String projectId,String userId) throws BusinessException;
	
	public void updateProjectPsnBoxNum(String curUser,String projectId,String userId,int oldAllowBoxNum, int allowBoxNum) throws BusinessException;
	
}
