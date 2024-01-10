CREATE DEFINER=`neos`@`%` PROCEDURE `SP_DJ_EVAL_RESULT_RANK`(
		I_IN_COMMITTEE_SEQ INT(11)
	)
BEGIN

/*****************************************************************************
	1. dj_eval_item_result rank_code 적용

	VER 작성자  일자         내용
	--------------------------------------------------------------------------
	1.0 김윤호  2020-07-13  최초작성
*****************************************************************************/


DECLARE V_ITEM_SEQ INT(11);
DECLARE V_COMPANY_SEQ INT(11);

DECLARE done INT DEFAULT FALSE;

#커서 정의
DECLARE CUR1 CURSOR FOR
	SELECT B.EVAL_COMPANY_SEQ, C.ITEM_SEQ FROM DJ_EVAL_COMMITTEE A
	JOIN DJ_EVAL_COMPANY B
	ON A.COMMITTEE_SEQ = B.COMMITTEE_SEQ
	AND A.ACTIVE = 'Y'
	AND A.COMMITTEE_SEQ = I_IN_COMMITTEE_SEQ
	JOIN DJ_EVAL_COMMITTEE_ITEM C
	ON A.COMMITTEE_SEQ = C.COMMITTEE_SEQ
	AND C.ACTIVE = 'Y';
            
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

#커서를 연다
OPEN CUR1;
#Loop 돌아감
recom_loop:Loop
#반환된 필드값을 변수에 담는다
FETCH CUR1 INTO V_COMPANY_SEQ, V_ITEM_SEQ;

IF done THEN
   #데이터가 없으면 Loop 종료
   LEAVE recom_loop;
END IF;

	#코드 초기화 
	update dj_eval_item_result set rank_code = 'Y' where item_seq = V_ITEM_SEQ and eval_company_seq = V_COMPANY_SEQ and active = 'Y';

	#작은수 1개
	update dj_eval_item_result set rank_code = 'N' where item_result_seq =
	 (select item_result_seq from (
     select b.item_result_seq from dj_eval_commissioner a
     join dj_eval_item_result b
     on a.commissioner_seq = b.commissioner_seq
     and a.confirm_yn = 'Y'
     and a.attend_yn = 'Y'
     and a.active = 'Y'
     and a.active = 'Y'
     and a.eval_save = 'Y'
     and b.item_seq = V_ITEM_SEQ
     and b.eval_company_seq = V_COMPANY_SEQ
     order by b.score asc limit 1 ) t);
	
    #큰수 1개
	update dj_eval_item_result set rank_code = 'N' where item_result_seq =
	 (select item_result_seq from (
     select b.item_result_seq from dj_eval_commissioner a
     join dj_eval_item_result b
     on a.commissioner_seq = b.commissioner_seq
     and a.confirm_yn = 'Y'
     and a.attend_yn = 'Y'
     and a.active = 'Y'
     and a.active = 'Y'
     and a.eval_save = 'Y'
     and b.item_seq = V_ITEM_SEQ
     and b.eval_company_seq = V_COMPANY_SEQ
     order by b.score desc limit 1 ) t);
     
        
END loop recom_loop;
#커서를 닫는다
close CUR1;

END