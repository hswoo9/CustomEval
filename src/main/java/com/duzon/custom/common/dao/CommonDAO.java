package com.duzon.custom.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

/**
 * 공통 DAO
 * 필요에 따라 method 추가 가능.
 * @author iguns
 *
 */
@Repository("CommonDAO")
public class CommonDAO extends AbstractDAO{

	/**
	 * 한글 기안기 서버 URL 조회
	 * @param achrGbn
	 * @return
	 */
	public String getHwpCtrlUrl(String achrGbn) {
		return (String) selectOne("common.getHwpCtrlUrl", achrGbn);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getBankCode() {
		return selectListMs("common.getBankCode");
	}

	
}
