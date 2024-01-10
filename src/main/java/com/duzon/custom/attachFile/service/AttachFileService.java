package com.duzon.custom.attachFile.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartHttpServletRequest;

public interface AttachFileService {
	
	String attachFileUpload(String key, String subPath, String code, String compSeq, String empSeq, MultipartHttpServletRequest multi);
	
	void attachFileDownload(String fileKey, HttpServletRequest request, HttpServletResponse response);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	   
	
}
