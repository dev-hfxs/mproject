/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月24日
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
* @创建日期：2018年4月24日
* @功能描述: 工单管理接口
 */
public interface IJobService {
	public void addJob(String adminUser,Map<String,Object> jobObj) throws BusinessException;
}