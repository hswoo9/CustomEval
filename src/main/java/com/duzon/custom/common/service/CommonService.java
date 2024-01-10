package com.duzon.custom.common.service;

import java.util.List;
import java.util.Map;

public interface CommonService {

	/**
	 * 한글 기안기 서버 URL 조회
	 * @param achrGbn
	 * @return
	 */
	String getHwpCtrlUrl(String achrGbn);

	List<Map<String, Object>> getBankCode();


}
