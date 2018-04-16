/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.common.utils;

import java.util.UUID;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: 唯一ID生成
 */
public class UUIDGenerator {
	/**
	 * get uuid;
	 * 
	 * @return
	 */
	public static String getUUID() {
		UUID uuid = UUID.randomUUID();
		String uuidStr = uuid.toString();
		return uuidStr.replace("-", "");
	}

	public static void main(String[] args) {
		for (int i = 0; i < 10; i++) {
			System.out.println(getUUID());
		}

	}
}
