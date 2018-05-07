/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月30日
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
* @创建日期：2018年4月30日
* @功能描述: 
 */
public interface IDetectorService {
	public void addDetector(String curUser, Map<String,Object> detectorObj) throws BusinessException;
	
	public void updateDetector(String curUser, Map<String,Object> detectorObj) throws BusinessException;
	
	public void deleteDetector(String curUser, String id) throws BusinessException;
	
	public void deleteDetectorByProcessorId(String curUser, String processorId) throws BusinessException;
	
	public void update4ImportDetector(String curUser,String processorId, boolean ignoreExistsData, boolean enableReplace, List<Map<String,String>> datas) throws BusinessException;
	
}
