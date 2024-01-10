CREATE DEFINER=`neos`@`%` FUNCTION `fn_getRandomTxt`(
	V_IN_MGT_SEQ_FR INT(1) # 자리수
    ) RETURNS varchar(10) CHARSET utf8mb4
BEGIN

/*****************************************************************************
	1. 랜덤 문자 생성 자리

	VER 작성자  일자         내용
	--------------------------------------------------------------------------
	1.0 김윤호  2020.08.28.  최초작성
*****************************************************************************/ 
DECLARE V_OUT_PW VARCHAR(50);
DECLARE V_IN_TXT VARCHAR(100);

	SET V_IN_TXT = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'; #문자설정
    SET V_OUT_PW = '';
    
	WHILE LENGTH(V_OUT_PW) < V_IN_MGT_SEQ_FR DO

		SET V_OUT_PW =	CONCAT( V_OUT_PW , (SELECT SUBSTRING(V_IN_TXT, RAND() * LENGTH(V_IN_TXT), 1) ));
                      
	END WHILE;
                      
	
RETURN V_OUT_PW;
  
END