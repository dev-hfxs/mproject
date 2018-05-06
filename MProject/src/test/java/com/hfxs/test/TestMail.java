/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月4日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.hfxs.test;


import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月4日
* @功能描述: 
 */
public class TestMail {
	    private static JavaMailSenderImpl mailSender = createMailSender();

	    /**
	     * 邮件发送器
	     *
	     * @return 配置好的工具
	     */
	    private static JavaMailSenderImpl createMailSender() {
	        JavaMailSenderImpl sender = new JavaMailSenderImpl();
	        sender.setHost("smtp.exmail.qq.com");
	        sender.setPort(25);
	        sender.setUsername("weiming.li@sierotech.com");
	        sender.setPassword("hfxs2018Nice");
	        sender.setDefaultEncoding("Utf-8");
	        Properties p = new Properties();
	        p.setProperty("mail.transport.protocol", "smtp");
	        p.setProperty("mail.smtp.host", "smtp.exmail.qq.com");
	        p.setProperty("mail.smtp.timeout", "1000");
	        p.setProperty("mail.smtp.auth", "false");
	        sender.setJavaMailProperties(p);
	        return sender;
	    }

	    /**
	     * 发送邮件
	     *
	     * @param to 接受人
	     * @param subject 主题
	     * @param html 发送内容
	     * @throws MessagingException 异常
	     * @throws UnsupportedEncodingException 异常
	     */
	    public static void sendMail(String to, String subject, String html) throws MessagingException,UnsupportedEncodingException {
	        MimeMessage mimeMessage = mailSender.createMimeMessage();
	        // 设置utf-8或GBK编码，否则邮件会有乱码
	        MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
	        messageHelper.setFrom("weiming.li@sierotech.com", "lwm");
	        messageHelper.setTo(to);
	        messageHelper.setSubject(subject);
	        messageHelper.setText(html, true);
	        mailSender.send(mimeMessage);
	    }
	    
	    public static void main(String[] args) {
	    	try {
				sendMail("82889738@qq.com","test","niaho");
			} catch (UnsupportedEncodingException e) {
				
				e.printStackTrace();
			} catch (MessagingException e) {
				e.printStackTrace();
			}
	    }
}
