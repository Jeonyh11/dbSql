Exception (예외) : pl/sql 블럭이 실행되는 동안 발생하는 에러
                        예외가 발생 했을 때PL/SQL의 EXCEPTION 절을 기술하여
                        다른 로직을 실행하여 예외 문제를 해결 할 수 있다.
                        
예외 구분
1.사전 정의 예외 (Oracle Rpedefined Exception)
    오라클에서 미리 정의한 예외로    ORA-XXXXX로 정의
    에러코드만 있으면 에러이름이 없는 경우가 대다수.

2. 사용자 정의 예외(User Defined Exception)

예외 발생 시 해당 sql문은 중단 
    .
    .EXCEPTION 절이 있으면 : 예외 처리부에 기술된 문장을 실행
    .EXCEPTION 절이 없으면 : PL/SQL 블록 종료
    
예외처리방법
DECLARE 

BEGIN
EXCEPTION 
    WHEN 예외명 [OR 예외명2] THEN
            실행할 문장;
    WHEN 예외명3 [OR 예외명4] THEN
            실행할 문장;
    WHEN OTHER THEN
        실행할 문장 (여기서 SQLCODE, SQLERRM 속성을 통해 예외 코드를 확인 할수 있다.)
END;
/

하나의 행이 조회되어야 하는 상황에서 여러개의 행이 반환된 경우
(예외처리가 없을때)

SET SERVEROUTPUT ON;

DECLARE
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename INTO v_ename
    FROM emp;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS');
END;
/

사용자 예외 정의, 사용
1. PL/SQL 블럭 안에서 또다른 PL/SQL 블럭을 정의 하는 것이 가능

NO_EMP : 사번을 통해서 사원을 검색하는데 해당 사번을 갖는 사원이 없을 때
    SELECT *
    FROM emp
    WHERE empno = -1;
    
    ==> NO_DATA_FOUND ==> NO_EMP
    

DECLARE 
    v_ename emp.ename%TYPE;
    NO_EMP EXCEPCION;

    BEGIN
        SELECT ename INTO v_ename
        FROM emp
        WHERE empno = -1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RAISE NO_EMP ;
END;

EXCEPTION
    WHEN NO_EMP THEN
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
 
END;
/


FUNCTION : 반환 값이 존재하는 PL/SQL 블럭

사번을 입력 받아서, 해당 사원의 이름을 반환 하는 FUNCTION

CREATE OR REPLACE FUNCTION getEmpName (p_empno emp.empno%TYPE)
RETURN VARCHAR2 IS v_ename  emp.ename%TYPE;

BEGIN
    SELECT ename INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN v_ename;
END;
/
--------------------------------------function1

CREATE OR REPLACE FUNCTION getDeptName(p_deptno dept.deptno%TYPE) RETURN VARCHAR2 IS
    v_dname dept.dname%TYPE;
BEGIN
    SELECT dname INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/


DROP FUNCTION getdeptname

사원이 속한 부서이름을 가져오는 방법
1. join
SELECT empno, ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno= dept.deptno;

2. 스칼라 서브 쿼리
SELECT empno, ename, deptno (SELECT dname FROM dept WHERE deptno = emp.deptno) dname
FROM emp;

3. function
SELECT empno, ename, deptno,
            getdeptname(deptno) dname
FROM emp;

분포도 : 흩어진 정도
데이터 분포도 : 특정 데이터가 발생하는 빈도
예 : emp 테이블의 empno : 값이 - 14개 존재 - 데이터 분포도가 좋다(중복이 적다)
     emp 테입르의 deptno : 값이 3개 존재 - 데이터 분포도가 나쁘다(중복이 많다)

함수의 경우 오라클에서 기본적으로 캐쉬 기능을 사용
기본 캐쉬 사이즈가 20개
getDeptName(10) => ACCOUNTING 오라클은 10번 인자로 getDeptName을 실행 했을때 ACCOUNTING 이라는 결과 값을 기억(캐싱)
이후에 동일한 인자로 함수를 실행하면 함수를 실행하지 않고 캐싱된 값을 반환

--------------------------------------------- function2
SELECT   indent(LEVEL) || deptnm
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


CREATE OR REPLACE FUNCTION indent(p_level NUMBER) RETURN VARCHAR2 IS
    v_ret VARCHAR(200);
BEGIN
    SELECT LPAD(' ', (p_level-1)*4, ' ') INTO v_ret
    FROM dual;
    RETURN v_ret;
   /*  v_ret := LPAD(' ', (p_level-1)*4, ' ');
    RETURN v_ret;   SELECT문 대신 써도 된다*/
END;
/

패키지 : 관련된 PL/SQL 블럭을 묶어 놓은 객체
java 의 패키지와 유사
==> 유사한 타입들의 모입

DBMS_XPLAN.;
DBMS_OUTPUT. ;

패키지 생성 방법 : java의 interface, class 사용 방법과 유사
Interface 객체명 : new class();
List<String> names = new ArrayList<String>();

PL/SQL  패키지 생성 방법
1. 선언부
2. BODY

CREATE OR REPLACE PACKAGE names AS 
    FUNCTION getEmpName(p_empno emp.empno%TYPE) RETURN VARCHAR2;
    FUNCTION getDeptName(p_deptno dept.deptno%TYPE) RETURN VARCHAR2;
end names;
/

BODY 부 생성
-------------------------------------------------------------------------------
    CREATE OR REPLACE PACKAGE BODY names IS
    FUNCTION getEmpName (p_empno emp.empno%TYPE) RETURN VARCHAR2 IS
        v_ename  emp.ename%TYPE;

    BEGIN
         SELECT ename INTO v_ename
        FROM emp
        WHERE empno = p_empno;
    
       RETURN v_ename;
    END;

    FUNCTION getDeptName(p_deptno dept.deptno%TYPE) RETURN VARCHAR2 IS
         v_dname dept.dname%TYPE;
         
    BEGIN
         SELECT dname INTO v_dname
         FROM dept
        WHERE deptno = p_deptno;
    
         RETURN v_dname;
    END;
    
    end;
    /

DROP PACKAGE BODY names

SELECT NAMES.GETEMPNAME(empno), NAMES.GETDEPTNAME(deptno)
FROM emp;


Trigger (방아쇠) : 설정한 이벤트에 따라 실행되는 로직을 담은 객체
    웹 : 로그인 버튼 클릭 
        => 사용자 아이디 input 값과, 비밀번호 input 값을 파라미터 서버로 전송
            
    db : 테이블의 데이터가 추가되거나 변경되었을 때 PL/SQL 블럭을 실행
    
    users 테이블에 사용자 비밀번호가 변경 되었을 때
    users_history 테이블에 기존에 사용하던 비밀번호 이력으로 생성
    
    SELECT *
    FROM users;
    CREATE TABLE users_history AS
    SELECT userid, pass, SYSDATE mod_dt
    FROM users
    WHERE 1=2;
    
    SELECT *
    FROM users_history;

    users 테이블의 pass 컬럼이 변경되었을때 실행할 트리거 생성
    
    CREATE OR REPLACE TRIGGER trg_users_pass
        BEFORE UPDATE ON users
        FOR EACH ROW
    BEGIN
       --테이블 업데이트가 일어 났을때,
       --기존(:OLD.pass) 비밀번호와 업데이트 하려고 하는 비밀번호(:NEW.pass)가 다를때
        IF :OLD.pass != :NEW.pass THEN
            INSERT INTO USERS_HISTORY VALUES(:OLD.userid, :OLD.pass, SYSDATE);
        END IF;
    END;
    /
    데이터가 없는 상황
    SELECT *
    FROM users_history;
    
    UPDATE users SET pass = 'brownPass'
    WHERE userid = 'brown'
    
    
    트리거가 실행되지 않을 조건으로 UPDATE
    UPDATE users SET alias = '곰탱이'
    WHERE userid = 'brown';
    
트리거
    장점 : users 테이블에 비밀번호를 바꾸는 로직 (java 코드)는 작성을 해야한다.
            users_history에 이력을 남기는 로직 (java코드)은 작성하지 않아도 됨
    단점 : (시스템을 유지보수하는 사람)
            : users_history 테이블에 데이터를 넣는 로직이 없는 데 생성 됨
    
    DROP TRIGGER trg_users_pass
    