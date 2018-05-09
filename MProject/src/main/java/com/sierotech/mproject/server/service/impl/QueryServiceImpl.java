/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月5日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.server.service.impl;

import java.util.Date;
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
		if("P".equals(codeObj.get("codeType").toString())){
			emailContent.append("&nbsp;&nbsp;验证码功能：项目查询<br>");
		}if("M".equals(codeObj.get("codeType").toString())){
			emailContent.append("&nbsp;&nbsp;验证码功能：机箱查询<br>");
		}if("C".equals(codeObj.get("codeType").toString())){
			emailContent.append("&nbsp;&nbsp;验证码功能：处理器查询<br>");
		}if("D".equals(codeObj.get("codeType").toString())){
			emailContent.append("&nbsp;&nbsp;验证码功能：探测器查询<br>");
		}else if("U".equals(codeObj.get("codeType").toString())){
			emailContent.append("&nbsp;&nbsp;验证码功能：信息修改<br>");
		}
		emailContent.append("&nbsp;&nbsp;有效项目：").append(projectName).append("<br>") ;
		emailContent.append("&nbsp;&nbsp;有效时长(小时):").append(codeObj.get("validTime")).append("<br>");
		emailContent.append("&nbsp;&nbsp;生效时间: ").append(curDate).append("<br><br>");
		emailContent.append("&nbsp;&nbsp;邮件来自：天津航峰希萨科技有限责任公司");
		EmailUtil.sendTextMail(emailAddress, emailTitle, emailContent.toString());
	}


	@Override
	public Map<String, Object> queryInfo(String codeUser, String queryType, String queryValue, String codeValue)
			throws BusinessException {
		if(queryType == null) {
			throw new BusinessException("信息查询错误, 未指定查询的项目.");
		}
		//查询验证码
		Map<String, Object> verCodeMap = null;
		Map<String,Object> paramMap = new HashMap<String, Object>();
		String getVerCodePreSql = ConfigSQLUtil.getCacheSql("mproject-query-getCodeByCodeValue");
		paramMap.clear();
		paramMap.put("codeValue", codeValue);
		paramMap.put("targetUser", codeUser);
		String getVerCodeSql = ConfigSQLUtil.preProcessSQL(getVerCodePreSql, paramMap);
		try {
			verCodeMap = springJdbcDao.queryForMap(getVerCodeSql);
		}catch (DataAccessException dae) {
			throw new BusinessException("信息查询错误, 获取验证码错误.");
		}
		if(verCodeMap == null) {
			throw new BusinessException("信息查询错误, 不是有效的验证码.");
		}
		if(!queryType.equals(verCodeMap.get("code_type").toString())){
			throw new BusinessException("信息查询错误, 验证码对应的查询项目不一致.");
		}
		if(verCodeMap.get("create_date") == null || "".equals(verCodeMap.get("create_date")) || verCodeMap.get("valid_ime") == null || "".equals(verCodeMap.get("valid_ime"))) {
			throw new BusinessException("信息查询错误, 验证码有效期未指定.");
		}
		String beginDate = verCodeMap.get("create_date").toString();
		String sValidTime = verCodeMap.get("valid_ime").toString();
		int iValidTime = 0;
		try{
			iValidTime = Integer.parseInt(sValidTime);
		}catch(NumberFormatException ne) {
			//
		}
		//检查验证码有效期
		Date endDate = DateUtils.getCurrDay();
		Date startDate = DateUtils.parse(beginDate);
		Date validDate = DateUtils.addHour(startDate, iValidTime);
		int diffValue = DateUtils.compareDate(validDate, endDate);
		if(diffValue < 0) {
			throw new BusinessException("信息查询错误, 验证码有效期已过.");
		}
		String projectId = verCodeMap.get("project_id") == null? "" : verCodeMap.get("project_id").toString();
		paramMap.clear();
		paramMap.put("projectId", projectId);
		//检查是否查询到内容
		String getDataPreSql = "";
		if("P".equals(queryType)) {
			getDataPreSql = ConfigSQLUtil.getCacheSql("mproject-query-getProjectByNumber");
			paramMap.put("projectNumber", queryValue);
		}else if("M".equals(queryType)) {
			getDataPreSql = ConfigSQLUtil.getCacheSql("mproject-query-getBoxByBoxNumber");
			paramMap.put("boxNumber", queryValue);
		}else if("C".equals(queryType)) {
			getDataPreSql = ConfigSQLUtil.getCacheSql("mproject-query-getProcessorByNfcNumber");
			paramMap.put("nfcNumber", queryValue);
		}else if("D".equals(queryType)) {
			getDataPreSql = ConfigSQLUtil.getCacheSql("mproject-query-getDetectorByNfcNumber");
			paramMap.put("nfcNumber", queryValue);
		}
		String getDataSql = ConfigSQLUtil.preProcessSQL(getDataPreSql, paramMap);
		List alData = null;
		try {
			alData = springJdbcDao.queryForList(getDataSql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
		}
		if(alData == null || alData.size() < 1) {
			throw new BusinessException("未查询到数据.");
		}
		//查询成功,将验证码标识未已使用
		String updateCodePreSql = ConfigSQLUtil.getCacheSql("mproject-query-closeCodeByCodeId");
		paramMap.clear();
		paramMap.put("codeId", verCodeMap.get("id"));
		String updateCodeSql = ConfigSQLUtil.preProcessSQL(updateCodePreSql, paramMap);
		try {
			springJdbcDao.queryForList(updateCodeSql);
		} catch (DataAccessException dae) {
			log.info(dae.toString());
		}
		return verCodeMap;
	}
}
