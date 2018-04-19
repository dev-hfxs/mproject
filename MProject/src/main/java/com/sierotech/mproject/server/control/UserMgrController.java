/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月17日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.control;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ControllerUtils;
import com.sierotech.mproject.common.utils.UserTool;
import com.sierotech.mproject.server.service.IUserService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月17日
* @功能描述: 用户管理控制层处理
 */
@Controller
@RequestMapping("/user/mgr/")
@Scope("request")
public class UserMgrController {
	
	@Autowired
	IUserService userService;
	
	@RequestMapping(value = "/checkUser")
	@ResponseBody
	public Map<String, String> checkUser(HttpServletRequest request) {
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		String msg = "";
		String userId = request.getParameter("id");
		if(userId == null) {
			result.put("msg", "用户名验证参数错误,缺少用户ID.");
			return result;
		}
		String userName = request.getParameter("userName");
		if(userName == null) {
			result.put("msg", "用户名验证参数错误,缺少用户名.");
			return result;
		}
		boolean userExist = true;
		try {
			userExist = userService.checkUserExist(userId, userName);
		}catch(BusinessException be) {
			msg = be.getMessage();
		}
		if (userExist) {
			result.put("userExist", "true");
		}else {
			result.put("userExist", "false");
		}
		result.put("returnCode", "success");
		result.put("msg", msg);
		return result;
	}
	
	@RequestMapping(value = "/add")
	@ResponseBody
	public Map<String, String> addUser(HttpServletRequest request) {
		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map userObj = ControllerUtils.toMap(request);
		if(null == userObj.get("userName")) {
			result.put("msg", "添加用户参数错误,缺少用户名.");
			return result;
		}
		if(null == userObj.get("fullName")) {
			result.put("msg", "添加用户参数错误,缺少用户姓名.");
			return result;
		}
		if(null == userObj.get("idNumber")) {
			result.put("msg", "添加用户参数错误,缺少身份证号.");
			return result;
		}
		if(null == userObj.get("orgId")) {
			result.put("msg", "添加用户参数错误,缺少用户单位.");
			return result;
		}
		if(null == userObj.get("roleId")) {
			result.put("msg", "添加用户参数错误,缺少用户类型.");
			return result;
		}
		if(null == userObj.get("contactNumber")) {
			result.put("msg", "添加用户参数错误,缺少用户联系电话.");
			return result;
		}
		String sex = request.getParameter("sex");
		String birthday = request.getParameter("birthday");
		try {
			userService.addUser(UserTool.getLoginUser(request).get("user_name"), userObj);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/update")
	@ResponseBody
	public Map<String, String> updateUser(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map userObj = ControllerUtils.toMap(request);
		
		if(null == userObj.get("id")) {
			result.put("msg", "修改用户参数错误,缺少用户ID.");
			return result;
		}
		if(null == userObj.get("userName")) {
			result.put("msg", "修改用户参数错误,缺少用户名.");
			return result;
		}
		if(null == userObj.get("fullName")) {
			result.put("msg", "修改用户参数错误,缺少用户姓名.");
			return result;
		}
		if(null == userObj.get("idNumber")) {
			result.put("msg", "修改用户参数错误,缺少身份证号.");
			return result;
		}
		if(null == userObj.get("orgId")) {
			result.put("msg", "修改用户参数错误,缺少用户单位.");
			return result;
		}
		if(null == userObj.get("roleId")) {
			result.put("msg", "修改用户参数错误,缺少用户类型.");
			return result;
		}
		if(null == userObj.get("contactNumber")) {
			result.put("msg", "修改用户参数错误,缺少用户联系电话.");
			return result;
		}
		String sex = request.getParameter("sex");
		String birthday = request.getParameter("birthday");
		
		try {
			userService.updateUser(UserTool.getLoginUser(request).get("user_name"), userObj);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/pwd/reset")
	@ResponseBody
	public Map<String, String> resetPwd(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map userObj = ControllerUtils.toMap(request);
		
		if(null == userObj.get("id")) {
			result.put("msg", "重置用户密码错误,缺少用户ID.");
			return result;
		}
		
		try {
			userService.updateUserPwd(UserTool.getLoginUser(request).get("user_name"), userObj.get("id").toString());
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/pwd/change")
	@ResponseBody
	public Map<String, String> changePwd(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map userObj = ControllerUtils.toMap(request);
		
		if(null == userObj.get("id")) {
			result.put("msg", "用户密码修改错误,缺少用户ID.");
			return result;
		}
		String userId = userObj.get("id").toString();
		if(null == userObj.get("oldPwd")) {
			result.put("msg", "用户密码修改错误,缺少原密码.");
			return result;
		}
		String oldPwd = userObj.get("oldPwd").toString();
		if(null == userObj.get("newPwd")) {
			result.put("msg", "用户密码修改错误,缺少新密码.");
			return result;
		}
		String newPwd = userObj.get("newPwd").toString();
		try {
			userService.updateUserPwd(userId, oldPwd, newPwd);
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		if(request.getSession().getAttribute("loginUser") != null) {
			Map<String,String> loginUser = (Map<String,String>)request.getSession().getAttribute("loginUser");
			loginUser.put("init_password", "N");
			request.getSession().setAttribute("loginUser",loginUser);
		}else {
			result.put("msg", "会话已失效.");
			result.put("returnCode", "fail");
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/delete")
	@ResponseBody
	public Map<String, String> deleteUser(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map userObj = ControllerUtils.toMap(request);
		
		if(null == userObj.get("id")) {
			result.put("msg", "删除用户错误,缺少用户ID.");
			return result;
		}
		try {
			userService.deleteUser(UserTool.getLoginUser(request).get("user_name"), userObj.get("id").toString());
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
	
	@RequestMapping(value = "/recover")
	@ResponseBody
	public Map<String, String> recoverUser(HttpServletRequest request) {		
		Map<String, String> result = new HashMap<String, String>();
		result.put("returnCode", "fail");
		Map userObj = ControllerUtils.toMap(request);
		
		if(null == userObj.get("id")) {
			result.put("msg", "恢复用户错误,缺少用户ID.");
			return result;
		}
		try {
			userService.recoverUser(UserTool.getLoginUser(request).get("user_name"), userObj.get("id").toString());
		}catch(BusinessException be) {
			result.put("msg", be.getMessage());
			return result;
		}
		
		result.put("returnCode", "success");
		result.put("msg", "");
		return result;
	}
}
