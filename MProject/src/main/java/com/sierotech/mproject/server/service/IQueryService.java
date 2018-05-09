/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月5日
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
* @创建日期：2018年5月5日
* @功能描述: 
 */
public interface IQueryService {
	
	public void createCode(String curUser, Map<String,Object> codeObj) throws BusinessException;
	
	public Map<String,Object> queryInfo(String codeUser, String queryType, String queryValue, String codeValue ) throws BusinessException;
	
}
