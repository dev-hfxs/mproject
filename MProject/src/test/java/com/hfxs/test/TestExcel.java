/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.hfxs.test;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sierotech.mproject.common.utils.excel.ParseExcelData;
import com.sierotech.mproject.context.AppContext;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: Excel文件解析测试
 */
public class TestExcel {
	static final Logger log = LoggerFactory.getLogger(TestExcel.class);

	public static void main(String[] args) {
		try {
//			InputStream fileIn = new FileInputStream("D:\\downloads\\处理器.xlsx");
			InputStream fileIn = new FileInputStream("D:\\downloads\\探测器.xls");
			AppContext.loadExcelMeta();
			Map<String, Object> datasMap = ParseExcelData.getInstance().readFile(fileIn, "D:\\downloads\\探测器.xls",
					AppContext.getExcelTemplateMeta("detector"));
			//log.info(datasMap.toString());
			System.out.println(datasMap);
		} catch (Exception e) {

		}

	}
	
	
}
