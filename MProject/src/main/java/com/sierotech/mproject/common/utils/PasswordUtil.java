/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.common.utils;

/**
 * @JDK版本: 1.7
 * @创建人: lwm
 * @创建日期：2018年4月15日 
 * @功能描述: 密码工具类 
 */
public class PasswordUtil {
	private static String passwordProviderClassName = ConfigFactory.getPropertyConfig("mproject.properties").getString("password.provider.class");

	public static String encrypt(String pwd) {
		return getPasswordUtil().encrypt(pwd);
	}
	

	public static boolean validPassword(String password,String encryptValue) {
		return getPasswordUtil().validPassword(password, encryptValue);
	}
	
	private static IPasswordProvider getPasswordUtil() {
		try {
			Class newClass = Class.forName(passwordProviderClassName);
			return (IPasswordProvider) newClass.newInstance();
		} catch (Exception ee) {
			ee.printStackTrace();
			System.out.println("please config the password.provider.class!");
			return null;
		}
	}
	
//	  public static void main(String[] arg0) throws Exception
//	  {
//	       String pwd = "12345";
//		   String str = encrypt(pwd);
//		   System.out.println(str);
//		   System.out.println(validPassword("12345",str));
//	  }
}
