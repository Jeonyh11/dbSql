많이 쓰이는 함수, 잘 알아두자
(개념 적으로 혼돈하지 말고 잘 정리하자 - SELECT 절에 올 수 있는 컬럼에 대해 잘 정리)


그룹 함수 : 여러개의 행을 입력으로 받아 하나의 행으로 결과를 반환하는 함수

오라클 제공 그룹함수
MIN(컬럼|익스프레션) : 그룹중에 최소값을 반환
MAX(컬럼|익스프레션) : 그룹중에 최대값을 반환
AVG(컬럼|익스프레션) : 그룹의 평균값을 반환
SUM(컬럼|익스프레션) : 그룹의 합계값을 반환
COUNT(컬럼|익스프레션|*) : 그룹핑된 행의 갯수

SELECT 행을 묶을 컬럼, 그룹함수
FROM 테이블명
[WHERE]
GROUP BY 행을 묶을 컬럼
[HAVING 그룹함수 체크조건];

그룹함수에서 많이 어려워 하는 부분
SELECT 절에 기술할 수 있는 컬럼의 구분 : GROUP BY 절에 나오지 않은 컬럼이 SELECT 절에 나오면 에러

SELECT deptno, MIN(ename),COUNT(*), MIN(sal), MAX(sal), SUM(sal), AVG(sal)
FROM emp
GROUP BY deptno;

SELECT pid, pnm, SUM(cycle.cnt)
FROM cycle
GROUP BY pid;

전체 직원(모든 행을 대상으로)중에 가장 많은 급여를 받는 사람의 값
 :전체 행을 대상으로 
 
 전체직원중에 가장 큰 급여 값을 알수 없지만 해당 급여를 받는 사람이 누군지는 그룹함수만 이용해서는 알수 없다.
 emp테이블 가장 큰 급여를 받는 사람의 길이 5000인 것은 알지만 해당사원이 누군지는 그룹함수만 사용해서는 식별할 수 없다.
 
SELECT MAX(sal) 
FROM emp;


COUNT 함수 * 인자
* : 행의 개수를 반환
컬럼 | 익스프레션 : null값이 아닌 행의 개수

SELECT COUNT (*), COUNT(mgr),COUNT(comm)
FROM emp;


그룹함수의 특징 : NULL값을 무시
NULL 연산의 특징 : 결과 항상 NULL이다


SELECT SUM(comm)
FROM emp;

SELECT SUM(sal + comm), SUM(sal) + SUM(comm)
FROM emp;

그룹함수 특징 2: 그룹화와 관련없는 상수들은 SELECT 절에 기술 할 수 없다.
SELECT deptno, SYSDATE,'TEST',1, COUNT(*)
FROM emp
GROUP BY deptno;


그룹함수 특징 3 :
    SINGLE ROW 함수의 경우 WHERE 에 기술하는 것이 가능하다.
    ex : SELECT*
        FROM emp
        WHERE ename = UPPER('smith');
        
    그룹함수의 경우 WHERE절에서 사용하는 것이 불가능 하다.
    =>HAVING 절에서 그룹함수에 대한 조건을 기술하여 행을 제한 할 수 있다.
    
    그룹함수는 WHERE절에 사용 불가
    SELECT deptno, COUNT(*)
    FROM emp
    WHERE COUNT(*) >= 5
    GROUP BY deptno;

그룹합수에 대한 행 제한은 HAVING 절에 기술

  SELECT deptno, COUNT(*)
    FROM emp
    GROUP BY deptno
   HAVING COUNT(*) >= 5;

GROUP BY 를 사용하면 WHERE 절을 사용 못하나?
GROUP BY에 대상이 되는 행들을 제한할때 WHERE 절 사용

SELECT deptno, COUNT(*)
FROM emp
WHERE sal > 1000
GROUP BY deptno;

-----------193page--------------------
SELECT  MAX(sal), MIN(sal),
        ROUND(AVG(sal),+2) AVG_SAL,
          SUM(sal) SUM_SAL,
          COUNT(sal)count_sal,
          COUNT(mgr)count_mgr,
          COUNT(*)count_all
          
FROM emp;

-----------194page--------------------
SELECT  deptno, MAX(sal), MIN(sal),
        ROUND(AVG(sal),+2) AVG_SAL,
          SUM(sal) SUM_SAL,
          COUNT(sal)count_sal,
          COUNT(mgr)count_mgr,
          COUNT(*)count_all
          
FROM emp
GROUP BY deptno;

**GROUP BY 절에 기술한 컬럼이 SELECT 절에 오지 않아도 실행에는 문제는 없다.


-----------195page----------------
SELECT 
DECODE (deptno, 10, 'ACCOUNTING',
                    20, 'RESEARCH',
                    30, 'SALES',
                    40, 'OPERATIONS')dname,

         MAX(sal), MIN(sal),
        ROUND(AVG(sal),+2) AVG_SAL,
          SUM(sal) SUM_SAL,
          COUNT(sal)count_sal,
          COUNT(mgr)count_mgr,
          COUNT(*)count_all
          
FROM emp
GROUP BY deptno;

SELECT 


         MAX(sal), MIN(sal),
        ROUND(AVG(sal),+2) AVG_SAL,
          SUM(sal) SUM_SAL,
          COUNT(sal)count_sal,
          COUNT(mgr)count_mgr,
          COUNT(*)count_all
          
FROM emp
GROUP BY DECODE (deptno, 10, 'ACCOUNTING', 20, 'RESEARCH', 30, 'SALES');

--------------196page------------------------
SELECT  TO_CHAR(hiredate, 'yyyymm') hire_yyyymm,  COUNT(*) cnt
FROM emp
GROUP BY  TO_CHAR(hiredate, 'yyyymm');

WHERE + JOIN SELECT SQL의 모든것
JOIN: 다른 테이블과 연결하여 데이터를 확장하는 문법
        . 컬럼을 확장
** 행을 확장 - 집합연산자(UNION, INTERSECT, MINUS)

JOIN 문법 구분
1. ANSI - SQL  : RDBMS에서 사용하는 SQL 표준 (표준을 잘 지킨 모든 RDBMS-MySQL, PostgreSQL..에서 실행가능)

2. ORACLE - SQL : ORACLE사만의 고유문법

NATURAL JOIN : 조인하고자 하는 테이블의 컬럼명이 같은 컬럼끼리 연결
                     컬럼의 값이 같은 행들끼리 연결
    ANSI-SQL
    
    SELECT 컬럼
    FROM 테이블명 NATURAL JOIN 테이블명;
    
    조인 컬럼에 테이블 한정자를 붙이면 NATURAL JOIN 에서는 에러로 취급
    
    emp.deptno(x) ==> deptno (0)
    
    컬럼명이 한쪽 테이블에만 존재할 경우 테이블 한정자를 붙이지 않아도 상관 없다.
    emp.empno (0) , empno (0)
    SELECT emp.empno, deptno, dname
    FROM emp NATURAL JOIN dept;
    
    NATURAL JOIN을 ORACLE 문법으로
    1. FROM 절에 조인할 테이블을 나열한다(,)
    2. WHERE 절에 테이블 조인 조건을 기술한다.
    
    SELECT *
    FROM emp, dept
    WHERE emp.deptno = dept.deptno;

ORA-00918: column ambiguously defined 
컬럼이 여러개의 테이블에 동시에 존재하는 상황에서 테이블 한정자를 붙이지 않아서 오라클 입장에서 해당 컬럼이 어떤 테이블의 컬럼이 
알 수 가 없을때 발생


ANSI -SQL : JOIN WITH USING
    조인 하려는 테이블간 같은 이름의 컬럼이 2개 이상일 때 하나의 컬럼으로만 조인을 하고 싶을때 사용
    
    
    SELECT *
    FROM emp JOIN dept ON (emp.deptno = dept.deptno );

 ORACLE--------------------------------
    SELECT *
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    AND emp.deptno IN (20,30);
    
    
    논리적인 형태에 따른 조인 구분
    1. SELF JOIN : 조인하는 테이블 서로 같은 경우
    
    SELECT e.empno, e.ename, e.mgr, m.ename
    FROM emp e JOIN emp m ON ( e.mgr = m.empno ) ;

ORACLE

  SELECT e.empno, e.ename, e.mgr, m.ename
    FROM emp e, emp m
    WHERE  e.mgr = m.empno ;
    
    
    KING의 경우 mgr 컬럼의 값이 NULL이기 때문에 e.mgr = m.empno 조건을 충족 시키지 못함
    그래서 조인을 실패해 14건 중 13건 데이터만 조회

2. NON EQUI JOIN : 조인 조건이 = 아닌 조인

SELECT*
FROM emp, dept
WHERE emp.empno = 7369
AND emp.deptno != dept.deptno;


SELECT *
FROM salgrade;


--sal를 이용하여 등급을 구하기, empno, ename, sal, 등급(grade)
SELECT e.empno, e.ename, e.sal, s.grade
FROM emp s, salgrade g
WHERE emp.sal >= salgrade.losal
AND emp.sal <= salgrade.hisal;

SELECT empno, ename, sal, grade
FROM emp s, salgrade g
WHERE sal BETWEEN losal AND hisal;

-------ANSI VERSION ---------------
SELECT empno, ename, sal, grade
FROM emp JOIN salgrade ON ( sal BETWEEN losal AND hisal);

-------grp5------------
SELECT TO_CHAR(hiredate,'yyyy') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY  TO_CHAR(hiredate,'yyyy');

------grp6--------------
SELECT  COUNT(*) cnt
FROM dept;

-----grp7---------------
SELECT  COUNT(COUNT(*)) cnt
FROM emp
GROUP BY deptno;


--------join0-----------

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
ORDER BY emp.deptno ASC ;


-------join0_1------------

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE emp.deptno LIKE 10 OR emp.deptno LIKE 30;

------------join0_2-----------------
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE sal >=2500
ORDER BY emp.deptno ASC ;

----------join0_3-----------------
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE   sal >=2500 AND empno > 7600
ORDER BY emp.deptno ASC ;

----------join0_4-----------------
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname
FROM emp JOIN dept ON ( emp.deptno = dept.deptno)
WHERE   sal >2500 AND empno > 7600 AND dname IN ('RESEARCH')
ORDER BY emp.empno DESC;


