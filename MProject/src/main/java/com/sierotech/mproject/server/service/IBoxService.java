/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月27日
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
* @创建日期：2018年4月27日
* @功能描述: 机箱管理接口
 */
public interface IBoxService {
	public boolean checkBoxNumber(String boxId, String boxNumber) throws BusinessException;
	
	public void addBox(String curUser, Map<String,Object> boxObj) throws BusinessException;
	
	public void deleteBox(String curUser, String boxId) throws BusinessException;
	
	public void updateBox4Submit(String curUser, String boxId) throws BusinessException;
	
	public void updateBox4Edit(String curUser, String boxId) throws BusinessException;
	
	public void updateBox4Accept(String curUser, String boxId) throws BusinessException;
	
}
