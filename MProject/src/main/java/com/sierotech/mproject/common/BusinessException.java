package com.sierotech.mproject.common;


/**
 * @JDK版本: 1.7
 * @创建人: lwm
 * @创建日期：2018年4月15日
 * @功能描述: Service层公用的Exception. 继承自RuntimeException
 */

public class BusinessException extends RuntimeException {

	private static final long serialVersionUID = 1401593546385403720L;

	public BusinessException() {
		super();
	}

	public BusinessException(String message) {
		super(message);
	}

	public BusinessException(Throwable cause) {
		super(cause);
	}

	public BusinessException(String message, Throwable cause) {
		super(message, cause);
	}
}
