날짜 관련된 함수

TO_CHAR 날짜 ==> 문자
TO_DATE 문자 ==> 날짜

NULL 관련 함수 - NULL과 관련된 연산의 결과는 NULL
총 4가지 존재
1. NVL(expr1, expr2)
    if(expr1 == null)
    System.out.println(exp2);
    else
    System.out.println(exp1);
    
2. NVL2(expr1,expr2,expr3)
    if(expr1 != null)
        System.out.println(expr2);
        else
        System.out.println(expr3);
        
3. NULLIF(expr1, expr2)
    if(expr1 == expr2)
        System.out.println(NULL);
        else
        System.out.println(expr1);

4. coalesce(expr1, expr2, expr3 ....)
    if(expr1!=NULL)
    System.out.println(expr1)
    else
    coalesce(expr2, expr3...)
    
coalesce(null,null,5,4)
         
 
SELECT empno, ename, sal, comm,
    sal + NVL(comm, 0) nvl_sum,    -- comm 컬럼이 NULL일떄 0으로 변경하여 sal 컬럼과 합계를 구한다 
   sal + NVL2(comm,comm,0) nvl2_sum,
   NVL2(comm, sal+comm, sal) nvl2_sum2,
   NULLIF(sal, sal) nullif,
   NULLIF(sal, 5000) nullif_sal,
   sal + COALESCE(comm,0) coalesce_sum,
   COALESCE(sal + comm, sal) coalesce_sum2
FROM emp;

------171page-----------
SELECT empno, ename, mgr,
     NVL(mgr,9999)mgr_n,
     NVL2(mgr,mgr,9999)mgr_n_1,
     COALESCE(mgr,9999)mgr_n_2
FROM emp;

SELECT userid,usernm,reg_dt,
        NVL(reg_dt,SYSDATE)n_reg_dt
FROM users
--WHERE userid != 'brown'
WHERE userid IN ( 'cony', 'sally', 'james', 'moon' );


java 조건 체크 : if, switch


SQL : CASE 절
CASE 
    WHEN 조건 THEN 반환할 문장
    WHEN 조건2 THEN 반환할 문장
END

emp 테이블에서 job 컬럼의 값이 'SALESMAN'이면 sal값에 5%를 인상한 급여를 반환 sal * 1.05
                            'MANAGER'이면 sal값에 10%를 인상한 급여를 반환 sal * 1.10
                            'PRESIDENT'이면 sal값에 20%를 인상한 급여를 반환 sal * 1.20
                            그 밖의 직군('CLERK','ANALYST')은 sal 값 그대로 반환
                            
SELECT ename, job, sal,     --    CASE절을 이용 새롭게 계산한 sal_b 
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
    END sal_b,
    DECODE(job,
                'SALESMAN', sal * 1.05,
                'MANAGER', sal * 1.10,
                'PRESIDENT', sal * 1.20,
                sal) sal_decode
FROM emp;

CASE, DECODE 둘다 조건 비교시 사용
차이점 : DECODE의 경우 값비교가 = (EQUAL)에 대해서만 가능, 복수 조건은 DECODE를 중첩하여 표현
        CASE는 부등호 사용가능, 복수개의 조건 사용가능
        (CASE
            WHEN sal > 3000 AND job = 'MANAGER'



가변인자 :
DECODE(col| expr1,            
                search1, return1,   -- 첫번째 컬럼이 두번째 컬럼 (search1)과 같으면 세번째 컬럼 (return1)을 리턴
                search2, return2,   -- 첫번째 컬럼이 네번째 컬럼 (search1)과 같으면 다섯번째 컬럼 (return1)을 리턴
                search3, return3,   -- 첫번째 컬럼이 여섯번째 컬럼 (search1)과 같으면 일곱번째 컬럼 (return1)을 리턴
                [default])          -- 일치 하는게 없으면 default 값 리턴
                
                
SELECT empno, ename,
  CASE
        WHEN deptno = 10 THEN 'ACCOUNTING'
        WHEN deptno = 20 THEN 'RESEARCH'
        WHEN deptno = 30 THEN 'SALES'
        WHEN deptno = 40 THEN 'OPERATIONS'
        ELSE 'ddit'
    END dname,
    DECODE(deptno, 10, 'ACCOUNTING',
                    20, 'RESEARCH',
                    30, 'SALES',
                    40, 'OPERATIONS')danme2
FROM emp;
                
            -------- 건강검진 대상 여부 : 출생년도 짝수 구분과 건강검진 실시년도(올해)의 짝수 구분이 같을때
            ex) 1983년생은 홀수년도 출생이므로 2020년도 건강검진 비대상
                 1982년생은 짝수년도 출생이므로 2020년도 건강검진 대상
                 
    어떤 양의 정수 x가 짝수인지 홀수인지 구별법?
    짝수는 2로 나눴을때 나머지가 0
    홀수는 2로 나눴을때 나머지가 1
    나머지는 나누는 수보다 항상 작다
    나머지는 항상 0,1
나머지 연산 : java %, SQL mod 함수
    
SELECT empno,ename,hiredate,
        CASE
        WHEN MOD(TO_CHAR(hiredate, 'yyyy'),2) = MOD(TO_CHAR(SYSDATE, 'yyyy'),2) 
        THEN '건강검진 대상자'
        ELSE '건강검진 비대상'
        END contact_to_doctor
FROM emp;


SELECT userid,usernm,reg_dt,
        CASE
        WHEN MOD(TO_CHAR(REG_DT, 'yyyy'),2) = MOD(TO_CHAR(SYSDATE, 'yyyy'),2) 
        THEN '건강검진 대상자'
        ELSE '건강검진 비대상'
        END contact_to_doctor,
        DECODE(
        MOD(TO_CHAR(REG_DT, 'yyyy'),2),
         MOD(TO_CHAR(SYSDATE, 'yyyy'),2),
         '건강검진 대상자',
         '건강검진 비대상') contact_to_doctor2
        )
FROM users;





