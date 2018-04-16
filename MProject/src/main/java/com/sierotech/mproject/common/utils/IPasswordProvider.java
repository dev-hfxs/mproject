/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.common.utils;

/**
 * @JDK版本: 1.7
 * @创建人: lwm
 * @创建日期：2018年4月15日
 * @功能描述: 密码加密、密码验证接口
 */
public interface IPasswordProvider {
	public String encrypt(String pwd);

	public boolean validPassword(String password, String encryptValue);
}
