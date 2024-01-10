package com.duzon.custom.eval.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.duzon.custom.login.vo.EvalLoginVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.duzon.custom.common.service.CommonService;
import com.duzon.custom.eval.service.EvalService;
import com.google.gson.Gson;

/**
 * 제안평가
 * yh
 */
@Controller
public class EvalController {

	private static final Logger logger = LoggerFactory.getLogger(EvalController.class);
	
	@Autowired
	private EvalService evalService;
	
	@Autowired
	private CommonService commonService;

	private String SERVER_DIR = "/upload/";

	@RequestMapping(value = "/eval/evalAvoid", method = RequestMethod.POST)
	@ResponseBody
	public void evalAvoid(@RequestParam Map<String, Object> params, HttpServletRequest request){
		Map<String, Object> map = evalService.getEvalchk((Map<String, Object>) request.getSession().getAttribute("evalLoginVO"));
		map.put("eval_avoid_txt", params.get("eval_avoid_txt"));

		evalService.setEvalAvoidY(map);
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/eval/evalView", method = RequestMethod.GET)
	public String evalView(@RequestParam Map<String, Object> params, Model model, RedirectAttributes redirectAttr, HttpServletRequest request, RedirectAttributes redirect) throws Exception {
		logger.debug("evalView");
		
		Gson gs = new Gson();
		
		
//		SIGN_1 = 평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서
//		SIGN_2 = 평가위원 사전의결사항
//		SIGN_3 = 사전접촉여부 확인(신고)서
//		SIGN_4 = 평가수당 지급 확인서
//		SIGN_5 = 평가위원 개인정보 수집·이용 동의서
//		SIGN_6 = 위원별 제안서 평가표
//		SIGN_7 = 업체별 제안서 평가집계표
//		SIGN_8 = 제안서 평가 총괄표
//		SIGN_9 = 사전접촉여부 확인(신고)서 한번더
//		SIGN_10 = 평가위원장 가산금 지급 확인서

		
		FlashMap fm = RequestContextUtils.getOutputFlashMap(request);
		
		Map<String, Object> map = (Map<String, Object>) request.getSession().getAttribute("evalLoginVO");
		
		//로그인 기본 정보가져오기
		map = evalService.getEvalchk(map);

		/** 웹한글 기안기 url 가져오기 */
		String hwpUrl = "";
		if(request.getServerName().contains("localhost") || request.getServerName().contains("127.0.0.1")){
			hwpUrl = commonService.getHwpCtrlUrl("l_hwpUrl");
		}else{
			hwpUrl = commonService.getHwpCtrlUrl("s_hwpUrl");
		}

		model.addAttribute("hwpUrl", hwpUrl);
		model.addAttribute("userInfo", map);

		if(map != null && map.size() > 0 ){
			Map<String, Object> avoidChkMap = evalService.getEvalAvoidFailChk(map);
			if(avoidChkMap.get("avoidFailChk").equals("AVOID_OVER_FAIL")){
				if(map.get("SIGN_4").equals("N")) {
					logger.info("pageInfo ===== /eval/sign/evalSign4");
					//기피자가 평가위원 수의 2/3 됐을때 평가수당확인창으로 바로 이동
					List<Map<String, Object>> list = commonService.getBankCode();
					model.addAttribute("bankList", list);
					model.addAttribute("avoidFailMessage", "과반수의 평가위원이 기피신청을 하였으므로,\\n평가를 진행할 수 없습니다.");
					return "/eval/sign/evalSign4";
				} else {
					//평가수당 확인했으면 종료하기
					logger.info("pageInfo ===== /");
					HttpSession session = request.getSession();
					session.invalidate();
					fm.put("message", "과반수의 평가위원이 기피신청을 하였으므로,\\n평가를 진행할 수 없습니다.");
					return "redirect:/";
				}
			}

			if(map.get("SIGN_1").equals("N")){
				logger.info("pageInfo ===== /eval/sign/evalSign1");
				//평가위원 유의사항
				//평가위원 운영지침
				return "/eval/sign/evalSign1";
				
			}else if(map.get("JANG").equals("N")){
				logger.info("pageInfo ===== /eval/evalChoiceView");
				//평가위원 투표
				model.addAttribute("commissionerList", evalService.getCommissionerList(map));
				return "/eval/evalChoiceView";
				
			}else if(map.get("SIGN_2").equals("N")){
				logger.info("pageInfo ===== /eval/sign/evalSign2");
				//사전의결사항
				
				String jangName = evalService.getCommitteeJangName(map);
				model.addAttribute("jangName", jangName);
				
				return "/eval/sign/evalSign2";
				

			}else if(map.get("SIGN_5").equals("N")){
				logger.info("pageInfo ===== /eval/sign/evalSign5");
				//개인정보 동의서
				return "/eval/sign/evalSign5";
				
			}else if(map.get("SIGN_3").equals("N")){
				logger.info("pageInfo ===== /eval/sign/evalSign3");

				//사전접촉여부 확인
				List<Map<String, Object>> companyList = evalService.getCompanyList(map);
				model.addAttribute("getCompanyList", gs.toJson(companyList));
				model.addAttribute("companyList", companyList);
				
				return "/eval/sign/evalSign3";
			
			}else if(map.get("SIGN_3").equals("Y") && map.get("CONTACT").equals("Y")) {
				//사전접촉 했으면 바로 평가수당으로 보내기
				if(map.get("SIGN_4").equals("N")) {
					logger.info("pageInfo ===== /eval/sign/evalSign4");

					//평가수당확인
					List<Map<String, Object>> list = commonService.getBankCode();
					model.addAttribute("bankList", list);
					return "/eval/sign/evalSign4";
				} else {
					logger.info("pageInfo ===== /");

					//평가수당 확인했으면 종료하기
					HttpSession session = request.getSession();
					session.invalidate();
					fm.put("message", "평가가 종료되었습니다.");
					return "redirect:/";
				}
				
			}else if(map.get("EVAL_SAVE").equals("N") && map.get("SIGN_6").equals("N")){
				logger.info("pageInfo ===== /eval/evalView");

				//평가 시작
				model.addAttribute("list", evalService.getResultList(map));
				model.addAttribute("companyList", evalService.getCompanyList(map));
				model.addAttribute("companyRemarkList", evalService.getCompanyRemarkList(map));
				model.addAttribute("itemList", evalService.getItemList(map));
				model.addAttribute("evalCommittee", evalService.getEvalCommittee(map));

				return "/eval/evalView";
				
			}/*else if(map.get("SIGN_9").equals("N")){

				//사전접촉여부 확인
				List<Map<String, Object>> companyList = evalService.getCompanyList(map);
				model.addAttribute("getCompanyList", gs.toJson(companyList));
				model.addAttribute("companyList", companyList);

				return "/eval/sign/evalSign9";

			}*/else if(map.get("SIGN_6").equals("N")){
				logger.info("pageInfo ===== /eval/sign/evalSign6");

				//사전접속자는 제외
//				if(map.get("CONTACT").equals("N")){

				map.put("pageNumber", "6");
					//위원별 제안서 평가표
					//결과
				model.addAttribute("list", gs.toJson(evalService.getResultList(map)));
				//회사
				model.addAttribute("getCompanyList", gs.toJson(evalService.getCompanyList(map)));
				//평가내용
				model.addAttribute("getCompanyRemarkList", gs.toJson(evalService.getCompanyRemarkList(map)));
				//항목
				model.addAttribute("itemList", gs.toJson(evalService.getItemList2(map)));
				//기업별 토탈
				model.addAttribute("companyTotal", gs.toJson(evalService.getCompanyTotal(map)));

				return "/eval/sign/evalSign6";
				
//				}else{
//					HttpSession session = request.getSession();
//					session.invalidate();
//					fm.put("message", "평가가 종료되었습니다.");
//					return "redirect:/";
//				}
				
			}else if(map.get("SIGN_7").equals("N") && map.get("EVAL_JANG").equals("Y")){
				logger.info("pageInfo ===== /eval/sign/evalSign7");

				//6,7,8,10 은 위원장만 진행
				
				List<Map<String, Object>> getCompanyList = evalService.getCompanyList(map);
//				
//				//회사
				model.addAttribute("getCompanyList", getCompanyList);
//
//				//결과
				List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
				for (Map<String, Object> company : getCompanyList) {
//					System.out.println(getCompanyList.get(0).get("eval_company_seq"));
//					map.put("EVAL_COMPANY_SEQ", getCompanyList.get(0).get("eval_company_seq"));
//					resultList.add(evalService.evalResultList(map));
					System.out.println(company.get("eval_company_seq"));
					map.put("EVAL_COMPANY_SEQ", company.get("eval_company_seq"));
					resultList.add(evalService.evalResultList(map));
				}
//				
				model.addAttribute("result", resultList);
				
				return "/eval/sign/evalSign7";

			}else if(map.get("SIGN_8").equals("N") && map.get("EVAL_JANG").equals("Y")){
				logger.info("pageInfo ===== /eval/sign/evalSign8");
				
				//평가 결과
				model.addAttribute("result", gs.toJson(evalService.getEvalConfirmChk(map)));
				
				return "/eval/sign/evalSign8";
				
			}else if(map.get("SIGN_4").equals("N")){
				logger.info("pageInfo ===== /eval/sign/evalSign4");

				//평가수당확인
				
				List<Map<String, Object>> list = commonService.getBankCode();
				model.addAttribute("bankList", list);
				
				return "/eval/sign/evalSign4";
				
			}else if(map.get("SIGN_10").equals("N") && map.get("EVAL_JANG").equals("Y")){
				logger.info("pageInfo ===== /eval/sign/evalSign10");

				//평가위원장 가산금 지급 확인서
				return "/eval/sign/evalSign10";
			}else{
				logger.info("pageInfo ===== /");

				HttpSession session = request.getSession();
				session.invalidate();
				fm.put("message", "\"평가위원님의 제안 평가가\\n정상적으로 제출 되었습니다.\"\\n수고 하셨습니다.");
				return "redirect:/";
			}
		}else{
			logger.info("pageInfo ===== /");
			//혹시라도 평가가 없으면 로그인페이지로
			HttpSession session = request.getSession();
			session.invalidate();
			fm.put("message", "평가가 없습니다.");
			return "redirect:/";
			
		}
		
	}

	@RequestMapping("/eval/getEvalData")
	@ResponseBody
	public Map<String, Object> getEvalData(@RequestParam Map<String, Object> params){
		Map<String, Object> result = new HashMap<>();

		result.put("companyList", evalService.getCompanyList(params));
		result.put("itemList", evalService.getItemList(params));

		return result;
	}

	@RequestMapping(value = "/eval/evalBlindPopup", method = RequestMethod.GET)
	public String evalBlindPopup(@RequestParam Map<String, Object> params, Model model) {
		model.addAttribute("params", params);
		return "/eval/popup/evalBlindPopup";
	}

	@RequestMapping(value = "/eval/setEvalCommissionerBlindUpd", method = RequestMethod.POST)
	@ResponseBody
	public void setEvalCommissionerBlindUpd(@RequestParam Map<String, Object> params, HttpServletRequest request) {
		evalService.setEvalCommissionerBlindUpd(params);
	}

	@RequestMapping(value = "/eval/evalViewSave", method = RequestMethod.POST) 
	@ResponseBody
	public void evalViewSave(@RequestParam Map<String, Object> map, @RequestParam Map<String, Object> params) {
		logger.debug("evalViewSave");
		
		evalService.evalViewSave(map);
		evalService.setScoreData(params);
		
	}

	@RequestMapping(value = "/eval/setCommSave", method = RequestMethod.POST) 
	@ResponseBody
	public String setCommSave(@RequestParam Map<String, Object> map, HttpServletRequest request) {
		logger.debug("setCommSave");
		
		map.putAll((Map<String, Object>) request.getSession().getAttribute("evalLoginVO"));
		
		return evalService.setCommSave(map);
		
	}

	/**
	 * 2020. 7. 10.
	 * yh
	 * :장이 누구인가
	 */
	@RequestMapping(value = "/eval/getEvalJang", method = RequestMethod.POST) 
	@ResponseBody
	public String getEvalJang(@RequestParam Map<String, Object> map, HttpServletRequest request) {
		logger.debug("getEvalJang");
		
		return evalService.getEvalJang(map);
		
	}

	/**
	 * 2020. 7. 10.
	 * yh
	 * :양식단계별 저장(전 체크 )
	 */
	@RequestMapping(value = "/eval/setSignSetpChk", method = RequestMethod.POST)
	@ResponseBody
	public String setSignSetpChk(@RequestParam Map<String, Object> map, HttpServletRequest request) {
		logger.debug("setSignSetpChk");

		return evalService.setSignSetpChk(map);
	}

	/**
	 * 2020. 7. 10.
	 * yh
	 * :양식단계별 저장
	 */
	@RequestMapping(value = "/eval/setSignSetp", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> setSignSetp(@RequestParam Map<String, Object> map) {
		logger.debug("setSignSetp");

		return evalService.setSignSetp(map);
	}

	@RequestMapping(value = "/eval/getEvalConfirmChk", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> getEvalConfirmChk(@RequestParam Map<String, Object> map) {
		logger.debug("getEvalConfirmChk");
		return evalService.getEvalConfirmChk(map);
		
	}
	

	@RequestMapping(value = "/eval/evalJangConfirmChk", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalJangConfirmChk(@RequestParam Map<String, Object> map) {
		logger.debug("evalJangConfirmChk");
		
		return evalService.getEvalchk(map);
		
	}

	@RequestMapping(value = "/eval/evalResultList", method = RequestMethod.POST) 
	@ResponseBody
	public Map<String, Object> evalResultList(@RequestParam Map<String, Object> map, HttpServletRequest request) {
		logger.debug("evalResultList");
		
		return evalService.evalResultList(map);
		
	}
	
	@RequestMapping(value = "/eval/sign4ViewForm", method = RequestMethod.GET)
	public String sign4ViewForm(@RequestParam Map<String, Object> map, Model model) {
		
		model.addAttribute("userInfo", evalService.getEvalchk(map));
		
		return "/eval/sign/evalSign4"; 
		
	}

	@RequestMapping(value = "/eval/sign3ViewForm", method = RequestMethod.GET)
	public String sign3ViewForm(@RequestParam Map<String, Object> map, Model model) {
		
		model.addAttribute("userInfo", evalService.getEvalchk(map));
		
		return "/eval/sign/evalSign3"; 
		
	}
	
	@RequestMapping(value = "/eval/noticePopup", method = RequestMethod.GET)
	public String noticePopup(@RequestParam Map<String, Object> map, Model model) {

		return "/eval/popup/noticePopup";
		
	}

	@RequestMapping(value = "/eval/notice", method = RequestMethod.GET)
	public String notice(HttpServletRequest request, Model model) {
		Map<String, Object> map = (Map<String, Object>) request.getSession().getAttribute("evalLoginVO");
		map = evalService.getEvalchk(map);
//		logger.debug(request);
		//로그인 기본 정보가져오기
		model.addAttribute("userInfo", map);

		return "/eval/notice";
	}

    @RequestMapping("/eval/setSign")
    @ResponseBody
    public Map<String, Object> evalSaveImage(@RequestParam Map<String, Object> map, HttpServletRequest request){
        Map<String, Object> result = new HashMap<>();
		evalService.setSign(map, signFilePathF(request, map, SERVER_DIR));
        return result;
    }

    @RequestMapping("/eval/popEvalSign")
    public String popEvalSign(@RequestParam Map<String, Object> map, Model model){
		model.addAttribute("params", map);
        return "/evalSign";
    }

	/**
	 * yh
	 * 2021. 9. 11.
	 * :평가 다시 진행
	 */
	@RequestMapping(value = "/eval/evalMod", method = RequestMethod.POST)
	@ResponseBody
	public String evalMod(@RequestParam Map<String, Object> map) {
		
		return evalService.evalMod(map);
	}

	@RequestMapping(value = "/eval/evalAvoidPopup", method = RequestMethod.GET)
	public String evalAvoidPopup() {
		return "/eval/popup/evalAvoidPopup";
	}

	/**
	 * :평가위원장 평가저장시 평가위원 평가진행중인지 체크
	 * @throws Exception
	 */
	@RequestMapping(value = "/eval/getCommissionerChk")
	@ResponseBody
	public Map<String, Object> getCommissionerChk(@RequestParam Map<String, Object> map) {
		return evalService.getCommissionerChk(map);
	}

	/**
	 * :평가위원 서명파일 다운로드
	 * @throws Exception
	 */
	@RequestMapping(value = "/eval/makeZipFile")
	@ResponseBody
	public Map<String, Object> evalProposalModFileDownload(@RequestParam Map<String, Object> map, HttpServletRequest request, HttpServletResponse response) {
		logger.debug("evalProposalModFileDownload");
//		evalService.evalProposalModFileDownload(map, signFilePathF(request, map, SERVER_DIR), request, response);
        return evalService.makeZipFile(map, request, response);
	}

	@RequestMapping(value = "/eval/setScoreData")
	@ResponseBody
	public void setScoreData(@RequestParam Map<String, Object> params){
		evalService.setScoreData(params);
	}

	public String signFilePathF(HttpServletRequest servletRequest, Map<String, Object> params, String baseDir){
		String path = "";

		path = baseDir + "cust_eval/" + params.get("commissioner_seq").toString() + "/sign";

		if(servletRequest.getServerName().contains("localhost") || servletRequest.getServerName().contains("127.0.0.1") || servletRequest.getServerName().contains("121.186.165.80")){
			path = "/home" + path;
		}else{
			path = "/data" + path;
		}

		return path;
	}
}
