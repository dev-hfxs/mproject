/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.common.utils.spring;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;

import com.sierotech.mproject.common.utils.SQLPoolInitializor;
import com.sierotech.mproject.context.AppContext;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: Spring 容器启动完执行系统初始化相关操作
 */
@Component
public class ContextLoadFinishHandle implements ApplicationListener<ContextRefreshedEvent> {
	static final Logger log = LoggerFactory.getLogger(ContextLoadFinishHandle.class);

	@Autowired
	private SQLPoolInitializor sqlPoolInit;

	// @Autowired
	// private DataSourceInitializor dataSrcInit;

	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		
		if (event.getApplicationContext().getDisplayName().startsWith("Root WebApplicationContext")) {
			
			sqlPoolInit.run();

			// 加载excel模板元数据
			AppContext.loadExcelMeta();
		}
	}
}
