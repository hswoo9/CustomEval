package com.duzon.custom.common.interceptor;

import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.ModelAndViewDefiningException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.servlet.support.RequestContextUtils;


public class AuthenticInterceptor extends HandlerInterceptorAdapter {

	/**
	 * 세션에 계정정보(LoginVO)가 있는지 여부로 인증 여부를 체크한다.
	 * 계정정보(LoginVO)가 없다면, 로그인 페이지로 이동한다.
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
		
		boolean flag = false;
		FlashMap fm = RequestContextUtils.getOutputFlashMap(request);
		
		try {
			
			Map<String, Object> map = (Map<String, Object>) request.getSession().getAttribute("evalLoginVO");
			
			if (map != null && (boolean) map.get("flag")) {
				
				flag = true;
					
			} else {
				fm.put("message", "로그인 정보가 잘못되었습니다.");
				ModelAndView modelAndView = new ModelAndView("redirect:/");
				throw new ModelAndViewDefiningException(modelAndView);
			}
		} catch (Exception e) {
			fm.put("message", "로그인 정보가 잘못되었습니다.");
			ModelAndView modelAndView = new ModelAndView("redirect:/");
			throw new ModelAndViewDefiningException(modelAndView);
		}
		
		return flag;
	}

}
