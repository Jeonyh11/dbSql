DELETE emp_test;
DELETE emp_test2;

COMMIT;

ALL : 조건에 만족하는 모든 구문의 INSERT 실행
FIRST : 조건에 만족하는 첫번 째 구문의 INSERT만 실행

INSERT FIRST
 WHEN eno >= 9500 THEN
    INTO emp_test VALUES (eno, enm)
 WHEN eno >= 9000 THEN
    INTO emp_test2 VALUES (eno, enm)
SELECT 9000 eno, 'brown' enm FROM dual UNION ALL
SELECT 9500, 'sally' FROM dual;

SELECT*
FROM emp_test;
-- 9500 sally -------------------

SELECT*
FROM emp_test2;
-- 9000 brown -----------------

동일한 구조(컬럼)의 테이블을 여러개 생성했을 확률이 높음
행을 잘라서 서로 다른 테이블에 분산 : 개별 테이블의 건수가 줄어들어 table full access 속도가 빨라진다

실적 테이블 : 20190101 ~ 20191231 실적데이터 ==> SALES_2019 테이블에 저장
                20200101 ~ 20201231 실적데이터 ==> SALES_2020 테이블에 저장
개별년도 계산은 상관 없으나 19,20 년도 데이터를 동시에 보기 위해서는 UNION ALL 혹은 쿼리를 두번 사용 해야한다.

오라클 파티션 기능
테이블을 생성하고, 입력되는 값에 따라 오라클 내부적으로 별도의 영역에 저장


MERGE  -- 
특정 테이블에 입력하려고 하는 데이터가 없으면 입력하고, 있으면 업데이트를 한다
9000, 'brown' 데이터를 emp-test 넣으려고 하는데
emp_test 테이블에 9000번 사번을 갖고 있는 사원 있으면 이름을 업데이트하고 사원이 없으면 신규로 입력

merge 구문을 사용하지 않고 위 시나리오 대로 개발을 하려면 적어도 2개의 sql 을 실행 해야함
1. SELECT 'X'
    FROM emp_test
    WHERE empno= 9000;
    
2. 1번에서 조회된 데이터가 없을 경우
    INSERT INTO emp_test VALUES (9000, 'brown');
    2번에서 조회된 데이터가 있을 경우
    UPDATE emp_test SET ename = 'brown'
    WHERE empno = 9000;
    
merge 구문을 이용하게 되면 한번의 SQL 로 실행 가능

 INSERT INTO 변경/신규입력할 테이블 
 USING 테이블 | 뷰 | 인라인뷰
 ON (INTO 절과 USING 절에 기술한 테이블의 연결 조건)
 
WHEN MATCHED THEN
    UPDATE SET 컬럼 = 값, ...
    
WHEN NOT MATCHED THEN
    INSERT [(컬럼1, 컬럼2, ...)] VALUES (값1, 값2,...);
    
--------9000, 'brown'--------------------
MERGE INTO emp_test
    USING (SELECT 9000 eno, 'moon' enm
                FROM dual) a
        ON (emp_test.empno = a.eno)
        
WHEN MATCHED THEN
    UPDATE SET ename = a.enm
WHEN NOT MATCHED THEN
    INSERT VALUES (a.eno, a.enm);
    
ROLLBACK;    
    
SELECT*
FROM emp_test;

INSERT INTO emp_test
SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7499);
    
COMMIT;    
    
SELECT*
FROM emp_test;
    
emp 테이블 이용하여 emp 테이블 존재하고 emp_test에는 없는 사원에 대해서는 
emp_test 테이블에 신규로 입력

emp, emp_test 양쪽에 존재하는 사원은 이름을 이름 || '_M'

MERGE INTO emp_test
USING emp
ON (emp.empno = emp_test.empno)

WHEN MATCHED THEN
    UPDATE SET ename = ename || '_M'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);



매칭 2건에 대하여 매칭 안되는게 12건
 -> MERGE 실행시 UPDATE 2건에, INSERT 12건
SELECT*
FROM emp_test, emp
WHERE emp.empno = emp_test.empno;
    
DELETE emp
WHERE empno > 7999 OR empno < 7000;
    
    
------17 page  -----------------
SELECT deptno, SUM(sal) 
FROM emp
GROUP BY deptno
UNION ALL
SELECT NULL, SUM(sal)
FROM emp;

위의 쿼리를 레포트 그룹 함수를 적용하면
SELECT deptno, SUM(sal)
FROm emp
GROUP BY ROLLUP(deptno);


GROUP BY ROLLUP(deptno)
UNION ALL
GROUP BY deptno
GROUP BY ==> 전체

GROUP BY ROLLUP(deptno, job)
GROUP BY deptno, job
UNION ALL
GROUP BY deptno
UNION ALL
GROUP BY ==> 전체

ROLLUP : GROUP BY 를 확장한 구문
            서브 그룹을 자동적으로 생성
            GROUP BY ROLLUP(컬럼1, 컬럼2,...)
            *** ROLLUP 절에 기술한 컬럼을 오른쪽에서 부터 하나씩 제거해 가며
                            서브 그룹을 생성한다.
                            
SELECT job, deptno, SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY ROLLUP (job, deptno);

SELECT job, deptno,  SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job, deptno UNION ALL

SELECT job, NULL,  SUM(sal + NVL(comm, 0)) sal
FROM emp
GROUP BY job  UNION ALL





GROUPING(col) 함수 : rollup, cube절을 사용한 SQL에서만 사용이 가능한 함수
                            인자 col은 GROUP BY절에 기술된 컬럼만 사용 가능
                            1, 0 을 반환
                            1 : 해당 컬럼이 소계 계산에 사용 된 경우
                            0 : 해당 컬럼이 소계 계산에 사용 되지 않은 경우
                             
SELECT job, deptno,
        GROUPING(job), GROUPING(deptno),
        SUM(sal + NVL(comm, 0))sal
        FROM emp
        GROUP BY ROLLUP(job, deptno);


  ------------------------------------------------------                           
SELECT job, deptno,
        GROUPING(job), GROUPING(deptno),
        SUM(sal + NVL(comm, 0))sal
        FROM emp
        GROUP BY ROLLUP(job'총계', deptno)
        UNION ALL
        SELECT SUM(sal + NVL(comm, 0)) sal
        FROM emp
        
 내가 작성한 쿼리문
 ------------------------------------------------------------------
 
 
 
 
 
SELECT NVL(job, '총계') job, deptno,
        WHEN GROUPING(job) = 1 THEN '총계'
        else job
        END job, deptno,
        GROUPING(job), GROUPING(deptno),
        SUM(sal +NVL(comm, 0)) sal 
        FROM emp
        GROUP BY ROLLUP (job, deptno);
        
    null값이 아닌 GROUPING  함수를 통해 레이블을 달아준 이유
    NULL값이 실제 데이터의 NULL인제 GROUP BY에 의해 NULL이 표현 된것인지는 
    GROUPING 함수를 통해서만 알 수 있다.
    
SELECT job, mgr, GROUPING(job), GROUPING(mgr), SUM(sal)
FROM emp
GROUP BY ROLLUP(job, mgr);



 ------------------------ 27 page ----------------------
SELECT 
CASE
         WHEN GROUPING(deptno) = 1 THEN '(null)'
         ELSE TO_CHAR(deptno)
        END deptno,
CASE
        WHEN GROUPING(job) = 1 THEN '(null)'
        else job
        END job,
        GROUPING(deptno), GROUPING(job),
        SUM(sal +NVL(comm, 0)) sal 
        FROM emp
        GROUP BY ROLLUP (deptno, job);
            
    
----------------------28 page ------------------------------
SELECT 
CASE
         WHEN GROUPING(dname) = 1 THEN 'ACOUNTING'
         ELSE dname
        END dname,
CASE
        WHEN GROUPING(job) = 1 THEN '(null)'
        else job
        END job,
        GROUPING(dname), GROUPING(job),
        SUM(sal +NVL(comm, 0)) sal 
        FROM emp
        GROUP BY ROLLUP (deptno, job);
            
SELECT dept.dname, emp.job,   SUM(sal +NVL(comm, 0)) sal  
FROM emp, dept
WHERE emp.deptno = dept.dname
GROUP BY ROLLUP (dname, job);













