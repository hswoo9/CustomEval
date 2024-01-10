package com.duzon.custom.attachFile.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.attachFile.dao.AttachFileDAO;
import com.duzon.custom.attachFile.service.AttachFileService;
import com.duzon.custom.common.utiles.CtGetProperties;
import com.duzon.custom.common.utiles.CtPostUrl;

@Service
public class AttachFileServiceImpl implements AttachFileService {
	
	private static final Logger logger = LoggerFactory.getLogger(AttachFileServiceImpl.class);
	
	@Autowired
	private AttachFileDAO attachFileDAO;
	

	@Override
	public void attachFileDownload(String fileKey, HttpServletRequest request, HttpServletResponse response) {
		//첨부파일
		
		String fileNm = "";
		String path = "";
		String fileOrName = "";
		String rootPath = CtGetProperties.getKey("BizboxA.fileRootPath"); // /home/upload/dj_file
		
		Map<String, Object> file = attachFileDAO.getAttachFile(fileKey);
		
		fileNm = String.valueOf(file.get("attch_file_nm"));
		fileOrName = String.valueOf(file.get("attch_file_seq"));
		
		if(file.get("attch_file_code").equals("MIG")){
			path = String.valueOf(file.get("attch_file_path")) + fileOrName;
		}else{
			path = rootPath + String.valueOf(file.get("attch_file_path")) + fileOrName;
		}
		
		try {
			fileDownLoad(fileNm, path, request, response);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}

	@Override
	public String attachFileUpload(String key, String subPath, String code, String compSeq, String empSeq, MultipartHttpServletRequest multi) {
		//파일업로드 
		//key	문서키값
		//code	타입
		//multi	첨부파일
		
		//전자결재용 파일키
		String fileKey = "";
		
		List<MultipartFile> fileList = multi.getFiles("file");
		
		CtPostUrl gwFile = new CtPostUrl();
		gwFile.urlTxt("deleteYN", "Y");
		gwFile.urlTxt("compSeq", compSeq);
		gwFile.urlTxt("empSeq", empSeq);
		
		for (MultipartFile mf : fileList) {
			
			Map<String, Object> fileMap = attachFile(key, subPath, code, mf);
			gwFile.urlFile( (String)fileMap.get("attch_file_nm"), (File) fileMap.get("newFile"));
			
		}
		
		fileKey = gwFile.finish();
		
		return fileKey;
	}
	
	private Map<String, Object> attachFile(String key, String subPath, String code, MultipartFile file){
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		Date d = new Date();
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat ff = new SimpleDateFormat("yyyyMMdd");
		
		String path = CtGetProperties.getKey("BizboxA.fileRootPath") + subPath + df.format(d) + "/";
		String sub = subPath + df.format(d) + "/";
		
		String fileSeq = "DJF_" + ff.format(d) + RandomStringUtils.randomAlphanumeric(10);
		
		map.put("attch_file_nm", file.getOriginalFilename());
		map.put("attch_file_size", file.getSize());
		map.put("attch_file_path", sub);
		map.put("attch_file_doc_seq", key);
		map.put("attch_file_code", code);
		map.put("attch_file_seq", fileSeq);

		//디비에 등록을 하고
		//attachFileDAO.fileUpload(map);
		
		File targetFilePath = new File(path);
		File targetFile = new File(path + fileSeq);
		
		try {
			targetFilePath.mkdirs();
			file.transferTo(targetFile);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		map.put("newFile", targetFile);
		
		return map;
	}
	
	private static void fileDownLoad(String fileNm, String path, HttpServletRequest request, HttpServletResponse response) throws Exception {
		BufferedInputStream in = null;
		BufferedOutputStream out = null;
		File reFile = null;
		
		logger.info("@#file: " + path);

		reFile = new File(path);
		setDisposition(fileNm, request, response);
		
		in = new BufferedInputStream(new FileInputStream(reFile));
		out = new BufferedOutputStream(response.getOutputStream());
		
		FileCopyUtils.copy(in, out);
		out.flush();
	}

	private static void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = getBrowser(request);

		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "ISO-8859-1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			
			dispositionPrefix = "attachment;filename=\"";
			encodedFilename = sb.toString() + "\"";
		} else {
			
		}

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		if ("Opera".equals(browser)) {
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}
	
	private static String getBrowser(HttpServletRequest request) {
		String header = request.getHeader("User-Agent");
		if (header.indexOf("MSIE") > -1) { // IE 10 �씠�븯
			return "MSIE";
		} else if (header.indexOf("Trident") > -1) { // IE 11
			return "MSIE";
		} else if (header.indexOf("Chrome") > -1) {
			return "Chrome";
		} else if (header.indexOf("Opera") > -1) {
			return "Opera";
		}
		return "Firefox";
	}

	
}
