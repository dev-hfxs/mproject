/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.context;

import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.core.io.support.ResourcePatternResolver;
import org.xml.sax.InputSource;

import com.sierotech.mproject.common.utils.ConfigFactory;
import com.sierotech.mproject.common.utils.excel.ExcelDataTemplateMeta;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: 系统应用上下文,方便获取系统应用加载的配置信息
 */

public class AppContext {
	private static Map<String, ExcelDataTemplateMeta> edtmMap = new HashMap<String, ExcelDataTemplateMeta>();

	private static String uploadDir = ConfigFactory.getPropertyConfig("mproject.properties").getString("upload.dir");

	public static String getUploadDir() {
		return uploadDir;
	}

	public static ExcelDataTemplateMeta getExcelTemplateMeta(String dataName) {
		return edtmMap.get(dataName);
	}

	public static void loadExcelMeta() {
		ResourcePatternResolver resourceLoader = new PathMatchingResourcePatternResolver();
		Resource resource = resourceLoader.getResource("classpath:/templateMeta.xml");
		try {
			URL url = resource.getURL();
			InputSource is = new InputSource(url.toExternalForm());

			SAXReader reader = new SAXReader();
			Document doc = reader.read(is);
			Element rootNode = doc.getRootElement();
			// 获取数据节点
			List<Element> dataNodes = rootNode.elements("data");
			if (dataNodes != null) {
				for (Element dataNode : dataNodes) {
					ExcelDataTemplateMeta edtm = new ExcelDataTemplateMeta();
					String dataName = dataNode.attributeValue("name");
					String sheetNum = dataNode.attributeValue("sheetNum");
					String heardRowNum = dataNode.attributeValue("heardRowNum");
					edtm.setDataName(dataName);
					try {
						edtm.setSheetNum(Integer.parseInt(sheetNum));
					} catch (NumberFormatException ne) {
						break; // sheetNum页码指定错误,跳过该数据类型;
					}
					try {
						edtm.setHeaderRowNum(Integer.parseInt(heardRowNum));
					} catch (NumberFormatException ne) {
						break; // heardRowNum表头行指定错误,跳过该数据类型
					}
					// 数据节点的列
					List<Element> columnNodes = dataNode.elements();
					if (columnNodes != null) {
						Map<String, String> columnCellNameMap = new HashMap<String, String>();
						Map<String, String> columnTypeMap = new HashMap<String, String>();
						Map<String, Integer> columnCellNumMap = new HashMap<String, Integer>();
						Map<String, String> columnIsNullMap = new HashMap<String, String>();

						for (Element columnNode : columnNodes) {
							String columnName = columnNode.attributeValue("name");
							String columnCellName = columnNode.getTextTrim();
							String columnType = columnNode.attributeValue("dataType");
							String columnIsNull = columnNode.attributeValue("isNull");
							String columnCellNum = columnNode.attributeValue("cellNum");
							try {
								int cellNum = Integer.parseInt(columnCellNum);
								columnCellNumMap.put(columnName, cellNum);
							} catch (NumberFormatException ne) {
								break; // 元数据文件列号未指定正确,跳过该数据类型
							}
							columnCellNameMap.put(columnName, columnCellName);
							columnTypeMap.put(columnName, columnType);
							columnIsNullMap.put(columnName, columnIsNull);
						}
						edtm.setColumnCellNameMap(columnCellNameMap);
						edtm.setColumnTypeMap(columnTypeMap);
						edtm.setColumnIsNullMap(columnIsNullMap);
						edtm.setColumnCellNumMap(columnCellNumMap);
					}
					edtmMap.put(dataName, edtm);
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (DocumentException e) {
			e.printStackTrace();
		}
	}
}
