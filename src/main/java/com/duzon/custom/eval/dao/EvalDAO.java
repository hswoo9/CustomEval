package com.duzon.custom.eval.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.duzon.custom.common.dao.AbstractDAO;
import com.duzon.custom.common.vo.PdfEcmFileVO;
import com.duzon.custom.common.vo.PdfEcmMainVO;
import com.duzon.custom.login.vo.EvalLoginVO;

@Repository
public class EvalDAO extends AbstractDAO{

	public void setSignDir(Map<String, Object> params) {
		update("eval.setSignDir", params);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEvalchk(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvalchk", map);
	}

	public List<Map<String, Object>> getevalNotice(Map<String, Object> map) {
		return selectList("eval.getevalNotice", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getResultList(Map<String, Object> map) {
		return selectList("eval.getResultList", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCompanyList(Map<String, Object> map) {
		return selectList("eval.getCompanyList", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getItemList(Map<String, Object> map) {
		return selectList("eval.getItemList", map);
	}

	public List<Map<String, Object>> getItemList2(Map<String, Object> map) {
		return selectList("eval.getItemList2", map);
	}

	public void setEvalViewUpdate(Map<String, Object> vo) {
		update("eval.setEvalViewUpdate", vo);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCompanyRemarkList(Map<String, Object> map) {
		return selectList("eval.getCompanyRemarkList", map);
	}

	public void setEvalComRemarkUpdate(Map<String, Object> vo) {
		update("eval.setEvalComRemarkUpdate", vo);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCommissionerList(Map<String, Object> map) {
		return selectList("eval.getCommissionerList", map);
	}

	public void setCommSave(Map<String, Object> map) {
		update("eval.setCommSave", map);
	}

	public void setCommjangChk(Map<String, Object> map) {
		update("eval.setCommjangChk", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getChkList(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getChkList", map);
	}

	public void setJangUpdate(Map<String, Object> map) {
		update("eval.setJangUpdate", map);
	}

	public String getEvalJang(Map<String, Object> map) {
		return (String) selectOne("eval.getEvalJang", map);
	}

	public void setSignSetp(Map<String, Object> map) {
		update("eval.setSignSetp", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEvalJangData(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvalJangData", map);
	}

	public void setEvalConfirm(Map<String, Object> map) {
		update("eval.setEvalConfirm", map);
	}

	public String getEvalConfirmChk(Map<String, Object> map) {
		return (String) selectOne("eval.getEvalConfirmChk", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalConfirmData(Map<String, Object> map) {
		return selectList("eval.getEvalConfirmData", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getItemColList(Map<String, Object> map) {
		return selectList("eval.getItemColList", map);
	}

	public void setRankCode(Map<String, Object> map) {
		update("eval.setRankCode", map);
	}

	public void setEvalJangConfirm(Map<String, Object> map) {
		update("eval.setEvalJangConfirm", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalCompany(Map<String, Object> map) {
		return selectList("eval.getEvalCompany", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalResultList(Map<String, Object> map) {
		return selectList("eval.getEvalResultList", map);
	}

	@SuppressWarnings("unchecked")
	public Map<String, Object> getEvalResultTotal(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvalResultTotal", map);
	}

	public void evalSaveUpdate(Map<String, Object> map) {
		update("eval.evalSaveUpdate", map);
	}

	public void insertPdfMain(PdfEcmMainVO pdfMain) {
		insert("eval.insertPdfMain", pdfMain);
	}

	public void insertPdfFile(PdfEcmFileVO pdfFile) {
		insert("eval.insertPdfFile", pdfFile);
	}

	public void setEvalPassword() {
		update("eval.setEvalPassword", null);
	}

	public void setEvalIdDel() {
		update("eval.setEvalIdDel", null);
	}

	public void setPurcReqUpdate(Map<String, Object> map) {
		update("eval.setPurcReqUpdate", map);
	}

	public void setEvalIdDelLog() {
		insert("eval.setEvalIdDelLog", null);
	}

	public void setCommDetailUpdate(Map<String, Object> map) {
		update("eval.setCommDetailUpdate", map);
	}

	public void setEvalPayUpdate(Map<String, Object> map) {
		update("eval.setEvalPayUpdate", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getEvalConfirmData2(Map<String, Object> map) {
		return selectList("eval.getEvalConfirmData2", map);
	}

	public String getCommitteeJangName(Map<String, Object> map) {
		return (String) selectOne("eval.getCommitteeJangName", map);
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCompanyTotal(Map<String, Object> map) {
		return selectList("eval.getCompanyTotal", map);
	}

	public void evalMod(Map<String, Object> map) {
		update("eval.evalMod", map);
	}

	public String evalConfirmYn(Map<String, Object> map) {
		return (String) selectOne("eval.evalConfirmYn", map);
	}
	
	public void setJangEvalPayUpdate(Map<String,Object> map) {
		update("eval.setJangEvalPayUpdate", map);
	}
	public void setEvalAvoidY(Map<String,Object> map) {
		update("eval.setEvalAvoidY", map);
	}
	public void setEvalJangReSelected(Map<String,Object> map) {
		update("eval.setEvalJangReSelected", map);
	}
	public Map<String, Object> getEvalCommittee(Map<String, Object> params){ return (Map<String, Object>) selectOne("eval.getEvalCommittee", params);}

	public Map<String, Object> evalProposalModFileDownload(Map<String,Object> map){
		return (Map<String, Object>) selectOne("eval.evalProposalModFileDownload", map);
	}

    public Map<String, Object> getEvalCommittee2(Map<String, Object> map) {
        return (Map<String, Object>) selectOne("eval.getEvalCommittee2", map);
    }

    public void setEvalJangCntCn(Map<String, Object> map) {
        update("eval.setEvalJangCntCn", map);
    }

	public Map<String, Object> getEvalCommissionerEvalMinuteChk(Map<String, Object> params) { return (Map<String, Object>) selectOne("eval.getEvalCommissionerEvalMinuteChk", params);}
	public void getEvalMinuteChKGroupFailUpd(Map<String, Object> params) { update("eval.getEvalMinuteChKGroupFailUpd", params);}
	public void getEvalMinuteChKGroupFailUpd2(Map<String, Object> params) { update("eval.getEvalMinuteChKGroupFailUpd2", params);}

	public void setScoreData(Map<String, Object> map) {update("eval.setScoreData", map);}
	public List<Map<String, Object>> getCommissionerChk(Map<String, Object> params) { return selectList("eval.getCommissionerChk", params);}
	public List<Map<String, Object>> getCommissionerChk2(Map<String, Object> params) { return selectList("eval.getCommissionerChk2", params);}
	public Map<String, Object> getEvalAvoidFailChk(Map<String, Object> params) { return (Map<String, Object>) selectOne("eval.getEvalAvoidFailChk", params);}

	public void setEvalCommissionerBlindUpd(Map<String, Object> params){ update("eval.setEvalCommissionerBlindUpd", params);}

	public List<Map<String, Object>> getSignList(Map<String, Object> params){
		return selectList("eval.getSignList", params);
	}

	public List<Object> getJangCnt(Map<String, Object> map) {
		return selectList("eval.getJangCnt", map);
	}
	public void setEvalJangChkTie(Map<String,Object> map) {
		update("eval.setEvalJangChkTie", map);
	}

	public String getEvalTieChk(Map<String, Object> map) {
		return (String) selectOne("eval.getEvalTieChk", map);
	}

	public String getCommissionerSeqEvalId(Map<String, Object> map) {
		return (String) selectOne("eval.getCommissionerSeqEvalId", map);
	}

	public void setEvalJangNo(Map<String, Object> map) {
		update("eval.setEvalJangNo", map);
	}

	public List<Map<String, Object>> getDuplId(Map<String, Object> params){
		return selectList("eval.getDuplId", params);
	}


	public void setCommissionerSign9(Map<String, Object> map) {

		update("eval.setCommissionerSign9", map);
	}

	public int getCommissionerSign9Cnt(Map<String, Object> map) {

		return (int) selectOne("eval.getCommissionerSign9Cnt", map);
    }

	public Map<String, Object> getEvalStepCheck(Map<String, Object> map) {
		return (Map<String, Object>) selectOne("eval.getEvalStepCheck", map);
	}
}
