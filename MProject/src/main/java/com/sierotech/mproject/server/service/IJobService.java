/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月24日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service;

import java.util.List;
import java.util.Map;

import com.sierotech.mproject.common.BusinessException;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月24日
* @功能描述: 工单管理接口
 */
public interface IJobService {
	public void addJob(String adminUser,Map<String,Object> jobObj) throws BusinessException;
	
	public void updateJob(String jobId, String jobStatus, String jobDesc);
	
	public void updateJob(String curUser, String jobId, String jobStatus, String jobDesc, String boxPos,Map<String,String> installOptions, List<Map> detectorPosList);
	
	public void updateJob(String curUser, String jobId, String jobStatus, String jobDesc, List<Map> processIpList,  List<Map> configInfoList,  List<Map> detectorInfoList, Map<String, String> debugOptionMap);
	
	public void updateJob4Revoke(String adminUser, String jobId) throws BusinessException;
	
}
