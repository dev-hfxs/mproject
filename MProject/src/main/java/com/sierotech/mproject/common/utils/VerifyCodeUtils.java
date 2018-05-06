/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月4日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.common.utils;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Random;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月4日
* @功能描述: 生成验证码
 */
public class VerifyCodeUtils {
	public static final String VERIFY_CODES = "23456789ABCDEFGHJKLMNPQRSTUVWXYZ";
    
    /**
     * 使用默认字符源生成验证码
     * @param verifySize    验证码长度
     * @return
     */
    public static String generateVerifyCode(int verifySize){
        return generateVerifyCode(verifySize, VERIFY_CODES);
    }
    
    
    /**
     * 使用指定源生成验证码
     * @param verifySize    验证码长度
     * @param sources   	验证码字符源
     * @return
     */
    public static String generateVerifyCode(int verifySize, String sources){
        if(sources == null || sources.length() == 0){
            sources = VERIFY_CODES;
        }
        int codesLen = sources.length();
        int index = codesLen -1;
        
        List<String> alSources = Arrays.asList(sources.split(""));
    	Collections.shuffle(alSources);    	
        Random rand = new Random();
        StringBuilder verifyCode = new StringBuilder(verifySize);
        while(verifyCode.length() < verifySize) {
            verifyCode.append(alSources.get(rand.nextInt(index)));
        }
        return verifyCode.toString();
    }
    
//    public static void main(String[] args) {
//    	for(int i=0;i<1000;i++) {
//    		System.out.println(VerifyCodeUtils.generateVerifyCode(8));
//    	}
//    }
}
