/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月5日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.common.utils.ConfigSQLUtil;
import com.sierotech.mproject.common.utils.DateUtils;
import com.sierotech.mproject.common.utils.EmailUtil;
import com.sierotech.mproject.common.utils.UUIDGenerator;
import com.sierotech.mproject.common.utils.VerifyCodeUtils;
import com.sierotech.mproject.server.service.IQueryService;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月5日
* @功能描述: 
 */
@Service
public class QueryServiceImpl implements IQueryService{

	static final Logger log = LoggerFactory.getLogger(QueryServiceImpl.class);

	@Autowired
	private JdbcTemplate springJdbcDao;

	@Override
	public void createCode(String curUser, Map<String, Object> codeObj) throws BusinessException {
		if (null == codeObj.get("projectId")) {
			throw new BusinessException("生成验证码错误, 缺少有效项目ID!");
		}
		if (null == codeObj.get("targetUser")) {
			throw new BusinessException("生成验证码错误, 缺少验证码使用用户!");
		}
		if (null == codeObj.get("codeType")) {
			throw new BusinessException("生成验证码错误, 缺少验证码类型!");
		}		
		if (null == codeObj.get("validTime")) {
			throw new BusinessException("生成验证码错误, 缺少有效时长!");
		}
		//获取用户
		Map<String, Object> userObj = null;
		String getUserPreSql = ConfigSQLUtil.getCacheSql("mproject-user-getUserById");
		Map<String,Object> paramMap = new HashMap<String, Object>();
		paramMap.put("userId", codeObj.get("targetUser"));
		
		String getUserSql = ConfigSQLUtil.preProcessSQL(getUserPreSql, paramMap);
		try {
			userObj = springJdbcDao.queryForMap(getUserSql);
		}catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("生成验证码错误, 未找到使用验证码的目标用户.");
		}
		if(userObj == null) {
			throw new BusinessException("生成验证码错误, 未找到使用验证码的目标用户.");
		}
		//获取项目
		Map<String, Object> projectObj = null;
		String getProjectPreSql = ConfigSQLUtil.getCacheSql("mproject-project-queryProjectById");
		paramMap.clear();
		paramMap.put("projectId", codeObj.get("projectId"));
		String getProjectSql = ConfigSQLUtil.preProcessSQL(getProjectPreSql, paramMap);
		try {
			projectObj = springJdbcDao.queryForMap(getProjectSql);
		}catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("生成验证码错误, 未找到验证码的有效项目.");
		}
		if(projectObj == null) {
			throw new BusinessException("生成验证码错误, 未找到验证码的有效项目.");
		}
		//生成验证码
		String verifyCode = VerifyCodeUtils.generateVerifyCode(8);
		
		//存储验证码
		String curDate = DateUtils.getNow(DateUtils.FORMAT_LONG);
		String codeId = UUIDGenerator.getUUID();
		codeObj.put("codeId", codeId);
		codeObj.put("codeValue", verifyCode);
		codeObj.put("creator", curUser);
		codeObj.put("createDate", curDate);
		String preSql = ConfigSQLUtil.getCacheSql("mproject-query-addcode");
		String sql = ConfigSQLUtil.preProcessSQL(preSql, codeObj);
		try {
			springJdbcDao.update(sql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
			throw new BusinessException("生成验证码错误, 验证码存储失败.");
		}
		//发送验证码邮件给用户
		String emailAddress = userObj.get("user_name").toString();
		String projectName = projectObj.get("project_name").toString();
		String emailTitle = "项目管理系统验证码";
		StringBuffer emailContent = new StringBuffer();
		emailContent.append(userObj.get("full_name")).append(":<br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;您好！<br>");
		emailContent.append("&nbsp;&nbsp;验证码：").append(verifyCode).append("<br>");
		if("Q".equals(codeObj.get("codeType").toString())){
			emailContent.append("&nbsp;&nbsp;验证码类型：查询<br>");
		}else if("U".equals(codeObj.get("codeType").toString())){
			emailContent.append("&nbsp;&nbsp;验证码类型：修改<br>");
		}
		emailContent.append("&nbsp;&nbsp;有效项目：").append(projectName).append("<br>") ;
		emailContent.append("&nbsp;&nbsp;有效时长(小时):").append(codeObj.get("validTime")).append("<br>");
		emailContent.append("&nbsp;&nbsp;生效时间: ").append(curDate).append("<br><br>");
		emailContent.append("&nbsp;&nbsp;邮件来自：天津航峰希萨科技有限责任公司");
		EmailUtil.sendTextMail(emailAddress, emailTitle, emailContent.toString());
	}
}
