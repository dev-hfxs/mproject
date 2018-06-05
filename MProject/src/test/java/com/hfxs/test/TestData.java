/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年6月1日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.hfxs.test;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.SQLException;

import org.springframework.jdbc.core.JdbcTemplate;

import com.alibaba.druid.pool.DruidDataSource;
import com.sierotech.mproject.common.utils.UUIDGenerator;
import com.sierotech.mproject.common.utils.VerifyCodeUtils;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年6月1日
* @功能描述: 
 */
public class TestData {
	public static void main(String[] args) {
		
		
//		DruidDataSource newDataSource = new DruidDataSource();
//		
//		newDataSource.setDriverClassName("com.mysql.jdbc.Driver");
//		newDataSource.setUrl("jdbc:mysql://localhost:3316/mproject?useServerPrepStmts=true&rewriteBatchedStatements=true&useOldAliasMetadataBehavior=true&characterEncoding=utf-8");
//		newDataSource.setPoolPreparedStatements(false);
//		newDataSource.setValidationQuery(" SELECT 1 ");
//		newDataSource.setUsername("root");
//		newDataSource.setPassword("123456");
//		newDataSource.setInitialSize(1);
//		newDataSource.setMaxActive(5);
//		newDataSource.setMinIdle(1);
//		newDataSource.setRemoveAbandoned(true);
//		newDataSource.setRemoveAbandonedTimeout(180);
//		newDataSource.setLogAbandoned(true);
//		newDataSource.setDefaultAutoCommit(true);
//		newDataSource.setTestOnBorrow(true);
//		newDataSource.setMaxWait(45);
//		
//		JdbcTemplate springJdbc = new JdbcTemplate();
//		springJdbc.setDataSource(newDataSource);
		
		for(int i=2;i<3;i++) {
			StringBuffer sbSql = new StringBuffer();
			for(int j=0;j<10000;j++) {
				String processorId = UUIDGenerator.getUUID();
				sbSql.setLength(0);
//				sbSql.append(" insert into t_detector(id,processor_id,nfc_number,longitude, latitude, start_point, end_point,pos_desc, detector_seq) values ");
				for(int m=0;m<240;m++) {
					String nfcNumber = VerifyCodeUtils.generateVerifyCode(14);
//					sbSql.append("('"+UUIDGenerator.getUUID()+"','" + processorId +"','" + nfcNumber +"',1.235678,24.2875491,'N','N','a',"+ m +"),\n");
					sbSql.append(""+UUIDGenerator.getUUID()+"," + processorId +"," + nfcNumber +",1.235678,24.2875491,N,N,a,"+ m +"\n");
				}
				sbSql.setLength(sbSql.toString().lastIndexOf(","));
				sbSql.append("\n");
				System.out.println(j);
//				springJdbc.update(sbSql.toString());
				FileOutputStream fileOut;
				BufferedOutputStream buffOut;
				try {
					fileOut = new FileOutputStream(new File("d:\\temp\\detector_"+i+".txt"),true);
					buffOut = new BufferedOutputStream(fileOut);
					buffOut.write(sbSql.toString().getBytes());
					buffOut.flush();
					buffOut.close();
					fileOut.close();
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
		}
	}
}
