package com.duzon.custom.login.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.duzon.custom.login.dao.LoginDAO;
import com.duzon.custom.login.service.LoginService;
import com.duzon.custom.login.vo.EvalLoginVO;


import java.util.*;


@Service
public class LoginServiceImpl implements LoginService {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginServiceImpl.class);

	
	@Autowired
	private LoginDAO loginDao;

	@Override
	public int getLoginChk(EvalLoginVO evalLoginVO) {
		return loginDao.getLoginChk(evalLoginVO);
	}

	@Override
	public List<Map<String, Object>> getEvalSearchList(Map<String, Object> params) {
		return loginDao.getEvalSearchList(params);
	}
}
