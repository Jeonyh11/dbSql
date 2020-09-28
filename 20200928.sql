START WITH : 계층쿼리의 시작 점(행), 여러 개의 행을 조회하는 조건이 들어갈 수도 있다
           START WITH 절에 의해 선택된 행이 여러개이면, 순차적으로 진행한다
           
CONNECT BY : 행과 행을 연결할 조건을 기술

PRIOR : 현재 읽은 행을 지칭

PRIOR 키워드는 CONNECT BY 바로 다음에 나오지 않아도 된다
CONNECT BY PRIOR deptcd = p_deptcd;

create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;



----------------실습 h_2-------------------------------

SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY p_deptcd = PRIOR deptcd;


계층쿼리 - 상향식
디자인팀(dept0_00_0)부터 시작하여 자신의 상위 부서로 연결하는 쿼리

SELECT LEVEL lv, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd


create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;


SELECT*
FROM h_sum

SELECT LPAD('  ', (LEVEL -1)*3) | | s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id


pruning branch : 가지치기

SELECT 쿼리 처음 배울때, 설명해준 SQL 구문 실행 순서
FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY

SELECT 쿼리에 START WITH, CONNECT BY 절이 있는 경우
FROM -> START WITH, CONNECT BY -> WHERE ....

하향식 쿼리로 데이터 조회
SELECT *
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;
현재 읽은 행의 deptcd 값이 앞으로 읽을 행의 p_deptcd 컬럼과 같고
앞으로 읽을 행의 deptcd 컬럼 값이 'dept0_01'이 아닐때 연결 하겠다


행 제한 조건을 WHERE 절에 기술 했을 경우
FROM -> START WITH -> WHERE 절 순으로 실행 되기 때문에
1. 계층 탐색을 전부 완료한 후
2. WHERE 절에 해당하는 행만 데이터를 제외한다.

SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm
FROM dept_h
WHERE deptcd !=  'dept0_01'
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;


계층쿼리 특수함수 (오라클 사용자에게 중요한 함수)
CONNECT_BY_ROOT(col) : 최상위 행의 컬럼 값 조회
SYS_CONNECT_BY_PATH(col, 구분자) : 계층 순회 경로를 표현
CONNECT_BY_ISLEAF : 해당 행이 leaf node(자식이 없는 노드)인지 여부를 반환
                                (1 : leaf node, 0 : no leaf node)
                                
                                
SELECT deptcd, LPAD(' ', (LEVEL-1)*3)  | | deptnm,
        CONNECT_BY_ROOT(deptnm) cbr,
        LTRIM(SYS_CONNECT_BY_PATH(deptnm, '-'), '-') scbp,
        CONNECT_BY_ISLEAF CBI
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

CONNECT BY LEVEL 계층 쿼리 : CROSS JOIN 유사
연결 가능한 모든 행에 대해 계층으로 연결

SELECT dummy, LEVEL, LTRIM(SYS_CONNECT_BY_PATH(dummy, '-'), '-') scbp
FROM dual
CONNECT BY LEVEL <= 10;


create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

-- ORDER BY 절에 SIBLINGS 는 정렬하는데 보기 좋게 해준다
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY SEQ DESC;



SELECT *
FROM
(SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title, CONNECT_BY_ROOT(seq) gn
FROM board_test
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq);
OREDER BY gn DESC, seq aSC;




gn(NUMBER) 컬럼을 테이블에 추가
ALTER TABLE board_test ADD(gn NUMBER);


UPDATE board_test set gn = 2;
WHERE seq IN (2,3);

UPDATE board_test set gn = 2;
WHERE seq NOT IN (1,2,3,9);

COMMIT;


SELECT *
FROM board_test
SELECT seq, LPAD(' ', (LEVEL-1)*3) || title title, CONNECT_BY_ROOT(seq) gn
START WITH parent_seq is null
CONNECT BY PRIOR seq = parent_seq);


분석함수, WINDOW 함수
사원중에 가장 많은 급여를 받는 사람의 정보 조회(empno, ename, sal)
SELECT empno, ename, sal
FROM emp
WHERE sal = (SELECT MAX(sal)
                    FROM emp);

SQL의 단점 행간 연속이 부족 : 해당 부분을 보완 해주는 것이 분석함수 (윈도우 함수)

실습 ana01
SELECT ename, sal, deptno, RANK() OVER (PARTITION BY deptno ORDER BY sal DESC)  sal_rank
FROM emp;

분석함수를 사용하지 않고도 위와 동일한 결과를 만들어 내는 것이 가능
(*** 분석함수 모드 DBMS에서 제공을 하지는 않음)

(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) a


(SELECT LEVEL lv
FROM dual
CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp)) b;

SELECT *
FROM 
(SELECT ename, sal, deptno, ROWNUM rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) ) a,

(SELECT deptno, lv, ROWNUM rn
FROM 
    (SELECT a.deptno, b.lv
    FROM 
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) a, 
    (SELECT LEVEL lv
     FROM dual
     CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp) ) b
    WHERE a.cnt >= b.lv
    ORDER BY a.deptno, b.lv )) b
WHERE a.rn = b.rn;

분석함수 / 윈도우 함수 문법
SELECT 윈도우 함수 이름 ([인자]) OVER   -- over는 분석 설정
                ([Partition by columns] [ORDER BY columns] [WINDOWING]) 
PARTITION BY : 영역 설정
ORDER BY : 영역내에서 순서 설정 (RANK, ROW_NUMBER)
WINDWING : 파티션 내에서 범위 설정

순위관련 분석함수 - 동일 값에 대한 순위처리에 따라 3가지 함수를 제공
RANK : 동일 값에 대해 동일 순위 부여
            후순위 : 1등이 2명이면 그 다음 순위가 3위가 된다. (1 1 3)
DENSE_RANK : 동일값에 대해 동일 순위 부여
                        후순위 : 1등이 2명이면 그 다음순위가 2위 (1 1 2)
ROW_NUMBER : 동일값이라도 다른 순위를 부여 (1 2 3)

사원의 부서별 급여 순위 구하기
emp 테이블 사용

SELECT ename,sal,deptno,
        RANK()over (PARTITION BY deptno ORDER BY sal DESC) sal_rank,
        DENSE_RANK() over (PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
        ROW_NUMBER()over (PARTITION BY deptno ORDER BY sal DESC) sal_row_number
        FROM emp;

사원의 전체 급여순위를 구하시오
급여가 동일할 경우 사번이 빠른 사람이 높은순위가 되도록 작성

SELECT empno, ename, sal, deptno,
        RANK()over ( ORDER BY sal DESC) sal_rank,
        DENSE_RANK() over (ORDER BY sal DESC) sal_dense_rank,
        ROW_NUMBER()over ( ORDER BY sal DESC) sal_row_number
        FROM emp;

분석함수 - 집계함수
SUM(col), MIN(col), MAX(col), COUNT(col | *), AVG(col)
사원번호, 사원이름, 소속부서번호, 소속된 부서의 사원수

SELECT empno, ename, deptno, COUNT(*) OVER (PARTITION BY deptno)
FROM emp;

---------------------실습 ana2 -------------------------------
SELECT empno, ename, sal, deptno, 
        ROUND(AVG(sal) over(PARTITION BY deptno),2)avg_sal
FROM emp;


분석함수를 사용하지 않고 만들기

SELECT empno, ename, sal, emp.deptno, a.avg_sal
FROM emp,
(SELECT deptno, ROUND(AVG(sal),2)avg_sal
FROM emp
GROUP BY deptno) a
WHERE emp.deptno = a.deptno;

