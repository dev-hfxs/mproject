/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月11日
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
* @创建日期：2018年5月11日
* @功能描述: 
 */
public interface IPService {
	public void addIP(String adminUser,Map<String,Object> ipObj) throws BusinessException;
	
	public void updateIP(String adminUser,Map<String,Object> ipObj) throws BusinessException;
	
	public void deleteIP(String adminUser, String ipID) throws BusinessException;
	
	public void updateStatus(String userId, String ipID, String status) throws BusinessException;
	
	public void update4ImportIp(String projectId, List<Map<String, String>> datas)	throws BusinessException;
	
}
