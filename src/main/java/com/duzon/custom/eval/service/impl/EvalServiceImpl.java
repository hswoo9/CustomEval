package com.duzon.custom.eval.service.impl;

import com.duzon.custom.attachFile.service.AttachFileService;
import com.duzon.custom.common.utiles.CommFileUtil;
import com.duzon.custom.common.utiles.EgovStringUtil;
import com.duzon.custom.common.vo.PdfEcmFileVO;
import com.duzon.custom.common.vo.PdfEcmMainVO;
import com.duzon.custom.eval.dao.EvalDAO;
import com.duzon.custom.eval.service.EvalService;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.itextpdf.text.Document;
import com.itextpdf.text.pdf.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.file.*;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;


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
			System.out.println("===================[ 1 ]====================");
			byte[] imgByte = Base64.getDecoder().decode((String) map.get("sign"));
			String originFileExt = "png";
			String fileName = map.get("commissioner_seq").toString() + "_sign";
			System.out.println("===================[ 2 ]====================");
			File lOutFile = File.createTempFile(fileName, "." + originFileExt);
			BufferedImage image = ImageIO.read(new ByteArrayInputStream(imgByte));
			ImageIO.write(image, originFileExt, lOutFile);
			System.out.println("===================[ 3 ]====================");
			File newPath = new File(serverDir);
			if (!newPath.exists()) {
				newPath.mkdirs();
			}
			System.out.println("===================[ 4 ]====================");
			Path path = Paths.get(serverDir + "/" + fileName + "." + originFileExt);
			Files.copy(new FileInputStream(lOutFile), path, new CopyOption[]{StandardCopyOption.REPLACE_EXISTING});
			System.out.println("===================[ 5 ]====================");
			String signDir = "http:\\\\1.233.95.140:58090\\upload\\cust_eval\\" + fileName.replaceAll("_sign", "") + "\\sign\\" + fileName + ".png";

			HttpServletRequest servletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();

			if(servletRequest.getServerName().contains("10.10.10.114") || servletRequest.getServerName().contains("one.epis.or.kr")) {
				signDir = "http:\\\\10.10.10.114\\upload\\cust_eval\\" + fileName.replaceAll("_sign", "") + "\\sign\\" + fileName + ".png";
			}

			map.put("signDir", signDir.toString().replace("\\\\", "//").replace("\\", "/"));

			/*CommFileUtil commFileUtil = new CommFileUtil();
			Map<String, Object> signDirMap = commFileUtil.setServerIFSave(serverDir, imgByte, map.get("commissioner_seq") + "_sign");
			map.put("signDir", signDirMap.get("signDir").toString().replace("\\\\", "//").replace("\\", "/"));*/
		} catch (Exception e) {
			e.printStackTrace();
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
	public List<Map<String, Object>> getevalNotice(Map<String, Object> map) {
		return evalDAO.getevalNotice(map);
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
		//투표자 seq 입력
		evalDAO.setEvalJangNo(map);

		//로그인 유저 투표 여부 업데이트
		//evalDAO.setCommjangChk(map);

		//누가 위원장인가? 투표가 끝났으면 위원장 체크하기
		Map<String, Object> chkList = evalDAO.getChkList(map);
		String userCnt = String.valueOf(chkList.get("userCnt"));
		String cnt = String.valueOf(chkList.get("cnt"));

		if( userCnt.equals(cnt) ){
			List<Object> jangCntList = evalDAO.getJangCnt(map);
			System.out.println("*****jangCntList.size()****"+jangCntList.size());
			System.out.println("*****jangCntList****"+jangCntList);
			if (jangCntList.size() == 1) {
				Object updateSeq = jangCntList.get(0);
				System.out.println("*****updateSeq****"+updateSeq);
				//Object updateSeq = jangCnt.get("COMMISSIONER_SEQ");

				Map<String, Object> jangCntMap = new HashMap<>();
				jangCntMap.put("updateSeq",updateSeq);

				evalDAO.setJangUpdate(jangCntMap);
				//evalDAO.setEvalJangCntCn(map);
				result = "Y";

			}else if (jangCntList.size() > 1) {
				evalDAO.setEvalJangChkTie(map);
				evalDAO.setEvalJangCntCn(map);
				result = "O";
			}
		}

		return result;
	}

	@Override
	public String getEvalJang(Map<String, Object> map) {
		String result = "";

		String evalJangYN = evalDAO.getEvalJang(map);

		if(evalJangYN.equals("N")){
			String evalJangChkYN = evalDAO.getEvalTieChk(map);
			//evalDAO.setEvalJangReSelected(map);
			if(evalJangChkYN.equals("N")){
				result = "N";
			}else if (evalJangChkYN.equals("Y")){
				//evalDAO.setEvalJangReSelected(map);
				result = "O";
			}
		}else if(evalJangYN.equals("Y")){
			result = "Y";
		}

		return result;
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
			int minute1Group2 = Integer.parseInt(commissionerMinteList.get("MINUTE1_GROUP2").toString());
			if (total != minute1) {
				return "nullFail"; 
			} else if (minute1Group != 1 || minute1Group2 != 1) { 
				evalDAO.getEvalMinuteChKGroupFailUpd(map);
				return "groupFail";
			}
		}else if (stpe.equals("99")){
			evalDAO.getEvalMinuteChKGroupFailUpd2(map);
		}

		return "notFail";
	}

	@Override
	public void setCommissionerSign9(Map<String, Object> map) {
		//상태값 변경
		evalDAO.setCommissionerSign9(map);
	}

	@Override
	public String getCommissionerSign9Chk(Map<String, Object> map) {

		String status = "Y";

		int sign9Cnt = evalDAO.getCommissionerSign9Cnt(map);

		if(sign9Cnt > 0) {
			status = "N";
		}

		return status;
	}

	@Override
	public Map<String, Object> setSignSetp(Map<String, Object> map) {
		Map<String, Object> returnMap = new HashMap<String, Object>();

		String step = String.valueOf(map.get("step"));


		map.put("col_nm", "sign_" + step);
		map.put("col_file", "sign_" + step + "_file_seq");

		Map<String, Object> comSeq = new HashMap<String, Object>();
		comSeq.put("commissioner_seq", map.get("commissioner_seq"));
		String evalId = evalDAO.getCommissionerSeqEvalId(comSeq);
		List<Map<String, Object>> duplIdList = evalDAO.getDuplId(comSeq);


		if (duplIdList != null && !duplIdList.isEmpty()) {
			Map<String, Integer> nameCountMap = new HashMap<>();

			// 이름 중복 여부 확인
			for (Map<String, Object> item : duplIdList) {
				String currentEvalId = String.valueOf(item.get("EVAL_ID"));
				nameCountMap.put(currentEvalId, nameCountMap.getOrDefault(currentEvalId, 0) + 1);
			}

			for (Map<String, Object> item : duplIdList) {
				String commissionerSeq = String.valueOf(item.get("COMMISSIONER_SEQ"));
				String currentEvalId = String.valueOf(item.get("EVAL_ID"));
				String evalPhone = String.valueOf(item.get("EVAL_PHONE"));

				if (nameCountMap.get(currentEvalId) > 1 &&
						currentEvalId.equals(evalId) &&
						commissionerSeq.equals(String.valueOf(comSeq.get("commissioner_seq")))) {
					evalId = currentEvalId + "(" + evalPhone.substring(evalPhone.length() - 4) + ")";
					break;
				}
			}
		}

		if (map.containsKey("jangYN")) {
			step += "_jang";
		}

		// Step에 따른 파일 이름 매핑
		String fileName;
		String originFileExt = "hwp";
		switch (step) {
			case "1":
				fileName = "평가(심사)위원 위촉 확인 및 평가운영지침 준수 각서_" + evalId;
				originFileExt = "hwp";
				break;
			case "2":
				fileName = "평가위원 사전의결사항_" + evalId;
				originFileExt = "hwp";
				break;
			case "2_jang":
				fileName = "평가위원장 사전의결사항_" + evalId;
				originFileExt = "hwp";
				break;
			case "3":
				fileName = "사전접촉여부 확인(신고)서_" + evalId;
				originFileExt = "hwp";
				break;
			case "4":
				fileName = "평가수당 지급 확인서_" + evalId;
				originFileExt = "hwp";
				break;
			case "5":
				fileName = "평가위원 개인정보 수집·이용 동의서_" + evalId;
				originFileExt = "hwp";
				break;
			case "6":
				fileName = "(평가표) 위원별 제안서 평가표_" + evalId;
				originFileExt = "pdf";
				break;
			case "7":
				fileName = "(평가표) 업체별 제안서 평가집계표_";
				originFileExt = "pdf";
				break;
			case "8":
				fileName = "(평가표) 제안서 평가 총괄표_";
				originFileExt = "pdf";
				break;
			case "9":
				fileName = "사전접촉여부 확인(신고)서 _" + evalId;
				originFileExt = "hwp";
				break;
			case "10":
				fileName = "평가위원장 가산금 지급 확인서_" + evalId;
				originFileExt = "hwp";
				break;
			default:
				fileName = "기타";
				originFileExt = "hwp";// Default case for safety
		}


		// file 저장
		map.put("attch_file_seq", fileName);

		String url = "/home/upload/cust_eval/";
		HttpServletRequest servletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();

		if(servletRequest.getServerName().contains("10.10.10.114") || servletRequest.getServerName().contains("one.epis.or.kr")) {
			url = "/nas1/upload/cust_eval/";
		}

		if("6".equals(step) || "8".equals(step)){
			if (!EgovStringUtil.nullConvert(map.get("signHwpFileData")).equals("")) {
				try {
					String originFileName = fileName;

					String fileStr = EgovStringUtil.nullConvert(map.get("signHwpFileData"));

					if (fileStr.startsWith("data:") && fileStr.contains("base64,")) {
						fileStr = fileStr.substring(fileStr.indexOf("base64,") + "base64,".length());
					}

					File file = File.createTempFile(originFileName, "." + originFileExt);

					if ("hwp".equals(originFileExt)) {
						FileOutputStream lFileOutputStream = new FileOutputStream(file);
						// Base64 디코딩이 필요없다면, 그냥 fileStr을 UTF-8로 저장
						lFileOutputStream.write(fileStr.getBytes("UTF-8"));
						lFileOutputStream.close();
					} else if ("pdf".equals(originFileExt)) {
						fileStr = fileStr.replaceAll("[\\n\\r]", "");
						byte[] decodedBytes = Base64.getDecoder().decode(fileStr); // Base64 디코딩
						FileOutputStream lFileOutputStream = new FileOutputStream(file);
						lFileOutputStream.write(decodedBytes);
						lFileOutputStream.close();
					}

					String serverFilePath = url + map.get("commissioner_seq").toString() + "/pdf/";
					File newPath = new File(serverFilePath);
					if (!newPath.exists()) {
						newPath.mkdirs();
					}

					Path path = Paths.get(serverFilePath + fileName + "." + originFileExt);
					Files.copy(new FileInputStream(file), path, new CopyOption[]{StandardCopyOption.REPLACE_EXISTING});

				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				returnMap.put("result", "fail");
				return returnMap;
			}
		}else if ("7".equals(step)) {
			int i = 1; // signHwpFileData_1, signHwpFileData_2 등을 순차적으로 처리하기 위한 변수
			while (map.containsKey("signHwpFileData_" + i)) {
				String fileStr = EgovStringUtil.nullConvert(map.get("signHwpFileData_" + i));

				if (!fileStr.equals("")) {
					try {
						String originFileName = fileName + (char) ('A' + (i - 1)) + "업체";

						// Base64 처리
						if (fileStr.startsWith("data:") && fileStr.contains("base64,")) {
							fileStr = fileStr.substring(fileStr.indexOf("base64,") + "base64,".length());
						}

						// 파일 생성
						File file = File.createTempFile(originFileName, "." + originFileExt);

						fileStr = fileStr.replaceAll("[\\n\\r]", "");
						byte[] decodedBytes = Base64.getDecoder().decode(fileStr); // Base64 디코딩
						FileOutputStream lFileOutputStream = new FileOutputStream(file);
						lFileOutputStream.write(decodedBytes);
						lFileOutputStream.close();


						// 서버에 파일 저장
						String serverFilePath = url + map.get("commissioner_seq").toString() + "/pdf/";
						File newPath = new File(serverFilePath);
						if (!newPath.exists()) {
							newPath.mkdirs();
						}

						Path path = Paths.get(serverFilePath + originFileName + "." + originFileExt);
						Files.copy(new FileInputStream(file), path, new CopyOption[]{StandardCopyOption.REPLACE_EXISTING});

						/*PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
						pdfEcmFileVO.setRep_id("eval_"+map.get("commissioner_seq").toString());
						pdfEcmFileVO.setComp_seq("1000");
						pdfEcmFileVO.setDoc_id(originFileName);
						pdfEcmFileVO.setDoc_no("001");
						pdfEcmFileVO.setDoc_path("Z:/upload/cust_eval/" + map.get("commissioner_seq") + "/hwp");
						pdfEcmFileVO.setDoc_name(originFileName);
						pdfEcmFileVO.setDoc_ext("hwp");
						pdfEcmFileVO.setDoc_title(originFileName);

						PdfEcmMainVO pdfEcmMainVO = new PdfEcmMainVO();

						pdfEcmMainVO.setRep_id("eval_"+map.get("commissioner_seq").toString());
						pdfEcmMainVO.setComp_seq("1000");
						pdfEcmMainVO.setDept_seq("1");
						pdfEcmMainVO.setEmp_seq("1");
						pdfEcmMainVO.setPdf_path("Z:/upload/cust_eval/" + map.get("commissioner_seq") + "/pdf");
						pdfEcmMainVO.setPdf_name(originFileName);
						//pdfEcmMainVO.setPdf_name("PDF_" + originFileName);
						pdfEcmMainVO.setStatus_cd("D0001");

						evalDAO.insertPdfFile(pdfEcmFileVO);
						evalDAO.insertPdfMain(pdfEcmMainVO);*/

					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				i++;
			}

		}else{
				if (!EgovStringUtil.nullConvert(map.get("signHwpFileData")).equals("")) {
					try {
						String originFileName = fileName;

						String fileStr = EgovStringUtil.nullConvert(map.get("signHwpFileData"));

						if (fileStr.startsWith("data:") && fileStr.contains("base64,")) {
							fileStr = fileStr.substring(fileStr.indexOf("base64,") + "base64,".length());
						}

						File file = File.createTempFile(originFileName, "." + originFileExt);

						if ("hwp".equals(originFileExt)) {
							FileOutputStream lFileOutputStream = new FileOutputStream(file);
							// Base64 디코딩이 필요없다면, 그냥 fileStr을 UTF-8로 저장
							lFileOutputStream.write(fileStr.getBytes("UTF-8"));
							lFileOutputStream.close();
						} else if ("pdf".equals(originFileExt)) {
							fileStr = fileStr.replaceAll("[\\n\\r]", "");
							byte[] decodedBytes = Base64.getDecoder().decode(fileStr); // Base64 디코딩
							FileOutputStream lFileOutputStream = new FileOutputStream(file);
							lFileOutputStream.write(decodedBytes);
							lFileOutputStream.close();
						}

						String serverFilePath = url + map.get("commissioner_seq").toString() + "/hwp/";
						File newPath = new File(serverFilePath);
						if (!newPath.exists()) {
							newPath.mkdirs();
						}

						Path path = Paths.get(serverFilePath + fileName + "." + originFileExt);
						Files.copy(new FileInputStream(file), path, new CopyOption[]{StandardCopyOption.REPLACE_EXISTING});

					/*CommFileUtil commFileUtil = new CommFileUtil();
					commFileUtil.setServerSFSave(EgovStringUtil.nullConvert(map.get("signHwpFileData")), (String) map.get("commissioner_seq"), fileName, "hwp");*/

						PdfEcmFileVO pdfEcmFileVO = new PdfEcmFileVO();
						pdfEcmFileVO.setRep_id("eval_"+map.get("commissioner_seq").toString()+"_"+step);
						pdfEcmFileVO.setComp_seq("1000");
						pdfEcmFileVO.setDoc_id("sign_" + step);
						pdfEcmFileVO.setDoc_no("001");
						pdfEcmFileVO.setDoc_path("Z:/upload/cust_eval/" + map.get("commissioner_seq") + "/hwp");
						pdfEcmFileVO.setDoc_name(fileName);
						pdfEcmFileVO.setDoc_ext("hwp");
						pdfEcmFileVO.setDoc_title(fileName);

						PdfEcmMainVO pdfEcmMainVO = new PdfEcmMainVO();
						pdfEcmMainVO.setRep_id("eval_"+map.get("commissioner_seq").toString()+"_"+step);
						pdfEcmMainVO.setComp_seq("1000");
						pdfEcmMainVO.setDept_seq("1");
						pdfEcmMainVO.setEmp_seq("1");
						pdfEcmMainVO.setPdf_path("Z:/upload/cust_eval/" + map.get("commissioner_seq") + "/pdf");
						pdfEcmMainVO.setPdf_name(fileName);
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

			}

			if (step.endsWith("_jang")) {
				step = step.replace("_jang", "");
			}

			// 상태값 변경
			evalDAO.setSignSetp(map);

			if (step.equals("9") && map.get("flag").equals("Y")) {
				// 사전접촉이 있으면 평가비용 5만원으로 변경
				evalDAO.setEvalPayUpdate(map);
	 			
				if(map.get("jang").equals("Y")) {
					map.put("COMMITTEE_SEQ", map.get("committee_seq"));
					evalDAO.setEvalJangReSelected(map);
					evalDAO.setEvalJangCntCn(map);
					evalDAO.getEvalMinuteChKGroupFailUpd2(map);
				}
			} else if (step.equals("4")) {
				// 수당 개인정보 업데이트
				evalDAO.setCommDetailUpdate(map);
				// 평가확정
				evalDAO.setEvalJangConfirm(map);
			} else if (step.equals("8")) {
				// 평가확정
				// evalDAO.setEvalJangConfirm(map);

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

		AtomicInteger counter = new AtomicInteger(1);
		AtomicInteger cnt = new AtomicInteger(0);

		AtomicReference<Double> previousScore = new AtomicReference<>(null);
		AtomicInteger previousRank = new AtomicInteger(0);

		list.stream()
				.filter(row -> !"-".equals(row.get("RANK").toString()))
				.sorted((row1, row2) -> {
					Double totalSum1 = (Double) row1.get("TOTAL_SUM");
					Double totalSum2 = (Double) row2.get("TOTAL_SUM");
					return totalSum2.compareTo(totalSum1);  // 내림차순 정렬
				})
				.forEach(row -> {
					Double currentScore = (Double) row.get("TOTAL_SUM");

					if (cnt.get() != 0) {
						if (currentScore.equals(previousScore.get())) {
							row.put("RANK", previousRank.get());
						} else {
							row.put("RANK", counter.get());
							previousRank.set(counter.get());
						}
					} else {
						row.put("RANK", counter.get());
						previousRank.set(counter.get());
					}

					// 이전 점수를 현재 점수로 업데이트
					previousScore.set(currentScore);
					counter.incrementAndGet(); // 다음 순위 증가
					cnt.set(1); // 최초 반복 후 고정
				});

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
	public Map<String, Object> setEvalAvoidY(Map<String, Object> map) {
		Map<String, Object> returnMap = new HashMap<String, Object>();

		Map<String, Object> comSeq = new HashMap<String, Object>();
		comSeq.put("commissioner_seq", map.get("commissioner_seq"));
		String evalId = evalDAO.getCommissionerSeqEvalId(comSeq);
		List<Map<String, Object>> duplIdList = evalDAO.getDuplId(comSeq);

		if (duplIdList != null && !duplIdList.isEmpty()) {
			Map<String, Integer> nameCountMap = new HashMap<>();

			// 이름 중복 여부 확인
			for (Map<String, Object> item : duplIdList) {
				String currentEvalId = String.valueOf(item.get("EVAL_ID"));
				nameCountMap.put(currentEvalId, nameCountMap.getOrDefault(currentEvalId, 0) + 1);
			}

			for (Map<String, Object> item : duplIdList) {
				String commissionerSeq = String.valueOf(item.get("COMMISSIONER_SEQ"));
				String currentEvalId = String.valueOf(item.get("EVAL_ID"));
				String evalPhone = String.valueOf(item.get("EVAL_PHONE"));

				if (nameCountMap.get(currentEvalId) > 1 &&
						currentEvalId.equals(evalId) &&
						commissionerSeq.equals(String.valueOf(comSeq.get("commissioner_seq")))) {
					evalId = currentEvalId + "(" + evalPhone.substring(evalPhone.length() - 4) + ")";
					break;
				}
			}
		}

		String fileName = "기피신청서_" + evalId;
		String originFileExt = "pdf";

		// file 저장
		map.put("attch_file_seq", fileName);

		String url = "/home/upload/cust_eval/";
		HttpServletRequest servletRequest = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();

		if(servletRequest.getServerName().contains("10.10.10.114") || servletRequest.getServerName().contains("one.epis.or.kr")) {
			url = "/nas1/upload/cust_eval/";
		}

		if (!EgovStringUtil.nullConvert(map.get("signHwpFileData")).equals("")) {
			try {
				String originFileName = fileName;

				String fileStr = EgovStringUtil.nullConvert(map.get("signHwpFileData"));

				if (fileStr.startsWith("data:") && fileStr.contains("base64,")) {
					fileStr = fileStr.substring(fileStr.indexOf("base64,") + "base64,".length());
				}

				File file = File.createTempFile(originFileName, "." + originFileExt);

				if ("hwp".equals(originFileExt)) {
					FileOutputStream lFileOutputStream = new FileOutputStream(file);
					// Base64 디코딩이 필요없다면, 그냥 fileStr을 UTF-8로 저장
					lFileOutputStream.write(fileStr.getBytes("UTF-8"));
					lFileOutputStream.close();
				} else if ("pdf".equals(originFileExt)) {
					fileStr = fileStr.replaceAll("[\\n\\r]", "");
					byte[] decodedBytes = Base64.getDecoder().decode(fileStr); // Base64 디코딩
					FileOutputStream lFileOutputStream = new FileOutputStream(file);
					lFileOutputStream.write(decodedBytes);
					lFileOutputStream.close();
				}

				String serverFilePath = url + map.get("commissioner_seq").toString() + "/pdf/";
				File newPath = new File(serverFilePath);
				if (!newPath.exists()) {
					newPath.mkdirs();
				}

				Path path = Paths.get(serverFilePath + fileName + "." + originFileExt);
				Files.copy(new FileInputStream(file), path, new CopyOption[]{StandardCopyOption.REPLACE_EXISTING});

			} catch (Exception e) {
				e.printStackTrace();
			}
		}else{
			returnMap.put("result", "fail");
			return returnMap;
		}

		evalDAO.setEvalAvoidY(map);
		if(map.get("EVAL_JANG").equals("Y")){
			evalDAO.setEvalJangReSelected(map);
			map.put("committee_seq", map.get("COMMITTEE_SEQ"));
			evalDAO.setEvalJangCntCn(map);
			evalDAO.getEvalMinuteChKGroupFailUpd2(map);
		}

		returnMap.put("result", "success");
		return returnMap;
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
			if(params.containsKey("evalSign")) {
				if(params.get("evalSign").equals("9") && commissioner.get("sign_9").equals("N")) {
					returnBoolean = false;
				}
			}
		}

		returnMap.put("commissionerChk", returnBoolean);

		return returnMap;
	}

	@Override
	public Map<String, Object> getCommissionerChk2(Map<String, Object> params) {
		Map<String, Object> returnMap = new HashMap<>();
		boolean returnBoolean = true;
		List<Map<String, Object>> commissionerList = evalDAO.getCommissionerChk2(params);

		for(Map<String, Object> commissioner : commissionerList){
			if(commissioner.get("eval_save").equals("N") || commissioner.get("sign_4").equals("N")){
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

	@Override
	public void setEvalJangReSelected(Map<String,Object> map){
		evalDAO.setEvalJangReSelected(map);
	}

	@Override
	public Map<String, Object> getEvalStepCheck(Map<String, Object> map) {
		return evalDAO.getEvalStepCheck(map);
	}
}