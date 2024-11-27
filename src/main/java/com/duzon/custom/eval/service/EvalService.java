package com.duzon.custom.eval.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.duzon.custom.login.vo.EvalLoginVO;
import com.google.gson.JsonElement;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface EvalService {

	Map<String, Object> setSign(Map<String, Object> map, String serverDir);

	Map<String, Object> getEvalchk(Map<String, Object> map);

	List<Map<String, Object>> getResultList(Map<String, Object> map);

	List<Map<String, Object>> getCompanyList(Map<String, Object> map);

	List<Map<String, Object>> getItemList(Map<String, Object> map);
	List<Map<String, Object>> getItemList2(Map<String, Object> map);

	void evalViewSave(Map<String, Object> map);

	List<Map<String, Object>> getCompanyRemarkList(Map<String, Object> map);

	List<Map<String, Object>> getCommissionerList(Map<String, Object> map);

	String setCommSave(Map<String, Object> map);

	String getEvalJang(Map<String, Object> map);

	String setSignSetpChk(Map<String, Object> map);
	Map<String, Object> setSignSetp(Map<String, Object> map);

	Map<String, Object> getEvalJangData(Map<String, Object> map);

	Map<String, Object> getEvalConfirmChk(Map<String, Object> map);

	List<Map<String, Object>> getEvalCompany(Map<String, Object> map);

	Map<String, Object> evalResultList(Map<String, Object> map);
	
	void setEvalPassword();

	void setEvalIdDel();

	String getCommitteeJangName(Map<String, Object> map);

	List<Map<String, Object>> getCompanyTotal(Map<String, Object> map);

	String evalMod(Map<String, Object> map);

	/**
	 * 기피신청
	 * @param params
	 */
	void setEvalAvoidY(Map<String, Object> params);

	Map<String, Object> getEvalCommittee(Map<String, Object> params);

	void evalProposalModFileDownload(Map<String, Object> map, String serverDir,HttpServletRequest request, HttpServletResponse response) ;

	Map<String, Object> makeZipFile(Map<String, Object> map, HttpServletRequest request, HttpServletResponse response);

	void setScoreData(Map<String, Object> params);
	Map<String, Object> getCommissionerChk(Map<String, Object> params);
	Map<String, Object> getCommissionerChk2(Map<String, Object> params);
	Map<String, Object> getEvalAvoidFailChk(Map<String, Object> params);

	void setEvalCommissionerBlindUpd(Map<String, Object> params);

	List<Map<String, Object>> getSignList(Map<String, Object> params);

	void setEvalJangReSelected(Map<String, Object> map);



}
