package com.sierotech.mproject.server.service;

import java.util.Map;

import com.sierotech.mproject.common.BusinessException;

public interface ILoginService {
	//
	public Map doLogin(String userNo, String password) throws BusinessException;

}
