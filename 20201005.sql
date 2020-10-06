달력 만들기
1. 행을 인위적으로 만들기
    CONNECT BY LEVEL 
    
    인위적으로 여러개의 행을 만들기
    계층쿼리 : 행과 행을 연결
                
    
    
    
    
    조인 : 테이블의 행과, 다른 테이블의 행을 연결 - 컬럼이 확장
    SELECT LEVEL, dummy, LTRIM(SYS_CONNECT_BY_PATH(dummy, '-'),'-')
    FROM dual
    CONNECT BY LEVEL <= 31;
    
    
    년월 문자열이 주어졌을 때 해당 월의 일수 구하기
    EX : '202010' => 31
            날짜가 있으면 원하는 항목(년,월,일,시,분,초)만 추출할 수 있다
            TO_CHAR(날짜, '원하는 항목')
            TO_CHAR(해당날짜의 마지막날짜까지 구하는 함수(TO_DATE('202010', '포맷'), '원하는항목')
            
            TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM') : 일자를 설정하지 않았기 때문에 1일자 0시0분0초 => 마지막 날짜로 변경
            TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM'), '원하는항목')
            
            SELECT TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')),'DD')
            FROM dual;
            
            SELECT LEVEL, dummy
            FROM dual
            CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')),'DD')
    
            실제 필요한 값 ==> 날짜 (20201001 ~ 20201031)
            DATE + 정수 = DATE에서 정수를 일자로 취급해서 더한 날짜
            2020.10.05 + 5 = 2020.10.10
            
            2020년10월1일자를 만들려면
            주어진 값 : '202010'
            
            '202010' || '01' ==> '20201001'
            TO_DATE('202010' || '01', 'YYYYMM')
            
            2020년 10월1일의 날짜 타입을 구함
            날짜 +숫자(LEVEL1~31) 연산을 통해 2020년 10월의 모든 일자를 구할 수 있다.
            => LEVEL 은 1부터 시작하므로 2020년 10월1일 값을 유지하기 위해서는 날짜 + LEVEL-1 day
            
            SELECT
            FROM dual
            CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TODATE('202010','YYYYMM')),'DD')
        
            
2. 그룹 함수
    여러행을 하나의 행으로 만드는 방법
    null 값은 자체적으로 제외시킨다
    
3. expression
    테이블에 존재하지 않지만, 수식, 함수를 이용하여 새로운 컬럼을 만드는 방법
    
4. 부수적인 것들
    date 관련함수
    - 월의 마지막 일자 구하기
    
        SELECT MIN(DECODE(d, 1, day)) sun, MIN(DECODE(d, 2, day)) mon,
       MIN(DECODE(d, 3, day)) tue, MIN(DECODE(d, 4, day)) wed,
       MIN(DECODE(d, 5, day)) thu, MIN(DECODE(d, 6, day)) fri,
       MIN(DECODE(d, 7, day)) sat
        FROM 
        (SELECT TO_DATE('202010', 'YYYYMM') + LEVEL-1 day,
        TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'd') d,
        TO_CHAR(TO_DATE('202010', 'YYYYMM') + LEVEL-1, 'iw') iw
            FROM dual
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE('202010', 'YYYYMM')), 'DD'))
            GROUP BY DECODE(d, 1, iw+1, iw)
            ORDER BY DECODE(d, 1, iw+1, iw);   
    
    
    
    PL/SQL : Procedual Language / SQL
    SQL은 집합적인 언어인데 여기다 절차적 요소를 더함
    절차적 요소 (반복문, 조건 제어- 분기처리)
    
    결론 : 절차적으로 잘못 짜면 속도가 느리다
        ==> sql로 한번에 처리할 수 없는지 고민
        
    PL/SQL block 구조 : try/catch문과 유사 - 중첩 가능
    DECLARE
    선언부(생략가능)
    - PL/SQL 블럭에서 사용할 변수, TYPE(CLASS), CURSOR(SQL-정보)등을 선언하는 절
                JAVA랑 다르게 변수선언을 블록 어디서나 할 수 없음
                
    BEGIN 
        실행부(생략불가)
        로직 - (데이터를 조회해서 변수에 담기, 루프, 조건제어)
   
   EXCEPTION
   예외부 (생략가능)
        BEGIN 절에서 발생한 예외를 처리하는 부분
   
   END;
   / 오타가 아니고 PL/SQL 끝을 표현
   
   pl/sql 식별자 규칙 : 오라클 객체(table, index...) 생성시와 동일
   30글자를 넘어감녀 안됨 (FK시 길어지게 되는 경우가 있다)
   오라클 객체명은 내부적으로 대문자로 관리
   
   PL/SQL 연산자 : SQL과 동일  
                        프로그래밍 언어의 특성 (변수, 반복문, 조건문)
                        대입 연산자 주의(SQL에 존재하지 않음)
                        JAVA = 
                        PL/SQL :=
         
  10번 부서의 부서번호, 부서이름을 각 변수에 담아서 console에 출력                      
  부서번호 : v_deptno, 부서이름 : v_deptnm
변수 선언 : java와 순서가 다름
                java : 타입 변수명      pl/sql : 변수명 타입
                
  console 출력
  java : System.out.println();
  pl/sql : DBMS_OUTPUT.PUT_LINE();
  
  ORACLE은 결과출력을 위해 출력 기능을 활성화 해야함
  매번 실행할 필요는 없고, 오라클 접속 후 한번만 실행하면 됨
  
  SET SERVEROUTPUT ON;
  
  DECLARE
        v_deptno NUMBER(2);
        v_dname VARCHAR2(14);
  BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
  END;
  /
        
 참조타입 : 변수 타입을 테이블의 컬럼 정보를 통해 선언
                변수명 테이블명.컬럼명%TYPE;
                ==> 특정 테이블 컬럼의 타입을 참조하여 선언.
                        해당 컬럼의 타입이 변경되더라도 pl/sql 코드는 수정하지 않아도 됨
    
    DECLARE
        v_deptno dept.deptno%TYPE; /* v_deptno NUMBER(2); */
        v_dname dept.dname%TYPE;
  BEGIN
    SELECT deptno, dname INTO v_deptno, v_dname
    FROM dept
    WHERE deptno = 10;
    
    DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ', v_dname : ' || v_dname);
  END;
  /    
  
  PL/SQL PROCEDURE : 오라클 DBMS에 저장한 PL/SQL 블럭 함수와 다르게 리턴값이 없다
  
  생성방법
  CREATE OR REPLACE PROCEDURE 프로시저명 [(입력값...)] IS 
    선언부
 BEGIN
 END;
 /
 
 실행방법
 EXEC 프로시저명;
 
 
 CREATE OR REPLACE PROCEDURE printdept IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
 BEGIN
 SELECT deptno, dname INTO v_deptno, v_dname
 FROM dept
 WHERE deptno = 10;
 DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ',v_dname : ' || v_dname);
 
 END;
 /
 
 EXEC printdept;
 
 
 printdept프로시저는 begin절에 10번 부서의 정보를 조회하도록
 hard coding 되어있음 프로시저가 인자를 받도록 수정
 
 EXEC printdept(20);
EXEC printdept(30);

 CREATE OR REPLACE PROCEDURE printdept (p_deptno IN dept.deptno%TYPE) IS
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
 BEGIN
 SELECT deptno, dname INTO v_deptno, v_dname
 FROM dept
 WHERE deptno = p_deptno;
 DBMS_OUTPUT.PUT_LINE('v_deptno : ' || v_deptno || ',v_dname : ' || v_dname);
 
 END;
 /
 
 EXEC printdept(20);
 EXEC printdept(30);
 EXEC printdept(10);
 
 
 -- printemp procedure 생성, param : empno, empno에 해당하는 사원이름, 부서이름을 화면에 출력
 DESC emp;
  DESC dept;
 
 CREATE PROCEDURE printemp (p_empno IN emp.empno%TYPE) IS
  v_ename emp.ename%TYPE;
  v_dname dept.dname%TYPE;
  
 BEGIN
 SELECT ename, dname INTO  v_ename, v_dname
 FROM emp, dept
 WHERE emp.empno = p_empno
 AND emp.deptno = dept.deptno;
 DBMS_OUTPUT.PUT_LINE('v_ename : ' || v_ename || ',v_dname : ' || v_dname);
 
 END;
 /
 
 SELECT*
 FROM emp;
 
 -- 프로시저 삭제
 DROP PROCEDURE  printemp
 
 EXEC printemp (7369);
 
 SELECT *
 FROM dept_test;
 
 DROP TABLE dept_test;

CREATE TABLE dept_test AS

SELECT * FROM dept;

SELECT * FROM dept_test;


 --registdept_test procedure 생성,
 --param : deptno, dname, loc,
 --로직 : 입력받은 부서 정보를 dept_test 테이블에 신규입력,
 --exec registdept_test (99, 'ddit', 'daejeon');
 --dept_test 테이블에 정상적으로 입력 되었는지 확인
 
 INSERT INTO DEPT_TEST VALUES (99, 'ddit', 'daejeon');
 ROLLBACK;
 
  CREATE OR REPLACE PROCEDURE registdept_test 
  (r_deptno IN dept.deptno%TYPE, 
  r_dname IN dept.dname%TYPE,
  r_loc IN dept.loc%TYPE) IS
  
 BEGIN
  INSERT INTO DEPT_TEST VALUES(r_deptno,  r_dname,  r_loc );

 END;
 /
 EXEC  registdept_test(99,'ddit', 'daejeon');
 
 SELECT*
 FROM dept_test;
 
 DROP PROCEDURE UPDATEdept_test
 
 --UPDATEdept_test procedure 생성
 --param : deptno, dname, loc
 --로직 : 입력받은 부서 정보를 dept_test 테이블에 정보 수정
 --exec UPDATEdept_test (99, 'ddit_m', 'daejeon');
 --dept_test 테이블에 정상적으로 갱신 되었는지 확인
 INSERT INTO dept_test VALUES (99, 'ddit_m', 'daejeon');
 ROLLBACK;
 
 CREATE OR REPLACE PROCEDURE UPDATEdept_test 
    (p_deptno IN dept.deptno%TYPE,
     p_dname IN dept.dname%TYPE,
     p_loc IN dept.loc%TYPE
     ) IS
    BEGIN
    UPDATE DEPT_TEST SET (p_deptno, p_dname, p_loc);
 END;
 /

 EXEC  UPDATEdept_test(99,'ddit_m', 'daejeon');
 
 
 DROP TABLE dept_test;