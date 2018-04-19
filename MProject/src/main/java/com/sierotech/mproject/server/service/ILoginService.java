package com.sierotech.mproject.server.service;

import java.util.Map;

import com.sierotech.mproject.common.BusinessException;

public interface ILoginService {
	//
	public Map doLogin(Map<String,Object> userObj) throws BusinessException;
	
}
