/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.common.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: 日期工具类 默认使用 "yyyy-MM-dd HH:mm:ss" 格式化日期
 */

public final class DateUtils {
	public static String FORMAT_SHORT = "yyyy-MM-dd";

	public static String FORMAT_LONG = "yyyy-MM-dd HH:mm:ss";

	public static String FORMAT_FULL = "yyyy-MM-dd HH:mm:ss.S";

	public static String FORMAT_SHORT_CN = "yyyy年MM月dd";

	public static String FORMAT_LONG_CN = "yyyy年MM月dd日  HH时mm分ss秒";

	public static String FORMAT_FULL_CN = "yyyy年MM月dd日  HH时mm分ss秒SSS毫秒";

	private static SimpleDateFormat datetimeFormat = new SimpleDateFormat(FORMAT_LONG);

	private static SimpleDateFormat dateFormat = new SimpleDateFormat(FORMAT_SHORT);

	/**
	 * 获得默认的 date pattern
	 */
	public static String getDatePattern() {
		return FORMAT_LONG;
	}

	/**
	 * 根据预设格式返回当前日期
	 * 
	 * @return
	 */
	public static String getNow() {
		return format(new Date());
	}

	/**
	 * 根据用户格式返回当前日期
	 * 
	 * @param format
	 * @return
	 */
	public static String getNow(String format) {
		return format(new Date(), format);
	}

	/**
	 * 使用预设格式格式化日期
	 * 
	 * @param date
	 * @return
	 */
	public static String format(Date date) {
		return format(date, getDatePattern());
	}

	/**
	 * 使用用户格式格式化日期
	 * 
	 * @param date
	 *            日期
	 * @param pattern
	 *            日期格式
	 * @return
	 */
	public static String format(Date date, String pattern) {
		String returnValue = "";
		if (date != null) {
			SimpleDateFormat df = new SimpleDateFormat(pattern);
			returnValue = df.format(date);
		}
		return (returnValue);
	}

	/**
	 * 使用预设格式提取字符串日期
	 * 
	 * @param strDate
	 *            日期字符串
	 * @return
	 */
	public static Date parse(String strDate) {
		return parse(strDate, getDatePattern());
	}

	/**
	 * 使用用户格式提取字符串日期
	 * 
	 * @param strDate
	 *            日期字符串
	 * @param pattern
	 *            日期格式
	 * @return
	 */
	public static Date parse(String strDate, String pattern) {
		SimpleDateFormat df = new SimpleDateFormat(pattern);
		try {
			return df.parse(strDate);
		} catch (ParseException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * 在日期上增加数个整月
	 * 
	 * @param date
	 *            日期
	 * @param n
	 *            要增加的月数
	 * @return
	 */
	public static Date addMonth(Date date, int n) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.MONTH, n);
		return cal.getTime();
	}

	/**
	 * 在日期上增加天数
	 * 
	 * @param date
	 *            日期
	 * @param n
	 *            要增加的天数
	 * @return
	 */
	public static Date addDay(Date date, int n) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.DATE, n);
		return cal.getTime();
	}

	/**
	 * 在日期上增加小时
	 * 
	 * @param date
	 *            日期
	 * @param n
	 *            要增加的小时数
	 * @return
	 */
	public static Date addHour(Date date, int n) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		cal.add(Calendar.HOUR, n);
		return cal.getTime();
	}
	/**
	 * 获取时间戳
	 */
	public static String getTimeString() {

		Calendar calendar = Calendar.getInstance();
		return datetimeFormat.format(calendar.getTime());
	}

	/**
	 * 按默认格式的字符串距离今天的天数
	 * 
	 * @param date
	 *            日期字符串
	 * @return
	 */
	public static int countDays(String date) {
		long t = Calendar.getInstance().getTime().getTime();
		Calendar c = Calendar.getInstance();
		c.setTime(parse(date));
		long t1 = c.getTime().getTime();
		return (int) (t / 1000 - t1 / 1000) / 3600 / 24;
	}

	/**
	 * 按用户格式字符串距离今天的天数
	 * 
	 * @param date
	 *            日期字符串
	 * @param format
	 *            日期格式
	 * @return
	 */
	public static int countDays(String date, String format) {
		long t = Calendar.getInstance().getTime().getTime();
		Calendar c = Calendar.getInstance();
		c.setTime(parse(date, format));
		long t1 = c.getTime().getTime();
		return (int) (t / 1000 - t1 / 1000) / 3600 / 24;
	}

	/**
	 * 将日期对象转换为字符串，格式为yyyy-MM-dd.
	 * 
	 * @param date
	 *            日期.
	 * @return 日期对应的日期字符串.
	 */
	public static String toDateString(Date date) {
		if (date == null) {
			return null;
		}
		return dateFormat.format(date);
	}

	/**
	 * 返回当前系统时间
	 * 
	 * @return
	 */
	public static String getCurrDateTime() {
		return toDatetimeString(new Date());

	}

	/**
	 * 获取系统当前时间，待后期可扩展到取数据库时间
	 * 
	 * @return 系统当前时间
	 */
	public static String getCurrDate() {
		return toDateString(new Date());

	}

	/**
	 * 将日期对象转换为字符串，转换后的格式为yyyy-MM-dd HH:mm:ss.
	 * 
	 * @param date
	 *            要转换的日期对象.
	 * @return 字符串,格式为yyyy-MM-dd HH:mm:ss.
	 */
	public static String toDatetimeString(Date date) {
		if (date == null) {
			return null;
		}
		return datetimeFormat.format(date);
	}

	/**
	 * 获取当前日期
	 * 
	 * @return
	 */
	public static Date getCurrDay() {
		return new Date();
	}

	/**
	 * 返回年份，如2004.
	 */
	public static int getYear(Date d) {

		Calendar c = Calendar.getInstance();
		c.setTime(d);
		return c.get(Calendar.YEAR);
	}

	public static int getYear() {
		return getYear(new Date());
	}

	/**
	 * 返回月份，为1－－ － 12内.
	 */
	public static int getMonth(Date d) {
		Calendar c = Calendar.getInstance();
		c.setTime(d);
		return c.get(Calendar.MONTH) + 1;
	}

	public static int getMonth() {
		return getMonth(new Date());
	}

	/**
	 * 取得季度
	 * 
	 * @param d
	 *            日期类型
	 * @return
	 */
	public static final int getQuarter(Date d) {
		return getQuarter(getMonth(d));
	}

	/**
	 * 取得当前的季度
	 * 
	 * @return
	 */
	public static final int getQuarter() {
		return getQuarter(getMonth());
	}

	/**
	 * 传递月份,取得季度
	 * 
	 * @param num
	 * @return
	 */
	public static final int getQuarter(int num) {
		num = num % 3 == 0 ? num / 3 : (num / 3 + 1);
		return num % 4 == 0 ? 4 : num % 4;

	}

	/**
	 * 比较两个日期,起始日期是否小于结束日期
	 * 
	 * @param num
	 * @return
	 */
	public static int compareDate(Date startDate, Date endDate) {
		Calendar ca1=Calendar.getInstance();
		ca1.setTime(startDate);
		Calendar ca2=Calendar.getInstance();
		ca2.setTime(endDate);
		return ca2.compareTo(ca1);
	}
	 
}