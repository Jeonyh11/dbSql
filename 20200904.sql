별칭 기술 : 텍스트, "텍스트" 
SELECT empno "ename"
FROM emp;

WHERE 절 : 스프레드 시트
        - filter : 전체 데이터 중에서 낵 ㅏ원하는 행만 나오도록 제한
    
비교 연산 <,>,=,!=, <=, >=
        BETWEEN AND
        IN
연산자를 배울 때 (복습할 때) 기억할 부분은 해당 연산자 x항 연산자 인지하자

1          +           5
피연산자  연산자      피연산자

a++ : 단항 연산자

int a = b > 5 ? 10 : 20;

BETWEEN AND : 비교대상 BETWEEN 시작값 AND 종료값
IN : 비교대상 IN (값1, 값2...)
LIKE : 비교대상 LIKE '매칭문자열 %_'

SELECT *
FROM emp
WHERE 10 BETWEEN 10 AND 50;




NULL 비교

NULL 값은 =, != 등의 비교연산으로 비교가 불가능
EX : emp 테이블에는 comm 컬럼의 값이 NULL인 데이터가 존재
comm 이 null 인 데이터를 조회 하기 위해 다음과같이 실행할 경우 정상적으로 동작하지 않음
SELECT *
FROM emp
WHERE comm = NULL;
//아무 값이 안뜬다

SELECT *
FROM emp
WHERE comm IS NULL;

// 비교데이터인 IS 를 사용해야 한다.

comm 컬럼의 값이 NULL이 아닐때
=, != <>(부정연산자)

SELECT *
FROM emp
WHERE comm IS NOT NULL;

IN <==> NOT IN
사원중 소속 부서가 10번이 아닌 사원 조회
SELECT*
FROM emp
WHERE deptno NOT IN (10)

// 사원중에 자신의 상급자가 존재하지 않는 사원들만 조회(모든 컬럼)
SELECT *
FROM emp
WHERE mgr IS NULL;

논리 연산 : AND, OR, NOT
AND, OR  : 조건을 결합
    AND :  조건1 AND 조건2 : 조건 1과,조건2를 동시에 만족하는 행만 조회가 되도록 제한
    OR  : 조건1 OR 조건2 : 조건1 혹은 조건2를 만족하는 행만 조회 되도록 제한
    
조건1   조건2      조건1AND 조건2       조건1OR조건2
T        T            T                   T
T        F            F                   T
F        T            F                   T
F        F            F                   F


WHERE 절에 AND 조건을 사용하게 되면 : 보통 행이 줄어든다
WHERE 절에 OR 조건을 사용하게 되면 : 보통 행이 늘어난다

NOT : 부정 연산
다른 연산자와 함께 사용되며 부정형 표현으로 사용됨
NOT IN (값1, 값2...)
IS NOT NULL
NOT EXISTS (존재하지 않는다)


mgr가 7698사번을 가지면서 급여가 1000보다 큰 사원들 조회
SELECT *
FROM emp
WHERE mgr = 7698
    AND sal >= 1000; 
    
mgr가 사원번호 7698이거나 급여가 1000보다 큰 사원들 조회
SELECT *
FROM emp
WHERE mgr = 7698
    OR sal >= 1000; 
    
emp테이블의 사원중에 mgr가 7698이 아니고, 7839가 아닌 사원
SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839);

SELECT *
FROM emp
WHERE mgr != 7698
    AND mgr != 7839;
    
IN 연산자는 OR 연산자로 대체가 가능      시험 *****************************************
SELECT *
FROM emp
WHERE mgr  IN (7698,7839);       ==> mgr = 7698 OR mgr = 7839

WHERE mgr  NOT IN (7698,7839);       ==> mgr != 7698 AND mgr != 7839

IN 연산자 사용시 NULL 데이터 유의점
요구사항 : mgr가 7698, 7839, NULL 인 사원만 조회

SELECT *
FROM emp
WHERE mgr  IN (7698,7839,NULL);
 OR mgr IS NULL
 
 SELECT *
FROM emp
WHERE mgr  IN (7698,7839)
 OR mgr IS NULL;
 
 
SELECT *
FROM emp
WHERE mgr  != 7698
    AND mgr != 7839;
    
 emp 테이블 job이 salesman이고 hiredate 1981/06/01 이후인 데이터 조회
 (데이터는 대소문자를 가린다.) (데이터 타입 표현) (AND 논리 연산자)
 SELECT *
 FROM emp
 WHERE job IN ('SALESMAN')
    AND hiredate >=  TO_DATE('1981/06/01','yyyy/mm/dd');
    
emp 테이블에서 부서번호 10번 아니고 hiredate 1981/06/01  이후 직원 정보 조회 (NOT IN , IN 금지)

SELECT*
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('1981/06/01','yyyy/mm/dd');   
    
SELECT*
FROM emp
WHERE deptno IN (20, 30)  AND hiredate >= TO_DATE('1981/06/01','yyyy/mm/dd');   

// WHERE 11
SELECT*
FROM emp
WHERE job = ('SALESMAN') OR hiredate >= TO_DATE('1981/06/01','yyyy/mm/dd');

// WHERE 12
SELECT*
FROM emp
WHERE job = ('SALESMAN') OR empno LIKE '78%';

// WHERE 13
SELECT*
FROM emp
WHERE job = ('SALESMAN') OR empno BETWEEN 7800 AND 7899 
                OR empno = 78 
                OR empno BETWEEN 780 AND 789;

// WHERE 14
SELECT*
FROM emp
WHERE job = ('SALESMAN') OR empno  LIKE '78%';


정렬 **************매우 중요***************
RDBMS는 집합에서 많은 부분을 차용
집합의 특징 : 1. 순서가 없다
            2. 중복을 허용하지 않는다
    {1,5,10} == {5,1,10} 집합에는 순서는 없다
    {1,5,5,10} ==> {5,1,10} 집합은 중복을 허용하지 않는다
아래 sql의 실행결과, 데이터의 조회 순서는 보장되지 않는다
지음은 7369, 7499....조회가 되지만 내일 동일한 sql을 실행 하더라도 오늘 순서가 보장되지 앟는다(바뀔수 있음)

* 데이터는 보편적으로 데이터를 입력한 순서대로 나온다(보장없음)
**테이블에는 순서가 없다.

SELECT*
FROM emp;

시스템을 만들다 보면 데이터의 정렬이 중요한 경우가 많다
게시판 글 리스트 : 가장 최신글이 가장위로 와야한다.

** 즉 SELECT 결과 행의 순서를 조정할 수 있어야한다.
==> ORDER BY 구문

문법
SELECT*
FROM 테이블명
[WHERE]
[ORDER BY 컬럼1, 컬럼2]

SELECT*
FROM emp
ORDER BY job, empno;

오름차순 ASC : 값이 작은 데이터부터 큰 데이터 순으로 나열
내림차순,DESC : 반대

ORACLE에서는 기본적으로 오름차순이 기본 값으로 적용됨
내림차순으로 정렬을 원할경우 정렬 기준 컬럼 뒤에 DESC를 붙여준다

job컬럼으로 오름차순 정렬하고 같은 job을 갖는 행끼리 empno로 내림차순 정렬한다.
SELECT*
FROM emp
ORDER BY job, empno DESC;

참고
1. ORDER BY절에 별칭 사용 가능
SELECT empno eno, ename enm
FROM emp
ORDER BY enm;

2. ORDER BY 절에 SELECT 절의 컬럼 순서번호를 기술 하여 정렬 가능

SELECT empno, ename
FROM emp
ORDER BY 2; ==> ORDER BY ename

3. expression도 가능
SELECT empno, ename, sal + 500
FROM emp
ORDER BY sal + 500;

SELECT *
FROM dept
ORDER BY dname ;

SELECT*
FROM dept
ORDER BY loc DESC;

// oderby2 comm이 존재하는 사원만 조회, 단 상여가 0인 사람은 상여가 없는 것으로 간주
SELECT*
FROM emp
WHERE comm IS NOT NULL
AND comm != 0;
ORDER BY comm DESC, empno DESC;

SELECT*
FROM emp
WHERE mgr != 0
ORDER BY job ASC ,empno DESC;

order 3    
SELECT *
FROM emp
WHERE mgr != 0
ORDER BY job ASC, empno DESC;

order 4
SELECT *
FROM emp
WHERE deptno IN (10,30) AND sal > 1500
ORDER BY ename DESC;

************실무에서 매우 많이 사용*********************
ROWNUM : 행의 번호를 부여해주는 가상 컬럼
        ** 조회된 순서대로 번호를 부여
        
        1. WHERE 절에 사용하는 것이 가능
        * WHERE ROWNUM = 1 (동등 비교 연산으 ㅣ경우 1만 가능)
        WHERE ROWNUM <= 15 사용가능
        WHERE ROWNUM BETWEEN 1 AND 15 사용 가능 
        
        
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM =1;

SELECT ROWNUM, empno, ename
FROM emp;
WHERE 글번호 BETWEEN 46 AND 60;

2. ORDER BY 절은 SELECT 이후에 실행된다
 ** SELECT 절에 ROWNUM을 사용하고 ORDER BY 절을 적용하게 되면 원하는 결과를 얻지 못한다
 
 SELECT ROWNUM, empno, ename
 FROM emp
 ORDER BY ename;
 
 정렬을 먼저 하고, 정렬된 결과에 ROWNNUM을 적용
 ==> INLINE-VIEW
    SELECT 결과를 하나의 테이블 처럼 만들어 준다.
    
사원정보를 페이징 처리
1페이지 5명씩 조회
1페이지 : 1~5,  (page-1)pageSize + 1 ~ page * pageSize //페이지 구하는 공식
2페이지 : 6~10,
3페이지 : 11~15

page = 1, pageSize = 5

SELECT*
FROM( SELECT ROWNUM rn, a.*   
      FROM
      (SELECT empno, ename
       FROM emp
       ORDER BY ename)a)
WHERE rn BETWEEN (:page-1)* :pageSize + 1 AND :page * :pageSize;
     //a는 FROM에 묶여진 SELECT문에 a라는 임의의 테이블을 사용
     //SELECT 절에 *를 사용 했는데 ,를 통해 다른 특수 컬럼이나 EXPRESSION을 사용 할경우는
              *앞에 해당 데이터가 어떤 테이블에서 왔는지 명시를 해줘야 한다(한정자)
SELECT ROWNUM, emp.*
FROM emp;

별칭은 테이블에도 적용 가능, 단 컬럼이랑 다르게 AS 옵션은 없다

SELECT ROWNUM, e.*
FROM emp e;
