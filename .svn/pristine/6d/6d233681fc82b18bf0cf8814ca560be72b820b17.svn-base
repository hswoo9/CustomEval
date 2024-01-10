package com.duzon.custom.common.controller;

import java.io.File;
import java.io.FileInputStream;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.common.utiles.FileDownload;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping(value="/common")
public class CommonController {
	
	private static final Logger logger = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	
	
	@RequestMapping(value = "/getHwpFile", method = RequestMethod.GET)
	public void getHwpFile(@RequestParam Map<String, Object> map,HttpServletRequest request, HttpServletResponse response) {
		logger.info("getHwpFile");
		
		String fileNm = map.get("fileNm") + ".hwp";

		String filePath = request.getSession().getServletContext().getRealPath("/resources/hwp/" + fileNm);
		
		temFileDown(filePath, fileNm, response);
	}
	
	private void temFileDown(String filePath, String fileName, HttpServletResponse response){
		
		File file = new File(filePath);
		FileInputStream in = null;
		try {
			try {
				in = new FileInputStream(file);
			} catch ( Exception e ) {
				e.printStackTrace();
			}

			response.setContentType( "application/x-msdownload" );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ new String(fileName.getBytes("euc-kr"),"iso-8859-1") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(file != null)
				response.setHeader( "Content-Length", file.length()+"" );
			else 
				response.setHeader( "Content-Length", "0" );
			
			FileDownload.outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}
		
	}
	

}
