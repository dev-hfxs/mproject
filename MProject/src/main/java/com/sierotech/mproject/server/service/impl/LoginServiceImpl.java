/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.server.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.hfxs.test.TestExcel;
import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ConfigSQLUtil;
import com.sierotech.mproject.common.utils.PasswordUtil;
import com.sierotech.mproject.server.service.ILoginService;

/**
 * @JDK版本: 1.7
 * @创建人: lwm
 * @创建日期：2018年4月15日 @功能描述: 登录处理的服务类
 */
@Service
public class LoginServiceImpl implements ILoginService {
	static final Logger log = LoggerFactory.getLogger(LoginServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;

	@Override
	public Map doLogin(Map<String,Object> userObj) throws BusinessException {
		
		if (null == userObj) {
			throw new BusinessException("登录参数为空.");
		}
		// 获取用户
		Map<String, Object> loginUser = null;
		String preSql = ConfigSQLUtil.getCacheSql("mproject-login-getUserByUserName");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, userObj);
		
		List<Map<String,Object>> alUser = springJdbcDao.queryForList(sql);
		if(alUser!=null && alUser.size()> 0) {
			loginUser = alUser.get(0);
		}
		
		if (null == loginUser) {
			throw new BusinessException("用户不存在.");
		}
		if ("D".equals(loginUser.get("status").toString())) {
			throw new BusinessException("用户已被禁用.");
		}
		if(!userObj.get("fullName").toString().equals(loginUser.get("full_name").toString())){
			throw new BusinessException("用户姓名不正确.");
		}
		if (!PasswordUtil.validPassword(userObj.get("password").toString(),loginUser.get("password").toString())){
			throw new BusinessException("用户密码不正确.");
		}
		//判断是不是施工经理
		if("B".equals(loginUser.get("role_type"))) {
			//再判断是否有在建的项目
			preSql = ConfigSQLUtil.getCacheSql("mproject-user-getUserProjects");
			Map<String,Object> paramsMap = new HashMap<String,Object>();
			paramsMap.put("userId", loginUser.get("id").toString());
			sql = ConfigSQLUtil.preProcessSQL(preSql,paramsMap);
			List<Map<String, Object>> userProjects = springJdbcDao.queryForList(sql);
			if(userProjects == null || userProjects.size() < 1) {
				throw new BusinessException("用户没有关联项目暂不能登录.");
			}
		}
		//验证通过 返回loginUser
		return loginUser;
	}

}
