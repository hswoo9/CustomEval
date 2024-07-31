package com.duzon.custom.eval.service.impl;

import java.awt.image.BufferedImage;
import java.io.*;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import com.duzon.custom.common.utiles.CommFileUtil;
import com.duzon.custom.common.utiles.EgovStringUtil;
import com.duzon.custom.common.vo.PdfEcmFileVO;
import com.duzon.custom.common.vo.PdfEcmMainVO;
import com.itextpdf.text.Document;
import com.itextpdf.text.pdf.*;
import org.apache.commons.lang.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.duzon.custom.attachFile.service.AttachFileService;
import com.duzon.custom.eval.dao.EvalDAO;
import com.duzon.custom.eval.service.EvalService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import sun.misc.BASE64Decoder;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@Service
public class EvalServiceImpl implements EvalService {

	private static final Logger logger = LoggerFactory.getLogger(EvalServiceImpl.class);

	private String[] invalidName = {"\\\\","/",":","[*]","[?]","\"","<",">","[|]"};

	@Autowired
	private EvalDAO evalDAO;

	@Autowired
	private AttachFileService af;

	@Override
	public Map<String, Object> setSign(Map<String, Object> map, String serverDir) {
		Map<String, Object> result = new HashMap<String, Object>();

		try {
			BASE64Decoder decoder = new BASE64Decoder();
			byte[] imgByte = decoder.decodeBuffer((String) map.get("sign"));

			CommFileUtil commFileUtil = new CommFileUtil();
			Map<String, Object> signDirMap = commFileUtil.setServerIFSave(serverDir, imgByte, map.get("commissioner_seq") + "_sign");
			map.put("signDir", signDirMap.get("signDir").toString().replace("\\\\", "//").replace("\\", "/"));
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		result.put("result", "success");
		evalDAO.setSignDir(map);

		return result;
	}

	@Override
	public Map<String, Object> getEvalchk(Map<String, Object> map) {

		//1. 평가가 있는지, 평가를 했는지 조회
		Map<String, Object> data = evalDAO.getEvalchk(map);

		return data;
	}

	@Override
	public List<Map<String, Object>> getResultList(Map<String, Object> map) {
		return evalDAO.getResultList(map);
	}

	@Override
	public List<Map<String, Object>> getCompanyList(Map<String, Object> map) {
		return evalDAO.getCompanyList(map);
	}

	@Override
	public List<Map<String, Object>> getItemList(Map<String, Object> map) {
		return evalDAO.getItemList(map);
	}
	@Override
	public List<Map<String, Object>> getItemList2(Map<String, Object> map) {
		return evalDAO.getItemList2(map);
	}

	@Override
	public void evalViewSave(Map<String, Object> map) {

		Gson gson = new Gson();
		List<Map<String, Object>> list = gson.fromJson((String) map.get("list"),new TypeToken<List<Map<String, Object>>>(){}.getType() );
		List<Map<String, Object>> remark = gson.fromJson((String) map.get("remark"),new TypeToken<List<Map<String, Object>>>(){}.getType() );

		if(map.get("jang").equals("Y")){
			evalDAO.setEvalConfirm(map);
		}

		for (Map<String, Object> vo : list) {
			evalDAO.setEvalViewUpdate(vo);
		}

		for (Map<String, Object> vo : remark) {
			evalDAO.setEvalComRemarkUpdate(vo);
		}

		evalDAO.evalSaveUpdate(map);

	}

	@Override
	public List<Map<String, Object>> getCompanyRemarkList(Map<String, Object> map) {
		return evalDAO.getCompanyRemarkList(map);
	}

	@Override
	public List<Map<String, Object>> getCommissionerList(Map<String, Object> map) {
		return evalDAO.getCommissionerList(map);
	}

	@Override
	public String setCommSave(Map<String, Object> map) {

		String result = "N";

		//투표 카운트 +1 하기
		evalDAO.setCommSave(map);

		//로그인 유저 투표 여부 업데이트
		evalDAO.setCommjangChk(map);

		//누가 위원장인가? 투표가 끝났으면 위원장 체크하기
		Map<String, Object> chkList = evalDAO.getChkList(map);
		String userCnt = String.valueOf(chkList.get("userCnt"));
		String cnt = String.valueOf(chkList.get("cnt"));

		if( userCnt.equals(cnt) ){
			evalDAO.setJangUpdate(map);
			evalDAO.setEvalJangCntCn(map);
			result = "Y";
		}

		return result;
	}

	@Override
	public String getEvalJang(Map<String, Object> map) {
		return evalDAO.getEvalJang(map);
	}

	@Override
	public String setSignSetpChk(Map<String, Object> map) {
		map.put("sign2Chk", "sign2Chk");
		String stpe = String.valueOf(map.get("step"));

		//상태값 변경
		evalDAO.setSignSetp(map);

		if(stpe.equals("2")){
			Map<String, Object> commissionerMinteList = evalDAO.getEvalCommissionerEvalMinuteChk(map);

			int total = Integer.parseInt(commissionerMinteList.get("TOTAL_COMMISSIONER").toString());
			int minute1 = Integer.parseInt(commissionerMinteList.get("MINUTE1_IS_NULL_TOTAL").toString());
			int minute1Group = Integer.parseInt(commissionerMinteList.get("MINUTE1_GROUP").toString());
			if (total != minute1) {
				return "nullFail"; 
			} else if (minute1Group != 1) {
				evalDAO.getEvalMinuteChKGroupFailUpd(map);
				return "groupFail";
			}
		}else if (stpe.equals("99")){
			evalDAO.getEvalMinuteChKGroupFailUpd2(map);
		}

		return "notFail";
	}



		public Map<String, Object> setSignSetp(Map<String, Object> map) {
			Map<String, Object> returnMap = new HashMap<String, Object>();

			String step = String.valueOf(map.get("step"));

			map.put("col_nm", "sign_" + step);
			map.put("col_file", "sign_" + step + "_file_seq");

			// Step에 따른 파일 이름 매핑
			String fileName;
			switch (step) {
				case "1":
					fileName = "평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서";
					break;
				case "2":
					fileName = "평가위원 사전의결사항";
					break;
				case "3":
					fileName = "사전접촉여부 확인(신고)서";
					break;
				case "4":
					fileName = "평가수당 지급 확인서";
					break;
				case "5":
					fileName = "평가위원 개인정보 수집·이용 동의서";
					break;
				case "6":
					fileName = "위원별 제안서 평가표";
					break;
				case "7":
					fileName = "업체별 제안서 평가집계표";
					break;
				case "8":
					fileName = "제안서 평가 총괄표";
					break;
				case "9":
					fileName = "사전접촉여부 확인(신고)서 한번더";
					break;
				case "10":
					fileName = "평가위원장 가산금 지급 확인서";
					break;
				default:
					fileName = "기타"; // Default case for safety
			}

			// file 저장
			map.put("attch_file_seq", fileName);

			if (!EgovStringUtil.nullConvert(map.get("signHwpFileData")).equals("")) {
				try {
					CommFileUtil commFileUtil = new CommFileUtil();
					commFileUtil.setServerSFSave(EgovStringUtil.nullConvert(map.get("signHwpFileData")), (String) map.get("commissioner_seq"), fileName, "hwp");

					PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
					pdfEcmFileVO.setRep_id(fileName);
					pdfEcmFileVO.setComp_seq("1000");
					pdfEcmFileVO.setDoc_id(fileName);
					pdfEcmFileVO.setDoc_no("001");
					pdfEcmFileVO.setDoc_path("Z:/upload/epis/cust_eval/" + map.get("commissioner_seq") + "/hwp");
					pdfEcmFileVO.setDoc_name(fileName);
					pdfEcmFileVO.setDoc_ext("hwp");
					pdfEcmFileVO.setDoc_title("sign_" + step);

					PdfEcmMainVO pdfEcmMainVO = new PdfEcmMainVO();

					pdfEcmMainVO.setRep_id(fileName);
					pdfEcmMainVO.setComp_seq("1000");
					pdfEcmMainVO.setDept_seq("1");
					pdfEcmMainVO.setEmp_seq("1");
					pdfEcmMainVO.setPdf_path("Z:/upload/epis/cust_eval/" + map.get("commissioner_seq") + "/pdf");
					pdfEcmMainVO.setPdf_name("PDF_" + fileName);
					pdfEcmMainVO.setStatus_cd("D0001");

					evalDAO.insertPdfFile(pdfEcmFileVO);
					evalDAO.insertPdfMain(pdfEcmMainVO);
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				returnMap.put("result", "fail");
				return returnMap;
			}

			// 상태값 변경
			evalDAO.setSignSetp(map);

			if (step.equals("9") && map.get("flag").equals("Y")) {
				// 사전접촉이 있으면 평가비용 5만원으로 변경
				evalDAO.setEvalPayUpdate(map);
			} else if (step.equals("4")) {
				// 수당 개인정보 업데이트
				evalDAO.setCommDetailUpdate(map);
			} else if (step.equals("8")) {
				// 평가확정
				evalDAO.setEvalJangConfirm(map);

				if (map.get("join_select_type").equals("Y")) {
					evalDAO.setPurcReqUpdate(map);
				}
			} else if (step.equals("10")) {
				Map<String, Object> coms = evalDAO.getEvalCommittee2(map);
				coms.put("COMMITTEE_SEQ", coms.get("committee_seq"));

				Map<String, Object> coms2 = evalDAO.getEvalCommittee(coms);

				map.put("evalCm", coms2.get("eval_cm"));
				evalDAO.setJangEvalPayUpdate(map);
			}

			returnMap.put("result", "success");
			return returnMap;
		}



	@Override
	public Map<String, Object> getEvalJangData(Map<String, Object> map) {
		return evalDAO.getEvalJangData(map);
	}

	@Override
	public Map<String, Object> getEvalConfirmChk(Map<String, Object> map) {

		//rank_code 업데이트 프로시저 호출
		evalDAO.setRankCode(map);

		List<Map<String, Object>> userList = evalDAO.getCommissionerList(map);

		String score_yn = (String) userList.get(0).get("SCORE_YN");

		int userCnt = 0;
		//실제 평가위원 수
		for (Map<String, Object> map2 : userList) {
			if(map2.get("contact").equals("N") && map2.get("eval_avoid").equals("N")){
				userCnt++;
			}
		}

		map.put("userCnt", userCnt);
		map.put("score_yn", score_yn);

		//평점구하기 위한 평가위원 수 
		//5명 이하일 경우 모두 
		//그외 최상 최하 빼기 위해 두명 제외
		if(userCnt > 5){
			map.put("userCntTotal", userCnt-2);
		}else if(score_yn.equals("Y")) {
			map.put("userCntTotal", userCnt-2);
			/*map.put("userCnt", userCnt-2);*/
		}else{
			map.put("userCntTotal", userCnt);
		}

		List<Map<String, Object>> col = evalDAO.getItemColList(map);
		map.put("colList", col);

		List<Map<String, Object>> list = evalDAO.getEvalConfirmData(map);

		map.put("list", list);

		map.put("chk", "Y");

		return map;
	}

	@Override
	public List<Map<String, Object>> getEvalCompany(Map<String, Object> map) {
		return evalDAO.getEvalCompany(map);
	}

	@Override
	public Map<String, Object> evalResultList(Map<String, Object> map) {

		Map<String, Object> result = new HashMap<String, Object>();

		//rank_code 업데이트 프로시저 호출
//		evalDAO.setRankCode(map);

		List<Map<String, Object>> userList = evalDAO.getCommissionerList(map);

		String score_yn = (String) userList.get(0).get("SCORE_YN");

		int userCnt = 0;
		//실제 평가위원 수
		for (Map<String, Object> map2 : userList) {
			if(map2.get("contact").equals("N") && map2.get("eval_avoid").equals("N")){
				userCnt++;
			}
		}

		map.put("userCnt", userCnt);
		map.put("score_yn", score_yn);

		//평점구하기 위한 평가위원 수 
		//5명 이하일 경우 모두 
		//그외 최상 최하 빼기 위해 두명 제외
		if(userCnt > 5){
			map.put("userCntTotal", userCnt-2);
		}else if(score_yn.equals("Y")) {
			map.put("userCntTotal", userCnt-2);
			/*map.put("userCnt", userCnt-2);*/
		}else{
			map.put("userCntTotal", userCnt);
		}

		List<Map<String, Object>> col = evalDAO.getItemColList(map);
		map.put("colList", col);
		result.put("colList", col);

		List<Map<String, Object>> list = evalDAO.getEvalResultList(map);
		result.put("list", list);

		Map<String, Object> total = evalDAO.getEvalResultTotal(map);
		result.put("total", total);

		List<Map<String, Object>> sumList = evalDAO.getEvalConfirmData(map);
		result.put("sumList", sumList);

		return result;
	}

	@Override
	public void setEvalPassword() {
		evalDAO.setEvalPassword();
	}

	@Override
	public void setEvalIdDel() {
		//삭제전 로그에 등록
		evalDAO.setEvalIdDelLog();
		//삭제
		evalDAO.setEvalIdDel();
	}

	@Override
	public String getCommitteeJangName(Map<String, Object> map) {
		return evalDAO.getCommitteeJangName(map);
	}

	@Override
	public List<Map<String, Object>> getCompanyTotal(Map<String, Object> map) {
		return evalDAO.getCompanyTotal(map);
	}

	@Override
	public String evalMod(Map<String, Object> map) {

		String cf = evalDAO.evalConfirmYn(map);

		if(cf.equals("N")){
			evalDAO.evalMod(map);
		}

		return cf;
	}

	@Override
	public void setEvalAvoidY(Map<String, Object> params) {
		evalDAO.setEvalAvoidY(params);
		if(params.get("EVAL_JANG").equals("Y")){
			evalDAO.setEvalJangReSelected(params);
		}
	}

	@Override
	public Map<String, Object> getEvalCommittee(Map<String, Object> params) {
		return evalDAO.getEvalCommittee(params);
	}

	@Override
	public void evalProposalModFileDownload(Map<String, Object> map, String serverDir, HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> fileList = evalDAO.evalProposalModFileDownload(map);
		Map<String, Object> fileName = new HashMap<>();

		List<String> fileNameList = new ArrayList<String>();

		String serverFilePath = serverDir + "/";
		String fileZipName = fileList.get("commissioner_seq") + ".zip"; //저장할 압축파일명

		String sign_1 = (String) fileList.get("sign_1");
		String sign_2 = (String) fileList.get("sign_2");
		String sign_3 = (String) fileList.get("sign_3");
		String sign_4 = (String) fileList.get("sign_4");
		String sign_5 = (String) fileList.get("sign_5");
		String sign_6 = (String) fileList.get("sign_6");
		String sign_7 = (String) fileList.get("sign_7");
		String sign_8 = (String) fileList.get("sign_8");
		String sign_9 = (String) fileList.get("sign_9");
		String sign_10 = (String) fileList.get("sign_10");

		for(int i = 1; i < 10; i++) {
			fileName.put("sign_"+i+"_file_seq", fileList.get("sign_"+i+"_file_seq"));
			fileNameList.add((String)fileList.get("sign_"+i+"_file_seq"));
		}

		// ZipOutputStream을 FileOutputStream 으로 감쌈
		// 파일압축 시작
		FileOutputStream fout = null;
		ZipOutputStream zout = null;
		try{
			fout = new FileOutputStream(serverFilePath + fileZipName); //지정경로에 + 지정이름으로
			zout = new ZipOutputStream(fout);

			List pdfs = new ArrayList<FileInputStream>();

			if(sign_1.equals("Y")) {
				/** pdf 문제로 hwp 로 파일 변경*/
				File signFile = new File(serverFilePath +fileList.get("sign_1_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서.hwp")); // 압축파일에 저장될 파일명

				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_2.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_2_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원 사전의결사항.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원 사전의결사항.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_3.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_3_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_사전접촉여부 확인(신고)서1.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_사전접촉여부 확인(신고)서1.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_4.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_4_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가수당 지급 확인서.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가수당 지급 확인서.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_5.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_5_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원 개인정보 수집·이용 동의서.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원 개인정보 수집·이용 동의서.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_6.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_6_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_위원별 제안서 평가표.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_위원별 제안서 평가표.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_7.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_7_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_업체별 제안서 평가집계표.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_업체별 제안서 평가집계표.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_8.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_8_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_제안서 평가 총괄표.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_제안서 평가 총괄표.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_9.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_9_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_사전접촉여부 확인(신고)서2.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_사전접촉여부 확인(신고)서2.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}
			if(sign_10.equals("Y")) {
				File signFile = new File(serverFilePath +fileList.get("sign_10_file_seq") + ".hwp");

				pdfs.add(new FileInputStream(signFile));
				FileInputStream fin = new FileInputStream(signFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원장 가산금 지급 확인서.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME")+ "_평가위원장 가산금 지급 확인서.hwp")); // 압축파일에 저장될 파일명
				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				// input file을 바이트로 읽음, zip stream에 읽은 바이트를 씀
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length); //읽은 파일을 ZipOutputStream에 Write
				}

				zout.closeEntry();
				fin.close();
			}

			/** pdf 문제로 hwp 로 파일 변경*/
//			File tempFile = File.createTempFile((String)fileList.get("NAME") + "_통합자료", ".pdf", new File(serverFilePath));
			File tempFile = File.createTempFile((String)fileList.get("NAME") + "_통합자료", ".hwp", new File(serverFilePath));
			if(tempFile.exists()){
				OutputStream output = new FileOutputStream(tempFile);
				concatPDFs(pdfs, output, true);

				FileInputStream fin = new FileInputStream(tempFile); // 압축대상 파일
				/** pdf 문제로 hwp 로 파일 변경*/
//				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME") + "_통합자료.pdf")); // 압축파일에 저장될 파일명
				zout.putNextEntry(new ZipEntry((String)fileList.get("NAME") + "_통합자료.hwp")); // 압축파일에 저장될 파일명

				int length;
				int size = fin.available();
				byte[] buffer = new byte[size];
				while((length = fin.read(buffer)) > 0){
					zout.write(buffer, 0, length);
				}
				zout.closeEntry();
				fin.close();
				tempFile.deleteOnExit();
			}

		}catch(Exception ioe){
			ioe.printStackTrace();
		}finally {
			try {
				zout.close();
				fout.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		File downFile = new File(serverFilePath + fileZipName);
		FileInputStream in = null;
		String downFileName = fileList.get("TITLE") +"_"+ fileList.get("NAME") + ".zip";
		try {
			try {
				in = new FileInputStream(downFile);
			} catch ( Exception e ) {
				e.printStackTrace();
			}

			response.setContentType( "application/x-msdownload" );
			response.setHeader( "Content-Disposition", "attachment; filename=\""+ new String(downFileName.getBytes("euc-kr"),"iso-8859-1") + "\"" );
			response.setHeader( "Content-Transfer-Coding", "binary" );
			if(downFile != null)
				response.setHeader( "Content-Length", downFile.length()+"" );
			else
				response.setHeader( "Content-Length", "0" );

			CommFileUtil.outputStream(response, in);
		}catch(Exception e ) {
			e.printStackTrace() ;
		}
	}

	@Override
	public Map<String, Object> makeZipFile(Map<String, Object> params, HttpServletRequest request, HttpServletResponse response) {
		Map<String, Object> fileMap = evalDAO.evalProposalModFileDownload(params);
		List<Map<String, Object>> fileList = new ArrayList<>();

		for(int i = 1; i < 11; i++){
			Map<String, Object> map = new HashMap<>();

			if(fileMap.get("sign_"+i).equals("Y")) {
				if(i == 1){
					map.put("fileName", fileMap.get("NAME") + "_평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서");
				}else if(i == 2){
					map.put("fileName", fileMap.get("NAME") + "_평가위원 사전의결사항");
				}else if(i == 3){
					map.put("fileName", fileMap.get("NAME") + "_사전접촉여부 확인(신고)서1");
				}else if(i == 4){
					map.put("fileName", fileMap.get("NAME") + "_평가수당 지급 확인서");
				}else if(i == 5){
					map.put("fileName", fileMap.get("NAME") + "_평가위원 개인정보 수집·이용 동의서");
				}else if(i == 6){
					map.put("fileName", fileMap.get("NAME") + "_위원별 제안서 평가표");
				}else if(i == 7){
					map.put("fileName", fileMap.get("NAME") + "_업체별 제안서 평가집계표");
				}else if(i == 8){
					map.put("fileName", fileMap.get("NAME") + "_제안서 평가 총괄표");
				}else if(i == 9){
					map.put("fileName", fileMap.get("NAME") + "_사전접촉여부 확인(신고)서2");
				}else if(i == 10){
					map.put("fileName", fileMap.get("NAME") + "_평가위원장 가산금 지급 확인서");
				}
				fileList.add(map);
			}
		}

		/**
		 * pdf 솔루션 통합본 생성
		 */

//        for(int i = 0; i < fileList.size(); i++){
//            PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
//            pdfEcmFileVO.setRep_id("EVAL_" + fileMap.get("committee_seq") + "_" + fileMap.get("commissioner_seq"));
//
//            pdfEcmFileVO.setComp_seq("1000");
//            pdfEcmFileVO.setDoc_id("EVAL_" + fileMap.get("committee_seq") + "_" + fileMap.get("commissioner_seq"));
//            pdfEcmFileVO.setDoc_no("00" + (i+1));
//            pdfEcmFileVO.setDoc_path("Z:/upload/epis/cust_eval/" + fileMap.get("commissioner_seq") + "/pdf");
//            pdfEcmFileVO.setDoc_name((String) fileList.get(i).get("fileName"));
//            pdfEcmFileVO.setDoc_ext("pdf");
//            pdfEcmFileVO.setDoc_title((String) fileList.get(i).get("fileName"));
//
//            evalDAO.insertPdfFile(pdfEcmFileVO);
//        }
//
//        PdfEcmMainVO pdfEcmMainVO = new PdfEcmMainVO();
//        pdfEcmMainVO.setRep_id("EVAL_" + fileMap.get("committee_seq") + "_" + fileMap.get("commissioner_seq"));
//        pdfEcmMainVO.setComp_seq("1000");
//        pdfEcmMainVO.setDept_seq("1");
//        pdfEcmMainVO.setEmp_seq("1");
//        pdfEcmMainVO.setPdf_path("Z:/upload/epis/cust_eval/" + fileMap.get("commissioner_seq") + "/pdf");
//        pdfEcmMainVO.setPdf_name("PDF_" + fileMap.get("NAME") + "_통합자료");
//        pdfEcmMainVO.setStatus_cd("D0001");
//
//        evalDAO.insertPdfMain(pdfEcmMainVO);

		/**
		 * pdf 솔루션 통합본 생성 종료
		 */

		/** pdf 변환 솔루션 파일경로 */
//        String zipDir = "/home/upload/epis/cust_eval/" + fileMap.get("commissioner_seq") + "/pdf";
//		String returnZipDir = "/upload/epis/cust_eval/" + fileMap.get("commissioner_seq") + "/pdf";
		String zipDir = "/home/upload/cust_eval/" + fileMap.get("commissioner_seq") + "/hwp";
		String returnZipDir = "/upload/cust_eval/" + fileMap.get("commissioner_seq") + "/hwp";
		try {
			CommFileUtil commFileUtil = new CommFileUtil();
			returnZipDir = commFileUtil.setMakeZipFileDown(zipDir, returnZipDir, fileMap.get("TITLE") +"_"+ fileMap.get("NAME") + ".zip");
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		Map<String, Object> returnMap = new HashMap<>();
		returnMap.put("result", "success");
		returnMap.put("zipDir", returnZipDir);

		return returnMap;
	}

	@Override
	public void setScoreData(Map<String, Object> params) {
		Gson gson = new Gson();

		List<Map<String, Object>> list =  gson.fromJson(params.get("itemScoreList").toString(),new TypeToken<List<Map<String, Object>>>(){}.getType() );
		for(Map<String, Object> map : list){
			evalDAO.setScoreData(map);
		}
	}

	@Override
	public Map<String, Object> getCommissionerChk(Map<String, Object> params) {
		Map<String, Object> returnMap = new HashMap<>();
		boolean returnBoolean = true;
		List<Map<String, Object>> commissionerList = evalDAO.getCommissionerChk(params);

		for(Map<String, Object> commissioner : commissionerList){
			if(commissioner.get("eval_save").equals("N") || commissioner.get("sign_6").equals("N")){
				returnBoolean = false;
			}
		}

		returnMap.put("commissionerChk", returnBoolean);

		return returnMap;
	}

	@Override
	public Map<String, Object> getEvalAvoidFailChk(Map<String, Object> params) {
		return evalDAO.getEvalAvoidFailChk(params);
	}

	@Override
	public void setEvalCommissionerBlindUpd(Map<String, Object> params) {
		evalDAO.setEvalCommissionerBlindUpd(params);
	}

	public static void concatPDFs(List<InputStream> streamOfPDFFiles,
								  OutputStream outputStream, boolean paginate) {

		Document document = new Document();
		try {
			List<InputStream> pdfs = streamOfPDFFiles;
			List<PdfReader> readers = new ArrayList<PdfReader>();
			int totalPages = 0;
			Iterator<InputStream> iteratorPDFs = pdfs.iterator();

			// Create Readers for the pdfs.
			while (iteratorPDFs.hasNext()) {
				InputStream pdf = iteratorPDFs.next();
				PdfReader pdfReader = new PdfReader(pdf);
				readers.add(pdfReader);
				totalPages += pdfReader.getNumberOfPages();
			}
			// Create a writer for the outputstream
			PdfWriter writer = PdfWriter.getInstance(document, outputStream);

			document.open();
			BaseFont bf = BaseFont.createFont(BaseFont.HELVETICA,
					BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			PdfContentByte cb = writer.getDirectContent(); // Holds the PDF
			// data

			PdfImportedPage page;
			int currentPageNumber = 0;
			int pageOfCurrentReaderPDF = 0;
			Iterator<PdfReader> iteratorPDFReader = readers.iterator();

			// Loop through the PDF files and add to the output.
			while (iteratorPDFReader.hasNext()) {
				PdfReader pdfReader = iteratorPDFReader.next();

				// Create a new page in the target for each source page.
				while (pageOfCurrentReaderPDF < pdfReader.getNumberOfPages()) {
					document.newPage();
					pageOfCurrentReaderPDF++;
					currentPageNumber++;
					page = writer.getImportedPage(pdfReader,
							pageOfCurrentReaderPDF);
					cb.addTemplate(page, 0, 0);

					// Code for pagination.
					if (paginate) {
						cb.beginText();
						cb.setFontAndSize(bf, 9);
						cb.showTextAligned(PdfContentByte.ALIGN_CENTER, ""
										+ currentPageNumber + " of " + totalPages, 520,
								5, 0);
						cb.endText();
					}
				}
				pageOfCurrentReaderPDF = 0;
			}
			outputStream.flush();
			document.close();
			outputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (document.isOpen())
				document.close();
			try {
				if (outputStream != null)
					outputStream.close();
			} catch (IOException ioe) {
				ioe.printStackTrace();
			}
		}
	}

	@Override
	public List<Map<String, Object>> getSignList(Map<String, Object> params){
		return evalDAO.getSignList(params);
	}
}