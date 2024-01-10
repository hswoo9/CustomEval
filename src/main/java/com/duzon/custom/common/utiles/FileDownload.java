package com.duzon.custom.common.utiles;

import java.io.FileInputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;

public class FileDownload {

	/**
	 * 2020. 10. 15.
	 * yh
	 * :
	 */
	
	
	public static void outputStream(HttpServletResponse response,FileInputStream in ) throws Exception {
		ServletOutputStream binaryOut = response.getOutputStream();
		byte buffer[] = new byte[8 * 1024];
		
		try {
			IOUtils.copy(in, binaryOut);
			binaryOut.flush();
		} catch ( Exception e ) {
		} finally {
			if (in != null) {
				try {
				in.close();
				}catch(Exception e ) {}
			}
			if (binaryOut != null) {
				try {
					binaryOut.close();
				}catch(Exception e ) {}
			}
		}	
	}
	
	public static  String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
        if (header.indexOf("MSIE") > -1 || header.indexOf("Trident") > -1) {
            return "MSIE";
        } else if (header.indexOf("Chrome") > -1) {
            return "Chrome";
        } else if (header.indexOf("Opera") > -1) {
            return "Opera";
        }
        return "Firefox";
    }
	
}
