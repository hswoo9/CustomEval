package com.duzon.custom.eval.utiles;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.duzon.custom.eval.service.EvalService;


public class EvalScheduler {

	private static final Logger logger = LoggerFactory.getLogger(EvalScheduler.class);
	
	
	@Autowired
	private EvalService evalService;
	
	/**
	 * 2020. 8. 27.
	 * yh
	 * :평가자 id 스케줄러 
	 */
	public void evalIdReset(){
		logger.debug("#### evalIdReset ####");
		
		// 1. 아이디 패스워드 매일 초기화 세팅 난수 6자리 영문 대, 소, 숫자
		evalService.setEvalPassword();
		
		// 2. 아이디 삭제 평가 종료일 기준 다음날 삭제
		evalService.setEvalIdDel();
		
	}
	
	
}
