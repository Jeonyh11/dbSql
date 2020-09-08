ROUNUM : 1부터 읽어야 된다
        SELECT 절이 ORDER BY 절보다 먼저 실행된다
            ==> ROWNUM을 이용하여 순서를 부여 하려면 정렬부터 해야한다.
                ==> 인라인뷰 ( ORDER BY - ROWNUM을 분리)
                
        
SELECT *
FROM( SELECT ROWNUM rn, a.*   
      FROM
      (SELECT empno, ename
       FROM emp
       ORDER BY ename)a)
WHERE rn BETWEEN  1 AND 10;


SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM <=10;


SELECT*
FROM (SELECT ROWNUM rn, empno, ename
    FROM emp)
WHERE rn >=11 AND rn <=20;

//emp 테이블에서 사원이름을 오른차순 정렬하고 11~14번에 해당하는 순번, 사원번호, 이름 출력
1. 정렬기준 : ORDER BY ename ASC;
2. 페이지 사이즈 : 11 ~ 20(페이지당 10건)
***********************************************************************
SELECT*
FROM
(SELECT ROWNUM rn, empno, ename
FROM
    (SELECT empno, ename
     FROM emp
     ORDER BY ename ASC))
WHERE rn > 10 AND rn <= 20;

SELECT*
FROM dual;

ORACLE 함수 분류
1. SINGLE ROW FUNCTION : 단일 행을 작업의 기준, 결과도 한건 반환
2. MULTI ROW ROW FUNCTION : 여러 행을 작업의 기준, 하나의 행을 결과로 반환

dual 테이블
    1.sys계정에 존재하는 누구나 사용할 수 있는 테이블
    2. 테이블에는 하나의 컬럼, dummy 존재, 값은 x
    3. 하나의 행만 존재
        ****** SINGLE
        
    SELECT empno, ename, LENGTH(ename),LENGTH('hello')
    FROM emp;

sql 칠거지악
1. 좌변을 가공하지 말아라 (테이블 컴럼에 함수를 사용하지 말것)
. 함수 실행 횟수
. 인덱스 사용관련

  SELECT ename, LOWER(ename)
    FROM emp
    WHERE LOWER(ename) = 'smith';
    
    
    SELECT ename, LOWER(ename)
    FROM emp
    WHERE ename = 'SMITH';
    
    문자열 관련함수
    
    SELECT CONCAT('Hello',',World') concat,
    SUBSTR('Hello, World', 1, 5) substr,
    SUBSTR('Hello, World',  5) substr2,
    LENGTH('Hello, World') length,
    INSTR('Hello, World','o')instr,
    INSTR('Hello, World','o', 5+1)instr2,
    INSTR('Hello, World','o', INSTR('Hello, World','o') +1)instr3,
    LPAD('Hello, World', 15, '*')lpad,
    LPAD('Hello, World', 15)lpad2,
    RPAD('Hello, World', 15, '*')rpad,
    REPLACE('Hello, World', 'Hello', 'Hell') replace,
    TRIM('Hello, World') trim,
    TRIM('      Hello, World     ') trim2,
    TRIM('H' FROM 'Hello, World' ) trim3
    
    FROM dual;
    
    
    숫자관련 함수
    
    number 
    - ROUND : 반올림  
    
                                                         1  0  5 . 2 3
    - TRUNC : 버림 함수                                  -3 -2 -1 0 1 2  반올림 자리수 음수부터는 음수자릿수 반올림
          ==> 몇번째 자리에서 반올림, 버림을 할지?
              ROUND(숫자, 반올림 결과 자리수)
    - MOD   : 나머지를 구하는 함수
    
    SELECT TRUNC(105.54, 1) trunc,
            TRUNC(105.55, 1) trunc2, 
            TRUNC(105.55, 0) trunc3,
            TRUNC(105.55, -1) trunc4,
            TRUNC(155.55, -2) trunc5
    FROM DUAL;
    
    mod 나머지 구하는 함수
    피제수 - 분자, 제수 - 분모
    a / b = c 
    a: 피제수
    b: 제수
    
    SELECT mod(10,3),
    TRUNC(mod(10,3), 1) trunc
    FROM dual;
    10을 3으로 나눴을때 몫 구하기
    SELECT  mod(10,3), 3*10,10/3,
    TRUNC(10/3, 0)trunc
    FROM dual;
    
    날짜 관련 함수
    문자열 ==> 날짜 타입 TO_DATE
    SYSDATE : 오라클 서버의 현재 날짜, 시간을 돌려주는 특수 함수
             함수의 인자가 없다.
             (java = public void test() {
             }
             test();
             
             SQL
             length('Hello, World')
             SYSDATE;
             
SELECT SYSDATE

FROM dual;
    
날짜 타입 +- 정수 : 날짜에서 정수만큼 더한 (뺀) 날짜
emp hiredate +5, -5
하루 = 24
1일 = 24h
1h = 1/24일
1m = 1/24일/60
1s = 1/24일/60/60


SELECT SYSDATE, SYSDATE + 5, SYSDATE -5,
    SYSDATE + 1/24, SYSDATE + 1/24/60
FROM dual;


///////////////////////////////////////////////

--SELECT  LASTDAY, TO_DATE('2019/12/31','yyyy/mm/dd')
--LASTDAY_BEFORE5, SYSDATE -5 ,
--NOW, SYSDATE, NOW_BEFORESYSDATE, SYSDATE-3,
--FROM dual;

sql : nsl 포맷에 설정된 문자열 형식을 따르거나
        TO_DATE 함수를 이용하여 명확하게 명시
        TO_DATE ('날짜 문자열', '날짜 문자열 형식')
        
    SELECT TO_DATE('2019/12/31', 'yyyy/mm/dd') LASTDAY,
           TO_DATE('2019/12/31', 'yyyy/mm/dd') -5 LASTDAY_BEFORE5,
           SYSDATE NOW,
           SYSDATE -3 NOW_BEFORE3
           FROM dual;


