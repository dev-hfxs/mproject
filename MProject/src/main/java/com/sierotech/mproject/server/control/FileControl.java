/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.server.control;

import java.io.File;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.sierotech.mproject.common.BusinessException;
import com.sierotech.mproject.context.AppContext;

/**
* @JDK版本: 1.7
* @创建人: lwm
* @创建日期：2018年4月15日
* @功能描述: 文件上传响应类
 */
@Controller
@RequestMapping("/file")
@Scope("request")
public class FileControl {
	static final Logger log = LoggerFactory.getLogger(FileControl.class);

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	@ResponseBody
	public String upload(HttpServletRequest request, MultipartFile file1, MultipartFile file2) {

		String targetDir = AppContext.getUploadDir();

		// 如果文件不为空，写入上传路径
		if (!file1.isEmpty()) {
			// 上传文件名
			String filename = file1.getOriginalFilename();
			int index = filename.lastIndexOf(".");
			String postfix = filename.substring(index + 1);

			if (!"txt".equals(postfix)) {
				throw new BusinessException("文件类型不正确,请选择txt文件.");
			}

			File filepath = new File(targetDir, filename);
			// 判断路径是否存在，如果不存在就创建一个
			if (!filepath.getParentFile().exists()) {
				filepath.getParentFile().mkdirs();
			}
			// 将上传文件保存到目标文件当中
			try {
				file1.transferTo(new File(targetDir + File.separator + filename));
			} catch (Exception e) {
				throw new BusinessException("文件存储错误.");
			}

		}

		if (!file2.isEmpty()) {
			// 上传文件名
			String filename = file2.getOriginalFilename();
			File filepath = new File(targetDir, filename);
			// 判断路径是否存在，如果不存在就创建一个
			if (!filepath.getParentFile().exists()) {
				filepath.getParentFile().mkdirs();
			}
			// 将上传文件保存到一个目标文件当中
			try {
				file2.transferTo(new File(targetDir + File.separator + filename));
			} catch (Exception e) {
				throw new BusinessException("文件存储错误.");
			}
		}
		return "success";
	}
}
