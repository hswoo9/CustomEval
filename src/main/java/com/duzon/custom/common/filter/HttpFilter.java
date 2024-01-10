package com.duzon.custom.common.filter;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * request 파라미터를 보기 위한 필터
 * @author iguns
 *
 */
public class HttpFilter implements Filter{
	private static final Logger logger = LoggerFactory.getLogger(HttpFilter.class);
	private FilterConfig config;	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {

		/** 디버깅을 위한 요청 URL 확인 */
		request.setCharacterEncoding("UTF-8");
		HttpServletRequest  hsr = (HttpServletRequest )request;
		String uri = hsr.getRequestURI();
		if (uri != null && uri.indexOf(".") < 0) {
			String ipAddress = ((HttpServletRequest)request).getHeader("X-FORWARDED-FOR");  
			if (ipAddress == null) {  
				ipAddress = request.getRemoteAddr();  
			}

			logger.info("===>>> ["+ipAddress + "] "+ hsr.getRequestURL());
			Enumeration params = request.getParameterNames(); 
			while(params.hasMoreElements()){
				String paramName = (String)params.nextElement();
				logger.info("         "+paramName+" : "+request.getParameter(paramName));
			}
		}

		chain.doFilter(request, response);
	}
	@Override
	public void destroy() {
		
	}
	@Override
	public void init(FilterConfig arg0) throws ServletException {
		
	}

}
