package com.duzon.custom.login.service;

import com.duzon.custom.login.vo.EvalLoginVO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;
import java.util.List;

public interface LoginService {

	int getLoginChk(EvalLoginVO evalLoginVO);

	List<Map<String, Object>> getEvalSearchList(Map<String, Object> params);

}
