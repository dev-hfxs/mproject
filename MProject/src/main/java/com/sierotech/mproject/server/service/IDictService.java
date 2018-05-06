/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月5日
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
* @创建日期：2018年5月5日
* @功能描述: 
 */
public interface IDictService {
	public void update4ImportCode(String curUser,String dataName, List<Map<String,String>> datas) throws BusinessException;
	
	public Map<String,Object> queryNfcDataByCode(String dataName, String code)  throws BusinessException;
	
	public boolean checkNfcCodeUsed(String dataName, String code, String dataId) throws BusinessException;
	
}
