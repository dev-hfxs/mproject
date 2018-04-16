package com.sierotech.mproject.server.control;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sierotech.mproject.server.service.ILoginService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: 登录、登出请求响应类
 */
@Controller
@RequestMapping("/auth")
@Scope("request")
public class LoginControl {
	@Autowired
	private ILoginService loginService;

	@RequestMapping(value = "/login")
	@ResponseBody
	public Map<String, String> login(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		loginService.doLogin("", "");
		result.put("returnCode", "0");
		// result.put("loginRetCode", loginUser.getLoginStatus());
		return result;
	}
}
