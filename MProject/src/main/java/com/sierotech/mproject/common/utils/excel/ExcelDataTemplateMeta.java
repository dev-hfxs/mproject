/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.common.utils.excel;

import java.util.Map;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: Excel导入数据元数据描述类
 */
public class ExcelDataTemplateMeta {
	private String dataName;

	private int sheetNum;
	
	private int headerRowNum;
	
	private Map<String,String> columnCellNameMap;
	
	private Map<String,String> columnTypeMap;

	private Map<String,Integer> columnCellNumMap;
	
	private Map<String,String> columnIsNullMap;
	
	public ExcelDataTemplateMeta() {
		
	}

	public ExcelDataTemplateMeta(String dataName, int sheetNum, int headerRowNum,
			Map<String, String> columnCellNameMap, Map<String, String> columnTypeMap,
			Map<String, Integer> columnCellNumMap, Map<String, String> columnIsNullMap) {
		super();
		this.dataName = dataName;
		this.sheetNum = sheetNum;
		this.headerRowNum = headerRowNum;
		this.columnCellNameMap = columnCellNameMap;
		this.columnTypeMap = columnTypeMap;
		this.columnCellNumMap = columnCellNumMap;
		this.columnIsNullMap = columnIsNullMap;
	}

	@Override
	public String toString() {
		return "ExcelDataTemplateMeta [dataName=" + dataName + ", sheetNum=" + sheetNum + ", headerRowNum="
				+ headerRowNum + ", columnCellNameMap=" + columnCellNameMap + ", columnTypeMap=" + columnTypeMap
				+ ", columnCellNumMap=" + columnCellNumMap + ", columnIsNullMap=" + columnIsNullMap + "]";
	}
	
	public String getDataName() {
		return dataName;
	}

	public void setDataName(String dataName) {
		this.dataName = dataName;
	}

	public int getSheetNum() {
		return sheetNum;
	}

	public void setSheetNum(int sheetNum) {
		this.sheetNum = sheetNum;
	}

	public int getHeaderRowNum() {
		return headerRowNum;
	}

	public void setHeaderRowNum(int headerRowNum) {
		this.headerRowNum = headerRowNum;
	}

	public Map<String, String> getColumnCellNameMap() {
		return columnCellNameMap;
	}

	public void setColumnCellNameMap(Map<String, String> columnCellNameMap) {
		this.columnCellNameMap = columnCellNameMap;
	}

	public Map<String, String> getColumnTypeMap() {
		return columnTypeMap;
	}

	public void setColumnTypeMap(Map<String, String> columnTypeMap) {
		this.columnTypeMap = columnTypeMap;
	}

	public Map<String, Integer> getColumnCellNumMap() {
		return columnCellNumMap;
	}

	public void setColumnCellNumMap(Map<String, Integer> columnCellNumMap) {
		this.columnCellNumMap = columnCellNumMap;
	}

	public Map<String, String> getColumnIsNullMap() {
		return columnIsNullMap;
	}

	public void setColumnIsNullMap(Map<String, String> columnIsNullMap) {
		this.columnIsNullMap = columnIsNullMap;
	}

	

}
