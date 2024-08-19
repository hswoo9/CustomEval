package com.duzon.custom.login.dao;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;
import com.duzon.custom.login.vo.EvalLoginVO;

import java.util.List;
import java.util.Map;

@Repository
public class LoginDAO extends AbstractDAO{

	public int getLoginChk(EvalLoginVO evalLoginVO) {
		return (int) selectOne("login.loginChk", evalLoginVO);
	}

	public List<Map<String, Object>> getEvalSearchList(Map<String, Object> map) {
		return selectList("login.getEvalSearchList", map);
	}

}
