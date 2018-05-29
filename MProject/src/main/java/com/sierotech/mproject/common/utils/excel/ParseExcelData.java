/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.common.utils.excel;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: 解析Excel文件的数据
 */
public class ParseExcelData {
	private static ParseExcelData instance;

	public ParseExcelData() {
		//
	}

	public static synchronized ParseExcelData getInstance() {
		if (instance == null) {
			instance = new ParseExcelData();
		}
		return instance;
	}

	public Map<String, Object> readFile(InputStream fileIn, String fileName, ExcelDataTemplateMeta edtm) {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		if (fileIn == null || fileName == null || edtm == null) {
			return null;
		}
		List<Map<String, String>> alValidData = new ArrayList<Map<String, String>>();
		List<Map<String, String>> alErrorData = new ArrayList<Map<String, String>>();
		try {

			int index = fileName.lastIndexOf(".");
			String postfix = fileName.substring(index + 1);

			Workbook workbook = null;
			if ("xls".equals(postfix)) {
				workbook = new HSSFWorkbook(fileIn);
			} else if ("xlsx".equals(postfix)) {
				workbook = new XSSFWorkbook(fileIn);
				// SXSSFWorkbook sworkbook = new SXSSFWorkbook((XSSFWorkbook)workbook,100);
			}

			// 获取第指定的sheet
			Sheet sheet = workbook.getSheetAt(edtm.getSheetNum());
			// 总的行数
			int sheetRows = sheet.getLastRowNum();
			
			// 总的列数 > 获取表头的列数
			int columns = sheet.getRow(edtm.getHeaderRowNum()).getLastCellNum();
			resultMap.put("allColumns", columns);
			// 获取表头 校验是否和元数据定义一致
			Row headRrow = sheet.getRow(edtm.getHeaderRowNum());
			boolean headerMatch = true;
			
			//begin 关闭列名校验 2018-05-29
//			if (null == headRrow || headRrow.getFirstCellNum() == -1) {
//				List<String> sheetHeads = new ArrayList<String>();
//				for (int i = 1; i < columns; i++) {
//					String cellName = headRrow.getCell(i).getStringCellValue();
//					sheetHeads.add(cellName);
//				}
//				Map<String, String> metaHeadColumns = edtm.getColumnCellNameMap();
//				Map<String, Integer> metaHeadCellNums = edtm.getColumnCellNumMap();
//
//				if (null != metaHeadColumns) {
//					for (Map.Entry<String, String> entry : metaHeadColumns.entrySet()) {
//						String metaColumnName = entry.getKey().toString();
//						String metaCellName = entry.getValue().toString();
//
//						int metaCellNum = metaHeadCellNums.get(metaColumnName);
//
//						String tempCellName = sheetHeads.get(metaCellNum);
//						if (tempCellName.equals(metaCellName)) {
//							continue;
//						} else {
//							headerMatch = false; //// 模板数据列名与文件中的列名不一致,则校验失败
//							break;
//						}
//
//					}
//				}
//			}			
//			if (headerMatch == false) {
//				return null; // 校验失败返回
//			}
			//end 关闭列名校验 2018-05-29
			
			// 遍历数据行
			int dataBeginRow = edtm.getHeaderRowNum() + 1;
			Map<String, Integer> metaColumnCellNums = edtm.getColumnCellNumMap();
			Map<String, String> metaColumnTypes = edtm.getColumnTypeMap();
			Map<String, String> metaColumnIsNulls = edtm.getColumnIsNullMap();
			int factRows = 0; //有效数据行数
			for (int i = dataBeginRow; i <= sheetRows; i++) {
				Row dataRow = sheet.getRow(i);
				//if (null == dataRow || dataRow.getFirstCellNum() == -1 || dataRow.getLastCellNum() < columns) {
				if (null == dataRow || dataRow.getFirstCellNum() == -1) {
					// 这一行是空行，不读取
					continue;
				}
				int rowEmptyColumns = 0;
				for (Map.Entry<String, Integer> entry : metaColumnCellNums.entrySet()) {
					int columnCellNum = entry.getValue();
					String cellValue = "";
					if (null != dataRow.getCell(columnCellNum)) {
						dataRow.getCell(columnCellNum).setCellType(Cell.CELL_TYPE_STRING);
						cellValue = dataRow.getCell(columnCellNum).getStringCellValue();
					}
					if("".equals(cellValue)) {
						rowEmptyColumns ++;
					}
				}
				if(rowEmptyColumns == metaColumnCellNums.size()) {
					//指定列都是空数据
					continue;
				}
				factRows ++;
				Map<String, String> dataMap = new HashMap<String, String>();
				// 遍历数据行的列数
				boolean rowDataIsValid = true;
				
				for (Map.Entry<String, Integer> entry : metaColumnCellNums.entrySet()) {
					String columnName = entry.getKey();
					String columnType = metaColumnTypes.get(columnName);
					int columnCellNum = entry.getValue();

					String cellValue = "";
					if (null != dataRow.getCell(columnCellNum)) {
						dataRow.getCell(columnCellNum).setCellType(Cell.CELL_TYPE_STRING);
						cellValue = dataRow.getCell(columnCellNum).getStringCellValue();
					}
										
					String columnIsNull = metaColumnIsNulls.get(columnName);
					if ("N".equals(columnIsNull) || "n".equals(columnIsNull)) {
						if (null == cellValue || "".equals(cellValue)) {
							rowDataIsValid = false;
						}
					}
					
					if (columnType.startsWith("int") || columnType.startsWith("float") || columnType.startsWith("double")) {
						// 校验是否数字类型
						try {
							Double.valueOf(cellValue);
						} catch (NumberFormatException ne) {
							rowDataIsValid = false;
						}
					}
					dataMap.put(columnName, cellValue);
				}
				if (rowDataIsValid == true) {
					alValidData.add(dataMap);// 放入有效数据列表
				} else {
					alErrorData.add(dataMap);// 放入错误数据列表
				}
			}
			
			resultMap.put("allRows", factRows);
			resultMap.put("validData", alValidData);
			resultMap.put("errorData", alErrorData);
			fileIn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultMap;
	}
}
