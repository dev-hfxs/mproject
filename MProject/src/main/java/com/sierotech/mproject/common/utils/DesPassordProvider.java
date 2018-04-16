/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.common.utils;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;



/**
 * @JDK版本: 1.7
 * @创建人: lwm
 * @创建日期：2018年4月15日
 * @功能描述: DES加密,密码验证功能实现
 */
public class DesPassordProvider implements IPasswordProvider {
	private String byte2hex(byte[] b) {
		String hs = "";
		String stmp = "";
		for (int n = 0; n < b.length; n++) {
			stmp = (java.lang.Integer.toHexString(b[n] & 0XFF));
			if (stmp.length() == 1) {
				hs = hs + "0" + stmp;
			} else {
				hs = hs + stmp;
			}
		}
		return hs.toUpperCase();
	}

	private byte[] hexStringToByte(String hexString) {
		int length = hexString.length() / 2;
		byte[] b = new byte[length];
		for (int i = 0; i < length; i++) {
			int tempInt = Integer.parseInt(hexString.substring(i * 2, i * 2 + 2), 16);
			b[i] = (byte) tempInt;
		}
		return b;
	}

	private static final String Algorithm = "DESede";
	private static final byte[] keyBytes = { (byte) 0xAF, (byte) 0x22, (byte) 0x4F, (byte) 0x58, (byte) 0xDE,
			(byte) 0x10, (byte) 0x40, (byte) 0xBB, (byte) 0x28, (byte) 0x25, (byte) 0x79, (byte) 0x51, (byte) 0xCB,
			(byte) 0xEF, (byte) 0xAB, (byte) 0x66, (byte) 0xBE, (byte) 0x29, (byte) 0x7C, (byte) 0xDD, (byte) 0x30,
			(byte) 0x40, (byte) 0x36, (byte) 0xE2 };
	
	@Override
	public String encrypt(String inStr) {
		StringBuffer inoutStr = new StringBuffer(inStr);
		inoutStr.delete(0, inoutStr.length());
		try {
			SecretKey deskey = new SecretKeySpec(keyBytes, Algorithm);
			Cipher c1 = Cipher.getInstance(Algorithm);
			c1.init(Cipher.ENCRYPT_MODE, deskey);
			byte[] digest = c1.doFinal(inStr.getBytes());
			inoutStr.append(byte2hex(digest));

		} catch (Exception e) {
			e.printStackTrace();
			return "error.encrypt";
		}
		return inoutStr.toString();
	}

	public String decrypt(String inStr) {
		StringBuffer inoutStr = new StringBuffer(inStr);
		inoutStr.delete(0, inoutStr.length());
		try {
			SecretKey deskey = new SecretKeySpec(keyBytes, Algorithm);
			Cipher cliper = Cipher.getInstance(Algorithm);
			cliper.init(Cipher.DECRYPT_MODE, deskey);
			byte[] digest = cliper.doFinal(hexStringToByte(inStr));
			inoutStr.append(new String(digest));
		} catch (Exception e) {
			e.printStackTrace();
			return "error.encrypt";
		}
		return inoutStr.toString();
	}
	
	@Override
	public boolean validPassword(String password,String encryptValue) {
		if(null == password || encryptValue == null) {
			return false;
		}
		String decryptPassword = decrypt(encryptValue);
		return password.equals(encryptValue);
	}
}
