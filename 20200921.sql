PRIMARY KEY : PK_테이블명
FOREIGN KEY : FK_소스테이블명_참조테이블명

제약조건 삭제
ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
1. 부서 테이블에 PRIMARY KEY 제약조건 추가
2. 사원 테이블에 PRIMARY KEY 제약조건 추가
3. 사원 테이블- 부서테이블간 FOREIGN KEY 제약조건 추가

제약조건 삭제시는 데이터 입력과 반대로 자식부터 먼저 삭제
3 - (1, 2)

ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE emp_test DROP CONSTRAINT FK_emp_test_dept_test;
ALTER TABLE emp_test DROP CONSTRAINT PK_emp_test;
ALTER TABLE dept_test DROP CONSTRAINT PK_dept_test;

SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');


1. dept_test 테이블의 deptno컬럼에 PRIMARY KEY 제약 조건 추가
ALTER TABLE dept_test ADD CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno);
2. emp_test 테이블의 empno컬럼에 PRIMARY KEY 제약 조건 추가
 ALTER TABLE emp_test ADD CONSTRAINT PK_EMP_TEST PRIMARY KEY (empno);
3. emp_test 테이블의 deptno 컬럼이 dept_test 컬럼의 deptno컬럼을  참조하는 FOREIGN KEY 제약 조건 추가
  ALTER TABLE emp_test ADD CONSTRAINT FK_EMP_TEST_DETP_TEST FOREIGN KEY (deptno) REFERENCES DEPT_TEST (deptno);  
    
    
 제약조건 활성화 - 비활성화 테스트
 테스트 데이터 준비 : 부모 - 자식 관계가 있는 테이블에서는 부모 테이블에 데이터를 먼저 입력
 dept_test ==> emp_test
 
 INSERT INTO dept_test VALUES (10, 'ddit');
 
INSERT INTO emp_test VALUES (99, 'brown', 10);
  
  20번 부서는 dept_test 테이블에 존재하지 않는 데이터이기 때문에 FK에 의해 입력 불가
INSERT INTO emp_test VALUES (98, 'sally', 20);
COMMIT;
 

 FK를 비활성화 한후 다시 입력
 ALTER TABLE emp_test DISABLE CONSTRAINT fk_emp_test_dept_test;
 
 FK 제약조건 재 활성화
  ALTER TABLE emp_test ENABLE CONSTRAINT fk_emp_test_dept_test;
  
 SELECT *
FROM user_constraints
WHERE table_name IN ('EMP_TEST', 'DEPT_TEST');


테이블, 컬럼 주석(comments) 생성가능
테이블 주석 정보 확인
SELECT*
FROM user_tab_comments;               --오라클 주석
 
 테이블 주석 작성 방법
 COMMENT ON TABLE 테이블명 IS '주석';

EMP 테이블에 주석(사원) 생성하기
COMMENT ON TABLE emp IS '사원';

컬럼 주석 확인
SELECT*
FROM user_col_comments
WHERE TABLE_NAME = 'EMP';

컬럼 주석 다는 문법
COMMENT ON COLUMN 테이블명.컬럼명 IS '주석';

 DESC emp_test;
 
  SELECT *
 FROM emp_test;
 
 SELECT*
 FROM dept_test;
 
COMMENT ON COLUMN emp.EMPNO IS '사번';
COMMENT ON COLUMN emp.ENAME IS '사원이름';
COMMENT ON COLUMN emp.JOB IS '직업';
COMMENT ON COLUMN emp.MGR IS '매니저 사번';
COMMENT ON COLUMN emp.HIREDATE IS '고용일';
COMMENT ON COLUMN emp.COMM IS '성과급';
COMMENT ON COLUMN emp.SAL IS '급여';
COMMENT ON COLUMN emp.DEPTNO IS '부서번호';

----------DDL 실습 comment1 ----------------- ***********************************************************
SELECT t.*, c.column_name, c.comments
FROM user_tab_comments t, user_col_comments c
WHERE t.table_name = c.table_name
AND t.table_name IN ('CYCLE', 'CUSTOMER', 'PRODUCT', 'DAILY');

SELECT *
FROM user_CONSTRAINTS
WHERE table_name IN('EMP', 'DEPT');

 
 ALTER TABLE EMP ADD CONSTRAINT PK_DEPT PRIMARY KEY (empno);  -- 0
 
 ALTER TABLE DEPT ADD CONSTRAINT PK_EMP PRIMARY KEY (deptno);  --0
 
ALTER TABLE EMP ADD CONSTRAINT FK_EMP_DEPT FOREIGN KEY (deptno) REFERENCES DEPT(deptno); --0

 ALTER TABLE DEPT ADD CONSTRAINT FK_DEPT_EMP FOREIGN KEY (mgr) REFERENCES EMP(deptno); --x

VIEW : VIEW는 쿼리이다
        물리적인 데이터를 갖고 있지 않고 논리적인 데이터 정의 집합이다 
        VIEW가 사용하고 있는 테이블의 데이터가 바뀌면 VIEW 조회 결과도 같이 바뀐다.
문법
CREATE OR REPLACE VIEW 뷰이름 AS
SELECT 쿼리;

emp테이블에서 sal, comm 컬럼 두개를 제외한 나머지 6개 컬럼으로 v_emp 이름으로 VIEW 발생

CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

V_EMP 뷰를 HR계정에게 조회 할수 있도록 권한 부여
GRANT SELECT ON v_emp To HR;


GRANT CONNECT, RESOURCE TO 계정명;
VIEW에 대한 생성권한은 RESOURCE에 포함되지 않는다.










