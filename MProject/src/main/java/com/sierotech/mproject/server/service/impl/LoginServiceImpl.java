/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.server.service.impl;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.server.service.ILoginService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: 登录处理的服务类
 */
@Service
public class LoginServiceImpl implements ILoginService {

	@Autowired
	private JdbcTemplate springJdbc;

	@Override
	public Map doLogin(String userNo, String password) throws BusinessException {

		// springJdbc.update("insert into t_test(id,uname)
		// values('us12311','zhangsan')");

		return null;
	}

}
