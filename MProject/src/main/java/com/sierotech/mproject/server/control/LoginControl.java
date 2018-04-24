package com.sierotech.mproject.server.control;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ConfigSQLUtil;
import com.sierotech.mproject.common.utils.ControllerUtils;
import com.sierotech.mproject.server.service.CommonService;
import com.sierotech.mproject.server.service.ILoginService;
import com.sierotech.mproject.server.service.impl.LoginServiceImpl;

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
	static final Logger log = LoggerFactory.getLogger(LoginControl.class);
	
	@Autowired
	private ILoginService loginService;

	@Autowired
	private CommonService commonService;

	@RequestMapping(value = "/login")
	@ResponseBody
	public Map<String, Object> login(HttpServletRequest request) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("returnCode", "fail");
		Map userObj = ControllerUtils.toMap(request);
		if (null == userObj.get("userName")) {
			result.put("msg", "用户登录参数错误,缺少用户名.");
			return result;
		}
		if (null == userObj.get("fullName")) {
			result.put("msg", "用户登录参数错误,缺少用户姓名.");
			return result;
		}
		if (null == userObj.get("password")) {
			result.put("msg", "用户登录参数错误,缺少登录密码.");
			return result;
		}
		Map<String, Object> loginUser = null;
		try {
			loginUser = loginService.doLogin(userObj);
		} catch (BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		// 用户信息放入会话信息中
		if (loginUser != null) {
			// 获取用户当前项目
			if ("B".equals(loginUser.get("role_type")) || "E".equals(loginUser.get("role_type"))) {
				// 针对施工经理、系统工程师, 设置用户当前项目
				String sqlId = "";
				if ("E".equals(loginUser.get("role_type"))) {
					sqlId = "mproject-project-getEngineerUserProjects";
				}
				if ("B".equals(loginUser.get("role_type"))) {
					sqlId = "mproject-project-getManagerUserProjects";
				}
				Map<String, String> paramMap = new HashMap<String, String>();
				paramMap.put("userId", loginUser.get("id").toString());
				
				List<Map<String, Object>> userProjects = commonService.queryForList(sqlId, paramMap);
				if (userProjects != null && userProjects.size() > 0) {
					Map<String, Object> curProject = userProjects.get(0);
					request.getSession().setAttribute("curProjectId", curProject.get("id").toString());
				}
			}
			request.getSession().setAttribute("loginUser", loginUser);
			result.put("loginUser", loginUser.toString());
			result.put("returnCode", "success");
		} else {
			result.put("msg", "登录失败.");
		}

		return result;
	}

	@RequestMapping(value = "/logout")
	@ResponseBody
	public String logout(HttpServletRequest request) {
		try {
			String returnPage = "/system/login/login.jsp";
			request.getSession().invalidate();
			return returnPage;
		} catch (Exception ex) {
		}
		return null;
	}
	
	@RequestMapping(value = "/changeCurProject")
	@ResponseBody
	public Map<String, Object> setUserCurProject(HttpServletRequest request) {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("returnCode", "fail");
		try {
			String curProjectId = request.getParameter("projectId");
			if(curProjectId != null) {
				request.getSession().setAttribute("curProjectId", curProjectId);
				result.put("returnCode", "success");
			}
		} catch (Exception ex) {
		}
		return result;
	}
}
