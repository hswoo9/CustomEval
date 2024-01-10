package com.duzon.custom.attachFile.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.duzon.custom.attachFile.service.AttachFileService;

/**
 * @author user
 * 첨부파일 업로드, 다운로드 해보자
 */
@Controller
public class AttachFileController {
	
	private static final Logger logger = LoggerFactory.getLogger(AttachFileController.class);
	
	
	@Autowired
	private AttachFileService attachFileService;
	
	
	@RequestMapping(value = "/attachFile/attachFileDownload", method = RequestMethod.GET)
	@ResponseBody
	public void attachFileDownload(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response){
		logger.info("attachFileDownload");
		try {
			attachFileService.attachFileDownload(String.valueOf(map.get("fileKey")), request, response);
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		

}
