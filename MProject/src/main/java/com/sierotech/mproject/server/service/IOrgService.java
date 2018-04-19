/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月19日
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
* @创建日期：2018年4月19日
* @功能描述: 
 */
public interface IOrgService {
	public boolean checkOrgExist(String orgId, String orgName) throws BusinessException;
	
	public void addOrg(String adminUser,Map<String,Object> orgObj) throws BusinessException;
	
	public void updateOrg(String adminUser,Map<String,Object> orgObj) throws BusinessException;
	
	public void deleteOrg(String adminUser,String orgId) throws BusinessException;
	
	public void recoverOrg(String adminUser,String orgId) throws BusinessException;
}
