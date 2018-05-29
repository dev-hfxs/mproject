/**
* <p>版权所有:(C)2018-2022 天津航峰希萨科技有限公司 </p>
* @创建人: lwm
* @创建日期: 2018年4月15日
* @修改人: 
* @修改日期：
* @描述: 文件简要描述
 */
package com.sierotech.mproject.server.control;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

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
	
	/*
	 * 上传处理器配置文件
	 * */
	@RequestMapping(value = "/upload/configFile", method = RequestMethod.POST)
	@ResponseBody
	public String uploadTemp(HttpServletRequest request) {
		
		MultipartHttpServletRequest mreq = (MultipartHttpServletRequest ) request;
		if(mreq.getFileMap()!=null) {
			for(String key: mreq.getFileMap().keySet()) {
				MultipartFile fileT = mreq.getFileMap().get(key);
				
				String targetDir = AppContext.getUploadTempDir();

				// 如果文件不为空，写入上传路径
				if (!fileT.isEmpty()) {
					// 上传文件名
					String filename = fileT.getOriginalFilename();
					String fileId = request.getParameter("file-id");
					if(fileId == null) {
						throw new BusinessException("上传文件无效,缺少标识.");
					}
					int index = filename.lastIndexOf(".");
					String postfix = filename.substring(index + 1);
					if (!"txt".equals(postfix)) {
						throw new BusinessException("文件类型不正确,请选择txt文件.");
					}
					String newFileName = fileId + "_" + filename;
					File filepath = new File(targetDir, newFileName);
					// 判断路径是否存在，如果不存在就创建一个
					if (!filepath.getParentFile().exists()) {
						filepath.getParentFile().mkdirs();
					}
					// 将上传文件保存到目标文件当中
					try {
						fileT.transferTo(new File(targetDir + File.separator + newFileName));
					} catch (Exception e) {
						throw new BusinessException("文件存储错误.");
					}
				}
			}	
		}
		return "success";
	}
	
	/*
	 * 上传机箱验收文件
	 * */
	@RequestMapping(value = "/upload/acceptFile", method = RequestMethod.POST)
	@ResponseBody
	public String uploadAcceptFile(HttpServletRequest request) {		
		MultipartHttpServletRequest mreq = (MultipartHttpServletRequest ) request;
		if(mreq.getFileMap()!=null) {
			for(String key: mreq.getFileMap().keySet()) {
				MultipartFile fileT = mreq.getFileMap().get(key);
				
				String targetDir = AppContext.getUploadTempDir();

				// 如果文件不为空，写入上传路径
				if (!fileT.isEmpty()) {
					// 上传文件名
					String filename = fileT.getOriginalFilename();
					String fileId = request.getParameter("file-id");
					String newFileName = fileId + "_" + filename;
					File filepath = new File(targetDir, newFileName);
					// 判断路径是否存在，如果不存在就创建一个
					if (!filepath.getParentFile().exists()) {
						filepath.getParentFile().mkdirs();
					}
					// 将上传文件保存到目标文件当中
					try {
						fileT.transferTo(new File(targetDir + File.separator + newFileName));
					} catch (Exception e) {
						throw new BusinessException("文件存储错误.");
					}
				}
			}	
		}
		return "success";
	}
	
	
	/**
     * 文件下载
     */
    @RequestMapping(value = "/download", method = RequestMethod.POST)
    public String downloadFile(HttpServletRequest request, HttpServletResponse response) {
    	String filePath = request.getParameter("filePath");
        if (filePath != null) {
        	int pos = filePath.lastIndexOf("\\");
        	if(pos > 0) {
        		pos = pos + 1;
        	}
        	String fileName = filePath;
        	if(pos > 0) {
        		fileName = filePath.substring(pos);
        	}
        	
        	if(fileName !=null && fileName.lastIndexOf("_") > 0) {
        		int underlinePos = fileName.lastIndexOf("_");
        		fileName = fileName.substring(underlinePos + 1);
        	}
            String realPath = AppContext.getUploadDir();
            String fullPath = realPath + File.separator + filePath;
            File file = new File(fullPath);
            if (file.exists()) {
                response.setContentType("application/force-download");// 设置强制下载不打开
                String encodeFileName = "";
				try {
					encodeFileName = URLEncoder.encode(fileName,"UTF-8");
				} catch (UnsupportedEncodingException e1) {
					log.info(e1.getMessage());
				}
				response.addHeader("Content-Disposition","attachment;filename=" + encodeFileName );// 设置文件名
				byte[] buffer = new byte[1024];
                FileInputStream fis = null;
                BufferedInputStream bis = null;
                try {
                    fis = new FileInputStream(file);
                    bis = new BufferedInputStream(fis);
                    OutputStream os = response.getOutputStream();
                    int i = bis.read(buffer);
                    while (i != -1) {
                        os.write(buffer, 0, i);
                        i = bis.read(buffer);
                    }
                } catch (Exception e) {
                    log.info(e.getMessage());
                } finally {
                    if (bis != null) {
                        try {
                            bis.close();
                        } catch (IOException e) {
                        	log.info(e.getMessage());
                        }
                    }
                    if (fis != null) {
                        try {
                            fis.close();
                        } catch (IOException e) {
                        	log.info(e.getMessage());
                        }
                    }
                }
            }else {
            	request.setAttribute("errorInfo", "访问的文件："+fileName+"不存在!");
            	return "error/resIsvalid";
            }
        }
        return null;
    }
}
