package com.duzon.custom.login.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.duzon.custom.eval.service.EvalService;
import com.duzon.custom.login.service.LoginService;
import com.duzon.custom.login.vo.EvalLoginVO;

/**
 * 제안평가
 * yh
 */
@Controller
public class LoginController {

	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	@Autowired
	private LoginService loginService;


	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model, HttpServletRequest request, HttpServletResponse response){
		
		HttpSession session = request.getSession();
		
		if(session != null){
			session.invalidate();
		}
		
		Map<String, ?> flashMap = RequestContextUtils.getInputFlashMap(request);
		
		if(flashMap != null) {  
			String message = (String) flashMap.get("message");
			model.addAttribute("message", message);
		}
		
		return "/login/loginView";
	}
	
	@RequestMapping(value = "/login", method = RequestMethod.POST)
	public String login(HttpServletRequest request, HttpServletResponse response, EvalLoginVO evalLoginVO){
		
		HttpSession session = request.getSession();
		Map<String, Object> map = new HashMap<String, Object>();
		
		int cnt = loginService.getLoginChk(evalLoginVO);
		map.put("evalId", evalLoginVO.getId());
        map.put("evalPw", evalLoginVO.getPw());
		map.put("evalTitle", evalLoginVO.getTitle());
		
		//로그인처리
		if(cnt > 0){
			map.put("flag", true);
			session.setAttribute("id", evalLoginVO.getId());
		}else{
			map.put("flag", false);
		}
		
		session.setAttribute("evalLoginVO", map);
		
		return "redirect:/eval/notice";
	}
	

}
