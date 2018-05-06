/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年5月4日
* @修改人: 
* @修改日期：
* @描述: 
 */
package com.sierotech.mproject.common.utils;

import java.util.Date;
import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.server.service.impl.BoxServiceImpl;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年5月4日
* @功能描述: 邮件发送
 */
public class EmailUtil {
	static final Logger log = LoggerFactory.getLogger(EmailUtil.class);
	
	// mail.smtp.host
	public static String mailSmtpHost = ConfigFactory.getPropertyConfig("mproject.properties").getString("mail.smtp.host");
	
	// mail.smtp.timeout
	public static String mailSmtpTimeout = ConfigFactory.getPropertyConfig("mproject.properties").getString("mail.smtp.timeout");
	
	// mail.transport.protocol
	public static String mailProtocol =  ConfigFactory.getPropertyConfig("mproject.properties").getString("mail.transport.protocol");
	
	//发件人地址
	public static String senderAddress = ConfigFactory.getPropertyConfig("mproject.properties").getString("mail.sender.address");
	
	//发件人账户名
	public static String senderAccount = ConfigFactory.getPropertyConfig("mproject.properties").getString("mail.sender.account");
	
	//发件人账户密码
	public static String senderPassword = ConfigFactory.getPropertyConfig("mproject.properties").getString("mail.sender.pwd");
	
	public static void sendTextMail(String recipient, String mailSubject, String mailContent)  throws BusinessException{
	    Properties props = new Properties();
        props.setProperty("mail.smtp.auth", "true");
        props.setProperty("mail.transport.protocol", mailProtocol);
        props.setProperty("mail.smtp.timeout", mailSmtpTimeout);
        props.setProperty("mail.smtp.host", mailSmtpHost);
        
        Session session = Session.getInstance(props);
        session.setDebug(false);
        
        MimeMessage msg = new MimeMessage(session);
        try {
			msg.setFrom(new InternetAddress(senderAddress));
			// 收件人地址（可以增加多个收件人、抄送、密送），即下面这一行代码书写多行
			msg.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(recipient));
			//设置邮件主题
	        msg.setSubject(mailSubject,"UTF-8");
	        // 设置邮件正文
	        msg.setContent(mailContent, "text/html;charset=UTF-8");
	        // 设置邮件的发送时间,默认立即发送
	        msg.setSentDate(new Date());
	        
	        // 根据session对象获取邮件传输对象Transport
	        Transport transport = session.getTransport();
	        // 设置发件人的账户名和密码
	        transport.connect(senderAccount, senderPassword);
	        // 发送邮件，并发送到所有收件人地址，message.getAllRecipients() 获取到的是在创建邮件对象时添加的所有收件人, 抄送人, 密送人
	        transport.sendMessage(msg,msg.getAllRecipients());
	        transport.close();
		} catch (AddressException e) {
			log.info(e.getMessage());
			throw new BusinessException("不能连接到发送邮箱服务器.");
		} catch (MessagingException e) {
			log.info(e.getMessage());
			throw new BusinessException("邮件发送失败.");
		}
	}
}
